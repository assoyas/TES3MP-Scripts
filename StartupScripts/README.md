## Startup Scripts
### VERSION 1.1

**Note:** If you downloaded TES3MP **before** June 2018, you will need to manually install the StateSpam fix script. [StateSpam fix can be found here.](https://github.com/Skvysh/TES3MP-Scripts/tree/master/StateSpam)
If you downloaded TES3MP after that date, you can ignore this message.

The script attempts to load as much of the missing objects, variables and anything else that would otherwise be lost after a relog. The StateSpam script is required to not cause conflicts when certain objects appear in different states for players currently in a cell. The variables and entities are adjusted based on player's journal and is independent of the journal sharing progress. Current fixes addressed by the script are documented below and one can expect the list to expand in the future.


## KNOWN ISSUES

The choice for estate in RavenRock will not save. There is no journal entry to know where YOU decided to build YOUR estate. The location is controlled by `ColonyState ∈ [34;36]`, where each value denotes different location. Since this is the variable we calculate, there is no way to know where the estate was placed originally. This small detail will not have serious effect on the gameplay.

Since the Great House strongholds are all controled by a single variable, it is possible for people to access other houses' strongholds and wreak havoc, screwing up several quests for other players. There is no way to avoid this without constantly resetting cells or using instances.

Startup script, which disables a bunch of entities in 60 cells, will not execute if at least one of them is already loaded. Either delete all the cells and relog or, if for some reason one of the cells **has** to remain between resets, delete it from the `startupCells` variable found at the top.

If you use a synchronyzed journal, one player progressing in the main Bloodmoon questline will result in all players having werewolf status given to them upon logging in. This is because the only way to know whether a player should be a werewolf or not is through specific quest entries.


## INSTALLING INSTRUCTIONS

1) Copy `startupData.json` to `.../tes3mp/mp-stuff/data`.

2) Copy `startupScripts.lua` to `.../tes3mp/mp-stuff/scripts`.

3) Open `server.lua` with a text editor.

4) Add `startupScripts = require("startupScripts")` at the top of the file along with other included scripts.

5) Find `myMod.PushPlayerList(Players)` and below it add `startupScripts.Initialize()`.

6) Find `myMod.OnPlayerCellChange(pid)` and below it add `startupScripts.OnCellChange(pid)`.

7) Save `server.lua` and close it. Open `myMod.lua`.

8) Find `Players[pid].name = playerName` and below it add `startupScripts.RunStartup(pid)`.

9) Save `myMod.lua` and close it. Open `/player/base.lua`.

10) Find `if self.hasAccount ~= false then` and below it add `startupScripts.OnLogin(self.pid)`.

11) Save `base.lua` and close it.

12) (OPTIONAL) Open `startupScripts` and change value of `loadIndividualStartupObjects` variable at the top, depending on your server's settings and preference. Read the comment for more details.

## FEATURES

• RavenRock in Solstheim island, including choice of person you side with and the service, will be loaded properly.

• Strongholds built through Great House questlines will persist.

• A fix for auto-goodbye when talking to NPCs in Mournhold after relogging once the `MournholdAttack` quest was started has been added.

• NPCs and objects in 60 cells affected by `Startup` script in TES3 are disabled on server initialization (when a first player connects to a server with no cell data) or enabled/disabled individually for each player when entering each affected cell if the journal is not synchronyzed between players.

• Werewolf state, depending on how far you are in the questline, as well as some variables for related quests and the claw damage rewarded after first Hircine's quest.

• Vampire state and clan depending on which clan you joined (tracked by an entry added to your spellbook).

• All bound items are removed upon loggin in, since they are stuck in your inventory after relogging.

## startupScripts.xlsx
The excel spreadsheet file contains my findings of how the entities, variables and other things are modified by journal entries and which indexes do so.


## CHANGELOG:
### Script version:
#### 1.1:
Rewrite of how data is handled.

#### 1.0:
Initial release of the script.

### Data file version:
#### 1.0:
Initial definition of data file.