const Cpu = @import("cpu.zig").Cpu;
const instructions = @import("instructions.zig");
const opcodes_cb_table = @import("opcodes_cb.zig").opcodes_cb_table;

pub const opcodes_table: [256]*const fn (*Cpu) void = .{
    opcode00, opcode01, opcode02, opcode03, opcode04, opcode05, opcode06, opcode07,
    opcode08, opcode09, opcode0A, opcode0B, opcode0C, opcode0D, opcode0E, opcode0F,
    opcode10, opcode11, opcode12, opcode13, opcode14, opcode15, opcode16, opcode17,
    opcode18, opcode19, opcode1A, opcode1B, opcode1C, opcode1D, opcode1E, opcode1F,
    opcode20, opcode21, opcode22, opcode23, opcode24, opcode25, opcode26, opcode27,
    opcode28, opcode29, opcode2A, opcode2B, opcode2C, opcode2D, opcode2E, opcode2F,
    opcode30, opcode31, opcode32, opcode33, opcode34, opcode35, opcode36, opcode37,
    opcode38, opcode39, opcode3A, opcode3B, opcode3C, opcode3D, opcode3E, opcode3F,
    opcode40, opcode41, opcode42, opcode43, opcode44, opcode45, opcode46, opcode47,
    opcode48, opcode49, opcode4A, opcode4B, opcode4C, opcode4D, opcode4E, opcode4F,
    opcode50, opcode51, opcode52, opcode53, opcode54, opcode55, opcode56, opcode57,
    opcode58, opcode59, opcode5A, opcode5B, opcode5C, opcode5D, opcode5E, opcode5F,
    opcode60, opcode61, opcode62, opcode63, opcode64, opcode65, opcode66, opcode67,
    opcode68, opcode69, opcode6A, opcode6B, opcode6C, opcode6D, opcode6E, opcode6F,
    opcode70, opcode71, opcode72, opcode73, opcode74, opcode75, opcode76, opcode77,
    opcode78, opcode79, opcode7A, opcode7B, opcode7C, opcode7D, opcode7E, opcode7F,
    opcode80, opcode81, opcode82, opcode83, opcode84, opcode85, opcode86, opcode87,
    opcode88, opcode89, opcode8A, opcode8B, opcode8C, opcode8D, opcode8E, opcode8F,
    opcode90, opcode91, opcode92, opcode93, opcode94, opcode95, opcode96, opcode97,
    opcode98, opcode99, opcode9A, opcode9B, opcode9C, opcode9D, opcode9E, opcode9F,
    opcodeA0, opcodeA1, opcodeA2, opcodeA3, opcodeA4, opcodeA5, opcodeA6, opcodeA7,
    opcodeA8, opcodeA9, opcodeAA, opcodeAB, opcodeAC, opcodeAD, opcodeAE, opcodeAF,
    opcodeB0, opcodeB1, opcodeB2, opcodeB3, opcodeB4, opcodeB5, opcodeB6, opcodeB7,
    opcodeB8, opcodeB9, opcodeBA, opcodeBB, opcodeBC, opcodeBD, opcodeBE, opcodeBF,
    opcodeC0, opcodeC1, opcodeC2, opcodeC3, opcodeC4, opcodeC5, opcodeC6, opcodeC7,
    opcodeC8, opcodeC9, opcodeCA, opcodeCB, opcodeCC, opcodeCD, opcodeCE, opcodeCF,
    opcodeD0, opcodeD1, opcodeD2, opcodeNA, opcodeD4, opcodeD5, opcodeD6, opcodeD7,
    opcodeD8, opcodeD9, opcodeDA, opcodeNA, opcodeDC, opcodeNA, opcodeDE, opcodeDF,
    opcodeE0, opcodeE1, opcodeE2, opcodeNA, opcodeNA, opcodeE5, opcodeE6, opcodeE7,
    opcodeE8, opcodeE9, opcodeEA, opcodeNA, opcodeNA, opcodeNA, opcodeEE, opcodeEF,
    opcodeF0, opcodeF1, opcodeF2, opcodeF3, opcodeNA, opcodeF5, opcodeF6, opcodeF7,
    opcodeF8, opcodeF9, opcodeFA, opcodeFB, opcodeNA, opcodeNA, opcodeFE, opcodeFF,
};

