const std = @import("std");
const llvmlib = @import("llvm.zig");
const token = @import("token.zig");
const custom = @import("customtypes.zig");
const allocator = @import("allocator.zig");

var Types: [11]TypeData = undefined;
var nullValue: ValueData = undefined;
var trueValue: ValueData = undefined;
var falseValue: ValueData = undefined;

pub fn setupNamed() !void {
    var oldNamed = named;
    named = std.StringHashMap(StackEntry).init(allocator.alloc);

    var iter = oldNamed.iterator();

    while (iter.next()) |entry| {
        var skip = false;
        for (locals.items) |local| {
            if (std.mem.eql(u8, local, entry.key_ptr.*)) skip = true;
        }
        if (skip) continue;
        try named.put(entry.key_ptr.*, entry.value_ptr.*);
    }
    Types = [_]TypeData{
        .{ .name = "void", .aType = null },
        .{ .name = "i8", .aType = TheContext.intType(8) },
        .{ .name = "i16", .aType = TheContext.intType(16) },
        .{ .name = "i32", .aType = TheContext.intType(32) },
        .{ .name = "i64", .aType = TheContext.intType(64) },
        .{ .name = "f64", .aType = TheContext.doubleType() },
        .{ .name = "ptr", .aType = TheContext.pointerType(0), .data = .{ .Pointer = &Types[0] } },
        .{ .name = "bool", .aType = TheContext.intType(1) },
        .{ .name = "f32", .aType = TheContext.floatType() },
        .{ .name = "type", .aType = null },
        .{ .name = "anytype", .aType = null },
    };

    nullValue = .{
        .llvm = .{
            .kind = Types[6],
            .value = llvmlib.Type.constInt(TheContext.intType(32), 0, .False),
        },
    };

    falseValue = .{
        .llvm = .{
            .kind = Types[7],
            .value = llvmlib.Type.constInt(TheContext.intType(1), 0, .False),
        },
    };

    trueValue = .{
        .llvm = .{
            .kind = Types[7],
            .value = llvmlib.Type.constInt(TheContext.intType(1), 1, .False),
        },
    };

    try named.put("null", .{
        .Value = &nullValue,
    });
    try named.put("false", .{
        .Value = &falseValue,
    });
    try named.put("true", .{
        .Value = &trueValue,
    });

    try named.put("void", .{
        .Type = &Types[0],
    });
    try named.put("bool", .{
        .Type = &Types[7],
    });
    try named.put("type", .{
        .Type = &Types[9],
    });
    try named.put("anytype", .{
        .Type = &Types[10],
    });
    try named.put("i8", .{
        .Type = &Types[1],
    });
    try named.put("i16", .{
        .Type = &Types[2],
    });
    try named.put("i32", .{
        .Type = &Types[3],
    });
    try named.put("i64", .{
        .Type = &Types[4],
    });
    try named.put("u8", .{
        .Type = &Types[1],
    });
    try named.put("u16", .{
        .Type = &Types[2],
    });
    try named.put("u32", .{
        .Type = &Types[3],
    });
    try named.put("u64", .{
        .Type = &Types[4],
    });
    try named.put("f32", .{
        .Type = &Types[8],
    });
    try named.put("f64", .{
        .Type = &Types[5],
    });
}

const FunctionImpl = struct {
    val: *llvmlib.Value,
    args: []*const TypeData,
    rets: ?*const TypeData,
    kind: *llvmlib.Type,
    name: []const u8,
};

const FunctionData = struct {
    ext: ?*llvmlib.Value,

    args: []*const TypeData,
    body: ?*ExpressionAST,
    rets: ?*const TypeData,
    name: []const u8,
    impls: []FunctionImpl,

    pub fn getType(self: *FunctionData, args: []*const TypeData) !*llvmlib.Type {
        for (self.args, 0..) |arg, idx| {
            if (!args[idx].sameType(arg)) {
                std.log.info("{s}", .{self.name});
                return error.BadFunctionCall;
            }
        }

        var akind: ?*llvmlib.Type = undefined;

        if (self.rets == null) {
            akind = TheContext.voidType();
        } else {
            akind = self.rets.?.aType;
            if (akind == null)
                akind = TheContext.voidType();
        }

        var argsKinds = try allocator.alloc.alloc(*llvmlib.Type, args.len);

        for (argsKinds, 0..) |_, idx| {
            argsKinds[idx] = args[idx].aType.?;
        }

        var functionType = llvmlib.functionType(akind.?, argsKinds.ptr, @as(c_uint, @intCast(argsKinds.len)), .False);

        return functionType;
    }

    pub fn implement(self: *FunctionData, args: []*const TypeData) !FunctionImpl {
        for (self.impls) |impl| {
            var good = true;

            for (impl.args, 0..) |arg, idx| {
                if (!args[idx].sameType(arg)) {
                    good = false;
                }
            }
            if (good) return impl;
        }

        for (self.args, 0..) |arg, idx| {
            if (!args[idx].sameType(arg)) {
                std.log.info("{s}", .{self.name});
                std.log.info("{s}!={s}", .{ try args[idx].getName(), try arg.getName() });
                return error.BadFunctionCall;
            }
        }

        var akind: ?*llvmlib.Type = undefined;

        if (self.rets == null) {
            akind = TheContext.voidType();
        } else {
            akind = self.rets.?.aType;
            if (akind == null)
                akind = TheContext.voidType();
        }

        var argsKinds = try allocator.alloc.alloc(*llvmlib.Type, args.len);

        for (argsKinds, 0..) |_, idx| {
            argsKinds[idx] = args[idx].aType.?;
        }

        var functionType = llvmlib.functionType(akind.?, argsKinds.ptr, @as(c_uint, @intCast(argsKinds.len)), .False);

        if (self.ext != null) {
            return .{
                .val = self.ext.?,
                .args = self.args,
                .rets = self.rets,
                .kind = functionType,
                .name = self.name,
            };
        }
        var name: []u8 = undefined;
        if (std.mem.eql(u8, "main", self.name)) {
            name = try std.fmt.allocPrint(allocator.alloc, "{s} ", .{self.name});
        } else {
            name = try std.fmt.allocPrint(allocator.alloc, "{s}_{} ", .{ self.name, self.impls.len });
        }

        std.log.info("impl: {s}", .{self.name});

        name[name.len - 1] = 0;

        var function = llvmlib.Module.addFunction(TheModule, @as([*:0]const u8, @ptrCast(name)), functionType);

        var oldFunc = TheFunction;
        TheFunction = .{
            .val = function,
            .args = args,
            .rets = self.rets,
            .kind = functionType,
            .name = name,
        };

        var oldBB = Builder.getInsertBlock();
        var bb = TheContext.appendBasicBlock(function, "entry");
        Builder.positionBuilderAtEnd(bb);

        var values = ValueStack.init(allocator.alloc);

        for (self.args, 0..) |_, idx| {
            var param = function.getParam(@as(c_uint, @intCast(idx)));
            var value = try allocator.alloc.create(ValueData);
            value.* = .{
                .llvm = .{
                    .kind = args[idx].*,
                    .value = param,
                },
            };

            try values.append(.{
                .Value = value,
            });
        }

        var oldLocals = locals;
        var oldNamed = named;
        try setupNamed();
        locals = std.ArrayList([]const u8).init(allocator.alloc);

        try self.body.?.codegen(&values);

        named = oldNamed;
        locals = oldLocals;
        TheFunction = oldFunc;

        if (values.items.len == 1) {
            var val = try values.items[0].getValue(self.rets.?);

            if (!val.Value.getKind().sameType(self.rets.?)) {
                std.log.info("{s}", .{self.name});
                return error.ReturnMismatch;
            }

            _ = Builder.buildRet(val.Value.getValue());
            var idx = self.impls.len;
            self.impls = try allocator.alloc.realloc(self.impls, self.impls.len + 1);

            self.impls[idx] = .{
                .val = function,
                .args = args,
                .rets = self.rets,
                .kind = functionType,
                .name = name,
            };

            Builder.positionBuilderAtEnd(oldBB);

            return self.impls[idx];
        } else if (values.items.len == 0) {
            if (self.rets != null) {
                std.log.info("{s}", .{self.name});
                return error.ReturnMismatch;
            }

            _ = Builder.buildRetVoid();

            var idx = self.impls.len;
            self.impls = try allocator.alloc.realloc(self.impls, self.impls.len + 1);

            self.impls[idx] = .{
                .val = function,
                .args = args,
                .rets = self.rets,
                .kind = functionType,
                .name = name,
            };

            Builder.positionBuilderAtEnd(oldBB);

            return self.impls[idx];
        }
        std.log.info("{s}: {any}, {}", .{ self.name, values.items, values.items.len });

        return error.Unknown;
    }
};

