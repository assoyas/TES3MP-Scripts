------------------
-- Version: 1.0 --
------------------
require("charClassHelper")
local goldRefId = "gold_001"            -- change if you're using different item as gold
local maxTrainerLevel = 100             -- maximum skill level you can train to using trainers, change as needed
--[[first notification is displayed every time player exceeds maxTrainerLevel while training on the server with that specific
maxTrainerValue, so the message is displayed again if you change the cap. Adjust the text based on your preferences]]
local firstNotification = "Training is limited up to skill level " .. maxTrainerLevel .. " on this server. Training beyond that will result in a rollback of the skill and a refund."
-- messages to display when player trains beyond the allowed limit, informing of the rollback of skill and refund (if applicable)
local trainRefundNotification = "Trainer use beyond limit detected; rolling back and refunding."
local trainNoRefundNotification = "Trainer use beyond limit detected; rolling back."
local Methods = {}

Methods.OnLogin = function(pid)
    Players[pid].data.customVariables.dtPreviousGold = 0
    Players[pid].data.customVariables.dtChangedCell = false
    if Players[pid].data.customVariables.dtDisplayedNotification == nil then
        Players[pid].data.customVariables.dtDisplayedNotification = -1
    end
end

Methods.CheckGold = function(pid)
    local count
    local itemIndex = tableHelper.getIndexByNestedKeyValue(Players[pid].data.inventory, "refId", goldRefId)
    if itemIndex ~= nil then
        count = Players[pid].data.inventory[itemIndex].count
    else
        count = 0
    end
    Players[pid].data.customVariables.dtPreviousGold = count
end

Methods.CheckCellChange = function(pid)
    local previousCell = Players[pid].data.location.cell
    local cell = tes3mp.GetCell(pid)
    if previousCell ~= cell then
        Players[pid].data.customVariables.dtChangedCell = true
    else
        Players[pid].data.customVariables.dtChangedCell = false
    end
end

Methods.GetCurrentGold = function(pid)
    local gold
    for i = 0, tes3mp.GetInventoryChangesSize(pid) - 1 do
        local itemRefId = tes3mp.GetInventoryItemRefId(pid, i)
        if itemRefId ~= "" then
            if itemRefId == "gold_001" then
                gold = tes3mp.GetInventoryItemCount(pid, i)
                break
            end
        end
    end
    if gold == nil then
        gold = 0
    end
    return gold
end

Methods.OnPlayerBounty = function(pid)
    Players[pid].data.customVariables.dtPreviousGold = disableTraining.GetCurrentGold(pid)
end

Methods.CheckTrainerUse = function(pid)
    local cellChange = Players[pid].data.customVariables.dtChangedCell
    local previousGold = Players[pid].data.customVariables.dtPreviousGold
    local currentGold = disableTraining.GetCurrentGold(pid)
    if cellChange == false then
        if previousGold > currentGold then
            local goldDiff = previousGold - currentGold
            disableTraining.CheckSkill(pid, goldDiff)
        end
    end
    Players[pid].data.customVariables.dtChangedCell = false
end

Methods.CheckSkill = function(pid, goldDiff)
    local data = Players[pid].data
    local skillArray = {}
    local progressArray = {}
    local i = 0
    for name in pairs(data.skills) do
        local skillId = tes3mp.GetSkillId(name)
        local baseValue = tes3mp.GetSkillBase(pid, skillId)
        local savedValue = data.skills[name]
        if savedValue + 1 == baseValue then
            if baseValue > maxTrainerLevel then
                i = i + 1
                skillArray[i] = name
                progressArray[i] = charClassHelper.GetSkillPercentage(pid, name)
            end
        end
    end
    if i ~= 0 then
        local tempSort
        if i > 1 then
            for j = 1, i-1 do
                for k = j+1, i do
                    if progressArray[j] > progressArray[k] then
                        tempSort = progressArray[j]
                        progressArray[j] = progressArray[k]
                        progressArray[k] = tempSort
                        tempSort = skillArray[j]
                        skillArray[j] = skillArray[k]
                        skillArray[k] = tempSort
                    end
                end
            end
        end

        if tostring(skillArray[1]) ~= "Speechcraft" and tostring(skillArray[1]) ~= "Mercantile" then
            disableTraining.UndoTraining(pid, skillArray[1], goldDiff)
        else
            if progressArray[1] < 70 then
                disableTraining.UndoTraining(pid, skillArray[1], goldDiff)
            end
        end
    end
end

Methods.UndoTraining = function(pid, skillName, goldDiff)
    local data = Players[pid].data
    local value
    value = data.skills[skillName]
    tes3mp.SetSkillBase(pid, tes3mp.GetSkillId(skillName), value)
    value = data.skillProgress[skillName]
    tes3mp.SetSkillProgress(pid, tes3mp.GetSkillId(skillName), value)
    for name, value in pairs(data.attributeSkillIncreases) do
        tes3mp.SetSkillIncrease(pid, tes3mp.GetAttributeId(name), value)
    end
    if data.customVariables.dtDisplayedNotification ~= maxTrainerLevel then
        tes3mp.CustomMessageBox(pid, -1, firstNotification .. "\n", "Ok")
        data.customVariables.dtDisplayedNotification = maxTrainerLevel
    end
    if goldDiff > 999 then
        tes3mp.MessageBox(pid, -1, color.Red .. trainNoRefundNotification)
    else
        tes3mp.MessageBox(pid, -1, color.Red .. trainRefundNotification)
        local itemIndex = tableHelper.getIndexByNestedKeyValue(data.inventory, "refId", goldRefId)
        if itemIndex ~= nil then
            data.inventory[itemIndex].count = data.inventory[itemIndex].count + goldDiff
            data.customVariables.dtPreviousGold = data.inventory[itemIndex].count
            data.customVariables.dtChangedCell = false
            Players[pid]:LoadInventory()
            Players[pid]:LoadEquipment()
        end
    end
    tes3mp.SendSkills(pid)
end

return Methods
