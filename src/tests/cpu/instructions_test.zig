const std = @import("std");
const Cpu = @import("../../cpu/cpu.zig").Cpu;
const instructions = @import("../../cpu/instructions.zig");
const testWithCpu = @import("cpu_test.zig").testWithCpu;

test "add" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            cpu.registers.a = 0x10;
            instructions.add(cpu, &cpu.registers.a, 0x22);
            try std.testing.expect(cpu.registers.a == 0x32);
            try std.testing.expect(!cpu.registers.getSubtractionFlag());
            try std.testing.expect(!cpu.registers.getZeroFlag());
            try std.testing.expect(!cpu.registers.getCarryFlag());
            try std.testing.expect(!cpu.registers.getHalfCarryFlag());
        }
    }.testFunction;
    try testWithCpu(testFunction);
}

test "adc" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            cpu.registers.a = 0x8F;
            cpu.registers.f = 0x10;
            instructions.adc(cpu, &cpu.registers.a, 0x01);
            try std.testing.expect(cpu.registers.a == 0x91);
            try std.testing.expect(!cpu.registers.getSubtractionFlag());
            try std.testing.expect(!cpu.registers.getZeroFlag());
            try std.testing.expect(!cpu.registers.getCarryFlag());
            try std.testing.expect(cpu.registers.getHalfCarryFlag());
        }
    }.testFunction;
    try testWithCpu(testFunction);
}

test "sub" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            cpu.registers.a = 0x22;
            instructions.sub(cpu, &cpu.registers.a, 0x11);
            try std.testing.expect(cpu.registers.a == 0x11);
            try std.testing.expect(cpu.registers.getSubtractionFlag());
            try std.testing.expect(!cpu.registers.getZeroFlag());
            try std.testing.expect(!cpu.registers.getCarryFlag());
            try std.testing.expect(!cpu.registers.getHalfCarryFlag());

            cpu.registers.a = 0x10;
            instructions.sub(cpu, &cpu.registers.a, 0x10);
            try std.testing.expect(cpu.registers.a == 0x00);
            try std.testing.expect(cpu.registers.getZeroFlag());
            try std.testing.expect(cpu.registers.getSubtractionFlag());
            try std.testing.expect(!cpu.registers.getCarryFlag());
            try std.testing.expect(!cpu.registers.getHalfCarryFlag());
        }
    }.testFunction;
    try testWithCpu(testFunction);
}

test "sbc" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            cpu.registers.a = 0x10;
            cpu.registers.f = 0x00;
            instructions.sbc(cpu, &cpu.registers.a, 0x05);
            try std.testing.expect(cpu.registers.a == 0x0B);
            try std.testing.expect(cpu.registers.getSubtractionFlag());
            try std.testing.expect(!cpu.registers.getZeroFlag());
            try std.testing.expect(!cpu.registers.getCarryFlag());
            try std.testing.expect(cpu.registers.getHalfCarryFlag());

            cpu.registers.a = 0x10;
            cpu.registers.f = 0x10;
            instructions.sbc(cpu, &cpu.registers.a, 0x05);
            try std.testing.expect(cpu.registers.a == 0x0A);
            try std.testing.expect(cpu.registers.getSubtractionFlag());
            try std.testing.expect(!cpu.registers.getZeroFlag());
            try std.testing.expect(!cpu.registers.getCarryFlag());
            try std.testing.expect(cpu.registers.getHalfCarryFlag());

            cpu.registers.a = 0x00;
            cpu.registers.f = 0x10;
            instructions.sbc(cpu, &cpu.registers.a, 0x01);
            try std.testing.expect(cpu.registers.a == 0xFE);
            try std.testing.expect(cpu.registers.getSubtractionFlag());
            try std.testing.expect(!cpu.registers.getZeroFlag());
            try std.testing.expect(cpu.registers.getCarryFlag());
            try std.testing.expect(cpu.registers.getHalfCarryFlag());

            cpu.registers.a = 0x00;
            cpu.registers.f = 0x10;
            instructions.sbc(cpu, &cpu.registers.a, 0xFF);
            try std.testing.expect(cpu.registers.a == 0x00);
            try std.testing.expect(cpu.registers.getSubtractionFlag());
            try std.testing.expect(cpu.registers.getZeroFlag());
            try std.testing.expect(cpu.registers.getCarryFlag());
            try std.testing.expect(cpu.registers.getHalfCarryFlag());
        }
    }.testFunction;
    try testWithCpu(testFunction);
}