pub const opcode_names: [256][]const u8 = .{ "NOP", "LD BC, d16", "LD (BC), A", "INC BC", "INC B", "DEC B", "LD B, d8", "RLCA", "LD (a16), SP", "ADD HL, BC", "LD A, (BC)", "DEC BC", "INC C", "DEC C", "LD C, d8", "RRCA", "INVALID", "LD DE, d16", "LD (DE), A", "INC DE", "INC D", "DEC D", "LD D, d8", "RLA", "JR s8", "ADD HL, DE", "LD A, (DE)", "DEC DE", "INC E", "DEC E", "LD E, d8", "RRA", "JR NZ, s8", "LD HL, d16", "LD (HL+), A", "INC HL", "INC H", "DEC H", "LD H, d8", "DAA", "JR Z, s8", "ADD HL, HL", "LD A, (HL+)", "DEC HL", "INC L", "DEC L", "LD L, d8", "CPL", "JR NC, s8", "LD SP, d16", "LD (HL-), A", "INC SP", "INC (HL)", "DEC (HL)", "LD (HL), d8", "SCF", "JR C, s8", "ADD HL, SP", "LD A, (HL-)", "DEC SP", "INC A", "DEC A", "LD A, d8", "CCF", "LD B, B", "LD B, C", "LD B, D", "LD B, E", "LD B, H", "LD B, L", "LD B, (HL)", "LD B, A", "LD C, B", "LD C, C", "LD C, D", "LD C, E", "LD C, H", "LD C, L", "LD C, (HL)", "LD C, A", "LD D, B", "LD D, C", "LD D, D", "LD D, E", "LD D, H", "LD D, L", "LD D, (HL)", "LD D, A", "LD E, B", "LD E, C", "LD E, D", "LD E, E", "LD E, H", "LD E, L", "LD E, (HL)", "LD E, A", "LD H, B", "LD H, C", "LD H, D", "LD H, E", "LD H, H", "LD H, L", "LD H, (HL)", "LD H, A", "LD L, B", "LD L, C", "LD L, D", "LD L, E", "LD L, H", "LD L, L", "LD L, (HL)", "LD L, A", "LD (HL), B", "LD (HL), C", "LD (HL), D", "LD (HL), E", "LD (HL), H", "LD (HL), L", "HALT", "LD (HL), A", "LD A, B", "LD A, C", "LD A, D", "LD A, E", "LD A, H", "LD A, L", "LD A, (HL)", "LD A, A", "ADD A, B", "ADD A, C", "ADD A, D", "ADD A, E", "ADD A, H", "ADD A, L", "ADD A, (HL)", "ADD A, A", "ADC A, B", "ADC A, C", "ADC A, D", "ADC A, E", "ADC A, H", "ADC A, L", "ADC A, (HL)", "ADC A, A", "SUB B", "SUB C", "SUB D", "SUB E", "SUB H", "SUB L", "SUB (HL)", "SUB A", "SBC A, B", "SBC A, C", "SBC A, D", "SBC A, E", "SBC A, H", "SBC A, L", "SBC A, (HL)", "SBC A, A", "AND B", "AND C", "AND D", "AND E", "AND H", "AND L", "AND (HL)", "AND A", "XOR B", "XOR C", "XOR D", "XOR E", "XOR H", "XOR L", "XOR (HL)", "XOR A", "OR B", "OR C", "OR D", "OR E", "OR H", "OR L", "OR (HL)", "OR A", "CP B", "CP C", "CP D", "CP E", "CP H", "CP L", "CP (HL)", "CP A", "RET NZ", "POP BC", "JP NZ, a16", "JP a16", "CALL NZ, a16", "PUSH BC", "ADD A, d8", "RST 0", "RET Z", "RET", "JP Z, a16", "INVALID", "CALL Z, a16", "CALL a16", "ADC A, d8", "RST 1", "RET NC", "POP DE", "JP NC, a16", "INVALID", "CALL NC, a16", "PUSH DE", "SUB d8", "RST 2", "RET C", "RETI", "JP C, a16", "INVALID", "CALL C, a16", "INVALID", "SBC A, d8", "RST 3", "LD (a8), A", "POP HL", "LD (C), A", "INVALID", "INVALID", "PUSH HL", "AND d8", "RST 4", "ADD SP, s8", "JP HL", "LD (a16), A", "INVALID", "INVALID", "INVALID", "XOR d8", "RST 5", "LD A, (a8)", "POP AF", "LD A, (C)", "DI", "INVALID", "PUSH AF", "OR d8", "RST 6", "LD HL, SP+s8", "LD SP, HL", "LD A, (a16)", "EI", "INVALID", "INVALID", "CP d8", "RST 7" };

fn opcodeNA(_: *Cpu) void {
    @panic("invalid opcode");
}

fn opcode00(cpu: *Cpu) void {
    cpu.pc +%= 1;
}

fn opcode01(cpu: *Cpu) void {
    cpu.registers.setBC(cpu.d16());
    cpu.pc +%= 3;
}

fn opcode02(cpu: *Cpu) void {
    cpu.writeByte(cpu.registers.getBC(), cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcode03(cpu: *Cpu) void {
    cpu.cycle_manager.cycle(1);
    cpu.registers.setBC(cpu.registers.getBC() +% 1);
    cpu.pc +%= 1;
}

fn opcode04(cpu: *Cpu) void {
    instructions.inc(cpu, &cpu.registers.b);
    cpu.pc +%= 1;
}

fn opcode05(cpu: *Cpu) void {
    instructions.dec(cpu, &cpu.registers.b);
    cpu.pc +%= 1;
}

fn opcode06(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.b, cpu.d8());
    cpu.pc +%= 2;
}

fn opcode07(cpu: *Cpu) void {
    instructions.rlc(cpu, &cpu.registers.a);
    cpu.registers.setZeroFlag(false); // RLCA always clears zero flag
    cpu.pc +%= 1;
}

fn opcode08(cpu: *Cpu) void {
    cpu.writeWord(cpu.d16(), cpu.sp);
    cpu.pc +%= 3;
}

fn opcode09(cpu: *Cpu) void {
    var target = cpu.registers.getHL();
    instructions.addWords(cpu, &target, cpu.registers.getBC());
    cpu.registers.setHL(target);
    cpu.pc +%= 1;
}

fn opcode0A(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.a, cpu.readByte(cpu.registers.getBC()));
    cpu.pc +%= 1;
}

fn opcode0B(cpu: *Cpu) void {
    cpu.cycle_manager.cycle(1);
    cpu.registers.setBC(cpu.registers.getBC() -% 1);
    cpu.pc +%= 1;
}

fn opcode0C(cpu: *Cpu) void {
    instructions.inc(cpu, &cpu.registers.c);
    cpu.pc +%= 1;
}

fn opcode0D(cpu: *Cpu) void {
    instructions.dec(cpu, &cpu.registers.c);
    cpu.pc +%= 1;
}

fn opcode0E(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.c, cpu.d8());
    cpu.pc +%= 2;
}

fn opcode0F(cpu: *Cpu) void {
    instructions.rrc(cpu, &cpu.registers.a);
    cpu.registers.setZeroFlag(false); // RRCA always clears zero flag
    cpu.pc +%= 1;
}

