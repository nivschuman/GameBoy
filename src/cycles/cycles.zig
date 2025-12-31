//tick frequency = 4,194,304 Hz
//cycle frequency = 4,194,304Hz / 4 = 1,048,576 Hz (one cycle every 4 ticks)

const Timer = @import("../io/timer/timer.zig").Timer;

pub const Cycle = u8; //M-Cycle
pub const Tick = u8; //T-Cycle

pub fn asTicks(cycles: Cycle) Tick {
    return cycles * 4;
}

pub const CycleManager = struct {
    timer: *Timer,

    pub fn init(timer: *Timer) CycleManager {
        return .{ .timer = timer };
    }

    pub fn cycle(self: *CycleManager, cycles: Cycle) void {
        const ticks = asTicks(cycles);
        var tick: u8 = 0;
        while (tick < ticks) : (tick += 1) {
            self.timer.tick();
        }
    }
};
