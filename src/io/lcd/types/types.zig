pub const LcdMode = enum(u2) {
    HBLANK = 0,
    VBLANK = 1,
    OAM = 2,
    XFER = 3,
};

pub const StatInterruptCondition = enum(u3) {
    LYC = 3,
    OAM = 4,
    VBLANK = 5,
    HBLANK = 6,
};

pub const ObjectSize = struct {
    width: u8,
    height: u8,

    pub fn init(width: u8, height: u8) ObjectSize {
        return .{
            .width = width,
            .height = height,
        };
    }
};
