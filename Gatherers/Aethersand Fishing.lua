--[=====[
[[SND Metadata]]
author:  'johnreddy || Adapted from pot0to and Minnu'
version: 0.9.4b
description: Fishing for Aethersand
plugin_dependencies:
- AutoHook
- Lifestream
- vnavmesh
- YesAlready
configs:
    AethersandToFarm:
        description: Type of Aethersand to farm.
        is_choice: true
        default: "Levinchrome Aethersand"
        choices:
            - "Levinchrome Aethersand"
    Food:
        description: "Leave blank if you don't want to use any food. If its HQ include <hq> next to the name \"Baked Eggplant <hq>\"."
        default: "Nasi Goreng <HQ>"
    Potion:
        description: "Leave blank if you don't want to use any potions. If its HQ include <hq> next to the name \"Superior Spiritbond Potion <hq>\"."
        default: "Superior Spiritbond Potion <HQ>"
    MinInventoryFreeSlots:
        description: Minimum free inventory slots required to start turn-ins.
        default: 5
        min: 0
        max: 140
    SelfRepair:
        description: Automatically repair your own gear when durability is low.
        default: true
    BuyDarkMatter:
        description: Buy Dark Matter for self repair.
        default: true
    RepairThreshold:
        description: Durability percentage at which tools should be repaired.
        default: 20
        min: 0
        max: 100
    ExtractMateria:
        description: Automatically extract materia from fully spiritbonded gear.
        default: true
    MoveSpotsAfter:
        description: Number of minutes to fish one spot before moving to the next.
        default: 30
    ResetHardAmissAfter:
        description: Number of minutes to farm in current instance before teleporting away and back.
        default: 120

[[End Metadata]]
--]=====]

--[[
    -> 0.9.4b   Created BaitCheck.  Set default consumables. 
    -> 0.9.3    Fixed typos.  Made bait type variable
    -> 0.9.2    Added gsResetAmiss
    -> 0.9.1    Removed AutoRetainer
                Removed Scrip turnins and spending
                Moves utility functions and CharacterState functions
                Added initial header comments to functions
                Initial gsReduce function
    -> 0.9.0    Initial adaptation from https://github.com/MinnuVerse/SnD/blob/main/Gatherers/FishingGathererScrips.lua
                Change ScriptName logging to a variable
                Removed collectable turn-ins, Script fish

********************************************************************************
*                               Required Plugins                               *
********************************************************************************

1. AutoHook
2. VnavMesh
3. Lifestream
4. Teleporter
5. YesAlready: YesNo > ... (the 3 dots) > Auto Collectables https://github.com/PunishXIV/AutoHook/blob/main/AcceptCollectable.md

]]

--=========================== VARIABLES ==========================--

import("Systaem")
import("System.Numerics")

ScriptName="[AetherFishing]"

-------------------
--    General    --
-------------------
    
AethersandToFarm       = Config.Get("AethersandToFarm")
ItemToExchange         = Config.Get("ItemToExchange")
Food                   = Config.Get("Food")
Potion                 = Config.Get("Potion")
MinInventoryFreeSlots  = Config.Get("MinInventoryFreeSlots")
SelfRepair             = Config.Get("SelfRepair")
BuyDarkMatter          = Config.Get("BuyDarkMatter")
RepairThreshold        = Config.Get("RepairThreshold")
ExtractMateria         = Config.Get("ExtractMateria")
MoveSpotsAfter         = Config.Get("MoveSpotsAfter")
ResetHardAmissAfter    = Config.Get("ResetHardAmissAfter")


--============================ CONSTANT ==========================--

----------------------------
--    State Management    --
----------------------------

CharacterState = {}

CharacterCondition = {
    mounted                            = 4,
    gathering                          = 6,
    casting                            = 27,
    occupiedInQuestEvent               = 32,
    occupiedMateriaExtractionAndRepair = 39,
    fishing                            = 43,
    betweenAreas                       = 45,
    occupiedSummoningBell              = 50
}

-----------------
--    Items    --
-----------------


--------------------
--    Merchant    --
--------------------

FishingBaitMerchant = {
    npcName   = "Merchant & Mender",
    x         = -398,
    y         = 3,
    z         = 80,
    zoneId    = 129,
    aetheryte = "Limsa Lominsa",
    aethernet = { name = "Arcanists' Guild", x = -336, y = 12, z = 56 }
}

Mender = {
    npcName   = "Alistair",
    x         = -246.87,
    y         = 16.19,
    z         = 49.83
}

DarkMatterVendor = {
    npcName   = "Unsynrael",
    x         = -257.71,
    y         = 16.19,
    z         = 50.11,
    wait      = 0.08
}

------------------------
--    Collectables    --
------------------------

