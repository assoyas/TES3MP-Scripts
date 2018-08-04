require("color")
Methods = {}
local vampirismCostItemId = "gold_001"          -- ID of the item
local vampirismCostCureItemId = ""              -- ID of the cure item
local vampirismCostCount = "100000"             -- amount of the item
local vampirismCostCureCount = ""               -- amount of the cure item
local vampirismCostText = "This process will be instant and will cost you 100.000 gold."        -- text to display regarding the item and count, cannot be made dynamic with current tools in a simple way
local vampirismCostCureText = "This process will be instant. The cure will cost you nothing"    -- same as before
local vampirismGUIID = 695874                   -- GUI ID for transformation texboxes, do not touch
local vampirismCureGUIID = 695875               -- no touchies
local vampirismLevelReq = 0                     -- optional level requirement; keep it at 0 if no requirement is desired (unless you have players being level 0 for some reason)
local allowCure = true                          -- allow curing?
local allowVampirism = true                     -- allow infection?
local displayGlobalTransformationMessage = true -- whether or not to display the transformation message to the whole server

Methods.IsVampire = function(pid)
    local isVampire
    for index, item in pairs(Players[pid].data.spellbook) do
        if tableHelper.containsKeyValue(Players[pid].data.spellbook, "spellId", "vampire attributes", true) then
            isVampire = true
        else
            isVampire = false
        end
    end
    return isVampire
end

Methods.OnLogin = function(pid)
    local message = ""
    local vampireClan
    local isVampire = false
    local consoleAddSpell
    local consoleStartScript
    isVampire = VaW.IsVampire(pid)
    if isVampire == true then
        for index, item in pairs(Players[pid].data.spellbook) do
            if tableHelper.containsKeyValue(Players[pid].data.spellbook, "spellId", "vampire berne specials", true) then
                vampireClan = "berne"
            elseif tableHelper.containsKeyValue(Players[pid].data.spellbook, "spellId", "vampire aundae specials", true) then
                vampireClan = "aundae"
            elseif tableHelper.containsKeyValue(Players[pid].data.spellbook, "spellId", "vampire quarra specials", true) then
                vampireClan = "quarra"
            else
                vampireClan = "none"
            end
        end
        if vampireClan ~= "none" then
            consoleAddSpell = "player->addspell \"vampire blood " .. vampireClan .. "\""
            consoleStartScript = "startscript, \"vampire_" .. vampireClan .. "_PC\""
        else
            local logmessage = "VaW: WARNING! PLAYER PID" .. pid .. " IS VAMPIRE WITH NO CLAN\n"
            tes3mp.LogMessage(0, message)
        end
        myMod.RunConsoleCommandOnPlayer(pid, consoleAddSpell)
        myMod.RunConsoleCommandOnPlayer(pid, consoleStartScript)
    end
end

Methods.Initialize = function(pid)
    local level = tonumber(Players[pid].data.stats.level)
    local message
    local isVampire
    if allowVampirism == true then
        isVampire = VaW.IsVampire(pid)
        if isVampire == false then
            if level < vampirismLevelReq then
                message = color.Red .. "Insufficient level. Required: " .. vampirismLevelReq .. "\n" .. color.Default
                tes3mp.SendMessage(pid, message, false)
            else
                VaW.ShowCostBox(pid)
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

Methods.InitializeCure = function(pid)
    local message
    local isVampire
    isVampire = VaW.IsVampire(pid)
    if allowCure == true then
        if isVampire == true then
            VaW.ShowCureBox(pid)
        else
            message = color.Red .. "You are not a vampire.\n" .. color.Default
            tes3mp.SendMessage(pid, message, false)
        end
    else
        message = color.Crimson .. "You cannot cure the disease this way.\n" .. color.Default
        tes3mp.SendMessage(pid, message, false)
    end
end

Methods.ShowCostBox = function(pid)
    local label = "Select your vampire clan.\n"
    if vampirismCostItemId ~= "" then
        label = label .. vampirismCostText
    end
    local buttonData = "    Aundae    ;    Berne    ;    Quarra    ;    Cancel    "
    tes3mp.CustomMessageBox(pid, vampirismGUIID, label, buttonData)
end

Methods.ShowCureBox = function(pid)
    local label = "Are you sure you want to cure yourself?.\n"
    if vampirismCostCureItemId ~= "" then
        label = label .. vampirismCostCureText
    end
    local buttonData = "Yes;No"
    tes3mp.CustomMessageBox(pid, vampirismCureGUIID, label, buttonData)
end

