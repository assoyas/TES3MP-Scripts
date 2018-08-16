## Startup Scripts
### VERSION `1.0`

**Note:** If you downloaded TES3MP **before** June 2018, you will need to manually install the StateSpam fix script. [StateSpam fix can be found here.](https://github.com/Skvysh/TES3MP-Scripts/tree/master/StateSpam)

If you downloaded TES3MP after that date, you can ignore this message.

## ABOUT THE SCRIPT

The script attempts to load as much of the missing objects, variables and anything else that would otherwise be lost after a relog. The StateSpam script is required to not cause conflicts when certain objects appear in different states for players currently in a cell. The variables and entities are adjusted based on player's journal and is independent of the journal sharing progress. Current fixes addressed by the script are documented below and one can expect the list to expand in the future.


## KNOWN ISSUES

The choice for estate in RavenRock will not save. There is no journal entry to know where YOU decided to build YOUR estate. The location is controlled by `ColonyState ? [34;36]`, where each value denotes different location. Since this is the variable we calculate, there is no way to know where the estate was placed originally. Therefore, you will be eventually forced to use same estate location on the whole server (unless server has custom variables being saved that accounts for this - although in that case there is no need to even use this script). It is a small detail that should not affect many players and definitely has no impact on the gameplay.

Since the Great House strongholds are all controled by a single variable, it is possible for people to access other houses' strongholds and wreak havoc, screwing up several quests for other players. There is no way to avoid this without constantly resetting cells or using instances.

Startup script, which disables a bunch of entities in 60 cells, will not execute if at least one of them is already loaded. Either delete all the cells and relog or, if for some reason one of the cells **has** to remain, delete it from the `startupCells` variable found at the top.


## INSTALLING INSTRUCTIONS

1) Copy `startupScripts.lua` to `.../tes3mp/mp-stuff/scripts`.

2) Open `server.lua` with a text editor.

3) Add `startupScripts = require("startupScripts")` at the top, along with all other included scripts.

4) Save `server.lua`

5) Open `myMod.lua` with a text editor.

6) Find `Methods.OnPlayerConnect = function(pid, playerName)` function. Below it, add `startupScripts.onServerInit(pid)`.

7) Save `myMod.lua`, open `stateHelper.lua`.

8) Find `function StateHelper:LoadJournal(pid, stateObject)` function. At the end of it, you will find `tes3mp.SendJournalChanges(pid)`. Right above it, put a call to this script by adding `startupScripts.onLogin(pid, stateObject)`.

9) Save `stateHeler.lua`. If you have progress in some of the quests addressed by the script as well as console access, you can login to see certain console commands being executed.

## LIST OF FIXES

• RavenRock in Solstheim island, including choice of person you side with, service and few less significant statuses, will be loaded properly.

• Strongholds built through Great House questlines will persist.

• A fix for auto-goodbye when talking to NPCs in Mournhold after relogging once the `MournholdAttack` quest has been done.

• NPCs and several objects disabled by `Startup` script in TES3, which is executed at the very beginning of the game, will be disabled if the server is "fresh" - none of the 60 cells affected by the TES3 script have files created for them yet.

## startupScripts.xlsx
The excel spreadsheet file contains my findings of how the entities, variables and other things are modified by journal entries and which indexes do so.