pub const ValueKind = enum {
    llvm,
    ref,
};

pub const LLVMValueData = struct {
    kind: TypeData,
    value: *llvmlib.Value,
};

pub const ValueData = union(ValueKind) {
    llvm: LLVMValueData,
    ref: custom.RefValueData,

    pub fn getValue(self: *const ValueData) *llvmlib.Value {
        switch (self.*) {
            .llvm => {
                return self.llvm.value;
            },
            .ref => {
                return self.ref.value;
            },
        }
    }

    pub fn getKind(self: *const ValueData) TypeData {
        switch (self.*) {
            .llvm => {
                return self.llvm.kind;
            },
            .ref => {
                return self.ref.getKind(TheContext) catch undefined;
            },
        }
    }
};

pub const StructEntry = struct {
    name: []const u8,
    kind: TypeData,
};

pub const InternalTypeKind = enum {
    Int,
    Float,
    Error,
};

pub const InternalData = union(InternalTypeKind) {
    Int: c_ulonglong,
    Float: f64,
    Error: []const u8,
};

pub const FunctionType = struct {
    args: []*const TypeData,
    rets: ?*const TypeData,
};

pub const TypeKind = enum {
    Pointer,
    Reference,
    Array,
    Error,
    Struct,
    Function,
};

pub const TypeSubData = union(TypeKind) {
    Pointer: *const TypeData,
    Reference: *const TypeData,
    Array: *const TypeData,
    Error: *const TypeData,
    Struct: []StructEntry,
    Function: FunctionType,
};

pub const TypeData = struct {
    aType: ?*llvmlib.Type,
    name: []const u8,

    data: ?TypeSubData = null,

    pub fn errorType(targType: *llvmlib.Type) *llvmlib.Type {
        var types: []const *llvmlib.Type = &[_]*llvmlib.Type{ TheContext.intType(1), targType };

        var structType = TheContext.structType(types.ptr, 2, .True);

        return structType;
    }

    pub fn getName(self: *const TypeData) ![]const u8 {
        if (self.data == null)
            return self.name;

        switch (self.data.?) {
            .Pointer => |ptr| {
                return try std.fmt.allocPrint(allocator.alloc, "ptr {s}", .{try ptr.getName()});
            },
            .Reference => |ptr| {
                return try std.fmt.allocPrint(allocator.alloc, "ref {s}", .{try ptr.getName()});
            },
            .Array => |array| {
                return try std.fmt.allocPrint(allocator.alloc, "arr {s}", .{try array.getName()});
            },
            .Error => |err| {
                return try std.fmt.allocPrint(allocator.alloc, "err {s}", .{try err.getName()});
            },
            .Struct => |str| {
                var result = try std.fmt.allocPrint(allocator.alloc, "struct {s} [", .{self.name});
                for (str, 0..) |item, idx| {
                    var r: []u8 = undefined;
                    if (idx != 0) {
                        r = try std.fmt.allocPrint(allocator.alloc, "{s}, {s}", .{ result, try item.kind.getName() });
                    } else {
                        r = try std.fmt.allocPrint(allocator.alloc, "{s}{s}", .{ result, try item.kind.getName() });
                    }
                    allocator.alloc.free(result);
                    result = r;
                }
                var r = try std.fmt.allocPrint(allocator.alloc, "{s}]", .{result});
                allocator.alloc.free(result);
                result = r;

                return result;
            },
            .Function => |func| {
                var result = try std.fmt.allocPrint(allocator.alloc, "proc", .{});
                for (func.args, 0..) |item, idx| {
                    var r: []u8 = undefined;
                    if (idx != 0) {
                        r = try std.fmt.allocPrint(allocator.alloc, "{s}, {s}", .{ result, try item.getName() });
                    } else {
                        r = try std.fmt.allocPrint(allocator.alloc, "{s} {s}", .{ result, try item.getName() });
                    }
                    allocator.alloc.free(result);
                    result = r;
                }
                if (func.rets != null) {
                    var r = try std.fmt.allocPrint(allocator.alloc, "{s} => {s}", .{ result, try func.rets.?.getName() });
                    allocator.alloc.free(result);
                    result = r;
                } else {
                    var r = try std.fmt.allocPrint(allocator.alloc, "{s} => void", .{result});
                    allocator.alloc.free(result);
                    result = r;
                }

                return result;
            },
        }
    }

    pub fn sameType(self: *const TypeData, other: *const TypeData) bool {
        if (std.mem.eql(u8, self.name, "anytype") or std.mem.eql(u8, other.name, "anytype")) return true;
        if ((self.aType == null) != (other.aType == null)) return false;
        if ((self.data == null) != (other.data == null)) return false;
        if (self.aType == null or self.data == null) return std.mem.eql(u8, self.name, other.name);
        switch (self.data.?) {
            .Reference => {
                if (other.data.? != .Reference) return false;
                if (other.data.?.Reference.aType == null or self.data.?.Reference.aType == null) return true;

                if (!self.data.?.Reference.sameType(other.data.?.Reference)) return false;
            },
            .Pointer => {
                if (other.data.? != .Pointer) return false;
                if (other.data.?.Pointer.aType == null or self.data.?.Pointer.aType == null) return true;

                if (!self.data.?.Pointer.sameType(other.data.?.Pointer)) return false;
            },
            .Array => {
                if (other.data.? != .Array) return false;
                if (!self.data.?.Array.sameType(other.data.?.Array)) return false;
            },
            .Struct => {
                if (other.data.? != .Struct) return false;
                if (self.data.?.Struct.len != other.data.?.Struct.len) return false;
                for (self.data.?.Struct, 0..) |*a, idx| {
                    if (!a.kind.sameType(&other.data.?.Struct[idx].kind)) return false;
                }
            },
            .Function => {
                if (other.data.? != .Function) return false;
                if ((self.data.?.Function.rets == null) != (other.data.?.Function.rets == null)) return false;
                for (self.data.?.Function.args, 0..) |a, idx| {
                    if (!a.sameType(other.data.?.Function.args[idx])) return false;
                }
                if (self.data.?.Function.rets != null and !self.data.?.Function.rets.?.sameType(other.data.?.Function.rets.?)) return false;
            },
            .Error => {
                if (other.data.? != .Error) return false;
                if (!self.data.?.Error.sameType(other.data.?.Error)) return false;
            },
        }
        return std.mem.eql(u8, self.name, other.name);
    }
};

const StackEntryTag = enum {
    Value,
    //CompValue,
    Function,
    Type,
    Internal,
};

