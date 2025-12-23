const std = @import("std");

const winlibs = [_][]const u8{
    "gdi32",
    "winmm",
    "setupapi",
    "user32",
    "shell32",
    "advapi32",
    "ole32",
    "oleaut32",
    "imm32",
    "version",
};

pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "gameboy",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = b.graph.host,
        }),
    });

    const sdl_path = "third_party/sdl2";
    exe.addIncludePath(b.path(sdl_path ++ "/include"));
    exe.addLibraryPath(b.path(sdl_path ++ "/lib"));

    exe.linkLibC();
    for (winlibs) |winLib| {
        exe.linkSystemLibrary(winLib);
    }
    exe.linkSystemLibrary("SDL2");

    b.installBinFile(sdl_path ++ "/bin/SDL2.dll", "SDL2.dll");
    b.installArtifact(exe);

    const run_exe = b.addRunArtifact(exe);
    if (b.args) |args| {
        run_exe.addArgs(args);
    }
    const run_step = b.step("run", "Run the application");
    run_step.dependOn(&run_exe.step);

    const test_step = b.step("test", "Run tests");
    const tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/tests.zig"),
            .target = b.graph.host,
        }),
        .test_runner = .{ .path = b.path("src/tests/test_runner.zig"), .mode = .simple },
    });
    const run_tests = b.addRunArtifact(tests);
    test_step.dependOn(&run_tests.step);
}
