const std = @import("std");
const Timer = @import("../../../io/timer/timer.zig").Timer;
const InterruptRegisters = @import("../../../io/interrupts/interrupts.zig").InterruptRegisters;
const Interrupt = @import("../../../io/interrupts/interrupts.zig").Interrupt;

test "timer tick" {
    var interrupt_regs = InterruptRegisters.init();
    var timer = Timer.init(&interrupt_regs);

    timer.tac = 0b101;
    timer.div = 0b10111;
    timer.tima = 0;
    timer.tick();
    try std.testing.expect(timer.tima == 0);

    timer.tac = 0b101;
    timer.div = 0b11111;
    timer.tima = 0;
    timer.tick();
    try std.testing.expect(timer.tima == 1);
}

test "tima overflow" {
    var interrupt_regs = InterruptRegisters.init();
    var timer = Timer.init(&interrupt_regs);

    timer.tima = 0xFF;
    timer.tma = 0x42;
    timer.tac = 0b101;
    timer.div = 0b1111;

    timer.tick();
    try std.testing.expect(timer.tima == 0x42);
    try std.testing.expect(interrupt_regs.getSpecifiedInterruptFlag(Interrupt.Timer));
}
