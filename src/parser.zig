const std = @import("std");
const llvm = @import("llvm.zig");
const token = @import("token.zig");
const allocator = @import("allocator.zig");

const FunctionData = struct {
    kind: *llvm.Type,

    val: *llvm.Value,
    args: []*TypeData,
    rets: ?*TypeData,
};

const ValueData = struct {
    kind: TypeData,
    value: *llvm.Value,
};

pub const StructEntry = struct {
    name: []const u8,
    kind: TypeData,
};

pub const TypeData = struct {
    aType: ?*llvm.Type,
    entrys: ?[]const StructEntry = null,
};

const StackEntryTag = enum {
    Value,
    Function,
    Type,
};

pub const StackEntry = union(StackEntryTag) {
    Value: *ValueData,
    Function: *FunctionData,
    Type: *TypeData,
};

const ValueStack = std.ArrayList(StackEntry);
const TokenList = std.ArrayList(token.Token);

pub var TheModule: *llvm.Module = undefined;
pub var TheContext: *llvm.Context = undefined;
pub var Builder: *llvm.Builder = undefined;
pub var TheFunction: ?*llvm.Value = null;

pub var named: std.StringHashMap(StackEntry) = undefined;

pub fn getType(name: []const u8) !*TypeData {
    var kind = named.get(name);
    if (kind) |result| {
        if (result == .Type) {
            return result.Type;
        }
        return error.UnknownType;
    }
    return error.UnknownType;
}

pub fn getNamed(name: []const u8) ?StackEntry {
    var kind = named.get(name);
    if (kind) |result| {
        return result;
    }
    return null;
}

pub fn getFunction(name: []const u8) ?*FunctionData {
    var kind = named.get(name);
    if (kind) |result| {
        if (result == .Function) {
            return result.Function;
        }
        return null;
    }
    return null;
}

pub const ExpressionAST = struct {
    const Self = @This();

    const VTable = struct {
        codegen: *const fn (*anyopaque, *ValueStack) anyerror!void,
    };

    vtable: *const VTable,
    ptr: *anyopaque,

    pub fn codegen(self: *Self, values: *ValueStack) !void {
        return self.vtable.codegen(self.ptr, values);
    }

    pub fn parse(toks: *TokenList) anyerror!*Self {
        var result = try allocator.alloc.create(ExpressionAST);

        switch (toks.items[0].type) {
            .Number => {
                var num = try allocator.alloc.create(NumberExprAST);
                num.* = try NumberExprAST.parse(toks);

                result.init(num);
                return result;
            },
            .Ident => {
                var num = try allocator.alloc.create(IdentExprAST);
                num.* = try IdentExprAST.parse(toks);

                result.init(num);
                return result;
            },
            .If => {
                var num = try allocator.alloc.create(IfExprAST);
                num.* = try IfExprAST.parse(toks);

                result.init(num);
                return result;
            },
            .Op => {
                switch (toks.items[0].value[0]) {
                    '.' => {
                        var prop = try allocator.alloc.create(PropExprAST);
                        prop.* = try PropExprAST.parse(toks);

                        result.init(prop);
                        return result;
                    },
                    '{' => {
                        var block = try allocator.alloc.create(BlockExprAST);
                        block.* = try BlockExprAST.parse(toks);

                        result.init(block);
                        return result;
                    },
                    '=', '-', '+', '@' => {
                        var block = try allocator.alloc.create(OpExprAST);
                        block.* = try OpExprAST.parse(toks);

                        result.init(block);
                        return result;
                    },
                    else => return error.InvalidToken,
                }
            },
            else => {
                std.log.err("{}", .{toks.items[0]});
                return error.InvalidToken;
            },
        }
    }

    pub fn init(selfObj: *Self, ptr: anytype) void {
        const Ptr = @TypeOf(ptr);
        const ptr_info = @typeInfo(Ptr);

        if (ptr_info != .Pointer) @compileError("ptr must be a pointer");
        if (ptr_info.Pointer.size != .One) @compileError("ptr must be a single item pointer");

        const alignment = ptr_info.Pointer.alignment;

        const gen = struct {
            fn codegenImpl(pointer: *anyopaque, values: *ValueStack) anyerror!void {
                const self = @ptrCast(Ptr, @alignCast(alignment, pointer));

                return @call(.auto, ptr_info.Pointer.child.codegen, .{ self, values });
            }

            const vtable = VTable{
                .codegen = codegenImpl,
            };
        };

        selfObj.ptr = ptr;
        selfObj.vtable = &gen.vtable;
    }
};

