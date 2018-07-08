## Criminals
### Version: 1.0

## ABOUT THE SCRIPT

![Example of the script in action](https://i.imgur.com/9wvbkro.png)

![Another example of the script in action](https://i.imgur.com/RKjTDpf.png)

The script enhances the bounty system by adding global messages when people reach certain tresholds of bounty (500, 1000 and 5000) or when they manage to clear their name. It also adds the ability to award the bounty to players who kill the criminals. Finally, it is possible to append prefixes to the chat messages sent by criminals, to let others know they indeed broke the law.



## INSTALLING INSTRUCTIONS

1) Put `Criminals.lua` file in `...\tes3mp\mp-stuff\scripts\` folder.

2) Open `server.lua` and add `Criminals = require("Criminals")` at the top along with other `require` lines.

3) (OPTIONAL) Find `return false -- default behavior, chat messages should not` and replace it with:

```
local prefix = Criminals.isCriminal(pid)
tes3mp.SendMessage(pid, prefix .. playerName .. " (" .. pid .. "): " .. message .. "\n", true)
return false -- default behavior, chat messages should not
```

4) Save `server.lua`, open `myMod.lua`.

5) Find `Players[pid]:Message("You have successfully logged in.\n")` and below it add `Criminals.onLogin(pid)`.

6) Find `Players[pid]:SaveBounty()` and add `Criminals.updateBounty(pid)` below it.

7) Save `myMod.lua` and open `\player\base.lua`.

8) Find `deathReason = "was killed by " .. deathReason` and below it add `Criminals.processBountyReward(self.pid, deathReason)`.

9) Save `base.lua` and start the server. Try committing a crime to gain a bounty of 500 or more and see if a message is displayed in the chat.

## SETTINGS
displayGlobalWanted = true -- whether or not to display the global messages in chat when a player's wanted status changes
displayGlobalClearedBounty = true -- whether or not to display a global message when a player clears their bounty
displayGlobalBountyClaim = true -- whether or not to display a global message when another player claims a bounty
bountyItem = "gold_001" -- item used as bounty, in case you use a custom currency
### Changes you can make in the script
|Variable|Description|
|:----|:-----|
|displayGlobalWanted|Whether or not to display a message when a player becomes wanted.|
|displayGlobalClearedBounty|Whether or not to display a message when a player clears their name.|
|displayGlobalBountyClaim|Whether or not to display a message when a player claims a bounty by killing another player.|
|bountyItem|Item used as bounty (normally gold).|

## KNOWN ISSUES

The bounty will not be awarded to the killer if the wanted player is killed by an effect instead (spell, enchant, etc). This is a limitation by TES3MP and hopefully it will be solved in the future.

The chat prefixes, although completely optional, can interfere with other scripts that add prefixes. Consult `#scripting_help` channel on TES3MP discord server if you happen to use another script which adds prefixes for a solution.