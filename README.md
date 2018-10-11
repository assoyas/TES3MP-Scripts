# Custom server-side scripts for [TES3MP](https://tes3mp.com/)
All scripts should be working fine with TES3MP version `0.6.2 hotfix` (and mostly likely all the way up to 0.7.0).

The scripts found here either add some new features to the gameplay or provide temporary fixes to some issues encountered in the current version of TES3MP. They are easy to install and setup and occasionally provide settings to tune to better suit your needs.
The scripts are in no way official and should not be treated as such - crashes may occur and the logs may lack enough description of the problem. In such case, I will try to assist You to the best of my capabilities, though I highly recommend making backups.

# Short overview of the scripts

## AntiCurses (v1.1)
Similar to what DisableAssassins script does, it removes any creatures spawned by the cursed items. Owners are welcome to use setting variables to change which types of cursed items are allowed to spawn their related creatures and which are removed upon picking up the item.

## Boots of Actually Blinding Speed (BOABS) (v1.1)
A harmless script that ensures the boots actually blind player, no matter what magicka resist they have (although it is still possible to bypass this if you have access to console).

## CharClassHelper (v1.0)
A small library to help handle both pre-defined and custom classes, most importantly - get the percentage of skill's progress.

## Cliff Racer Sounds (v1.1)
A not-so-harmless script that plays a random cliff racer sound at random intervals while a player is in the wilderness.

## Criminals (v1.1)
A script that enhances the bounty system in TES3MP by adding messages to the chat when players are wanted, prefixes to criminals' messages and award bounty to those that kill the criminals.

## CustomQuests (v0.9.3)
A somewhat experimental version. The script allows you to create custom quests that require players to either hunt specific creatures, travel to a specific cell or acquire specific items. The quests are easy to implement through few lines in a text file - see README.txt and customQuestsMain.txt for explanations of values and examples. The script is written poorly, with no comments, poor optimization and possible game-breaking bugs. See README.txt for known issues. USE THIS AT YOUR OWN RISK.

## DisableTraining (v1.0)
A server-side mostly-functional solution to trainer usage in Morrowind multiplayer. The script attempts to detect and isolate trainer usage and undo it if players train beyond the specified limit. The script is not 100% reliable - check the `readme` in the folder for more detailed information.

## PlayTime (v1.0.1)
Script that tracks the play time of players playing on the server and saves it (in seconds) to players' data files. Adds two chat commands to either display individual play time or list the play times of all logged in players.

## RPRolls (v1.2.1)
Easy-to-setup script that adds a chat command to roll a random number between <skill/attirbute> and 100. The result is displayed locally. The script was made with roleplaying in mind, where people could roll for checks when resolving conflicts.

## RecursiveCliffRacers (v1.0.1)
A TES3MP-implementation of the Recursive Cliff Racers mod, which spawns more cliff racers when one dies.
  
## StartupScripts (v1.1)
Previously known as "RavenRock", script provides a means to load several variables affecting the states of objects, such as Raven Rock colony in Solstheim, Great House strongholds and disabling various entities that should be disabled at the start of the game. The script may be expanded in the future to include even more fixes for various quests (especially the ones in Tribunal and Bloodmoon expansion) by reading journal entries and changing appropariate TES3 variables through console.

## StateSpam (v1.0.1)
[Thanks to Malseph](https://github.com/Malseph/Mal-s-Public-Server-Scripts-for-Tes3MP/blob/master/Console%20state%20spam%20prevention.lua), StateSpam is mostly meant to help tackle the issues with Raven Rock, especially when two players with different states of the colony are have the cell loaded. However, this script is included with TES3MP releases from June 2018 and onwards, so it is not necessary to use if you have a newer version of the package.

## VampiresAndWerewolves (v1.2)
Currently only involving the first part, the script allows players to bypass the lack of vampirism-associated scripts in current tes3mp version and become vampires of the clan of their choosing. Several customizable features include level requirement to perform transformation, cure the disease as well as customizable cost item and amount and whether or not those choices are allowed in the first place.

## WerewolfRobe (v1.1)
A small script that allows players to equip werewolf robe - the body of a werewolf - without having to transform into one. Some customization is included in the script to limit who can use it and if there is a cost.

# Note:
On 2018-09-01 I put up updates to nearly every script, which, in most cases, added more consistent naming pattern for functions, files and such. Due to renaming of files and functions, updating just the script itself might crash the server - refer to the new instructions for each file to ensure that the proper names for functions are used. I apologize for my lack of attention when first making the scripts and I hope this issue will not repeat in the future.
