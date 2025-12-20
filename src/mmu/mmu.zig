const Cartridge = @import("../cartridge/cartridge.zig").Cartridge;
const memory = @import("memory/memory.zig");
const InterruptRegisters = @import("../cpu/interrupts/interrupts.zig").InterruptRegisters;

pub const Mmu = struct {
    cartridge: *Cartridge,
    wram: *memory.WRam,
    hram: *memory.HRam,
    interrupt_registers: *InterruptRegisters,

    pub fn init(cartridge: *Cartridge, wram: *memory.WRam, hram: *memory.HRam, interrupt_registers: *InterruptRegisters) Mmu {
        return .{
            .cartridge = cartridge,
            .wram = wram,
            .hram = hram,
            .interrupt_registers = interrupt_registers,
        };
    }

    pub fn readByte(self: *const Mmu, address: u16) u8 {
        return switch (address) {
            0x0000...0x7FFF => self.cartridge.readByte(address), // ROM bank 0 / switchable banks
            0x8000...0x9FFF => @panic("unmapped address"), // VRAM (8 KB) – video memory
            0xA000...0xBFFF => self.cartridge.readByte(address - 0xA000), // External RAM in cartridge
            0xC000...0xDFFF => self.wram.readByte(address - 0xC000), // Work RAM (WRAM)
            0xE000...0xFDFF => self.wram.readByte(address - 0xE000), // Echo RAM (mirror of WRAM)
            0xFE00...0xFE9F => @panic("unmapped address"), // OAM (sprite attribute memory, 160 bytes)
            0xFEA0...0xFEFF => 0, // Unusable / forbidden memory
            0xFF00...0xFF0E => @panic("unmapped address"), // I/O registers
            0xFF0F => self.interrupt_registers.interrupt_flag,
            0xFF10...0xFF7F => @panic("unmapped address"), // I/O registers
            0xFF80...0xFFFE => self.hram.readByte(address - 0xFF80), // High Ram (HRAM)
            0xFFFF => self.interrupt_registers.interrupt_enable, // Interrupt Enable register
        };
    }

    pub fn readSignedByte(self: *const Mmu, address: u16) i8 {
        return @bitCast(self.readByte(address));
    }

    pub fn writeByte(self: *Mmu, address: u16, value: u8) void {
        switch (address) {
            0x0000...0x7FFF => self.cartridge.writeByte(address, value), // ROM bank 0 / switchable banks
            0x8000...0x9FFF => @panic("unmapped address"), // VRAM – video memory
            0xA000...0xBFFF => self.cartridge.writeByte(address - 0xA000, value), // External RAM in cartridge
            0xC000...0xDFFF => self.wram.writeByte(address - 0xC000, value), // Work RAM (WRAM)
            0xE000...0xFDFF => self.wram.writeByte(address - 0xE000, value), // Echo RAM (mirror of WRAM)
            0xFE00...0xFE9F => @panic("unmapped address"), // OAM (sprite attribute memory, 160 bytes)
            0xFEA0...0xFEFF => {}, // Unusable / forbidden memory – writes ignored
            0xFF00...0xFF0E => @panic("unmapped address"), // I/O registers
            0xFF0F => self.interrupt_registers.setInterruptFlag(value),
            0xFF10...0xFF7F => @panic("unmapped address"), // I/O registers
            0xFF80...0xFFFE => self.hram.writeByte(address - 0xFF80, value), // High Ram (HRAM)
            0xFFFF => self.interrupt_registers.setInterruptEnable(value), // Interrupt Enable register
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
