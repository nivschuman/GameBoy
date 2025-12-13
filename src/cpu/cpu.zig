const Registers = @import("registers/registers.zig").Registers;
const Mmu = @import("../mmu/mmu.zig").Mmu;
const opcodes_table = @import("opcodes.zig").opcodes_table;

pub const Cpu = struct {
    registers: Registers,
    pc: u16,
    sp: u16,
    halted: bool,
    stopped: bool,
    mmu: *Mmu,

    pub fn init(mmu: *Mmu) Cpu {
        return .{
            .registers = Registers.init(),
            .pc = 0,
            .sp = 0,
            .mmu = mmu,
            .halted = false,
            .stopped = false,
        };
    }

    pub fn opcode(self: *const Cpu) u8 {
        return self.mmu.readByte(self.pc);
    }

    pub fn d8(self: *const Cpu) u8 {
        return self.mmu.readByte(self.pc +% 1);
    }

    pub fn s8(self: *const Cpu) i8 {
        return self.mmu.readSignedByte(self.pc +% 1);
    }

    pub fn d16(self: *const Cpu) u16 {
        return self.mmu.readWord(self.pc +% 1);
    }

    pub fn executeInstruction(self: *Cpu) void {
        opcodes_table[self.opcode()](self);
    }
};
