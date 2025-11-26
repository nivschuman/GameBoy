const Registers = @import("registers.zig").Registers;
const Memory = @import("memory.zig").Memory;

pub const Cpu = struct {
    registers: Registers,
    pc: u16,
    sp: u16,
    memory: Memory,
    halted: bool,
    stopped: bool,

    pub fn init() Cpu {
        return .{
            .registers = Registers.init(),
            .pc = 0,
            .sp = 0,
            .memory = Memory.init(),
            .halted = false,
            .stopped = false,
        };
    }
};
