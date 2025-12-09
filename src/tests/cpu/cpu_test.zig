const std = @import("std");
const Memory = @import("../../memory/memory.zig").Memory;
const Cpu = @import("../../cpu/cpu.zig").Cpu;

test "executeInstruction" {
    var memory = Memory.init();
    var cpu = Cpu.init(&memory);

    cpu.pc = 0;
    memory.writeByte(0, 0x01);
    memory.writeByte(1, 0xAB);
    memory.writeByte(2, 0xCD);
    memory.writeByte(3, 0xCB);
    memory.writeByte(4, 0x80);

    cpu.executeInstruction();
    try std.testing.expect(cpu.registers.getBC() == 0xCDAB);
    try std.testing.expect(cpu.pc == 3);

    cpu.executeInstruction();
    try std.testing.expect(cpu.registers.b == 0xCC);
    try std.testing.expect(cpu.pc == 5);
}
