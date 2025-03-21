--[[
Scrap file for pulling out of.  Convert/update functions and rename variables as you go

]]

--[[
********************************************************************************
*           Code: Don't touch this unless you know what you're doing           *
********************************************************************************
]]


FishTable =
{
    {
        fishName = "Fleeting Brand",
        fishId = 36473,
        baitName = "Versatile Lure",
        zoneId = 959,
        zoneName = "Mare Lamentorum",
        autohookPreset = "AH4_H4sIAAAAAAAACu1YTVPjOBD9K5TP8ZS/bXELGWCpCgxFwu5hag+K3U5UOFZGllnYKf77tGwrsROHTE0RigM3py29/tBT+3V+GsNS8hEtZDFK58bpT+M8p7MMhllmnEpRwsBQL8csh83LRL+6wicnIgPjVjAumHw2Tm20FudPcVYmkGzMav1LjXXNebxQYNWDo54qnCAaGJer6UJAseAZWmzL6iC/Dl1hkLCzwzoYzGhRLnUEnm15B0LQu3iWQSz3VARx7PYu53AUXCSMZlUg+SMIbeguHvQ5s50gIFtRe92ou0kNZ/wRzzKlWaHdX7Bicf4MRasQ/hak73cgA32W9AEmC5bKM8qqcihDoQ0TSeMHREWw5oR3cduopEG9pZJBHu9jHIYXbMME3XNyNJJg/8OIyppwOojt3c7WKbvN7umCZow+FBf0kQsF0DHo7NxB134HMVYY19uqZn03BkPYJprbCUCX94zNL+myqsMwn2cgCu1UcUptCy1vJ5sOVPSCWOdPUtDmfquDmfLJf3R1lcuSScbzS8pyXR8TqTsuBVxDUdA5ujaMgXFTBWHccOwCgxrheYUWVagevDEv5B/j3WIi0B+hYRp73tceq/ebeCYrvKOCZqNSCMjlG2W5hfpmufZGu5Nxr/dq1QUXMVS3DpdpulXGRFmb9mhjg6ypNJF8pS4+y+cTCbjDbmfZ0G0o3ia5NlwV7X3OfpSgcA3iOjQEyzMdElumF6SOSfzANS3iOb6b2mmUOAbijVkhv6XKB/L/e01klcD6ZtfZ7Yvxb/SPfSWDE7VCAd5wsaTZX5w/KAjddP4BWv1Wdox/fX+rhqnvc/OyXWplmrIliK0bf83y9Sv1EfuCMV7Tp7aNfMFG0UDW9fPsUDVDHdNECp63vs7Hd2+5LfdjmEOeUPH8AepSBfaVlwh14KTe1LETkLXfzWkczcXvVPwIzqeCrd65rqHvuGvPx6psx8n711a7xxW8RM30pCSHWqZ68DCVIEa0nC9QZS+VisJG29ecKx2OrauSaeqhJUBqLeCTXf3aFQOvKFElofXnVPfEO/hRMgEJepKlEnJKo/c1yuM3vnftb5/96rNfffarD9ad2pLRjokTOLHpzMBByQixSSIvMiPHBuLOXC+CmfHyr9aMzT8O39eGWjaihmzrRzfwQne/frzIACRmfHImaJ501K69t1hqArxKUKizGDU7lkg5+5Znz/cF3OcJiM2oq/9sUbuHS17mrYL3DcE+2R78XOXtK8/liCJi1mTdfNE29YxUtKVIKbbXTOm0Zuj3iX9gLvZx54f592Yzq/zxhKI2K8tIVbsqdHtmaSYV9VibN8t2L4DV4SekLtA4Sk0IrdT0EhxuZkCQpJAEbhTQgEYRTiC7/PP3Z3AHcy45K+A3qWf3MK+fXa/R6VXa9NOyl0WHafnJrv3s6pAr9KiTBkFiztw4ML04IiaxPcukgQWJ68dBQurmV7O2t32dmCe3pUAxfDKJURQX3Ync9jybBHFo2mGM7ZXYIbbXNDEpsZyZP6OEhIHx8gtuKGkNOxYAAA==",
        fishingSpots = {
            maxHeight = 35,
            waypoints = {
                { x=10.05, y=26.89, z=448.99 },
                { x=37.71, y=22.36, z=481.05 },
                { x=58.87, y=22.22, z=487.95 }, --orange balls
                { x=71.79, y=22.39, z=477.65 },
            },
            pointToFace = { x=37.71, y=22.36, z=1000 }
        },
        scripColor = "Purple",
        scripId = 38,
        collectiblesTurnInListIndex = 28
    }
}



