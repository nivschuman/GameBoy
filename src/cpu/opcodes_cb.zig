const Cpu = @import("cpu.zig").Cpu;
const instructions = @import("instructions.zig");

pub const opcodes_cb_table: [256]*const fn (*Cpu) void = .{
    opcodeCB00, opcodeCB01, opcodeCB02, opcodeCB03, opcodeCB04, opcodeCB05, opcodeCB06, opcodeCB07,
    opcodeCB08, opcodeCB09, opcodeCB0A, opcodeCB0B, opcodeCB0C, opcodeCB0D, opcodeCB0E, opcodeCB0F,
    opcodeCB10, opcodeCB11, opcodeCB12, opcodeCB13, opcodeCB14, opcodeCB15, opcodeCB16, opcodeCB17,
    opcodeCB18, opcodeCB19, opcodeCB1A, opcodeCB1B, opcodeCB1C, opcodeCB1D, opcodeCB1E, opcodeCB1F,
    opcodeCB20, opcodeCB21, opcodeCB22, opcodeCB23, opcodeCB24, opcodeCB25, opcodeCB26, opcodeCB27,
    opcodeCB28, opcodeCB29, opcodeCB2A, opcodeCB2B, opcodeCB2C, opcodeCB2D, opcodeCB2E, opcodeCB2F,
    opcodeCB30, opcodeCB31, opcodeCB32, opcodeCB33, opcodeCB34, opcodeCB35, opcodeCB36, opcodeCB37,
    opcodeCB38, opcodeCB39, opcodeCB3A, opcodeCB3B, opcodeCB3C, opcodeCB3D, opcodeCB3E, opcodeCB3F,
    opcodeCB40, opcodeCB41, opcodeCB42, opcodeCB43, opcodeCB44, opcodeCB45, opcodeCB46, opcodeCB47,
    opcodeCB48, opcodeCB49, opcodeCB4A, opcodeCB4B, opcodeCB4C, opcodeCB4D, opcodeCB4E, opcodeCB4F,
    opcodeCB50, opcodeCB51, opcodeCB52, opcodeCB53, opcodeCB54, opcodeCB55, opcodeCB56, opcodeCB57,
    opcodeCB58, opcodeCB59, opcodeCB5A, opcodeCB5B, opcodeCB5C, opcodeCB5D, opcodeCB5E, opcodeCB5F,
    opcodeCB60, opcodeCB61, opcodeCB62, opcodeCB63, opcodeCB64, opcodeCB65, opcodeCB66, opcodeCB67,
    opcodeCB68, opcodeCB69, opcodeCB6A, opcodeCB6B, opcodeCB6C, opcodeCB6D, opcodeCB6E, opcodeCB6F,
    opcodeCB70, opcodeCB71, opcodeCB72, opcodeCB73, opcodeCB74, opcodeCB75, opcodeCB76, opcodeCB77,
    opcodeCB78, opcodeCB79, opcodeCB7A, opcodeCB7B, opcodeCB7C, opcodeCB7D, opcodeCB7E, opcodeCB7F,
    opcodeCB80, opcodeCB81, opcodeCB82, opcodeCB83, opcodeCB84, opcodeCB85, opcodeCB86, opcodeCB87,
    opcodeCB88, opcodeCB89, opcodeCB8A, opcodeCB8B, opcodeCB8C, opcodeCB8D, opcodeCB8E, opcodeCB8F,
    opcodeCB90, opcodeCB91, opcodeCB92, opcodeCB93, opcodeCB94, opcodeCB95, opcodeCB96, opcodeCB97,
    opcodeCB98, opcodeCB99, opcodeCB9A, opcodeCB9B, opcodeCB9C, opcodeCB9D, opcodeCB9E, opcodeCB9F,
    opcodeCBA0, opcodeCBA1, opcodeCBA2, opcodeCBA3, opcodeCBA4, opcodeCBA5, opcodeCBA6, opcodeCBA7,
    opcodeCBA8, opcodeCBA9, opcodeCBAA, opcodeCBAB, opcodeCBAC, opcodeCBAD, opcodeCBAE, opcodeCBAF,
    opcodeCBB0, opcodeCBB1, opcodeCBB2, opcodeCBB3, opcodeCBB4, opcodeCBB5, opcodeCBB6, opcodeCBB7,
    opcodeCBB8, opcodeCBB9, opcodeCBBA, opcodeCBBB, opcodeCBBC, opcodeCBBD, opcodeCBBE, opcodeCBBF,
    opcodeCBC0, opcodeCBC1, opcodeCBC2, opcodeCBC3, opcodeCBC4, opcodeCBC5, opcodeCBC6, opcodeCBC7,
    opcodeCBC8, opcodeCBC9, opcodeCBCA, opcodeCBCB, opcodeCBCC, opcodeCBCD, opcodeCBCE, opcodeCBCF,
    opcodeCBD0, opcodeCBD1, opcodeCBD2, opcodeCBD3, opcodeCBD4, opcodeCBD5, opcodeCBD6, opcodeCBD7,
    opcodeCBD8, opcodeCBD9, opcodeCBDA, opcodeCBDB, opcodeCBDC, opcodeCBDD, opcodeCBDE, opcodeCBDF,
    opcodeCBE0, opcodeCBE1, opcodeCBE2, opcodeCBE3, opcodeCBE4, opcodeCBE5, opcodeCBE6, opcodeCBE7,
    opcodeCBE8, opcodeCBE9, opcodeCBEA, opcodeCBEB, opcodeCBEC, opcodeCBED, opcodeCBEE, opcodeCBEF,
    opcodeCBF0, opcodeCBF1, opcodeCBF2, opcodeCBF3, opcodeCBF4, opcodeCBF5, opcodeCBF6, opcodeCBF7,
    opcodeCBF8, opcodeCBF9, opcodeCBFA, opcodeCBFB, opcodeCBFC, opcodeCBFD, opcodeCBFE, opcodeCBFF,
};