test "and" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            cpu.registers.a = 0xF0;
            instructions.andFn(cpu, &cpu.registers.a, 0x0F);
            try std.testing.expect(cpu.registers.a == 0x00);
            try std.testing.expect(!cpu.registers.getSubtractionFlag());
            try std.testing.expect(cpu.registers.getZeroFlag());
            try std.testing.expect(!cpu.registers.getCarryFlag());
            try std.testing.expect(cpu.registers.getHalfCarryFlag());
        }
    }.testFunction;
    try testWithCpu(testFunction);
}

test "xor" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            cpu.registers.a = 0xAA;
            instructions.xor(cpu, &cpu.registers.a, 0xFF);
            try std.testing.expect(cpu.registers.a == 0x55);
            try std.testing.expect(!cpu.registers.getSubtractionFlag());
            try std.testing.expect(!cpu.registers.getZeroFlag());
            try std.testing.expect(!cpu.registers.getCarryFlag());
            try std.testing.expect(!cpu.registers.getHalfCarryFlag());
        }
    }.testFunction;
    try testWithCpu(testFunction);
}

test "or" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            cpu.registers.a = 0x0A;
            instructions.orFn(cpu, &cpu.registers.a, 0x05);
            try std.testing.expect(cpu.registers.a == 0x0F);
            try std.testing.expect(!cpu.registers.getSubtractionFlag());
            try std.testing.expect(!cpu.registers.getZeroFlag());
            try std.testing.expect(!cpu.registers.getCarryFlag());
            try std.testing.expect(!cpu.registers.getHalfCarryFlag());
        }
    }.testFunction;
    try testWithCpu(testFunction);
}

test "cp" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            cpu.registers.a = 0x10;
            instructions.cp(cpu, &cpu.registers.a, 0x10);
            try std.testing.expect(cpu.registers.a == 0x10);
            try std.testing.expect(cpu.registers.getZeroFlag());
            try std.testing.expect(cpu.registers.getSubtractionFlag());
            try std.testing.expect(!cpu.registers.getCarryFlag());
            try std.testing.expect(!cpu.registers.getHalfCarryFlag());
        }
    }.testFunction;
    try testWithCpu(testFunction);
}

test "addWords" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            cpu.registers.setHL(0x1234);
            cpu.registers.setBC(0x0001);

            var hl_val = cpu.registers.getHL();
            instructions.addWords(cpu, &hl_val, cpu.registers.getBC());
            cpu.registers.setHL(hl_val);

            try std.testing.expect(cpu.registers.getHL() == 0x1235);
            try std.testing.expect(!cpu.registers.getSubtractionFlag());
            try std.testing.expect(!cpu.registers.getCarryFlag());
            try std.testing.expect(!cpu.registers.getHalfCarryFlag());

            cpu.registers.setHL(0x0FFF);
            cpu.registers.setBC(0x0001);

            hl_val = cpu.registers.getHL();
            instructions.addWords(cpu, &hl_val, cpu.registers.getBC());
            cpu.registers.setHL(hl_val);

            try std.testing.expect(cpu.registers.getHL() == 0x1000);
            try std.testing.expect(cpu.registers.getHalfCarryFlag());
            try std.testing.expect(!cpu.registers.getCarryFlag());

            cpu.registers.setHL(0xFFFF);
            cpu.registers.setBC(0x0001);

            hl_val = cpu.registers.getHL();
            instructions.addWords(cpu, &hl_val, cpu.registers.getBC());
            cpu.registers.setHL(hl_val);

            try std.testing.expect(cpu.registers.getHL() == 0x0000);
            try std.testing.expect(cpu.registers.getCarryFlag());
            try std.testing.expect(cpu.registers.getHalfCarryFlag());
        }
    }.testFunction;
    try testWithCpu(testFunction);
}

