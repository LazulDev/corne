---
name: keymap-editor
description: >
  Review, visualize, and modify the ZMK keymap for this Corne TP split keyboard.
  Use when the user wants to change key bindings, swap keys, add or remove layers,
  move modifiers, change thumb cluster assignments, add macros/combos, or review
  the current layout. Triggers on: remap key, swap keys, change layer, move
  backspace, add shortcut, keymap, binding, thumb key, modifier, home row mods,
  tap-hold, combo, macro, layer toggle.
allowed-tools: Bash Read Write Edit Glob Grep
metadata:
  tags: zmk, keymap, keyboard, corne, split-keyboard, firmware
  version: "1.0"
---

# Keymap Editor

## When to use this skill
- User wants to change, swap, or reassign any key binding
- User wants to add, remove, or reorder layers
- User wants to review or visualize the current keymap
- User asks about what a specific key position does
- User wants to add combos, macros, tap-dance, or hold-tap behaviors
- User wants to apply a layout philosophy (home row mods, Miryoku-style, etc.)

## Keyboard geometry

Corne TP — 42 keys, split (3×6 + 3 thumb keys per half).

```
Left half (6 cols × 3 rows + 3 thumb)       Right half (6 cols × 3 rows + 3 thumb)

╭────┬────┬────┬────┬────┬────╮              ╭────┬────┬────┬────┬────┬────╮
│ 0  │ 1  │ 2  │ 3  │ 4  │ 5  │              │ 6  │ 7  │ 8  │ 9  │ 10 │ 11 │  Row 0
├────┼────┼────┼────┼────┼────┤              ├────┼────┼────┼────┼────┼────┤
│ 12 │ 13 │ 14 │ 15 │ 16 │ 17 │              │ 18 │ 19 │ 20 │ 21 │ 22 │ 23 │  Row 1
├────┼────┼────┼────┼────┼────┤              ├────┼────┼────┼────┼────┼────┤
│ 24 │ 25 │ 26 │ 27 │ 28 │ 29 │              │ 30 │ 31 │ 32 │ 33 │ 34 │ 35 │  Row 2
╰────┴────┴────┴────┼────┼────┼────╮    ╭────┼────┼────┼────┴────┴────┴────╯
                     │ 36 │ 37 │ 38 │    │ 39 │ 40 │ 41 │                      Thumbs
                     ╰────┴────┴────╯    ╰────┴────┴────╯
```

Positions 0–5 / 12–17 / 24–29 / 36–38 = left half.
Positions 6–11 / 18–23 / 30–35 / 39–41 = right half.

## Instructions

### Step 1: Read the current keymap

The keymap lives at `config/corne_tp.keymap`. Always read it before making changes.

Current layer definitions (indices are `#define`d at the top of the file):

| Index | Name    | Purpose |
|-------|---------|---------|
| 0     | DEFAULT | QWERTY base layer |
| 1     | NUMBER  | Numbers and symbols |
| 2     | FN      | Function / numpad |
| 3     | HOTKEY  | BT profiles, output toggle, soft off |

### Step 2: Understand the user's request

Clarify ambiguous requests before editing. Common patterns:

- **"swap X and Y"** — exchange two key positions within a layer.
- **"move X to Y"** — place binding X at position Y; ask what replaces the old position (usually `&trans` or `&none`).
- **"add home row mods"** — apply hold-tap (`&mt`) modifiers to home row (A S D F / J K L ;) on the DEFAULT layer.
- **"add a layer for …"** — create a new layer block, add a `#define`, wire an `&mo`/`&tog`/`&to` on an existing layer.
- **"add a combo"** — add a `combos` node outside the `keymap` node, inside the root `/` block.
- **"add a macro"** — add a `macros` node with a `zmk,behavior-macro` compatible binding.

### Step 3: Edit the keymap

Rules when editing `config/corne_tp.keymap`:

1. **Preserve ASCII-art alignment comments** — each row has a visual separator comment. Keep the column width consistent.
2. **Each layer must have exactly 42 bindings** — 36 matrix + 6 thumb. A missing or extra binding breaks the build.
3. **Use `&trans` for transparent (fall-through)**, `&none` for disabled keys.
4. **Do not reorder `#include` directives** — `pointing.h` must come after the `#define ZMK_POINTING_DEFAULT_SCRL_VAL` line.
5. **Layer indices must be contiguous** starting at 0. If adding a layer, use the next available index.
6. **Thumb row bindings** (positions 36–41) are on the last row inside the layer block, after the third row comment.

