Version `1.0`

This small script adds a chat command `/wwrobe` that allows players on the server to equip the elusive "Werewolf Robe". This item is essentially the body of a werewolf and is actually given to player when it turns into a werewolf, however, the item cannot be seen in inventory. Still, the item is saved in the player's datafile, so it can be kept track of. The scripts allows some customization, such as:

• Who is allowed to equip the robe (everyone/mods and admins/admins only)

• Whether the process cost anything (both the item and the amount of item)

## Installing instructions

1) Copy `WWRobe.lua` to `...\<tes3mpfolder>\mp-stuff\scripts`.

2) Open `server.lua` with a text editor.

3) Add`WWRobe = require("WWRobe")` at the top, along with all other included scripts.

4) (OPTIONAL) Add `/wwrobe - Equip werewolf robe\` below, where the `helptext` variables are located. Add this under appropariate helptext, depending on who is allowed to use the command. This will display the command in the help text when players type `/help` in chat.

5) Scroll down a long way in `server.lua` and find where chat commands are described. Find the last one and add:
`elseif cmd[1] == "wwrobe" then WWRobe.Initialize(pid)`
(or just put it anywhere below a previous command, such as `elseif (cmd[1] == "greentext"...`).

6) Find `if myMod.OnGUIAction(pid, idGui, data) then return end` near the end and add `if WWRobe.OnGUIAction(pid, idGui, data) then return end` below it.

7) (OPTIONAL) Open `WWRobe.lua` and edit the variables at the top, if you wish.

8) Start your server and type `/wwrobe` in chat to see some magic
