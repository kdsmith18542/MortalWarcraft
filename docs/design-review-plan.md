# Mortal Warcraft Design Review & Audit Plan

## 1. Purpose
Provide a practical, repeatable process for auditing every spec in the repo without generating redundant "review" files. This doc is the single source of truth for how design reviews are scheduled, executed, and tracked.

## 2. Scope & Ordering
We will sweep the specs in four passes, roughly aligning with directory numbering:

1. **Core Fundamentals (00–06)** – vision, progression, combat, risk, economy, PvE.
2. **Systems & World (07–39)** – mounts, guilds, social, navigation, telemetry, security.
3. **Content & Pillars (40–79)** – factions, itemization, PvE/PvP modes, quests, seasons.
4. **Support & Ops (80+)** – chat, admin tools, automation, QoL, legacy services.

## 3. Tracking Artifact
- Maintain a single `design_review_tracker.csv` (or shared sheet) with columns:
  - `file`
  - `owner`
  - `last_reviewed`
  - `status` (`ok`, `needs_update`, `rewrite`)
  - `notes`
  - `follow-ups / linked issues`
- The tracker lives alongside this doc in `/docs/` and is updated every time a file is reviewed.

## 4. Review Workflow
1. **Assign Pillar Owner** – design lead or system owner takes primary responsibility for the current pillar. Secondary reviewer (engineer/writer) sanity-checks feasibility.
2. **Read & Log** – reviewer reads the spec end-to-end, logging findings directly in the tracker (no extra mini-docs).
3. **Batch Changes** – group fixes by pillar to avoid half-updated terminology. Open PRs referencing tracker rows.
4. **Verification Pass** – after finishing a pillar, run repo-wide grep/search (e.g., `rg "Season XP"`, `rg "Derived Level"`) to ensure terminology and rules are consistent.
5. **Summary Drop** – once per pillar (or every ~2 weeks) add a short note to the tracker or project board describing what changed and what remains.

## 5. Cadence & Goals
- Target **5–7 files per week** depending on size.
- Never start the next pillar until the current one’s action items are either completed or captured as Jira/issues with owners.
- Prefer realistic timelines; it’s acceptable for a complex file to span multiple weeks if noted in the tracker.

## 6. Deliverables
- `design_review_tracker.csv` – canonical status log.
- Pull requests / issues linked from tracker entries.
- Optional `review_summary_<YYYY-MM-DD>.md` when a pillar wraps, highlighting key decisions and remaining debts.

## 7. Next Actions
1. Seed the tracker with all spec files + provisional owners.
2. Continue/complete Pillar 1 (00–06) review using the recent terminology fixes as the baseline.
3. Schedule the first summary once Pillar 1 is done, then roll forward to Pillar 2.

Keep this file updated if the process evolves; avoid scattering new “review guidelines” elsewhere.