fn opcodeCB00(cpu: *Cpu) void {
    instructions.rlc(cpu, &cpu.registers.b);
    cpu.pc +%= 2;
}

fn opcodeCB01(cpu: *Cpu) void {
    instructions.rlc(cpu, &cpu.registers.c);
    cpu.pc +%= 2;
}

fn opcodeCB02(cpu: *Cpu) void {
    instructions.rlc(cpu, &cpu.registers.d);
    cpu.pc +%= 2;
}

fn opcodeCB03(cpu: *Cpu) void {
    instructions.rlc(cpu, &cpu.registers.e);
    cpu.pc +%= 2;
}

fn opcodeCB04(cpu: *Cpu) void {
    instructions.rlc(cpu, &cpu.registers.h);
    cpu.pc +%= 2;
}

fn opcodeCB05(cpu: *Cpu) void {
    instructions.rlc(cpu, &cpu.registers.l);
    cpu.pc +%= 2;
}

fn opcodeCB06(cpu: *Cpu) void {
    instructions.rlc(cpu, cpu.memory.getBytePtr(cpu.registers.getHL()));
    cpu.pc +%= 2;
}

fn opcodeCB07(cpu: *Cpu) void {
    instructions.rlc(cpu, &cpu.registers.a);
    cpu.pc +%= 2;
}

fn opcodeCB08(cpu: *Cpu) void {
    instructions.rrc(cpu, &cpu.registers.b);
    cpu.pc +%= 2;
}
pub fn opcodeCB09(cpu: *Cpu) void {
    instructions.rrc(cpu, &cpu.registers.c);
    cpu.pc +%= 2;
}

pub fn opcodeCB0A(cpu: *Cpu) void {
    instructions.rrc(cpu, &cpu.registers.d);
    cpu.pc +%= 2;
}

fn opcodeCB0B(cpu: *Cpu) void {
    instructions.rrc(cpu, &cpu.registers.e);
    cpu.pc +%= 2;
}

fn opcodeCB0C(cpu: *Cpu) void {
    instructions.rrc(cpu, &cpu.registers.h);
    cpu.pc +%= 2;
}

fn opcodeCB0D(cpu: *Cpu) void {
    instructions.rrc(cpu, &cpu.registers.l);
    cpu.pc +%= 2;
}

fn opcodeCB0E(cpu: *Cpu) void {
    instructions.rrc(cpu, cpu.memory.getBytePtr(cpu.registers.getHL()));
    cpu.pc +%= 2;
}

fn opcodeCB0F(cpu: *Cpu) void {
    instructions.rrc(cpu, &cpu.registers.a);
    cpu.pc +%= 2;
}

fn opcodeCB10(cpu: *Cpu) void {
    instructions.rl(cpu, &cpu.registers.b);
    cpu.pc +%= 2;
}

fn opcodeCB11(cpu: *Cpu) void {
    instructions.rl(cpu, &cpu.registers.c);
    cpu.pc +%= 2;
}

fn opcodeCB12(cpu: *Cpu) void {
    instructions.rl(cpu, &cpu.registers.d);
    cpu.pc +%= 2;
}

fn opcodeCB13(cpu: *Cpu) void {
    instructions.rl(cpu, &cpu.registers.e);
    cpu.pc +%= 2;
}

fn opcodeCB14(cpu: *Cpu) void {
    instructions.rl(cpu, &cpu.registers.h);
    cpu.pc +%= 2;
}

fn opcodeCB15(cpu: *Cpu) void {
    instructions.rl(cpu, &cpu.registers.l);
    cpu.pc +%= 2;
}

fn opcodeCB16(cpu: *Cpu) void {
    instructions.rl(cpu, cpu.memory.getBytePtr(cpu.registers.getHL()));
    cpu.pc +%= 2;
}

fn opcodeCB17(cpu: *Cpu) void {
    instructions.rl(cpu, &cpu.registers.a);
    cpu.pc +%= 2;
}

fn opcodeCB18(cpu: *Cpu) void {
    instructions.rr(cpu, &cpu.registers.b);
    cpu.pc +%= 2;
}

