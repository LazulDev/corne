# AGENTS.md

## Project Overview

ZMK firmware configuration for a **Corne TP** — a 42-key (3×6 + 3 thumb) split keyboard built on **nice!nano v2** (nRF52840) controllers over Bluetooth. The left half has an SSD1306 OLED display; the right half has an Azoteq IQS5xx (TPS43) I2C trackpad. ZMK Studio support is enabled.

This is **not** a typical software project. There is no application code, package manager, linter, or test suite. The repository is a ZMK user config consumed by the ZMK build system (West/Zephyr) via GitHub Actions.

## Repository Structure

```
build.yaml                        # GitHub Actions build matrix (boards + shields)
config/
  west.yml                        # West manifest — pulls zmk + azoteq trackpad driver
  corne_tp.keymap                 # Keymap: 4 layers (DEFAULT, NUMBER, FN, HOTKEY)
  corne_tp_left.conf              # User-level Kconfig overrides for left half
  corne_tp_right.conf             # User-level Kconfig overrides for right half
  KEYMAP.md                       # (placeholder) Keymap documentation
  boards/shields/corne_tp/        # Custom shield definition
    corne_tp.dtsi                 # Shared devicetree (matrix, OLED, trackpad split input)
    corne_tp-layouts.dtsi         # Physical key layout metadata
    corne_tp.zmk.yml              # Shield metadata (siblings, features)
    corne_tp_left.overlay         # Left half DT overlay (columns, battery, trackpad listener)
    corne_tp_right.overlay        # Right half DT overlay (columns, battery, trackpad device)
    corne_tp_left.conf            # Shield-level left Kconfig (OLED, BLE, sleep, Studio)
    corne_tp_right.conf           # Shield-level right Kconfig (I2C, pointing, trackpad driver)
    Kconfig.defconfig              # Default Kconfig (split, BLE, display, LVGL)
    Kconfig.shield                 # Shield selection guards
.github/workflows/
  build.yml                       # CI: builds firmware via zmkfirmware/zmk build-user-config
  keymap-img.yml                  # CI: generates keymap SVGs (assets/imgs/) via keymap-drawer
```

## Build

There is **no local build by default**. Firmware is built automatically by GitHub Actions on push to `main` or on PRs.

- The CI workflow (`.github/workflows/build.yml`) uses the reusable workflow `zmkfirmware/zmk/.github/workflows/build-user-config.yml@v0.3`.
- `build.yaml` defines the build matrix: `corne_tp_left`, `corne_tp_right`, and `settings_reset`, all targeting `nice_nano/nrf52840`.
- The left build includes the `studio-rpc-usb-uart` snippet for ZMK Studio.
- Built `.uf2` artifacts are uploaded as the `firmware` archive in GitHub Actions.

### Local Build (optional)

To build locally you need the full ZMK/Zephyr toolchain:

1. Install `west` (`pip install west`)
2. `west init -l config/` from the repo root
3. `west update`
4. Build a half, e.g.: `west build -s zmk/app -b nice_nano/nrf52840 -- -DSHIELD=corne_tp_left -DZMK_CONFIG="$(pwd)/config"`

The `.gitignore` excludes local build artifacts: `build/`, `.west/`, `modules/`, `zmk/`, `firmware/`.

## Dependencies (West Manifest)

Defined in `config/west.yml`:

- **zmk** — `zmkfirmware/zmk@main` (core firmware + Zephyr RTOS)
- **zmk-driver-azoteq-iqs5xx** — `AYM1607/zmk-driver-azoteq-iqs5xx@main` (trackpad driver)

## Keymap

The keymap is in `config/corne_tp.keymap` (Devicetree format). Four layers:

- **0 DEFAULT** — QWERTY base. Left thumb: right-click, Ctrl/Enter, layer 1 (NUMBER). Right thumb: Backspace, layer 3 (HOTKEY), left-click.
- **1 NUMBER** — Numbers row, symbols, braces/brackets.
- **2 FN** — Function/numpad hybrid.
- **3 HOTKEY** — BT profile select (0–4), output toggle, BT clear, soft off.

When editing the keymap, preserve the ASCII-art column alignment comments. Each layer has a 6×3 + 3 thumb grid per half. Bindings use ZMK behavior shorthands (`&kp`, `&mt`, `&trans`, `&bt`, `&mkp`, `&mo`, `&out`, `&soft_off`).

## Hardware-Specific Notes

- **Left half is the central** (BLE host). It has the OLED and acts as the split central (`ZMK_SPLIT_ROLE_CENTRAL`).
- **Right half is the peripheral**. It physically hosts the Azoteq TPS43 trackpad connected over I2C (`reg = <0x74>`). Trackpad input is forwarded to the left half via ZMK's `input-split` mechanism.
- The trackpad has `switch-xy`, `natural-scroll-x`, and `natural-scroll-y` enabled. Input is further transformed with `XY_SWAP | X_INVERT` in the listener on the central side.
- The OLED is an SSD1306 128×32 on I2C address `0x3c`.
- GPIO pins follow the `pro_micro` pin mapping for the nice!nano.

## Configuration Layering

Kconfig is applied in two layers:

1. **Shield-level** (`config/boards/shields/corne_tp/*.conf`) — base hardware config (OLED, BLE, trackpad driver, sleep, Studio).
2. **User-level** (`config/corne_tp_left.conf`, `config/corne_tp_right.conf`) — personal overrides on top of shield defaults. Currently minimal.

When adding new Kconfig options, prefer the user-level files for personal tweaks and the shield-level files for hardware-dependent settings.

## Flashing

1. Connect a half via USB.
2. Double-click the nice!nano reset button to enter UF2 bootloader (appears as a USB mass-storage drive).
3. Drag the corresponding `.uf2` file onto the drive.
4. **Flash order**: right half first, then left half (for BLE pairing).
5. To reset stored settings/pairings, flash `settings_reset.uf2` first, then re-flash the normal firmware.

## PR / CI Guidelines

- Pushing to `main` or opening a PR triggers the firmware build workflow.
- Changing any `config/*.keymap` file on `main` (or manually via `workflow_dispatch`) triggers the keymap drawing workflow (`keymap-drawer`), which commits SVG visualizations to `assets/imgs/`.
- Ensure the CI build passes (all three artifacts: left, right, settings_reset) before merging.

## Common Tasks

**Add a new key binding**: Edit `config/corne_tp.keymap`. Find the correct layer and positional slot.

**Add a new layer**: Define a new layer block in `config/corne_tp.keymap`, add a `#define` for it, and wire it in via `&mo <layer>` or `&tog <layer>` on an existing layer.

**Change trackpad behavior**: Modify `config/boards/shields/corne_tp/corne_tp_right.overlay` (device properties) or `corne_tp.dtsi` (input processor transforms).

**Change BLE / power settings**: Edit `config/boards/shields/corne_tp/corne_tp_left.conf` (shield-level) or `config/corne_tp_left.conf` (user-level).

**Add a new ZMK module/driver**: Add the remote and project to `config/west.yml`, then reference it in the appropriate overlay or Kconfig files.
