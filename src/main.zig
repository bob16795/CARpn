const std = @import("std");
const llvm = @import("llvm.zig");
const parser = @import("parser.zig");
const allocator = @import("allocator.zig");
const token = @import("token.zig");

pub fn parseTokens(input: []const u8) !std.ArrayList(token.Token) {
    var result = std.ArrayList(token.Token).init(allocator.alloc);

    var file = try std.fs.cwd().openFile(input, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    while (in_stream.readByte() catch null) |byte| {
        if (std.ascii.isWhitespace(byte)) {
            continue;
        }

        if (std.ascii.isAlphabetic(byte)) {
            var name = try allocator.alloc.alloc(u8, 1);
            name[0] = byte;

            var appendCh: ?u8 = null;

            while (in_stream.readByte() catch null) |subbyte| {
                if (!std.ascii.isAlphanumeric(subbyte)) {
                    if (!std.ascii.isWhitespace(subbyte))
                        appendCh = subbyte;
                    break;
                }
                name = try allocator.alloc.realloc(name, name.len + 1);
                name[name.len - 1] = subbyte;
            }

            var appends = token.Token{
                .type = .Ident,
                .value = name,
            };

            if (std.mem.eql(u8, name, "proc")) appends.type = .Proc;
            if (std.mem.eql(u8, name, "var")) appends.type = .Var;
            if (std.mem.eql(u8, name, "def")) appends.type = .Def;
            if (std.mem.eql(u8, name, "if")) appends.type = .If;
            if (std.mem.eql(u8, name, "do")) appends.type = .Do;
            if (std.mem.eql(u8, name, "struct")) appends.type = .Struct;
            if (std.mem.eql(u8, name, "alias")) appends.type = .Alias;
            if (std.mem.eql(u8, name, "extern")) appends.type = .Extern;

            name = try allocator.alloc.realloc(name, name.len + 1);
            name[name.len - 1] = 0;

            appends.value = name[0 .. name.len - 1];

            try result.append(appends);

            if (appendCh) |append| {
                var adds = try allocator.alloc.alloc(u8, 1);
                adds[0] = append;

                try result.append(.{
                    .type = .Op,
                    .value = adds,
                });
            }

            continue;
        }

        if (byte == '"') {
            var name = try allocator.alloc.alloc(u8, 0);

            while (in_stream.readByte() catch null) |subbyte| {
                if (subbyte == '"') break;
                name = try allocator.alloc.realloc(name, name.len + 1);
                name[name.len - 1] = subbyte;
            }

            try result.append(.{
                .type = .String,
                .value = name,
            });

            continue;
        }

        if (std.ascii.isDigit(byte)) {
            var name = try allocator.alloc.alloc(u8, 1);
            name[0] = byte;

            while (in_stream.readByte() catch null) |subbyte| {
                if (!(std.ascii.isDigit(subbyte) or subbyte == '.')) break;
                name = try allocator.alloc.realloc(name, name.len + 1);
                name[name.len - 1] = subbyte;
            }

            try result.append(.{
                .type = .Number,
                .value = name,
            });

            continue;
        }

        if (byte == '#') {
            while (in_stream.readByte() catch null) |subbyte| {
                if (subbyte == '\n' or subbyte == '\r') break;
            }

            continue;
        }

        var name = try allocator.alloc.alloc(u8, 1);
        name[0] = byte;

        if (result.items[result.items.len - 1].value[0] == '=' and name[0] == '=') {
            result.items[result.items.len - 1].value = "q";
            continue;
        }

        try result.append(.{
            .type = .Op,
            .value = name,
        });
    }

    return result;
}

pub fn main() !void {
    llvm.LLVMInitializeX86TargetInfo();
    llvm.LLVMInitializeX86Target();
    llvm.LLVMInitializeX86TargetMC();
    llvm.LLVMInitializeX86AsmParser();
    llvm.LLVMInitializeX86AsmPrinter();

    parser.TheContext = llvm.Context.create();
    parser.TheModule = llvm.Module.createWithName("Context", parser.TheContext);
    parser.Builder = parser.TheContext.createBuilder();

    parser.named = std.StringHashMap(parser.StackEntry).init(allocator.alloc);

    var Types: [8]parser.TypeData = undefined;
    Types = [_]parser.TypeData{
        .{ .name = "void", .aType = null },
        .{ .name = "i8", .aType = parser.TheContext.intType(8) },
        .{ .name = "i16", .aType = parser.TheContext.intType(16) },
        .{ .name = "i32", .aType = parser.TheContext.intType(32) },
        .{ .name = "i64", .aType = parser.TheContext.intType(64) },
        .{ .name = "f64", .aType = parser.TheContext.doubleType() },
        .{ .name = "ptr", .aType = parser.TheContext.pointerType(5), .data = .{ .Pointer = &Types[0] } },
        .{ .name = "bool", .aType = parser.TheContext.intType(1) },
    };

    var nullValue: parser.ValueData = .{
        .kind = Types[6],
        .value = llvm.Type.constInt(parser.TheContext.intType(64), 0, .False),
    };

    try parser.named.put("null", .{
        .Value = &nullValue,
    });

    try parser.named.put("void", .{
        .Type = &Types[0],
    });
    try parser.named.put("ptr", .{
        .Type = &Types[6],
    });
    try parser.named.put("bool", .{
        .Type = &Types[7],
    });
    try parser.named.put("i8", .{
        .Type = &Types[1],
    });
    try parser.named.put("i16", .{
        .Type = &Types[2],
    });
    try parser.named.put("i32", .{
        .Type = &Types[3],
    });
    try parser.named.put("i64", .{
        .Type = &Types[4],
    });
    try parser.named.put("u8", .{
        .Type = &Types[1],
    });
    try parser.named.put("u16", .{
        .Type = &Types[2],
    });
    try parser.named.put("u32", .{
        .Type = &Types[3],
    });
    try parser.named.put("u64", .{
        .Type = &Types[4],
    });
    try parser.named.put("f64", .{
        .Type = &Types[5],
    });

    var toks = try parseTokens("test.car");

    while (toks.items.len != 0) {
        switch (toks.items[0].type) {
            .Def => {
                var def = try parser.DefinitionAST.parse(&toks);
                _ = try def.codegen();
            },
            .Extern => {
                var ext = try parser.ExternAST.parse(&toks);
                _ = try ext.codegen();
            },
            .Struct => {
                var str = try parser.StructAST.parse(&toks);
                _ = try str.codegen();
            },
            else => {
                return error.BadToken;
            },
        }
    }

    var str = parser.TheModule.printToString();

    std.log.info("{s}", .{str});

    const CPU: [*:0]const u8 = "generic";
    const features: [*:0]const u8 = "";
    const thriple: [*:0]const u8 = "x86_64-pc-linux-gnu";
    const out: [*:0]const u8 = "lol.o";
    var opt: ?*llvm.RelocMode = null;
    var t: *llvm.Target = undefined;
    var err: [*:0]const u8 = @ptrCast([*:0]const u8, try allocator.alloc.alloc(u8, 512));
    if (llvm.Target.getFromTriple(thriple, &t, &err).toBool()) {
        std.log.info("{s}", .{err});
    }

    var targetMachine = llvm.TargetMachine.create(t, thriple, CPU, features, opt, .Default);

    targetMachine.emitToFile(parser.TheModule, out, .ObjectFile);
}