pub const NumberExprAST = struct {
    const Self = @This();

    value: i32,

    pub fn codegen(self: *Self, values: *ValueStack) !void {
        var value = try allocator.alloc.create(ValueData);
        var kind = TheContext.intType(32);

        value.kind.aType = kind;
        value.value = llvm.Type.constInt(kind, @intCast(c_ulonglong, self.value), .False);

        try values.append(.{ .Value = value });
    }

    pub fn parse(toks: *TokenList) !Self {
        var num = toks.orderedRemove(0);
        var value = try std.fmt.parseInt(i32, num.value, 10);

        return .{
            .value = value,
        };
    }
};

pub const PropExprAST = struct {
    const Self = @This();

    name: []const u8,

    pub fn codegen(self: *Self, values: *ValueStack) !void {
        var value = values.pop();
        for (value.Value.kind.entrys.?) |entry, idx| {
            if (std.mem.eql(u8, entry.name, self.name)) {
                var adds = try allocator.alloc.create(ValueData);
                adds.kind = entry.kind;
                adds.value = Builder.buildStructGEP(value.Value.kind.aType.?, value.Value.value, @intCast(c_uint, idx), "entry");

                try values.append(.{ .Value = adds });

                return;
            }
        }

        return error.PropNotFound;
    }

    pub fn parse(toks: *TokenList) !Self {
        _ = toks.orderedRemove(0);
        var name = toks.orderedRemove(0);

        return .{
            .name = name.value,
        };
    }
};

pub const IfExprAST = struct {
    const Self = @This();

    body: *ExpressionAST,

    pub fn codegen(self: *Self, values: *ValueStack) !void {
        var condV = values.pop().Value.value;

        condV = Builder.buildICmp(.NE, condV, llvm.Type.constInt(TheContext.intType(32), 0, .False), "ifcond");

        var headbb = TheContext.appendBasicBlock(TheFunction.?, "ifhead");
        var bodybb = TheContext.appendBasicBlock(TheFunction.?, "ifbody");
        var mergebb = TheContext.appendBasicBlock(TheFunction.?, "ifmerge");

        _ = Builder.buildBr(headbb);
        Builder.positionBuilderAtEnd(headbb);

        _ = Builder.buildCondBr(condV, bodybb, mergebb);
        Builder.positionBuilderAtEnd(bodybb);

        var oldValues = try allocator.alloc.alloc(StackEntry, values.items.len);
        defer allocator.alloc.free(oldValues);

        std.mem.copy(StackEntry, oldValues, values.items);

        var newValues = std.ArrayList(StackEntry).init(allocator.alloc);
        defer newValues.deinit();

        try newValues.appendSlice(values.items);

        try self.body.codegen(&newValues);

        if (newValues.items.len != oldValues.len) return error.SizeMismatch;

        _ = Builder.buildBr(mergebb);
        Builder.positionBuilderAtEnd(mergebb);

        values.clearAndFree();

        for (oldValues) |_, idx| {
            if (oldValues[idx].Value == newValues.items[idx].Value) {
                try values.append(oldValues[idx]);
                continue;
            }

            var name = try std.fmt.allocPrint(allocator.alloc, "__if_{}", .{idx});
            defer allocator.alloc.free(name);

            var Arg = Builder.buildPhi(oldValues[idx].Value.value.typeOf(), @ptrCast([*:0]const u8, name));
            var vals: [*]const *llvm.Value = &[_]*llvm.Value{ oldValues[idx].Value.value, newValues.items[idx].Value.value };
            var blocks: [*]const *llvm.BasicBlock = &[_]*llvm.BasicBlock{ headbb, bodybb };

            Arg.addIncoming(vals, blocks, 2);

            var adds = try allocator.alloc.create(ValueData);
            adds.kind = oldValues[idx].Value.kind;
            adds.value = Arg;

            try values.append(.{ .Value = adds });
        }
    }

    pub fn parse(toks: *TokenList) !Self {
        _ = toks.orderedRemove(0);

        var body = try ExpressionAST.parse(toks);

        return Self{
            .body = body,
        };
    }
};

