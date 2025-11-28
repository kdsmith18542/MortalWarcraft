# Mortal Warcraft Overhaul Module
# AzerothCore Module CMakeLists.txt

cmake_minimum_required(VERSION 3.16)
project(mortal_overhaul)

# Set module name
set(MODULE_NAME "mortal_overhaul")

# Add source files
set(SOURCES
    src/MortalOverhaul.cpp
    src/MortalLevel.cpp
    src/MortalCombat.cpp
    src/MortalCreature.cpp
    src/MortalCombatSkills.cpp
    src/MortalDurabilityDecay.cpp
    src/MortalEncumbrance.cpp
    src/MortalGatheringSkills.cpp
    src/MortalCraftingSkills.cpp
    src/MortalCraftingQuality.cpp
    src/MortalCodex.cpp
    src/MortalTaskRewards.cpp
    src/MortalCaravanMovement.cpp
    src/MortalSkillTrainer.cpp
    src/MortalGuildStorage.cpp
    src/MortalFragmentDrops.cpp
    src/MortalItemBond.cpp
    src/MortalMountRepair.cpp
    src/MortalBuyOrders.cpp
    src/MortalHotZones.cpp
    src/MortalBlessedItems.cpp
    src/MortalNavigation.cpp
    src/MortalFishing.cpp
    src/MortalFirstAid.cpp
    src/MortalRestoration.cpp
    src/MortalRuneAugments.cpp
    src/MortalFactions.cpp
    src/MortalInstanceTier.cpp
    src/MortalSeasons.cpp
    src/MortalEndlessContracts.cpp
    src/MortalBuildPresets.cpp
    src/MortalPublicGrouping.cpp
    src/WorldScripts_MortalPeriodic.cpp
    src/MortalSecurity.cpp
    src/MortalGMTools.cpp
    src/MortalTelemetry.cpp
    src/MortalEldensEve.cpp
    src/ScriptMgr.cpp
)

# Add header directories
set(AC_ROOT ${CMAKE_SOURCE_DIR}/azerothcore)
include_directories(
    ${CMAKE_SOURCE_DIR}/src
    ${AC_ROOT}/src
    ${AC_ROOT}/src/common
    ${AC_ROOT}/src/common/Collision
    ${AC_ROOT}/src/common/Collision/Maps
    ${AC_ROOT}/src/common/Collision/Models
    ${AC_ROOT}/src/common/Collision/Management
    ${AC_ROOT}/src/common/Utilities
    ${AC_ROOT}/src/common/Dynamic
    ${AC_ROOT}/src/common/Dynamic/LinkedReference
    ${AC_ROOT}/src/common/Debugging
    ${AC_ROOT}/src/common/Navigation
    ${AC_ROOT}/src/server
    ${AC_ROOT}/src/server/shared
    ${AC_ROOT}/src/server/shared/DBC
    ${AC_ROOT}/src/server/shared/DataStores
    ${AC_ROOT}/src/server/shared/Packets
    ${AC_ROOT}/src/server/shared/UpdateFields
    ${AC_ROOT}/src/server/database
    ${AC_ROOT}/src/server/database/Database
    ${AC_ROOT}/src/server/game
    ${AC_ROOT}/src/server/game/Entities
    ${AC_ROOT}/src/server/game/Entities/Player
    ${AC_ROOT}/src/server/game/Entities/Unit
    ${AC_ROOT}/src/server/game/Entities/Unit/Stats
    ${AC_ROOT}/src/server/game/Entities/Creature
    ${AC_ROOT}/src/server/game/Entities/Pet
    ${AC_ROOT}/src/server/game/Entities/Item
    ${AC_ROOT}/src/server/game/Entities/GameObject
    ${AC_ROOT}/src/server/game/Entities/Object
    ${AC_ROOT}/src/server/game/Entities/Object/Updates
    ${AC_ROOT}/src/server/game/Battlegrounds
    ${AC_ROOT}/src/server/game/Guilds
    ${AC_ROOT}/src/server/game/Loot
    ${AC_ROOT}/src/server/game/Conditions
    ${AC_ROOT}/src/server/game/Combat
    ${AC_ROOT}/src/server/game/Movement
    ${AC_ROOT}/src/server/game/Movement/MovementGenerators
    ${AC_ROOT}/src/server/game/Movement/Spline
    ${AC_ROOT}/src/server/game/Server
    ${AC_ROOT}/src/server/game/Server/Protocol
    ${AC_ROOT}/src/server/game/Maps
    ${AC_ROOT}/src/server/game/Grids
    ${AC_ROOT}/src/server/game/Grids/Cells
    ${AC_ROOT}/src/server/game/Spells
    ${AC_ROOT}/src/server/game/Scripting
    ${AC_ROOT}/src/server/game/Scripting/ScriptDefines
    ${AC_ROOT}/src/server/game/World
    ${AC_ROOT}/src/server/game/AI
    ${AC_ROOT}/src/server/game/AI/CoreAI
    ${AC_ROOT}/src/server/game/AI/ScriptedAI
    ${AC_ROOT}/deps
    ${AC_ROOT}/deps/g3dlite
    ${AC_ROOT}/deps/g3dlite/include
    ${AC_ROOT}/deps/recastnavigation
    ${AC_ROOT}/deps/recastnavigation/Detour/Include
    ${AC_ROOT}/deps/fmt/include
)

# Create module library
add_library(${MODULE_NAME} STATIC ${SOURCES})

# Link against AzerothCore built libs
target_link_directories(${MODULE_NAME} PRIVATE ${CMAKE_SOURCE_DIR}/azerothcore/build/lib)
target_link_libraries(${MODULE_NAME}
    worldserver
    shared
)

# Set output directory
set_target_properties(${MODULE_NAME} PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
)
