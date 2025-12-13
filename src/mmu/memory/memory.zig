pub fn Memory(comptime size: usize) type {
    return struct {
        data: [size]u8,

        pub fn init() @This() {
            return .{ .data = [_]u8{0} ** size };
        }

        pub fn readByte(self: *const @This(), addr: u16) u8 {
            return self.data[addr];
        }

        pub fn writeByte(self: *@This(), addr: u16, value: u8) void {
            self.data[addr] = value;
        }
    };
}

pub const WRam = Memory(0x2000);
pub const HRam = Memory(0x7F);
pub const Oam = Memory(0xA0);
pub const VRam = Memory(0x2000);
