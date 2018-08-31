------------------
-- Version: 1.2 --
------------------

require("color")
local Methods = {}
-- Vampire variables
local vampirismCostItemId = "gold_001"          -- ID of the item
local vampirismCostCureItemId = ""              -- ID of the cure item
local vampirismCostCount = 100000               -- amount of the item
local vampirismCostCureCount = 0                -- amount of the cure item
local vampirismCostText = "This process will be instant and will cost you 100.000 gold."        -- text to display regarding the item and count, cannot be made dynamic with current tools in a simple way
local vampirismCostCureText = "This process will be instant. The cure will cost you nothing"    -- same as before
local vampirismGUIID = 695874                   -- GUI ID for transformation texboxes, do not touch
local vampirismCureGUIID = 695875               -- no touchies
local vampirismLevelReq = 0                     -- optional level requirement; keep it at 0 if no requirement is desired (unless you have players being level 0 for some reason)
local allowVampirismCure = true                 -- allow curing?
local allowVampirism = true                     -- allow infection?
local displayGlobalVampirismTransformationMessage = true -- whether or not to display the transformation message to the whole server
local vampirismInfectOnKill = true              -- can players contract the disease by being killed by another (vampire) player?
local vampirismInfectChance = 25                -- chance (in percentage) for that to happen
local vampirismInfectLevelThreshold = 20        -- minimum level for player to be eligible for infection that way
local displaygGlobalVampirismInfectionMessage = true -- whether to display a global message when infection this way happens or not

-- function to check if player is a vampire
Methods.IsVampire = function(pid)
    if tableHelper.containsKeyValue(Players[pid].data.spellbook, "spellId", "vampire attributes", true) then
        return true
    else
        return false
    end
    return false
end

-- return player's vampire clan as a string or false if there's none
Methods.GetVampireClan = function(pid)
    if tableHelper.containsKeyValue(Players[pid].data.spellbook, "spellId", "vampire aundae specials", true) then
        return "aundae"
    elseif tableHelper.containsKeyValue(Players[pid].data.spellbook, "spellId", "vampire brene specials", true) then
        return "brene"
    elseif tableHelper.containsKeyValue(Players[pid].data.spellbook, "spellId", "vampire quarra specials", true) then
        return "quarra"
    else
        return false
    end
    return false
end

-- check if player meets the requirements for vampirism infection
Methods.InitializeVampirism = function(pid)
    local level = tonumber(Players[pid].data.stats.level)
    local message
    if allowVampirism == true then
        if VaW.IsVampire(pid) == false then
            if level < vampirismLevelReq then
                message = color.Red .. "Insufficient level. Required: " .. vampirismLevelReq .. "\n" .. color.Default
                tes3mp.SendMessage(pid, message, false)
            else
                VaW.ShowVampirismCostBox(pid)
            end
        else
            message = color.Red .. "You are already a vampire.\n" .. color.Default
            tes3mp.SendMessage(pid, message, false)
        end
    else
        message = color.Crimson .. "You cannot transform into a vampire this way.\n" .. color.Default
        tes3mp.SendMessage(pid, message, false)
    end
end

-- setup the display of cure message box
Methods.InitializeVampirismCure = function(pid)
    local message
    if allowVampirismCure == true then
        if VaW.IsVampire(pid) then
            VaW.ShowVampirismCureBox(pid)
        else
            message = color.Red .. "You are not a vampire.\n" .. color.Default
            tes3mp.SendMessage(pid, message, false)
        end
    else
        message = color.Crimson .. "You cannot cure the disease this way.\n" .. color.Default
        tes3mp.SendMessage(pid, message, false)
    end
end

-- show clan options
Methods.ShowVampirismCostBox = function(pid)
    local label = "Select your vampire clan.\n"
    if vampirismCostItemId ~= "" then
        label = label .. vampirismCostText
    end
    local buttonData = "    Aundae    ;    Berne    ;    Quarra    ;    Cancel    "
    tes3mp.CustomMessageBox(pid, vampirismGUIID, label, buttonData)
end

-- display cure message box
Methods.ShowVampirismCureBox = function(pid)
    local label = "Are you sure you want to cure yourself?\n"
    if vampirismCostCureItemId ~= "" then
        label = label .. vampirismCostCureText
    end
    local buttonData = "Yes;No"
    tes3mp.CustomMessageBox(pid, vampirismCureGUIID, label, buttonData)
end

-- detect which button was clicked
Methods.OnGUIAction = function(pid, idGui, data)
	if idGui == vampirismGUIID then
		if tonumber(data) == 0 then -- Aundae
			VaW.ProcessPurchase(pid, "vampirismBuy", vampirismCostItemId, vampirismCostCount, "aundae")
			return true
		elseif tonumber(data) == 1 then -- Berne
            VaW.ProcessPurchase(pid, "vampirismBuy", vampirismCostItemId, vampirismCostCount, "berne")
			return true
        elseif tonumber(data) == 2 then -- Quarra
            VaW.ProcessPurchase(pid, "vampirismBuy", vampirismCostItemId, vampirismCostCount, "quarra")
			return true
        elseif tonumber(data) == 3 then -- Cancel
			return true
		end
	elseif idGui == vampirismCureGUIID then
        if tonumber(data) == 0 then -- Cure
			VaW.ProcessPurchase(pid, "vampirismCure", vampirismCostCureItemId, vampirismCostCureCount, 0)
			return true
		elseif tonumber(data) == 1 then -- Cancel
			return true
		end
	end
