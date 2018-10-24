﻿## Startup Scripts for 0.6.2
### VERSION 1.1.2

**Note:** If you downloaded TES3MP **before** June 2018, you will need to manually install the StateSpam fix script. [StateSpam fix can be found here.](https://github.com/Skvysh/TES3MP-Scripts/tree/master/StateSpam)
If you downloaded TES3MP after that date, you can ignore this message.

## INSTALLING INSTRUCTIONS

1) Copy `startupData.json` (from a folder above) to `.../tes3mp/mp-stuff/data`.

2) Copy `startupScripts.lua` to `.../tes3mp/mp-stuff/scripts`.

3) Open `server.lua` with a text editor.

4) Add `startupScripts = require("startupScripts")` at the top of the file along with other included scripts.

5) Find `myMod.PushPlayerList(Players)` and below it add `startupScripts.Initialize()`.

6) Find `myMod.OnPlayerCellChange(pid)` and below it add `startupScripts.OnCellChange(pid)`.

7) Save `server.lua` and close it. Open `myMod.lua`.

8) Find `Players[pid].name = playerName` and below it add `startupScripts.RunStartup(pid)`.

9) Save `myMod.lua` and close it. Open `/player/base.lua`.

10) Find `if self.hasAccount ~= false then` and below it add `startupScripts.OnLogin(self.pid)`.

11) Save `base.lua` and close it.

12) (OPTIONAL) Open `startupScripts` and change value of `loadIndividualStartupObjects` variable at the top, depending on your server's settings and preference. Read the comment for more details.

## CHANGELOG:
### 1.1.2:
(Hopefully) prevent some crashes regarding cell change.

### 1.1.1:
Minor fixes.

### 1.1:
Rewrite of how data is handled.

### 1.0:
Initial release of the script.