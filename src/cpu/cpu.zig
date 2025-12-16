const Registers = @import("registers/registers.zig").Registers;
const Mmu = @import("../mmu/mmu.zig").Mmu;
const CycleManager = @import("../cycles/cycles.zig").CycleManager;
const Cycles = @import("../cycles/cycles.zig").Cycles;
const opcodes_table = @import("opcodes.zig").opcodes_table;

pub const Cpu = struct {
    registers: Registers,
    pc: u16,
    sp: u16,
    halted: bool,
    stopped: bool,
    mmu: *Mmu,
    cycle_manager: *CycleManager,

    pub fn init(mmu: *Mmu, cycle_manager: *CycleManager) Cpu {
        return .{
            .registers = Registers.init(),
            .pc = 0,
            .sp = 0,
            .mmu = mmu,
            .cycle_manager = cycle_manager,
            .halted = false,
            .stopped = false,
        };
    }

    pub fn opcode(self: *const Cpu) u8 {
        return self.readByte(self.pc);
    }

    pub fn d8(self: *const Cpu) u8 {
        return self.readByte(self.pc +% 1);
    }

    pub fn s8(self: *const Cpu) i8 {
        return self.readSignedByte(self.pc +% 1);
    }

    pub fn d16(self: *const Cpu) u16 {
        return self.readWord(self.pc +% 1);
    }

    pub fn readByte(self: *const Cpu, address: u16) u8 {
        const result = self.mmu.readByte(address);
        self.cycle(1);
        return result;
    }

    pub fn readSignedByte(self: *const Cpu, address: u16) i8 {
        const result = self.mmu.readSignedByte(address);
        self.cycle(1);
        return result;
    }

    pub fn readWord(self: *const Cpu, address: u16) u16 {
        const result = self.mmu.readWord(address);
        self.cycle(2);
        return result;
    }

    pub fn writeByte(self: *Cpu, address: u16, value: u8) void {
        self.mmu.writeByte(address, value);
        self.cycle(1);
    }

    pub fn writeWord(self: *Cpu, address: u16, value: u16) void {
        self.mmu.writeWord(address, value);
        self.cycle(2);
    }

    pub fn executeInstruction(self: *Cpu) void {
        opcodes_table[self.opcode()](self);
    }

    pub fn cycle(self: *const Cpu, cycles: Cycles) void {
        self.cycle_manager.cycle(cycles);
    }
};
