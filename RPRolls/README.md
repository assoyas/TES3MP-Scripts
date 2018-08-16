## RPRolls
## CURRENT VERSION: 1.2

This scripts adds a `/roll <skill/attirbute>` command (by default available to everyone) which chooses a random value between player's specified skill/attribute and 100. The result is displayed in local chat for everyone to see the outcome. The script was made with RP server in mind, hence the name.

## Setup instructions
1) Place this file in `\mp-stuff\scripts\`
2) Add `RPRolls = require("RPRolls")` at the top of `server.lua`
3) Add `math.randomseed(os.time())` somewhere at the top of `server.lua` (for example: after `timeCounter = config.timeServerInitTime`)
4) Add `elseif cmd[1] == "roll" then RPRolls.doRoll(pid, playerName, cmd[2])` after last `elseif cmd[1] == ...` statement in `server.lua`
5) Add `/roll <skill/attribute> - perform <skill/attribute> - 100 roll"` at the end of `local helptext = ...`

## CHANGELOG:
### 1.2:
Rewrote the script partially, so it uses loops instead of dozens of `if` checks.

### 1.1:
Added rolls for skills as well.

### 1.0:
Initial release of the script.