const Cpu = @import("types/cpu.zig").Cpu;
const Instructions = @import("instructions.zig");

fn opcodeCB00(cpu: *Cpu) void {
    Instructions.rlc(cpu, &cpu.registers.b);
    cpu.pc +%= 2;
}

fn opcodeCB01(cpu: *Cpu) void {
    Instructions.rlc(cpu, &cpu.registers.c);
    cpu.pc +%= 2;
}

fn opcodeCB02(cpu: *Cpu) void {
    Instructions.rlc(cpu, &cpu.registers.d);
    cpu.pc +%= 2;
}

fn opcodeCB03(cpu: *Cpu) void {
    Instructions.rlc(cpu, &cpu.registers.e);
    cpu.pc +%= 2;
}

fn opcodeCB04(cpu: *Cpu) void {
    Instructions.rlc(cpu, &cpu.registers.h);
    cpu.pc +%= 2;
}

fn opcodeCB05(cpu: *Cpu) void {
    Instructions.rlc(cpu, &cpu.registers.l);
    cpu.pc +%= 2;
}

fn opcodeCB06(cpu: *Cpu) void {
    Instructions.rlc(cpu, &cpu.memory.getBytePtr(cpu.registers.getHL()));
    cpu.pc +%= 2;
}

fn opcodeCB07(cpu: *Cpu) void {
    Instructions.rlc(cpu, &cpu.registers.a);
    cpu.pc +%= 2;
}

fn opcodeCB08(cpu: *Cpu) void {
    Instructions.rrc(cpu, &cpu.registers.b);
    cpu.pc +%= 2;
}
pub fn opcodeCB09(cpu: *Cpu) void {
    Instructions.rrc(cpu, &cpu.registers.c);
    cpu.pc +%= 2;
}

pub fn opcodeCB0A(cpu: *Cpu) void {
    Instructions.rrc(cpu, &cpu.registers.d);
    cpu.pc +%= 2;
}

fn opcodeCB0B(cpu: *Cpu) void {
    Instructions.rrc(cpu, &cpu.registers.e);
    cpu.pc +%= 2;
}

fn opcodeCB0C(cpu: *Cpu) void {
    Instructions.rrc(cpu, &cpu.registers.h);
    cpu.pc +%= 2;
}

fn opcodeCB0D(cpu: *Cpu) void {
    Instructions.rrc(cpu, &cpu.registers.l);
    cpu.pc +%= 2;
}

fn opcodeCB0E(cpu: *Cpu) void {
    Instructions.rrc(cpu, &cpu.memory.getBytePtr(cpu.registers.getHL()));
    cpu.pc +%= 2;
}

fn opcodeCB0F(cpu: *Cpu) void {
    Instructions.rrc(cpu, &cpu.registers.a);
    cpu.pc +%= 2;
}

fn opcodeCB10(cpu: *Cpu) void {
    Instructions.rl(cpu, &cpu.registers.b);
    cpu.pc +%= 2;
}

fn opcodeCB11(cpu: *Cpu) void {
    Instructions.rl(cpu, &cpu.registers.c);
    cpu.pc +%= 2;
}

fn opcodeCB12(cpu: *Cpu) void {
    Instructions.rl(cpu, &cpu.registers.d);
    cpu.pc +%= 2;
}

fn opcodeCB13(cpu: *Cpu) void {
    Instructions.rl(cpu, &cpu.registers.e);
    cpu.pc +%= 2;
}

fn opcodeCB14(cpu: *Cpu) void {
    Instructions.rl(cpu, &cpu.registers.h);
    cpu.pc +%= 2;
}

fn opcodeCB15(cpu: *Cpu) void {
    Instructions.rl(cpu, &cpu.registers.l);
    cpu.pc +%= 2;
}

fn opcodeCB16(cpu: *Cpu) void {
    Instructions.rl(cpu, &cpu.memory.getBytePtr(cpu.registers.getHL()));
    cpu.pc +%= 2;
}

fn opcodeCB17(cpu: *Cpu) void {
    Instructions.rl(cpu, &cpu.registers.a);
    cpu.pc +%= 2;
}

fn opcodeCB18(cpu: *Cpu) void {
    Instructions.rr(cpu, &cpu.registers.b);
    cpu.pc +%= 2;
}

fn opcodeCB19(cpu: *Cpu) void {
    Instructions.rr(cpu, &cpu.registers.c);
    cpu.pc +%= 2;
}

fn opcodeCB1A(cpu: *Cpu) void {
    Instructions.rr(cpu, &cpu.registers.d);
    cpu.pc +%= 2;
}

fn opcodeCB1B(cpu: *Cpu) void {
    Instructions.rr(cpu, &cpu.registers.e);
    cpu.pc +%= 2;
}

fn opcodeCB1C(cpu: *Cpu) void {
    Instructions.rr(cpu, &cpu.registers.h);
    cpu.pc +%= 2;
}

fn opcodeCB1D(cpu: *Cpu) void {
    Instructions.rr(cpu, &cpu.registers.l);
    cpu.pc +%= 2;
}

fn opcodeCB1E(cpu: *Cpu) void {
    Instructions.rr(cpu, &cpu.memory.getBytePtr(cpu.registers.getHL()));
    cpu.pc +%= 2;
}

fn opcodeCB1F(cpu: *Cpu) void {
    Instructions.rr(cpu, &cpu.registers.a);
    cpu.pc +%= 2;
}

