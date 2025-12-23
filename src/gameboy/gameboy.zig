const Cpu = @import("../cpu/cpu.zig").Cpu;

pub const GameBoy = struct {
    cpu: *Cpu,

    pub fn init(cpu: *Cpu) GameBoy {
        return .{
            .cpu = cpu,
        };
    }

    pub fn start(self: *GameBoy) void {
        while (true) {
            self.cpu.step();
        }
    }
};
