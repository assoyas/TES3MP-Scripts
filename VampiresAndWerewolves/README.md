## CURRENT VERSION: 1.1
Written for `TES3MP 0.6.2 hotfixed`, should work with other versions as well

# ABOUT THE SCRIPT:
The script provides a temporary workaround for vampirism in TES3MP. Currently, contracted diseases are not saved unless they are obtained through scripts, meaning that even if you contract the disease, it will not be saved. Furthermore, the script attached to the disease does not trigger after 3 in-game days. Finally, even though the vampire attributes are saved, the related variables that define you as a vampire are not saved, so restarting the game will cause everyone to forget you are a proper vampire.

The solution is then to a) given players an option to automatically obtain the disease and trigger the attached script, fully transforming into a vampire of the clan of their chosing and b) to ensure that the variables associated with vampirism are properly loaded every time the player logs in.

As the name implies, it should also do something related to werewolves - indeed, the idea is to (eventually) implement a way to become a werewolf through server-side scripts (including the disease), thus skipping the need to play through Bloodmoon questline. This, assuming there are no issues, will be added later on.

## INSTALLATION:
To properly install this script, start by placing `VampiresAndWerewolves.lua` to the scripts folder found at `.../tes3mp/mp-stuff/scripts/`

In the same folder, open `server.lua` and make the following changes:

1. add `VaW = require("VampiresAndWerewolves")` somewhere at the top, along with other `require` lines (to make sure the script is loaded).

2. (OPTIONAL) add 
```
/vampirism - Join a vampire clan of your choosing\
/vampirism cure - Attempt to cure vampirism\
```
somewhere at  [local helptext = ... ] lines of code, to include the associated commands in `/help` function.

3. add
```
elseif cmd[1] == "vampirism" and cmd[2] == nil then
	VaW.Initialize(pid)
elseif cmd[1] == "vampirism" and cmd[2] == "cure" then
	VaW.InitializeCure(pid)
```
where all the chat commands go (can possibly do it after the `elseif (cmd[1] == "greentext" or cmd[1] == "gt") and cmd[2] ~= nil then` command block (to allow people to use these commands).

4. Find `function OnGuiAction(pid, idGui, data)` and under it add `if VaW.OnGUIAction(pid, idGui, data) then return end`.

5. Save `server.lua` file

You will also need to make a small change to `base.lua` file, found in `.../tes3mp/mp-stuff/scripts/player/` folder.

Find `function BasePlayer:FinishLogin()` function and at the end of it add `VaW.OnLogin(self.pid)`, in order to properly load vampirism after login.

Save `base.lua` file as well and you should be good to go.

## SETTINGS:
There are some other changes you can make at the top of the script file. The defaults are:
```
local vampirismCostItemId = "gold_001"          -- ID of the item
local vampirismCostCureItemId = ""              -- ID of the cure item
local vampirismCostCount = "100000"             -- amount of the item
local vampirismCostCureCount = ""               -- amount of the cure item
local vampirismCostText = "This process will be instant and will cost you 100.000 gold."        -- text to display regarding the item and count, cannot be made dynamic with current tools in a simple way
local vampirismCostCureText = "This process will be instant. The cure will cost you nothing"    -- same as before, but for cure
local vampirismLevelReq = 0                     -- optional level requirement; keep it at 0 if no requirement is desired (unless you have players being level 0 for some reason)
local allowCure = true                          -- allow curing?
local allowVampirism = true                     -- allow infection?
local displayGlobalTransformationMessage = true -- whether or not to display the transformation message to the whole server
```
## COMMANDS:

### Commands added by this script
|Command|Description|
|:----|:-----|
|/vampirism|Checks if level requirements are met, then displays a text box regarding clan choice and costs (if applicable), allowing the player to chose the vampire clan they wish to join. If the player can afford, they are transformed instantly.|
|/vampirism cure|Checks if player is a vampire and is allowed to cure themselves of vampirism. If so, a choicebox pops up asking to pay the price (if applicable) and curing the player if they proceed.|

## CHANGELOG:

### 1.1:
Added `/vampirism cure`, associated settings as well as ability to allow/disallow obtaining and curing the diseases on the server via the commands.

### 1.0:
• Initial release of the script, allowing players to transform into vampires and properly load the associated variables on login.
