const Registers = @import("registers.zig").Registers;
const Memory = @import("memory.zig").Memory;

pub const Cpu = struct {
    registers: Registers,
    pc: u16,
    sp: u16,
    halted: bool,
    stopped: bool,
    memory: *Memory,

    pub fn init(memory: *Memory) Cpu {
        return .{
            .registers = Registers.init(),
            .pc = 0,
            .sp = 0,
            .memory = memory,
            .halted = false,
            .stopped = false,
        };
    }

    pub fn d8(self: *const Cpu) u8 {
        return self.memory.readByte(self.pc +% 1);
    }

    pub fn s8(self: *const Cpu) i8 {
        return self.memory.readSignedByte(self.pc +% 1);
    }

    pub fn d16(self: *const Cpu) u16 {
        return self.memory.readWord(self.pc +% 1);
    }
};
