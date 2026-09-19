# Game Boy Emulator

A Game Boy emulator written from scratch in **Zig**.

The goal of this project is to understand how the original Game Boy hardware works by implementing its major components at the hardware level.

## Requirements

* [Zig 0.15.2](https://ziglang.org/)
* SDL2 development libraries

### Windows SDL2 Setup

SDL2 is not included in the repository. Download the **SDL2 development libraries for Windows** from the official SDL website.

After downloading SDL2, place the extracted files under:

```text
third_party/sdl2/
```

The directory should contain the following structure:

```text
third_party/
└── sdl2/
    ├── include/
    ├── lib/
    └── bin/
        └── SDL2.dll
```

The project is configured to use SDL2 from this location.

## Building

Build the project with:

```bash
zig build
```

The executable will be generated at:

```text
zig-out/bin/gameboy.exe
```

## Running

The emulator expects the path to a Game Boy ROM as its first command-line argument.

```bash
zig build run -- path\to\game.gb
```

## Debug Mode

The emulator supports an optional debug mode as a second command-line argument.

The available modes are:

| Mode        | Description                                                                 |
| ----------- | --------------------------------------------------------------------------- |
| `DebugOff`  | Normal execution with debugging disabled.                                   |
| `DebugLog`  | Logs debugging information and opens the debug window.                      |
| `DebugStep` | Enables debug logging, opens the debug window, and steps through execution. |

For example:

```bash
zig build run -- path\to\game.gb DebugLog
```

Or:

```bash
zig build run -- path\to\game.gb DebugStep
```

When a debug mode is enabled, the debug window displays the tiles currently stored in VRAM.

The debug tile viewer displays all **384 tiles** available in the Game Boy's tile data area.

## Tests

Run the test suite with:

```bash
zig build test
```

The tests cover individual hardware components and behaviors, including:

* CPU
* Memory
* VRAM
* PPU
* Pixel fetcher

## Project Structure

The project is organized around the major components of the Game Boy hardware:

```text
src/
├── cartridge/       Cartridge and ROM handling
├── constants/       Constants
├── cpu/             LR35902 CPU
├── cycles/          Cycle and timing management
├── errors/          Error types
├── gameboy/         Game Boy execution and control
├── io/              Memory-mapped I/O
│   ├── interrupts/
│   ├── lcd/
│   ├── serial/
│   └── timer/
├── mmu/             Memory management and address routing
├── ppu/             Picture Processing Unit
│   ├── fetcher/
│   ├── oam/
│   └── vram/
├── tests/            Tests and test runner
├── ui/               SDL2-based UI
└── utils/            Utility code
```

## References

The implementation is primarily based on Game Boy technical documentation and hardware behavior described by [Pan Docs](https://gbdev.io/pandocs/).