pub const OpExprAST = struct {
    const Self = @This();

    op: u8,

    pub fn codegen(self: *Self, values: *ValueStack) !void {
        switch (self.op) {
            '=' => {
                var R = values.pop();
                var L = values.pop();

                _ = Builder.buildStore(R.Value.value, L.Value.value);
            },
            '@' => {
                var Val = values.pop();

                var adds = try allocator.alloc.create(ValueData);
                adds.kind = Val.Value.kind;
                adds.value = Builder.buildLoad(Val.Value.kind.aType.?, Val.Value.value, "readtmp");

                try values.append(.{ .Value = adds });
            },
            '-' => {
                var R = values.pop();
                var L = values.pop();

                var adds = try allocator.alloc.create(ValueData);
                adds.kind = R.Value.kind;
                adds.value = Builder.buildSub(L.Value.value, R.Value.value, "subtmp");

                try values.append(.{ .Value = adds });
            },
            '+' => {
                var R = values.pop();
                var L = values.pop();

                var adds = try allocator.alloc.create(ValueData);
                adds.kind = R.Value.kind;
                adds.value = Builder.buildAdd(L.Value.value, R.Value.value, "addtmp");

                try values.append(.{ .Value = adds });
            },
            else => return error.InvalidOp,
        }
    }

    pub fn parse(toks: *TokenList) !Self {
        var oper = toks.orderedRemove(0);
        var op = oper.value[0];

        return .{
            .op = op,
        };
    }
};

pub const IdentExprAST = struct {
    const Self = @This();

    value: []const u8,

    pub fn codegen(self: *Self, values: *ValueStack) !void {
        if (std.mem.eql(u8, self.value, "disc")) {
            _ = values.pop();
        } else if (std.mem.eql(u8, self.value, "copy")) {
            try values.append(values.getLast());
        } else if (std.mem.eql(u8, self.value, "swap")) {
            var A = values.pop();
            var B = values.pop();
            try values.append(A);
            try values.append(B);
        } else if (getFunction(self.value)) |func| {
            var params = try allocator.alloc.alloc(*llvm.Value, func.args.len);
            for (params) |*entry| {
                entry.* = values.pop().Value.value;
            }

            var adds = try allocator.alloc.create(ValueData);

            adds.value = Builder.buildCall(func.kind, func.val, @ptrCast([*]const *llvm.Value, params), @intCast(c_uint, func.args.len), "calltmp");

            if (func.rets.?.aType != null) {
                adds.kind = func.rets.?.*;
                try values.append(.{ .Value = adds });
            }
        } else if (getNamed(self.value)) |value| {
            try values.append(value);
        } else if (values.getLast() == .Type) {
            var kind = values.pop().Type;

            var alloca = Builder.buildAlloca(kind.aType.?, @ptrCast([*:0]const u8, self.value));

            var adds = try allocator.alloc.create(ValueData);
            adds.value = alloca;
            adds.kind = kind.*;

            try named.put(self.value, .{ .Value = adds });

            try values.append(.{ .Value = adds });
        } else {
            std.log.info("{s}", .{self.value});

            return error.Undefined;
        }
    }

    pub fn parse(toks: *TokenList) !Self {
        var ident = toks.orderedRemove(0);

        return .{
            .value = ident.value,
        };
    }
};

pub const BlockExprAST = struct {
    const Self = @This();

    body: []*ExpressionAST,

    pub fn codegen(self: *Self, values: *ValueStack) !void {
        for (self.body) |_, idx| {
            try self.body[idx].codegen(values);
        }
    }

    pub fn parse(toks: *TokenList) anyerror!Self {
        var result: Self = undefined;

        _ = toks.orderedRemove(0);

        result.body = try allocator.alloc.alloc(*ExpressionAST, 0);

        while (true) {
            if (toks.items[0].type == .Op and toks.items[0].value[0] == '}') break;
            var value = try ExpressionAST.parse(toks);
            result.body = try allocator.alloc.realloc(result.body, result.body.len + 1);

            result.body[result.body.len - 1] = value;
        }

        _ = toks.orderedRemove(0);

        return result;
    }
};