fn opcode10(cpu: *Cpu) void {
    instructions.stop(cpu);
    cpu.pc +%= 1;
}

fn opcode11(cpu: *Cpu) void {
    cpu.registers.setDE(cpu.d16());
    cpu.pc +%= 3;
}

fn opcode12(cpu: *Cpu) void {
    cpu.writeByte(cpu.registers.getDE(), cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcode13(cpu: *Cpu) void {
    cpu.cycle_manager.cycle(1);
    cpu.registers.setDE(cpu.registers.getDE() +% 1);
    cpu.pc +%= 1;
}

fn opcode14(cpu: *Cpu) void {
    instructions.inc(cpu, &cpu.registers.d);
    cpu.pc +%= 1;
}

fn opcode15(cpu: *Cpu) void {
    instructions.dec(cpu, &cpu.registers.d);
    cpu.pc +%= 1;
}

fn opcode16(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.d, cpu.d8());
    cpu.pc +%= 2;
}

fn opcode17(cpu: *Cpu) void {
    instructions.rl(cpu, &cpu.registers.a);
    cpu.registers.setZeroFlag(false); // RLA always clears zero flag
    cpu.pc +%= 1;
}

fn opcode18(cpu: *Cpu) void {
    const jmp = cpu.s8();
    cpu.pc +%= 2;
    instructions.jr(cpu, jmp, true);
}

fn opcode19(cpu: *Cpu) void {
    var target = cpu.registers.getHL();
    instructions.addWords(cpu, &target, cpu.registers.getDE());
    cpu.registers.setHL(target);
    cpu.pc +%= 1;
}

fn opcode1A(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.a, cpu.readByte(cpu.registers.getDE()));
    cpu.pc +%= 1;
}

fn opcode1B(cpu: *Cpu) void {
    cpu.cycle_manager.cycle(1);
    cpu.registers.setDE(cpu.registers.getDE() -% 1);
    cpu.pc +%= 1;
}

fn opcode1C(cpu: *Cpu) void {
    instructions.inc(cpu, &cpu.registers.e);
    cpu.pc +%= 1;
}

fn opcode1D(cpu: *Cpu) void {
    instructions.dec(cpu, &cpu.registers.e);
    cpu.pc +%= 1;
}

fn opcode1E(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.e, cpu.d8());
    cpu.pc +%= 2;
}

fn opcode1F(cpu: *Cpu) void {
    instructions.rr(cpu, &cpu.registers.a);
    cpu.registers.setZeroFlag(false); // RRA always clears zero flag
    cpu.pc +%= 1;
}

fn opcode20(cpu: *Cpu) void {
    const jmp = cpu.s8();
    cpu.pc +%= 2;
    instructions.jr(cpu, jmp, !cpu.registers.getZeroFlag());
}

fn opcode21(cpu: *Cpu) void {
    cpu.registers.setHL(cpu.d16());
    cpu.pc +%= 3;
}

fn opcode22(cpu: *Cpu) void {
    cpu.writeByte(cpu.registers.getHL(), cpu.registers.a);
    cpu.registers.setHL(cpu.registers.getHL() +% 1);
    cpu.pc +%= 1;
}

fn opcode23(cpu: *Cpu) void {
    cpu.cycle_manager.cycle(1);
    cpu.registers.setHL(cpu.registers.getHL() +% 1);
    cpu.pc +%= 1;
}

fn opcode24(cpu: *Cpu) void {
    instructions.inc(cpu, &cpu.registers.h);
    cpu.pc +%= 1;
}

fn opcode25(cpu: *Cpu) void {
    instructions.dec(cpu, &cpu.registers.h);
    cpu.pc +%= 1;
}

fn opcode26(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.h, cpu.d8());
    cpu.pc +%= 2;
}

fn opcode27(cpu: *Cpu) void {
    instructions.daa(cpu, &cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcode28(cpu: *Cpu) void {
    const jmp = cpu.s8();
    cpu.pc +%= 2;
    instructions.jr(cpu, jmp, cpu.registers.getZeroFlag());
}

fn opcode29(cpu: *Cpu) void {
    var target = cpu.registers.getHL();
    instructions.addWords(cpu, &target, cpu.registers.getHL());
    cpu.registers.setHL(target);
    cpu.pc +%= 1;
}

fn opcode2A(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.a, cpu.readByte(cpu.registers.getHL()));
    cpu.registers.setHL(cpu.registers.getHL() +% 1);
    cpu.pc +%= 1;
}

fn opcode2B(cpu: *Cpu) void {
    cpu.cycle_manager.cycle(1);
    cpu.registers.setHL(cpu.registers.getHL() -% 1);
    cpu.pc +%= 1;
}

fn opcode2C(cpu: *Cpu) void {
    instructions.inc(cpu, &cpu.registers.l);
    cpu.pc +%= 1;
}

fn opcode2D(cpu: *Cpu) void {
    instructions.dec(cpu, &cpu.registers.l);
    cpu.pc +%= 1;
}

fn opcode2E(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.l, cpu.d8());
    cpu.pc +%= 2;
}

