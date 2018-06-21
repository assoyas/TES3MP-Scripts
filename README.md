# Scripts for TES3MP
All scripts should be working fine with TES3MP version `0.6.2 hotfix` (and mostly likely all the way up to 0.7.0).

## AntiCurses (v1.0)
Similar to what DisableAssassins script does, it removes any creatures spawned by the cursed items. Owners are welcome to use setting variables to change which types of cursed items are allowed to spawn their related creatures and which are removed upon picking up the item.

## Boots of Actually Blinding Speed (BOABS) (v1.0)
A harmless script that ensures the boots actually blind player, no matter what magicka resist they have (although it is still possible to bypass this if you have access to console).

## CustomQuests (v0.9.3)
A somewhat experimental version. The script allows you to create custom quests that require players to either hunt specific creatures, travel to a specific cell or acquire specific items. The quests are easy to implement through few lines in a text file - see README.txt and customQuestsMain.txt for explanations of values and examples. The script is written poorly, with no comments, poor optimization and possible game-breaking bugs. See README.txt for known issues. USE THIS AT YOUR OWN RISK.

## RPRolls (v1.1)
Easy-to-setup script that adds a chat command to roll a random number between <skill/attirbute> and 100. The result is displayed locally. The script was made with roleplaying in mind, where people could roll for checks when resolving conflicts.
  
## RavenRock (v1.0)
### REQUIRES STATESPAM FIX!
An attempt to provide a temporary fix for Raven Rock in Bloodmoon expansion. Using fancy algorithms of simply reading your journal and finding the right journal entries, the colony's progress is properly set through the global values in TES3. After logging in, your client forcibly sends console commands (even if you don't have access to the console!) to set these values to what your colony should look like. As such, you should retain your colony progress after relogging. Note that this is not meant to be a full fix for the questline - many quests can and will break if you relog in the middle of them and the colony progress might behave weird, especially with desynced journal. This has been tested by me only, so there's a good chance things might break at some point any way.

## StateSpam (v1.0)
[Thanks to Malseph](https://github.com/Malseph/Mal-s-Public-Server-Scripts-for-Tes3MP/blob/master/Console%20state%20spam%20prevention.lua), StateSpam is mostly meant to help tackle the issues with Raven Rock, especially when two players with different states of the colony are have the cell loaded.

## VampiresAndWerewolves (v1.1)
Currently only involving the first part, the script allows players to bypass the lack of vampirism-associated scripts in current tes3mp version and become vampires of the clan of their choosing. Several customizable features include level requirement to perform transformation, cure the disease as well as customizable cost item and amount and whether or not those choices are allowed in the first place.

## WerewolfRobe (v1.0)
A small script that allows players to equip werewolf robe - the body of a werewolf - without having to transform into one. Some customization is included in the script to limit who can use it and if there is a cost.
