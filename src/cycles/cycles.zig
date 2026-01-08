//tick frequency = 4,194,304 Hz
//cycle frequency = 4,194,304Hz / 4 = 1,048,576 Hz (one cycle every 4 ticks)

const Timer = @import("../io/timer/timer.zig").Timer;
const Dma = @import("../io/dma/dma.zig").Dma;
const Mmu = @import("../mmu/mmu.zig").Mmu;

// 1 cycle = 4 ticks
pub const Cycle = u8; //M-Cycle
pub const Tick = u8; //T-Cycle

pub const CycleManager = struct {
    timer: *Timer,
    dma: *Dma,
    mmu: *Mmu,

    pub fn init(timer: *Timer, dma: *Dma, mmu: *Mmu) CycleManager {
        return .{
            .timer = timer,
            .dma = dma,
            .mmu = mmu,
        };
    }

    pub fn cycle(self: *CycleManager, cycles: Cycle) void {
        var c: Cycle = 0;
        while (c < cycles) : (c += 1) {
            const ticks: Tick = cycles * 4;
            var t: Tick = 0;
            while (t < ticks) : (t += 1) {
                self.timer.tick();
            }

            self.dma.cycle(self.mmu);
        }
    }
};
