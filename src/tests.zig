pub const registers_test = @import("cpu/registers/registers_test.zig");
pub const cpu_test = @import("cpu/cpu_test.zig");
pub const instructions_test = @import("cpu/instructions_test.zig");
pub const memory_test = @import("memory/memory_test.zig");

test {
    @import("std").testing.refAllDecls(@This());
}
