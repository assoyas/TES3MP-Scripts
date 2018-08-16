local Methods = {}
Methods.ConsoleSpamPrevention = function(pid, refIndex, refId, cellDescription)
	local Name = refId.."-Spam"
	if Players[pid].StateSpam == nil then
		Players[pid].StateSpam = {}
	end
	if Players[pid].StateSpam[Name] == nil then
		Players[pid].StateSpam[Name] = 0
	else
		Players[pid].StateSpam[Name] = (Players[pid].StateSpam[Name] + 1)
		if Players[pid].StateSpam[Name] >= 5 then -- If the player gets 5 false object states for the same refid in that cell, delete it.
            myMod.LoadCell(cellDescription) -- make sure the cell is loaded
            tes3mp.InitializeEvent(pid)
            tes3mp.SetEventCell(cellDescription)
            local splitIndex = refIndex:split("-")
            tes3mp.SetObjectRefNumIndex(splitIndex[1])
            tes3mp.SetObjectMpNum(splitIndex[2])
            tes3mp.SetObjectRefId("")
            tes3mp.AddWorldObject()
            tes3mp.SendObjectDelete()
		end
	end
end

return Methods
