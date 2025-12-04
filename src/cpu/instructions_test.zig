const std = @import("std");
const Cpu = @import("types/cpu.zig").Cpu;
const Registers = @import("types/registers.zig").Registers;
const Instructions = @import("instructions.zig");

test "add" {
    var cpu = Cpu.init();
    cpu.registers.a = 0x10;

    Instructions.add(&cpu, &cpu.registers.a, 0x22);
    try std.testing.expect(cpu.registers.a == 0x32);
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
}

test "adc" {
    var cpu = Cpu.init();
    cpu.registers.a = 0x8F;
    cpu.registers.f = 0x10;

    Instructions.adc(&cpu, &cpu.registers.a, 0x01);
    try std.testing.expect(cpu.registers.a == 0x91);
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());
}

test "sub" {
    var cpu = Cpu.init();

    cpu.registers.a = 0x22;
    Instructions.sub(&cpu, &cpu.registers.a, 0x11);
    try std.testing.expect(cpu.registers.a == 0x11);
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());

    cpu.registers.a = 0x10;
    Instructions.sub(&cpu, &cpu.registers.a, 0x10);
    try std.testing.expect(cpu.registers.a == 0x00);
    try std.testing.expect(cpu.registers.getZeroFlag());
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
}

test "sbc" {
    var cpu = Cpu.init();

    cpu.registers.a = 0x10;
    cpu.registers.f = 0x00;
    Instructions.sbc(&cpu, &cpu.registers.a, 0x05);
    try std.testing.expect(cpu.registers.a == 0x0B);
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());

    cpu.registers.a = 0x10;
    cpu.registers.f = 0x10;
    Instructions.sbc(&cpu, &cpu.registers.a, 0x05);
    try std.testing.expect(cpu.registers.a == 0x0A);
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());

    cpu.registers.a = 0x00;
    cpu.registers.f = 0x10;
    Instructions.sbc(&cpu, &cpu.registers.a, 0x01);
    try std.testing.expect(cpu.registers.a == 0xFE);
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());

    cpu.registers.a = 0x00;
    cpu.registers.f = 0x10;
    Instructions.sbc(&cpu, &cpu.registers.a, 0xFF);
    try std.testing.expect(cpu.registers.a == 0x00);
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(cpu.registers.getZeroFlag());
    try std.testing.expect(cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());
}

test "and" {
    var cpu = Cpu.init();
    cpu.registers.a = 0xF0;

    Instructions.andFn(&cpu, &cpu.registers.a, 0x0F);
    try std.testing.expect(cpu.registers.a == 0x00);
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());
}

test "xor" {
    var cpu = Cpu.init();
    cpu.registers.a = 0xAA;

    Instructions.xor(&cpu, &cpu.registers.a, 0xFF);
    try std.testing.expect(cpu.registers.a == 0x55);
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
}

test "or" {
    var cpu = Cpu.init();
    cpu.registers.a = 0x0A;

    Instructions.orFn(&cpu, &cpu.registers.a, 0x05);
    try std.testing.expect(cpu.registers.a == 0x0F);
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
}

test "cp" {
    var cpu = Cpu.init();
    cpu.registers.a = 0x10;

    Instructions.cp(&cpu, &cpu.registers.a, 0x10);
    try std.testing.expect(cpu.registers.a == 0x10);
    try std.testing.expect(cpu.registers.getZeroFlag());
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
}

test "addWords" {
    var cpu = Cpu.init();

    cpu.registers.setHL(0x1234);
    cpu.registers.setBC(0x0001);

    var hl_val = cpu.registers.getHL();
    Instructions.addWords(&cpu, &hl_val, cpu.registers.getBC());
    cpu.registers.setHL(hl_val);

    try std.testing.expect(cpu.registers.getHL() == 0x1235);
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());

    cpu.registers.setHL(0x0FFF);
    cpu.registers.setBC(0x0001);

    hl_val = cpu.registers.getHL();
    Instructions.addWords(&cpu, &hl_val, cpu.registers.getBC());
    cpu.registers.setHL(hl_val);

    try std.testing.expect(cpu.registers.getHL() == 0x1000);
    try std.testing.expect(cpu.registers.getHalfCarryFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());

    cpu.registers.setHL(0xFFFF);
    cpu.registers.setBC(0x0001);

    hl_val = cpu.registers.getHL();
    Instructions.addWords(&cpu, &hl_val, cpu.registers.getBC());
    cpu.registers.setHL(hl_val);

    try std.testing.expect(cpu.registers.getHL() == 0x0000);
    try std.testing.expect(cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());
}

