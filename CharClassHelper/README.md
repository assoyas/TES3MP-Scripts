﻿## CharClassHelper
### VERSION 1.0

A small library to help read character's class. Supports both native classes and custom ones. Functions include reading player's major/minor skills and calculating the progress of a skill in percentage.

I had a need for such library for one of my scripts, so I put together something that could be applied in other cases as well. The script reads player's data file to determine whether they are using a pre-defined or a custom class, then reads the class' variables either from player's data file in case of a custom class or the supplied data file in case of pre-defined classes. The script does not contain many failsaves to prevent crashes and there may be spelling errors in the attached data file, so you are welcome to make a pull request if you find any mistakes, as well as if you define a new function that could be used in the script.

## INSTALLATION:

1) Copy `charClassHelper.lua` to `.../tes3mp/mp-stuff/scripts`.

2) Open `server.lua` with a text editor.

3) Add `charClassHelper = require("charClassHelper")` at the top, along with all other included scripts.

4) Save `server.lua` file

5) Copy `charClassData.json` to `.../tes3mp/mp-stuff/data/` folder.


## COMPABILITY:
The script was made for vanilla Morrowind. Mods that alter the pre-defined classes, variables `SkillGroupBonus` or `SpecializationBonus`, adds new skills or modifies their names will have to be accounted for by the script through adjustments where necessary.

## FUNCTIONS:

### Functions added by this script
|Function|Arguments|Description|
|:----|:-----|:-----|
|GetClassData|int pid|Returns a table containing information of player's class depending on whether they use a custom or pre-defined class.|
|GetSpecialization|int pid|Retruns the specialization of player's class, in integer, from 0 to 2, mapping to combat, magic and stealth specialization, respectivelly.|
|GetMajorSkills|int pid|Returns an array containing the names of player's major skills, with first letter being capital for each skill.|
|GetMinorSkills|int pid|Returns an array containing the names of player's minor skills, with first letter being capital for each skill.|
|GetMajorAttributes|int pid|Returns an array containing the names of player's preferred attributes, with first letter being capital for each attribute.|
|IsMajorSkill|int pid, string skill|Returns a boolean defining whether the `skill` is player's major skill or not. The skill has to start with a capital letter.|
|IsMinorSkill|int pid, string skill|Returns a boolean defining whether the `skill` is player's minor skill or not. The skill has to start with a capital letter.|
|IsSpecializedSkill|int pid, string skill|Returns a boolean defining whether the `skill` falls under the specialization of player's class. The skill has to start with a capital letter.|
|GetSkillPercentage|int pid, string skill|Returns the percentage of player's skill progress, the number you see while scrolling over a skill in TES3. The skill has to start with a capital letter.|

## CHANGELOG:
### 1.0:
• Initial release of the script.