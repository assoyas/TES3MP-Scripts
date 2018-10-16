## DisableTraining
### VERSION 1.0

**Note:** Requires [CharClassHelper script](https://github.com/Skvysh/TES3MP-Scripts/tree/master/CharClassHelper) in order to function properly.

The script attempts to, through server-side, disable trainer use by detecting and isolating trainer usage whenever possible, rolling back the skill level and progress and refuding when applicable.

The script is not perfect - there are likely cases of missed detections, false alarms and wrong skills being rolled back. However, in most cases the issues should only arise on the first use of the trainer during that visit in the cell - consecutive trainer uses will be isolated better due to saving of some crucial data.

Since there is no clear `OnTrainerUse` event (or none that I am aware of), one needs to isolate the trainer use by comparing gold in player's inventory before and after skill change, then make some decisions based on available information. In most cases - through proper gameplay - people should encounter little-to-no issues. However, it is possible to abuse the system, although briefly, to bypass the trainer use limit. It is also possible to gain potentially infinite gold at a slow rate, but then again - there are dozens more ways to do it in Morrowind. The script might also perform poorly when used in combination with mods that modify how skills or training works - in such cases, you are best off modifying the base game data to exclude the trainers, since you are already enforcing a plugin use. The script's main aim is to provide a solution to trainer "abuse" in vanilla Morrowind.

A rough idea of the thought process for the decision is shown in figure below:
![Decision making flowchart](https://imgur.com/dAz0Jea.png)

## INSTALLING INSTRUCTIONS

1) Put `disableTraining.lua` file in `...\tes3mp\mp-stuff\scripts\` folder.

2) Open `server.lua` and add `disableTraining = require("disableTraining")` at the top along with other `require` lines.

3) Save `server.lua`, open `myMod.lua`.

4) Find `local message = Methods.GetChatName(pid) .. " joined the server.\n"` and above it add `disableTraining.OnLogin(pid)`.

5) Find `Players[pid]:SaveSkills()` and above it add `disableTraining.CheckTrainerUse(pid)`.

6) Find `Players[pid]:SaveBounty()` and above it add `disableTraining.OnPlayerBounty(pid)`.

7) Find `Players[pid]:SaveCell()` and above it add `disableTraining.CheckCellChange(pid)`.

8) Find `Players[pid]:SaveInventory()` and above it add `disableTraining.CheckGold(pid)`.

9) Save `myMod.lua` and close it.

10) (OPTIONAL) Open `disableTraining.lua` and edit the variables at the top to your liking.

## SETTINGS

You can and should modify some of the variables found at the top of the script. `maxTrainerLevel` variable indicates the maximum level players can achieve in a skill through training - trying to train a skill above that value will (usually) undo the training. `firstNotification`, `trainRefundNotification` and `trainNoRefundNotification` are the text that is displayed to the player when they train beyond the limit and are either informed about it through a notification box they need to click on, or a short message at the bottom of the screen, depending on whether they are being refunded or not. You can change these notifications to fit the server's language or to simply display different text when conditions are met.

## KNOWN ISSUES

The script will not always detect and isolate the correct skill that's being trained - in few cases where there are multiple variables present and a decision needs to be made, the script will lean towards the most likely case and pick it, even if it is not always correct. However, for the most part, the script should function properly.

## CHANGELOG:
### 1.0:
Initial release of the script.