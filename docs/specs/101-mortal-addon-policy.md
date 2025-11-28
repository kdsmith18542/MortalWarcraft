# Mortal Warcraft – UI & Addon Policy

> Mortal is an **addon-friendly, but curated** sandbox server.  
> We want you to customize your UI and improve readability,  
> **without** automating gameplay, breaking the fog-of-war, or trivializing risk.

This document explains:

- What we officially support (Mortal Addon Pack),
- What kinds of addons are allowed, restricted, or bannable,
- How to stay safe if you like tweaking your UI.

---

## Related Specs

- `15-ui-client.md` - MortalUI core addon and UI system
- `25-launcher-mortal-client.md` - Launcher that installs and maintains the addon pack
- `20-aio-ui-basics.md` - AIO UI system that addons integrate with
- `44-accessibility-and-ux-guidelines.md` - UX guidelines that addons should follow

---

## 1. The Mortal Addon Pack (Official Setup)

We ship and support an official addon bundle:

- **MortalUI** (core)
  - Config enforcer (ensures minimum settings for visibility, risk, and readability),
  - Tooltip injector (Mortal skills, weight, hunger, etc.),
  - Bridges to nameplates, map pins, Atlas data.

- **Included UI/QoL addons** (subject to change):
  - Immersion (quest dialogue camera),
  - DynamicCam (optional action-RPG camera),
  - Bagnon or similar inventory manager,
  - Bartender4 (action bar layout),
  - Mapster + HandyNotes (with Mortal map overlays),
  - TidyPlates theme (PvP & sovereignity nameplates),
  - SharedMedia (fonts/textures for the “gritty” look).

The Launcher installs and maintains this pack for you.

> **If it works with the Mortal Addon Pack, it’s supported.**  
> Other addons are “use at your own risk” and must follow the rules below.

---

## 2. Allowed Addons (Green Zone)

These categories are generally fine:

### 2.1 UI & Layout

- Action bar mods (Bartender, Dominos, etc.),
- Unit frame replacements (Shadowed Unit Frames, etc.),
- Bag/inventory/bank mods,
- Chat styling and font packs.

### 2.2 Information & Readability

- Damage meters (Recount/Skada style),
- Minimal buff/debuff trackers,
- Simple weak aura-style reminders (no auto-casts),
- Quest text enhancers or log organizers.

### 2.3 Cosmetic & Immersion

- Camera tweaks (like DynamicCam),
- Map skinning, texture/font replacements,
- Roleplay/emote enhancements.

**Rule of thumb**:  
If it **only changes how information you already have is displayed**, it’s usually fine.

---

## 3. Banned Addons (Red Line)

These are explicitly forbidden. Using them can result in warnings, suspensions, or bans.

### 3.1 Combat Automation

- One-button rotation scripts,
- Auto-interrupt, auto-CC, or auto-heal logic that chooses **who/when/what** to cast for you,
- Anything that:
  - Automatically targets enemies,
  - Automatically cycles through abilities based on combat events.

### 3.2 Radar / ESP / Visibility Hacks

- Addons that claim to:
  - Show hidden units beyond normal API behavior,
  - Reveal stealthed players beyond our visual shimmer + True Sight rules,
  - Provide “player radar” showing exact positions of players in Red Zones in real-time.

### 3.3 Navigation / Fog-of-War Cheats

- Any addon that:
  - Rebuilds full, precise enemy movements in Red Zones,
  - Circumvents our “no party dots in Red Zones” and war fog mechanics.

### 3.4 Hyper-Automated Trading

- Mass-posting / auto-undercutting Auction House bots,
- Scripts that:

  - Scan and react to markets continuously without input,
  - Abuse mail/trade APIs to act as autopilot traders.

---

## 4. Grey Area Addons (Use at Your Own Risk)

Some addons are technically allowed but may be:

- Less useful in Mortal (because encounters and systems are heavily changed),
- Subject to nerfs if they damage gameplay.

Examples:

- Classic boss mods (DBM / BigWigs):
  - These will not be tuned for Mortal encounters,
  - They won’t get you banned, but they may **lie to you**.
- Extreme UI scripting:
  - As long as **you** are deciding who/when/what to cast,
  - And the addon is only surfacing info (not acting), it’s probably fine.

If we see a specific addon consistently breaking the game’s intended difficulty or risk profile, we may:

- Call it out by name,
- Ask players to disable it,
- Or add server-side mitigation.

---

## 5. How We Enforce This

### 5.1 Technical Limits

World of Warcraft’s client API already protects certain things:

- Addons **cannot**:
  - Cast spells without a hardware event (your keypress/click),
  - Move your character,
  - Accept popups like resurrections without input.

We lean on this and on server-side detection:

- Abnormal behavior (perfectly timed interrupts, impossible reaction times),
- Suspicious movement or targeting patterns,
- Repeated behavior that matches botting.

### 5.2 MortalUI & Config Enforcer

MortalUI may:

- Enforce minimum settings for:
  - Nameplate visibility,
  - Enemy cast bars,
  - Combat text essentials,
- Ensure you’re not using extreme zoom hacks or visibility cheats.

We do **not** inspect your local addon list, but we reserve the right to act on behavior that clearly violates the rules.

---

## 6. Player FAQ

### “Can I use my usual retail UI pack?”

Probably yes, if:

- It doesn’t automate combat,
- It doesn’t try to show hidden/stealthed players,
- It doesn’t break our fog-of-war rules.

When in doubt, ask in **Discord → #addons** and we’ll give a ruling.

---

### “Can I write my own addons that use Mortal data?”

Yes – as long as you:

- Only use data we intentionally expose (e.g., via MortalUI comm channels),
- Don’t try to reverse-engineer or scrape hidden information,
- Follow the same rules:
  - No automation,
  - No ESP/radar,
  - No breaking fog-of-war.

---

### “What happens if an addon I use gets banned?”

We will:

1. Announce it on Discord & the website,
2. Update this document and in-game help (`/mortal addons`),
3. Give a grace period where you’re warned before punished (except in extreme cases).

---

## 7. In-Game Commands & Help

We plan to provide:

- `/mortal addons`
  - Prints a short version of this policy and a link to the full page.
- Tutorial NPC lines in the mainland hub:
  - “The Mortal Addon Pack is recommended. Other addons are allowed… but the gods of code frown upon automatons and mind-readers.”

---

## 8. Summary

- Mortal is **addon-friendly**:
  - We like UI customization and better readability.
- Mortal is **not automation-friendly**:
  - Your brain and hands play the game, not an addon.
- If you’re unsure:
  - Use the Mortal Addon Pack,
  - Or ask us in the addon channel before committing.

Play smart, die gloriously, and don’t let a Lua script steal your stories.