CharacterCondition = {
    normal=1,
    mounted=4,
    gathering=6,
    casting=27,
    occupiedInEvent=31,
    occupiedInQuestEvent=32,
    occupied=33,
    boundByDutyDiadem=34,
    occupiedMateriaExtractionAndRepair=39,
    gathering42=42,
    fishing=43,
    betweenAreas=45,
    jumping48=48,
    occupiedSummoningBell=50,
    jumping61=61,
    betweenAreasForDuty=51,
    boundByDuty56=56,
    mounting57=57,
    mounting64=64,
    beingMoved=70,
    flying=77
}

--#region Fishing
function InterpolateCoordinates(startCoords, endCoords, n)
    local x = startCoords.x + n * (endCoords.x - startCoords.x)
    local y = startCoords.y + n * (endCoords.y - startCoords.y)
    local z = startCoords.z + n * (endCoords.z - startCoords.z)
    return {waypointX=x, waypointY=y, waypointZ=z}
end

function GetWaypoint(coords, n)
    local total_distance = 0
    local distances = {}

    -- Calculate distances between each pair of coordinates
    for i = 1, #coords - 1 do
        local dx = coords[i + 1].x - coords[i].x
        local dy = coords[i + 1].y - coords[i].y
        local dz = coords[i + 1].z - coords[i].z
        local distance = math.sqrt(dx * dx + dy * dy + dz * dz)
        table.insert(distances, distance)
        total_distance = total_distance + distance
    end

    -- Find the target distance
    local target_distance = n * total_distance

    -- Walk through the coordinates to find the target coordinates
    local accumulated_distance = 0
    for i = 1, #coords - 1 do
        if accumulated_distance + distances[i] >= target_distance then
            local remaining_distance = target_distance - accumulated_distance
            local t = remaining_distance / distances[i]
            return InterpolateCoordinates(coords[i], coords[i + 1], t)
        end
        accumulated_distance = accumulated_distance + distances[i]
    end

    -- If n is 1 (100%), return the last coordinate
    return { waypointX=coords[#coords].x, waypointY=coords[#coords].y, waypointZ=coords[#coords].z }
end

function SelectNewFishingHole()
    LogInfo("["..ThisScriptName.."] Selecting new fishing hole")

    -- if Achievement.fishingSpots.waypoints ~= nil then
    SelectedFishingSpot = GetWaypoint(Achievement.fishingSpots.waypoints, math.random())
    SelectedFishingSpot.waypointY = QueryMeshPointOnFloorY(
        SelectedFishingSpot.waypointX, Achievement.fishingSpots.maxHeight, SelectedFishingSpot.waypointZ, false, 50)

    SelectedFishingSpot.x = Achievement.fishingSpots.pointToFace.x
    SelectedFishingSpot.y = Achievement.fishingSpots.pointToFace.y
    SelectedFishingSpot.z = Achievement.fishingSpots.pointToFace.z
    -- else
    --     local n = math.random(1, #Achievement.fishingSpots)
    --     SelectedFishingSpot = Achievement.fishingSpots[n]
    -- end
    SelectedFishingSpot.startTime = os.clock()
    SelectedFishingSpot.lastStuckCheckPosition = {
        x=GetPlayerRawXPos(), y=GetPlayerRawYPos(), z=GetPlayerRawZPos()
    }
end

function RandomAdjustCoordinates(x, y, z, maxDistance)
    local angle = math.random() * 2 * math.pi
    local x_adjust = maxDistance * math.random()
    local z_adjust = maxDistance * math.random()

    local randomX = x + (x_adjust * math.cos(angle))
    local randomY = y + maxDistance
    local randomZ = z + (z_adjust * math.sin(angle))

    return randomX, randomY, randomZ
end

function TeleportToFishingZone()
    if not IsInZone(Achievement.zoneId) then
        TeleportTo(Achievement.closestAetheryte.aetheryteName)
    elseif not GetCharacterCondition(CharacterCondition.betweenAreas) then
        yield("/wait 3")
        SelectNewFishingHole()
        ResetHardAmissTime = os.clock()
        State = CharacterState.goToFishingHole
        LogInfo("["..ThisScriptName.."] GoToFishingHole")
    end
end



ResetHardAmissTime = os.clock()


--#region Movement





CharacterState = {
    ready = Ready,
    selectAchievement = SelectAchievement,
    teleportToFishingZone = TeleportToFishingZone,
    goToFishingHole = GoToFishingHole,
    extractMateria = ExecuteExtractMateria,
    repair = ExecuteRepair,
    fishing = Fishing,
    goToHubCity = GoToHubCity,
    buyDarkMatter = BuyDarkMatter,
    buyVersatileLure = BuyVersatileLure,
}