fn opcode2F(cpu: *Cpu) void {
    instructions.cpl(cpu, &cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcode30(cpu: *Cpu) void {
    const jmp = cpu.s8();
    cpu.pc +%= 2;
    instructions.jr(cpu, jmp, !cpu.registers.getCarryFlag());
}

fn opcode31(cpu: *Cpu) void {
    cpu.sp = cpu.d16();
    cpu.pc +%= 3;
}

fn opcode32(cpu: *Cpu) void {
    cpu.writeByte(cpu.registers.getHL(), cpu.registers.a);
    cpu.registers.setHL(cpu.registers.getHL() -% 1);
    cpu.pc +%= 1;
}

fn opcode33(cpu: *Cpu) void {
    cpu.cycle_manager.cycle(1);
    cpu.sp +%= 1;
    cpu.pc +%= 1;
}

fn opcode34(cpu: *Cpu) void {
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.inc(cpu, &target);
    cpu.writeByte(cpu.registers.getHL(), target);
    cpu.pc +%= 1;
}

fn opcode35(cpu: *Cpu) void {
    var target = cpu.readByte(cpu.registers.getHL());
    instructions.dec(cpu, &target);
    cpu.writeByte(cpu.registers.getHL(), target);
    cpu.pc +%= 1;
}

fn opcode36(cpu: *Cpu) void {
    cpu.writeByte(cpu.registers.getHL(), cpu.d8());
    cpu.pc +%= 2;
}

fn opcode37(cpu: *Cpu) void {
    instructions.scf(cpu);
    cpu.pc +%= 1;
}

fn opcode38(cpu: *Cpu) void {
    const jmp = cpu.s8();
    cpu.pc +%= 2;
    instructions.jr(cpu, jmp, cpu.registers.getCarryFlag());
}

fn opcode39(cpu: *Cpu) void {
    var target = cpu.registers.getHL();
    instructions.addWords(cpu, &target, cpu.sp);
    cpu.registers.setHL(target);
    cpu.pc +%= 1;
}

fn opcode3A(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.a, cpu.readByte(cpu.registers.getHL()));
    cpu.registers.setHL(cpu.registers.getHL() -% 1);
    cpu.pc +%= 1;
}

fn opcode3B(cpu: *Cpu) void {
    cpu.cycle_manager.cycle(1);
    cpu.sp -%= 1;
    cpu.pc +%= 1;
}

fn opcode3C(cpu: *Cpu) void {
    instructions.inc(cpu, &cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcode3D(cpu: *Cpu) void {
    instructions.dec(cpu, &cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcode3E(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.a, cpu.d8());
    cpu.pc +%= 2;
}

fn opcode3F(cpu: *Cpu) void {
    instructions.ccf(cpu);
    cpu.pc +%= 1;
}

fn opcode40(cpu: *Cpu) void {
    // LD B, B (no-op)
    cpu.pc +%= 1;
}

fn opcode41(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.b, cpu.registers.c);
    cpu.pc +%= 1;
}

fn opcode42(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.b, cpu.registers.d);
    cpu.pc +%= 1;
}

fn opcode43(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.b, cpu.registers.e);
    cpu.pc +%= 1;
}

fn opcode44(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.b, cpu.registers.h);
    cpu.pc +%= 1;
}

fn opcode45(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.b, cpu.registers.l);
    cpu.pc +%= 1;
}

fn opcode46(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.b, cpu.readByte(cpu.registers.getHL()));
    cpu.pc +%= 1;
}

fn opcode47(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.b, cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcode48(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.c, cpu.registers.b);
    cpu.pc +%= 1;
}

fn opcode49(cpu: *Cpu) void {
    // LD C, C (no-op)
    cpu.pc +%= 1;
}

fn opcode4A(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.c, cpu.registers.d);
    cpu.pc +%= 1;
}

fn opcode4B(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.c, cpu.registers.e);
    cpu.pc +%= 1;
}

fn opcode4C(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.c, cpu.registers.h);
    cpu.pc +%= 1;
}

fn opcode4D(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.c, cpu.registers.l);
    cpu.pc +%= 1;
}

fn opcode4E(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.c, cpu.readByte(cpu.registers.getHL()));
    cpu.pc +%= 1;
}

fn opcode4F(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.c, cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcode50(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.d, cpu.registers.b);
    cpu.pc +%= 1;
}

fn opcode51(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.d, cpu.registers.c);
    cpu.pc +%= 1;
}

fn opcode52(cpu: *Cpu) void {
    // LD D, D (no-op)
    cpu.pc +%= 1;
}

fn opcode53(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.d, cpu.registers.e);
    cpu.pc +%= 1;
}

fn opcode54(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.d, cpu.registers.h);
    cpu.pc +%= 1;
}

fn opcode55(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.d, cpu.registers.l);
    cpu.pc +%= 1;
}

fn opcode56(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.d, cpu.readByte(cpu.registers.getHL()));
    cpu.pc +%= 1;
}

fn opcode57(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.d, cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcode58(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.e, cpu.registers.b);
    cpu.pc +%= 1;
}

fn opcode59(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.e, cpu.registers.c);
    cpu.pc +%= 1;
}

fn opcode5A(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.e, cpu.registers.d);
    cpu.pc +%= 1;
}

fn opcode5B(cpu: *Cpu) void {
    // LD E, E (no-op)
    cpu.pc +%= 1;
}

fn opcode5C(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.e, cpu.registers.h);
    cpu.pc +%= 1;
}

fn opcode5D(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.e, cpu.registers.l);
    cpu.pc +%= 1;
}

fn opcode5E(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.e, cpu.readByte(cpu.registers.getHL()));
    cpu.pc +%= 1;
}

fn opcode5F(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.e, cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcode60(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.h, cpu.registers.b);
    cpu.pc +%= 1;
}

fn opcode61(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.h, cpu.registers.c);
    cpu.pc +%= 1;
}

fn opcode62(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.h, cpu.registers.d);
    cpu.pc +%= 1;
}

fn opcode63(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.h, cpu.registers.e);
    cpu.pc +%= 1;
}

fn opcode64(cpu: *Cpu) void {
    // LD H, H (no-op)
    cpu.pc +%= 1;
}

fn opcode65(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.h, cpu.registers.l);
    cpu.pc +%= 1;
}

