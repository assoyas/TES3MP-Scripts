## RavenRock
### VERSION `1.0`

**REQUIRES STATESPAM FIX SCRIPT OR ELSE THINGS WILL GET UGLY**

[StateSpam fix can be found here](https://github.com/SkotisVarvikas/TES3MP-Stuffs/tree/master/StateSpam/)

## ABOUT THE SCRIPT

It is an attempt to provide at least somewhat working version of Raven Rock. For those not familiar with the place and its issues regarding current TES3MP version - the colony's progress is controlled by a few global variables in TES3. Since these variables are currently not saved in TES3MP, after progressing a bit through questline and relogging, you will find that your colony is gone - because the variables have been "reset" to 0. An intuitive approach would then be to set these variables to their proper values based on the progress already done (tracked by journal entries). That is indeed the approach used here - by reading player's savefile and finding the right journal entries, colony's progress can be loaded. This includes the choice you made regarding who you side with early on in the questline as well as the choice you made regarding the servicer found in Raven Rock - smithy or a trading outpost. The StateSpam script is **a must** to ensure that players with different progresses do not cause server lag due to mismatching cell data (and to ensure that Hroldar the Strange is properly removed from your client). The script has been tested by me while relogging after every few quests and the colony seems to be loading properly every time. The script, however, does **NOT** address quest issues caused by relogs - some quests can and will break if you relog in the middle of them - as is the case with many other quests. Again, this script only focuses on properly loading the variables associated with the colony.

The script should be working fine regardless of whether you are using synchronised journal or not - though problems may occur if two players are doing the questline with different progress at the same time. In that case - wait for one player to leave, then relog yourself to ensure that the proper variables are set.

## KNOWN ISSUES

The choice for estate will not save. There is no journal entry to know where YOU decided to build YOUR estate. The location is controlled by `ColonyState ∈ [34;36]`, where each value denotes different location. Since this is the variable we calculate, there is no way to know where the estate was placed originally. Therefore, you will be eventually forced to use same estate location on the whole server (unless server has custom variables being saved that accounts for this - although in that case there is no need to even use this script). It is a small detail that should not affect many players and definitely has no impact on the gameplay.


## INSTALLING INSTRUCTIONS

1) Copy `RavenRock.lua` to `.../tes3mp/mp-stuff/scripts`.

2) Open `server.lua` with a text editor.

3) Add `RavenRock = require("RavenRock")` at the top, along with all other included scripts.

4) Save `server.lua`, open `stateHelper.lua`.

5) Find `function StateHelper:LoadJournal(pid, stateObject)` function. At the end of it, you will find `tes3mp.SendJournalChanges(pid)`. Right above it, put a call to RavenRock script by adding `RavenRock.onLogin(pid, stateObject)`.

6) Save `stateHeler.lua`. If you have some progress in the questline already, start up the game to check if the colony is properly loaded. If you have console access, you should also see some commands being typed out.

## RAVENROCK.xlsx
I have also provided an excel spreadsheet file where I documented my findings regarding specific variable values, what triggers the change and what is the result. If something is not loading find (probably due to my mistake), you can refer to this file to double-check everything is correct.