pub const StackEntry = union(StackEntryTag) {
    Value: *ValueData,
    //CompValue: *ValueData,
    Function: *FunctionData,
    Type: *const TypeData,
    Internal: *InternalData,

    pub fn eql(self: *StackEntry, other: *StackEntry) bool {
        switch (self.*) {
            .Value => {
                return (other.* == .Value and other.Value == self.Value) or other.* == .Internal;
            },
            .Function => {
                return (other.* == .Function) and other.Function == self.Function;
            },
            .Type => {
                return (other.* == .Type) and other.Type.sameType(self.Type);
            },
            .Internal => {
                return (other.* == .Internal or other.* == .Value);
            },
        }
    }

    pub fn getValue(self: *const StackEntry, kind: *const TypeData) !*const StackEntry {
        switch (self.*) {
            .Value => {
                if (kind.data != null and kind.data.? == .Error) {
                    if (self.Value.getKind().sameType(kind.data.?.Error)) {
                        var values: []const *llvmlib.Value = &[_]*llvmlib.Value{
                            llvmlib.Type.constInt(TheContext.intType(1), 0, .False),
                            self.Value.getValue(),
                        };
                        var constant = TheContext.constStruct(values.ptr, 2, .True);
                        var out = Builder.buildAlloca(constant.typeOf(), "err");
                        _ = Builder.buildStore(constant, out);

                        var result = try allocator.alloc.create(StackEntry);
                        var val = try allocator.alloc.create(ValueData);
                        result.* = .{
                            .Value = val,
                        };

                        val.* = .{
                            .llvm = .{
                                .kind = kind.*,
                                .value = out,
                            },
                        };

                        return result;
                    }
                    return self;
                }
                return self;
            },
            .Function => return error.NotValue,
            .Type => return error.NotValue,
            .Internal => {
                var result = try allocator.alloc.create(StackEntry);
                var val = try allocator.alloc.create(ValueData);
                result.* = .{
                    .Value = val,
                };
                switch (self.Internal.*) {
                    .Int => {
                        if (kind.data == null or kind.data.? != .Error) {
                            val.* = .{
                                .llvm = .{
                                    .kind = kind.*,
                                    .value = llvmlib.Type.constInt(kind.aType.?, self.Internal.Int, .False),
                                },
                            };
                        } else {
                            var values: []const *llvmlib.Value = &[_]*llvmlib.Value{
                                llvmlib.Type.constInt(TheContext.intType(1), 0, .False),
                                llvmlib.Type.constInt(kind.data.?.Error.aType.?, self.Internal.Int, .False),
                            };
                            var constant = TheContext.constStruct(values.ptr, 2, .True);
                            var alloca = Builder.buildAlloca(constant.typeOf(), "err");
                            _ = Builder.buildStore(constant, alloca);

                            val.* = .{
                                .llvm = .{
                                    .kind = kind.*,
                                    .value = alloca,
                                },
                            };
                        }
                    },
                    .Float => {
                        if (kind.data == null or kind.data.? != .Error) {
                            val.* = .{
                                .llvm = .{
                                    .kind = kind.*,
                                    .value = llvmlib.Type.constReal(kind.aType.?, self.Internal.Float),
                                },
                            };
                        } else {
                            var values: []const *llvmlib.Value = &[_]*llvmlib.Value{
                                llvmlib.Type.constInt(TheContext.intType(1), 0, .False),
                                llvmlib.Type.constReal(kind.data.?.Error.aType.?, self.Internal.Float),
                            };
                            var constant = TheContext.constStruct(values.ptr, 2, .True);
                            var alloca = Builder.buildAlloca(constant.typeOf(), "err");
                            _ = Builder.buildStore(constant, alloca);

                            val.* = .{
                                .llvm = .{
                                    .kind = kind.*,
                                    .value = alloca,
                                },
                            };
                        }
                    },
                    .Error => {
                        var values: []const *llvmlib.Value = &[_]*llvmlib.Value{
                            llvmlib.Type.constInt(TheContext.intType(1), 1, .False),
                            TheContext.constString(self.Internal.Error.ptr, @as(c_uint, @intCast(self.Internal.Error.len)), .False),
                        };
                        var constant = TheContext.constStruct(values.ptr, 2, .True);
                        var out = Builder.buildAlloca(constant.typeOf(), "err");
                        _ = Builder.buildStore(constant, out);

                        val.* = .{
                            .llvm = .{
                                .kind = kind.*,
                                .value = out,
                            },
                        };
                    },
                }
                return result;
            },
        }
    }
};

pub const ValueStack = std.ArrayList(StackEntry);
const StructData = std.ArrayList(StructEntry);
const TokenList = std.ArrayList(token.Token);

pub var TheModule: *llvmlib.Module = undefined;
pub var TheContext: *llvmlib.Context = undefined;
pub var Builder: *llvmlib.Builder = undefined;
pub var TheFunction: ?FunctionImpl = null;
pub var locals: std.ArrayList([]const u8) = undefined;

pub var named: std.StringHashMap(StackEntry) = undefined;

pub fn getType(name: []const u8) !*const TypeData {
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
    return named.get(name);
}