test "rlc" {
    var cpu = Cpu.init();
    cpu.registers.a = 0b10000001;

    Instructions.rlc(&cpu, &cpu.registers.a);

    try std.testing.expect(cpu.registers.a == 0b00000011);
    try std.testing.expect(cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());

    cpu.registers.a = 0x00;
    Instructions.rlc(&cpu, &cpu.registers.a);
    try std.testing.expect(cpu.registers.a == 0x00);
    try std.testing.expect(cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
}

test "rrc" {
    var cpu = Cpu.init();
    cpu.registers.a = 0b00101001;

    Instructions.rrc(&cpu, &cpu.registers.a);

    try std.testing.expect(cpu.registers.a == 0b10010100);
    try std.testing.expect(cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());

    cpu.registers.a = 0x00;
    Instructions.rrc(&cpu, &cpu.registers.a);
    try std.testing.expect(cpu.registers.a == 0x00);
    try std.testing.expect(cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
}

test "rl" {
    var cpu = Cpu.init();
    cpu.registers.a = 0b10000000;
    Instructions.rl(&cpu, &cpu.registers.a);
    try std.testing.expect(cpu.registers.a == 0);
    try std.testing.expect(cpu.registers.getCarryFlag());
}

test "rr" {
    var cpu = Cpu.init();
    cpu.registers.a = 0b00000001;
    Instructions.rr(&cpu, &cpu.registers.a);
    try std.testing.expect(cpu.registers.a == 0);
    try std.testing.expect(cpu.registers.getCarryFlag());
}

test "cpl" {
    var cpu = Cpu.init();
    cpu.registers.a = 0xAA;
    Instructions.cpl(&cpu, &cpu.registers.a);
    try std.testing.expect(cpu.registers.a == 0x55);
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());
}

test "scf" {
    var cpu = Cpu.init();
    Instructions.scf(&cpu);
    try std.testing.expect(cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
}

test "ccf" {
    var cpu = Cpu.init();
    Instructions.scf(&cpu);
    Instructions.ccf(&cpu);
    try std.testing.expect(!cpu.registers.getCarryFlag());
    Instructions.ccf(&cpu);
    try std.testing.expect(cpu.registers.getCarryFlag());
}

test "jr" {
    var cpu = Cpu.init();
    cpu.pc = 0x100;
    Instructions.jr(&cpu, 0x10, true);
    try std.testing.expect(cpu.pc == 0x110);

    cpu.pc = 0x100;
    Instructions.jr(&cpu, -0x10, true);
    try std.testing.expect(cpu.pc == 0xF0);
}

test "jp" {
    var cpu = Cpu.init();
    Instructions.jp(&cpu, 0x1234, true);
    try std.testing.expect(cpu.pc == 0x1234);

    cpu.pc = 0x100;
    Instructions.jp(&cpu, 0x2000, false);
    try std.testing.expect(cpu.pc == 0x100);
}

test "ldRam" {
    var cpu = Cpu.init();
    Instructions.ldRam(&cpu, 0x12, 0xAB);
    try std.testing.expect(cpu.memory.readByte(0xFF12) == 0xAB);
}

test "addSigned" {
    var cpu = Cpu.init();
    cpu.sp = 0xFFF8;

    Instructions.addSigned(&cpu, &cpu.sp, 8);
    try std.testing.expect(cpu.sp == 0x0000);
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());
    try std.testing.expect(cpu.registers.getCarryFlag());

    cpu.sp = 0x0004;
    Instructions.addSigned(&cpu, &cpu.sp, -8);
    try std.testing.expect(cpu.sp == 0xFFFC);
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());

    cpu.sp = 0x8000;
    Instructions.addSigned(&cpu, &cpu.sp, 127);
    try std.testing.expect(cpu.sp == 0x807F);
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());

    cpu.sp = 0x8000;
    Instructions.addSigned(&cpu, &cpu.sp, -128);
    try std.testing.expect(cpu.sp == 0x7F80);
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
}
