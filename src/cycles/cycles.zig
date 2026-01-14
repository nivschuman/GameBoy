//tick frequency = 4,194,304 Hz
//cycle frequency = 4,194,304Hz / 4 = 1,048,576 Hz (one cycle every 4 ticks)

const Timer = @import("../io/timer/timer.zig").Timer;
const Dma = @import("../io/lcd/dma/dma.zig").Dma;
const Mmu = @import("../mmu/mmu.zig").Mmu;
const Ppu = @import("../ppu/ppu.zig").Ppu;

// 1 cycle = 4 ticks
pub const Cycle = u16; //M-Cycle
pub const Tick = u16; //T-Cycle

pub const CycleManager = struct {
    timer: *Timer,
    dma: *Dma,
    mmu: *Mmu,
    ppu: *Ppu,

    pub fn init(timer: *Timer, dma: *Dma, mmu: *Mmu, ppu: *Ppu) CycleManager {
        return .{
            .timer = timer,
            .dma = dma,
            .mmu = mmu,
            .ppu = ppu,
        };
    }

    pub fn cycle(self: *CycleManager, cycles: Cycle) void {
        var c: Cycle = 0;
        while (c < cycles) : (c += 1) {
            const ticks: Tick = cycles * 4;
            var t: Tick = 0;
            while (t < ticks) : (t += 1) {
                self.timer.tick();
                self.ppu.tick();
            }

            self.dma.cycle(self.mmu);
        }
    }
};
