pub const registers_test = @import("tests/cpu/registers/registers_test.zig");
pub const cpu_test = @import("tests/cpu/cpu_test.zig");
pub const instructions_test = @import("tests/cpu/instructions_test.zig");
pub const memory_test = @import("tests/memory/memory_test.zig");

test {
    @import("std").testing.refAllDecls(@This());
}
