## VampiresAndWerewolves
### VERSION 1.2

**NOTE:** Requires [StartupScripts](https://github.com/Skvysh/TES3MP-Scripts/tree/master/StartupScripts) to work properly, since that script loads vampire state and clan on login.
 
The script aims to enhance the vampire and werewolf features in TES3MP. Current features include on-demand infection and cure of vampirism as well as a chance to infect other players with the disease.
Since time progression in TES3MP is complicated, the disease does not function very well on its own - therefore, the script forces the infection to happen and skips the 3-day waiting period.

While detecting player's vampire status in TES3MP is fairly easily (by checking the spellbook), werewolf state is much more complicated - the only way to know if player is a werewolf through normal means is to check for Bloodmoon questline progress - an option that is not very feasable in a synchronised journal scenario. Therefore, anything werewolf related from this script is on hold till I figure out a way to properly track the werewolf state.

## INSTALLATION:

1) Copy `vampiresAndWerewolves.lua` to `.../tes3mp/mp-stuff/scripts`.

2) Open `server.lua` with a text editor.

3) Add `VaW = require("vampiresAndWerewolves")` at the top, along with all other included scripts.

4) (OPTIONAL) add 
```
/vampirism - Join a vampire clan of your choosing\
/vampirism cure - Attempt to cure vampirism\
```
somewhere at  [local helptext = ... ] lines of code, to include the associated commands in `/help` function.

5) Add
```
elseif cmd[1] == "vampirism" and cmd[2] == nil then
	VaW.Initialize(pid)
elseif cmd[1] == "vampirism" and cmd[2] == "cure" then
	VaW.InitializeCure(pid)
```
where all the chat commands go (can possibly do it after the `elseif (cmd[1] == "greentext" or cmd[1] == "gt") and cmd[2] ~= nil then` command block (to allow people to use these commands).

6) Find `function OnGuiAction(pid, idGui, data)` and under it add `if VaW.OnGUIAction(pid, idGui, data) then return end`.

7) Save `server.lua` file

8) Open `base.lua` file, found in `.../tes3mp/mp-stuff/scripts/player/` folder.

9) Find `deathReason = "was killed by " .. deathReason` and above it add `VaW.OnPlayerDeath(self.pid, deathReason)`

10) Save `base.lua` file as well.

## SETTINGS:
There are a bunch of settings that you can change. They are found at the top of the script and the comments contain a description of what they are in charge of.

## COMMANDS:

### Commands added by this script
|Command|Description|
|:----|:-----|
|/vampirism|Checks if level requirements are met, then displays a text box regarding clan choice and costs (if applicable), allowing the player to chose the vampire clan they wish to join. If the player can afford, they are transformed instantly.|
|/vampirism cure|Checks if player is a vampire and is allowed to cure themselves of vampirism. If so, a choicebox pops up asking to pay the price (if applicable) and curing the player if they proceed.|

## CHANGELOG:
### 1.2:
Cut out some redundant functions, fixed an issue with curing being completely free regardless of values used, added an option to be able to infect other players by killing them.

### 1.1:
Added `/vampirism cure`, associated settings as well as ability to allow/disallow obtaining and curing the diseases on the server via the commands.

### 1.0:
• Initial release of the script, allowing players to transform into vampires and properly load the associated variables on login.
