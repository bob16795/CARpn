const std = @import("std");
const llvmlib = @import("llvm.zig");
const parser = @import("parser.zig");
const allocator = @import("allocator.zig");

pub const RefValueData = struct {
    kind: parser.TypeData,
    value: *llvmlib.Value,

    pub fn getKind(self: *const RefValueData, ctx: *llvmlib.Context) !parser.TypeData {
        const typeClone = try allocator.alloc.create(parser.TypeData);
        typeClone.* = self.kind;

        const structEntries = try allocator.alloc.alloc(parser.StructEntry, 2);

        structEntries[0] = .{
            .name = "rc",
            .kind = .{
                .aType = ctx.intType(32),
                .name = "rc ptr",
            },
        };

        structEntries[1] = .{
            .name = "data",
            .kind = .{
                .aType = ctx.pointerType(0),
                .name = "data",
                .data = .{
                    .Pointer = typeClone,
                },
            },
        };

        const result = .{
            .aType = ctx.structType(
                @ptrCast(&.{
                    ctx.pointerType(0),
                    ctx.pointerType(0),
                }),
                2,
                .False,
            ),
            .name = "ref",
            .data = .{
                .Struct = try allocator.alloc.create(parser.StructTypeData),
            },
        };

        result.data.Struct.* = .{
            .entries = @ptrCast(structEntries),
            .children = std.StringHashMap(parser.StackEntry).init(allocator.alloc),
        };

        return result;
    }
};
