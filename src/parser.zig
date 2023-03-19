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

pub const ValueData = struct {
    kind: TypeData,
    value: *llvm.Value,
};

pub const StructEntry = struct {
    name: []const u8,
    kind: TypeData,
};

pub const TypeKind = enum {
    Pointer,
    Array,
    Struct,
};

pub const TypeSubData = union(TypeKind) {
    Pointer: *TypeData,
    Array: *TypeData,
    Struct: []StructEntry,
};

pub const TypeData = struct {
    aType: ?*llvm.Type,
    name: []const u8,

    data: ?TypeSubData = null,

    pub fn sameType(self: *TypeData, other: *TypeData) bool {
        if ((self.aType == null) != (other.aType == null)) return false;
        if ((self.data == null) != (other.data == null)) return false;
        if (self.aType == null or self.data == null) return std.mem.eql(u8, self.name, other.name);
        switch (self.data.?) {
            .Pointer => {
                if (other.data.? != .Pointer) return false;
                //if (!self.data.?.Pointer.sameType(other.data.?.Pointer)) return false;
            },
            .Array => {
                if (other.data.? != .Array) return false;
                if (!self.data.?.Array.sameType(other.data.?.Array)) return false;
            },
            .Struct => {
                if (other.data.? != .Struct) return false;
                for (self.data.?.Struct) |*a, idx| {
                    if (!a.kind.sameType(&other.data.?.Struct[idx].kind)) return false;
                }
            },
        }
        return std.mem.eql(u8, self.name, other.name);
    }
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
const StructData = std.ArrayList(StructEntry);
const TokenList = std.ArrayList(token.Token);

pub var TheModule: *llvm.Module = undefined;
pub var TheContext: *llvm.Context = undefined;
pub var Builder: *llvm.Builder = undefined;
pub var TheFunction: ?*FunctionData = null;

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
        typegen: *const fn (*anyopaque, *StructData) anyerror!void,
    };

    vtable: *const VTable,
    ptr: *anyopaque,

    pub fn codegen(self: *Self, values: *ValueStack) !void {
        return self.vtable.codegen(self.ptr, values);
    }

    pub fn typegen(self: *Self, values: *StructData) !void {
        return self.vtable.typegen(self.ptr, values);
    }

    pub fn parse(toks: *TokenList) anyerror!*Self {
        var result = try allocator.alloc.create(ExpressionAST);

        switch (toks.items[0].type) {
            .String => {
                var num = try allocator.alloc.create(StringExprAST);
                num.* = try StringExprAST.parse(toks);

                result.init(num);
                return result;
            },
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
            .Do => {
                var num = try allocator.alloc.create(DoExprAST);
                num.* = try DoExprAST.parse(toks);

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
                    // q: ==
                    '!', '=', '<', '-', '+', '@', '*', '$', ']', 'q' => {
                        var block = try allocator.alloc.create(OpExprAST);
                        block.* = try OpExprAST.parse(toks);

                        result.init(block);
                        return result;
                    },
                    else => {
                        std.log.err("{s}", .{toks.items[0].value});
                        return error.InvalidToken;
                    },
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

            fn typegenImpl(pointer: *anyopaque, values: *StructData) anyerror!void {
                const self = @ptrCast(Ptr, @alignCast(alignment, pointer));

                return @call(.auto, ptr_info.Pointer.child.typegen, .{ self, values });
            }

            const vtable = VTable{
                .codegen = codegenImpl,
                .typegen = typegenImpl,
            };
        };

        selfObj.ptr = ptr;
        selfObj.vtable = &gen.vtable;
    }
};

pub const StringExprAST = struct {
    const Self = @This();

    value: []const u8,

    pub fn codegen(self: *Self, values: *ValueStack) !void {
        var str = TheContext.constString(@ptrCast([*]const u8, self.value), @intCast(c_uint, self.value.len), .False);
        var charType = try getType("u8");

        var stringType = try allocator.alloc.create(TypeData);

        stringType.* = .{
            .aType = TheContext.pointerType(5),
            .name = "array",
            .data = .{
                .Array = charType,
            },
        };

        var value = try allocator.alloc.create(ValueData);

        value.* = .{
            .value = Builder.buildAlloca(str.typeOf(), "string"),
            .kind = .{
                .aType = TheContext.pointerType(5),
                .name = "ptr",
                .data = .{
                    .Pointer = stringType,
                },
            },
        };

        _ = Builder.buildStore(str, value.value);

        try values.append(.{ .Value = value });
    }

    pub fn typegen(_: *Self, _: *StructData) !void {
        return error.InvalidType;
    }

    pub fn parse(toks: *TokenList) !Self {
        var num = toks.orderedRemove(0);
        var value = num.value;

        return .{
            .value = value,
        };
    }
};