FishTable = {
    {
        fishName                    = "Purple Palate",
        fishId                      = 46249,
        baitName                    = "Versatile Lure",
        baitId                      = 29717,
        zoneName                    = "Kozuma'uka",
        zoneId                      = 1188,
        autoHookPreset              = "AH4_H4sIAAAAAAAACu1Yy27bOBT9FYNrcaAHqYd3rpu0wSRpEDvTRTELSryyiciSS1Fp08D/PqAk2pYj2U3aATqY7uxL8uhc8twH+YQmlSqmrFTlNF2g8RM6y1mcwSTL0FjJCiykBy9FDrtBboYuOBq7YWShGykKKdQjGjsWuijPviZZxYHvzHr+psG6KopkqcHqH67+VeP4oYXeredLCeWyyDgaO7bdQT4OXWNEQWeFfZLMdFmtBhwjjk0OGAVdRr4BKbIMEjWM4+yvck+TKiQXLKt3Jn8AaQzdyVbfxxzX96MD1rTL2u0MT+LiAdA4ZVlpPn8uyuXZI5TmZIhj00NI2oH0zNGye5gtRareMFFvhzaUxjBTLLkv0Zi2h+WHz3H3UUmLesOUgDwZEiBxbP/4OVEDJMU3mDLVyM9wOFzsHsjOnPJ8yTLB7stz9lBIDdAxGOc8q2u/haR4AInGjt6yvvjxw+c687sUTp3YG7F4x1b1Bk3yRQayNHS02Dgae4FNnvnZ+US42Vjo7KuSrJMHtlT1Ac6L2Re2vshVJZQo8ndM5GYjsWOhy0rCFZQlWwAaI2Sh65oTui5yQC3C4xoaufTgXRalejXejYQS+hkijAbGmy/W4zs+szUkSrJsWkkJufpJXh6g/jRfe9k+87j36/Ws80ImUEfnF7Y2h10buba2WdUJrFZZM1WsdYIQ+WKmYF2Lc+dlq76J/DnO7cM99+mLWMVMqHORZeWR8dsqLz9UBuEuF58r0MwQc8H2/cjFNAgTTFyP4ZhThhn1I5eFqUd9QBsLXYpSfUg1yxKNPz3VfPUWbJNIsz9DXv4FsmRKZDDSMzTgdSFXLHtfFPcawqS3j8Dq/9pegtrGXx3oJnW0g/uH1ZqaHSROEOlNbDFnShb5XjgPLJ+LFciDgL8S+XYIjV3yh20hXS375mp7d75Tzz+gZnt71C5hATln8vGHfXYjnaLvSnhbVO10M6+xnNjZLpiv969Zt9u9D3n2+HEJ+SRR4gEuOORKJLpC99HZQ/geJ3sWz6VYv5B2QF1vu/KVxDsYL6feLtcZYpIqkLc6FqdFlSvzue3QlFWLpboUK90mEOo1Q928YrukbT4r2TQj+sdenTW+XRdqwD09o0ZgUgflYNfkBTQifV3TYKOmG05TRUwg38LnSkjgM8VUpfsc3dEORPeJaH1p4HQm9or+mLpfJN+TOj0uyBcqbkBaHf04feo5Lp2hQz96Y9AE2ppSq3p/XaO1uxIaQdZXm8kDE5nWmpHaXu0B3wVOSIq5H3BM4iDBYZhynESO56exZ7uhgzbW82JDvJCGw8XmFvjoii0WhSp/yUrz71eD30HwvUHwI9nxVKD8To6/k+Ork6NDAg408nBEHAeTlNuYURrgKPFdOwkTgDhAm79NZ94+KH3aGpp8+ekJdRKn75JoOHHeVHKdweiGZUx1LyXOscKzbTl0IJmG666Eu5yD3D1cmJc0vXiy0sVjB9H3pEGjw9u6131xCTWpSqYsgVmmM2HrJI3oiecM/RjyyzzBzdZMQlpl71nODQv9VkH7eHSKb7t/nlUf8gWfF9MlJPfbc95777I7F/FXX0z1Ym1pO1qne9tsr5f6Z2PeTetrTjrX0DDmXhhgcHiIScxSHMVpjB07BM4DCilx61ag2wYE9pE7559sdFM9LqsfEHK/WF+tzn6VP3v/+7+JtTnG/45Y0zBgTsxCDAFNMSGphxmJfBxzQmgchIlHvTo1N7gtxbfzER4pWK1HeDQBtQQ5wqPDjLv3Fd+n3E5ciu3UTzFhuhSknGKwuQ0kpWHgeGjzD5+8M2i8GAAA",
        fishingSpots = {
            maxHeight               = 22, -- max of the listed waypoints, rounded up
            waypoints = {
                { x =  134.529, y =  21.712, z =  -77.222 },
                { x =  116.637, y =  21.712, z =  -75.389 },
                { x =  106.360, y =  21.576, z =  -65.314 },
                { x =   87.901, y =  21.576, z =  -69.022 },
                { x =   80.672, y =  21.891, z =  -80.141 },
                { x =    8.948, y =  21.891, z =  -79.512 },
            },
            pointToFace             = { x = 71.739, y = 21.891, z = 10000 },
        },
        Aethersand                  = "Levinchrome Aethersand",
        AethersandItemID            = 46246,
        AmissResetZoneName          = "Tuliyollal",
        AmissResetZoneID            = 1185,
    },
}


