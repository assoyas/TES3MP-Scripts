## AntiCurses
### VERSION 1.1

This script automatically removes any Dremora Lords, Ancestral Ghosts or Dwemer Ghosts created by the cursed items when a player picks one up. Server owners can choose to not remove entities spawned by certain items.

## INSTALLING INSTRUCTIONS

1) Copy `antiCurses.lua` to `.../tes3mp/mp-stuff/scripts`.

2) Open `server.lua` with a text editor.

3) Add `antiCurses = require("antiCurses")` at the top, along with all other included scripts.

4) Find `cell.lua` file located in `../tes3mp/mp-stuff/scripts/cell/` and open it with a text editor.

5) Find `if wasPlacedHere == false then` line of code and where this block ends with an `end`, replace it with
 ```
 else
	antiCurses.CheckItem(pid, refId)
end
```

The full block should then look something like this:
```
if wasPlacedHere == false then
	table.insert(self.data.packets.delete, refIndex)
	self:InitializeObjectData(refIndex, refId)
else
	antiCurses.CheckItem(pid, refId)
end
```

6) Save `cell.lua` file and you should be good to go - test out different cursed items ([list found here](http://en.uesp.net/wiki/Morrowind:Cursed_Items)) to make sure nothing spawns when you pick it up from the ground.

## SETTINGS

The script contains a minor list of settings:
```
local disableDremoras = true
local disableDremorasSpecial = true
local disableGhosts = true
local disableDwemerGhosts = true
```

Each variable defines whether or not to remove a specific type of enemy from a cursed item list. Since cursed gold does not naturally appear in the game, one may wish to use it as a special currency on their server. Thus, it will be possible to "disarm" those coins, while keeping other cursed items working as intended, if you wish.

## CHANGELOG:
### 1.1:
Rewritten the script to be bit more efficient, more consistent capitalization.

### 1.0:
Initial release of the script.