const Cpu = @import("cpu.zig").Cpu;
const Instructions = @import("instructions.zig");

pub fn opcode00(cpu: *Cpu) void {
    cpu.pc += 1;
}

pub fn opcode01(cpu: *Cpu) void {
    cpu.registers.setBC(cpu.memory.readWord(cpu.pc + 1));
    cpu.pc += 3;
}

pub fn opcode02(cpu: *Cpu) void {
    cpu.memory.writeByte(cpu.registers.getBC(), cpu.registers.a);
    cpu.pc += 1;
}

pub fn opcode03(cpu: *Cpu) void {
    cpu.registers.setBC(@addWithOverflow(cpu.registers.getBC(), 1)[0]);
    cpu.pc += 1;
}

pub fn opcode04(cpu: *Cpu) void {
    Instructions.inc(cpu, &cpu.registers.b);
    cpu.pc += 1;
}

pub fn opcode05(cpu: *Cpu) void {
    Instructions.dec(cpu, &cpu.registers.b);
    cpu.pc += 1;
}

pub fn opcode06(cpu: *Cpu) void {
    cpu.registers.b = cpu.memory.readByte(cpu.pc + 1);
    cpu.pc += 2;
}

pub fn opcode07(cpu: *Cpu) void {
    cpu.registers.b = cpu.memory.readByte(cpu.pc + 1);
    cpu.pc += 2;
}

pub fn opcode08(cpu: *Cpu) void {
    Instructions.rlc(cpu, &cpu.registers.a);
    cpu.registers.setZeroFlag(false); // RLCA always clears zero flag
    cpu.pc += 1;
}

pub fn opcode40(cpu: *Cpu) void {
    // LD B, B (no-op)
    cpu.pc += 1;
}

pub fn opcode41(cpu: *Cpu) void {
    cpu.registers.b = cpu.registers.c;
    cpu.pc += 1;
}

pub fn opcode42(cpu: *Cpu) void {
    cpu.registers.b = cpu.registers.d;
    cpu.pc += 1;
}

pub fn opcode43(cpu: *Cpu) void {
    cpu.registers.b = cpu.registers.e;
    cpu.pc += 1;
}

pub fn opcode44(cpu: *Cpu) void {
    cpu.registers.b = cpu.registers.h;
    cpu.pc += 1;
}

pub fn opcode45(cpu: *Cpu) void {
    cpu.registers.b = cpu.registers.l;
    cpu.pc += 1;
}

pub fn opcode46(cpu: *Cpu) void {
    cpu.registers.b = cpu.memory.readByte(cpu.registers.getHL());
    cpu.pc += 1;
}

pub fn opcode47(cpu: *Cpu) void {
    cpu.registers.b = cpu.registers.a;
    cpu.pc += 1;
}

pub fn opcode48(cpu: *Cpu) void {
    cpu.registers.c = cpu.registers.b;
    cpu.pc += 1;
}

pub fn opcode49(cpu: *Cpu) void {
    // LD C, C (no-op)
    cpu.pc += 1;
}

pub fn opcode4A(cpu: *Cpu) void {
    cpu.registers.c = cpu.registers.d;
    cpu.pc += 1;
}

pub fn opcode4B(cpu: *Cpu) void {
    cpu.registers.c = cpu.registers.e;
    cpu.pc += 1;
}

pub fn opcode4C(cpu: *Cpu) void {
    cpu.registers.c = cpu.registers.h;
    cpu.pc += 1;
}

pub fn opcode4D(cpu: *Cpu) void {
    cpu.registers.c = cpu.registers.l;
    cpu.pc += 1;
}

pub fn opcode4E(cpu: *Cpu) void {
    cpu.registers.c = cpu.memory.readByte(cpu.registers.getHL());
    cpu.pc += 1;
}

pub fn opcode4F(cpu: *Cpu) void {
    cpu.registers.c = cpu.registers.a;
    cpu.pc += 1;
}

pub fn opcode50(cpu: *Cpu) void {
    cpu.registers.d = cpu.registers.b;
    cpu.pc += 1;
}

pub fn opcode51(cpu: *Cpu) void {
    cpu.registers.d = cpu.registers.c;
    cpu.pc += 1;
}

