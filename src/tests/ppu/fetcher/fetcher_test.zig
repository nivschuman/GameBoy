const std = @import("std");
const Dma = @import("../../../io/lcd/dma/dma.zig").Dma;
const Lcd = @import("../../../io/lcd/lcd.zig").Lcd;
const VRam = @import("../../../ppu/vram/vram.zig").VRam;
const Pixel = @import("../../../ppu/vram/tiles/tiles.zig").Pixel;
const PixelFetcher = @import("../../../ppu/fetcher/fetcher.zig").PixelFetcher;
const PixelFifo = @import("../../../ppu/fetcher/fetcher.zig").PixelFifo;

fn testWithFetcher(testFunction: fn (*PixelFetcher) anyerror!void) anyerror!void {
    var dma = Dma.init();
    var lcd = Lcd.init(&dma);
    var vram = VRam.init();
    var bg_fifo = PixelFifo.init();
    var obj_fifo = PixelFifo.init();

    var fetcher = PixelFetcher.init(&bg_fifo, &obj_fifo, &vram, &lcd);
    try testFunction(&fetcher);
}

test "get tile" {
    const testFunction = struct {
        pub fn testFunction(fetcher: *PixelFetcher) anyerror!void {
            fetcher.vram.writeByte(0x9800, 1);

            fetcher.tick();
            fetcher.tick();

            try std.testing.expect(fetcher.tile_number == 1);
            try std.testing.expect(fetcher.mode == .GET_TILE_DATA_LOW);
        }
    }.testFunction;
    try testWithFetcher(testFunction);
}

test "get tile data" {
    const testFunction = struct {
        pub fn testFunction(fetcher: *PixelFetcher) anyerror!void {
            fetcher.vram.writeByte(0x9800, 1);
            fetcher.vram.writeByte(0x8010, 0xAA);
            fetcher.vram.writeByte(0x8011, 0x55);

            fetcher.tick();
            fetcher.tick();
            fetcher.tick();
            fetcher.tick();

            try std.testing.expect(fetcher.tile_data_low == 0xAA);
            try std.testing.expect(fetcher.mode == .GET_TILE_DATA_HIGH);

            fetcher.tick();
            fetcher.tick();

            try std.testing.expect(fetcher.tile_data_high == 0x55);
            try std.testing.expect(fetcher.mode == .SLEEP);
        }
    }.testFunction;
    try testWithFetcher(testFunction);
}

test "push tile" {
    const testFunction = struct {
        pub fn testFunction(fetcher: *PixelFetcher) anyerror!void {
            fetcher.vram.writeByte(0x8000, 0xFF);
            fetcher.vram.writeByte(0x8001, 0x00);

            for (0..9) |_| {
                fetcher.tick();
            }

            try std.testing.expect(fetcher.background_pixel_fifo.count == 7);
            try std.testing.expect(fetcher.render_x == 1);
            try std.testing.expect(
                fetcher.video_buffer[0] == fetcher.lcd.bgp.getColor(Pixel.init(1)),
            );
        }
    }.testFunction;
    try testWithFetcher(testFunction);
}