--[[
   Action Functions
  ]]

--[[ Mount ]]
function Mount()
    local mountActionId = 9
    Dalamud.Log(string.format("%s Using Mount Roulette...", ScriptName))
    repeat
        Actions.ExecuteGeneralAction(mountActionId)
        yield("/wait 1")
    until Svc.Condition[CharacterCondition.mounted]
end

--[[ Dismount ]]
function Dismount()
    local dismountActionId = 23
    repeat
        Actions.ExecuteGeneralAction(dismountActionId)
        yield("/wait 1")
    until not Svc.Condition[CharacterCondition.mounted]
end

--[[ CastFishing ]]
function CastFishing()
    local castFishingActionId = 289
    Actions.ExecuteAction(castFishingActionId, ActionType.Action)
end

--[[ QuitFishing ]]
function QuitFishing()
    local quitFishingActionId = 299
    Actions.ExecuteAction(quitFishingActionId, ActionType.Action)
end


--[[
   Utility Functions
  ]]

--[[ WaitForPlayer ]]
function WaitForPlayer()
    Dalamud.Log(string.format("%s Waiting for player...", ScriptName))
    repeat
        yield("/wait 0.1")
    until Player.Available and not Player.IsBusy
    yield("/wait 0.1")
end

--[[ GetAetheryteName ]]
function GetAetheryteName(zoneId)
    local territoryData = Excel.GetRow("TerritoryType", zoneId)

    if territoryData and territoryData.Aetheryte and territoryData.Aetheryte.PlaceName then
        return tostring(territoryData.Aetheryte.PlaceName.Name)
    else
        return nil
    end
end

--[[ TeleportTo ]]
function TeleportTo(aetheryteName)
    IPC.Lifestream.ExecuteCommand(aetheryteName)
    yield("/wait 1")
    while Svc.Condition[CharacterCondition.casting] do
        yield("/wait 1")
    end
    yield("/wait 1")
    while Svc.Condition[CharacterCondition.betweenAreas] do
        yield("/wait 1")
    end
    yield("/wait 1")
end

--[[ OnChatMessage ]]
function OnChatMessage()
    local message = TriggerData.message
    local patternToMatch = "The fish sense something amiss. Perhaps it is time to try another location."

    if message and message:find(patternToMatch) then
        Dalamud.Log(string.format("%s OnChatMessage triggered for Fish sense..!!", ScriptName))
        State = CharacterState.gsFishSense
        Dalamud.Log(string.format("%s State Changed → FishSense", ScriptName))
    end
end

--[[ NeedsRepair ]]
function NeedsRepair(repairThreshold)
    local repairList = Inventory.GetItemsInNeedOfRepairs(repairThreshold)
    local needsRepair = repairList.Count > 0
    Dalamud.Log(string.format("%s Items below %d%% durability: %s", ScriptName, repairThreshold, needsRepair and repairList.Count or "None"))
    return needsRepair
end

--[[ CanExtractMateria ]]
function CanExtractMateria()
    local bondedItems = Inventory.GetSpiritbondedItems()
    local count = (bondedItems and bondedItems.Count) or 0
    Dalamud.Log(string.format("%s Found %d spiritbonded items.", ScriptName, count))
    return count
end

--[[ HasStatusId ]]
function HasStatusId(statusId)
    local statusList = Player.Status

    if not statusList then
        return false
    end

    for i = 0, statusList.Count - 1 do
        local status = statusList:get_Item(i)
        if status and status.StatusId == statusId then
            return true
        end
    end

    return false
end

--[[ GetDistanceToPoint ]]
function GetDistanceToPoint(dX, dY, dZ)
    local player = Svc.ClientState.LocalPlayer
    if not player or not player.Position then
        Dalamud.Log(string.format("%s GetDistanceToPoint: Player position unavailable.", ScriptName))
        return math.huge
    end

    local px = player.Position.X
    local py = player.Position.Y
    local pz = player.Position.Z

    local dx = dX - px
    local dy = dY - py
    local dz = dZ - pz

    local distance = math.sqrt(dx * dx + dy * dy + dz * dz)
    return distance
end

--[[ DistanceBetween ]]
function DistanceBetween(px1, py1, pz1, px2, py2, pz2)
    local dx = px2 - px1
    local dy = py2 - py1
    local dz = pz2 - pz1

    local distance = math.sqrt(dx * dx + dy * dy + dz * dz)
    return distance
end


--[[
   Fishing Functions
  ]]

--[[ InterpolateCoordinates ]]
function InterpolateCoordinates(startCoords, endCoords, n)
    local x = startCoords.x + n * (endCoords.x - startCoords.x)
    local y = startCoords.y + n * (endCoords.y - startCoords.y)
    local z = startCoords.z + n * (endCoords.z - startCoords.z)
    return { waypointX = x, waypointY = y, waypointZ = z }
end

