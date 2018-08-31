------------------
-- Version: 1.1 --
------------------

-- play a random cliff racer sound at random times when a player is in the exterior
require("speechHelper")
require("time")
local Methods = {}
-- get sound path
local creature = "cliff racer"
local sounds = {"moan", "roar", "scream"}
math.randomseed(os.time()) -- make random seed, although probably unnecessary
local maxRoll = 60 -- defines the odds of playing the sound - 1/x chance

Methods.OnCellChange = function(pid) -- run when a player enters a new cell
    CRS.StopTimer(pid) -- stop the timer so we dont have multiple timers running
    if CRS.InWilderness(pid) then
        CRS.BeginTimer(pid)
    end
end

Methods.InWilderness = function(pid) -- function to check if player is in wilderness (i.e. cell ending with a number)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
        local cell = Players[pid].data.location.cell
        local splitCell = tonumber(string.sub(cell, -1))
        if splitCell ~= nil then
            return true
        else
            return false
        end
    else
        return false
    end
end

Methods.BeginTimer = function(pid) -- start a timer with 1 second duration
    local PlayerData = Players[pid]
    PlayerData.tid_CRS = tes3mp.CreateTimerEx("GenerateRandomNumber", time.seconds(1), "i", pid)
    tes3mp.StartTimer(PlayerData.tid_CRS)
end

Methods.StopTimer = function(pid) -- stop timer when switching cells
    local PlayerData = Players[pid]
    if PlayerData.tid_CRS ~= nil then
        tes3mp.StopTimer(PlayerData.tid_CRS)
    end
end

function GenerateRandomNumber(pid) -- generate a chance to trigger the sound
    math.random()
    local roll = math.random(1,maxRoll) -- roll between 1 and 60 by default
    if roll == maxRoll then
        CRS.GenerateSound(pid)
    end
    if CRS.InWilderness(pid) then
        CRS.BeginTimer(pid)
    end
end

Methods.GenerateSound = function(pid) -- play the sound if still in wilderness
    if CRS.InWilderness(pid) then
        math.random()
        local sound = math.random(1,3) -- we have three sounds to choose from, pick a random one
        local soundName = "\"".. creature .. " " .. sounds[sound] .. "\""
        myMod.RunConsoleCommandOnPlayer(pid, "playsound " .. soundName)
    end
end

return Methods
