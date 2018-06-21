Methods = {}
Methods.findBoots = function(pid)
    local fade = false
    local consoleCommand
    for index, item in pairs(Players[pid].data.equipment) do
        if tableHelper.containsKeyValue(Players[pid].data.equipment, "refId", "boots of blinding speed[unique]", true) then
            fade = true
        else
            fade = false
        end
    end
    if fade == true then
        consoleCommand = "FadeOut 1"
    else
        consoleCommand = "FadeIn 1"
    end
    myMod.RunConsoleCommandOnPlayer(pid, consoleCommand)
end

return Methods
