local Methods = {}
local startupCells = {"0, 22", "0, -9", "1, 24", "-11, 15", "-11, 9", "-12, 11", "15, 5", "17, -6", "2, 23", "-2, -3", "2, 4", "-2, 5", "-2, 6", "-2, -8", "3, 23", "3, 24", "-3, -8", "3, -9", "-4, 12", "4, -9", "-5, -5", "-5, 9", "-6, -5", "6, -7", "8, 15", "-8, 16", "-8, 2", "-8, 3", "9, 15", "-9, 2", "-9, 4", "9, -7", "Ald-ruhn, Gindrala Hleran's House", "Ald-ruhn, Sarethi Manor", "Ald-ruhn, The Rat In The Pot", "Balmora, Balyn Omarel's House", "Balmora, Eight Plates", "Bthuand", "Cavern of the Incarnate", "Ghostgate, Tower of Dusk", "Gnaar Mok, Nadene Rotheran's Shack", "Ilunibi, Soul's Rattle", "Indarys Manor, Berendas' House", "Kora-Dur", "Mamaea, Sanctum of Black Hope", "Nchurdamz, Interior", "Rothan Ancestral Tomb", "Sadrith Mora, Dirty Muriel's Cornerclub", "Sadrith Mora, Tel Naga Great Hall", "Sadrith Mora, Telvanni Council House", "Telasero, Lower Level", "Vivec, Arena Storage", "Vivec, Foreign Quarter Underworks", "Vivec, Hall of Wisdom", "Vivec, Hlaalu Prison Cells", "Vivec, Jeanne; Trader", "Vivec, Milo's Quarters", "Vivec, Ralen Tilvur; Smith", "Vivec, St. Olms Underworks", "Vivec, Telvanni Enchanter"}
Methods.onServerInit = function(pid)
    local serverInitialized = false
    for index,cellDescription in ipairs(startupCells) do
        LoadedCells[cellDescription] = Cell(cellDescription)
        LoadedCells[cellDescription].description = cellDescription
        if LoadedCells[cellDescription]:HasEntry() then
            LoadedCells[cellDescription]:Load()
            serverInitialized = true
        end
        myMod.UnloadCell(cellDescription)
    end
    if serverInitialized == false then
        myMod.RunConsoleCommandOnPlayer(pid, "Startscript, Startup")
    end
end

