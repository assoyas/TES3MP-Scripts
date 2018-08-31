## Boots of Actually Blinding Speed (BOABS)
### VERSION 1.1

*For when you reeeeally hate people who use those boots*

This script simply calls a console command `FadeOut` when a player has Boots of Blinding Speed (BOBS) equipped. If the player has BOBS unequipped, the console instead calls `FadeIn` to bring the screen back. Those that have access to console might be able to "bypass" this script by calling `FadeIn` themselves, but BOABS script is called every time a player changes their equipment, so they would have to re-do it after every equipment change.
Note that the game itself uses `FadeIn` and `FadeOut` in a number of cases, so if the equipment changes while that is happening, unexpected and weird (although not particularly harmful) events may occur.

## INSTALLING INSTRUCTIONS

1) Copy `BOABS.lua` to `.../tes3mp/mp-stuff/scripts`.

2) Open `server.lua` with a text editor.

3) Add `BOABS = require("BOABS")` at the top, along with all other included scripts.

4) In `server.lua`, find `function OnPlayerEquipment(pid)` and inside this block add `BOABS.FindBoots(pid)`.

5) Save `server.lua` and start the server. Try equipping Boots of Blinding Speed with a high amount of Resist Magicka effecting you. Your screen should fade to black in a second.

## CHANGELOG:
### 1.1:
Rewritten the script to be bit more efficient, as well as use console command only once, use more consistent capitalization in the script.

### 1.0:
Initial release of the script.