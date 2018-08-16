local Methods = {}
local powerReq = 0                                  -- 0 for everyone, 1 for mods, 2 for admins
local costItem = "gold_001"                         -- ID of item one must pay. Leave "" for no item
local costCount = 1000                              -- amount of item needed
local costMessage = "This will cost you 1000 gold." -- message to display about the cost
local WWRobeGUIID = 24602                           -- GUIID, probably don't need to touch

Methods.Initialize = function(pid)
    local power = tonumber(Players[pid].data.settings.admin)
    local message
    if power < powerReq then
        message = color.Red .. "Insufficient powers.\n" .. color.Default
        tes3mp.SendMessage(pid, message, false)
    else
        WWRobe.ShowCostBox(pid)
    end
end

Methods.ShowCostBox = function(pid)
    local label = "Equip Werewolf Robe?\n"
    if costItem ~= "" then
        label = label .. costMessage
    end
    local buttonData = "Yes;No"
    tes3mp.CustomMessageBox(pid, WWRobeGUIID, label, buttonData)
end

Methods.OnGUIAction = function(pid, idGui, data)
	if idGui == WWRobeGUIID then
		if tonumber(data) == 0 then -- Yes
			WWRobe.CostCheck(pid)
			return true
		elseif tonumber(data) == 1 then -- No
			return true
		end
	end
end

Methods.CostCheck = function(pid)
    local message
    local itemCount
    local itemIndex
    local canTurnIn = true
    if costItem ~= "" then
        for index, item in pairs(Players[pid].data.inventory) do
            if tableHelper.containsKeyValue(Players[pid].data.inventory, "refId", costItem, true) then
                itemIndex = tableHelper.getIndexByNestedKeyValue(Players[pid].data.inventory, "refId", costItem)
                itemCount = Players[pid].data.inventory[itemIndex].count
            else
                itemCount = 0
            end
        end
        if tonumber(itemCount) < tonumber(costCount) then
            canTurnIn = false
        end
    end
    if canTurnIn == true then
        if costItem ~= "" then
            Players[pid].data.inventory[itemIndex].count = Players[pid].data.inventory[itemIndex].count - tonumber(costCount)
            if Players[pid].data.inventory[itemIndex].count == 0 then
                Players[pid].data.inventory[itemIndex] = nil
            end
        end
        message = color.Green .. "Robe equipped!\n" .. color.Default
        tes3mp.SendMessage(pid, message, false)
        Players[pid]:LoadInventory()
        Players[pid]:LoadEquipment()
        Players[pid]:Save()
        WWRobe.EquipRobe(pid)
    else
        message = color.IndianRed .. "Item missing.\n" .. color.Default
        tes3mp.SendMessage(pid, message, false)
    end
end

Methods.EquipRobe = function(pid)
    if Players[pid].data.equipment[11] == nil then
        local items = { {"werewolfrobe", "1", "1"}}
        for i,item in pairs(items) do
            local structuredItem = { refId = item[1], count = item[2], charge = item[3] }
            table.insert(Players[pid].data.equipment, 11, structuredItem)
        end
    else
        Players[pid].data.equipment[11].refId = "werewolfrobe"
        Players[pid].data.equipment[11].count = "1"
        Players[pid].data.equipment[11].charge = "1"
    end
    Players[pid]:Save()
    Players[pid]:LoadInventory()
    Players[pid]:LoadEquipment()
end

return Methods
