## Cliff Racer Sounds

## ABOUT THE SCRIPT

The script checks if a player is in wilderness (exterior cell in the Vvardenfell) and generates a random number (default: between 1 and 60). If specific number is rolled (by default: once every minute, on average), it plays one of the three cliff racer sounds found in the MW's data folders.

Warning! This script will probably make your players paranoid or drive them insane.

## INSTALLING INSTRUCTIONS

1) Put `CliffRacerSounds.lua` file in `...\tes3mp\mp-stuff\scripts\` folder.

2) Open `server.lua` and add `CRS = require("CliffRacerSounds")` at the top along with other `require` lines.

3) Find `function OnPlayerCellChange(pid)` function and inside of it add `CRS.onCellChange(pid)`.

4) Save `server.lua`, start your server and wait.

## SETTINGS

You can modify the script to play different sounds - open the script and see the top variables for path, edit as you wish. You can get the name of the sound by opening data files in construction set and checking the "Sounds" tab. If you add more sounds to the list, the `generateSound` function needs to be updated for a higher range of sounds.

You can also modify the chance for the sound to trigger in `generateRandomNumber` function - see the comments in the script for more details.

## KNOWN ISSUES

Cliff racer sounds tend to piss people off.