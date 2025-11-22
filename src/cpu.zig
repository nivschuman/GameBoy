const Registers = @import("registers.zig").Registers;
const Memory = @import("memory.zig").Memory;

pub const Cpu = struct {
    registers: Registers,
    pc: u16,
    memory: Memory,

    pub fn init() Cpu {
        return .{
            .registers = Registers.init(),
            .pc = 0,
            .memory = Memory.init(),
        };
    }
};
