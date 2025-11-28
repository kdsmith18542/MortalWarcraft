# Issue #23851 - Aberrations Quest Egg Death Animation Fix

## Problem
During the Storm Peaks quests "Aberrations" (12925) and "The Aberrations Must Die" (13425), using a Vial of Frost Oil (item 41612) on a Plagued Proto-Drake Egg (gameobject 191840) freezes it and gives quest credit, but the egg does not despawn afterwards. This allows players to complete the quest by freezing the same eggs over and over.

## Expected Behavior
Using Vial of Frost Oil on a Plagued Proto-Drake Egg should:
1. Play the egg's death animation
2. Despawn the egg shortly after it's frozen
3. Force players to freeze different eggs to continue the quest

## Root Cause
The spell 55647 (Frost Oil) activates the gameobject but doesn't handle the death animation or despawn. The gameobject remains in the world after being activated.

## Solution
Created a spell script `spell_q12925_q13425_frost_oil_egg` for spell 55647 that:
1. Checks if the target is a Plagued Proto-Drake Egg (191840)
2. Verifies the player is on quest 12925 or 13425
3. Calls `UseDoorOrButton` with destroy flag to play death animation
4. Sends despawn animation via `SendObjectDeSpawnAnim`
5. Despawns the egg after 2 seconds using `DespawnOrUnsummon(2s)`

## Files Changed
- `realm2/azerothcore/src/server/scripts/Spells/spell_quest.cpp` - Added spell script class and registration

## Testing
1. Accept quest 12925 (Aberrations) or 13425 (The Aberrations Must Die)
2. Obtain Vial of Frost Oil from Valkyrion Aspirants
3. Use the item on a Plagued Proto-Drake Egg
4. Verify the egg plays its death animation
5. Verify the egg despawns after ~2 seconds
6. Verify quest credit is given
7. Verify the same egg cannot be used again

## Related Issues
- Original issue: https://github.com/azerothcore/azerothcore-wotlk/issues/23851
- Linked from ChromieCraft: https://github.com/chromiecraft/chromiecraft/issues/8537

