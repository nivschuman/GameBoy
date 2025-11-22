const std = @import("std");
const Cpu = @import("cpu.zig").Cpu;
const Registers = @import("registers.zig").Registers;
const Instructions = @import("instructions.zig");

test "ADD" {
    var cpu = Cpu{
        .registers = Registers{
            .a = 0x10,
            .b = 0x22,
            .f = 0,
            .c = 0,
            .d = 0,
            .e = 0,
            .h = 0,
            .l = 0,
            .g = 0,
        },
    };

    Instructions.add(&cpu, cpu.registers.b);
    try std.testing.expect(cpu.registers.a == 0x32);
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
}

test "ADC" {
    var cpu = Cpu{
        .registers = Registers{
            .a = 0x8F,
            .b = 0x01,
            .f = 0x10,
            .c = 0,
            .d = 0,
            .e = 0,
            .h = 0,
            .l = 0,
            .g = 0,
        },
    };

    Instructions.adc(&cpu, cpu.registers.b);
    try std.testing.expect(cpu.registers.a == 0x91);
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());
}
