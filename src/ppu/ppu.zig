const VRam = @import("vram/vram.zig").VRam;
const Oam = @import("oam/oam.zig").Oam;
const Dma = @import("../io/lcd/dma/dma.zig").Dma;

pub const Ppu = struct {
    oam: *Oam,
    vram: *VRam,
    dma: *Dma,

    pub fn init(oam: *Oam, vram: *VRam, dma: *Dma) Ppu {
        return .{
            .oam = oam,
            .vram = vram,
            .dma = dma,
        };
    }

    pub fn readByte(self: *const Ppu, address: u16) u8 {
        return switch (address) {
            0x8000...0x9FFF => self.vram.readByte(address),
            0xFE00...0xFE9F => if (self.dma.transferring()) 0xFF else self.oam.readByte(address - 0xFE00),
            else => @panic("invalid ppu address"),
        };
    }

    pub fn writeByte(self: *Ppu, address: u16, value: u8) void {
        switch (address) {
            0x8000...0x9FFF => self.vram.writeByte(address, value),
            0xFE00...0xFE9F => if (!self.dma.transferring()) self.oam.writeByte(address - 0xFE00, value),
            else => @panic("invalid ppu address"),
        }
    }
};