Methods.OnGUIAction = function(pid, idGui, data)
	if idGui == vampirismGUIID then
		if tonumber(data) == 0 then -- Aundae
			VaW.BuyVampirism(pid,1)
			return true
		elseif tonumber(data) == 1 then -- Berne
            VaW.BuyVampirism(pid,2)
			return true
        elseif tonumber(data) == 2 then -- Quarra
            VaW.BuyVampirism(pid,3)
			return true
        elseif tonumber(data) == 3 then -- Cancel
			return true
		end
	elseif idGui == vampirismCureGUIID then
        if tonumber(data) == 0 then -- Cure
			VaW.Cure(pid)
			return true
		elseif tonumber(data) == 1 then -- Cancel
			return true
		end
	end
end

Methods.BuyVampirism = function(pid, clan)
    local message
    local itemCount
    local itemIndex
    local canTransform = true
    local clanName
    local playerName = tes3mp.GetName(pid)
    if clan == 1 then
        clanName = "Aundae"
    elseif clan == 2 then
        clanName = "Berne"
    elseif clan == 3 then
        clanName = "Quarra"
    end
    if vampirismCostItemId ~= "" then
        for index, item in pairs(Players[pid].data.inventory) do
            if tableHelper.containsKeyValue(Players[pid].data.inventory, "refId", vampirismCostItemId, true) then
                itemIndex = tableHelper.getIndexByNestedKeyValue(Players[pid].data.inventory, "refId", vampirismCostItemId)
                itemCount = Players[pid].data.inventory[itemIndex].count
            else
                itemCount = 0
            end
        end
        if tonumber(itemCount) < tonumber(vampirismCostCount) then
            canTransform = false
        end
    end
    if canTransform == true then
        if vampirismCostItemId ~= "" then
            Players[pid].data.inventory[itemIndex].count = Players[pid].data.inventory[itemIndex].count - tonumber(vampirismCostCount)
            if Players[pid].data.inventory[itemIndex].count == 0 then
                Players[pid].data.inventory[itemIndex] = nil
            end
        end
        message = color.Red .. "Transformation complete. You are now part of the " .. clanName .. " clan.\n" .. color.Default
        tes3mp.SendMessage(pid, message, false)
        if displayGlobalTransformationMessage == true then
            message = color.DarkSalmon .. playerName .. " has joined the " .. clanName .. " vampire clan.\n" .. color.Default
            tes3mp.SendMessage(pid, message, true)
        end
        Players[pid]:LoadInventory()
        Players[pid]:LoadEquipment()
        Players[pid]:Save()
        VaW.Transform(pid,clan)
    else
        message = color.IndianRed .. "Item(s) missing.\n" .. color.Default
        tes3mp.SendMessage(pid, message, false)
    end
end

Methods.Transform = function(pid, clan)
    local consoleAddSpell
    local consoleStartScript
    local consoleSetPCVamp
    local vampireClan
    if clan == 1 then
        vampireClan = "aundae"
    elseif clan == 2 then
        vampireClan = "berne"
    elseif clan == 3 then
        vampireClan = "quarra"
    end
    consoleSetPCVamp = "set PCVampire to 0"
    consoleAddSpell = "player->addspell \"vampire blood " .. vampireClan .. "\""
    consoleStartScript = "startscript, \"vampire_" .. vampireClan .. "_PC\""
    myMod.RunConsoleCommandOnPlayer(pid, consoleSetPCVamp)
    myMod.RunConsoleCommandOnPlayer(pid, consoleAddSpell)
    myMod.RunConsoleCommandOnPlayer(pid, consoleStartScript)
    myMod.OnPlayerSpellbook(pid)
end

Methods.Cure = function(pid)
    local consoleCure
    local consoleSetPCVamp
    local message
    local playerName = tes3mp.GetName(pid)
    consoleCure = "startscript, \"Vampire_Cure_PC\""
    consoleSetPCVamp = "set PCVampire to 0"
    myMod.RunConsoleCommandOnPlayer(pid, consoleCure)
    --myMod.RunConsoleCommandOnPlayer(pid, consoleSetPCVamp)   -- NO WORKIES, SETS VARIABLE TOO FAST
    message = color.Green .. "You no longer feel the thirst for blood. You've been cured!\n" .. color.Default
    tes3mp.SendMessage(pid, message, false)
    if displayGlobalTransformationMessage == true then
        message = color.DarkGreen .. playerName .. " has cured their vampirism.\n" .. color.Default
        tes3mp.SendMessage(pid, message, true)
    end
    myMod.OnPlayerSpellbook(pid)
end
return Methods
