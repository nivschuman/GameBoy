const Mmu = @import("../../../mmu/mmu.zig").Mmu;
const Cycle = @import("../../../cycles/cycles.zig").Cycle;

pub const Dma = struct {
    source_address: u16,
    destination_address: u16,
    active: bool,
    delay: Cycle,

    pub fn init() Dma {
        return .{
            .source_address = 0,
            .destination_address = 0,
            .active = false,
            .delay = 0,
        };
    }

    pub fn activate(self: *Dma, value: u8) void {
        self.source_address = @as(u16, value) << 8;
        self.destination_address = 0xFE00;
        self.active = true;
        self.delay = 2;
    }

    pub fn cycle(self: *Dma, mmu: *Mmu) void {
        if (!self.active) {
            return;
        }

        if (self.delay > 0) {
            self.delay -= 1;
            return;
        }

        mmu.writeByte(self.destination_address, mmu.readByte(self.source_address));
        self.destination_address += 1;
        self.source_address += 1;
        if (self.destination_address > 0xFE9F) {
            self.active = false;
        }
    }

    pub fn transferring(self: *const Dma) bool {
        return self.active;
    }
};