### Step 4: Validate after editing

After modifying the keymap, verify:

- Count exactly 42 bindings per layer (6+6 per row × 3 rows + 3+3 thumbs).
- All referenced layer indices exist.
- All behavior references are valid ZMK behaviors (`&kp`, `&mt`, `&mo`, `&lt`, `&tog`, `&to`, `&trans`, `&none`, `&bt`, `&out`, `&mkp`, `&soft_off`, `&kp`).
- Any new `#define` or `#include` is placed correctly.
- For combos: `key-positions` use 0-indexed position numbers from the geometry diagram above.

### Step 5: Present changes to the user

After editing, show a concise summary of what changed:
- Which layer(s) were modified
- Which position(s) changed and from what → to what
- Any new layers, combos, or macros added

## ZMK behavior quick reference

| Behavior | Syntax | Description |
|----------|--------|-------------|
| Key press | `&kp KEYCODE` | Standard key press |
| Mod-tap | `&mt MOD KEYCODE` | Hold = modifier, tap = key |
| Layer-tap | `&lt LAYER KEYCODE` | Hold = activate layer, tap = key |
| Momentary layer | `&mo LAYER` | Layer active while held |
| Toggle layer | `&tog LAYER` | Toggle layer on/off |
| To layer | `&to LAYER` | Switch to layer |
| Transparent | `&trans` | Fall through to lower layer |
| None | `&none` | Disable key position |
| Bluetooth | `&bt BT_SEL N` / `&bt BT_CLR` | BT profile select / clear |
| Output toggle | `&out OUT_TOG` | Toggle USB / BLE |
| Mouse click | `&mkp LCLK` / `&mkp RCLK` | Mouse left / right click |
| Soft off | `&soft_off` | Enter deep sleep |

Common modifier prefixes: `LC()` `LA()` `LG()` `LS()` (left ctrl/alt/gui/shift), `RC()` etc. for right.

Common keycodes: `A`–`Z`, `N0`–`N9`, `F1`–`F24`, `RETURN`, `ESC`, `BSPC`, `TAB`, `SPACE`, `MINUS`, `EQUAL`, `LBKT`, `RBKT`, `BSLH`, `SEMI`, `SQT`, `GRAVE`, `COMMA`, `DOT`, `FSLH`, `CAPS`, `LEFT`, `RIGHT`, `UP`, `DOWN`, `HOME`, `END`, `PG_UP`, `PG_DN`, `DEL`, `INS`, `PSCRN`, `PAUSE_BREAK`.

## Examples

### Example 1: Swap two keys
**User:** "Swap Q and W on the base layer"
**Action:** In `default_layer`, exchange positions 1 and 2 — `&kp Q` ↔ `&kp W`.

### Example 2: Add home row mods
**User:** "Add home row mods with GACS order"
**Action:** On `default_layer`, replace row 1 inner keys:
- `&kp A` → `&mt LGUI A`, `&kp S` → `&mt LALT S`, `&kp D` → `&mt LCTRL D`, `&kp F` → `&mt LSHFT F`
- `&kp J` → `&mt RSHFT J`, `&kp K` → `&mt RCTRL K`, `&kp L` → `&mt RALT L`, `&kp SEMI` → `&mt RGUI SEMI`

### Example 3: Add a new layer
**User:** "Add a navigation layer with arrows on HJKL"
**Action:**
1. Add `#define NAV 4` after existing defines.
2. Add a new `nav_layer` block with arrows on positions 19–22 (H J K L), `&trans` elsewhere.
3. Wire `&mo NAV` onto an available thumb or layer key.

## Best practices
1. Always read the current keymap before editing — never assume the layout hasn't changed.
2. Preserve the visual ASCII-art comments to keep the file readable.
3. Count bindings after every edit — exactly 42 per layer, no exceptions.
4. When adding combos, keep `timeout-ms` between 25–50 ms for responsive triggering.
5. Suggest the user test on one half first after flashing to verify changes.