fn opcodeCB19(cpu: *Cpu) void {
    instructions.rr(cpu, &cpu.registers.c);
    cpu.pc +%= 2;
}

fn opcodeCB1A(cpu: *Cpu) void {
    instructions.rr(cpu, &cpu.registers.d);
    cpu.pc +%= 2;
}

fn opcodeCB1B(cpu: *Cpu) void {
    instructions.rr(cpu, &cpu.registers.e);
    cpu.pc +%= 2;
}

fn opcodeCB1C(cpu: *Cpu) void {
    instructions.rr(cpu, &cpu.registers.h);
    cpu.pc +%= 2;
}

fn opcodeCB1D(cpu: *Cpu) void {
    instructions.rr(cpu, &cpu.registers.l);
    cpu.pc +%= 2;
}

fn opcodeCB1E(cpu: *Cpu) void {
    instructions.rr(cpu, cpu.memory.getBytePtr(cpu.registers.getHL()));
    cpu.pc +%= 2;
}

fn opcodeCB1F(cpu: *Cpu) void {
    instructions.rr(cpu, &cpu.registers.a);
    cpu.pc +%= 2;
}

fn opcodeCB20(cpu: *Cpu) void {
    instructions.sla(cpu, &cpu.registers.b);
    cpu.pc +%= 2;
}

fn opcodeCB21(cpu: *Cpu) void {
    instructions.sla(cpu, &cpu.registers.c);
    cpu.pc +%= 2;
}

fn opcodeCB22(cpu: *Cpu) void {
    instructions.sla(cpu, &cpu.registers.d);
    cpu.pc +%= 2;
}

fn opcodeCB23(cpu: *Cpu) void {
    instructions.sla(cpu, &cpu.registers.e);
    cpu.pc +%= 2;
}

fn opcodeCB24(cpu: *Cpu) void {
    instructions.sla(cpu, &cpu.registers.h);
    cpu.pc +%= 2;
}

fn opcodeCB25(cpu: *Cpu) void {
    instructions.sla(cpu, &cpu.registers.l);
    cpu.pc +%= 2;
}

fn opcodeCB26(cpu: *Cpu) void {
    instructions.sla(cpu, cpu.memory.getBytePtr(cpu.registers.getHL()));
    cpu.pc +%= 2;
}

fn opcodeCB27(cpu: *Cpu) void {
    instructions.sla(cpu, &cpu.registers.a);
    cpu.pc +%= 2;
}

fn opcodeCB28(cpu: *Cpu) void {
    instructions.sra(cpu, &cpu.registers.b);
    cpu.pc +%= 2;
}

fn opcodeCB29(cpu: *Cpu) void {
    instructions.sra(cpu, &cpu.registers.c);
    cpu.pc +%= 2;
}

fn opcodeCB2A(cpu: *Cpu) void {
    instructions.sra(cpu, &cpu.registers.d);
    cpu.pc +%= 2;
}

fn opcodeCB2B(cpu: *Cpu) void {
    instructions.sra(cpu, &cpu.registers.e);
    cpu.pc +%= 2;
}

fn opcodeCB2C(cpu: *Cpu) void {
    instructions.sra(cpu, &cpu.registers.h);
    cpu.pc +%= 2;
}

fn opcodeCB2D(cpu: *Cpu) void {
    instructions.sra(cpu, &cpu.registers.l);
    cpu.pc +%= 2;
}

fn opcodeCB2E(cpu: *Cpu) void {
    instructions.sra(cpu, cpu.memory.getBytePtr(cpu.registers.getHL()));
    cpu.pc +%= 2;
}

fn opcodeCB2F(cpu: *Cpu) void {
    instructions.sra(cpu, &cpu.registers.a);
    cpu.pc +%= 2;
}

fn opcodeCB30(cpu: *Cpu) void {
    instructions.swap(cpu, &cpu.registers.b);
    cpu.pc +%= 2;
}

fn opcodeCB31(cpu: *Cpu) void {
    instructions.swap(cpu, &cpu.registers.c);
    cpu.pc +%= 2;
}

fn opcodeCB32(cpu: *Cpu) void {
    instructions.swap(cpu, &cpu.registers.d);
    cpu.pc +%= 2;
}

fn opcodeCB33(cpu: *Cpu) void {
    instructions.swap(cpu, &cpu.registers.e);
    cpu.pc +%= 2;
}

fn opcodeCB34(cpu: *Cpu) void {
    instructions.swap(cpu, &cpu.registers.h);
    cpu.pc +%= 2;
}

fn opcodeCB35(cpu: *Cpu) void {
    instructions.swap(cpu, &cpu.registers.l);
    cpu.pc +%= 2;
}

fn opcodeCB36(cpu: *Cpu) void {
    instructions.swap(cpu, cpu.memory.getBytePtr(cpu.registers.getHL()));
    cpu.pc +%= 2;
}

fn opcodeCB37(cpu: *Cpu) void {
    instructions.swap(cpu, &cpu.registers.a);
    cpu.pc +%= 2;
}

