# Project Canvas: Mortal Warcraft Overhaul
### Version 30.3 — Hybrid Technical Design Document  
### File: 44-accessibility-and-ux-guidelines.md  
### Section: Accessibility, Readability & UX Guidelines (MortalUI & Client)

---

## Related Specs

- `15-ui-client.md` - MortalUI implementation that follows these guidelines
- `20-aio-ui-basics.md` - AIO UI patterns that follow these guidelines
- `18-lfg-warfront-ui.md` - LFG and Warfront UI that follows these guidelines
- `38-social-and-onboarding-systems.md` - Social systems UI that follows these guidelines

---

## 1. Purpose

Define **accessibility and UX standards** for Mortal Warcraft so that:

- Combat, risk, and information are **readable** even with the gritty sandbox aesthetic.
- Players with **different needs** (colorblindness, motion sensitivity, cognitive load) can customize their experience.
- MortalUI and bundled addons follow **consistent patterns**, reducing confusion and UI bloat.

These guidelines are **production-level requirements**, not optional polish.

---

## 2. Visual Design Principles

### 2.1 Gritty but Readable

- The “gritty sandbox” look (darker fonts, parchment, rough textures) must **not**:
  - Reduce text contrast below acceptable thresholds,
  - Obscure important icons or timers.

**Rules:**

- Minimum text contrast:
  - Body text and key UI labels must maintain sufficient contrast against background.
- No critical information (HP, resources, timers, debuffs, map pins) may be:
  - Purely decorative,
  - Blended into noisy backgrounds.

### 2.2 Font & Text Guidelines

- Base font sizes:
  - Body: at least 12–14 px equivalent.
  - Tooltips: at least 11–12 px.
  - Headings: 16–18 px or larger.

- MortalUI must expose a **font size scale**:
  - Small / Normal / Large.
  - At minimum, allow a “Large” setting that increases all key UI labels & tooltips ~20–30%.

- Avoid:
  - Overuse of script fonts,
  - Excessive all-caps for long text.

### 2.3 Color Usage

- Do **not** rely on color alone to convey:
  - Buff vs debuff,
  - Risk tier (Green/Yellow/Red),
  - Item quality.

- Always pair color with:
  - Icons, patterns, labels, or text.

Example:

- Risk Zones on map:
  - Green/Yellow/Red overlay **plus**:
    - Zone labels (“Safe”, “Skulled”, “Full Loot”),
    - Different border patterns (solid/dashed/hazard stripes).

---

## 3. Accessibility Options (MortalUI)

MortalUI must provide an **Accessibility Settings Panel** with at least:

### 3.1 Colorblind & High-Contrast Modes

- Presets:
  - Normal,
  - High-Contrast,
  - Colorblind-friendly (e.g., deuteranopia-friendly palette).

Behaviors:

- Adjust nameplate colors (friendly/enemy/neutral),
- Adjust health bar and resource colors,
- Adjust risk overlays on map (using patterns + colors).

### 3.2 Motion & Camera

- Options to:
  - Disable or reduce:
    - DynamicCam extra motion,
    - Camera shake,
    - Sudden FOV zooms.

Settings examples:

- “Camera Motion Intensity”: Off / Low / Normal.
- “Disable Camera Shake”: checkbox.
- “Static Combat Zoom”: checkbox (prevents aggressive zoom/focus changes during combat).

### 3.3 UI Density & Clutter

- Presets:
  - Minimal,
  - Standard,
  - Extended.

**Minimal**:

- Hides non-critical panels and cosmetic widgets in combat:
  - Chat can fade,
  - Only essential bars, nameplates, combat text.

**Standard**:

- Default layout.

**Extended**:

- Shows additional combat info, debuff lists, and advanced metrics for experienced players.

---

## 4. Combat Readability

### 4.1 Brace & Guard Counter Cues

Since Brace & Guard Counter are **core skill-systems**, their cues must be clear:

- Audio:
  - Distinct sound when Brace activates successfully.
  - Distinct sound when a Guard Counter window opens.

- Visual:
  - Brief highlight around:
    - Player’s character,
    - Or on-screen indicator (“Opportunity!”) for Guard Counter.
  - Duration should match the actual effective window (e.g., ~0.75–2.0 seconds).

- Accessibility:
  - In MortalUI settings:
    - Allow toggling:
      - Extra outline flash,
      - Extra icon near resource bars.

### 4.2 Enemy Telegraphs

- Telegraphs for big hits, cone attacks, and AoEs must be:

  - **Visually distinct** from environment clutter:
    - Clear shapes (circles/cones),
    - Strong outline,
    - Minimal reliance on transparency-only effects.

- For colorblind/high-contrast modes:
  - Adjust telegraph colors,
  - Optionally allow thicker outlines or pattern overlays.

### 4.3 Nameplates & Critical Info

- TidyPlates drivers must ensure:
  - Player / enemy / NPC types are distinguishable via:
    - Color **and** icon/text.
  - Important flags:
    - Criminal, bounty target, guild war target, party member:
      - Add icons or text tags (“Criminal”, skull icon, etc.).
- Important debuffs (e.g., heavy bleed, mortal wound) must:
  - Use prioritized display (not buried in a long list),
  - Use recognizable icons and optional text labels.

