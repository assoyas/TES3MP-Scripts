## Startup Scripts for 0.7.0
### VERSION 1.0

## INSTALLING INSTRUCTIONS

1) Copy `startupData.json` (from a folder above) to `.../tes3mp/mp-stuff/data`.

2) Copy `startupScripts.lua` to `.../tes3mp/mp-stuff/scripts`.

3) Open `serverCore.lua` with a text editor.

4) Add `startupScripts = require("startupScripts")` at the top of the file along with other included scripts.

5) Find `logicHandler.PushPlayerList(Players)` and below it add `startupScripts.Initialize()`.

6) Find `function OnPlayerCellChange(pid)` and below it add `startupScripts.OnCellChange(pid)`.

7) Save `serverCore.lua` and close it. Open `eventHandler.lua`.

8) Find `Players[pid].name = playerName` and below it add `startupScripts.RunStartup(pid)`.

9) Save `eventHandler.lua` and close it. Open `/player/base.lua`.

10) Find `if self.hasAccount ~= false then` and below it add `startupScripts.OnLogin(self.pid)`.

11) Save `base.lua` and close it.

12) (OPTIONAL) Open `startupScripts` and change value of `loadIndividualStartupObjects` variable at the top, depending on your server's settings and preference. Read the comment for more details

## CHANGELOG:
### 1.0:
Initial release of the script for TES3MP 0.7.0.