fn opcodeCB38(cpu: *Cpu) void {
    instructions.srl(cpu, &cpu.registers.b);
    cpu.pc +%= 2;
}

fn opcodeCB39(cpu: *Cpu) void {
    instructions.srl(cpu, &cpu.registers.c);
    cpu.pc +%= 2;
}

fn opcodeCB3A(cpu: *Cpu) void {
    instructions.srl(cpu, &cpu.registers.d);
    cpu.pc +%= 2;
}

fn opcodeCB3B(cpu: *Cpu) void {
    instructions.srl(cpu, &cpu.registers.e);
    cpu.pc +%= 2;
}

fn opcodeCB3C(cpu: *Cpu) void {
    instructions.srl(cpu, &cpu.registers.h);
    cpu.pc +%= 2;
}

fn opcodeCB3D(cpu: *Cpu) void {
    instructions.srl(cpu, &cpu.registers.l);
    cpu.pc +%= 2;
}

fn opcodeCB3E(cpu: *Cpu) void {
    instructions.srl(cpu, cpu.memory.getBytePtr(cpu.registers.getHL()));
    cpu.pc +%= 2;
}

fn opcodeCB3F(cpu: *Cpu) void {
    instructions.srl(cpu, &cpu.registers.a);
    cpu.pc +%= 2;
}

fn opcodeCB40(cpu: *Cpu) void {
    instructions.bit(cpu, 0, cpu.registers.b);
    cpu.pc +%= 2;
}

fn opcodeCB41(cpu: *Cpu) void {
    instructions.bit(cpu, 0, cpu.registers.c);
    cpu.pc +%= 2;
}

fn opcodeCB42(cpu: *Cpu) void {
    instructions.bit(cpu, 0, cpu.registers.d);
    cpu.pc +%= 2;
}

fn opcodeCB43(cpu: *Cpu) void {
    instructions.bit(cpu, 0, cpu.registers.e);
    cpu.pc +%= 2;
}

fn opcodeCB44(cpu: *Cpu) void {
    instructions.bit(cpu, 0, cpu.registers.h);
    cpu.pc +%= 2;
}

fn opcodeCB45(cpu: *Cpu) void {
    instructions.bit(cpu, 0, cpu.registers.l);
    cpu.pc +%= 2;
}

fn opcodeCB46(cpu: *Cpu) void {
    instructions.bit(cpu, 0, cpu.memory.readByte(cpu.registers.getHL()));
    cpu.pc +%= 2;
}

fn opcodeCB47(cpu: *Cpu) void {
    instructions.bit(cpu, 0, cpu.registers.a);
    cpu.pc +%= 2;
}

fn opcodeCB48(cpu: *Cpu) void {
    instructions.bit(cpu, 1, cpu.registers.b);
    cpu.pc +%= 2;
}

fn opcodeCB49(cpu: *Cpu) void {
    instructions.bit(cpu, 1, cpu.registers.c);
    cpu.pc +%= 2;
}

fn opcodeCB4A(cpu: *Cpu) void {
    instructions.bit(cpu, 1, cpu.registers.d);
    cpu.pc +%= 2;
}

fn opcodeCB4B(cpu: *Cpu) void {
    instructions.bit(cpu, 1, cpu.registers.e);
    cpu.pc +%= 2;
}

fn opcodeCB4C(cpu: *Cpu) void {
    instructions.bit(cpu, 1, cpu.registers.h);
    cpu.pc +%= 2;
}

fn opcodeCB4D(cpu: *Cpu) void {
    instructions.bit(cpu, 1, cpu.registers.l);
    cpu.pc +%= 2;
}

fn opcodeCB4E(cpu: *Cpu) void {
    instructions.bit(cpu, 1, cpu.memory.readByte(cpu.registers.getHL()));
    cpu.pc +%= 2;
}

fn opcodeCB4F(cpu: *Cpu) void {
    instructions.bit(cpu, 1, cpu.registers.a);
    cpu.pc +%= 2;
}

fn opcodeCB50(cpu: *Cpu) void {
    instructions.bit(cpu, 2, cpu.registers.b);
    cpu.pc +%= 2;
}

fn opcodeCB51(cpu: *Cpu) void {
    instructions.bit(cpu, 2, cpu.registers.c);
    cpu.pc +%= 2;
}

fn opcodeCB52(cpu: *Cpu) void {
    instructions.bit(cpu, 2, cpu.registers.d);
    cpu.pc +%= 2;
}

fn opcodeCB53(cpu: *Cpu) void {
    instructions.bit(cpu, 2, cpu.registers.e);
    cpu.pc +%= 2;
}

fn opcodeCB54(cpu: *Cpu) void {
    instructions.bit(cpu, 2, cpu.registers.h);
    cpu.pc +%= 2;
}

fn opcodeCB55(cpu: *Cpu) void {
    instructions.bit(cpu, 2, cpu.registers.l);
    cpu.pc +%= 2;
}

