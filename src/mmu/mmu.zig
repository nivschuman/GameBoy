const memory = @import("../memory/memory.zig");

pub const Mmu = struct {
    wram: *memory.WRam,
    hram: *memory.HRam,
    oam: *memory.Oam,
    vram: *memory.VRam,

    pub fn readByte(self: *const Mmu, address: u16) u8 {
        return switch (address) {
            0x8000...0x9FFF => self.vram.readByte(address - 0x8000),
            0xC000...0xDFFF => self.wram.readByte(address - 0xC000),
            0xFE00...0xFE9F => self.oam.readByte(address - 0xFE00),
            0xFF80...0xFFFE => self.hram.readByte(address - 0xFF80),
            else => 0xFF,
        };
    }

    pub fn readSignedByte(self: *const Mmu, address: u16) i8 {
        return @bitCast(self.readByte(address));
    }

    pub fn writeByte(self: *Mmu, address: u16, value: u8) void {
        switch (address) {
            0x8000...0x9FFF => self.vram.writeByte(address - 0x8000, value),
            0xC000...0xDFFF => self.wram.writeByte(address - 0xC000, value),
            0xFE00...0xFE9F => self.oam.writeByte(address - 0xFE00, value),
            0xFF80...0xFFFE => self.hram.writeByte(address - 0xFF80, value),
        }
    }

    pub fn readWord(self: *const Mmu, address: u16) u16 {
        const low = self.readByte(address);
        const high = self.readByte(address + 1);
        return (@as(u16, high) << 8) | (@as(u16, low));
    }

    pub fn writeWord(self: *Mmu, address: u16, value: u16) void {
        const low = @as(u8, @truncate(value));
        const high = @as(u8, @truncate(value >> 8));
        self.writeByte(address, low);
        self.writeByte(address + 1, high);
    }
};
