const Cpu = @import("types/cpu.zig").Cpu;
const Instructions = @import("instructions.zig");

fn opcodeCB00(cpu: *Cpu) void {
    Instructions.rlc(cpu, &cpu.registers.b);
    cpu.pc +%= 1;
}

fn opcodeCB01(cpu: *Cpu) void {
    Instructions.rlc(cpu, &cpu.registers.c);
    cpu.pc +%= 1;
}

fn opcodeCB02(cpu: *Cpu) void {
    Instructions.rlc(cpu, &cpu.registers.d);
    cpu.pc +%= 1;
}

fn opcodeCB03(cpu: *Cpu) void {
    Instructions.rlc(cpu, &cpu.registers.e);
    cpu.pc +%= 1;
}

fn opcodeCB04(cpu: *Cpu) void {
    Instructions.rlc(cpu, &cpu.registers.h);
    cpu.pc +%= 1;
}

fn opcodeCB05(cpu: *Cpu) void {
    Instructions.rlc(cpu, &cpu.registers.l);
    cpu.pc +%= 1;
}

fn opcodeCB06(cpu: *Cpu) void {
    Instructions.rlc(cpu, &cpu.memory.getBytePtr(cpu.registers.getHL()));
    cpu.pc +%= 1;
}

fn opcodeCB07(cpu: *Cpu) void {
    Instructions.rlc(cpu, &cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcodeCB08(cpu: *Cpu) void {
    Instructions.rrc(cpu, &cpu.registers.b);
    cpu.pc +%= 1;
}
pub fn opcodeCB09(cpu: *Cpu) void {
    Instructions.rrc(cpu, &cpu.registers.c);
    cpu.pc +%= 1;
}

pub fn opcodeCB0A(cpu: *Cpu) void {
    Instructions.rrc(cpu, &cpu.registers.d);
    cpu.pc +%= 1;
}

fn opcodeCB0B(cpu: *Cpu) void {
    Instructions.rrc(cpu, &cpu.registers.e);
    cpu.pc +%= 1;
}

fn opcodeCB0C(cpu: *Cpu) void {
    Instructions.rrc(cpu, &cpu.registers.h);
    cpu.pc +%= 1;
}

fn opcodeCB0D(cpu: *Cpu) void {
    Instructions.rrc(cpu, &cpu.registers.l);
    cpu.pc +%= 1;
}

fn opcodeCB0E(cpu: *Cpu) void {
    Instructions.rrc(cpu, &cpu.memory.getBytePtr(cpu.registers.getHL()));
    cpu.pc +%= 1;
}

fn opcodeCB0F(cpu: *Cpu) void {
    Instructions.rrc(cpu, &cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcodeCB10(cpu: *Cpu) void {
    Instructions.rl(cpu, &cpu.registers.b);
    cpu.pc +%= 1;
}

fn opcodeCB11(cpu: *Cpu) void {
    Instructions.rl(cpu, &cpu.registers.c);
    cpu.pc +%= 1;
}

fn opcodeCB12(cpu: *Cpu) void {
    Instructions.rl(cpu, &cpu.registers.d);
    cpu.pc +%= 1;
}

fn opcodeCB13(cpu: *Cpu) void {
    Instructions.rl(cpu, &cpu.registers.e);
    cpu.pc +%= 1;
}

fn opcodeCB14(cpu: *Cpu) void {
    Instructions.rl(cpu, &cpu.registers.h);
    cpu.pc +%= 1;
}

fn opcodeCB15(cpu: *Cpu) void {
    Instructions.rl(cpu, &cpu.registers.l);
    cpu.pc +%= 1;
}

fn opcodeCB16(cpu: *Cpu) void {
    Instructions.rl(cpu, &cpu.memory.getBytePtr(cpu.registers.getHL()));
    cpu.pc +%= 1;
}

fn opcodeCB17(cpu: *Cpu) void {
    Instructions.rl(cpu, &cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcodeCB18(cpu: *Cpu) void {
    Instructions.rr(cpu, &cpu.registers.b);
    cpu.pc +%= 1;
}

fn opcodeCB19(cpu: *Cpu) void {
    Instructions.rr(cpu, &cpu.registers.c);
    cpu.pc +%= 1;
}

fn opcodeCB1A(cpu: *Cpu) void {
    Instructions.rr(cpu, &cpu.registers.d);
    cpu.pc +%= 1;
}

fn opcodeCB1B(cpu: *Cpu) void {
    Instructions.rr(cpu, &cpu.registers.e);
    cpu.pc +%= 1;
}

fn opcodeCB1C(cpu: *Cpu) void {
    Instructions.rr(cpu, &cpu.registers.h);
    cpu.pc +%= 1;
}

fn opcodeCB1D(cpu: *Cpu) void {
    Instructions.rr(cpu, &cpu.registers.l);
    cpu.pc +%= 1;
}

fn opcodeCB1E(cpu: *Cpu) void {
    Instructions.rr(cpu, &cpu.memory.getBytePtr(cpu.registers.getHL()));
    cpu.pc +%= 1;
}

fn opcodeCB1F(cpu: *Cpu) void {
    Instructions.rr(cpu, &cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcodeCB20(cpu: *Cpu) void {
    Instructions.sla(cpu, &cpu.registers.b);
    cpu.pc +%= 1;
}

fn opcodeCB21(cpu: *Cpu) void {
    Instructions.sla(cpu, &cpu.registers.c);
    cpu.pc +%= 1;
}

fn opcodeCB22(cpu: *Cpu) void {
    Instructions.sla(cpu, &cpu.registers.d);
    cpu.pc +%= 1;
}

fn opcodeCB23(cpu: *Cpu) void {
    Instructions.sla(cpu, &cpu.registers.e);
    cpu.pc +%= 1;
}

fn opcodeCB24(cpu: *Cpu) void {
    Instructions.sla(cpu, &cpu.registers.h);
    cpu.pc +%= 1;
}

fn opcodeCB25(cpu: *Cpu) void {
    Instructions.sla(cpu, &cpu.registers.l);
    cpu.pc +%= 1;
}

fn opcodeCB26(cpu: *Cpu) void {
    Instructions.sla(cpu, &cpu.memory.getBytePtr(cpu.registers.getHL()));
    cpu.pc +%= 1;
}

fn opcodeCB27(cpu: *Cpu) void {
    Instructions.sla(cpu, &cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcodeCB28(cpu: *Cpu) void {
    Instructions.sra(cpu, &cpu.registers.b);
    cpu.pc +%= 1;
}

fn opcodeCB29(cpu: *Cpu) void {
    Instructions.sra(cpu, &cpu.registers.c);
    cpu.pc +%= 1;
}

fn opcodeCB2A(cpu: *Cpu) void {
    Instructions.sra(cpu, &cpu.registers.d);
    cpu.pc +%= 1;
}

fn opcodeCB2B(cpu: *Cpu) void {
    Instructions.sra(cpu, &cpu.registers.e);
    cpu.pc +%= 1;
}

fn opcodeCB2C(cpu: *Cpu) void {
    Instructions.sra(cpu, &cpu.registers.h);
    cpu.pc +%= 1;
}

fn opcodeCB2D(cpu: *Cpu) void {
    Instructions.sra(cpu, &cpu.registers.l);
    cpu.pc +%= 1;
}

fn opcodeCB2E(cpu: *Cpu) void {
    Instructions.sra(cpu, &cpu.memory.getBytePtr(cpu.registers.getHL()));
    cpu.pc +%= 1;
}

fn opcodeCB2F(cpu: *Cpu) void {
    Instructions.sra(cpu, &cpu.registers.a);
    cpu.pc +%= 1;
}
