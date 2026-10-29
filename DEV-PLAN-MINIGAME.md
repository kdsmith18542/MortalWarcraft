# Minigame pivot — gap-checked dev plan (`asmortalwarcraft` branch)

Every claim below was checked against files on disk 2026-10-29. Nothing here is assumed.

## 1. Verified baseline (all paths exist)

| Piece | Location | State |
|---|---|---|
| Custom server module | `modules/mod-mortal/` (26 .h/.cpp: MortalAttributes/Level, MortalCombatSkills, Crafting, Territory, Siege, Bounty, Contracts, TaskBoard, Caravan, RegionalBank, ZoneRisk, DynamicEcosystem, Notoriety, PvP/Admin/Log hooks) + `conf/mod_mortal.conf.dist` + `sql/db_{characters,world}/mod_mortal_base.sql` | Real code, 252K |
| AC prepared-statement edits | inside `azerothcore/` submodule (`CharacterDatabase.h/.cpp` per `INTEGRATION.md`) | **At risk: submodule empty locally, edits unpublished** (gap G1) |
| Launcher (Tauri+React+Rust) | `launcher/src/` (`manifest.rs`, `patcher.rs`, `spell_patcher.rs`, `hitbox_patcher.rs`, `integrity.rs`, `download_mortal_client.rs`, pages: Dashboard/Settings/Logs/About) | Manifest shape = `{version, files[{path,checksum,size}], patches[{name,version,url,checksum,required}]}` via `/api/manifest`. **No chunked parts** (gap G4) |
| In-game UI | `addons/MortalUI/` (Core, Config, Hunger/Encumbrance displays, LFG, MapPins, Nameplates, Overlays, PvP panel, RiskZoneBanner, StatsOverlay, Tooltips) + spec `docs/specs/15-ui-client.md` (+18, +20) | Real addon |
| DB | `sql/` 235 migration files + `verify_and_run_migrations.sh` | Check ordering before first run (gap G5) |
| Design corpus | `docs/specs/` 00–27 + 100–108, `docs/guides/`, `docs/systems/` (skills/crafting/factions/pvp), `docs/INDEX.md` | Live. Report-spam era already archived; `cleanup-old-docs.sh` removed (no-op) |
| Minigame client (fork) | `../azeroth-survivors-re` → `kdsmith18542/azeroth-survivors-re`; mode in `crates/benilla-app/src/survivors/` (14 modules: abilities, auto, cards, data, enemies, fill, grade, hero, hud, menu, minimap, mobility, units) | Offline, no server (`mod.rs`: "There is no server") |
| Engine (fork) | `../benilla` → `kdsmith18542/benilla`; sync model in RE `docs/UPSTREAM.md` (merge upstream, `#[cfg]`-gated carries) | Adopt same model for your carries |

## 2. Minigame custom-changes familiarity (honest scope)

I have read file-level, not line-level: `survivors/mod.rs` (plugin wiring, `Phase`/`Run`/`Selection` resources, `CaptureMode` turns FrameXML off), `data.rs` head (`ClassDef`/weapons/sheath, `Kind` 17 ability shapes: Bolt/Strike/Melee/Nova/Cone/Ground(+Self)/Chain/Dot/Aura/Orbit/Shield/Immune/Thorns/Heal/Totem + `Effect` Slow/Root/Stun/Fear/Weaken/Drain/Execute; "Spell ids name `Spell.dbc` rows only for icon/name/visual — every number here is the mode's"), `menu.rs` head (pick screen rebuilt from 1.12 glue widgets/art, 8 races × zones, `MenuAction` Race/Sex/Class/Map/Randomize/Enter), `hud.rs` 2227 lines + `cards.rs` 534 lines (quality-colored cards). Content tuning lives in `data.rs` tables — that is your first customization surface, no protocol needed. Deeper claims (wave clock tuning, spawner budgets) need a full read of `enemies.rs`/`auto.rs`, scheduled below.

## 3. UI/login review → what MortalWarcraft steals

Minigame login: none — `menu.rs` replaces char-select with race/gender/class tower + zone list + Enter World, all from stock glue art (`glue::art`, `glue::widgets`, `glue::backdrop`), laid on the 768-unit canvas via `UiScale`. HUD: Bevy UI + custom materials (`SweepUiMaterial`, `FillMaterial`), quality colors = `RAID_CLASS_COLORS`, every card states exact deltas ("Damage 20 » 26").

