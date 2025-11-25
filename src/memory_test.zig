const std = @import("std");
const Memory = @import("memory.zig").Memory;

test "Memory write and read a word" {
    var memory = Memory.init();

    const address: u16 = 0x1000;
    const value: u16 = 0xABCD;

    memory.writeWord(address, value);

    try std.testing.expect(memory.readByte(address) == 0xCD);
    try std.testing.expect(memory.readByte(address + 1) == 0xAB);

    const read_value = memory.readWord(address);
    try std.testing.expect(read_value == value);
}
