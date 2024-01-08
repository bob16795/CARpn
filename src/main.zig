const std = @import("std");
const llvmlib = @import("llvm.zig");
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
                if (!std.ascii.isAlphanumeric(subbyte) and subbyte != '_') {
                    if (!std.ascii.isWhitespace(subbyte))
                        appendCh = subbyte;
                    break;
                }
                name = try allocator.alloc.realloc(name, name.len + 1);
                name[name.len - 1] = subbyte;
            }

            var appends = token.Token{
                .type = .Ident,
                .pos = try file.getPos(),
                .value = name,
            };

            if (std.mem.eql(u8, name, "proc")) appends.type = .Proc;
            if (std.mem.eql(u8, name, "var")) appends.type = .Var;
            if (std.mem.eql(u8, name, "def")) appends.type = .Def;
            if (std.mem.eql(u8, name, "if")) appends.type = .If;
            if (std.mem.eql(u8, name, "do")) appends.type = .Do;
            if (std.mem.eql(u8, name, "for")) appends.type = .For;
            if (std.mem.eql(u8, name, "struct")) appends.type = .Struct;
            if (std.mem.eql(u8, name, "macro")) appends.type = .Macro;
            if (std.mem.eql(u8, name, "extern")) appends.type = .Extern;
            if (std.mem.eql(u8, name, "lambda")) appends.type = .Lambda;
            if (std.mem.eql(u8, name, "fntype")) appends.type = .Func;
            if (std.mem.eql(u8, name, "err")) appends.type = .Error;
            if (std.mem.eql(u8, name, "global")) appends.type = .Global;
            if (std.mem.eql(u8, name, "const")) appends.type = .Const;

            name = try allocator.alloc.realloc(name, name.len + 1);
            name[name.len - 1] = 0;

            appends.value = name[0 .. name.len - 1];

            try result.append(appends);

            if (appendCh) |append| {
                var adds = try allocator.alloc.alloc(u8, 1);
                adds[0] = append;

                try result.append(.{
                    .type = .Op,
                    .pos = try file.getPos(),
                    .value = adds,
                });
            }

            continue;
        }

        if (byte == '(') {
            var name = try allocator.alloc.alloc(u8, 0);

            while (in_stream.readByte() catch null) |subbyte| {
                if (subbyte == ')') break;
                name = try allocator.alloc.realloc(name, name.len + 1);
                name[name.len - 1] = subbyte;
            }

            if (name.len == 0) {
                try result.append(.{
                    .type = .Op,
                    .pos = try file.getPos(),
                    .value = "c",
                });
            } else {
                try result.append(.{
                    .type = .Paren,
                    .pos = try file.getPos(),
                    .value = name,
                });
            }

            continue;
        }

        if (byte == '[') {
            var name = try allocator.alloc.alloc(u8, 0);

            while (in_stream.readByte() catch null) |subbyte| {
                if (subbyte == ']') break;
                name = try allocator.alloc.realloc(name, name.len + 1);
                name[name.len - 1] = subbyte;
            }

            if (name.len == 0) {
                try result.append(.{
                    .type = .Op,
                    .pos = try file.getPos(),
                    .value = "$",
                });
            } else {
                try result.append(.{
                    .type = .Bracket,
                    .pos = try file.getPos(),
                    .value = name,
                });
            }

            continue;
        }

        if (byte == '`') {
            var name = try allocator.alloc.alloc(u8, 0);

            while (in_stream.readByte() catch null) |subbyte| {
                if (subbyte == '`') break;
                name = try allocator.alloc.realloc(name, name.len + 1);
                name[name.len - 1] = subbyte;
            }

            try result.append(.{
                .type = .Ident,
                .pos = try file.getPos(),
                .value = name,
            });

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
                .pos = try file.getPos(),
                .value = name,
            });

            continue;
        }

        if (std.ascii.isDigit(byte) or byte == '-') {
            var name = try allocator.alloc.alloc(u8, 1);
            name[0] = byte;

            while (in_stream.readByte() catch null) |subbyte| {
                if (!(std.ascii.isDigit(subbyte) or subbyte == '.')) break;
                name = try allocator.alloc.realloc(name, name.len + 1);
                name[name.len - 1] = subbyte;
            }

            if (std.mem.eql(u8, name, "-")) {
                try result.append(.{
                    .type = .Op,
                    .pos = try file.getPos(),
                    .value = name,
                });
            } else {
                try result.append(.{
                    .type = .Number,
                    .pos = try file.getPos(),
                    .value = name,
                });
            }

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

        if (result.items[result.items.len - 1].value[0] == '!' and name[0] == '=') {
            result.items[result.items.len - 1].value = "n";
            continue;
        }

        if (result.items[result.items.len - 1].value[0] == '=' and name[0] == '=') {
            result.items[result.items.len - 1].value = "q";
            continue;
        }

        if (result.items[result.items.len - 1].value[0] == '&' and name[0] == '&') {
            result.items[result.items.len - 1].value = "A";
            continue;
        }

        if (result.items[result.items.len - 1].value[0] == '|' and name[0] == '|') {
            result.items[result.items.len - 1].value = "O";
            continue;
        }

        if (result.items[result.items.len - 1].value[0] == '<' and name[0] == '<') {
            result.items[result.items.len - 1].value = "L";
            continue;
        }

        if (result.items[result.items.len - 1].value[0] == '>' and name[0] == '>') {
            result.items[result.items.len - 1].value = "R";
            continue;
        }
        if (result.items[result.items.len - 1].value[0] == '=' and name[0] == '>') {
            result.items[result.items.len - 1].value = "N";
            continue;
        }

        try result.append(.{
            .type = .Op,
            .value = name,
            .pos = try file.getPos(),
        });
    }

    return result;
}

