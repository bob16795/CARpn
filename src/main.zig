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

            var appendDot = false;

            while (in_stream.readByte() catch null) |subbyte| {
                if (!std.ascii.isAlphanumeric(subbyte)) {
                    if (subbyte == '.')
                        appendDot = true;
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
            if (std.mem.eql(u8, name, "struct")) appends.type = .Struct;
            if (std.mem.eql(u8, name, "extern")) appends.type = .Extern;

            try result.append(appends);

            if (appendDot)
                try result.append(.{
                    .type = .Op,
                    .value = ".",
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
    var Types = [_]parser.TypeData{
        .{ .aType = null },
        .{ .aType = parser.TheContext.intType(32) },
        .{ .aType = parser.TheContext.doubleType() },
    };

    try parser.named.put("void", .{
        .Type = &Types[0],
    });
    try parser.named.put("i32", .{
        .Type = &Types[1],
    });
    try parser.named.put("f64", .{
        .Type = &Types[2],
    });

    var toks = try parseTokens("test.abs");

    std.log.info("{any}", .{toks.items});

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
