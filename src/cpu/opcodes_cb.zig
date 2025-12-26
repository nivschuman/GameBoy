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

pub const opcodes_cb_names: [256][]const u8 = .{
    "RLC B",   "RLC C",   "RLC D",      "RLC E",
    "RLC H",   "RLC L",   "RLC (HL)",   "RLC A",
    "RRC B",   "RRC C",   "RRC D",      "RRC E",
    "RRC H",   "RRC L",   "RRC (HL)",   "RRC A",
    "RL B",    "RL C",    "RL D",       "RL E",
    "RL H",    "RL L",    "RL (HL)",    "RL A",
    "RR B",    "RR C",    "RR D",       "RR E",
    "RR H",    "RR L",    "RR (HL)",    "RR A",
    "SLA B",   "SLA C",   "SLA D",      "SLA E",
    "SLA H",   "SLA L",   "SLA (HL)",   "SLA A",
    "SRA B",   "SRA C",   "SRA D",      "SRA E",
    "SRA H",   "SRA L",   "SRA (HL)",   "SRA A",
    "SWAP B",  "SWAP C",  "SWAP D",     "SWAP E",
    "SWAP H",  "SWAP L",  "SWAP (HL)",  "SWAP A",
    "SRL B",   "SRL C",   "SRL D",      "SRL E",
    "SRL H",   "SRL L",   "SRL (HL)",   "SRL A",
    "BIT 0,B", "BIT 0,C", "BIT 0,D",    "BIT 0,E",
    "BIT 0,H", "BIT 0,L", "BIT 0,(HL)", "BIT 0,A",
    "BIT 1,B", "BIT 1,C", "BIT 1,D",    "BIT 1,E",
    "BIT 1,H", "BIT 1,L", "BIT 1,(HL)", "BIT 1,A",
    "BIT 2,B", "BIT 2,C", "BIT 2,D",    "BIT 2,E",
    "BIT 2,H", "BIT 2,L", "BIT 2,(HL)", "BIT 2,A",
    "BIT 3,B", "BIT 3,C", "BIT 3,D",    "BIT 3,E",
    "BIT 3,H", "BIT 3,L", "BIT 3,(HL)", "BIT 3,A",
    "BIT 4,B", "BIT 4,C", "BIT 4,D",    "BIT 4,E",
    "BIT 4,H", "BIT 4,L", "BIT 4,(HL)", "BIT 4,A",
    "BIT 5,B", "BIT 5,C", "BIT 5,D",    "BIT 5,E",
    "BIT 5,H", "BIT 5,L", "BIT 5,(HL)", "BIT 5,A",
    "BIT 6,B", "BIT 6,C", "BIT 6,D",    "BIT 6,E",
    "BIT 6,H", "BIT 6,L", "BIT 6,(HL)", "BIT 6,A",
    "BIT 7,B", "BIT 7,C", "BIT 7,D",    "BIT 7,E",
    "BIT 7,H", "BIT 7,L", "BIT 7,(HL)", "BIT 7,A",
    "RES 0,B", "RES 0,C", "RES 0,D",    "RES 0,E",
    "RES 0,H", "RES 0,L", "RES 0,(HL)", "RES 0,A",
    "RES 1,B", "RES 1,C", "RES 1,D",    "RES 1,E",
    "RES 1,H", "RES 1,L", "RES 1,(HL)", "RES 1,A",
    "RES 2,B", "RES 2,C", "RES 2,D",    "RES 2,E",
    "RES 2,H", "RES 2,L", "RES 2,(HL)", "RES 2,A",
    "RES 3,B", "RES 3,C", "RES 3,D",    "RES 3,E",
    "RES 3,H", "RES 3,L", "RES 3,(HL)", "RES 3,A",
    "RES 4,B", "RES 4,C", "RES 4,D",    "RES 4,E",
    "RES 4,H", "RES 4,L", "RES 4,(HL)", "RES 4,A",
    "RES 5,B", "RES 5,C", "RES 5,D",    "RES 5,E",
    "RES 5,H", "RES 5,L", "RES 5,(HL)", "RES 5,A",
    "RES 6,B", "RES 6,C", "RES 6,D",    "RES 6,E",
    "RES 6,H", "RES 6,L", "RES 6,(HL)", "RES 6,A",
    "RES 7,B", "RES 7,C", "RES 7,D",    "RES 7,E",
    "RES 7,H", "RES 7,L", "RES 7,(HL)", "RES 7,A",
    "SET 0,B", "SET 0,C", "SET 0,D",    "SET 0,E",
    "SET 0,H", "SET 0,L", "SET 0,(HL)", "SET 0,A",
    "SET 1,B", "SET 1,C", "SET 1,D",    "SET 1,E",
    "SET 1,H", "SET 1,L", "SET 1,(HL)", "SET 1,A",
    "SET 2,B", "SET 2,C", "SET 2,D",    "SET 2,E",
    "SET 2,H", "SET 2,L", "SET 2,(HL)", "SET 2,A",
    "SET 3,B", "SET 3,C", "SET 3,D",    "SET 3,E",
    "SET 3,H", "SET 3,L", "SET 3,(HL)", "SET 3,A",
    "SET 4,B", "SET 4,C", "SET 4,D",    "SET 4,E",
    "SET 4,H", "SET 4,L", "SET 4,(HL)", "SET 4,A",
    "SET 5,B", "SET 5,C", "SET 5,D",    "SET 5,E",
    "SET 5,H", "SET 5,L", "SET 5,(HL)", "SET 5,A",
    "SET 6,B", "SET 6,C", "SET 6,D",    "SET 6,E",
    "SET 6,H", "SET 6,L", "SET 6,(HL)", "SET 6,A",
    "SET 7,B", "SET 7,C", "SET 7,D",    "SET 7,E",
    "SET 7,H", "SET 7,L", "SET 7,(HL)", "SET 7,A",
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
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.rlc(cpu, &target);
    cpu.writeByte(cpu.registers.getHL(), target);
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
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.rrc(cpu, &target);
    cpu.writeByte(cpu.registers.getHL(), target);
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
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.rl(cpu, &target);
    cpu.writeByte(cpu.registers.getHL(), target);
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
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.rr(cpu, &target);
    cpu.writeByte(cpu.registers.getHL(), target);
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
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.sla(cpu, &target);
    cpu.writeByte(cpu.registers.getHL(), target);
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
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.sra(cpu, &target);
    cpu.writeByte(cpu.registers.getHL(), target);
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
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.swap(cpu, &target);
    cpu.writeByte(cpu.registers.getHL(), target);
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
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.srl(cpu, &target);
    cpu.writeByte(cpu.registers.getHL(), target);
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
    instructions.bit(cpu, 0, cpu.readByte(cpu.registers.getHL()));
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
    instructions.bit(cpu, 1, cpu.readByte(cpu.registers.getHL()));
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
    instructions.bit(cpu, 2, cpu.readByte(cpu.registers.getHL()));
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
    instructions.bit(cpu, 3, cpu.readByte(cpu.registers.getHL()));
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
    instructions.bit(cpu, 4, cpu.readByte(cpu.registers.getHL()));
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
    instructions.bit(cpu, 5, cpu.readByte(cpu.registers.getHL()));
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
    instructions.bit(cpu, 6, cpu.readByte(cpu.registers.getHL()));
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
    instructions.bit(cpu, 7, cpu.readByte(cpu.registers.getHL()));
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
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.res(cpu, &target, 0);
    cpu.writeByte(cpu.registers.getHL(), target);
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
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.res(cpu, &target, 1);
    cpu.writeByte(cpu.registers.getHL(), target);
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
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.res(cpu, &target, 2);
    cpu.writeByte(cpu.registers.getHL(), target);
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
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.res(cpu, &target, 3);
    cpu.writeByte(cpu.registers.getHL(), target);
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
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.res(cpu, &target, 4);
    cpu.writeByte(cpu.registers.getHL(), target);
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
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.res(cpu, &target, 5);
    cpu.writeByte(cpu.registers.getHL(), target);
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
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.res(cpu, &target, 6);
    cpu.writeByte(cpu.registers.getHL(), target);
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
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.res(cpu, &target, 7);
    cpu.writeByte(cpu.registers.getHL(), target);
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
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.set(cpu, &target, 0);
    cpu.writeByte(cpu.registers.getHL(), target);
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
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.set(cpu, &target, 1);
    cpu.writeByte(cpu.registers.getHL(), target);
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
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.set(cpu, &target, 2);
    cpu.writeByte(cpu.registers.getHL(), target);
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
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.set(cpu, &target, 3);
    cpu.writeByte(cpu.registers.getHL(), target);
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
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.set(cpu, &target, 4);
    cpu.writeByte(cpu.registers.getHL(), target);
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
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.set(cpu, &target, 5);
    cpu.writeByte(cpu.registers.getHL(), target);
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
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.set(cpu, &target, 6);
    cpu.writeByte(cpu.registers.getHL(), target);
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
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.set(cpu, &target, 7);
    cpu.writeByte(cpu.registers.getHL(), target);
    cpu.pc +%= 2;
}

fn opcodeCBFF(cpu: *Cpu) void {
    instructions.set(cpu, &cpu.registers.a, 7);
    cpu.pc +%= 2;
}