--[[ GetWaypoint ]]
function GetWaypoint(coords, n)
    local total_distance = 0
    local distances = {}

    for i = 1, #coords - 1 do
        local dx = coords[i + 1].x - coords[i].x
        local dy = coords[i + 1].y - coords[i].y
        local dz = coords[i + 1].z - coords[i].z
        local distance = math.sqrt(dx * dx + dy * dy + dz * dz)
        table.insert(distances, distance)
        total_distance = total_distance + distance
    end

    local target_distance = n * total_distance

    local accumulated_distance = 0
    for i = 1, #coords - 1 do
        if accumulated_distance + distances[i] >= target_distance then
            local remaining_distance = target_distance - accumulated_distance
            local t = remaining_distance / distances[i]
            return InterpolateCoordinates(coords[i], coords[i + 1], t)
        end
        accumulated_distance = accumulated_distance + distances[i]
    end

    return { waypointX = coords[#coords].x, waypointY = coords[#coords].y, waypointZ = coords[#coords].z }
end


--[[ SelectNewFishingHole ]]
function SelectNewFishingHole()
    logged = false
    SelectedFishingSpot = GetWaypoint(SelectedFish.fishingSpots.waypoints, math.random())
    local point = IPC.vnavmesh.PointOnFloor(Vector3(SelectedFishingSpot.waypointX, SelectedFish.fishingSpots.maxHeight, SelectedFishingSpot.waypointZ), false, 50)
    SelectedFishingSpot.waypointY = (point and point.Y) or SelectedFishingSpot.waypointY or 0

    SelectedFishingSpot.x = SelectedFish.fishingSpots.pointToFace.x
    SelectedFishingSpot.y = SelectedFish.fishingSpots.pointToFace.y
    SelectedFishingSpot.z = SelectedFish.fishingSpots.pointToFace.z

    SelectedFishingSpot.startTime = os.clock()
    SelectedFishingSpot.lastStuckCheckPosition = { x = Player.Entity.Position.X, y = Player.Entity.Position.Y, z = Player.Entity.Position.Z }
end

--[[ RandomAdjustCoordinates ]]
function RandomAdjustCoordinates(x, y, z, maxDistance)
    local angle = math.random() * 2 * math.pi
    local distance = maxDistance * math.random()

    local randomX = x + distance * math.cos(angle)
    local randomY = y + maxDistance
    local randomZ = z + distance * math.sin(angle)

    return randomX, randomY, randomZ
end

--[[ FoodCheck ]]
function FoodCheck()
    if not HasStatusId(48) and Food ~= "" then
        yield("/item " .. Food)
    end
end

--[[ BaitCheck ]]
function BaitCheck()
    if Inventory.GetItemCount(SelectedFish.baitId) == 0 then
        Dalamud.Log(string.format("%s BaitCheck found no %s, return to gsReady for bait acquisition", ScriptName))
    else
        if not Addons.GetAddon("Bait").Ready then
            yield('/action "Bait"')
            yield("/wait 0.2")
            local looper = 0
            while not Addons.GetAddon("Bait").Ready and looper < 50 do
                yield("/wait 0.1")
                looper = looper + 1
            end
            if not Addons.GetAddon("Bait").Ready then
                Dalamud.Log(string.format("%s Not able to open bait window", ScriptName))
            end
        end
        yield(string.format("/callback Bait true %d false", SelectedFish.baitId))    
    end
    if Addons.GetAddon("Bait").Ready then
        yield("/callback Bait true -1")
        yield("/wait 0.1")
    end
end


--[[ PotionCheck ]]
function PotionCheck()
    if not HasStatusId(49) and Potion ~= "" then
        yield("/item " .. Potion)
    end
end

--[[ SelectFishTable ]]
function SelectFishTable()
    for _, fishTable in ipairs(FishTable) do
        if AethersandToFarm == fishTable.Aethersand then
            return fishTable
        end
    end
    Dalamud.Log(string.format("%s No matching fish table found for scrip color: %s", ScriptName, AethersandToFarm))
    return nil
end


--[[
   Charracter State Functions
  ]]

--[[ CharacterState.gsFishsense ]]
function CharacterState.gsFishSense()
    if Svc.Condition[CharacterCondition.gathering] or Svc.Condition[CharacterCondition.fishing] then
        QuitFishing()
    end

    WaitForPlayer()
    State = CharacterState.gsTeleportFishingZone
    Dalamud.Log(string.format("%s State Changed → TeleportFishingZone", ScriptName))
end

--[[ CharacterState.gsTeleportFishingZone ]]
function CharacterState.gsTeleportFishingZone()
    if Svc.ClientState.TerritoryType ~= SelectedFish.zoneId then
        local aetheryteName = GetAetheryteName(SelectedFish.zoneId)
        if aetheryteName then
            TeleportTo(aetheryteName)
        end
    elseif Player.Available and not Player.IsBusy then
        yield("/wait 1")
        SelectNewFishingHole()
        ResetHardAmissTime = os.clock()
        State = CharacterState.gsGoToFishingHole
        Dalamud.Log(string.format("%s  State Changed → GoToFishingHole", ScriptName))
    end
end

--[[ CharacterState.gsGoToFishingHole ]]
function CharacterState.gsGoToFishingHole()
    if Svc.ClientState.TerritoryType ~= SelectedFish.zoneId then
        State = CharacterState.gsTeleportFishingZone
        Dalamud.Log(string.format("%s State Changed → TeleportFishingZone", ScriptName))
        return
    end

    local now = os.clock()
    if now - SelectedFishingSpot.startTime > 10 then
        SelectedFishingSpot.startTime = now
        local x = Player.Entity.Position.X
        local y = Player.Entity.Position.Y
        local z = Player.Entity.Position.Z

        local lastStuckCheckPosition = SelectedFishingSpot.lastStuckCheckPosition

        if lastStuckCheckPosition and lastStuckCheckPosition.x and lastStuckCheckPosition.y and lastStuckCheckPosition.z then
            if GetDistanceToPoint(lastStuckCheckPosition.x, lastStuckCheckPosition.y, lastStuckCheckPosition.z) < 2 then
                Dalamud.Log(string.format("%s Stuck in same spot for over 10 seconds.", ScriptName))
                if IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning() then
                    IPC.vnavmesh.Stop()
                end
                local rX, rY, rZ = RandomAdjustCoordinates(x, y, z, 20)
                if rX and rY and rZ then
                    IPC.vnavmesh.PathfindAndMoveTo(Vector3(rX, rY, rZ), true)
                    while IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning() do
                        yield("/wait 1")
                    end
                end
                return
            end
        end
        SelectedFishingSpot.lastStuckCheckPosition = { x = x, y = y, z = z }
    end

    local distanceToWaypoint = GetDistanceToPoint(SelectedFishingSpot.waypointX, Player.Entity.Position.Y, SelectedFishingSpot.waypointZ)
    if distanceToWaypoint > 10 then
        if not Svc.Condition[CharacterCondition.mounted] then
            Mount()
            State = CharacterState.gsGoToFishingHole
            Dalamud.Log(string.format("%s State Changed → GoToFishingHole", ScriptName))
        elseif not (IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning()) then
            Dalamud.Log(string.format("%s Moving to waypoint: (%.2f, %.2f, %.2f)", ScriptName, SelectedFishingSpot.waypointX, SelectedFishingSpot.waypointY, SelectedFishingSpot.waypointZ))
            IPC.vnavmesh.PathfindAndMoveTo(Vector3(SelectedFishingSpot.waypointX, SelectedFishingSpot.waypointY, SelectedFishingSpot.waypointZ), true)
            while IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning() do
                yield("/wait 1")
            end
        end
        yield("/wait 1")
        return
    end

    if Svc.Condition[CharacterCondition.mounted] then
        Dismount()
    end

    State = CharacterState.gsFishing
    Dalamud.Log(string.format("%s State Changed → Fishing", ScriptName))
end

--[[ CharacterState.gsFishing ]]
function CharacterState.gsFishing()
    if Inventory.GetItemCount(SelectedFish.baitId) == 0 then
        State = CharacterState.gsBuyFishingBait
        Dalamud.Log(string.format("%s State Changed → BuyFishingBait", ScriptName))
        return
    end

    if Inventory.GetFreeInventorySlots() <= MinInventoryFreeSlots then
        Dalamud.Log(string.format("%s Not enough inventory space", ScriptName))
        if Svc.Condition[CharacterCondition.gathering] then
            QuitFishing()
            yield("/wait 1")
        else
            State = CharacterState.gsReduce
            Dalamud.Log(string.format("%s State Changed → Reduce", ScriptName))
        end
        return
    end

    if os.clock() - ResetHardAmissTime > (ResetHardAmissAfter * 60) then
        if Svc.Condition[CharacterCondition.gathering] then
            if not Svc.Condition[CharacterCondition.fishing] then
                QuitFishing()
                yield("/wait 1")
            end
        else
            State = CharacterState.gsResetAmiss
            Dalamud.Log(string.format("%s State Changed → Forced teleport away to avoid hard amiss", ScriptName))
        end
        return
    elseif os.clock() - SelectedFishingSpot.startTime > (MoveSpotsAfter * 60) then
        if not logged then
            Dalamud.Log(string.format("%s Switching fishing spots", ScriptName))
            logged = true
        end
        if Svc.Condition[CharacterCondition.gathering] then
            if not Svc.Condition[CharacterCondition.fishing] then
                QuitFishing()
                yield("/wait 1")
            end
        else
            SelectNewFishingHole()
            State = CharacterState.gsReady
            Dalamud.Log(string.format("%s State Changed → Timeout Ready", ScriptName))
        end
        return
    elseif Svc.Condition[CharacterCondition.gathering] then
        if (IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning()) then
            IPC.vnavmesh.Stop()
        end
        yield("/wait 1")
        return
    end

    local now = os.clock()
    if now - SelectedFishingSpot.startTime > 10 then
        local x = Player.Entity.Position.X
        local y = Player.Entity.Position.Y
        local z = Player.Entity.Position.Z

        local lastStuckCheckPosition = SelectedFishingSpot.lastStuckCheckPosition

        if GetDistanceToPoint(lastStuckCheckPosition.x, lastStuckCheckPosition.y, lastStuckCheckPosition.z) < 2 then
            Dalamud.Log(string.format("%s Stuck in same spot for over 10 seconds.", ScriptName))
            if IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning() then
                IPC.vnavmesh.Stop()
            end
            SelectNewFishingHole()
            State = CharacterState.gsReady
            Dalamud.Log(string.format("%s State Changed → Stuck Ready", ScriptName))
            return
        else
            SelectedFishingSpot.lastStuckCheckPosition = { x = x, y = y, z = z }
        end
    end

    if not IPC.vnavmesh.PathfindInProgress() and not IPC.vnavmesh.IsRunning() then
        local genericListType = Type.GetType("System.Collections.Generic.List`1[System.Numerics.Vector3]")
        local vectorList = Activator.CreateInstance(genericListType)
        local vector = Vector3(SelectedFishingSpot.x, SelectedFishingSpot.y, SelectedFishingSpot.z)
        vectorList:Add(vector)
        IPC.vnavmesh.MoveTo(vectorList, false)
        return
    end

    if IPC.vnavmesh.PathfindInProgress() and IPC.vnavmesh.IsRunning() then
        yield("/wait 0.5")
    end

    CastFishing()
    yield("/wait 0.5")
end

--[[ CharacterState.gsBuyFishingBait ]]
function CharacterState.gsBuyFishingBait()
    if Inventory.GetItemCount(SelectedFish.baitId) >= 1 then
        if Addons.GetAddon("Shop").Ready then
            yield("/callback Shop true -1")
        else
            State = CharacterState.gsGoToFishingHole
            Dalamud.Log(string.format("%s State Changed → GoToFishingHole", ScriptName))
        end
        return
    end

    if Svc.ClientState.TerritoryType ~= FishingBaitMerchant.zoneId then
        TeleportTo(FishingBaitMerchant.aetheryte)
        return
    end

    local distanceToMerchant = GetDistanceToPoint(FishingBaitMerchant.x, FishingBaitMerchant.y, FishingBaitMerchant.z)
    local distanceViaAethernet = DistanceBetween(FishingBaitMerchant.aethernet.x, FishingBaitMerchant.aethernet.y, FishingBaitMerchant.aethernet.z, FishingBaitMerchant.x, FishingBaitMerchant.y, FishingBaitMerchant.z)

    if distanceToMerchant > distanceViaAethernet + 20 then
        if not IPC.Lifestream.IsBusy() then
            TeleportTo(FishingBaitMerchant.aethernet.name)
        end
        return
    end

    if Addons.GetAddon("TeleportTown").Ready then
        yield("/callback TeleportTown false -1")
        return
    end

    if distanceToMerchant > 5 then
        if not IPC.vnavmesh.PathfindInProgress() and not IPC.vnavmesh.IsRunning() then
            IPC.vnavmesh.PathfindAndMoveTo(Vector3(FishingBaitMerchant.x, FishingBaitMerchant.y, FishingBaitMerchant.z), false)
        end
        return
    end

    if IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning() then
        IPC.vnavmesh.Stop()
        return
    end

    local baitMerchant = Entity.GetEntityByName(FishingBaitMerchant.npcName)
    if not Entity.Player.Target or Entity.Player.Target.Name ~= FishingBaitMerchant.npcName then
        if baitMerchant then
            baitMerchant:SetAsTarget()
        end
        return
    end

    if Addons.GetAddon("SelectIconString").Ready then
        yield("/callback SelectIconString true 0")
    elseif Addons.GetAddon("SelectYesno").Ready then
        yield("/callback SelectYesno true 0")
    elseif Addons.GetAddon("Shop").Ready then
        -- #TODO Change this to be variable based on the target bait
        yield("/callback Shop true 0 3 99 0")
    elseif baitMerchant then
        baitMerchant:Interact()
    end
end

--[[ CharacterState.gsReduce ]]
function CharacterState.gsReduce()
    if Inventory.GetCollectableItemCount(SelectedFish.fishId, 1) > 0 then
        if Addons.GetAddon("PurifyItemSelector").Ready then
            if Addons.GetAddon("PurifyAutoDialog").Ready then
                yield("/wait 1")
                return
            else
                if Addons.GetAddon("PurifyResult").Ready then
                    yield("/click PurifyResult Automatic")
                    yield("/wait 1")
                    return
                else
                    Dalamud.Log(string.format("%s Initiating Aetherial Reduction", ScriptName))
                    yield("/callback PurifyItemSelector true 12 0")
                    yield("/wait 1")
                    return
                end
            end
        else
            yield('/action "Aetherial Reduction"')
            yield("/wait 1")
            return
        end
    else
        if Addons.GetAddon("PurifyItemSelector").Ready then
            yield("/callback PurifyItemSelector true -1 0")
            yield("/wait 1")
            return
        end
        if Addons.GetAddon("PurifyResult").Ready then
            yield("/click PurifyResult Close")
            yield("/wait 1")
            return
        end
        if Addons.GetAddon("PurifyAutoDialog").Ready then
            yield("/click PurifyAutoDialog CancelExit")
            yield("/wait 1")
            return
        end
        Dalamud.Log(string.format("%s State Changed Reduce → Ready", ScriptName))
        State = CharacterState.gsReady
        return
    end
end

--[[ CharacterState.gsResetAmiss ]]
function CharacterState.gsResetAmiss()
    if Svc.ClientState.TerritoryType == SelectedFish.AmissResetZoneID then
        Dalamud.Log(string.format("%s State changed ResetAmiss → Ready", ScriptName))
        State = CharacterState.gsReady
        return
    else
        Dalamud.Log(string.format("%s Teleport to %s to hard reset fish amiss sense", ScriptName, SelectedFish.AmissResetZoneName))
        TeleportTo(SelectedFish.AmissResetZoneName)
        return
    end
end
        

--[[ CharacterState.gsRepair ]]
function CharacterState.gsRepair()
    if Addons.GetAddon("SelectYesno").Ready then
        yield("/callback SelectYesno true 0")
        return
    end

    if Addons.GetAddon("Repair").Ready then
        if not NeedsRepair(RepairThreshold) then
            yield("/callback Repair true -1")
        else
            yield("/callback Repair true 0")
        end
        return
    end

    if Svc.Condition[CharacterCondition.occupiedMateriaExtractionAndRepair] then
        Dalamud.Log(string.format("%s Repairing...", ScriptName))
        yield("/wait 1")
        return
    end

    local hawkersAlleyAethernetShard = { x = -213.95, y = 15.99, z = 49.35 }

    if SelfRepair then
        if Inventory.GetItemCount(33916) > 0 then
            if NeedsRepair(RepairThreshold) then
                if not Addons.GetAddon("Repair").Ready then
                    local repairActionId = 6
                    Actions.ExecuteGeneralAction(repairActionId)
                end
            else
                State = CharacterState.gsReady
                Dalamud.Log(string.format("%s State Changed → Ready", ScriptName))
            end

        elseif BuyDarkMatter then
            if Svc.ClientState.TerritoryType ~= 129 then
                Dalamud.Log(string.format("%s Teleporting to Limsa to buy Dark Matter.", ScriptName))
                TeleportTo("Limsa Lominsa Lower Decks")
                return
            end

            local npcVendor = Entity.GetEntityByName(DarkMatterVendor.npcName)
            if GetDistanceToPoint(DarkMatterVendor.x, DarkMatterVendor.y, DarkMatterVendor.z) > (DistanceBetween(hawkersAlleyAethernetShard.x, hawkersAlleyAethernetShard.y, hawkersAlleyAethernetShard.z,DarkMatterVendor.x, DarkMatterVendor.y, DarkMatterVendor.z) + 10) then
                TeleportTo("Hawkers' Alley")
                yield("/wait 1")
            elseif Addons.GetAddon("TeleportTown").Ready then
                yield("/callback TeleportTown false -1")
            elseif GetDistanceToPoint(DarkMatterVendor.x, DarkMatterVendor.y, DarkMatterVendor.z) > 5 then
                if not (IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning()) then
                    IPC.vnavmesh.PathfindAndMoveTo(Vector3(DarkMatterVendor.x, DarkMatterVendor.y, DarkMatterVendor.z), false)
                end
            else
                if not Entity.Player.Target or Entity.Player.Target.Name ~= DarkMatterVendor.npcName then
                    if npcVendor then
                        npcVendor:SetAsTarget()
                    end
                elseif not Svc.Condition[CharacterCondition.occupiedInQuestEvent] then
                    if npcVendor then
                        npcVendor:Interact()
                    end
                elseif Addons.GetAddon("SelectYesno").Ready then
                    yield("/callback SelectYesno true 0")
                elseif Addons.GetAddon("Shop").Ready then
                    yield("/callback Shop true 0 40 99")
                end
            end

        else
            Dalamud.Log(string.format("%s SelfRepair disabled. Using Limsa Mender instead.", ScriptName))
            SelfRepair = false
        end

    else
        if NeedsRepair(RepairThreshold) then
            if Svc.ClientState.TerritoryType ~= 129 then
                Dalamud.Log(string.format("%s Teleporting to Limsa for Mender.", ScriptName))
                TeleportTo("Limsa Lominsa Lower Decks")
                return
            end

            local npcMender = Entity.GetEntityByName(Mender.npcName)
            if GetDistanceToPoint(Mender.x, Mender.y, Mender.z) > (DistanceBetween(hawkersAlleyAethernetShard.x, hawkersAlleyAethernetShard.y, hawkersAlleyAethernetShard.z, Mender.x, Mender.y, Mender.z) + 10) then
                TeleportTo("Hawkers' Alley")
                yield("/wait 1")
            elseif Addons.GetAddon("TeleportTown").Ready then
                yield("/callback TeleportTown false -1")
            elseif GetDistanceToPoint(Mender.x, Mender.y, Mender.z) > 5 then
                if not (IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning()) then
                    IPC.vnavmesh.PathfindAndMoveTo(Vector3(Mender.x, Mender.y, Mender.z), false)
                end
            else
                if not Entity.Player.Target or Entity.Player.Target.Name ~= Mender.npcName then
                    if npcMender then
                        npcMender:SetAsTarget()
                    end
                elseif not Svc.Condition[CharacterCondition.occupiedInQuestEvent] then
                    if npcMender then
                        npcMender:Interact()
                    end
                end
            end
        else
            State = CharacterState.gsReady
            Dalamud.Log(string.format("%s State Changed → Ready", ScriptName))
        end
    end
end

--[[ CharacterState.gsExtractMateria ]]
function CharacterState.gsExtractMateria()
    if Svc.Condition[CharacterCondition.mounted] then
        Dismount()
        return
    end

    if Svc.Condition[CharacterCondition.occupiedMateriaExtractionAndRepair] then
        return
    end

    if CanExtractMateria() > 0 and Inventory.GetFreeInventorySlots() > 1 then
        if not Addons.GetAddon("Materialize").Ready then
            local extractionActionId = 14
            Actions.ExecuteGeneralAction(extractionActionId)
            yield("/wait 1")
            return
        end

        if Addons.GetAddon("MaterializeDialog").Ready then
            yield("/callback MaterializeDialog true 0")
        else
            yield("/callback Materialize true 2 0")
        end
    else
        if Addons.GetAddon("Materialize").Ready then
            yield("/callback Materialize true -1")
        else
            State = CharacterState.gsReady
            Dalamud.Log(string.format("%s State Changed → Ready", ScriptName))
        end
    end
end

--[[ CharacterState.gsReady ]]
function CharacterState.gsReady()
    FoodCheck()
    PotionCheck()
    BaitCheck()

    if not Player.Available then
        return

    elseif RepairThreshold > 0 and NeedsRepair(RepairThreshold) and (SelfRepair and Inventory.GetItemCount(33916) > 0) then
        State = CharacterState.gsRepair
        Dalamud.Log(string.format("%s State Changed → Repair", ScriptName))

    elseif ExtractMateria and CanExtractMateria() > 0 and Inventory.GetFreeInventorySlots() > 1 then
        State = CharacterState.gsExtractMateria
        Dalamud.Log(string.format("%s State Changed → ExtractMateria", ScriptName))

    elseif Inventory.GetFreeInventorySlots() <= MinInventoryFreeSlots and Inventory.GetCollectableItemCount(SelectedFish.fishId, 1) > 0 then
        State = CharacterState.gsReduce
        Dalamud.Log(string.format("%s State Changed → Reduce", ScriptName))

    elseif Inventory.GetItemCount(SelectedFish.baitId) == 0 then
        State = CharacterState.gsBuyFishingBait
        Dalamud.Log(string.format("%s State Changed → BuyFishingBait", ScriptName))

    else
        State = CharacterState.gsGoToFishingHole
        Dalamud.Log(string.format("%s State Changed → GoToFishingHole", ScriptName))
    end
end

--=========================== EXECUTION ==========================--
--[[
List of CharacterStates:
#TODO Document
  - gsFishSense
    Use OnChatMessage trigger to force relocation when seeing "fish sense something amiss".
  - gsTeleportFishingZone
    Teleport to the zone for fishing using "TeleportTo" function
  - gsGoToFishingHole
    Use vnavmesh to move to a semi-random location for fishing
  - gsFishing
    Do the fishing until hitting minimum free inventory slots.
  - gsBuyFishingBait
    Go buy the bait if needed
  - gsRepair
  - gsExtractMateria
  - gsResetAmiss
    Select place to teleport to and go there to reset hard amiss timer
  - gsReduce
    Reduce all items capable of Aetherial Reduction "Purify"
  - gsReady

    
]]


local logged = false
ResetHardAmissTime = os.clock()

LastStuckCheckTime = os.clock()
LastStuckCheckPosition = {
    x = Player.Entity.Position.X,
    y = Player.Entity.Position.Y,
    z = Player.Entity.Position.Z
}

SelectedFish = SelectFishTable()

if not SelectedFish then
    yield(string.format("/echo %s No fish table for %s. Stopping.", ScriptName, AethersandToFarm))
    Dalamud.Log(string.format("%s No fish table for %s. Stopping.", ScriptName, AethersandToFarm))
    yield("/snd stop all")
end

if Svc.ClientState.TerritoryType == SelectedFish.zoneId then
    Dalamud.Log(string.format("%s In fishing zone already. Selecting new fishing hole.", ScriptName))
    SelectNewFishingHole()
end

IPC.AutoHook.SetPluginState(true)
IPC.AutoHook.DeleteAllAnonymousPresets()
IPC.AutoHook.CreateAndSelectAnonymousPreset(SelectedFish.autoHookPreset)

if Player.Job.Id ~= 18 then
    Dalamud.Log(string.format("%s Switching to Fisher.", ScriptName))
    yield("/gs change Fisher")
    yield("/wait 1")
end

State = CharacterState.gsReady
Dalamud.Log(string.format("%s State Changed → Ready", ScriptName))

while true do
    State()
    yield("/wait 0.1")
end

--============================== END =============================--
