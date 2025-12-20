const std = @import("std");
const Mmu = @import("../../mmu/mmu.zig").Mmu;
const memory = @import("../../mmu/memory/memory.zig");
const Cartridge = @import("../../cartridge/cartridge.zig").Cartridge;
const Cpu = @import("../../cpu/cpu.zig").Cpu;
const CycleManager = @import("../../cycles/cycles.zig").CycleManager;
const interrupts = @import("../../cpu/interrupts/interrupts.zig");

pub fn testWithCpu(testFunction: fn (*Cpu) anyerror!void) anyerror!void {
    var interrupt_registers = interrupts.InterruptRegisters.init();
    var rom: [0x8000]u8 = [_]u8{0} ** 0x8000;
    var cart = Cartridge.init(rom[0..]);
    var wram = memory.WRam.init();
    var hram = memory.HRam.init();
    var mmu = Mmu.init(&cart, &wram, &hram, &interrupt_registers);
    var cycle_manager = CycleManager.init();
    var cpu = Cpu.init(&mmu, &cycle_manager, &interrupt_registers);
    try testFunction(&cpu);
}

test "executeInstruction" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            cpu.pc = 0;
            cpu.mmu.writeByte(0, 0x01);
            cpu.mmu.writeByte(1, 0xAB);
            cpu.mmu.writeByte(2, 0xCD);
            cpu.mmu.writeByte(3, 0xCB);
            cpu.mmu.writeByte(4, 0x80);

            cpu.executeInstruction();
            try std.testing.expect(cpu.registers.getBC() == 0xCDAB);
            try std.testing.expect(cpu.pc == 3);

            cpu.executeInstruction();
            try std.testing.expect(cpu.registers.b == 0xCC);
            try std.testing.expect(cpu.pc == 5);
        }
    }.testFunction;
    try testWithCpu(testFunction);
}

test "executeInterrupt" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            cpu.interrupt_master_enable = true;
            cpu.interrupt_registers.setSpecifiedInterruptEnable(interrupts.Interrupt.VBlank, true);
            cpu.interrupt_registers.setSpecifiedInterruptFlag(interrupts.Interrupt.VBlank, true);
            cpu.pc = 0x100;
            cpu.sp = 0xFFFE;
            cpu.mmu.writeWord(cpu.sp - 2, 0x0000);
            cpu.executeInterrupt();
            try std.testing.expect(cpu.pc == 0x0040);
            try std.testing.expect(cpu.interrupt_master_enable == false);
            const pushed_pc = cpu.mmu.readWord(cpu.sp);
            try std.testing.expect(pushed_pc == 0x0100);
        }
    }.testFunction;
    try testWithCpu(testFunction);
}
