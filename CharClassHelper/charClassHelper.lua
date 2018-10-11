------------------
-- Version: 1.0 --
------------------

--[[
GetClassData(int pid) - returns data containing description of player's class, either from player's data file or from charClassData.josn
GetSpecialization(int pid) - returns specialization, as a number from 0 to 2, corresponding to combat/magic/stealth
GetMajorSkills(int pid) - returns major skills, in array with size of 5
GetMinorSkills(int pid) - returns minor skills, in array with size of 5
GetMajorAttributes(int pid) - returns major attributes, in array with size of 2
IsMajorSkill(int pid, string skill) - returns true if `skill` is player's major skill, false otherwise
IsMinorSkill(int pid, string skill) - returns true if `skill` is player's minor skill, false otherwise
IsSpecializedSkill(int pid, string skill) - returns true if `skill` falls under specialized skill category, false otherwise
GetSkillPercentage(int pid, string skill) - returns rounded value of skill's percentage based on current data in player's savefile
]]

require("patterns")
local Methods = {}

local combatSkills = {"Armorer", "Athletics", "Axe", "Block", "Bluntweapon", "Heavyarmor", "Longblade", "Mediumarmor", "Spear"}
local magicSkills = {"Alchemy", "Alteration", "Conjuration", "Destruction", "Enchant", "Illusion", "Mysticism", "Restoration", "Unarmored"}
local stealthSkills = {"Acrobatics", "Handtohand", "Lightarmor", "Marksman", "Mercantile", "Security", "Shortblade", "Sneak", "Speechcraft"}

charClassData = {}
Methods.Initialize = function()
	charClassData = jsonInterface.load("charClassData.json")
end

Methods.GetClassData = function(pid)
    local Player = Players[pid].data
    local classData
    if Player.character.class ~= "custom" then
        classData = charClassData[Player.character.class]
    else
        classData = Player.customClass
    end
    return classData
end

Methods.GetSpecialization = function(pid)
    local classData = charClassHelper.GetClassData(pid)
    local specialization = classData.specialization
    return specialization -- combat/magic/stealth
end

Methods.GetMajorSkills = function(pid)
    local classData = charClassHelper.GetClassData(pid)
    local majorSkillsData
    local majorSkills = {}
    majorSkillsData = classData.majorSkills
    local i = 0
    for value in string.gmatch(majorSkillsData, patterns.commaSplit) do
        majorSkills[i] = value
        i = i + 1
    end
    return majorSkills -- 0 to 4
end

Methods.GetMinorSkills = function(pid)
    local classData = charClassHelper.GetClassData(pid)
    local minorSkillsData
    local minorSkills = {}
    minorSkillsData = classData.minorSkills
    local i = 0
    for value in string.gmatch(minorSkillsData, patterns.commaSplit) do
        minorSkills[i] = value
        i = i + 1
    end
    return minorSkills -- 0 to 4
end

Methods.GetMajorAttributes = function(pid)
    local classData = charClassHelper.GetClassData(pid)
    local majorAttributesData
    local majorAttributes = {}
    majorAttributesData = classData.majorAttributes
    local i = 0
    for value in string.gmatch(minorSkillsData, patterns.commaSplit) do
        majorAttributes[i] = value
        i = i + 1
    end
    return majorAttributes -- 0 to 1
end

Methods.IsMajorSkill = function(pid, skill)
    local majorSkills = charClassHelper.GetMajorSkills(pid)
    for i = 0, 4 do
       if majorSkills[i] == skill then
            return true
        end
    end
    return false
end

Methods.IsMinorSkill = function(pid, skill)
    local minorSkills = charClassHelper.GetMinorSkills(pid)
    for i = 0, 4 do
       if minorSkills[i] == skill then
            return true
        end
    end
    return false
end

Methods.IsSpecializedSkill = function(pid, skill)
    local specialization = charClassHelper.GetSpecialization(pid)
    local skillSet
    if specialization == 0 then
        skillSet = combatSkills
    elseif specialization == 1 then
        skillSet = magicSkills
    elseif specialization == 2 then
        skillSet = stealthSkills
    end
    for i = 0, 8 do
        if skillSet[i] == skill then
            return true
        end
    end
    return false
end

Methods.GetSkillPercentage = function(pid, skill)
    local skillGroupBonus
    local specializationBonus
    local Player = Players[pid].data
    local skillValue = Player.skills[skill]
    if skillValue == nil then
        skillValue = -1
    end
    if charClassHelper.IsMajorSkill(pid, skill) then
        skillGroupBonus = 0.75
    elseif charClassHelper.IsMinorSkill(pid, skill) then
        skillGroupBonus = 1
    else
        skillGroupBonus = 1.25
    end
    if charClassHelper.IsSpecializedSkill(pid, skill) then
        specializationBonus = 0.8
    else
        specializationBonus = 1
    end
    local progressMax = (skillValue + 1)*skillGroupBonus*specializationBonus
    local progress = math.floor(Player.skillProgress[skill]*100/progressMax + 0.5)
    return progress
end

return Methods
