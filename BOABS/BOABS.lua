------------------
-- Version: 1.1 --
------------------

local Methods = {}
Methods.FindBoots = function(pid)
    local fade = nil
    if Players[pid].data.customVariables.BOABS == nil then
        Players[pid].data.customVariables.BOABS = false
    end
    if tableHelper.containsKeyValue(Players[pid].data.equipment, "refId", "boots of blinding speed[unique]", true) then
        if Players[pid].data.customVariables.BOABS == false then
            fade = true
            Players[pid].data.customVariables.BOABS = true
        end
    else
        if Players[pid].data.customVariables.BOABS == true then
            fade = false
            Players[pid].data.customVariables.BOABS = false
        end
    end
    if fade == true then
        myMod.RunConsoleCommandOnPlayer(pid, "FadeOut 1")
    elseif fade == false then
        myMod.RunConsoleCommandOnPlayer(pid, "FadeIn 1")
    end
end

return Methods
