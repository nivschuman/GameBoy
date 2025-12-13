const std = @import("std");
const types = @import("types/types.zig");

pub const CartridgeHeader = struct {
    rom_header: []const u8,

    pub fn init(rom: []const u8) CartridgeHeader {
        return CartridgeHeader{
            .rom_header = rom[0x0100..0x0150],
        };
    }

    pub fn entryPoint(self: *const CartridgeHeader) []const u8 {
        return self.rom_header[0x00..0x04];
    }

    pub fn logo(self: *const CartridgeHeader) []const u8 {
        return self.rom_header[0x04..0x34];
    }

    pub fn title(self: *const CartridgeHeader) []const u8 {
        return self.rom_header[0x34..0x44];
    }

    pub fn newLicensee(self: *const CartridgeHeader) types.NewLicensee {
        return @enumFromInt(self.rom_header[0x44]);
    }

    pub fn sgb(self: *const CartridgeHeader) bool {
        return self.rom_header[0x46] != 0;
    }

    pub fn cartridgeType(self: *const CartridgeHeader) types.CartridgeType {
        return @enumFromInt(self.rom_header[0x47]);
    }

    pub fn romSize(self: *const CartridgeHeader) types.RomSize {
        return @enumFromInt(self.rom_header[0x48]);
    }

    pub fn ramSize(self: *const CartridgeHeader) types.RamSize {
        return @enumFromInt(self.rom_header[0x49]);
    }

    pub fn destinationCode(self: *const CartridgeHeader) types.DestinationCode {
        return @enumFromInt(self.rom_header[0x4A]);
    }

    pub fn oldLicensee(self: *const CartridgeHeader) types.OldLicensee {
        return @enumFromInt(self.rom_header[0x4B]);
    }

    pub fn versionNumber(self: *const CartridgeHeader) u8 {
        return self.rom_header[0x4C];
    }

    pub fn headerChecksum(self: *const CartridgeHeader) u8 {
        return self.rom_header[0x4D];
    }

    pub fn globalChecksum(self: *const CartridgeHeader) u16 {
        return (@as(u16, self.rom_header[0x4E]) << 8) | @as(u16, self.rom_header[0x4F]);
    }
};

pub const Cartridge = struct {
    header: CartridgeHeader,
    rom: []u8,

    pub fn init(rom: []u8) Cartridge {
        return .{ .header = CartridgeHeader.init(rom), .rom = rom };
    }

    pub fn validHeaderChecksum(self: *const Cartridge) bool {
        var checksum: u8 = 0;
        for (self.rom[0x0134..0x014D]) |value| {
            checksum = checksum -% value -% 1;
        }

        return self.header.headerChecksum() == checksum;
    }

    pub fn readByte(self: *const @This(), addr: u16) u8 {
        return self.rom[addr];
    }

    pub fn writeByte(self: *@This(), addr: u16, value: u8) void {
        self.rom[addr] = value;
    }
};

pub const FileLoader = struct {
    allocator: std.mem.Allocator,
    file_bytes: []u8,

    pub fn init(allocator: std.mem.Allocator, filename: []const u8) !FileLoader {
        const cwd = std.fs.cwd();
        const file = try cwd.openFile(filename, .{ .mode = .read_only });
        defer file.close();

        const file_size = try file.getEndPos();
        const file_bytes = try allocator.alloc(u8, file_size);
        _ = try file.readAll(file_bytes);

        return .{ .allocator = allocator, .file_bytes = file_bytes };
    }

    pub fn deinit(self: *const FileLoader) void {
        self.allocator.free(self.file_bytes);
    }
};
