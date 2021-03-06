﻿## StateSpam fix
### VERSION 1.0.1

**Note:** If you are using a TES3MP version downloaded in June 2018 or later, a variation of this script is already included in the core package and an individual installation is not needed.

[Originally written by Malseph](https://github.com/Malseph/Mal-s-Public-Server-Scripts-for-Tes3MP/blob/master/Console%20state%20spam%20prevention.lua) (yeah, THAT guy), edited for public consumption. The script is mostly aimed to fix the state change spam caused by Raven Rock questline (including the annoying Hroldar the Strange bug which occasionally froze the server), as well as other locations that my cause differences in the world states for the players. The script has been tested in that particular area with no issues encountered, hopefully no problems occur in other places, especially with high player count.

## INSTALLING INSTRUCTIONS

1) Copy `stateSpam.lua` to `.../tes3mp/mp-stuff/scripts`.

2) Open `server.lua` with a text editor.

3) Add `stateSpam = require("stateSpam")` at the top, along with all other included scripts.

4) Save `server.lua`, open `.../tes3mp/mp-stuff/cell/base.lua`.

5) Find `function BaseCell:SaveObjectStates(pid)` function. Between `tes3mp.LogAppend(1, "- " .. refIndex .. ", refId: " .. refId .. ", state: " .. tostring(state))` and `tableHelper.insertValueIfMissing(self.data.packets.state, refIndex)` insert
```
if state == false then
    stateSpam.ConsoleSpamPrevention(pid, refIndex, refId, self.description)
end
```

6) Save `base.lua`.

## CHANGELOG:
### 1.0.1:
Minor capitalization changes.

### 1.0:
Initial release of the script.