| Take for MortalUI addon (Lua) | Take for MW launcher (Tauri) |
|---|---|
| Card pattern: color-by-quality + exact-delta text → TaskBoard/contract and loot-upgrade rows | Pick-flow pattern: race/class/zone tower → minigame mode select screen |
| `menu.rs` glue reuse (stock art, new layout) → RiskZoneBanner/LFG panels reskinned, not rebuilt | Offline-first: survivors mode proves the sim runs with zero server — launcher "Play offline" = same binary, `WOW_SURVIVORS`-style flag |
| `hud.rs` offer/pending-pick state machines → mirror for vendor/craft preview states | Show exact deltas everywhere (aethus cards do; MW manifest should too: version + notes per file) |

Do not port Bevy UI code into Lua — port the *patterns* (unit canvas, quality colors, exact deltas, offer/pending states).

## 4. Gaps (checked, ordered by blast radius)

- **G1 — AC submodule edits unpublished.** `INTEGRATION.md` edits live inside `azerothcore/` (empty here). Any `submodule update --init` wipes them. Fix: push AC fork per INTEGRATION.md note, pin `.gitmodules` to it. Verify: `git -C azerothcore status` non-empty after init.
- **G2 — `realm2-era-progression` vs branch layout.** Remote has it (c33181a) + `realm1*`, `master`, copilot branches. Our branch tracks `mortal-overhaul` only. Rule: never merge realm branches into each other; shared changes via explicit cherry-pick. Verify: `git ls-remote --heads origin`.
- **G3 — 1.12 vs 3.3.5 asset split.** Minigame = 1.12.1 data (build 5875, Interface 11200); MW server = 3.3.5a. Shared art must be converted or duplicated; DBC edits do not transfer. Decide per asset, document in `dbc_patches/README.md`. Verify: build numbers in `Data/` vs `wow/Data` whiteman client.
- **G4 — updater has no chunking.** MW `manifest.rs` = whole files + sha; aethus = 20 MB parts (`UPDATER.md` in workspace root). Minigame payloads (255 MB world pack class) need parts or resume will die on Wine/Proton. Add `parts[]` to manifest (server + `download.rs`). Verify: download 250 MB file over throttled link, kill mid-way, resume.
- **G5 — 235 SQL files, ordering unverified.** Filenames suggest phases (00–108) but gaps/duplicates (`106_fishing_system*.sql` ×2, `23`/`23a` merc-healer). Dry-run migrator on empty DB before first real init. Verify: `verify_and_run_migrations.sh` against scratch MySQL.
- **G6 — shared benilla sound bug.** Crash logs in workspace (`benilla-config/Diagnostics/`) show 512-voice leak + underruns killing long sessions; minigame shares the engine. Fix upstream-first in your benilla fork (sound allocator module), sync into RE via UPSTREAM procedure. Verify: 10-min Wine soak, voice count flat.
- **G7 — launcher manifest URL vs frozen reference.** `UPDATER.md` + `updater/frozen-*.json` exist at workspace root; wire MW launcher envs (`MW_UPDATE_URL`, `MW_DATA_URL`, `MW_UPDATE_AUTO`) to match before first player build. Verify: point at local file, version-match = no-op.

## 5. Phased plan (each phase ends with its check)

- **P0 freeze & hygiene (done):** reference frozen, README fixed, no-op script removed. Check: this file committed + pushed.
- **P1 publish safety:** push AC submodule edits to AC fork, pin `.gitmodules`; dry-run SQL migrator; unshallow `src/*` before first custom commit. Checks: G1/G5 verifications green.
- **P2 minigame slice:** full read of `enemies.rs`/`auto.rs`/`data.rs`; retune content tables only (no engine fork yet); launcher "Play offline" + manifest v0.1.0 with parts (G4). Checks: offline run stable 30 min; resume-killed download completes.
- **P3 UI legitimacy:** MortalUI reskin pass using card/quality/delta patterns; launcher mode-select in pick-flow style. Check: side-by-side screenshots, same information, fewer clicks.
- **P4 net (only if co-op ships):** AoI tiers + snapshot budgets per `NETWORK-HOSTING-PLAN.md`; server-authoritative hits. Check: 4-player Wine soak, underrun counter zero, per-client bytes logged.
- **P5 bigger versions:** new `patch-MW*.MPQ` + version bumps through your manifests; realm branches untouched.

## 6. What I need from you to start P1/P2

1. AC fork URL (or permission to create `kdsmith18542/azerothcore-wotlk`) for G1.
2. Which minigame content to tune first (classes? zones? wave clock?).
3. Scratch MySQL available for the G5 dry run, or should P1 skip to engine work?
