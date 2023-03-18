const std = @import("std");

const builtin = @import("builtin");
pub const useclib = true;

pub var gpa = std.heap.GeneralPurposeAllocator(.{.stack_trace_frames = 10}){};
pub const alloc = if(!builtin.link_libc or !useclib) gpa.allocator() else std.heap.c_allocator;
