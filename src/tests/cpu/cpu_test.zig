const std = @import("std");
const Mmu = @import("../../mmu/mmu.zig").Mmu;
const Cartridge = @import("../../cartridge/cartridge.zig").Cartridge;
const Cpu = @import("../../cpu/cpu.zig").Cpu;

test "executeInstruction" {
    var rom: [0x8000]u8 = [_]u8{0} ** 0x8000;
    var cart = Cartridge.init(rom[0..]);
    var mmu = Mmu.init(&cart);
    var cpu = Cpu.init(&mmu);

    cpu.pc = 0;
    mmu.writeByte(0, 0x01);
    mmu.writeByte(1, 0xAB);
    mmu.writeByte(2, 0xCD);
    mmu.writeByte(3, 0xCB);
    mmu.writeByte(4, 0x80);

    cpu.executeInstruction();
    try std.testing.expect(cpu.registers.getBC() == 0xCDAB);
    try std.testing.expect(cpu.pc == 3);

    cpu.executeInstruction();
    try std.testing.expect(cpu.registers.b == 0xCC);
    try std.testing.expect(cpu.pc == 5);
}
