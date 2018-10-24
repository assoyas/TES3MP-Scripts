# Startup Scripts

The script attempts to load as much of the missing objects, variables and anything else that would otherwise be lost after a relog. The variables and entities are adjusted based on player's journal and is independent of the journal sharing progress. Current fixes addressed by the script are documented below and one can expect the list to expand in the future.

## KNOWN ISSUES

The choice for estate in RavenRock will not save. There is no journal entry to know where YOU decided to build YOUR estate. The location is controlled by `ColonyState ∈ [34;36]`, where each value denotes different location. Since this is the variable we calculate, there is no way to know where the estate was placed originally. This small detail will not have serious effect on the gameplay.

Since the Great House strongholds are all controled by a single variable, it is possible for people to access other houses' strongholds and wreak havoc, screwing up several quests for other players. There is no way to avoid this without constantly resetting cells or using instances.

Startup script, which disables a bunch of entities in 60 cells, will not execute if at least one of them is already loaded. Either delete all the cells and relog or, if for some reason one of the cells **has** to remain between resets, delete it from the `startupCells` variable found at the top. In a similar manner, TES3MP 0.7.0 requires running `BMStartUpScript`, if none of the associated cells are created yet.

If you use a synchronyzed journal, one player progressing in the main Bloodmoon questline will result in all players having werewolf status given to them upon logging in. This is because the only way to know whether a player should be a werewolf or not is through specific quest entries.

## INSTALLING INSTRUCTIONS

See individual version's folder for instructions.

## FEATURES
### Base game:

• Strongholds built through Great House questlines will persist.

• NPCs and objects in 60 cells affected by `Startup` script in TES3 are disabled on server initialization (when a first player connects to a server with no cell data) or enabled/disabled individually for each player when entering each affected cell if the journal is not synchronyzed between players.

• Vampire state and clan depending on which clan you joined (tracked by an entry added to your spellbook).

• All bound items are removed upon loggin in, since they may or may not be stuck in your inventory between sessions.

### Tribunal:

• It should now be possible to properly challenge Karrod and disable his scripted regen, as well as keep track of whether you weakened him beforehand or not.

• `bladefixScript` regarding Trueflame repair should be properly started even after relog.

• A fix for auto-goodbye when talking to NPCs in Mournhold after relogging once the `MournholdAttack` quest was started has been added.

### Bloodmoon:

• RavenRock in Solstheim island, including choice of person you side with and the service, will be loaded properly.

• Progress for individual and cumulative stones in Skaal Test of Loyalty quest will be properly loaded, allowing to relog in between individual stone quests.

• Werewolf state, depending on how far you are in the questline, as well as some variables for related quests and the claw damage rewarded after first Hircine's quest.

• `BMStartUpScript` will be executed if no associated cells are created yet, to disable some of the NPCs and objects, as intended.

## ADDING MORE FIXES
You are welcome to modify the `startupData.json` file to properly set more variables, disable/enable more objects and so on. Use the initial data as a guide for formatting the json. You can use this to include the loading of variables for mods, if you server uses them and the mods use them. Additionally, you are welcome to make pull requests for any base-game or official expansion related variables, objects and such - this will help everyone using the script until an official implementation of variable/script progess saving/loading is made.

## startupScripts.xlsx
The excel spreadsheet file contains my findings of how the entities, variables and other things are modified by journal entries and which indexes do so.

## CHANGELOG FOR THE DATA FILE:
### 1.1:
Added information about bm_stones, tr_blade and tr_champion quests.

### 1.0:
Initial definition of data file.