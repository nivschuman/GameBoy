const std = @import("std");
const Memory = @import("../../mmu/memory/memory.zig").Memory;

test "Memory write and read a byte" {
    var memory = Memory(0x2000).init();
    const address: u16 = 0x1000;
    const value: u16 = 0xAB;

    memory.writeByte(address, value);
    try std.testing.expect(memory.readByte(address) == 0xAB);
}