fn opcodeCB20(cpu: *Cpu) void {
    Instructions.sla(cpu, &cpu.registers.b);
    cpu.pc +%= 2;
}

fn opcodeCB21(cpu: *Cpu) void {
    Instructions.sla(cpu, &cpu.registers.c);
    cpu.pc +%= 2;
}

fn opcodeCB22(cpu: *Cpu) void {
    Instructions.sla(cpu, &cpu.registers.d);
    cpu.pc +%= 2;
}

fn opcodeCB23(cpu: *Cpu) void {
    Instructions.sla(cpu, &cpu.registers.e);
    cpu.pc +%= 2;
}

fn opcodeCB24(cpu: *Cpu) void {
    Instructions.sla(cpu, &cpu.registers.h);
    cpu.pc +%= 2;
}

fn opcodeCB25(cpu: *Cpu) void {
    Instructions.sla(cpu, &cpu.registers.l);
    cpu.pc +%= 2;
}

fn opcodeCB26(cpu: *Cpu) void {
    Instructions.sla(cpu, &cpu.memory.getBytePtr(cpu.registers.getHL()));
    cpu.pc +%= 2;
}

fn opcodeCB27(cpu: *Cpu) void {
    Instructions.sla(cpu, &cpu.registers.a);
    cpu.pc +%= 2;
}

fn opcodeCB28(cpu: *Cpu) void {
    Instructions.sra(cpu, &cpu.registers.b);
    cpu.pc +%= 2;
}

fn opcodeCB29(cpu: *Cpu) void {
    Instructions.sra(cpu, &cpu.registers.c);
    cpu.pc +%= 2;
}

fn opcodeCB2A(cpu: *Cpu) void {
    Instructions.sra(cpu, &cpu.registers.d);
    cpu.pc +%= 2;
}

fn opcodeCB2B(cpu: *Cpu) void {
    Instructions.sra(cpu, &cpu.registers.e);
    cpu.pc +%= 2;
}

fn opcodeCB2C(cpu: *Cpu) void {
    Instructions.sra(cpu, &cpu.registers.h);
    cpu.pc +%= 2;
}

fn opcodeCB2D(cpu: *Cpu) void {
    Instructions.sra(cpu, &cpu.registers.l);
    cpu.pc +%= 2;
}

fn opcodeCB2E(cpu: *Cpu) void {
    Instructions.sra(cpu, &cpu.memory.getBytePtr(cpu.registers.getHL()));
    cpu.pc +%= 2;
}

fn opcodeCB2F(cpu: *Cpu) void {
    Instructions.sra(cpu, &cpu.registers.a);
    cpu.pc +%= 2;
}

fn opcodeCB30(cpu: *Cpu) void {
    Instructions.swap(cpu, &cpu.registers.b);
    cpu.pc +%= 2;
}

fn opcodeCB31(cpu: *Cpu) void {
    Instructions.swap(cpu, &cpu.registers.c);
    cpu.pc +%= 2;
}

fn opcodeCB32(cpu: *Cpu) void {
    Instructions.swap(cpu, &cpu.registers.d);
    cpu.pc +%= 2;
}

fn opcodeCB33(cpu: *Cpu) void {
    Instructions.swap(cpu, &cpu.registers.e);
    cpu.pc +%= 2;
}

fn opcodeCB34(cpu: *Cpu) void {
    Instructions.swap(cpu, &cpu.registers.h);
    cpu.pc +%= 2;
}

fn opcodeCB35(cpu: *Cpu) void {
    Instructions.swap(cpu, &cpu.registers.l);
    cpu.pc +%= 2;
}

fn opcodeCB36(cpu: *Cpu) void {
    Instructions.swap(cpu, &cpu.memory.getBytePtr(cpu.registers.getHL()));
    cpu.pc +%= 2;
}

fn opcodeCB37(cpu: *Cpu) void {
    Instructions.swap(cpu, &cpu.registers.a);
    cpu.pc +%= 2;
}

fn opcodeCB38(cpu: *Cpu) void {
    Instructions.srl(cpu, &cpu.registers.b);
    cpu.pc +%= 2;
}

fn opcodeCB39(cpu: *Cpu) void {
    Instructions.srl(cpu, &cpu.registers.c);
    cpu.pc +%= 2;
}

fn opcodeCB3A(cpu: *Cpu) void {
    Instructions.srl(cpu, &cpu.registers.d);
    cpu.pc +%= 2;
}

fn opcodeCB3B(cpu: *Cpu) void {
    Instructions.srl(cpu, &cpu.registers.e);
    cpu.pc +%= 2;
}

fn opcodeCB3C(cpu: *Cpu) void {
    Instructions.srl(cpu, &cpu.registers.h);
    cpu.pc +%= 2;
}

fn opcodeCB3D(cpu: *Cpu) void {
    Instructions.srl(cpu, &cpu.registers.l);
    cpu.pc +%= 2;
}

fn opcodeCB3E(cpu: *Cpu) void {
    Instructions.srl(cpu, &cpu.memory.getBytePtr(cpu.registers.getHL()));
    cpu.pc +%= 2;
}

fn opcodeCB3F(cpu: *Cpu) void {
    Instructions.srl(cpu, &cpu.registers.a);
    cpu.pc +%= 2;
}