pub const NumberExprAST = struct {
    const Self = @This();

    value: i32,

    pub fn codegen(self: *Self, values: *ValueStack) !void {
        var value = try allocator.alloc.create(ValueData);
        var kind = TheContext.intType(32);

        value.kind.aType = kind;
        value.kind.name = "i32";
        value.kind.data = null;
        value.value = llvm.Type.constInt(kind, @intCast(c_ulonglong, self.value), .False);

        try values.append(.{ .Value = value });
    }

    pub fn typegen(_: *Self, _: *StructData) !void {
        return error.InvalidType;
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

        switch (value) {
            .Value => |val| {
                var kind: *TypeData = &val.kind;
                if (kind.data != null and kind.data.? == .Pointer) kind = kind.data.?.Pointer;

                if (kind.data != null and kind.data.? != .Struct) {
                    std.log.info("{s}", .{kind.name});
                    return error.BadKind;
                }
                for (kind.data.?.Struct) |entry, idx| {
                    if (std.mem.eql(u8, entry.name, self.name)) {
                        var adds = try allocator.alloc.create(ValueData);
                        adds.* = .{
                            .value = Builder.buildStructGEP(kind.aType.?, val.value, @intCast(c_uint, idx), ""),
                            .kind = .{
                                .aType = TheContext.pointerType(5),
                                .name = "ptr",
                                .data = .{ .Pointer = &kind.data.?.Struct[idx].kind },
                            },
                        };

                        try values.append(.{ .Value = adds });

                        return;
                    }
                }
            },
            .Type => |kind| {
                var name = try std.fmt.allocPrint(allocator.alloc, "{?s}.{s}", .{ kind.name, self.name });
                defer allocator.alloc.free(name);
                if (named.get(name)) |pushes| {
                    if (pushes == .Function) {
                        var func = pushes.Function;
                        var params = try allocator.alloc.alloc(*llvm.Value, func.args.len);
                        for (params) |_, idx| {
                            params[params.len - idx - 1] = values.pop().Value.value;
                        }

                        var adds = try allocator.alloc.create(ValueData);

                        adds.value = Builder.buildCall(func.kind, func.val, @ptrCast([*]const *llvm.Value, params), @intCast(c_uint, func.args.len), "calltmp");

                        if (func.rets != null) {
                            adds.kind = func.rets.?.*;
                            try values.append(.{ .Value = adds });
                        }
                        return;
                    }
                    try values.append(pushes);
                    return;
                }
                return error.Undefined;
            },
            else => return error.InvalidValue,
        }
        return error.PropNotFound;
    }

    pub fn typegen(_: *Self, _: *StructData) !void {
        return error.InvalidType;
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

        condV = Builder.buildICmp(.NE, condV, llvm.Type.constInt(TheContext.intType(8), 0, .False), "ifcond");

        var headbb = TheContext.appendBasicBlock(TheFunction.?.val, "ifhead");
        var bodybb = TheContext.appendBasicBlock(TheFunction.?.val, "ifbody");
        var mergebb = TheContext.appendBasicBlock(TheFunction.?.val, "ifmerge");

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

    pub fn typegen(_: *Self, _: *StructData) !void {
        return error.InvalidType;
    }

    pub fn parse(toks: *TokenList) !Self {
        _ = toks.orderedRemove(0);

        var body = try ExpressionAST.parse(toks);

        return Self{
            .body = body,
        };
    }
};

pub const DoExprAST = struct {
    const Self = @This();

    body: *ExpressionAST,

    pub fn codegen(self: *Self, values: *ValueStack) !void {
        var bodybb = TheContext.appendBasicBlock(TheFunction.?.val, "dobody");
        var mergebb = TheContext.appendBasicBlock(TheFunction.?.val, "domerge");

        _ = Builder.buildBr(bodybb);
        Builder.positionBuilderAtEnd(bodybb);

        var oldValues = try allocator.alloc.alloc(StackEntry, values.items.len);
        defer allocator.alloc.free(oldValues);

        std.mem.copy(StackEntry, oldValues, values.items);

        var newValues = std.ArrayList(StackEntry).init(allocator.alloc);
        defer newValues.deinit();

        try newValues.appendSlice(values.items);

        try self.body.codegen(&newValues);

        var condV = newValues.pop().Value.value;

        if (newValues.items.len != oldValues.len) return error.SizeMismatch;

        condV = Builder.buildICmp(.NE, condV, llvm.Type.constInt(TheContext.intType(1), 0, .False), "docond");

        _ = Builder.buildCondBr(condV, bodybb, mergebb);
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
            var blocks: [*]const *llvm.BasicBlock = &[_]*llvm.BasicBlock{ bodybb, mergebb };

            Arg.addIncoming(vals, blocks, 2);

            var adds = try allocator.alloc.create(ValueData);
            adds.kind = oldValues[idx].Value.kind;
            adds.value = Arg;

            try values.append(.{ .Value = adds });
        }
    }

    pub fn typegen(_: *Self, _: *StructData) !void {
        return error.InvalidType;
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
            'q' => {
                var R = values.pop();
                var L = values.pop();

                //std.log.info("{}, {}", .{R.Value.kind, L.Value.kind});

                if (!L.Value.kind.sameType(&R.Value.kind)) return error.InvalidCMP;

                var adds = try allocator.alloc.create(ValueData);
                adds.* = .{
                    .kind = .{
                        .aType = TheContext.intType(8),
                        .name = "bool",
                    },
                    .value = Builder.buildICmp(.EQ, R.Value.value, L.Value.value, "eqtmp"),
                };

                try values.append(.{ .Value = adds });
            },
            '!' => {
                var R = values.pop();

                //if (!L.Value.kind.sameType(&R.Value.kind)) return error.InvalidCMP;

                var adds = try allocator.alloc.create(ValueData);
                adds.* = .{
                    .kind = .{
                        .aType = TheContext.intType(1),
                        .name = "bool",
                    },
                    .value = Builder.buildNot(R.Value.value, "nottmp"),
                };

                try values.append(.{ .Value = adds });
            },
            '=' => {
                var R = values.pop();
                var L = values.pop();

                if (!L.Value.kind.data.?.Pointer.sameType(&R.Value.kind)) return error.InvalidAssign;

                _ = Builder.buildStore(R.Value.value, L.Value.value);
            },
            '@' => {
                var Val = values.pop();

                if (Val.Value.kind.data != null and Val.Value.kind.data.? == .Pointer) {
                    var adds = try allocator.alloc.create(ValueData);
                    adds.* = .{
                        .kind = Val.Value.kind.data.?.Pointer.*,
                        .value = Builder.buildLoad(Val.Value.kind.data.?.Pointer.*.aType.?, Val.Value.value, "readtmp"),
                    };
                    try values.append(.{ .Value = adds });
                } else {
                    std.log.info("{any}", .{Val});

                    return error.Invalid;
                }
            },
            '$' => {
                var Type = values.pop();

                var adds = try allocator.alloc.create(TypeData);
                adds.* = .{
                    .aType = TheContext.pointerType(5),
                    .name = "array",
                    .data = .{
                        .Array = Type.Type,
                    },
                };

                try values.append(.{ .Type = adds });
            },
            '*' => {
                var Val = values.pop();

                switch (Val) {
                    .Type => {
                        var adds = try allocator.alloc.create(TypeData);
                        adds.* = .{
                            .aType = TheContext.pointerType(5),
                            .name = "ptr",
                            .data = .{
                                .Pointer = Val.Type,
                            },
                        };

                        try values.append(.{ .Type = adds });
                    },
                    else => return error.InvalidParam,
                }
            },
            ']' => {
                _ = values.pop();
                var R = values.pop();

                var adds = try allocator.alloc.create(ValueData);
                adds.* = .{
                    .kind = R.Value.kind.data.?.Array.*,
                    .value = Builder.buildStructGEP(R.Value.kind.aType.?, R.Value.value, 0, "subtmp"),
                };

                try values.append(.{ .Value = adds });
            },
            '-' => {
                var R = values.pop();
                var L = values.pop();

                var adds = try allocator.alloc.create(ValueData);
                adds.* = .{
                    .kind = R.Value.kind,
                    .value = Builder.buildSub(L.Value.value, R.Value.value, "subtmp"),
                };

                try values.append(.{ .Value = adds });
            },
            '<' => {
                var R = values.pop();
                var L = values.pop();

                var adds = try allocator.alloc.create(ValueData);
                adds.* = .{
                    .kind = R.Value.kind,
                    .value = Builder.buildICmp(.ULE, L.Value.value, R.Value.value, "lttmp"),
                };

                try values.append(.{ .Value = adds });
            },
            '+' => {
                var R = values.pop();
                var L = values.pop();

                var adds = try allocator.alloc.create(ValueData);
                adds.* = .{
                    .kind = R.Value.kind,
                    .value = Builder.buildAdd(L.Value.value, R.Value.value, "addtmp"),
                };

                try values.append(.{ .Value = adds });
            },
            else => return error.InvalidOp,
        }
    }

    pub fn typegen(self: *Self, values: *StructData) !void {
        switch (self.op) {
            '*' => {
                var bak = try allocator.alloc.create(TypeData);

                bak.* = values.items[values.items.len - 1].kind;

                values.items[values.items.len - 1].kind = .{
                    .aType = TheContext.pointerType(5),
                    .name = "ptr",
                    .data = .{
                        .Pointer = bak,
                    },
                };
            },
            '$' => {
                var bak = try allocator.alloc.create(TypeData);

                bak.* = values.items[values.items.len - 1].kind;

                values.items[values.items.len - 1].kind = .{
                    .aType = bak.aType.?.arrayType(3),
                    .name = "array",
                    .data = .{
                        .Array = bak,
                    },
                };
            },
            else => return error.InvalidType,
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
        } else if (std.mem.eql(u8, self.value, "ret")) {
            var A = values.pop();
            _ = Builder.buildRet(A.Value.value);
        } else if (std.mem.eql(u8, self.value, "copy")) {
            try values.append(values.getLast());
        } else if (std.mem.eql(u8, self.value, "cast")) {
            return error.TODO;
        } else if (std.mem.eql(u8, self.value, "covr")) {
            try values.append(values.items[values.items.len - 2]);
        } else if (std.mem.eql(u8, self.value, "swap")) {
            var A = values.pop();
            var B = values.pop();
            try values.append(A);
            try values.append(B);
        } else if (getFunction(self.value)) |func| {
            var params = try allocator.alloc.alloc(*llvm.Value, func.args.len);
            for (params) |_, idx| {
                var val = values.pop();

                params[params.len - idx - 1] = val.Value.value;
                if (!val.Value.kind.sameType(func.args[params.len - idx - 1])) {
                    std.log.info("{s}, {s}", .{ val.Value.kind.name, func.args[params.len - idx - 1].name });
                    return error.TypeMismatch;
                }
            }

            var adds = try allocator.alloc.create(ValueData);

            adds.value = Builder.buildCall(func.kind, func.val, @ptrCast([*]const *llvm.Value, params), @intCast(c_uint, func.args.len), "calltmp");

            if (func.rets != null) {
                adds.kind = func.rets.?.*;
                try values.append(.{ .Value = adds });
            }
        } else if (getNamed(self.value)) |value| {
            try values.append(value);

            //if (value == .Value) {
            //    var lol = &values.items[values.items.len - 1];
            //    lol.Value.value = Builder.buildLoad(lol.Value.kind.aType.?, lol.Value.value, "readtmp");
            //}
        } else if (values.getLast() == .Type) {
            var kind = values.pop().Type;

            var alloca = Builder.buildAlloca(kind.aType.?, @ptrCast([*:0]const u8, self.value));

            var adds = try allocator.alloc.create(ValueData);
            adds.value = alloca;
            adds.kind = .{
                .aType = TheContext.pointerType(5),
                .name = "ptr",
                .data = .{
                    .Pointer = kind,
                },
            };

            try named.put(self.value, .{ .Value = adds });

            //try values.append(.{ .Value = adds });
        } else {
            std.log.info("{s}", .{self.value});

            return error.Undefined;
        }
    }

    pub fn typegen(self: *Self, values: *StructData) !void {
        if (getType(self.value) catch null) |value| {
            try values.append(.{
                .name = "",
                .kind = value.*,
            });
        } else {
            values.items[values.items.len - 1].name = self.value;
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

    pub fn typegen(_: *Self, _: *StructData) !void {
        return error.InvalidType;
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
    args: []ExpressionAST,
    result: []ExpressionAST,

    pub fn parse(toks: *TokenList) !Self {
        var result: PrototypeAST = undefined;

        result.args = try allocator.alloc.alloc(ExpressionAST, 0);
        result.result = try allocator.alloc.alloc(ExpressionAST, 0);
        _ = toks.orderedRemove(0);

        var name = toks.orderedRemove(0);
        result.name = name.value;

        while (true) {
            if (toks.items[0].value[0] == ':') break;

            var expr = try ExpressionAST.parse(toks);
            result.args = try allocator.alloc.realloc(result.args, result.args.len + 1);

            result.args[result.args.len - 1] = expr.*;
        }

        if (toks.items[0].value[0] != ':') return error.InvalidTok;
        _ = toks.orderedRemove(0);

        while (true) {
            var expr = ExpressionAST.parse(toks) catch null;
            if (expr == null) break;

            result.result = try allocator.alloc.realloc(result.result, result.result.len + 1);

            result.result[result.result.len - 1] = expr.?.*;

            if (toks.items[0].value.len > 1 or toks.items[0].value[0] == '{') break;
        }

        return result;
    }

    pub fn codegen(self: *Self) !*FunctionData {
        var argsTypes = std.ArrayList(StructEntry).init(allocator.alloc);
        for (self.args) |*prop| {
            try prop.typegen(&argsTypes);
        }
        var retsTypes = std.ArrayList(StructEntry).init(allocator.alloc);
        for (self.result) |*prop| {
            try prop.typegen(&retsTypes);
        }

        if (retsTypes.items.len != 1) {
            std.log.info("{}", .{retsTypes.items.len});
            return error.BadReturn;
        }

        var input = try allocator.alloc.alloc(*llvm.Type, argsTypes.items.len);

        for (argsTypes.items) |item, idx| {
            input[idx] = item.kind.aType.?;
        }

        var kind = retsTypes.items[0].kind.aType;
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
            data.args[idx] = try allocator.alloc.create(TypeData);
            data.args[idx].* = argsTypes.items[idx].kind;
        }

        if (retsTypes.items[0].kind.aType != null) {
            data.rets = &retsTypes.items[0].kind;
        } else data.rets = null;

        data.kind = functionType;

        try named.put(self.name, .{ .Function = data });

        return data;
    }
};

pub const DefinitionAST = struct {
    const Self = @This();

    proto: PrototypeAST,
    body: *ExpressionAST,

    pub fn codegen(self: *Self) !*llvm.Value {
        var function = try self.proto.codegen();

        TheFunction = function;

        var bb = TheContext.appendBasicBlock(function.val, "");
        Builder.positionBuilderAtEnd(bb);

        var values = ValueStack.init(allocator.alloc);

        for (function.args) |_, idx| {
            var param = function.val.getParam(@intCast(c_uint, idx));
            var value = try allocator.alloc.create(ValueData);
            value.* = .{
                .kind = function.args[idx].*,
                .value = param,
            };

            try values.append(.{
                .Value = value,
            });
        }

        try self.body.codegen(&values);

        if (values.items.len == 1) {
            if (!values.items[0].Value.kind.sameType(function.rets.?)) return error.ReturnMismatch;

            _ = Builder.buildRet(values.items[0].Value.value);

            return function.val;
        } else if (values.items.len == 0) {
            if (function.rets != null) return error.ReturnMismatch;

            _ = Builder.buildRetVoid();

            return function.val;
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

        return function.val;
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
    props: []ExpressionAST,
    defs: []DefinitionAST,

    pub fn codegen(self: *Self) !void {
        var values = std.ArrayList(StructEntry).init(allocator.alloc);
        for (self.props) |*prop| {
            try prop.typegen(&values);
        }

        var types = try allocator.alloc.alloc(*llvm.Type, values.items.len);

        for (values.items) |item, idx| {
            types[idx] = item.kind.aType.?;
        }

        var structType = TheContext.structCreateNamed(@ptrCast([*:0]const u8, self.name));
        structType.structSetBody(@ptrCast([*]*llvm.Type, types), @intCast(c_uint, types.len), .False);
        var adds = try allocator.alloc.create(TypeData);
        adds.* = .{
            .aType = structType,
            .name = self.name,

            .data = .{
                .Struct = values.items,
            },
        };

        try named.put(self.name, .{ .Type = adds });

        for (self.defs) |*def| {
            _ = try def.codegen();
        }
    }

    pub fn parse(toks: *TokenList) !Self {
        var result: StructAST = undefined;

        _ = toks.orderedRemove(0);

        result.name = toks.orderedRemove(0).value;
        result.props = try allocator.alloc.alloc(ExpressionAST, 0);
        result.defs = try allocator.alloc.alloc(DefinitionAST, 0);

        _ = toks.orderedRemove(0);

        while (true) {
            if (toks.items[0].type == .Op and toks.items[0].value[0] == '}') break;
            switch (toks.items[0].type) {
                .Def => {
                    var def = try DefinitionAST.parse(toks);
                    def.proto.name = try std.fmt.allocPrint(allocator.alloc, "{s}.{s}", .{ result.name, def.proto.name });

                    result.defs = try allocator.alloc.realloc(result.defs, result.defs.len + 1);

                    result.defs[result.defs.len - 1] = def;
                },
                else => {
                    var expr = try ExpressionAST.parse(toks);
                    result.props = try allocator.alloc.realloc(result.props, result.props.len + 1);

                    result.props[result.props.len - 1] = expr.*;
                },
            }
        }

        _ = toks.orderedRemove(0);

        return result;
    }
};