pub fn opcode52(cpu: *Cpu) void {
    // LD D, D (no-op)
    cpu.pc += 1;
}

pub fn opcode53(cpu: *Cpu) void {
    cpu.registers.d = cpu.registers.e;
    cpu.pc += 1;
}

pub fn opcode54(cpu: *Cpu) void {
    cpu.registers.d = cpu.registers.h;
    cpu.pc += 1;
}

pub fn opcode55(cpu: *Cpu) void {
    cpu.registers.d = cpu.registers.l;
    cpu.pc += 1;
}

pub fn opcode56(cpu: *Cpu) void {
    cpu.registers.d = cpu.memory.readByte(cpu.registers.getHL());
    cpu.pc += 1;
}

pub fn opcode57(cpu: *Cpu) void {
    cpu.registers.d = cpu.registers.a;
    cpu.pc += 1;
}

pub fn opcode58(cpu: *Cpu) void {
    cpu.registers.e = cpu.registers.b;
    cpu.pc += 1;
}

pub fn opcode59(cpu: *Cpu) void {
    cpu.registers.e = cpu.registers.c;
    cpu.pc += 1;
}

pub fn opcode5A(cpu: *Cpu) void {
    cpu.registers.e = cpu.registers.d;
    cpu.pc += 1;
}

pub fn opcode5B(cpu: *Cpu) void {
    // LD E, E (no-op)
    cpu.pc += 1;
}

pub fn opcode5C(cpu: *Cpu) void {
    cpu.registers.e = cpu.registers.h;
    cpu.pc += 1;
}

pub fn opcode5D(cpu: *Cpu) void {
    cpu.registers.e = cpu.registers.l;
    cpu.pc += 1;
}

pub fn opcode5E(cpu: *Cpu) void {
    cpu.registers.e = cpu.memory.readByte(cpu.registers.getHL());
    cpu.pc += 1;
}

pub fn opcode5F(cpu: *Cpu) void {
    cpu.registers.e = cpu.registers.a;
    cpu.pc += 1;
}

pub fn opcode60(cpu: *Cpu) void {
    cpu.registers.h = cpu.registers.b;
    cpu.pc += 1;
}

pub fn opcode61(cpu: *Cpu) void {
    cpu.registers.h = cpu.registers.c;
    cpu.pc += 1;
}

pub fn opcode62(cpu: *Cpu) void {
    cpu.registers.h = cpu.registers.d;
    cpu.pc += 1;
}

pub fn opcode63(cpu: *Cpu) void {
    cpu.registers.h = cpu.registers.e;
    cpu.pc += 1;
}

pub fn opcode64(cpu: *Cpu) void {
    // LD H, H (no-op)
    cpu.pc += 1;
}

pub fn opcode65(cpu: *Cpu) void {
    cpu.registers.h = cpu.registers.l;
    cpu.pc += 1;
}

pub fn opcode66(cpu: *Cpu) void {
    cpu.registers.h = cpu.memory.readByte(cpu.registers.getHL());
    cpu.pc += 1;
}

pub fn opcode67(cpu: *Cpu) void {
    cpu.registers.h = cpu.registers.a;
    cpu.pc += 1;
}

pub fn opcode68(cpu: *Cpu) void {
    cpu.registers.l = cpu.registers.b;
    cpu.pc += 1;
}

pub fn opcode69(cpu: *Cpu) void {
    cpu.registers.l = cpu.registers.c;
    cpu.pc += 1;
}

pub fn opcode6A(cpu: *Cpu) void {
    cpu.registers.l = cpu.registers.d;
    cpu.pc += 1;
}

pub fn opcode6B(cpu: *Cpu) void {
    cpu.registers.l = cpu.registers.e;
    cpu.pc += 1;
}

pub fn opcode6C(cpu: *Cpu) void {
    cpu.registers.l = cpu.registers.h;
    cpu.pc += 1;
}

pub fn opcode6D(cpu: *Cpu) void {
    // LD L, L (no-op)
    cpu.pc += 1;
}

pub fn opcode6E(cpu: *Cpu) void {
    cpu.registers.l = cpu.memory.readByte(cpu.registers.getHL());
    cpu.pc += 1;
}

