pub const Cycles = u8;
pub const Ticks = u8;

pub const CycleManager = struct {
    pub fn init() CycleManager {
        return .{};
    }

    pub fn cycle(_: *const CycleManager, _: Cycles) void {}
};

pub fn asTicks(cycles: Cycles) Ticks {
    return cycles * 4;
}