fn opcodeCB56(cpu: *Cpu) void {
    instructions.bit(cpu, 2, cpu.memory.readByte(cpu.registers.getHL()));
    cpu.pc +%= 2;
}

fn opcodeCB57(cpu: *Cpu) void {
    instructions.bit(cpu, 2, cpu.registers.a);
    cpu.pc +%= 2;
}

fn opcodeCB58(cpu: *Cpu) void {
    instructions.bit(cpu, 3, cpu.registers.b);
    cpu.pc +%= 2;
}

fn opcodeCB59(cpu: *Cpu) void {
    instructions.bit(cpu, 3, cpu.registers.c);
    cpu.pc +%= 2;
}

fn opcodeCB5A(cpu: *Cpu) void {
    instructions.bit(cpu, 3, cpu.registers.d);
    cpu.pc +%= 2;
}

fn opcodeCB5B(cpu: *Cpu) void {
    instructions.bit(cpu, 3, cpu.registers.e);
    cpu.pc +%= 2;
}

fn opcodeCB5C(cpu: *Cpu) void {
    instructions.bit(cpu, 3, cpu.registers.h);
    cpu.pc +%= 2;
}

fn opcodeCB5D(cpu: *Cpu) void {
    instructions.bit(cpu, 3, cpu.registers.l);
    cpu.pc +%= 2;
}

fn opcodeCB5E(cpu: *Cpu) void {
    instructions.bit(cpu, 3, cpu.memory.readByte(cpu.registers.getHL()));
    cpu.pc +%= 2;
}

fn opcodeCB5F(cpu: *Cpu) void {
    instructions.bit(cpu, 3, cpu.registers.a);
    cpu.pc +%= 2;
}

fn opcodeCB60(cpu: *Cpu) void {
    instructions.bit(cpu, 4, cpu.registers.b);
    cpu.pc +%= 2;
}

fn opcodeCB61(cpu: *Cpu) void {
    instructions.bit(cpu, 4, cpu.registers.c);
    cpu.pc +%= 2;
}

fn opcodeCB62(cpu: *Cpu) void {
    instructions.bit(cpu, 4, cpu.registers.d);
    cpu.pc +%= 2;
}

fn opcodeCB63(cpu: *Cpu) void {
    instructions.bit(cpu, 4, cpu.registers.e);
    cpu.pc +%= 2;
}

fn opcodeCB64(cpu: *Cpu) void {
    instructions.bit(cpu, 4, cpu.registers.h);
    cpu.pc +%= 2;
}

fn opcodeCB65(cpu: *Cpu) void {
    instructions.bit(cpu, 4, cpu.registers.l);
    cpu.pc +%= 2;
}

fn opcodeCB66(cpu: *Cpu) void {
    instructions.bit(cpu, 4, cpu.memory.readByte(cpu.registers.getHL()));
    cpu.pc +%= 2;
}

fn opcodeCB67(cpu: *Cpu) void {
    instructions.bit(cpu, 4, cpu.registers.a);
    cpu.pc +%= 2;
}

fn opcodeCB68(cpu: *Cpu) void {
    instructions.bit(cpu, 5, cpu.registers.b);
    cpu.pc +%= 2;
}

fn opcodeCB69(cpu: *Cpu) void {
    instructions.bit(cpu, 5, cpu.registers.c);
    cpu.pc +%= 2;
}

fn opcodeCB6A(cpu: *Cpu) void {
    instructions.bit(cpu, 5, cpu.registers.d);
    cpu.pc +%= 2;
}

fn opcodeCB6B(cpu: *Cpu) void {
    instructions.bit(cpu, 5, cpu.registers.e);
    cpu.pc +%= 2;
}

fn opcodeCB6C(cpu: *Cpu) void {
    instructions.bit(cpu, 5, cpu.registers.h);
    cpu.pc +%= 2;
}

fn opcodeCB6D(cpu: *Cpu) void {
    instructions.bit(cpu, 5, cpu.registers.l);
    cpu.pc +%= 2;
}

fn opcodeCB6E(cpu: *Cpu) void {
    instructions.bit(cpu, 5, cpu.memory.readByte(cpu.registers.getHL()));
    cpu.pc +%= 2;
}

fn opcodeCB6F(cpu: *Cpu) void {
    instructions.bit(cpu, 5, cpu.registers.a);
    cpu.pc +%= 2;
}

fn opcodeCB70(cpu: *Cpu) void {
    instructions.bit(cpu, 6, cpu.registers.b);
    cpu.pc +%= 2;
}

fn opcodeCB71(cpu: *Cpu) void {
    instructions.bit(cpu, 6, cpu.registers.c);
    cpu.pc +%= 2;
}

fn opcodeCB72(cpu: *Cpu) void {
    instructions.bit(cpu, 6, cpu.registers.d);
    cpu.pc +%= 2;
}

fn opcodeCB73(cpu: *Cpu) void {
    instructions.bit(cpu, 6, cpu.registers.e);
    cpu.pc +%= 2;
}

fn opcodeCB74(cpu: *Cpu) void {
    instructions.bit(cpu, 6, cpu.registers.h);
    cpu.pc +%= 2;
}