pub fn opcode6F(cpu: *Cpu) void {
    cpu.registers.l = cpu.registers.a;
    cpu.pc += 1;
}

pub fn opcode70(cpu: *Cpu) void {
    cpu.memory.writeByte(cpu.registers.getHL(), cpu.registers.b);
    cpu.pc += 1;
}

pub fn opcode71(cpu: *Cpu) void {
    cpu.memory.writeByte(cpu.registers.getHL(), cpu.registers.c);
    cpu.pc += 1;
}

pub fn opcode72(cpu: *Cpu) void {
    cpu.memory.writeByte(cpu.registers.getHL(), cpu.registers.d);
    cpu.pc += 1;
}

pub fn opcode73(cpu: *Cpu) void {
    cpu.memory.writeByte(cpu.registers.getHL(), cpu.registers.e);
    cpu.pc += 1;
}

pub fn opcode74(cpu: *Cpu) void {
    cpu.memory.writeByte(cpu.registers.getHL(), cpu.registers.h);
    cpu.pc += 1;
}

pub fn opcode75(cpu: *Cpu) void {
    cpu.memory.writeByte(cpu.registers.getHL(), cpu.registers.l);
    cpu.pc += 1;
}

pub fn opcode76(cpu: *Cpu) void {
    cpu.halted = true;
    cpu.pc += 1;
}

pub fn opcode77(cpu: *Cpu) void {
    cpu.memory.writeByte(cpu.registers.getHL(), cpu.registers.a);
    cpu.pc += 1;
}

pub fn opcode78(cpu: *Cpu) void {
    cpu.registers.a = cpu.registers.b;
    cpu.pc += 1;
}

pub fn opcode79(cpu: *Cpu) void {
    cpu.registers.a = cpu.registers.c;
    cpu.pc += 1;
}

pub fn opcode7A(cpu: *Cpu) void {
    cpu.registers.a = cpu.registers.d;
    cpu.pc += 1;
}

pub fn opcode7B(cpu: *Cpu) void {
    cpu.registers.a = cpu.registers.e;
    cpu.pc += 1;
}

pub fn opcode7C(cpu: *Cpu) void {
    cpu.registers.a = cpu.registers.h;
    cpu.pc += 1;
}

pub fn opcode7D(cpu: *Cpu) void {
    cpu.registers.a = cpu.registers.l;
    cpu.pc += 1;
}

pub fn opcode7E(cpu: *Cpu) void {
    cpu.registers.a = cpu.memory.readByte(cpu.registers.getHL());
    cpu.pc += 1;
}

pub fn opcode7F(cpu: *Cpu) void {
    // LD A, A (no-op)
    cpu.pc += 1;
}

pub fn opcode80(cpu: *Cpu) void {
    Instructions.add(cpu, cpu.registers.b);
    cpu.pc += 1;
}

pub fn opcode81(cpu: *Cpu) void {
    Instructions.add(cpu, cpu.registers.c);
    cpu.pc += 1;
}

pub fn opcode82(cpu: *Cpu) void {
    Instructions.add(cpu, cpu.registers.d);
    cpu.pc += 1;
}

pub fn opcode83(cpu: *Cpu) void {
    Instructions.add(cpu, cpu.registers.e);
    cpu.pc += 1;
}

pub fn opcode84(cpu: *Cpu) void {
    Instructions.add(cpu, cpu.registers.h);
    cpu.pc += 1;
}

pub fn opcode85(cpu: *Cpu) void {
    Instructions.add(cpu, cpu.registers.l);
    cpu.pc += 1;
}

pub fn opcode86(cpu: *Cpu) void {
    Instructions.add(cpu, cpu.memory.readByte(cpu.registers.getHL()));
    cpu.pc += 1;
}

pub fn opcode87(cpu: *Cpu) void {
    Instructions.add(cpu, cpu.registers.a);
    cpu.pc += 1;
}

pub fn opcode88(cpu: *Cpu) void {
    Instructions.adc(cpu, cpu.registers.b);
    cpu.pc += 1;
}

pub fn opcode89(cpu: *Cpu) void {
    Instructions.adc(cpu, cpu.registers.c);
    cpu.pc += 1;
}

pub fn opcode8A(cpu: *Cpu) void {
    Instructions.adc(cpu, cpu.registers.d);
    cpu.pc += 1;
}

