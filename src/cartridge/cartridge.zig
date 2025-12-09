const std = @import("std");
const types = @import("types/types.zig");

pub const CartridgeHeader = struct {
    rom_header: []const u8,

    pub fn init(rom: []const u8) CartridgeHeader {
        return CartridgeHeader{
            .rom_header = rom[0x0100..0x0150],
        };
    }

    pub fn entryPoint(self: *CartridgeHeader) []const u8 {
        return self.rom_header[0x00..0x04];
    }

    pub fn logo(self: *CartridgeHeader) []const u8 {
        return self.rom_header[0x04..0x34];
    }

    pub fn title(self: *CartridgeHeader) []const u8 {
        return self.rom_header[0x34..0x44];
    }

    pub fn newLicensee(self: *CartridgeHeader) types.NewLicensee {
        return @enumFromInt(self.rom_header[0x44]);
    }

    pub fn sgb(self: *CartridgeHeader) bool {
        return self.rom_header[0x46] != 0;
    }

    pub fn cartridgeType(self: *CartridgeHeader) types.CartridgeType {
        return @enumFromInt(self.rom_header[0x47]);
    }

    pub fn romSize(self: *CartridgeHeader) types.RomSize {
        return @enumFromInt(self.rom_header[0x48]);
    }

    pub fn ramSize(self: *CartridgeHeader) types.RamSize {
        return @enumFromInt(self.rom_header[0x49]);
    }

    pub fn destinationCode(self: *CartridgeHeader) types.DestinationCode {
        return @enumFromInt(self.rom_header[0x4A]);
    }

    pub fn oldLicensee(self: *CartridgeHeader) types.OldLicensee {
        return @enumFromInt(self.rom_header[0x4B]);
    }

    pub fn versionNumber(self: *CartridgeHeader) u8 {
        return self.rom_header[0x4C];
    }

    pub fn headerChecksum(self: *CartridgeHeader) u8 {
        return self.rom_header[0x4D];
    }

    pub fn globalChecksum(self: *CartridgeHeader) u16 {
        return (@as(u16, self.rom_header[0x4E]) << 8) | @as(u16, self.rom_header[0x4F]);
    }
};

pub const Cartridge = struct {
    header: CartridgeHeader,
    rom: []const u8,

    pub fn init(rom: []const u8) Cartridge {
        return .{ .header = CartridgeHeader.init(rom), .rom = rom };
    }

    pub fn validHeaderChecksum(self: *Cartridge) bool {
        var checksum: u8 = 0;
        for (self.rom[0x0134..0x014D]) |value| {
            checksum = checksum -% value -% 1;
        }

        return self.header.headerChecksum() == checksum;
    }
};

pub const RomLoader = struct {
    allocator: std.mem.Allocator,
    rom: []u8,

    pub fn init(allocator: std.mem.Allocator, filename: []const u8) !RomLoader {
        const cwd = std.fs.cwd();
        const file = try cwd.openFile(filename, .{ .mode = .read_only });
        defer file.close();

        const file_size = try file.getEndPos();
        const rom = try allocator.alloc(u8, file_size);
        try file.readAll(rom);

        return .{ .allocator = allocator, .rom = rom };
    }

    pub fn deinit(self: *RomLoader) void {
        self.allocator.free(self.rom);
    }
};