pub fn main() !void {
    llvmlib.LLVMInitializeWebAssemblyTargetInfo();
    llvmlib.LLVMInitializeWebAssemblyTarget();
    llvmlib.LLVMInitializeWebAssemblyTargetMC();
    llvmlib.LLVMInitializeWebAssemblyAsmParser();
    llvmlib.LLVMInitializeWebAssemblyAsmPrinter();

    parser.TheContext = llvmlib.Context.create();
    parser.TheModule = llvmlib.Module.createWithName("Context", parser.TheContext);
    parser.Builder = parser.TheContext.createBuilder();
    try parser.setupNamed();

    var args = try std.process.ArgIterator.initWithAllocator(allocator.alloc);

    _ = args.next();

    while (args.next()) |arg| {
        std.log.info("LEX {s}", .{arg});
        var toks = try parseTokens(arg);

        std.log.info("CAR {s}", .{arg});
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
                .Func => {
                    var ext = try parser.FuncTypeAST.parse(&toks);
                    _ = try ext.codegen();
                },
                .Struct => {
                    var str = try parser.StructAST.parse(&toks);
                    _ = try str.codegen();
                },
                .Const => {
                    var str = try parser.ConstAST.parse(&toks);
                    _ = try str.codegen();
                },
                .Global => {
                    var str = try parser.GlobalAST.parse(&toks);
                    _ = try str.codegen();
                },
                else => {
                    std.log.info("{s}", .{toks.items[0].value});
                    return error.BadToken;
                },
            }
        }
    }

    var values = parser.ValueStack.init(allocator.alloc);

    _ = try parser.getFunction("main", &values);
    var str = parser.TheModule.printToString();

    var file = try std.fs.cwd().createFile("tmp", .{});

    var writing: []const u8 = undefined;
    writing.ptr = @ptrCast(str);
    writing.len = 1;
    while (writing[writing.len - 1] != 0) writing.len += 1;
    writing.len -= 1;

    _ = try file.write(writing);

    file.close();

    std.log.info("LLVM lol.o", .{});

    const CPU: [*:0]const u8 = "";
    const features: [*:0]const u8 = "";
    //const thriple: [*:0]const u8 = "x86_64-pc-linux-gnu";
    const thriple: [*:0]const u8 = "wasm32-unknown-emscripten";
    const out: [*:0]const u8 = "lol.o";
    var opt: llvmlib.RelocMode = .Static;
    var t: *llvmlib.Target = undefined;
    var err: [*:0]const u8 = @as([*:0]const u8, @ptrCast(try allocator.alloc.alloc(u8, 512)));
    if (llvmlib.Target.getFromTriple(thriple, &t, &err) != .False) {
        std.log.info("{s}", .{err});
    }

    var targetMachine = llvmlib.TargetMachine.create(t, thriple, CPU, features, &opt, .Default);

    targetMachine.emitToFile(parser.TheModule, out, .ObjectFile);

    std.log.info("CC lol.o", .{});

    var output = try std.ChildProcess.exec(.{
        .allocator = allocator.alloc,
        .argv = &[_][]const u8{ "emcc", "-O0", "-static", "-lglfw", "-sALLOW_MEMORY_GROWTH=1", "-sINITIAL_MEMORY=2gb", "-sMAXIMUM_MEMORY=4gb", "-sASSERTIONS=2", "--preload-file", "resources@", "-ogame.html", "lol.o", "-Wall", "-sUSE_GLFW=3", "--shell-file", "shell.html", "-DPLATFORM_WEB", "test.c", "engine/stb_image.c" },
    });

    if (output.stdout.len != 0)
        std.log.info("{s}", .{output.stdout});
    if (output.stderr.len != 0)
        std.log.err("{s}", .{output.stderr});
}