pub fn opcode8B(cpu: *Cpu) void {
    Instructions.adc(cpu, cpu.registers.e);
    cpu.pc += 1;
}

pub fn opcode8C(cpu: *Cpu) void {
    Instructions.adc(cpu, cpu.registers.h);
    cpu.pc += 1;
}

pub fn opcode8D(cpu: *Cpu) void {
    Instructions.adc(cpu, cpu.registers.l);
    cpu.pc += 1;
}

pub fn opcode8E(cpu: *Cpu) void {
    Instructions.adc(cpu, cpu.memory.readByte(cpu.registers.getHL()));
    cpu.pc += 1;
}

pub fn opcode8F(cpu: *Cpu) void {
    Instructions.adc(cpu, cpu.registers.a);
    cpu.pc += 1;
}

pub fn opcode90(cpu: *Cpu) void {
    Instructions.sub(cpu, cpu.registers.b);
    cpu.pc += 1;
}

pub fn opcode91(cpu: *Cpu) void {
    Instructions.sub(cpu, cpu.registers.c);
    cpu.pc += 1;
}

pub fn opcode92(cpu: *Cpu) void {
    Instructions.sub(cpu, cpu.registers.d);
    cpu.pc += 1;
}

pub fn opcode93(cpu: *Cpu) void {
    Instructions.sub(cpu, cpu.registers.e);
    cpu.pc += 1;
}

pub fn opcode94(cpu: *Cpu) void {
    Instructions.sub(cpu, cpu.registers.h);
    cpu.pc += 1;
}

pub fn opcode95(cpu: *Cpu) void {
    Instructions.sub(cpu, cpu.registers.l);
    cpu.pc += 1;
}

pub fn opcode96(cpu: *Cpu) void {
    Instructions.sub(cpu, cpu.memory.readByte(cpu.registers.getHL()));
    cpu.pc += 1;
}

pub fn opcode97(cpu: *Cpu) void {
    Instructions.sub(cpu, cpu.registers.a);
    cpu.pc += 1;
}

pub fn opcode98(cpu: *Cpu) void {
    Instructions.sbc(cpu, cpu.registers.b);
    cpu.pc += 1;
}

pub fn opcode99(cpu: *Cpu) void {
    Instructions.sbc(cpu, cpu.registers.c);
    cpu.pc += 1;
}

pub fn opcode9A(cpu: *Cpu) void {
    Instructions.sbc(cpu, cpu.registers.d);
    cpu.pc += 1;
}

pub fn opcode9B(cpu: *Cpu) void {
    Instructions.sbc(cpu, cpu.registers.e);
    cpu.pc += 1;
}

pub fn opcode9C(cpu: *Cpu) void {
    Instructions.sbc(cpu, cpu.registers.h);
    cpu.pc += 1;
}

pub fn opcode9D(cpu: *Cpu) void {
    Instructions.sbc(cpu, cpu.registers.l);
    cpu.pc += 1;
}

pub fn opcode9E(cpu: *Cpu) void {
    Instructions.sbc(cpu, cpu.memory.readByte(cpu.registers.getHL()));
    cpu.pc += 1;
}

pub fn opcode9F(cpu: *Cpu) void {
    Instructions.sbc(cpu, cpu.registers.a);
    cpu.pc += 1;
}

pub fn opcodeA0(cpu: *Cpu) void {
    Instructions.andFn(cpu, cpu.registers.b);
    cpu.pc += 1;
}

pub fn opcodeA1(cpu: *Cpu) void {
    Instructions.andFn(cpu, cpu.registers.c);
    cpu.pc += 1;
}

pub fn opcodeA2(cpu: *Cpu) void {
    Instructions.andFn(cpu, cpu.registers.d);
    cpu.pc += 1;
}

pub fn opcodeA3(cpu: *Cpu) void {
    Instructions.andFn(cpu, cpu.registers.e);
    cpu.pc += 1;
}

pub fn opcodeA4(cpu: *Cpu) void {
    Instructions.andFn(cpu, cpu.registers.h);
    cpu.pc += 1;
}

pub fn opcodeA5(cpu: *Cpu) void {
    Instructions.andFn(cpu, cpu.registers.l);
    cpu.pc += 1;
}