end

-- generic function to process a purchase of a service
--[[
pid - player's ID
action - what kind of service we're buying (ex. cureVampirism)
item - itemID passed on for the specific service
count - the amount of the item
extra - additional variable passed on, such as the vampire clan
]]
Methods.ProcessPurchase = function(pid, action, item, count, extra)
    local message
    local itemCount
    local itemIndex
    local canPurchase = true
    local playerName = tes3mp.GetName(pid)
    if item ~= "" then
        itemIndex = tableHelper.getIndexByNestedKeyValue(Players[pid].data.inventory, "refId", item)
        if itemIndex ~= nil then
            itemCount = Players[pid].data.inventory[itemIndex].count
        else
            itemCount = 0
        end
        if itemCount < count then
            canPurchase = false
        end
    end
    if canPurchase == true then
        if item ~= "" then
            Players[pid].data.inventory[itemIndex].count = itemCount - count
            if Players[pid].data.inventory[itemIndex].count == 0 then
                Players[pid].data.inventory[itemIndex] = nil
            end
        end
        Players[pid]:LoadInventory()
        Players[pid]:LoadEquipment()
        if action == "vampirismBuy" then
            message = color.Red .. "Transformation complete. You are now part of the " .. extra .. " clan.\n" .. color.Default
            tes3mp.SendMessage(pid, message, false)
            if displayGlobalVampirismTransformationMessage == true then
                message = color.DarkSalmon .. playerName .. " has joined the " .. extra .. " vampire clan.\n" .. color.Default
                tes3mp.SendMessage(pid, message, true)
            end
            VaW.VampirismTransform(pid, extra)
        elseif action == "vampirismCure" then
            VaW.VampirismCure(pid)
        elseif action == "werewolfBuy" then
            VaW.WerewolfTransform(pid)
        elseif action == "werewolfCure" then
            VaW.WerewolfCure(pid)
        end
    else
        message = color.IndianRed .. "Item(s) missing.\n" .. color.Default
        tes3mp.SendMessage(pid, message, false)
    end
end

-- transform the player into a vampire of the clan
Methods.VampirismTransform = function(pid, clan)
    local message
    local playerName = tes3mp.GetName(pid)
    myMod.RunConsoleCommandOnPlayer(pid, "set PCVampire to 0")
    myMod.RunConsoleCommandOnPlayer(pid, "player->addspell \"vampire blood " .. clan .. "\"")
    myMod.RunConsoleCommandOnPlayer(pid, "startscript, \"vampire_" .. clan .. "_PC\"")
    myMod.OnPlayerSpellbook(pid)
end

-- cure the player of vampirism
Methods.VampirismCure = function(pid)
    local message
    local playerName = tes3mp.GetName(pid)
    myMod.RunConsoleCommandOnPlayer(pid, "startscript, \"Vampire_Cure_PC\"")
    message = color.Green .. "You no longer feel the thirst for blood. You've been cured!\n" .. color.Default
    tes3mp.SendMessage(pid, message, false)
    if displayGlobalVampirismTransformationMessage == true then
        message = color.DarkGreen .. playerName .. " has cured their vampirism.\n" .. color.Default
        tes3mp.SendMessage(pid, message, true)
    end
    myMod.OnPlayerSpellbook(pid)
end

Methods.OnPlayerDeath = function(pid, killerName)
    local playerName = tes3mp.GetName(pid)
    local lastPid = tes3mp.GetLastPlayerId()
    local killerPid = -1
    local message
    if Players[pid].data.stats.level >= vampirismInfectLevelThreshold then
        for i = 0, lastPid do
            if Players[i] ~= nil and Players[i]:IsLoggedIn() then
                if tostring(Players[i].name) == tostring(killerName) then
                    killerPid = Players[i].pid -- get killer's PID, assuming it was an actual player
                    break
                end
            end
        end
        if killerPid ~= -1 then -- if a killer was found
            if VaW.IsVampire(killerPid) then
                if vampirismInfectOnKill == true then
                    math.random()
                    local roll = math.random(0, 100)
                    if roll <= vampirismInfectChance then
                        local clan = VaW.GetVampireClan(killerPid)
                        if clan ~= false then
                            VaW.VampirismTransform(pid, clan)
                            message = color.Red .. "You have contracted porphyric hemophilia from " .. killerName .. ". You are now part of the " .. clan .. " bloodline.\n" .. color.Default
                            tes3mp.SendMessage(pid, message, false)
                            message = color.Red .. "You have infected " .. playerName .. " with the vampire curse.\n" .. color.Default
                            tes3mp.SendMessage(killerPid, message, false)
                            if displaygGlobalVampirismInfectionMessage == true then
                                message = color.DarkSalmon .. playerName .. " has been infected by " .. killerName .. " with the curse of " .. clan .. " vampire clan.\n" .. color.Default
                                tes3mp.SendMessage(pid, message, true)
                            end
                        end
                    end
                end
            end
        end
    end
end
return Methods
