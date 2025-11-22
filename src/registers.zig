pub const Registers = struct {
    a: u8,
    b: u8,
    c: u8,
    d: u8,
    e: u8,
    f: u8,
    g: u8,
    h: u8,
    l: u8,

    pub fn init() Registers {
        return .{
            .a = 0,
            .b = 0,
            .c = 0,
            .d = 0,
            .e = 0,
            .f = 0,
            .g = 0,
            .h = 0,
            .l = 0,
        };
    }

    pub fn getBC(self: *const Registers) u16 {
        return (@as(u16, self.b) << 8) | (@as(u16, self.c));
    }

    pub fn setBC(self: *Registers, value: u16) void {
        self.b = @truncate(value >> 8);
        self.c = @truncate(value);
    }

    pub fn getDE(self: *const Registers) u16 {
        return (@as(u16, self.d) << 8) | (@as(u16, self.e));
    }

    pub fn setDE(self: *Registers, value: u16) void {
        self.d = @truncate(value >> 8);
        self.e = @truncate(value);
    }

    pub fn getHL(self: *const Registers) u16 {
        return (@as(u16, self.h) << 8) | (@as(u16, self.l));
    }

    pub fn setHL(self: *Registers, value: u16) void {
        self.h = @truncate(value >> 8);
        self.l = @truncate(value);
    }

    pub fn getZeroFlag(self: *const Registers) bool {
        return (self.f & 0x80) != 0;
    }

    pub fn getZeroFlagValue(self: *const Registers) u1 {
        return @intFromBool(self.getZeroFlag());
    }

    pub fn setZeroFlag(self: *Registers, value: bool) void {
        self.f = (self.f & 0x7F) | (@as(u8, @intFromBool(value)) << 7);
    }

    pub fn getSubtractionFlag(self: *const Registers) bool {
        return (self.f & 0x40) != 0;
    }

    pub fn getSubtractionFlagValue(self: *const Registers) u1 {
        return @intFromBool(self.getSubtractionFlag());
    }

    pub fn setSubtractionFlag(self: *Registers, value: bool) void {
        self.f = (self.f & 0xBF) | (@as(u8, @intFromBool(value)) << 6);
    }

    pub fn getHalfCarryFlag(self: *const Registers) bool {
        return (self.f & 0x20) != 0;
    }

    pub fn getHalfCarryFlagValue(self: *const Registers) u1 {
        return @intFromBool(self.getHalfCarryFlag());
    }

    pub fn setHalfCarryFlag(self: *Registers, value: bool) void {
        self.f = (self.f & 0xDF) | (@as(u8, @intFromBool(value)) << 5);
    }

    pub fn getCarryFlag(self: *const Registers) bool {
        return (self.f & 0x10) != 0;
    }

    pub fn getCarryFlagValue(self: *const Registers) u1 {
        return @intFromBool(self.getCarryFlag());
    }

    pub fn setCarryFlag(self: *Registers, value: bool) void {
        self.f = (self.f & 0xEF) | (@as(u8, @intFromBool(value)) << 4);
    }
};
