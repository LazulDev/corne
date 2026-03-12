---
name: keymap-editor
description: >
  Review, visualize, modify, and design ZMK keymaps for this Corne TP split
  keyboard. Use when the user wants to change key bindings, swap keys, add or
  remove layers, add macros/combos, or review the current layout. Also use when
  the user wants help discovering or designing the ideal keymap for their workflow
  — even if they say "I don't know where to start", "recommend a layout", or
  "what keymap suits me". Triggers on: remap key, swap keys, change layer,
  keymap, binding, modifier, home row mods, combo, macro, recommend layout,
  design keymap, suggest keys, optimize layout, best keymap for programming,
  ergonomic layout, help me configure my keyboard.
allowed-tools: Bash Read Write Edit Glob Grep
metadata:
  tags: zmk, keymap, keyboard, corne, split-keyboard, firmware, discovery, ergonomics
  version: "2.0"
---

# Keymap Editor

## When to use this skill
- User wants to change, swap, or reassign any key binding
- User wants to add, remove, or reorder layers
- User wants to review or visualize the current keymap
- User asks about what a specific key position does
- User wants to add combos, macros, tap-dance, or hold-tap behaviors
- User wants to apply a layout philosophy (home row mods, Miryoku-style, etc.)
- User doesn't know what keymap to use and wants personalized recommendations
- User asks for help designing, optimizing, or choosing a layout for their workflow

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

### Step 1: Determine the mode — direct edit or discovery

If the user has a **specific change** in mind (swap keys, add combo, etc.), go to Step 3.

If the user is **exploring** what keymap suits them — they say things like "help me set up my keymap", "I don't know where to start", "recommend a layout", or "what's the best keymap for me" — begin the **Discovery flow** (Step 2).

### Step 2: Discovery flow — design the ideal keymap

Guide the user through a conversational questionnaire to understand their needs. Ask questions in **short rounds** (2–3 questions at a time, never a wall of 10 questions). Wait for the user's answers before continuing to the next round.

**Round 1 — Profile & context**
- What do you do? (developer, writer, designer, sysadmin, gamer, mixed…)
- What OS do you use? (Windows, macOS, Linux — affects modifier placement: Ctrl vs Cmd)
- Is this your first split/ortho keyboard, or do you have experience with custom layouts?

**Round 2 — Language & typing**
- What language(s) do you type in? (affects need for accented characters, dead keys, international layers)
- If you code: what languages/tools? (Vim/Neovim users need Escape accessible; heavy terminal users need Ctrl combos; bracket-heavy languages need easy `{}[]()` access)
- Do you use keyboard shortcuts heavily? Which ones? (Ctrl+C/V/Z, IDE shortcuts, window management…)

**Round 3 — Ergonomics & pain points**
- Do you have any discomfort or RSI concerns? (influences home row mods, thumb usage, pinky load reduction)
- Are there keys you find hard to reach or rarely use on your current layout?
- How do you feel about hold-tap keys? (some people dislike the timing; others love them)

**Round 4 — Trackpad & mouse integration**
- How do you use the trackpad? (scrolling, clicking, drag — this keyboard has a trackpad on the right half)
- Do you want mouse buttons on thumb keys, or prefer the current layout?

**After gathering answers, synthesize:**

1. Summarize the user's profile in 2–3 sentences.
2. Recommend a keymap approach. Common patterns to suggest based on answers:
   - **Developer (Vim)** → Nav layer on HJKL, Escape combo (J+K), home row mods, symbol layer optimized for brackets.
   - **Developer (IDE-heavy)** → Dedicated shortcut layer, easy Ctrl/Shift combos via home row mods, F-key row accessible.
   - **Writer / multilingual** → International/accent layer with dead keys or Unicode macros, minimal hold-tap to avoid interference with fast prose typing.
   - **Designer / creative** → Mouse-centric thumb cluster, shortcut layer for tool-specific hotkeys (Photoshop, Figma), minimal layers.
   - **Sysadmin / terminal** → Strong Ctrl placement, navigation layer, function keys accessible.
   - **Gamer** → Dedicated gaming layer (no hold-tap to avoid input lag), WASD untouched, numbers row easily accessible.
   - **RSI / ergonomics priority** → Home row mods (GACS or CAGS), reduced pinky load (move Shift/Ctrl off pinkies), combos for common shortcuts.
3. Present the recommendation as a concrete layer plan: which layers, what goes where, which behaviors.
4. **Always ask for confirmation before making any changes.** Show the proposed keymap changes and wait for approval.

### Step 3: Read the current keymap

The keymap lives at `config/corne_tp.keymap`. Always read it before making changes.

Current layer definitions (indices are `#define`d at the top of the file):