fn opcodeCB75(cpu: *Cpu) void {
    instructions.bit(cpu, 6, cpu.registers.l);
    cpu.pc +%= 2;
}

fn opcodeCB76(cpu: *Cpu) void {
    instructions.bit(cpu, 6, cpu.memory.readByte(cpu.registers.getHL()));
    cpu.pc +%= 2;
}

fn opcodeCB77(cpu: *Cpu) void {
    instructions.bit(cpu, 6, cpu.registers.a);
    cpu.pc +%= 2;
}

fn opcodeCB78(cpu: *Cpu) void {
    instructions.bit(cpu, 7, cpu.registers.b);
    cpu.pc +%= 2;
}

fn opcodeCB79(cpu: *Cpu) void {
    instructions.bit(cpu, 7, cpu.registers.c);
    cpu.pc +%= 2;
}

fn opcodeCB7A(cpu: *Cpu) void {
    instructions.bit(cpu, 7, cpu.registers.d);
    cpu.pc +%= 2;
}

fn opcodeCB7B(cpu: *Cpu) void {
    instructions.bit(cpu, 7, cpu.registers.e);
    cpu.pc +%= 2;
}

fn opcodeCB7C(cpu: *Cpu) void {
    instructions.bit(cpu, 7, cpu.registers.h);
    cpu.pc +%= 2;
}

fn opcodeCB7D(cpu: *Cpu) void {
    instructions.bit(cpu, 7, cpu.registers.l);
    cpu.pc +%= 2;
}

fn opcodeCB7E(cpu: *Cpu) void {
    instructions.bit(cpu, 7, cpu.memory.readByte(cpu.registers.getHL()));
    cpu.pc +%= 2;
}

fn opcodeCB7F(cpu: *Cpu) void {
    instructions.bit(cpu, 7, cpu.registers.a);
    cpu.pc +%= 2;
}

fn opcodeCB80(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.b, 0);
    cpu.pc +%= 2;
}

fn opcodeCB81(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.c, 0);
    cpu.pc +%= 2;
}

fn opcodeCB82(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.d, 0);
    cpu.pc +%= 2;
}

fn opcodeCB83(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.e, 0);
    cpu.pc +%= 2;
}

fn opcodeCB84(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.h, 0);
    cpu.pc +%= 2;
}

fn opcodeCB85(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.l, 0);
    cpu.pc +%= 2;
}

fn opcodeCB86(cpu: *Cpu) void {
    instructions.res(cpu, cpu.memory.getBytePtr(cpu.registers.getHL()), 0);
    cpu.pc +%= 2;
}

fn opcodeCB87(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.a, 0);
    cpu.pc +%= 2;
}

fn opcodeCB88(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.b, 1);
    cpu.pc +%= 2;
}

fn opcodeCB89(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.c, 1);
    cpu.pc +%= 2;
}

fn opcodeCB8A(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.d, 1);
    cpu.pc +%= 2;
}

fn opcodeCB8B(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.e, 1);
    cpu.pc +%= 2;
}

fn opcodeCB8C(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.h, 1);
    cpu.pc +%= 2;
}

fn opcodeCB8D(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.l, 1);
    cpu.pc +%= 2;
}

fn opcodeCB8E(cpu: *Cpu) void {
    instructions.res(cpu, cpu.memory.getBytePtr(cpu.registers.getHL()), 1);
    cpu.pc +%= 2;
}

fn opcodeCB8F(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.a, 1);
    cpu.pc +%= 2;
}

fn opcodeCB90(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.b, 2);
    cpu.pc +%= 2;
}

fn opcodeCB91(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.c, 2);
    cpu.pc +%= 2;
}

fn opcodeCB92(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.d, 2);
    cpu.pc +%= 2;
}

fn opcodeCB93(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.e, 2);
    cpu.pc +%= 2;
}

fn opcodeCB94(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.h, 2);
    cpu.pc +%= 2;
}

fn opcodeCB95(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.l, 2);
    cpu.pc +%= 2;
}

fn opcodeCB96(cpu: *Cpu) void {
    instructions.res(cpu, cpu.memory.getBytePtr(cpu.registers.getHL()), 2);
    cpu.pc +%= 2;
}

fn opcodeCB97(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.a, 2);
    cpu.pc +%= 2;
}

fn opcodeCB98(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.b, 3);
    cpu.pc +%= 2;
}

fn opcodeCB99(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.c, 3);
    cpu.pc +%= 2;
}

fn opcodeCB9A(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.d, 3);
    cpu.pc +%= 2;
}

fn opcodeCB9B(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.e, 3);
    cpu.pc +%= 2;
}

fn opcodeCB9C(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.h, 3);
    cpu.pc +%= 2;
}

fn opcodeCB9D(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.l, 3);
    cpu.pc +%= 2;
}

fn opcodeCB9E(cpu: *Cpu) void {
    instructions.res(cpu, cpu.memory.getBytePtr(cpu.registers.getHL()), 3);
    cpu.pc +%= 2;
}

