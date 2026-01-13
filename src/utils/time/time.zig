const std = @import("std");

pub const Milliseconds = u32;
pub const TimestampFunction = *const fn () Milliseconds;
pub const DelayFunction = *const fn (Milliseconds) void;

pub const Stopwatch = struct {
    timestamp_function: TimestampFunction,
    start_time: Milliseconds,

    pub fn init(timestamp_function: TimestampFunction) Stopwatch {
        return .{
            .timestamp_function = timestamp_function,
            .start_time = timestamp_function(),
        };
    }

    pub fn reset(self: *Stopwatch) void {
        self.start_time = self.timestamp_function();
    }

    pub fn elapsedTime(self: *const Stopwatch) Milliseconds {
        return self.timestamp_function() - self.start_time;
    }
};

pub const Delayer = struct {
    delay_function: DelayFunction,

    pub fn init(delay_function: DelayFunction) Delayer {
        return .{
            .delay_function = delay_function,
        };
    }

    pub fn delay(self: *const Delayer, milliseconds: Milliseconds) void {
        self.delay_function(milliseconds);
    }
};

pub const StdStopwatch = struct {
    pub fn init() Stopwatch {
        return Stopwatch.init(stdTimestamp);
    }

    fn stdTimestamp() Milliseconds {
        return @truncate(@as(u64, @intCast(std.time.milliTimestamp())));
    }
};

pub const StdDelayer = struct {
    pub fn init() Delayer {
        return Delayer.init(stdDelay);
    }

    fn stdDelay(milliseconds: Milliseconds) void {
        const nanoseconds: u64 = @as(u64, @intCast(milliseconds)) * 1_000_000;
        std.Thread.sleep(nanoseconds);
    }
};