fn opcode66(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.h, cpu.readByte(cpu.registers.getHL()));
    cpu.pc +%= 1;
}

fn opcode67(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.h, cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcode68(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.l, cpu.registers.b);
    cpu.pc +%= 1;
}

fn opcode69(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.l, cpu.registers.c);
    cpu.pc +%= 1;
}

fn opcode6A(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.l, cpu.registers.d);
    cpu.pc +%= 1;
}

fn opcode6B(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.l, cpu.registers.e);
    cpu.pc +%= 1;
}

fn opcode6C(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.l, cpu.registers.h);
    cpu.pc +%= 1;
}

fn opcode6D(cpu: *Cpu) void {
    // LD L, L (no-op)
    cpu.pc +%= 1;
}

fn opcode6E(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.l, cpu.readByte(cpu.registers.getHL()));
    cpu.pc +%= 1;
}

fn opcode6F(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.l, cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcode70(cpu: *Cpu) void {
    cpu.writeByte(cpu.registers.getHL(), cpu.registers.b);
    cpu.pc +%= 1;
}

fn opcode71(cpu: *Cpu) void {
    cpu.writeByte(cpu.registers.getHL(), cpu.registers.c);
    cpu.pc +%= 1;
}

fn opcode72(cpu: *Cpu) void {
    cpu.writeByte(cpu.registers.getHL(), cpu.registers.d);
    cpu.pc +%= 1;
}

fn opcode73(cpu: *Cpu) void {
    cpu.writeByte(cpu.registers.getHL(), cpu.registers.e);
    cpu.pc +%= 1;
}

fn opcode74(cpu: *Cpu) void {
    cpu.writeByte(cpu.registers.getHL(), cpu.registers.h);
    cpu.pc +%= 1;
}

fn opcode75(cpu: *Cpu) void {
    cpu.writeByte(cpu.registers.getHL(), cpu.registers.l);
    cpu.pc +%= 1;
}

fn opcode76(cpu: *Cpu) void {
    instructions.halt(cpu);
    cpu.pc +%= 1;
}

fn opcode77(cpu: *Cpu) void {
    cpu.writeByte(cpu.registers.getHL(), cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcode78(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.a, cpu.registers.b);
    cpu.pc +%= 1;
}

fn opcode79(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.a, cpu.registers.c);
    cpu.pc +%= 1;
}

fn opcode7A(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.a, cpu.registers.d);
    cpu.pc +%= 1;
}

fn opcode7B(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.a, cpu.registers.e);
    cpu.pc +%= 1;
}

fn opcode7C(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.a, cpu.registers.h);
    cpu.pc +%= 1;
}

fn opcode7D(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.a, cpu.registers.l);
    cpu.pc +%= 1;
}

fn opcode7E(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.a, cpu.readByte(cpu.registers.getHL()));
    cpu.pc +%= 1;
}

fn opcode7F(cpu: *Cpu) void {
    // LD A, A (no-op)
    cpu.pc +%= 1;
}

fn opcode80(cpu: *Cpu) void {
    instructions.add(cpu, &cpu.registers.a, cpu.registers.b);
    cpu.pc +%= 1;
}

fn opcode81(cpu: *Cpu) void {
    instructions.add(cpu, &cpu.registers.a, cpu.registers.c);
    cpu.pc +%= 1;
}

fn opcode82(cpu: *Cpu) void {
    instructions.add(cpu, &cpu.registers.a, cpu.registers.d);
    cpu.pc +%= 1;
}

fn opcode83(cpu: *Cpu) void {
    instructions.add(cpu, &cpu.registers.a, cpu.registers.e);
    cpu.pc +%= 1;
}

fn opcode84(cpu: *Cpu) void {
    instructions.add(cpu, &cpu.registers.a, cpu.registers.h);
    cpu.pc +%= 1;
}

fn opcode85(cpu: *Cpu) void {
    instructions.add(cpu, &cpu.registers.a, cpu.registers.l);
    cpu.pc +%= 1;
}

fn opcode86(cpu: *Cpu) void {
    instructions.add(cpu, &cpu.registers.a, cpu.readByte(cpu.registers.getHL()));
    cpu.pc +%= 1;
}

