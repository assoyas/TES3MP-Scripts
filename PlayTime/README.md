## PlayTime
### VERSION `1.0`

Script tracks players' play time on the server and stores it in their data files in seconds. Two new chat commands - /playtime and /playtime all - displays either individual play time or every player's that is currently online. The play time is converted into days/hours/minutes/seconds format when it is being displayed.

![Play time](https://imgur.com/sZY5pWw.png)

## INSTALLING INSTRUCTIONS

1) Copy `playTime.lua` to `.../tes3mp/mp-stuff/scripts`.

2) Open `server.lua` with a text editor.

3) Add `playTime = require("playTime")` at the top, along with all other included scripts.

4) At `local helpText = local helptext = "\nCommand list:\` block add
```
/playtime - Get your total play time on this server\
/playtime all - Get total play time on this server of all connected players\
```
somewhere inbetween the currently described commands, to add the two new commands to the `/help` list.

5) Find `function UpdateTime()` line of code and directly underneath it add `playTime.UpdatePlayTime()`

6) Find `local message = "Not a valid command. Type /help for more info.\n"`. Above you will see `else` line of code. Above THAT line of code, add
```
elseif cmd[1] == "playtime" and cmd[2] == "all" then
    playTime.ShowPlayTimeAllConnected(pid)
elseif cmd[1] == "playtime" then
    playTime.ShowPlayTime(pid)
```
7) Save `server.lua`. Start your server and try using one of the two commands. If everything was done properly, either a message box or a list will be displayed.

## COMMANDS:

### Commands added by this script
|Command|Description|
|:----|:-----|
|/playtime|Displays player's total play time on the server. The variable is stored in player's data file in seconds. The function converts it into days/hours/minutes/seconds format and then modifies the string to account for plural, singular or non-existant values. The result is displayed in a TES3 message box.|
|/playtime all|Displays a TES3 list box with the names, PIDs and their play time of all connected players. The time, stored in their data files, is converted from seconds to d/h/m/s format.|
