const std = @import("std");

pub fn main() !void {
    const x = 10;
    std.log.info("Hello World: {}", .{x});
}
