-- This script attempts to partially fix the cancer that is Raven Rock, at least until proper measures are implemented by David
-- The goal is to load the Raven Rock properly for each player and then fix state spam so it doesn't lag the server

Methods = {}
Methods.onLogin = function(pid, savedData)
    local consoleColonyTimer
    local consoleColonyState
    local consoleColonySide
    local consoleColonyService
    local consoleColonyNord
    local consoleAfer
    local consoleGratian
    local consoleGarnas
    --default states and such
    local colonyState = 0
    local colonySide = 0
    local colonyService = 0
    local colonyNord = 0
    local noteCount = 0
    local aferguard = 0
    local gratianguard = 0
    local garnasguard = 0
    for index, item in pairs(Players[pid].data.inventory) do
        if tableHelper.containsKeyValue(Players[pid].data.inventory, "refId", "bk_colony_toralf", true) then
            itemIndex = tableHelper.getIndexByNestedKeyValue(Players[pid].data.inventory, "refId", "bk_colony_toralf")
            noteCount = Players[pid].data.inventory[itemIndex].count
        else
            noteCount = 0
        end
    end

        for index, value2 in pairs(savedData.data.journal) do
            -- handle colony development steps
            if tostring(savedData.data.journal[index].quest) == "co_1" and tostring(savedData.data.journal[index].index) == "50" then
                colonyState = 1
            end
            if tostring(savedData.data.journal[index].quest) == "colony_update" and tostring(savedData.data.journal[index].index) == "10" then
                colonyState = 2
            end
            if tostring(savedData.data.journal[index].quest) == "colony_update" and tostring(savedData.data.journal[index].index) == "20" then
                colonyState = 3
            end
            if tostring(savedData.data.journal[index].quest) == "co_3" and tostring(savedData.data.journal[index].index) == "70" then
                colonyState = 4
            end
            if tostring(savedData.data.journal[index].quest) == "colony_update" and tostring(savedData.data.journal[index].index) == "30" then
                colonyState = 5
            end
            if (tostring(savedData.data.journal[index].quest) == "co_6a" and tostring(savedData.data.journal[index].index) == "60") or (tostring(savedData.data.journal[index].quest) == "co_6" and tostring(savedData.data.journal[index].index) == "80") then
                colonyState = 9
            end
            if tostring(savedData.data.journal[index].quest) == "colony_update" and tostring(savedData.data.journal[index].index) == "40" then
                colonyState = 10
            end
            if tostring(savedData.data.journal[index].quest) == "co_7" and (tostring(savedData.data.journal[index].index) == "80" or tostring(savedData.data.journal[index].index) == "90" or tostring(savedData.data.journal[index].index) == "100" or tostring(savedData.data.journal[index].index) == "110") then
                colonyState = 11
            end
            if tostring(savedData.data.journal[index].quest) == "co_9a" and tostring(savedData.data.journal[index].index) == "70" then
                colonyState = 12
            end
            if tostring(savedData.data.journal[index].quest) == "co_11" and (tostring(savedData.data.journal[index].index) == "60" or tostring(savedData.data.journal[index].index) == "70") then
                colonyState = 13
            end
            if tostring(savedData.data.journal[index].quest) == "colony_update" and tostring(savedData.data.journal[index].index) == "50" then
                colonyState = 20
            end
            if tostring(savedData.data.journal[index].quest) == "colony_update" and tostring(savedData.data.journal[index].index) == "60" then
                colonyState = 21
            end
            if tostring(savedData.data.journal[index].quest) == "co_13" and tostring(savedData.data.journal[index].index) == "5" then
                colonyState = 22
            end
            if tostring(savedData.data.journal[index].quest) == "co_13a" and tostring(savedData.data.journal[index].index) == "10" then
                colonyState = 22
            end
            if tostring(savedData.data.journal[index].quest) == "co_13" and tostring(savedData.data.journal[index].index) == "70" then
                colonyState = 23
            end
            if tostring(savedData.data.journal[index].quest) == "colony_update" and tostring(savedData.data.journal[index].index) == "70" then -- colony_update is not displayed on journal -> completely skip waiting period
                colonyState = 30
            end
            if tostring(savedData.data.journal[index].quest) == "co_13" and tostring(savedData.data.journal[index].index) == "70" then
                colonyState = 30
            end
            --estate building in progress
            if tostring(savedData.data.journal[index].quest) == "co_estate" and tostring(savedData.data.journal[index].index) == "40" then
                colonyState = 31 -- or use 32 or 33 for other location
            end
            --estate complete
            if tostring(savedData.data.journal[index].quest) == "co_estate" and tostring(savedData.data.journal[index].index) == "50" then
                colonyState = 34 -- or use 35 or 36 for other location
            end

            --set it to 10 just to be safe, in case player logs out without turning the quest in
            if tostring(savedData.data.journal[index].quest) == "co_13" and tostring(savedData.data.journal[index].index) == "10" and noteCount > 0 then
                colonyNord = 10
            end

            --smithy/trading outpost progress and choice
            if tostring(savedData.data.journal[index].quest) == "co_4" and (tostring(savedData.data.journal[index].index) == "30" or tostring(savedData.data.journal[index].index) == "60") then
                colonyService = 1
            end
            if tostring(savedData.data.journal[index].quest) == "co_4" and (tostring(savedData.data.journal[index].index) == "40" or tostring(savedData.data.journal[index].index) == "70") then
                colonyService = 2
            end
            if tostring(savedData.data.journal[index].quest) == "co_4" and tostring(savedData.data.journal[index].index) == "80" then
                colonyService = 3
            end
            if tostring(savedData.data.journal[index].quest) == "co_4" and tostring(savedData.data.journal[index].index) == "90" then
                colonyService = 4
            end
            if tostring(savedData.data.journal[index].quest) == "co_4" and tostring(savedData.data.journal[index].index) == "100" then
                colonyService = 5
            end
            if tostring(savedData.data.journal[index].quest) == "co_4" and tostring(savedData.data.journal[index].index) == "110" then
                colonyService = 6
            end

            --which cunt you side with
            if tostring(savedData.data.journal[index].quest) == "co_choice" and tostring(savedData.data.journal[index].index) == "40" then
                colonySide = 1
            end
            if tostring(savedData.data.journal[index].quest) == "co_choice" and tostring(savedData.data.journal[index].index) == "50" then
                colonySide = 2
            end

            --extra variables for guards
            if tostring(savedData.data.journal[index].quest) == "co_11" and tostring(savedData.data.journal[index].index) == "30" then
                aferguard = 1
            end
            if tostring(savedData.data.journal[index].quest) == "co_11" and tostring(savedData.data.journal[index].index) == "40" then
                gratianguard = 1
            end
            if tostring(savedData.data.journal[index].quest) == "co_11" and tostring(savedData.data.journal[index].index) == "50" then
                garnasguard = 1
            end
        end

    --set variables/execute scripts via console
    consoleColonyTimer = "startscript, ColonyTimer"
    consoleColonyState = "set ColonyState to " .. colonyState
    consoleColonySide = "set ColonySide to " .. colonySide
    consoleColonyService = "set ColonyService to " .. colonyService
    consoleColonyNord = "set ColonyNord to " .. colonyNord
    consoleAfer = "set aferguard to " .. aferguard
    consoleGratian = "set gratianguard to " .. gratianguard
    consoleGarnas = "set garnasguard to " .. garnasguard
    if colonyState > 0 then
        myMod.RunConsoleCommandOnPlayer(pid, consoleColonyTimer)
    end
    myMod.RunConsoleCommandOnPlayer(pid, consoleColonyState)
    myMod.RunConsoleCommandOnPlayer(pid, consoleColonySide)
    myMod.RunConsoleCommandOnPlayer(pid, consoleColonyService)
    myMod.RunConsoleCommandOnPlayer(pid, consoleColonyNord)
    myMod.RunConsoleCommandOnPlayer(pid, consoleAfer)
    myMod.RunConsoleCommandOnPlayer(pid, consoleGratian)
    myMod.RunConsoleCommandOnPlayer(pid, consoleGarnas)
end

return Methods