pub fn opcodeA6(cpu: *Cpu) void {
    Instructions.andFn(cpu, cpu.memory.readByte(cpu.registers.getHL()));
    cpu.pc += 1;
}

pub fn opcodeA7(cpu: *Cpu) void {
    Instructions.andFn(cpu, cpu.registers.a);
    cpu.pc += 1;
}

pub fn opcodeA8(cpu: *Cpu) void {
    Instructions.xor(cpu, cpu.registers.b);
    cpu.pc += 1;
}

pub fn opcodeA9(cpu: *Cpu) void {
    Instructions.xor(cpu, cpu.registers.c);
    cpu.pc += 1;
}

pub fn opcodeAA(cpu: *Cpu) void {
    Instructions.xor(cpu, cpu.registers.d);
    cpu.pc += 1;
}

pub fn opcodeAB(cpu: *Cpu) void {
    Instructions.xor(cpu, cpu.registers.e);
    cpu.pc += 1;
}

pub fn opcodeAC(cpu: *Cpu) void {
    Instructions.xor(cpu, cpu.registers.h);
    cpu.pc += 1;
}

pub fn opcodeAD(cpu: *Cpu) void {
    Instructions.xor(cpu, cpu.registers.l);
    cpu.pc += 1;
}

pub fn opcodeAE(cpu: *Cpu) void {
    Instructions.xor(cpu, cpu.memory.readByte(cpu.registers.getHL()));
    cpu.pc += 1;
}

pub fn opcodeAF(cpu: *Cpu) void {
    Instructions.xor(cpu, cpu.registers.a);
    cpu.pc += 1;
}

pub fn opcodeB0(cpu: *Cpu) void {
    Instructions.orFn(cpu, cpu.registers.b);
    cpu.pc += 1;
}

pub fn opcodeB1(cpu: *Cpu) void {
    Instructions.orFn(cpu, cpu.registers.c);
    cpu.pc += 1;
}

pub fn opcodeB2(cpu: *Cpu) void {
    Instructions.orFn(cpu, cpu.registers.d);
    cpu.pc += 1;
}

pub fn opcodeB3(cpu: *Cpu) void {
    Instructions.orFn(cpu, cpu.registers.e);
    cpu.pc += 1;
}

pub fn opcodeB4(cpu: *Cpu) void {
    Instructions.orFn(cpu, cpu.registers.h);
    cpu.pc += 1;
}

pub fn opcodeB5(cpu: *Cpu) void {
    Instructions.orFn(cpu, cpu.registers.l);
    cpu.pc += 1;
}

pub fn opcodeB6(cpu: *Cpu) void {
    Instructions.orFn(cpu, cpu.memory.readByte(cpu.registers.getHL()));
    cpu.pc += 1;
}

pub fn opcodeB7(cpu: *Cpu) void {
    Instructions.orFn(cpu, cpu.registers.a);
    cpu.pc += 1;
}

pub fn opcodeB8(cpu: *Cpu) void {
    Instructions.cp(cpu, cpu.registers.b);
    cpu.pc += 1;
}

pub fn opcodeB9(cpu: *Cpu) void {
    Instructions.cp(cpu, cpu.registers.c);
    cpu.pc += 1;
}

pub fn opcodeBA(cpu: *Cpu) void {
    Instructions.cp(cpu, cpu.registers.d);
    cpu.pc += 1;
}

pub fn opcodeBB(cpu: *Cpu) void {
    Instructions.cp(cpu, cpu.registers.e);
    cpu.pc += 1;
}

pub fn opcodeBC(cpu: *Cpu) void {
    Instructions.cp(cpu, cpu.registers.h);
    cpu.pc += 1;
}

pub fn opcodeBD(cpu: *Cpu) void {
    Instructions.cp(cpu, cpu.registers.l);
    cpu.pc += 1;
}

pub fn opcodeBE(cpu: *Cpu) void {
    Instructions.cp(cpu, cpu.memory.readByte(cpu.registers.getHL()));
    cpu.pc += 1;
}

pub fn opcodeBF(cpu: *Cpu) void {
    Instructions.cp(cpu, cpu.registers.a);
    cpu.pc += 1;
}
