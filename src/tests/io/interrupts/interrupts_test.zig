const std = @import("std");
const InterruptRegisters = @import("../../../io/interrupts/interrupts.zig").InterruptRegisters;
const Interrupt = @import("../../../io/interrupts/interrupts.zig").Interrupt;

test "specified interrupt enable" {
    var interrupt_registers = InterruptRegisters.init();
    try std.testing.expect(!interrupt_registers.getSpecifiedInterruptEnable(.VBlank));

    interrupt_registers.setSpecifiedInterruptEnable(.VBlank, true);
    try std.testing.expect(interrupt_registers.getSpecifiedInterruptEnable(.VBlank));

    interrupt_registers.setSpecifiedInterruptEnable(.VBlank, false);
    try std.testing.expect(!interrupt_registers.getSpecifiedInterruptEnable(.VBlank));
}

test "specified interrupt flag" {
    var interrupt_registers = InterruptRegisters.init();

    try std.testing.expect(!interrupt_registers.getSpecifiedInterruptFlag(.Timer));

    interrupt_registers.setSpecifiedInterruptFlag(.Timer, true);
    try std.testing.expect(interrupt_registers.getSpecifiedInterruptFlag(.Timer));

    interrupt_registers.setSpecifiedInterruptFlag(.Timer, false);
    try std.testing.expect(!interrupt_registers.getSpecifiedInterruptFlag(.Timer));
}

test "get interrupt to handle" {
    var interrupt_registers = InterruptRegisters.init();
    interrupt_registers.setSpecifiedInterruptEnable(.Timer, true);
    interrupt_registers.setSpecifiedInterruptFlag(.Timer, true);
    interrupt_registers.setSpecifiedInterruptEnable(.VBlank, true);
    interrupt_registers.setSpecifiedInterruptFlag(.VBlank, true);

    const pending = interrupt_registers.getInterruptToHandle() orelse unreachable;
    try std.testing.expect(pending == .VBlank);

    interrupt_registers.setSpecifiedInterruptFlag(.VBlank, false);
    const next = interrupt_registers.getInterruptToHandle() orelse unreachable;
    try std.testing.expect(next == .Timer);

    interrupt_registers.setSpecifiedInterruptFlag(.Timer, false);
    try std.testing.expect(interrupt_registers.getInterruptToHandle() == null);
}

test "setters" {
    var interrupt_registers = InterruptRegisters.init();

    interrupt_registers.setInterruptEnable(0xFF);
    interrupt_registers.setInterruptFlag(0x0F);

    try std.testing.expect(interrupt_registers.interrupt_enable == 0xFF);
    try std.testing.expect(interrupt_registers.interrupt_flag == 0x0F);
}