test "rlc" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            cpu.registers.a = 0b10000001;

            instructions.rlc(cpu, &cpu.registers.a);

            try std.testing.expect(cpu.registers.a == 0b00000011);
            try std.testing.expect(cpu.registers.getCarryFlag());
            try std.testing.expect(!cpu.registers.getSubtractionFlag());
            try std.testing.expect(!cpu.registers.getHalfCarryFlag());
            try std.testing.expect(!cpu.registers.getZeroFlag());

            cpu.registers.a = 0x00;
            instructions.rlc(cpu, &cpu.registers.a);
            try std.testing.expect(cpu.registers.a == 0x00);
            try std.testing.expect(cpu.registers.getZeroFlag());
            try std.testing.expect(!cpu.registers.getCarryFlag());
        }
    }.testFunction;
    try testWithCpu(testFunction);
}

test "rrc" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            cpu.registers.a = 0b00101001;

            instructions.rrc(cpu, &cpu.registers.a);

            try std.testing.expect(cpu.registers.a == 0b10010100);
            try std.testing.expect(cpu.registers.getCarryFlag());
            try std.testing.expect(!cpu.registers.getSubtractionFlag());
            try std.testing.expect(!cpu.registers.getHalfCarryFlag());
            try std.testing.expect(!cpu.registers.getZeroFlag());

            cpu.registers.a = 0x00;
            instructions.rrc(cpu, &cpu.registers.a);
            try std.testing.expect(cpu.registers.a == 0x00);
            try std.testing.expect(cpu.registers.getZeroFlag());
            try std.testing.expect(!cpu.registers.getCarryFlag());
        }
    }.testFunction;
    try testWithCpu(testFunction);
}

test "rl" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            cpu.registers.a = 0b10000000;
            cpu.registers.f = 0;
            instructions.rl(cpu, &cpu.registers.a);
            try std.testing.expect(cpu.registers.a == 0);
            try std.testing.expect(cpu.registers.getCarryFlag());
        }
    }.testFunction;
    try testWithCpu(testFunction);
}

test "rr" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            cpu.registers.a = 0b00000001;
            cpu.registers.f = 0;
            instructions.rr(cpu, &cpu.registers.a);
            try std.testing.expect(cpu.registers.a == 0);
            try std.testing.expect(cpu.registers.getCarryFlag());
        }
    }.testFunction;
    try testWithCpu(testFunction);
}

test "cpl" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            cpu.registers.a = 0xAA;
            instructions.cpl(cpu, &cpu.registers.a);
            try std.testing.expect(cpu.registers.a == 0x55);
            try std.testing.expect(cpu.registers.getSubtractionFlag());
            try std.testing.expect(cpu.registers.getHalfCarryFlag());
        }
    }.testFunction;
    try testWithCpu(testFunction);
}

test "scf" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            instructions.scf(cpu);
            try std.testing.expect(cpu.registers.getCarryFlag());
            try std.testing.expect(!cpu.registers.getSubtractionFlag());
            try std.testing.expect(!cpu.registers.getHalfCarryFlag());
        }
    }.testFunction;
    try testWithCpu(testFunction);
}

test "ccf" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            instructions.scf(cpu);
            instructions.ccf(cpu);
            try std.testing.expect(!cpu.registers.getCarryFlag());
            instructions.ccf(cpu);
            try std.testing.expect(cpu.registers.getCarryFlag());
        }
    }.testFunction;
    try testWithCpu(testFunction);
}

test "jr" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            cpu.pc = 0x100;
            instructions.jr(cpu, 0x10, true);
            try std.testing.expect(cpu.pc == 0x110);

            cpu.pc = 0x100;
            instructions.jr(cpu, -0x10, true);
            try std.testing.expect(cpu.pc == 0xF0);
        }
    }.testFunction;
    try testWithCpu(testFunction);
}

test "jp" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            instructions.jp(cpu, 0x1234, true);
            try std.testing.expect(cpu.pc == 0x1234);

            cpu.pc = 0x100;
            instructions.jp(cpu, 0x2000, false);
            try std.testing.expect(cpu.pc == 0x100);
        }
    }.testFunction;
    try testWithCpu(testFunction);
}