fn opcodeCB9F(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.a, 3);
    cpu.pc +%= 2;
}

fn opcodeCBA0(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.b, 4);
    cpu.pc +%= 2;
}

fn opcodeCBA1(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.c, 4);
    cpu.pc +%= 2;
}

fn opcodeCBA2(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.d, 4);
    cpu.pc +%= 2;
}

fn opcodeCBA3(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.e, 4);
    cpu.pc +%= 2;
}

fn opcodeCBA4(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.h, 4);
    cpu.pc +%= 2;
}

fn opcodeCBA5(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.l, 4);
    cpu.pc +%= 2;
}

fn opcodeCBA6(cpu: *Cpu) void {
    instructions.res(cpu, cpu.memory.getBytePtr(cpu.registers.getHL()), 4);
    cpu.pc +%= 2;
}

fn opcodeCBA7(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.a, 4);
    cpu.pc +%= 2;
}

fn opcodeCBA8(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.b, 5);
    cpu.pc +%= 2;
}

fn opcodeCBA9(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.c, 5);
    cpu.pc +%= 2;
}

fn opcodeCBAA(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.d, 5);
    cpu.pc +%= 2;
}

fn opcodeCBAB(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.e, 5);
    cpu.pc +%= 2;
}

fn opcodeCBAC(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.h, 5);
    cpu.pc +%= 2;
}

fn opcodeCBAD(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.l, 5);
    cpu.pc +%= 2;
}

fn opcodeCBAE(cpu: *Cpu) void {
    instructions.res(cpu, cpu.memory.getBytePtr(cpu.registers.getHL()), 5);
    cpu.pc +%= 2;
}

fn opcodeCBAF(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.a, 5);
    cpu.pc +%= 2;
}

fn opcodeCBB0(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.b, 6);
    cpu.pc +%= 2;
}

fn opcodeCBB1(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.c, 6);
    cpu.pc +%= 2;
}

fn opcodeCBB2(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.d, 6);
    cpu.pc +%= 2;
}

fn opcodeCBB3(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.e, 6);
    cpu.pc +%= 2;
}

fn opcodeCBB4(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.h, 6);
    cpu.pc +%= 2;
}

fn opcodeCBB5(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.l, 6);
    cpu.pc +%= 2;
}

fn opcodeCBB6(cpu: *Cpu) void {
    instructions.res(cpu, cpu.memory.getBytePtr(cpu.registers.getHL()), 6);
    cpu.pc +%= 2;
}

fn opcodeCBB7(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.a, 6);
    cpu.pc +%= 2;
}

fn opcodeCBB8(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.b, 7);
    cpu.pc +%= 2;
}

fn opcodeCBB9(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.c, 7);
    cpu.pc +%= 2;
}

fn opcodeCBBA(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.d, 7);
    cpu.pc +%= 2;
}

fn opcodeCBBB(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.e, 7);
    cpu.pc +%= 2;
}

fn opcodeCBBC(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.h, 7);
    cpu.pc +%= 2;
}

fn opcodeCBBD(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.l, 7);
    cpu.pc +%= 2;
}

fn opcodeCBBE(cpu: *Cpu) void {
    instructions.res(cpu, cpu.memory.getBytePtr(cpu.registers.getHL()), 7);
    cpu.pc +%= 2;
}

fn opcodeCBBF(cpu: *Cpu) void {
    instructions.res(cpu, &cpu.registers.a, 7);
    cpu.pc +%= 2;
}

fn opcodeCBC0(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.b, 0);
    cpu.pc +%= 2;
}

fn opcodeCBC1(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.c, 0);
    cpu.pc +%= 2;
}

fn opcodeCBC2(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.d, 0);
    cpu.pc +%= 2;
}

fn opcodeCBC3(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.e, 0);
    cpu.pc +%= 2;
}

fn opcodeCBC4(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.h, 0);
    cpu.pc +%= 2;
}

fn opcodeCBC5(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.l, 0);
    cpu.pc +%= 2;
}

fn opcodeCBC6(cpu: *Cpu) void {
    instructions.set(cpu, cpu.memory.getBytePtr(cpu.registers.getHL()), 0);
    cpu.pc +%= 2;
}

fn opcodeCBC7(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.a, 0);
    cpu.pc +%= 2;
}

fn opcodeCBC8(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.b, 1);
    cpu.pc +%= 2;
}

fn opcodeCBC9(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.c, 1);
    cpu.pc +%= 2;
}

fn opcodeCBCA(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.d, 1);
    cpu.pc +%= 2;
}

fn opcodeCBCB(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.e, 1);
    cpu.pc +%= 2;
}

fn opcodeCBCC(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.h, 1);
    cpu.pc +%= 2;
}

fn opcodeCBCD(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.l, 1);
    cpu.pc +%= 2;
}

fn opcodeCBCE(cpu: *Cpu) void {
    instructions.set(cpu, cpu.memory.getBytePtr(cpu.registers.getHL()), 1);
    cpu.pc +%= 2;
}