Methods.onLogin = function(pid, savedData)
    --default states and such
    local colonyState = 0
    local colonySide = 0
    local colonyService = 0
    local colonyNord = 0
    local noteCount = 0
    local aferguard = 0
    local gratianguard = 0
    local garnasguard = 0
    local stronghold = 0
    for index, item in pairs(Players[pid].data.inventory) do
        if tableHelper.containsKeyValue(Players[pid].data.inventory, "refId", "bk_colony_toralf", true) then
            itemIndex = tableHelper.getIndexByNestedKeyValue(Players[pid].data.inventory, "refId", "bk_colony_toralf")
            noteCount = Players[pid].data.inventory[itemIndex].count
        else
            noteCount = 0
        end
    end
    for index, value2 in pairs(savedData.data.journal) do
        local journalEntry = savedData.data.journal[index]
        local quest = journalEntry.quest
        local questIndex = journalEntry.index
        ----------------------Raven Rock-------------------------
        -- handle colony development steps
        if tostring(quest) == "co_1" and questIndex == 50 then
            colonyState = 1
        end
        if tostring(quest) == "colony_update" and questIndex == 10 then
            colonyState = 2
        end
        if tostring(quest) == "colony_update" and questIndex == 20 then
            colonyState = 3
        end
        if tostring(quest) == "co_3" and questIndex == 70 then
            colonyState = 4
        end
        if tostring(quest) == "colony_update" and questIndex == 30 then
            colonyState = 5
        end
        if (tostring(quest) == "co_6a" and questIndex == 60) or (tostring(quest) == "co_6" and questIndex == 80) then
            colonyState = 9
        end
        if tostring(quest) == "colony_update" and questIndex == 40 then
            colonyState = 10
        end
        if tostring(quest) == "co_7" and (questIndex == 80 or questIndex == 90 or questIndex == 100 or questIndex == 110) then
            colonyState = 11
        end
        if tostring(quest) == "co_9a" and questIndex == 70 then
            colonyState = 12
        end
        if tostring(quest) == "co_11" and (questIndex == 60 or questIndex == 70) then
            colonyState = 13
        end
        if tostring(quest) == "colony_update" and questIndex == 50 then
            colonyState = 20
        end
        if tostring(quest) == "colony_update" and questIndex == 60 then
            colonyState = 21
        end
        if tostring(quest) == "co_13" and questIndex == 5 then
            colonyState = 22
        end
        if tostring(quest) == "co_13a" and questIndex == 10 then
            colonyState = 22
        end
        if tostring(quest) == "co_13" and questIndex == 70 then
            colonyState = 23
        end
        if tostring(quest) == "colony_update" and questIndex == 70 then -- colony_update is not displayed on journal -> completely skip waiting period
            colonyState = 30
        end
        if tostring(quest) == "co_13" and questIndex == 70 then
            colonyState = 30
        end
        --estate building in progress
        if tostring(quest) == "co_estate" and questIndex == 40 then
            colonyState = 31 -- or use 32 or 33 for other location
        end
        --estate complete
        if tostring(quest) == "co_estate" and questIndex == 50 then
            colonyState = 34 -- or use 35 or 36 for other location
        end
        --set it to 10 just to be safe, in case player logs out without turning the quest in
        if tostring(quest) == "co_13" and questIndex == 10 and noteCount > 0 then
            colonyNord = 10
        end
        --smithy/trading outpost progress and choice
        if tostring(quest) == "co_4" and (questIndex == 30 or questIndex == 60) then
            colonyService = 1
        end
        if tostring(quest) == "co_4" and (questIndex == 40 or questIndex == 70) then
            colonyService = 2
        end
        if tostring(quest) == "co_4" and questIndex == 80 then
            colonyService = 3
        end
        if tostring(quest) == "co_4" and questIndex == 90 then
            colonyService = 4
        end
        if tostring(quest) == "co_4" and questIndex == 100 then
            colonyService = 5
        end
        if tostring(quest) == "co_4" and questIndex == 110 then
            colonyService = 6
        end
        --which person you side with
        if tostring(quest) == "co_choice" and questIndex == 40 then
            colonySide = 1
        end
        if tostring(quest) == "co_choice" and questIndex == 50 then
            colonySide = 2
        end
        --extra variables for guards
        if tostring(quest) == "co_11" and questIndex == 30 then
            aferguard = 1
        end
        if tostring(quest) == "co_11" and questIndex == 40 then
            gratianguard = 1
        end
        if tostring(quest) == "co_11" and questIndex == 50 then
            garnasguard = 1
        end

        -------------Startup script--------------------

        -- Startup script related entities being re-enabled based on journal entries
        -- current approach has issues

        ---------------Strongholds----------------------

        local strongholdQuests = { "hh_stronghold", "hr_stronghold", "ht_stronghold" }
        if tableHelper.containsValue(strongholdQuests, quest) and questIndex == 55 then
            if stronghold < 1 then
                stronghold = 1
            end
        end
        if tableHelper.containsValue(strongholdQuests, quest) and questIndex == 100 then
            if stronghold < 2 then
                stronghold = 2
            end
        end
        if tableHelper.containsValue(strongholdQuests, quest) and questIndex == 170 then
            if stronghold < 3 then
                stronghold = 3
            end
        end
        if tableHelper.containsValue(strongholdQuests, quest) and questIndex == 200 then
            if stronghold < 4 then
                stronghold = 4
            end
        end
        if tableHelper.containsValue(strongholdQuests, quest) and questIndex == 270 then
            if stronghold < 5 then
                stronghold = 5
            end
        end
        if tableHelper.containsValue(strongholdQuests, quest) and questIndex == 300 then
            if stronghold < 6 then
                stronghold = 6
            end
        end

        ---------------Tribunal fixes-------------------

        if tostring(quest) == "tr_mhattack" and questIndex == 30 then
            myMod.RunConsoleCommandOnPlayer(pid, "set MournholdAttack to " .. -1)
        end

        -- more to come

        ----------------Bloodmoon fixes------------------

        -- stuff to come
    end
    --set variables/execute scripts via console
    if colonyState > 0 then
        myMod.RunConsoleCommandOnPlayer(pid, "startscript, ColonyTimer")
    end
    myMod.RunConsoleCommandOnPlayer(pid, "set ColonyState to " .. colonyState)
    myMod.RunConsoleCommandOnPlayer(pid, "set ColonySide to " .. colonySide)
    myMod.RunConsoleCommandOnPlayer(pid, "set ColonyService to " .. colonyService)
    myMod.RunConsoleCommandOnPlayer(pid, "set ColonyNord to " .. colonyNord)
    myMod.RunConsoleCommandOnPlayer(pid, "set aferguard to " .. aferguard)
    myMod.RunConsoleCommandOnPlayer(pid, "set gratianguard to " .. gratianguard)
    myMod.RunConsoleCommandOnPlayer(pid, "set garnasguard to " .. garnasguard)
    myMod.RunConsoleCommandOnPlayer(pid, "set stronghold to " .. stronghold)
end

return Methods