test "addSigned" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            cpu.sp = 0xFFF8;

            instructions.addSigned(cpu, &cpu.sp, 8);
            try std.testing.expect(cpu.sp == 0x0000);
            try std.testing.expect(!cpu.registers.getZeroFlag());
            try std.testing.expect(!cpu.registers.getSubtractionFlag());
            try std.testing.expect(cpu.registers.getHalfCarryFlag());
            try std.testing.expect(cpu.registers.getCarryFlag());

            cpu.sp = 0x0004;
            instructions.addSigned(cpu, &cpu.sp, -8);
            try std.testing.expect(cpu.sp == 0xFFFC);
            try std.testing.expect(!cpu.registers.getZeroFlag());
            try std.testing.expect(!cpu.registers.getSubtractionFlag());
            try std.testing.expect(!cpu.registers.getHalfCarryFlag());
            try std.testing.expect(!cpu.registers.getCarryFlag());

            cpu.sp = 0x8000;
            instructions.addSigned(cpu, &cpu.sp, 127);
            try std.testing.expect(cpu.sp == 0x807F);
            try std.testing.expect(!cpu.registers.getZeroFlag());
            try std.testing.expect(!cpu.registers.getSubtractionFlag());
            try std.testing.expect(!cpu.registers.getHalfCarryFlag());
            try std.testing.expect(!cpu.registers.getCarryFlag());

            cpu.sp = 0x8000;
            instructions.addSigned(cpu, &cpu.sp, -128);
            try std.testing.expect(cpu.sp == 0x7F80);
            try std.testing.expect(!cpu.registers.getZeroFlag());
            try std.testing.expect(!cpu.registers.getSubtractionFlag());
            try std.testing.expect(!cpu.registers.getHalfCarryFlag());
            try std.testing.expect(!cpu.registers.getCarryFlag());
        }
    }.testFunction;
    try testWithCpu(testFunction);
}

test "stack" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            cpu.sp = 0xFFFE;

            instructions.push(cpu, 0x1234);
            try std.testing.expect(cpu.sp == 0xFFFC);

            const value = instructions.pop(cpu);
            try std.testing.expect(value == 0x1234);
            try std.testing.expect(cpu.sp == 0xFFFE);
        }
    }.testFunction;
    try testWithCpu(testFunction);
}

test "call" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            cpu.pc = 0x0150;
            cpu.sp = 0xFFFE;

            instructions.call(cpu, 0x4000, true);

            try std.testing.expect(cpu.pc == 0x4000);

            const ret = instructions.pop(cpu);
            try std.testing.expect(ret == 0x0150);
        }
    }.testFunction;
    try testWithCpu(testFunction);
}

test "ret" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            cpu.sp = 0xFFFC;
            instructions.push(cpu, 0x1234);
            instructions.ret(cpu, true);
            try std.testing.expect(cpu.pc == 0x1234);
            try std.testing.expect(cpu.sp == 0xFFFC);
        }
    }.testFunction;
    try testWithCpu(testFunction);
}

test "daa" {
    const testFunction = struct {
        pub fn testFunction(cpu: *Cpu) anyerror!void {
            cpu.registers.a = 0x45;
            cpu.registers.f = 0;
            instructions.add(cpu, &cpu.registers.a, 0x55);
            instructions.daa(cpu, &cpu.registers.a);
            try std.testing.expect(cpu.registers.a == 0x00);
            try std.testing.expect(cpu.registers.getCarryFlag());

            cpu.registers.a = 0x15;
            cpu.registers.f = 0;
            instructions.add(cpu, &cpu.registers.a, 0x27);
            instructions.daa(cpu, &cpu.registers.a);
            try std.testing.expect(cpu.registers.a == 0x42);
            try std.testing.expect(!cpu.registers.getCarryFlag());

            cpu.registers.a = 0x42;
            cpu.registers.f = 0x40;
            instructions.sub(cpu, &cpu.registers.a, 0x18);
            instructions.daa(cpu, &cpu.registers.a);
            try std.testing.expect(cpu.registers.a == 0x24);
            try std.testing.expect(cpu.registers.getSubtractionFlag());

            cpu.registers.a = 0x99;
            cpu.registers.f = 0;
            instructions.add(cpu, &cpu.registers.a, 0x01);
            instructions.daa(cpu, &cpu.registers.a);
            try std.testing.expect(cpu.registers.a == 0x00);
            try std.testing.expect(cpu.registers.getZeroFlag());
        }
    }.testFunction;
    try testWithCpu(testFunction);
}
