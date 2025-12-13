const Cartridge = @import("../cartridge/cartridge.zig").Cartridge;

pub const Mmu = struct {
    cartridge: *Cartridge,

    pub fn init(cartridge: *Cartridge) Mmu {
        return .{
            .cartridge = cartridge,
        };
    }

    pub fn readByte(self: *const Mmu, address: u16) u8 {
        return switch (address) {
            0x0000...0x8000 => self.cartridge.readByte(address),
            else => @panic("unmapped address"),
        };
    }

    pub fn readSignedByte(self: *const Mmu, address: u16) i8 {
        return @bitCast(self.readByte(address));
    }

    pub fn writeByte(self: *Mmu, address: u16, value: u8) void {
        switch (address) {
            0x0000...0x8000 => self.cartridge.writeByte(address, value),
            else => @panic("unmapped address"),
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