pub fn getFunction(name: []const u8, values: *ValueStack) !?FunctionImpl {
    var kind = named.get(name);
    if (kind) |result| {
        if (result == .Function) {
            var args = try allocator.alloc.alloc(*const TypeData, result.Function.args.len);
            for (args, 0..) |_, idx| {
                var val = values.items[values.items.len - args.len + idx];
                switch (val) {
                    .Value => {
                        const tmp = try allocator.alloc.create(TypeData);
                        tmp.* = val.Value.getKind();
                        args[idx] = tmp;
                    },
                    .Type => {
                        args[idx] = getNamed("type").?.Type;
                    },
                    .Internal => {
                        args[idx] = result.Function.args[idx];
                    },
                    else => return error.Invalid,
                }
            }

            return try result.Function.implement(args);
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
            .Error => {
                var proc = try allocator.alloc.create(ErrorExprAST);
                proc.* = try ErrorExprAST.parse(toks);

                result.init(proc);
                return result;
            },
            .Lambda => {
                var proc = try allocator.alloc.create(ProcExprAST);
                proc.* = try ProcExprAST.parse(toks);

                result.init(proc);
                return result;
            },
            .Bracket => {
                var str = try allocator.alloc.create(BracketExprAST);
                str.* = try BracketExprAST.parse(toks);

                result.init(str);
                return result;
            },
            .Paren => {
                var str = try allocator.alloc.create(ParenExprAST);
                str.* = try ParenExprAST.parse(toks);

                result.init(str);
                return result;
            },
            .String => {
                var str = try allocator.alloc.create(StringExprAST);
                str.* = try StringExprAST.parse(toks);

                result.init(str);
                return result;
            },
            .Number => {
                var num = try allocator.alloc.create(NumberExprAST);
                num.* = try NumberExprAST.parse(toks);

                result.init(num);
                return result;
            },
            .Ident => {
                var ident = try allocator.alloc.create(IdentExprAST);
                ident.* = try IdentExprAST.parse(toks);

                result.init(ident);
                return result;
            },
            .For => {
                var stmt = try allocator.alloc.create(ForExprAST);
                stmt.* = try ForExprAST.parse(toks);

                result.init(stmt);
                return result;
            },
            .If => {
                var stmt = try allocator.alloc.create(IfExprAST);
                stmt.* = try IfExprAST.parse(toks);

                result.init(stmt);
                return result;
            },
            .Do => {
                var do = try allocator.alloc.create(DoExprAST);
                do.* = try DoExprAST.parse(toks);

                result.init(do);
                return result;
            },
            .Op => {
                switch (toks.items[0].value[0]) {
                    'N' => {
                        var prop = try allocator.alloc.create(NameExprAST);
                        prop.* = try NameExprAST.parse(toks);

                        result.init(prop);
                        return result;
                    },
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
                    // n: !=
                    // c: ()
                    // A: &&
                    // O: ||
                    '!', '=', '<', '>', '-', '^', '+', '@', '*', '$', ']', '\'', 'q', 'n', 'c', 'A', 'O', 'L', 'R', '/', '&' => {
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

        const gen = struct {
            fn codegenImpl(pointer: *anyopaque, values: *ValueStack) anyerror!void {
                const self = @as(Ptr, @ptrCast(@alignCast(pointer)));

                return @call(.auto, ptr_info.Pointer.child.codegen, .{ self, values });
            }

            fn typegenImpl(pointer: *anyopaque, values: *StructData) anyerror!void {
                const self = @as(Ptr, @ptrCast(@alignCast(pointer)));

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

pub const ErrorExprAST = struct {
    const Self = @This();

    value: []const u8,

    pub fn codegen(self: *Self, values: *ValueStack) !void {
        var value = try allocator.alloc.create(InternalData);

        value.* = .{
            .Error = self.value,
        };

        try values.append(.{ .Internal = value });
    }

    pub fn typegen(_: *Self, _: *StructData) !void {
        return error.InvalidType;
    }

    pub fn parse(toks: *TokenList) !Self {
        _ = toks.orderedRemove(0);
        var num = toks.orderedRemove(0);
        var value = num.value;

        return .{
            .value = value,
        };
    }
};

pub const StringExprAST = struct {
    const Self = @This();

    value: []const u8,

    pub fn codegen(self: *Self, values: *ValueStack) !void {
        var strVal = TheContext.constString(@as([*]const u8, @ptrCast(self.value)), @as(c_uint, @intCast(self.value.len)), .False);
        var charType = try getType("u8");
        var str = TheModule.addGlobal(strVal.typeOf(), "str");
        str.setInitializer(strVal);

        var stringType = try allocator.alloc.create(TypeData);

        stringType.* = .{
            .aType = TheContext.pointerType(0),
            .name = "array",
            .data = .{
                .Array = charType,
            },
        };

        var value = try allocator.alloc.create(ValueData);

        value.* = .{
            .llvm = .{
                .value = str,
                //.kind = stringType.*,
                //.value = Builder.buildAlloca(str.typeOf(), "ptr"),
                .kind = .{
                    .aType = TheContext.pointerType(0),
                    .name = "ptr",
                    .data = .{
                        .Pointer = stringType,
                    },
                },
            },
        };

        //_ = Builder.buildStore(str, value.value);

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

    const NumberKind = enum { Float, Int };
    const Number = union(NumberKind) {
        Float: f64,
        Int: c_ulonglong,
    };

    value: Number,

    pub fn codegen(self: *Self, values: *ValueStack) !void {
        switch (self.value) {
            .Float => {
                var value = try allocator.alloc.create(InternalData);

                value.* = .{
                    .Float = self.value.Float,
                };

                try values.append(.{ .Internal = value });
            },
            .Int => {
                var value = try allocator.alloc.create(InternalData);

                value.* = .{
                    .Int = self.value.Int,
                };

                try values.append(.{ .Internal = value });
            },
        }
    }

    pub fn typegen(_: *Self, _: *StructData) !void {
        return error.InvalidType;
    }

    pub fn parse(toks: *TokenList) !Self {
        var num = toks.orderedRemove(0);
        var value: Number = undefined;

        if (std.mem.containsAtLeast(u8, num.value, 1, ".")) {
            value = .{ .Float = try std.fmt.parseFloat(f64, num.value) };
        } else {
            value = .{ .Int = try std.fmt.parseInt(c_ulonglong, num.value, 10) };
        }

        return .{
            .value = value,
        };
    }
};

pub const ParenExprAST = struct {
    const Self = @This();

    value: []const u8,

    pub fn codegen(self: *Self, values: *ValueStack) !void {
        if (getNamed(self.value)) |funcdat| {
            var func = try funcdat.Function.implement(funcdat.Function.args);

            var value = try allocator.alloc.create(ValueData);

            var fnType = try allocator.alloc.create(TypeData);
            fnType.* = .{
                .name = "func",
                .aType = func.kind,
                .data = .{
                    .Function = .{
                        .args = func.args,
                        .rets = func.rets,
                    },
                },
            };

            value.* = .{
                .llvm = .{
                    .value = func.val,
                    .kind = .{
                        .aType = TheContext.pointerType(0),
                        .name = "ptr",
                        .data = .{
                            .Pointer = fnType,
                        },
                    },
                },
            };

            try values.append(.{
                .Value = value,
            });
            return;
        }
        return error.Undefined;
    }

    pub fn typegen(_: *Self, _: *StructData) !void {
        return error.InvalidType;
    }

    pub fn parse(toks: *TokenList) !Self {
        var num = toks.orderedRemove(0);

        return .{
            .value = num.value,
        };
    }
};

pub const BracketExprAST = struct {
    const Self = @This();

    value: c_uint,

    pub fn codegen(self: *Self, values: *ValueStack) !void {
        var top = values.pop();

        switch (top) {
            .Value => {
                var kind = top.Value.getKind().data.?.Pointer.data.?.Array;

                var value = try allocator.alloc.create(ValueData);

                //var idx = llvmlib.Type.constInt(TheContext.intType(32), @intCast(c_ulonglong, self.value), .False);

                value.* = .{
                    .llvm = .{
                        .kind = .{
                            .aType = TheContext.pointerType(0),
                            .name = "ptr",
                            .data = .{
                                .Pointer = kind,
                            },
                        },
                        .value = Builder.buildStructGEP(top.Value.getKind().data.?.Pointer.aType.?, top.Value.getValue(), self.value, "elemtemp"),
                    },
                };

                try values.append(.{ .Value = value });
            },
            .Type => {
                var kind = try allocator.alloc.create(TypeData);

                kind.* = .{
                    .aType = top.Type.aType.?.arrayType(self.value),
                    .name = "array",
                    .data = .{
                        .Array = top.Type,
                    },
                };

                try values.append(.{ .Type = kind });
            },
            else => return error.InvalidKind,
        }
    }

    pub fn typegen(self: *Self, values: *StructData) !void {
        var top = try allocator.alloc.create(TypeData);
        top.* = values.pop().kind;

        try values.append(.{
            .kind = .{
                .aType = top.aType.?.arrayType(self.value),
                .name = "array",
                .data = .{
                    .Array = top,
                },
            },
            .name = "",
        });
    }

    pub fn parse(toks: *TokenList) !Self {
        var num = toks.orderedRemove(0);
        var value = try std.fmt.parseInt(c_uint, num.value, 10);

        return .{
            .value = value,
        };
    }
};

pub const FuncTypeAST = struct {
    const Self = @This();

    proto: PrototypeAST,

    pub fn codegen(self: *Self) !void {
        var function = try self.proto.codegen();

        function.ext.?.deleteFunction();
        function.ext = null;

        var kind = try allocator.alloc.create(TypeData);
        var fnKind = try allocator.alloc.create(TypeData);
        fnKind.* = .{
            .aType = try function.getType(function.args),
            .name = "func",
            .data = .{
                .Function = .{
                    .args = function.args,
                    .rets = function.rets,
                },
            },
        };
        kind.* = .{
            .aType = TheContext.pointerType(0),
            .name = "ptr",
            .data = .{ .Pointer = fnKind },
        };

        try named.put(self.proto.name, .{ .Type = kind });
    }

    pub fn parse(toks: *TokenList) !Self {
        _ = toks.orderedRemove(0);
        var result: Self = undefined;

        result.proto = try PrototypeAST.parse(toks);

        return result;
    }
};

pub const ProcExprAST = struct {
    const Self = @This();

    proto: PrototypeAST,
    body: *ExpressionAST,

    pub fn codegen(self: *Self, values: *ValueStack) !void {
        var oldFN = TheFunction;
        var oldBB = Builder.getInsertBlock();
        defer {
            TheFunction = oldFN;
            Builder.positionBuilderAtEnd(oldBB);
        }

        var function = try self.proto.codegen();

        function.body = self.body;
        function.ext.?.deleteFunction();
        function.ext = null;

        //TheFunction = function;

        //var bb = TheContext.appendBasicBlock(function.val, "entry");
        //Builder.positionBuilderAtEnd(bb);

        //var values_tmp = ValueStack.init(allocator.alloc);

        //for (function.args) |_, idx| {
        //    var param = function.val.getParam(@intCast(c_uint, idx));
        //    var value = try allocator.alloc.create(ValueData);
        //    value.* = .{
        //        .kind = function.args[idx].*,
        //        .value = param,
        //    };

        //    try values_tmp.append(.{
        //        .Value = value,
        //    });
        //}

        //try self.body.codegen(&values_tmp);

        //if (values_tmp.items.len == 1) {
        //    var val = try values_tmp.items[0].getValue(function.rets.?);

        //    if (!val.Value.kind.sameType(function.rets.?)) return error.ReturnMismatch;

        //    _ = Builder.buildRet(val.Value.value);

        //    try values.append(.{
        //        .Function = function,
        //    });

        //    return;
        //} else if (values_tmp.items.len == 0) {
        //    if (function.rets != null) return error.ReturnMismatch;

        //    _ = Builder.buildRetVoid();

        //    try values.append(.{
        //        .Function = function,
        //    });

        //    return;
        //}

        std.log.err("{s}: {any}, {}", .{ self.proto.name, values.items, values.items.len });
    }

    pub fn typegen(_: *Self, _: *StructData) !void {
        return error.InvalidType;
    }

    pub fn parse(toks: *TokenList) !Self {
        var result: Self = undefined;

        result.proto = try PrototypeAST.parse(toks);

        result.proto.name = "anon";

        result.body = try ExpressionAST.parse(toks);

        return result;
    }
};

pub const NameExprAST = struct {
    const Self = @This();

    name: []const u8,

    pub fn codegen(self: *Self, values: *ValueStack) !void {
        var value = values.pop();
        try named.put(self.name, value);
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

pub const PropExprAST = struct {
    const Self = @This();

    name: []const u8,

    pub fn codegen(self: *Self, values: *ValueStack) !void {
        var value = values.pop();

        switch (value) {
            .Value => |val| {
                if (std.mem.eql(u8, self.name, "TYPE")) {
                    try values.append(.{ .Type = &val.getKind() });
                    return;
                }
                var kind: *TypeData = try allocator.alloc.create(TypeData);
                kind.* = val.getKind();

                if (kind.data != null and kind.data.? == .Pointer) {
                    kind.* = kind.data.?.Pointer.*;

                    if (kind.data != null and kind.data.? != .Struct) {
                        std.log.err("{s}", .{try kind.getName()});
                        return error.BadKind;
                    }
                    for (kind.data.?.Struct, 0..) |entry, idx| {
                        if (std.mem.eql(u8, entry.name, self.name)) {
                            var adds = try allocator.alloc.create(ValueData);
                            adds.* = .{
                                .llvm = .{
                                    .value = Builder.buildStructGEP(kind.aType.?, val.getValue(), @as(c_uint, @intCast(idx)), ""),
                                    .kind = .{
                                        .aType = TheContext.pointerType(0),
                                        .name = "ptr",
                                        .data = .{ .Pointer = &kind.data.?.Struct[idx].kind },
                                    },
                                },
                            };

                            try values.append(.{ .Value = adds });

                            return;
                        }
                    }
                } else {
                    if (kind.data != null and kind.data.? != .Struct) {
                        std.log.err("{s}", .{try kind.getName()});
                        return error.BadKind;
                    }
                    for (kind.data.?.Struct, 0..) |entry, idx| {
                        if (std.mem.eql(u8, entry.name, self.name)) {
                            var adds = try allocator.alloc.create(ValueData);
                            adds.* = .{
                                .llvm = .{
                                    .value = Builder.buildExtractValue(val.getValue(), @as(c_uint, @intCast(idx)), "extracted"),
                                    .kind = entry.kind,
                                },
                            };

                            try values.append(.{ .Value = adds });

                            return;
                        }
                    }
                }
                std.log.err("{s}, {s}", .{ self.name, try val.getKind().getName() });
                return error.PropNotFound;
            },
            .Type => |kind| {
                //if (std.mem.eql(u8, self.name, "NEW")) {
                //    var pushes = try allocator.alloc.create(ValueData);

                //    pushes.* = .{
                //        .llvm = .{
                //            .kind = kind.*,
                //            .value = llvmlib.Type.constInt(TheContext.intType(32), 1, .False),
                //        },
                //    };

                //    try values.append(.{ .Value = pushes });
                //    return;
                //}
                if (std.mem.eql(u8, self.name, "SIZE")) {
                    var pushes = try allocator.alloc.create(ValueData);
                    const indices: []const *llvmlib.Value = &[_]*llvmlib.Value{
                        llvmlib.Type.constInt(TheContext.intType(32), 1, .False),
                    };

                    var size = kind.aType.?.arrayType(1).constInBoundsGEP(TheContext.pointerType(0).constNull(), indices.ptr, 1);

                    pushes.* = .{
                        .llvm = .{
                            .kind = (try getType("i32")).*,
                            .value = Builder.buildPtrToInt(size, TheContext.intType(32), "SIZE"),
                        },
                    };

                    try values.append(.{ .Value = pushes });
                    return;
                }
                var name = try std.fmt.allocPrint(allocator.alloc, "{?s}.{s}", .{ kind.name, self.name });
                defer allocator.alloc.free(name);
                if (named.get(name)) |pushes| {
                    if (pushes == .Function) {
                        var func = (try getFunction(name, values)).?;
                        var params = try allocator.alloc.alloc(*llvmlib.Value, func.args.len);
                        for (params, 0..) |_, idx| {
                            params[params.len - idx - 1] = (try values.pop().getValue(func.args[params.len - idx - 1])).Value.getValue();
                        }

                        const adds = try allocator.alloc.create(ValueData);

                        adds.* = .{
                            .llvm = .{
                                .kind = undefined,
                                .value = Builder.buildCall(func.kind, func.val, @as([*]const *llvmlib.Value, @ptrCast(params)), @as(c_uint, @intCast(func.args.len)), "calltmp"),
                            },
                        };

                        if (func.rets != null) {
                            adds.llvm.kind = func.rets.?.*;
                            try values.append(.{ .Value = adds });
                        }
                        return;
                    }
                    try values.append(pushes);
                    return;
                }
                std.log.info("{s}", .{name});
                return error.Undefined;
            },
            else => return error.InvalidValue,
        }
        std.log.info("{s}", .{self.name});

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
        var condV = (try values.pop().getValue(try getType("bool"))).Value.getValue();

        condV = Builder.buildICmp(.NE, condV, llvmlib.Type.constInt(TheContext.intType(1), 0, .False), "ifcond");

        var headbb = Builder.getInsertBlock();
        var bodybb = TheContext.appendBasicBlock(TheFunction.?.val, "ifbody");
        var mergebb = TheContext.appendBasicBlock(TheFunction.?.val, "ifmerge");

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

        for (oldValues, 0..) |_, idx| {
            if (oldValues[idx].eql(&newValues.items[idx])) {
                try values.append(oldValues[idx]);
                continue;
            }

            var name = try std.fmt.allocPrint(allocator.alloc, "__if_{}", .{idx});
            defer allocator.alloc.free(name);

            var Arg = Builder.buildPhi(oldValues[idx].Value.getValue().typeOf(), @as([*:0]const u8, @ptrCast(name)));
            var vals: [*]const *llvmlib.Value = &[_]*llvmlib.Value{ oldValues[idx].Value.getValue(), newValues.items[idx].Value.getValue() };
            var blocks: [*]const *llvmlib.BasicBlock = &[_]*llvmlib.BasicBlock{ headbb, bodybb };

            Arg.addIncoming(vals, blocks, 2);

            var adds = try allocator.alloc.create(ValueData);
            adds.* = .{
                .llvm = .{
                    .kind = oldValues[idx].Value.getKind(),
                    .value = Arg,
                },
            };

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

pub const ForExprAST = struct {
    const Self = @This();

    body: *ExpressionAST,

    pub fn codegen(_: *Self, _: *ValueStack) !void {
        return error.Undefined;
        //var startbb = Builder.getInsertBlock();
        //var bodybb = TheContext.appendBasicBlock(TheFunction.?.val, "forbody");

        //_ = Builder.buildBr(bodybb);

        //Builder.positionBuilderAtEnd(bodybb);

        //var Idx = Builder.buildPhi(TheContext.intType(32), "foridx");
        //var One = llvmlib.Type.constInt(TheContext.intType(32), 1, .False);
        //var Start = llvmlib.Type.constInt(TheContext.intType(32), 0, .False);
        //var Add = Builder.buildAdd(Idx, One, "addtmp");

        //var vals: [*]const *llvmlib.Value = &[_]*llvmlib.Value{ Start, Add };
        //var blocks: [*]const *llvmlib.BasicBlock = &[_]*llvmlib.BasicBlock{ startbb, bodybb };

        //Idx.addIncoming(vals, blocks, 2);
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

        var condV = (try newValues.pop().getValue(try getType("bool"))).Value.getValue();

        if (newValues.items.len != oldValues.len) return error.SizeMismatch;

        condV = Builder.buildICmp(.NE, condV, llvmlib.Type.constInt(TheContext.intType(1), 0, .False), "docond");

        _ = Builder.buildCondBr(condV, bodybb, mergebb);
        Builder.positionBuilderAtEnd(mergebb);

        values.clearAndFree();

        for (oldValues, 0..) |_, idx| {
            if (oldValues[idx].Value == newValues.items[idx].Value) {
                try values.append(oldValues[idx]);
                continue;
            }

            var name = try std.fmt.allocPrint(allocator.alloc, "__if_{}", .{idx});
            defer allocator.alloc.free(name);

            var Arg = Builder.buildPhi(oldValues[idx].Value.getValue().typeOf(), @as([*:0]const u8, @ptrCast(name)));
            var vals: [*]const *llvmlib.Value = &[_]*llvmlib.Value{ oldValues[idx].Value.getValue(), newValues.items[idx].Value.getValue() };
            var blocks: [*]const *llvmlib.BasicBlock = &[_]*llvmlib.BasicBlock{ bodybb, mergebb };

            Arg.addIncoming(vals, blocks, 2);

            var adds = try allocator.alloc.create(ValueData);
            adds.* = .{
                .llvm = .{
                    .kind = oldValues[idx].Value.getKind(),
                    .value = Arg,
                },
            };

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

                if (R == .Internal)
                    R = (try R.getValue(&L.Value.getKind())).*;
                if (L == .Internal)
                    L = (try L.getValue(&R.Value.getKind())).*;

                if (!L.Value.getKind().sameType(&R.Value.getKind())) {
                    std.log.err("{s} {s}", .{ try R.Value.getKind().getName(), try L.Value.getKind().getName() });

                    return error.InvalidCMP;
                }

                var adds = try allocator.alloc.create(ValueData);
                adds.* = .{
                    .llvm = .{
                        .kind = .{
                            .aType = TheContext.intType(1),
                            .name = "bool",
                        },
                        .value = Builder.buildICmp(.EQ, R.Value.getValue(), L.Value.getValue(), "neqtmp"),
                    },
                };

                try values.append(.{ .Value = adds });
            },
            'c' => {
                var top = values.pop();

                switch (top) {
                    .Function => |funcdat| {
                        var args = try allocator.alloc.alloc(*const TypeData, funcdat.args.len);
                        for (args, 0..) |_, idx| {
                            var val = values.items[values.items.len - args.len + idx];
                            switch (val) {
                                .Value => {
                                    args[idx] = &val.Value.getKind();
                                },
                                .Type => {
                                    args[idx] = getNamed("type").?.Type;
                                },
                                else => return error.Invalid,
                            }
                        }

                        var func = try funcdat.implement(args);

                        var params = try allocator.alloc.alloc(*const llvmlib.Value, func.args.len);
                        for (params, 0..) |_, idx| {
                            var val = try values.pop().getValue(func.args[params.len - idx - 1]);

                            params[params.len - idx - 1] = val.Value.getValue();
                            if (!val.Value.getKind().sameType(func.args[params.len - idx - 1])) {
                                std.log.err("{s}, {s}, anon", .{ try val.Value.getKind().getName(), try func.args[params.len - idx - 1].getName() });
                                return error.TypeMismatch;
                            }
                        }

                        var adds = try allocator.alloc.create(ValueData);
                        adds.* = .{
                            .llvm = .{
                                .value = Builder.buildCall(func.kind, func.val, @as([*]const *llvmlib.Value, @ptrCast(params)), @as(c_uint, @intCast(func.args.len)), "calltmp"),
                                .kind = undefined,
                            },
                        };

                        if (func.rets != null) {
                            adds.llvm.kind = func.rets.?.*;
                            try values.append(.{ .Value = adds });
                        }
                    },
                    .Value => |value| {
                        var val = value.getKind().data.?.Pointer;

                        var func: FunctionType = undefined;
                        var atype: *llvmlib.Type = undefined;
                        if (val.data.? == .Pointer) {
                            atype = val.data.?.Pointer.aType.?;
                            func = val.data.?.Pointer.data.?.Function;
                        } else {
                            atype = val.aType.?;
                            func = val.data.?.Function;
                        }

                        var params = try allocator.alloc.alloc(*llvmlib.Value, func.args.len);
                        for (params, 0..) |_, idx| {
                            var paramVal = try values.pop().getValue(func.args[params.len - idx - 1]);

                            params[params.len - idx - 1] = paramVal.Value.getValue();
                            if (!paramVal.Value.getKind().sameType(func.args[params.len - idx - 1])) {
                                std.log.err("{s}, {s}, anon", .{ try paramVal.Value.getKind().getName(), try func.args[params.len - idx - 1].getName() });
                                return error.TypeMismatch;
                            }
                        }

                        var adds = try allocator.alloc.create(ValueData);

                        adds.* = .{
                            .llvm = .{
                                .value = Builder.buildCall(atype, value.getValue(), @as([*]const *llvmlib.Value, @ptrCast(params)), @as(c_uint, @intCast(func.args.len)), "calltmp"),
                                .kind = undefined,
                            },
                        };

                        if (func.rets != null) {
                            adds.llvm.kind = func.rets.?.*;
                            try values.append(.{ .Value = adds });
                        }
                    },
                    else => return error.invalidType,
                }
            },
            'n' => {
                var R = values.pop();
                var L = values.pop();

                if (R == .Internal)
                    R = (try R.getValue(&L.Value.getKind())).*;
                if (L == .Internal)
                    L = (try L.getValue(&R.Value.getKind())).*;

                if (!L.Value.getKind().sameType(&R.Value.getKind())) return error.InvalidCMP;

                var adds = try allocator.alloc.create(ValueData);
                adds.* = .{
                    .llvm = .{
                        .kind = .{
                            .aType = TheContext.intType(1),
                            .name = "bool",
                        },
                        .value = Builder.buildICmp(.NE, R.Value.getValue(), L.Value.getValue(), "eqtmp"),
                    },
                };

                try values.append(.{ .Value = adds });
            },
            '!' => {
                var R = values.pop();

                switch (R) {
                    .Type => |kind| {
                        var adds = try allocator.alloc.create(TypeData);
                        adds.* = .{
                            .aType = TheContext.pointerType(0),
                            .name = "err",
                            .data = .{
                                .Error = kind,
                            },
                        };

                        try values.append(.{ .Type = adds });
                    },
                    .Value => {
                        if (R.Value.getKind().data != null and R.Value.getKind().data.? == .Error) {
                            var adds = try allocator.alloc.create(ValueData);
                            adds.* = .{
                                .llvm = .{
                                    .kind = R.Value.getKind().data.?.Error.*,
                                    .value = Builder.buildExtractValue(R.Value.getValue(), 1, "trytmp"),
                                },
                            };

                            try values.append(.{ .Value = adds });
                        } else {
                            if (!R.Value.getKind().sameType(try getType("bool"))) return error.InvalidCMP;

                            var adds = try allocator.alloc.create(ValueData);
                            adds.* = .{
                                .llvm = .{
                                    .kind = .{
                                        .aType = TheContext.intType(1),
                                        .name = "bool",
                                    },
                                    .value = Builder.buildNot(R.Value.getValue(), "nottmp"),
                                },
                            };

                            try values.append(.{ .Value = adds });
                        }
                    },
                    else => return error.Invalid,
                }
            },
            '\'' => {
                var Target = values.pop();
                var Value = try values.pop().getValue(Target.Type);

                const adds = try allocator.alloc.create(ValueData);
                adds.* = .{
                    .llvm = .{
                        .kind = Target.Type.*,
                        .value = Value.Value.getValue(),
                    },
                };

                try values.append(.{ .Value = adds });
            },
            '=' => {
                var R = values.pop();
                var L = values.pop();

                if (R == .Internal)
                    R = (try R.getValue(L.Value.getKind().data.?.Pointer)).*;

                if (!L.Value.getKind().data.?.Pointer.sameType(&R.Value.getKind())) {
                    std.log.info("{s} {s}", .{ try L.Value.getKind().data.?.Pointer.getName(), try R.Value.getKind().getName() });
                    std.log.info("{s}", .{TheFunction.?.name});

                    return error.InvalidAssign;
                }

                _ = Builder.buildStore(R.Value.getValue(), L.Value.getValue());
            },
            '@' => {
                var Val = values.pop();

                if (Val.Value.getKind().data != null and Val.Value.getKind().data.? == .Pointer) {
                    var adds = try allocator.alloc.create(ValueData);
                    adds.* = .{
                        .llvm = .{
                            .kind = Val.Value.getKind().data.?.Pointer.*,
                            .value = Builder.buildLoad(Val.Value.getKind().data.?.Pointer.*.aType.?, Val.Value.getValue(), "readtmp"),
                        },
                    };
                    try values.append(.{ .Value = adds });
                } else if (Val.Value.getKind().data != null and Val.Value.getKind().data.? == .Reference) {
                    //var adds = try allocator.alloc.create(ValueData);
                    //adds.* = .{
                    //    .llvm = .{
                    //        .kind = Val.Value.getKind().data.?.Pointer.*,
                    //        .value = Builder.buildLoad(Val.Value.getKind().data.?.Reference.*.aType.?, Val.Value.getValue(), "readtmp"),
                    //    },
                    //};
                    //try values.append(.{ .Value = adds });
                    std.log.info("todo deref {s}", .{Val.Value.getKind().name});

                    return error.Invalid;
                } else {
                    std.log.info("{s}", .{Val.Value.getKind().name});

                    return error.Invalid;
                }
            },
            '$' => {
                var Type = values.pop();

                switch (Type) {
                    .Type => {
                        var adds = try allocator.alloc.create(TypeData);
                        adds.* = .{
                            .aType = Type.Type.aType.?.arrayType(1),
                            .name = "array",
                            .data = .{
                                .Array = Type.Type,
                            },
                        };

                        try values.append(.{ .Type = adds });
                    },
                    .Value, .Internal => {
                        var R = values.pop();

                        var Indices: [*]const *llvmlib.Value = &[_]*llvmlib.Value{(try Type.getValue(try getType("i32"))).Value.getValue()};

                        var adds = try allocator.alloc.create(ValueData);
                        adds.* = .{
                            .llvm = .{
                                .kind = .{
                                    .aType = TheContext.pointerType(0),
                                    .name = "ptr",
                                    .data = .{
                                        .Pointer = R.Value.getKind().data.?.Pointer.data.?.Array,
                                    },
                                },
                                .value = Builder.buildInBoundsGEP(
                                    R.Value.getKind().data.?.Pointer.aType.?,
                                    R.Value.getValue(),
                                    Indices,
                                    1,
                                    "idxtmp",
                                ),
                            },
                        };

                        try values.append(.{ .Value = adds });
                    },
                    else => return error.Invalid,
                }
            },
            '&' => {
                var Val = values.pop();

                switch (Val) {
                    .Type => {
                        var adds = try allocator.alloc.create(TypeData);
                        adds.* = .{
                            .aType = TheContext.pointerType(0),
                            .name = "ref",
                            .data = .{
                                .Reference = Val.Type,
                            },
                        };

                        try values.append(.{ .Type = adds });
                    },
                    else => return error.InvalidParam,
                }
            },
            '*' => {
                var Val = values.pop();

                switch (Val) {
                    .Type => {
                        var adds = try allocator.alloc.create(TypeData);
                        adds.* = .{
                            .aType = TheContext.pointerType(0),
                            .name = "ptr",
                            .data = .{
                                .Pointer = Val.Type,
                            },
                        };

                        try values.append(.{ .Type = adds });
                    },
                    .Value, .Internal => {
                        var L = values.pop();

                        if (Val == .Internal)
                            Val = (try Val.getValue(&L.Value.getKind())).*;
                        if (L == .Internal)
                            L = (try L.getValue(&Val.Value.getKind())).*;

                        var val: *llvmlib.Value = undefined;
                        if (std.mem.eql(u8, Val.Value.getKind().name, "f32")) {
                            val = Builder.buildFMul(L.Value.getValue(), Val.Value.getValue(), "multmp");
                        } else {
                            val = Builder.buildMul(L.Value.getValue(), Val.Value.getValue(), "multmp");
                        }

                        var adds = try allocator.alloc.create(ValueData);
                        adds.* = .{
                            .llvm = .{
                                .kind = Val.Value.getKind(),
                                .value = val,
                            },
                        };

                        try values.append(.{ .Value = adds });
                    },
                    else => return error.InvalidParam,
                }
            },
            '-' => {
                var R = values.pop();
                var L = values.pop();

                if (R == .Internal)
                    R = (try R.getValue(&L.Value.getKind())).*;
                if (L == .Internal)
                    L = (try L.getValue(&R.Value.getKind())).*;

                var val: *llvmlib.Value = undefined;
                if (std.mem.eql(u8, R.Value.getKind().name, "f32")) {
                    val = Builder.buildFSub(L.Value.getValue(), R.Value.getValue(), "subtmp");
                } else {
                    val = Builder.buildSub(L.Value.getValue(), R.Value.getValue(), "subtmp");
                }

                var adds = try allocator.alloc.create(ValueData);
                adds.* = .{
                    .llvm = .{
                        .kind = R.Value.getKind(),
                        .value = val,
                    },
                };

                try values.append(.{ .Value = adds });
            },
            'A' => {
                var R = values.pop();
                var L = values.pop();

                if (R == .Internal)
                    R = (try R.getValue(&L.Value.getKind())).*;
                if (L == .Internal)
                    L = (try L.getValue(&R.Value.getKind())).*;

                var adds = try allocator.alloc.create(ValueData);
                adds.* = .{
                    .llvm = .{
                        .kind = R.Value.getKind(),
                        .value = Builder.buildAnd(L.Value.getValue(), R.Value.getValue(), "subtmp"),
                    },
                };

                try values.append(.{ .Value = adds });
            },
            '^' => {
                var R = values.pop();
                var L = values.pop();

                if (R == .Internal)
                    R = (try R.getValue(&L.Value.getKind())).*;
                if (L == .Internal)
                    L = (try L.getValue(&R.Value.getKind())).*;

                var adds = try allocator.alloc.create(ValueData);
                adds.* = .{
                    .llvm = .{
                        .kind = R.Value.getKind(),
                        .value = Builder.buildXor(L.Value.getValue(), R.Value.getValue(), "xortmp"),
                    },
                };

                try values.append(.{ .Value = adds });
            },
            '/' => {
                var R = values.pop();
                var L = values.pop();

                if (R == .Internal)
                    R = (try R.getValue(&L.Value.getKind())).*;
                if (L == .Internal)
                    L = (try L.getValue(&R.Value.getKind())).*;

                var val: *llvmlib.Value = undefined;
                if (std.mem.eql(u8, R.Value.getKind().name, "f32")) {
                    val = Builder.buildFDiv(L.Value.getValue(), R.Value.getValue(), "divtmp");
                } else {
                    val = Builder.buildUDiv(L.Value.getValue(), R.Value.getValue(), "divtmp");
                }

                var adds = try allocator.alloc.create(ValueData);
                adds.* = .{
                    .llvm = .{
                        .kind = R.Value.getKind(),
                        .value = val,
                    },
                };

                try values.append(.{ .Value = adds });
            },
            'L' => {
                var R = values.pop();
                var L = values.pop();

                if (R == .Internal)
                    R = (try R.getValue(&L.Value.getKind())).*;
                if (L == .Internal)
                    L = (try L.getValue(&R.Value.getKind())).*;

                var adds = try allocator.alloc.create(ValueData);
                adds.* = .{
                    .llvm = .{
                        .kind = R.Value.getKind(),
                        .value = Builder.buildShl(L.Value.getValue(), R.Value.getValue(), "subtmp"),
                    },
                };

                try values.append(.{ .Value = adds });
            },
            'R' => {
                var R = values.pop();
                var L = values.pop();

                if (R == .Internal)
                    R = (try R.getValue(&L.Value.getKind())).*;
                if (L == .Internal)
                    L = (try L.getValue(&R.Value.getKind())).*;

                var adds = try allocator.alloc.create(ValueData);
                adds.* = .{
                    .llvm = .{
                        .kind = R.Value.getKind(),
                        .value = Builder.buildLShr(L.Value.getValue(), R.Value.getValue(), "subtmp"),
                    },
                };

                try values.append(.{ .Value = adds });
            },
            'O' => {
                var R = values.pop();
                var L = values.pop();

                if (R == .Internal)
                    R = (try R.getValue(&L.Value.getKind())).*;
                if (L == .Internal)
                    L = (try L.getValue(&R.Value.getKind())).*;

                var adds = try allocator.alloc.create(ValueData);
                adds.* = .{
                    .llvm = .{
                        .kind = R.Value.getKind(),
                        .value = Builder.buildOr(L.Value.getValue(), R.Value.getValue(), "ortmp"),
                    },
                };

                try values.append(.{ .Value = adds });
            },
            '<' => {
                var R = values.pop();
                var L = values.pop();

                if (R == .Internal)
                    R = (try R.getValue(&L.Value.getKind())).*;
                if (L == .Internal)
                    L = (try L.getValue(&R.Value.getKind())).*;

                var val: *llvmlib.Value = undefined;
                if (std.mem.eql(u8, R.Value.getKind().name, "f32")) {
                    val = Builder.buildFCmp(.ULE, L.Value.getValue(), R.Value.getValue(), "lttmp");
                } else {
                    val = Builder.buildICmp(.ULT, L.Value.getValue(), R.Value.getValue(), "lttmp");
                }

                var adds = try allocator.alloc.create(ValueData);
                adds.* = .{
                    .llvm = .{
                        .kind = .{
                            .aType = TheContext.intType(1),
                            .name = "bool",
                        },
                        .value = val,
                    },
                };

                try values.append(.{ .Value = adds });
            },
            '>' => {
                var R = values.pop();
                var L = values.pop();

                if (R == .Internal)
                    R = (try R.getValue(&L.Value.getKind())).*;
                if (L == .Internal)
                    L = (try L.getValue(&R.Value.getKind())).*;

                var val: *llvmlib.Value = undefined;
                if (std.mem.eql(u8, R.Value.getKind().name, "f32")) {
                    val = Builder.buildFCmp(.UGE, L.Value.getValue(), R.Value.getValue(), "gttmp");
                } else {
                    val = Builder.buildICmp(.UGT, L.Value.getValue(), R.Value.getValue(), "gttmp");
                }

                var adds = try allocator.alloc.create(ValueData);
                adds.* = .{
                    .llvm = .{
                        .kind = .{
                            .aType = TheContext.intType(1),
                            .name = "bool",
                        },
                        .value = val,
                    },
                };

                try values.append(.{ .Value = adds });
            },
            '+' => {
                var R = values.pop();
                var L = values.pop();

                if (R == .Internal)
                    R = (try R.getValue(&L.Value.getKind())).*;
                if (L == .Internal)
                    L = (try L.getValue(&R.Value.getKind())).*;

                var val: *llvmlib.Value = undefined;
                if (std.mem.eql(u8, R.Value.getKind().name, "f32")) {
                    val = Builder.buildFAdd(L.Value.getValue(), R.Value.getValue(), "addtmp");
                } else {
                    val = Builder.buildAdd(L.Value.getValue(), R.Value.getValue(), "addtmp");
                }

                var adds = try allocator.alloc.create(ValueData);
                adds.* = .{
                    .llvm = .{
                        .kind = R.Value.getKind(),
                        .value = val,
                    },
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
                    .aType = TheContext.pointerType(0),
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
            '!' => {
                var bak = try allocator.alloc.create(TypeData);

                bak.* = values.items[values.items.len - 1].kind;

                values.items[values.items.len - 1].kind = .{
                    .aType = TheContext.pointerType(0),
                    .name = "err",
                    .data = .{
                        .Error = bak,
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
            var A = try values.pop().getValue(TheFunction.?.rets.?);
            _ = Builder.buildRet(A.Value.getValue());
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
        } else if (try getFunction(self.value, values)) |func| {
            var params = try allocator.alloc.alloc(*llvmlib.Value, func.args.len);
            for (params, 0..) |_, idx| {
                var val = try values.pop().getValue(func.args[params.len - idx - 1]);

                params[params.len - idx - 1] = val.Value.getValue();
                if (!val.Value.getKind().sameType(func.args[params.len - idx - 1])) {
                    std.log.info("{s}, {s}, {s}", .{ try val.Value.getKind().getName(), try func.args[params.len - idx - 1].getName(), self.value });
                    return error.TypeMismatch;
                }
            }

            var adds = try allocator.alloc.create(ValueData);

            adds.* = .{
                .llvm = .{
                    .value = Builder.buildCall(func.kind, func.val, params.ptr, @as(c_uint, @intCast(params.len)), "calltmp"),
                    .kind = undefined,
                },
            };

            if (func.rets != null) {
                adds.llvm.kind = func.rets.?.*;
                try values.append(.{ .Value = adds });
            }
        } else if (getNamed(self.value)) |value| {
            try values.append(value);
        } else if (values.items.len == 0) {
            std.log.info("{s}", .{self.value});

            return error.Undefined;
        } else if (values.getLast() == .Type) {
            var kind = values.pop().Type;

            var alloca = Builder.buildAlloca(kind.aType.?, @as([*:0]const u8, @ptrCast(self.value)));

            var adds = try allocator.alloc.create(ValueData);
            adds.* = .{
                .llvm = .{
                    .value = alloca,
                    .kind = .{
                        .aType = TheContext.pointerType(0),
                        .name = "ptr",
                        .data = .{
                            .Pointer = kind,
                        },
                    },
                },
            };

            try locals.append(self.value);

            try named.put(self.value, .{ .Value = adds });
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
            if (values.items.len == 0) {
                std.log.info("{s}", .{self.value});
                return error.NoTypeToName;
            }
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
        for (self.body, 0..) |_, idx| {
            try self.body[idx].codegen(values);
        }
    }

    pub fn typegen(self: *Self, values: *StructData) !void {
        for (self.body, 0..) |_, idx| {
            try self.body[idx].typegen(values);
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
        if (getNamed(self.name)) |func| {
            if (func == .Function) {
                return func.Function;
            }
            return error.Defined;
        }

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

        var input = try allocator.alloc.alloc(*llvmlib.Type, argsTypes.items.len);
        var generic: bool = false;

        for (argsTypes.items, 0..) |item, idx| {
            if (item.kind.aType) |aType| {
                input[idx] = aType;
            } else {
                generic = true;
                break;
            }
        }

        var kind = retsTypes.items[0].kind.aType;
        var akind = kind;

        if (kind == null) {
            akind = TheContext.voidType();
        }

        var data = try allocator.alloc.create(FunctionData);

        var args = try allocator.alloc.alloc(*TypeData, input.len);
        for (args, 0..) |_, idx| {
            args[idx] = try allocator.alloc.create(TypeData);
            args[idx].* = argsTypes.items[idx].kind;
        }

        if (!generic) {
            var functionType = llvmlib.functionType(akind.?, @as([*]const *llvmlib.Type, @ptrCast(input)), @as(c_uint, @intCast(input.len)), .False);

            var function = llvmlib.Module.addFunction(TheModule, @as([*:0]const u8, @ptrCast(self.name)), functionType);
            data.* = .{
                .name = self.name,
                .ext = function,
                .body = null,
                .rets = null,
                .args = args,
                .impls = try allocator.alloc.alloc(FunctionImpl, 0),
            };
        } else {
            data.* = .{
                .name = self.name,
                .ext = null,
                .body = null,
                .rets = null,
                .args = args,
                .impls = try allocator.alloc.alloc(FunctionImpl, 0),
            };
        }

        if (retsTypes.items[0].kind.aType != null) {
            data.rets = &retsTypes.items[0].kind;
        }

        if (!std.mem.eql(u8, self.name, "anon")) {
            try named.put(self.name, .{ .Function = data });
        }

        return data;
    }
};

pub const DefinitionAST = struct {
    const Self = @This();

    proto: PrototypeAST,
    body: *ExpressionAST,

    pub fn codegen(self: *Self) !void {
        var function = try self.proto.codegen();
        if (function.ext != null) {
            function.ext.?.deleteFunction();
            function.ext = null;
        }

        function.body = self.body;

        //TheFunction = function;

        //var bb = TheContext.appendBasicBlock(function.val, "entry");
        //Builder.positionBuilderAtEnd(bb);

        //var values = ValueStack.init(allocator.alloc);

        //for (function.args) |_, idx| {
        //    var param = function.val.getParam(@intCast(c_uint, idx));
        //    var value = try allocator.alloc.create(ValueData);
        //    value.* = .{
        //        .kind = function.args[idx].*,
        //        .value = param,
        //    };

        //    try values.append(.{
        //        .Value = value,
        //    });
        //}

        //try self.body.codegen(&values);

        //for (locals.items) |item| {
        //    _ = named.remove(item);
        //}

        //if (values.items.len == 1) {
        //    var val = try values.items[0].getValue(function.rets.?);

        //    if (!val.Value.kind.sameType(function.rets.?)) {
        //        std.log.info("{s}", .{self.proto.name});
        //        return error.ReturnMismatch;
        //    }

        //    _ = Builder.buildRet(val.Value.value);

        //    return function.val;
        //} else if (values.items.len == 0) {
        //    if (function.rets != null) {
        //        std.log.info("{s}", .{self.proto.name});
        //        return error.ReturnMismatch;
        //    }

        //    _ = Builder.buildRetVoid();

        //    return function.val;
        //}

        //std.log.info("{s}: {any}, {}", .{ self.proto.name, values.items, values.items.len });

        //return error.Unknown;
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

    pub fn codegen(self: *Self) !void {
        _ = try self.proto.codegen();
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

        var types = try allocator.alloc.alloc(*llvmlib.Type, values.items.len);

        for (values.items, 0..) |item, idx| {
            types[idx] = item.kind.aType.?;
        }

        var structType = TheContext.structCreateNamed(@as([*:0]const u8, @ptrCast(self.name)));
        structType.structSetBody(types.ptr, @as(c_uint, @intCast(types.len)), .False);
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

pub const ConstAST = struct {
    const Self = @This();

    name: []const u8,
    value: *ExpressionAST,

    pub fn codegen(self: *Self) !void {
        var valueTypes = std.ArrayList(StackEntry).init(allocator.alloc);
        try self.value.codegen(&valueTypes);
        try named.put(
            self.name,
            valueTypes.items[0],
        );
    }

    pub fn parse(toks: *TokenList) !Self {
        var result: Self = undefined;

        _ = toks.orderedRemove(0);

        result.name = toks.orderedRemove(0).value;
        result.value = try ExpressionAST.parse(toks);

        return result;
    }
};

pub const GlobalAST = struct {
    const Self = @This();

    name: []const u8,
    kind: []ExpressionAST,

    pub fn codegen(self: *Self) !void {
        var kindTypes = std.ArrayList(StructEntry).init(allocator.alloc);
        for (self.kind) |*prop| {
            try prop.typegen(&kindTypes);
        }

        if (kindTypes.items.len != 1) return error.Unknown;

        var global = try allocator.alloc.create(ValueData);
        global.* = .{
            .llvm = .{
                .value = TheModule.addGlobal(kindTypes.items[0].kind.aType.?, "globalPtr"),
                .kind = .{
                    .aType = TheContext.pointerType(0),
                    .name = "ptr",
                    .data = .{
                        .Pointer = &kindTypes.items[0].kind,
                    },
                },
            },
        };

        std.log.info("{s}", .{try global.getKind().getName()});

        global.getValue().setInitializer(kindTypes.items[0].kind.aType.?.constNull());

        try named.put(self.name, .{ .Value = global });
    }

    pub fn parse(toks: *TokenList) !Self {
        var result: Self = undefined;

        _ = toks.orderedRemove(0);

        result.name = toks.orderedRemove(0).value;
        result.kind = try allocator.alloc.alloc(ExpressionAST, 0);

        while (true) {
            var expr = ExpressionAST.parse(toks) catch null;
            if (expr == null) break;

            result.kind = try allocator.alloc.realloc(result.kind, result.kind.len + 1);

            result.kind[result.kind.len - 1] = expr.?.*;

            if (toks.items[0].value.len > 1 or toks.items[0].value[0] == '{') break;
        }

        return result;
    }
};