fn opcode87(cpu: *Cpu) void {
    instructions.add(cpu, &cpu.registers.a, cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcode88(cpu: *Cpu) void {
    instructions.adc(cpu, &cpu.registers.a, cpu.registers.b);
    cpu.pc +%= 1;
}

fn opcode89(cpu: *Cpu) void {
    instructions.adc(cpu, &cpu.registers.a, cpu.registers.c);
    cpu.pc +%= 1;
}

fn opcode8A(cpu: *Cpu) void {
    instructions.adc(cpu, &cpu.registers.a, cpu.registers.d);
    cpu.pc +%= 1;
}

fn opcode8B(cpu: *Cpu) void {
    instructions.adc(cpu, &cpu.registers.a, cpu.registers.e);
    cpu.pc +%= 1;
}

fn opcode8C(cpu: *Cpu) void {
    instructions.adc(cpu, &cpu.registers.a, cpu.registers.h);
    cpu.pc +%= 1;
}

fn opcode8D(cpu: *Cpu) void {
    instructions.adc(cpu, &cpu.registers.a, cpu.registers.l);
    cpu.pc +%= 1;
}

fn opcode8E(cpu: *Cpu) void {
    instructions.adc(cpu, &cpu.registers.a, cpu.readByte(cpu.registers.getHL()));
    cpu.pc +%= 1;
}

fn opcode8F(cpu: *Cpu) void {
    instructions.adc(cpu, &cpu.registers.a, cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcode90(cpu: *Cpu) void {
    instructions.sub(cpu, &cpu.registers.a, cpu.registers.b);
    cpu.pc +%= 1;
}

fn opcode91(cpu: *Cpu) void {
    instructions.sub(cpu, &cpu.registers.a, cpu.registers.c);
    cpu.pc +%= 1;
}

fn opcode92(cpu: *Cpu) void {
    instructions.sub(cpu, &cpu.registers.a, cpu.registers.d);
    cpu.pc +%= 1;
}

fn opcode93(cpu: *Cpu) void {
    instructions.sub(cpu, &cpu.registers.a, cpu.registers.e);
    cpu.pc +%= 1;
}

fn opcode94(cpu: *Cpu) void {
    instructions.sub(cpu, &cpu.registers.a, cpu.registers.h);
    cpu.pc +%= 1;
}

fn opcode95(cpu: *Cpu) void {
    instructions.sub(cpu, &cpu.registers.a, cpu.registers.l);
    cpu.pc +%= 1;
}

fn opcode96(cpu: *Cpu) void {
    instructions.sub(cpu, &cpu.registers.a, cpu.readByte(cpu.registers.getHL()));
    cpu.pc +%= 1;
}

fn opcode97(cpu: *Cpu) void {
    instructions.sub(cpu, &cpu.registers.a, cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcode98(cpu: *Cpu) void {
    instructions.sbc(cpu, &cpu.registers.a, cpu.registers.b);
    cpu.pc +%= 1;
}

fn opcode99(cpu: *Cpu) void {
    instructions.sbc(cpu, &cpu.registers.a, cpu.registers.c);
    cpu.pc +%= 1;
}

fn opcode9A(cpu: *Cpu) void {
    instructions.sbc(cpu, &cpu.registers.a, cpu.registers.d);
    cpu.pc +%= 1;
}

fn opcode9B(cpu: *Cpu) void {
    instructions.sbc(cpu, &cpu.registers.a, cpu.registers.e);
    cpu.pc +%= 1;
}

fn opcode9C(cpu: *Cpu) void {
    instructions.sbc(cpu, &cpu.registers.a, cpu.registers.h);
    cpu.pc +%= 1;
}

fn opcode9D(cpu: *Cpu) void {
    instructions.sbc(cpu, &cpu.registers.a, cpu.registers.l);
    cpu.pc +%= 1;
}

fn opcode9E(cpu: *Cpu) void {
    instructions.sbc(cpu, &cpu.registers.a, cpu.readByte(cpu.registers.getHL()));
    cpu.pc +%= 1;
}

fn opcode9F(cpu: *Cpu) void {
    instructions.sbc(cpu, &cpu.registers.a, cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcodeA0(cpu: *Cpu) void {
    instructions.andFn(cpu, &cpu.registers.a, cpu.registers.b);
    cpu.pc +%= 1;
}

fn opcodeA1(cpu: *Cpu) void {
    instructions.andFn(cpu, &cpu.registers.a, cpu.registers.c);
    cpu.pc +%= 1;
}

fn opcodeA2(cpu: *Cpu) void {
    instructions.andFn(cpu, &cpu.registers.a, cpu.registers.d);
    cpu.pc +%= 1;
}

fn opcodeA3(cpu: *Cpu) void {
    instructions.andFn(cpu, &cpu.registers.a, cpu.registers.e);
    cpu.pc +%= 1;
}

fn opcodeA4(cpu: *Cpu) void {
    instructions.andFn(cpu, &cpu.registers.a, cpu.registers.h);
    cpu.pc +%= 1;
}

fn opcodeA5(cpu: *Cpu) void {
    instructions.andFn(cpu, &cpu.registers.a, cpu.registers.l);
    cpu.pc +%= 1;
}

fn opcodeA6(cpu: *Cpu) void {
    instructions.andFn(cpu, &cpu.registers.a, cpu.readByte(cpu.registers.getHL()));
    cpu.pc +%= 1;
}

fn opcodeA7(cpu: *Cpu) void {
    instructions.andFn(cpu, &cpu.registers.a, cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcodeA8(cpu: *Cpu) void {
    instructions.xor(cpu, &cpu.registers.a, cpu.registers.b);
    cpu.pc +%= 1;
}

fn opcodeA9(cpu: *Cpu) void {
    instructions.xor(cpu, &cpu.registers.a, cpu.registers.c);
    cpu.pc +%= 1;
}

fn opcodeAA(cpu: *Cpu) void {
    instructions.xor(cpu, &cpu.registers.a, cpu.registers.d);
    cpu.pc +%= 1;
}

fn opcodeAB(cpu: *Cpu) void {
    instructions.xor(cpu, &cpu.registers.a, cpu.registers.e);
    cpu.pc +%= 1;
}

fn opcodeAC(cpu: *Cpu) void {
    instructions.xor(cpu, &cpu.registers.a, cpu.registers.h);
    cpu.pc +%= 1;
}

fn opcodeAD(cpu: *Cpu) void {
    instructions.xor(cpu, &cpu.registers.a, cpu.registers.l);
    cpu.pc +%= 1;
}

fn opcodeAE(cpu: *Cpu) void {
    instructions.xor(cpu, &cpu.registers.a, cpu.readByte(cpu.registers.getHL()));
    cpu.pc +%= 1;
}

fn opcodeAF(cpu: *Cpu) void {
    instructions.xor(cpu, &cpu.registers.a, cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcodeB0(cpu: *Cpu) void {
    instructions.orFn(cpu, &cpu.registers.a, cpu.registers.b);
    cpu.pc +%= 1;
}

fn opcodeB1(cpu: *Cpu) void {
    instructions.orFn(cpu, &cpu.registers.a, cpu.registers.c);
    cpu.pc +%= 1;
}

fn opcodeB2(cpu: *Cpu) void {
    instructions.orFn(cpu, &cpu.registers.a, cpu.registers.d);
    cpu.pc +%= 1;
}

fn opcodeB3(cpu: *Cpu) void {
    instructions.orFn(cpu, &cpu.registers.a, cpu.registers.e);
    cpu.pc +%= 1;
}

fn opcodeB4(cpu: *Cpu) void {
    instructions.orFn(cpu, &cpu.registers.a, cpu.registers.h);
    cpu.pc +%= 1;
}

fn opcodeB5(cpu: *Cpu) void {
    instructions.orFn(cpu, &cpu.registers.a, cpu.registers.l);
    cpu.pc +%= 1;
}

fn opcodeB6(cpu: *Cpu) void {
    instructions.orFn(cpu, &cpu.registers.a, cpu.readByte(cpu.registers.getHL()));
    cpu.pc +%= 1;
}

fn opcodeB7(cpu: *Cpu) void {
    instructions.orFn(cpu, &cpu.registers.a, cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcodeB8(cpu: *Cpu) void {
    instructions.cp(cpu, &cpu.registers.a, cpu.registers.b);
    cpu.pc +%= 1;
}

fn opcodeB9(cpu: *Cpu) void {
    instructions.cp(cpu, &cpu.registers.a, cpu.registers.c);
    cpu.pc +%= 1;
}

fn opcodeBA(cpu: *Cpu) void {
    instructions.cp(cpu, &cpu.registers.a, cpu.registers.d);
    cpu.pc +%= 1;
}

fn opcodeBB(cpu: *Cpu) void {
    instructions.cp(cpu, &cpu.registers.a, cpu.registers.e);
    cpu.pc +%= 1;
}

fn opcodeBC(cpu: *Cpu) void {
    instructions.cp(cpu, &cpu.registers.a, cpu.registers.h);
    cpu.pc +%= 1;
}

fn opcodeBD(cpu: *Cpu) void {
    instructions.cp(cpu, &cpu.registers.a, cpu.registers.l);
    cpu.pc +%= 1;
}

fn opcodeBE(cpu: *Cpu) void {
    instructions.cp(cpu, &cpu.registers.a, cpu.readByte(cpu.registers.getHL()));
    cpu.pc +%= 1;
}

fn opcodeBF(cpu: *Cpu) void {
    instructions.cp(cpu, &cpu.registers.a, cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcodeC0(cpu: *Cpu) void {
    cpu.pc +%= 1;
    cpu.cycle_manager.cycle(1);
    instructions.ret(cpu, !cpu.registers.getZeroFlag());
}

fn opcodeC1(cpu: *Cpu) void {
    cpu.registers.setBC(instructions.pop(cpu));
    cpu.pc +%= 1;
}

fn opcodeC2(cpu: *Cpu) void {
    const address = cpu.d16();
    cpu.pc +%= 3;
    instructions.jp(cpu, address, !cpu.registers.getZeroFlag());
}

fn opcodeC3(cpu: *Cpu) void {
    const address = cpu.d16();
    cpu.pc +%= 3;
    instructions.jp(cpu, address, true);
}

fn opcodeC4(cpu: *Cpu) void {
    const address = cpu.d16();
    cpu.pc +%= 3;
    instructions.call(cpu, address, !cpu.registers.getZeroFlag());
}

fn opcodeC5(cpu: *Cpu) void {
    instructions.push(cpu, cpu.registers.getBC());
    cpu.pc +%= 1;
}

fn opcodeC6(cpu: *Cpu) void {
    instructions.add(cpu, &cpu.registers.a, cpu.d8());
    cpu.pc +%= 2;
}

fn opcodeC7(cpu: *Cpu) void {
    cpu.pc +%= 1;
    instructions.call(cpu, 0x0000, true);
}

fn opcodeC8(cpu: *Cpu) void {
    cpu.pc +%= 1;
    cpu.cycle_manager.cycle(1);
    instructions.ret(cpu, cpu.registers.getZeroFlag());
}

fn opcodeC9(cpu: *Cpu) void {
    cpu.pc +%= 1;
    instructions.ret(cpu, true);
}

fn opcodeCA(cpu: *Cpu) void {
    const address = cpu.d16();
    cpu.pc +%= 3;
    instructions.jp(cpu, address, cpu.registers.getZeroFlag());
}

fn opcodeCB(cpu: *Cpu) void {
    opcodes_cb_table[cpu.d8()](cpu);
}

fn opcodeCC(cpu: *Cpu) void {
    const address = cpu.d16();
    cpu.pc +%= 3;
    instructions.call(cpu, address, cpu.registers.getZeroFlag());
}

fn opcodeCD(cpu: *Cpu) void {
    const address = cpu.d16();
    cpu.pc +%= 3;
    instructions.call(cpu, address, true);
}

fn opcodeCE(cpu: *Cpu) void {
    instructions.adc(cpu, &cpu.registers.a, cpu.d8());
    cpu.pc +%= 2;
}

fn opcodeCF(cpu: *Cpu) void {
    cpu.pc +%= 1;
    instructions.call(cpu, 0x0008, true);
}

fn opcodeD0(cpu: *Cpu) void {
    cpu.pc +%= 1;
    cpu.cycle_manager.cycle(1);
    instructions.ret(cpu, !cpu.registers.getCarryFlag());
}

fn opcodeD1(cpu: *Cpu) void {
    cpu.registers.setDE(instructions.pop(cpu));
    cpu.pc +%= 1;
}

fn opcodeD2(cpu: *Cpu) void {
    const address = cpu.d16();
    cpu.pc +%= 3;
    instructions.jp(cpu, address, !cpu.registers.getCarryFlag());
}

fn opcodeD4(cpu: *Cpu) void {
    const address = cpu.d16();
    cpu.pc +%= 3;
    instructions.call(cpu, address, !cpu.registers.getCarryFlag());
}

fn opcodeD5(cpu: *Cpu) void {
    instructions.push(cpu, cpu.registers.getDE());
    cpu.pc +%= 1;
}

fn opcodeD6(cpu: *Cpu) void {
    instructions.sub(cpu, &cpu.registers.a, cpu.d8());
    cpu.pc +%= 2;
}

fn opcodeD7(cpu: *Cpu) void {
    cpu.pc +%= 1;
    instructions.call(cpu, 0x0010, true);
}

fn opcodeD8(cpu: *Cpu) void {
    cpu.pc +%= 1;
    cpu.cycle_manager.cycle(1);
    instructions.ret(cpu, cpu.registers.getCarryFlag());
}

fn opcodeD9(cpu: *Cpu) void {
    instructions.reti(cpu);
    cpu.pc +%= 1;
}

fn opcodeDA(cpu: *Cpu) void {
    const address = cpu.d16();
    cpu.pc +%= 3;
    instructions.jp(cpu, address, cpu.registers.getCarryFlag());
}

fn opcodeDC(cpu: *Cpu) void {
    const address = cpu.d16();
    cpu.pc +%= 3;
    instructions.call(cpu, address, cpu.registers.getCarryFlag());
}

fn opcodeDE(cpu: *Cpu) void {
    instructions.sbc(cpu, &cpu.registers.a, cpu.d8());
    cpu.pc +%= 2;
}

fn opcodeDF(cpu: *Cpu) void {
    cpu.pc +%= 1;
    instructions.call(cpu, 0x0018, true);
}

fn opcodeE0(cpu: *Cpu) void {
    instructions.ldIntoRam(cpu, cpu.d8(), cpu.registers.a);
    cpu.pc +%= 2;
}

fn opcodeE1(cpu: *Cpu) void {
    cpu.registers.setHL(instructions.pop(cpu));
    cpu.pc +%= 1;
}

fn opcodeE2(cpu: *Cpu) void {
    instructions.ldIntoRam(cpu, cpu.registers.c, cpu.registers.a);
    cpu.pc +%= 1;
}

fn opcodeE5(cpu: *Cpu) void {
    instructions.push(cpu, cpu.registers.getHL());
    cpu.pc +%= 1;
}

fn opcodeE6(cpu: *Cpu) void {
    instructions.andFn(cpu, &cpu.registers.a, cpu.d8());
    cpu.pc +%= 2;
}

fn opcodeE7(cpu: *Cpu) void {
    cpu.pc +%= 1;
    instructions.call(cpu, 0x0020, true);
}

fn opcodeE8(cpu: *Cpu) void {
    cpu.cycle_manager.cycle(1); //this opcode takes an extra cycle
    instructions.addSigned(cpu, &cpu.sp, cpu.s8());
    cpu.pc +%= 2;
}

fn opcodeE9(cpu: *Cpu) void {
    cpu.pc = cpu.registers.getHL(); // we do this because this opcode always takes 1 cycle
}

fn opcodeEA(cpu: *Cpu) void {
    const address = cpu.d16();
    cpu.writeByte(address, cpu.registers.a);
    cpu.pc +%= 3;
}

fn opcodeEE(cpu: *Cpu) void {
    instructions.xor(cpu, &cpu.registers.a, cpu.d8());
    cpu.pc +%= 2;
}

fn opcodeEF(cpu: *Cpu) void {
    cpu.pc +%= 1;
    instructions.call(cpu, 0x0028, true);
}

fn opcodeF0(cpu: *Cpu) void {
    instructions.ldRamInto(cpu, &cpu.registers.a, cpu.d8());
    cpu.pc +%= 2;
}

fn opcodeF1(cpu: *Cpu) void {
    cpu.registers.setAF(instructions.pop(cpu));
    cpu.pc +%= 1;
}

fn opcodeF2(cpu: *Cpu) void {
    instructions.ldRamInto(cpu, &cpu.registers.a, cpu.registers.c);
    cpu.pc +%= 1;
}

fn opcodeF3(cpu: *Cpu) void {
    instructions.di(cpu);
    cpu.pc +%= 1;
}

fn opcodeF5(cpu: *Cpu) void {
    instructions.push(cpu, cpu.registers.getAF());
    cpu.pc +%= 1;
}

fn opcodeF6(cpu: *Cpu) void {
    instructions.orFn(cpu, &cpu.registers.a, cpu.d8());
    cpu.pc +%= 2;
}

fn opcodeF7(cpu: *Cpu) void {
    cpu.pc +%= 1;
    instructions.call(cpu, 0x0030, true);
}

fn opcodeF8(cpu: *Cpu) void {
    var target = cpu.sp;
    instructions.addSigned(cpu, &target, cpu.s8());
    cpu.registers.setHL(target);
    cpu.pc +%= 2;
}

fn opcodeF9(cpu: *Cpu) void {
    cpu.sp = cpu.registers.getHL();
    cpu.pc +%= 1;
}

fn opcodeFA(cpu: *Cpu) void {
    instructions.ld(cpu, &cpu.registers.a, cpu.readByte(cpu.d16()));
    cpu.pc +%= 3;
}

fn opcodeFB(cpu: *Cpu) void {
    instructions.ei(cpu);
    cpu.pc +%= 1;
}

fn opcodeFE(cpu: *Cpu) void {
    instructions.cp(cpu, &cpu.registers.a, cpu.d8());
    cpu.pc +%= 2;
}

fn opcodeFF(cpu: *Cpu) void {
    cpu.pc +%= 1;
    instructions.call(cpu, 0x0038, true);
}
