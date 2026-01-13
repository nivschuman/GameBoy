pub const registers_test = @import("tests/cpu/registers/registers_test.zig");
pub const cpu_test = @import("tests/cpu/cpu_test.zig");
pub const instructions_test = @import("tests/cpu/instructions_test.zig");
pub const memory_test = @import("tests/mmu/memory/memory_test.zig");
pub const cartridge_test = @import("tests/cartridge/cartridge_test.zig");
pub const interrupts_test = @import("tests/io/interrupts/interrupts_test.zig");
pub const timer_test = @import("tests/io/timer/timer_test.zig");
pub const tiles_test = @import("tests/ppu/vram/tiles/tiles_test.zig");
pub const ppu_test = @import("tests/ppu/ppu_test.zig");

test "tests entry" {
    @import("std").testing.refAllDecls(@This());
}
