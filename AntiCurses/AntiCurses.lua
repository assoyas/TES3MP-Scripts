cursedItemsDremora = {"ingred_cursed_daedras_heart_01","ingred_Dae_cursed_diamond_01",
"ebony broadsword_Dae_cursed","ingred_Dae_cursed_emerald_01",
"fiend spear_Dae_cursed","glass dagger_Dae_cursed",
"imperial helmet armor_Dae_curse","ingred_Dae_cursed_pearl_01",
"ingred_Dae_cursed_raw_ebony_01","ingred_Dae_cursed_ruby_01",
"light_com_Dae_cursed_candle_10"}
cursedItemsDremoraSpecial = {"gold_dae_cursed_001","gold_dae_cursed_005"}
cursedItemsGhosts = {"Silver Dagger_Hanin Cursed"}
cursedItemsDwemerCoin = {"misc_dwrv_cursed_coin00"}

local disableDremoras = true
local disableDremorasSpecial = true
local disableGhosts = true
local disableDwemerGhosts = true
local Methods = {}

Methods.CheckItem = function(pid, refId)
    local message
    local entity = 0
    local refIds = {}
    local cellDescription = Players[pid].data.location.cell
    if disableDremoras == true and entity == 0 then
        for index, item in pairs(cursedItemsDremora) do
            if string.lower(item) == string.lower(refId) then
                entity = 1
            end
        end
    end
    if disableDremorasSpecial == true and entity == 0 then
        for index, item in pairs(cursedItemsDremoraSpecial) do
            if string.lower(item) == string.lower(refId) then
                entity = 1
            end
        end
    end
    if disableGhosts == true and entity == 0 then
        for index, item in pairs(cursedItemsGhosts) do
            if string.lower(item) == string.lower(refId) then
                entity = 2
            end
        end
    end
    if disableDwemerGhosts == true and entity == 0 then
        for index, item in pairs(cursedItemsDwemerCoin) do
            if string.lower(item) == string.lower(refId) then
                entity = 3
            end
        end
    end
    if entity ~= 0 then
        Players[pid]:SaveCell()
        AntiCurses.RemoveEntities(pid, cellDescription, entity)
    end
end

Methods.RemoveEntities = function(pid, cellDescription, entity)
    tes3mp.ReadLastEvent()
    local found = 0
    local Entities = {}
    local message
    local creatureName
    local indexes = {}
    local i
    local i2 = 1
    local tmp = {}
    if entity == 1 then
        creatureName = "dremora_lord"
    elseif entity == 2 then
        creatureName =  "ancestor_ghost"
    elseif entity == 3 then
        creatureName = "dwarven ghost"
    else
        creatureName = "Todd Howard"
    end

    for index, value2 in pairs(LoadedCells[cellDescription].data.objectData) do
        if LoadedCells[cellDescription].data.objectData[index].refId == creatureName then
            indexes[i2] = index
            i2 = i2 + 1
        end
    end
    if indexes[1] ~= 0 then
        for i3 = 1,i2-1 do
            i = 1
            for word in string.gmatch(indexes[i3], '([^%-]+)') do
                tmp[i] = word
                i = i + 1
            end
            indexes[i3] = tmp[2]
        end
        table.sort(indexes)
        local removeId = indexes[i2-1]
        found = 1
        Entities[0] = removeId
        if found > 0 then
            for i,p in pairs(Players) do -- Do this for each player online
                for index2,a in pairs(Entities) do -- Sometimes more than one assassin spawns
                    tes3mp.InitializeEvent(p.pid)
                    tes3mp.SetEventCell(cellDescription)
                    tes3mp.SetObjectRefNumIndex(0)
                    tes3mp.SetObjectMpNum(a)
                    tes3mp.AddWorldObject() -- Add actor to packet
                    tes3mp.SendObjectDelete() -- Send Delete

                    if LoadedCells[cellDescription] ~= nil then

                        local refIndex = "0-" .. a
                        LoadedCells[cellDescription].data.objectData[refIndex] = nil
                        tableHelper.removeValue(LoadedCells[cellDescription].data.packets.spawn, refIndex)
                        tableHelper.removeValue(LoadedCells[cellDescription].data.packets.actorList, refIndex)
                        LoadedCells[cellDescription]:Save()
                    end
                end
            end
        end
    end
end

return Methods