---

## 5. UI Layout & Consistency

### 5.1 MortalUI Layout Standards

- Consistent placement of:

  - Health/resource bars,
  - Action bars,
  - Brace/Guard Counter feedback,
  - Buff/debuff clusters.

- Avoid requiring players to:

  - Track critical information at the extreme corners of the screen **while** focusing on the center during combat.

### 5.2 Panel & Window Behavior

- All major panels:
  - Codex,
  - Expedition Finder,
  - LFG Board,
  - Guild Directory,
  - Atlas-like map:
    - Must be:
      - Moveable,
      - Resizable (where practical),
      - Remember last position.
- Panels must:
  - Respect “Minimal UI during combat” settings:
    - Hide or go semi-transparent during intense fights if enabled.

### 5.3 Tooltip & Info Overload

- Tooltips (Item, Skill, Rune, etc.):
  - Must prioritize:
    - Name,
    - Type,
    - Core stats,
    - Special effects,
    - Requirements (skill, blessings).
  - Secondary flavor text and lore:
    - Should be visually separated (smaller font, different color or margins).

- Provide an option:
  - “Simplified Tooltips”
    - Hides advanced numeric breakdowns,
    - Shows plain-language summary first.

---

## 6. Audio & UX Feedback

### 6.1 Audio Cues

- Provide distinct sounds for:

  - Successful Brace/Guard Counter,
  - Full loot death,
  - Blessed save,
  - Task completion,
  - Trade completion (AH, buy orders, contracts),
  - Stronghold attack alerts.

- Allow players to adjust categories:
  - “Combat Cues”
  - “System Cues”
  - “Ambient/Environment”

### 6.2 Non-Audio Redundancy

- Critical events must have **visual components** as well as audio:

  - Full loot death:
    - Specific screen vignette,
    - Short text summary (“You have dropped your gear in a Red Zone.”).
  - Blessing save:
    - Glow or particle on preserved items,
    - Small popup notification.

---

## 7. Text & Localization Readiness

### 7.1 Text Handling

- MortalUI and Mortal Codex entries must:
  - Avoid hard-coded string concatenation that complicates translation.
  - Use string keys where possible.

- Layout must anticipate:
  - Longer strings in other languages,
  - No text overflow that hides important information.

### 7.2 Font & Charset

- Ensure fonts used:
  - Support extended Latin characters,
  - Have fallbacks for additional languages if needed later.

---

## 8. Onboarding & Cognitive Load

### 8.1 Progressive Disclosure

- Tutorial flow (Shipwreck / Mainland Hub / Mentor) must:

  - Start with a **minimal UI**:
    - Only core bars, simple hotbar.
  - Gradually introduce:
    - Task Boards,
    - Markets, banks,
    - Red/Yellow/Green systems,
    - Stronghold/Warfront/advanced PvP.

- New panels should:
  - Open with brief inline hints (e.g., small overlay pointing to key sections),
  - Offer “Don’t show this again” options.

### 8.2 Codex Integration

- When a player encounters a new system (e.g., first Red Zone entry, first Task Board), Codex entries should:

  - Be short and scannable (bullets, short paragraphs),
  - Use icons that match in-game UI elements.

---

## 9. Performance Considerations

### 9.1 Addon & UI Performance

- MortalUI and the bundled addons (Immersion, DynamicCam, Bagnon, Bartender4, Mapster, HandyNotes, etc.) must be configured to:

  - Avoid excessive script-heavy polling in combat.
  - Offer “Performance Mode”:
    - Disables non-essential visual flourishes (animated portraits, cosmetic overlays) for lower-end machines.

### 9.2 Graceful Degradation

- On lower framerates or older hardware:

  - Combat cues (Brace, telegraphs) remain functional:
    - Use clear, low-overhead visuals,
    - Avoid heavy particle spam for crucial feedback.

---

## 10. Implementation Checklist

To comply with this spec:

1. **Accessibility Panel**
   - Build MortalUI Accessibility settings with:
     - Colorblind/contrast presets,
     - Camera/motion controls,
     - UI density presets,
     - Simplified tooltips toggle.

2. **Combat FX**
   - Implement strong, configurable cues for:
     - Brace/Guard Counter windows,
     - Major telegraphs,
     - Full loot death & Blessed saves.

3. **Nameplates & Risk**
   - Ensure nameplate drivers:
     - Support icons/tags for Criminal, Bounty, War targets.
     - Use patterns + labels, not color-only.

4. **Text & Fonts**
   - Apply minimum font sizes and contrast checks.
   - Implement font-size scaling options.

5. **Layouts**
   - Make key panels:
     - Moveable,
     - Resizable,
     - Remembered per character/profile.

6. **Performance**
   - Provide a “Performance Mode” preset for MortalUI:
     - Reduces heavy effects,
     - Keeps essential feedback.

---

## 11. Status

With these guidelines, Mortal Warcraft’s UI and UX:

- Maintain the gritty sandbox identity,
- Stay legible and usable for a wide range of players,
- Provide clear combat and risk communication,
- Are configurable enough to support long sessions and diverse player needs.