| Index | Name    | Purpose |
|-------|---------|---------|
| 0     | DEFAULT | QWERTY base layer |
| 1     | NUMBER  | Numbers and symbols |
| 2     | FN      | Function / numpad |
| 3     | HOTKEY  | BT profiles, output toggle, soft off |

### Step 4: Understand the user's request

Clarify ambiguous requests before editing. Common patterns:

- **"swap X and Y"** — exchange two key positions within a layer.
- **"move X to Y"** — place binding X at position Y; ask what replaces the old position (usually `&trans` or `&none`).
- **"add home row mods"** — apply hold-tap (`&mt`) modifiers to home row (A S D F / J K L ;) on the DEFAULT layer.
- **"add a layer for …"** — create a new layer block, add a `#define`, wire an `&mo`/`&tog`/`&to` on an existing layer.
- **"add a combo"** — add a `combos` node outside the `keymap` node, inside the root `/` block.
- **"add a macro"** — add a `macros` node with a `zmk,behavior-macro` compatible binding.

### Step 5: Edit the keymap

Rules when editing `config/corne_tp.keymap`:

1. **Preserve ASCII-art alignment comments** — each row has a visual separator comment. Keep the column width consistent.
2. **Each layer must have exactly 42 bindings** — 36 matrix + 6 thumb. A missing or extra binding breaks the build.
3. **Use `&trans` for transparent (fall-through)**, `&none` for disabled keys.
4. **Do not reorder `#include` directives** — `pointing.h` must come after the `#define ZMK_POINTING_DEFAULT_SCRL_VAL` line.
5. **Layer indices must be contiguous** starting at 0. If adding a layer, use the next available index.
6. **Thumb row bindings** (positions 36–41) are on the last row inside the layer block, after the third row comment.

### Step 6: Validate after editing

After modifying the keymap, verify:

- Count exactly 42 bindings per layer (6+6 per row × 3 rows + 3+3 thumbs).
- All referenced layer indices exist.
- All behavior references are valid ZMK behaviors (`&kp`, `&mt`, `&mo`, `&lt`, `&tog`, `&to`, `&trans`, `&none`, `&bt`, `&out`, `&mkp`, `&soft_off`, `&kp`).
- Any new `#define` or `#include` is placed correctly.
- For combos: `key-positions` use 0-indexed position numbers from the geometry diagram above.

### Step 7: Present changes to the user

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

### Example 4: Discovery — developer who uses Vim on Linux
**User:** "I just got this keyboard, help me set up the keymap"
**Agent round 1:** Asks profile, OS, experience.
**User answers:** "I'm a backend dev, Linux, first split keyboard."
**Agent round 2:** Asks languages, tools, shortcuts.
**User answers:** "Go and Python, Neovim full-time, lots of terminal, tmux."
**Agent round 3:** Asks ergonomics, pain points, hold-tap opinion.
**User answers:** "Some pinky fatigue from Ctrl, open to try hold-tap."
**Agent synthesis:**
- Profile: Linux backend developer, Neovim + tmux heavy, first split keyboard.
- Recommendation: Home row mods (GACS) to move Ctrl off pinky. Nav layer with HJKL arrows. Escape combo (J+K). Symbol layer optimized for `{}[]()` for Go/Python. Keep a clean base QWERTY for the transition period.
- Presents concrete layer plan and asks for confirmation before editing.

### Example 5: Discovery — bilingual writer on macOS
**User:** "Recommend a layout for me"
**Agent round 1:** Asks profile, OS, experience.
**User answers:** "Writer, macOS, used a Planck before."
**Agent round 2:** Asks languages, tools, shortcuts.
**User answers:** "I write in Spanish and English, use Scrivener and Obsidian."
**Agent round 3:** Asks ergonomics, pain points.
**User answers:** "I want easy access to accents (á é í ó ú ñ ü) without interrupting flow."
**Agent synthesis:**
- Profile: Bilingual writer on macOS, experienced with ortho boards.
- Recommendation: Keep QWERTY base clean (no home row mods — prose typing dislikes hold-tap delays). Add an accents layer accessible via thumb with dead-key macros or direct Unicode for á/é/í/ó/ú/ñ/ü. Swap Ctrl/Cmd positions for macOS. Minimize layers — writer needs speed, not complexity.
- Presents proposal and waits for approval.

## Best practices
1. Always read the current keymap before editing — never assume the layout hasn't changed.
2. Preserve the visual ASCII-art comments to keep the file readable.
3. Count bindings after every edit — exactly 42 per layer, no exceptions.
4. When adding combos, keep `timeout-ms` between 25–50 ms for responsive triggering.
5. Suggest the user test on one half first after flashing to verify changes.