pub const PrototypeAST = struct {
    const Self = @This();

    name: []const u8,
    args: std.ArrayList([]const u8),
    result: []const u8,

    pub fn parse(toks: *TokenList) !Self {
        var result: PrototypeAST = undefined;

        result.args = std.ArrayList([]const u8).init(allocator.alloc);
        _ = toks.orderedRemove(0);

        var name = toks.orderedRemove(0);
        result.name = name.value;

        while (toks.items[0].type != .Op) {
            var tok = toks.orderedRemove(0);

            try result.args.append(tok.value);
        }

        if (toks.items[0].value[0] != ':') return error.InvalidTok;
        _ = toks.orderedRemove(0);

        var returns = toks.orderedRemove(0);

        result.result = returns.value;

        return result;
    }

    pub fn codegen(self: *Self) !*llvm.Value {
        var input = try allocator.alloc.alloc(*llvm.Type, self.args.items.len);

        for (self.args.items) |arg, idx| {
            var tmp = try getType(arg);
            if (tmp.aType) |val| {
                input[idx] = val;
            }
        }

        var kind = (try getType(self.result)).aType;
        var akind = kind;

        if (kind == null) {
            akind = TheContext.voidType();
        }

        var functionType = llvm.functionType(akind.?, @ptrCast([*]const *llvm.Type, input), @intCast(c_uint, input.len), .False);

        var function = llvm.Module.addFunction(TheModule, @ptrCast([*:0]const u8, self.name), functionType);

        var data = try allocator.alloc.create(FunctionData);
        data.val = function;
        data.args = try allocator.alloc.alloc(*TypeData, input.len);
        for (data.args) |_, idx| {
            data.args[idx] = try getType(self.args.items[idx]);
        }

        data.rets = try getType(self.result);
        data.kind = functionType;

        try named.put(self.name, .{ .Function = data });

        return function;
    }
};

pub const DefinitionAST = struct {
    const Self = @This();

    proto: PrototypeAST,
    body: *ExpressionAST,

    pub fn codegen(self: *Self) !*llvm.Value {
        var function = try self.proto.codegen();

        TheFunction = function;

        var bb = TheContext.appendBasicBlock(@ptrCast(*llvm.Value, function), "entry");
        Builder.positionBuilderAtEnd(bb);

        var values = ValueStack.init(allocator.alloc);

        for (self.proto.args.items) |_, idx| {
            var param = function.getParam(@intCast(c_uint, idx));
            var value = try allocator.alloc.create(ValueData);
            value.* = .{
                .kind = (try getType(self.proto.args.items[idx])).*,
                .value = param,
            };

            try values.append(.{
                .Value = value,
            });
        }

        try self.body.codegen(&values);

        if (values.items.len == 1) {
            if (values.items[0].Value.kind.aType != (try getType(self.proto.result)).aType) return error.ReturnMismatch;

            _ = Builder.buildRet(values.items[0].Value.value);

            return function;
        } else if (values.items.len == 0) {
            if ((try getType(self.proto.result)).aType != null) return error.ReturnMismatch;

            _ = Builder.buildRetVoid();

            return function;
        }

        std.log.info("{s}: {any}, {}", .{ self.proto.name, values.items, values.items.len });

        return error.Unknown;
    }

    pub fn parse(toks: *TokenList) !Self {
        var result: DefinitionAST = undefined;

        _ = toks.orderedRemove(0);

        result.proto = try PrototypeAST.parse(toks);

        result.body = try ExpressionAST.parse(toks);

        return result;
    }
};

pub const ExternAST = struct {
    const Self = @This();

    proto: PrototypeAST,

    pub fn codegen(self: *Self) !*llvm.Value {
        var function = try self.proto.codegen();

        return function;
    }

    pub fn parse(toks: *TokenList) !Self {
        var result: ExternAST = undefined;

        _ = toks.orderedRemove(0);

        result.proto = try PrototypeAST.parse(toks);

        return result;
    }
};

pub const StructAST = struct {
    const Self = @This();

    name: []const u8,
    props: []StructEntry,

    pub fn codegen(self: *Self) !void {
        var types = try allocator.alloc.alloc(*llvm.Type, self.props.len);
        for (self.props) |prop, idx| {
            types[idx] = prop.kind.aType.?;
        }

        var structType = TheContext.structType(@ptrCast([*]const *llvm.Type, types), @intCast(c_uint, types.len), .False);
        var adds = try allocator.alloc.create(TypeData);
        adds.entrys = self.props;
        adds.aType = structType;

        try named.put(self.name, .{ .Type = adds });
    }

    pub fn parse(toks: *TokenList) !Self {
        var result: StructAST = undefined;

        _ = toks.orderedRemove(0);

        result.name = toks.orderedRemove(0).value;
        result.props = try allocator.alloc.alloc(StructEntry, 0);

        _ = toks.orderedRemove(0);

        while (true) {
            if (toks.items[0].type == .Op and toks.items[0].value[0] == '}') break;
            var kind = try getType(toks.orderedRemove(0).value);
            var name = toks.orderedRemove(0).value;
            result.props = try allocator.alloc.realloc(result.props, result.props.len + 1);

            result.props[result.props.len - 1].name = name;
            result.props[result.props.len - 1].kind = kind.*;
        }

        _ = toks.orderedRemove(0);

        return result;
    }
};