fn opcodeCBCF(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.a, 1);
    cpu.pc +%= 2;
}

fn opcodeCBD0(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.b, 2);
    cpu.pc +%= 2;
}

fn opcodeCBD1(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.c, 2);
    cpu.pc +%= 2;
}

fn opcodeCBD2(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.d, 2);
    cpu.pc +%= 2;
}

fn opcodeCBD3(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.e, 2);
    cpu.pc +%= 2;
}

fn opcodeCBD4(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.h, 2);
    cpu.pc +%= 2;
}

fn opcodeCBD5(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.l, 2);
    cpu.pc +%= 2;
}

fn opcodeCBD6(cpu: *Cpu) void {
    instructions.set(cpu, cpu.memory.getBytePtr(cpu.registers.getHL()), 2);
    cpu.pc +%= 2;
}

fn opcodeCBD7(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.a, 2);
    cpu.pc +%= 2;
}

fn opcodeCBD8(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.b, 3);
    cpu.pc +%= 2;
}

fn opcodeCBD9(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.c, 3);
    cpu.pc +%= 2;
}

fn opcodeCBDA(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.d, 3);
    cpu.pc +%= 2;
}

fn opcodeCBDB(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.e, 3);
    cpu.pc +%= 2;
}

fn opcodeCBDC(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.h, 3);
    cpu.pc +%= 2;
}

fn opcodeCBDD(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.l, 3);
    cpu.pc +%= 2;
}

fn opcodeCBDE(cpu: *Cpu) void {
    instructions.set(cpu, cpu.memory.getBytePtr(cpu.registers.getHL()), 3);
    cpu.pc +%= 2;
}

fn opcodeCBDF(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.a, 3);
    cpu.pc +%= 2;
}

fn opcodeCBE0(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.b, 4);
    cpu.pc +%= 2;
}

fn opcodeCBE1(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.c, 4);
    cpu.pc +%= 2;
}

fn opcodeCBE2(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.d, 4);
    cpu.pc +%= 2;
}

fn opcodeCBE3(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.e, 4);
    cpu.pc +%= 2;
}

fn opcodeCBE4(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.h, 4);
    cpu.pc +%= 2;
}

fn opcodeCBE5(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.l, 4);
    cpu.pc +%= 2;
}

fn opcodeCBE6(cpu: *Cpu) void {
    instructions.set(cpu, cpu.memory.getBytePtr(cpu.registers.getHL()), 4);
    cpu.pc +%= 2;
}

fn opcodeCBE7(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.a, 4);
    cpu.pc +%= 2;
}

fn opcodeCBE8(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.b, 5);
    cpu.pc +%= 2;
}

fn opcodeCBE9(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.c, 5);
    cpu.pc +%= 2;
}

fn opcodeCBEA(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.d, 5);
    cpu.pc +%= 2;
}

fn opcodeCBEB(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.e, 5);
    cpu.pc +%= 2;
}

fn opcodeCBEC(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.h, 5);
    cpu.pc +%= 2;
}

fn opcodeCBED(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.l, 5);
    cpu.pc +%= 2;
}

fn opcodeCBEE(cpu: *Cpu) void {
    instructions.set(cpu, cpu.memory.getBytePtr(cpu.registers.getHL()), 5);
    cpu.pc +%= 2;
}

fn opcodeCBEF(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.a, 5);
    cpu.pc +%= 2;
}

fn opcodeCBF0(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.b, 6);
    cpu.pc +%= 2;
}

fn opcodeCBF1(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.c, 6);
    cpu.pc +%= 2;
}

fn opcodeCBF2(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.d, 6);
    cpu.pc +%= 2;
}

fn opcodeCBF3(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.e, 6);
    cpu.pc +%= 2;
}

fn opcodeCBF4(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.h, 6);
    cpu.pc +%= 2;
}

fn opcodeCBF5(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.l, 6);
    cpu.pc +%= 2;
}

fn opcodeCBF6(cpu: *Cpu) void {
    instructions.set(cpu, cpu.memory.getBytePtr(cpu.registers.getHL()), 6);
    cpu.pc +%= 2;
}

fn opcodeCBF7(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.a, 6);
    cpu.pc +%= 2;
}

fn opcodeCBF8(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.b, 7);
    cpu.pc +%= 2;
}

fn opcodeCBF9(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.c, 7);
    cpu.pc +%= 2;
}

fn opcodeCBFA(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.d, 7);
    cpu.pc +%= 2;
}

fn opcodeCBFB(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.e, 7);
    cpu.pc +%= 2;
}

fn opcodeCBFC(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.h, 7);
    cpu.pc +%= 2;
}

fn opcodeCBFD(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.l, 7);
    cpu.pc +%= 2;
}

fn opcodeCBFE(cpu: *Cpu) void {
    instructions.set(cpu, cpu.memory.getBytePtr(cpu.registers.getHL()), 7);
    cpu.pc +%= 2;
}

fn opcodeCBFF(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.a, 7);
    cpu.pc +%= 2;
}
