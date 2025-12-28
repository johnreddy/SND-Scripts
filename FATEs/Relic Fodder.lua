--[=====[
[[SND Metadata]]
author: johnreddy
version: 0.9.0
description: Generic Relic Fodder Farming - Companion script for Fate Farming
plugin_dependencies:
- Lifestream
- vnavmesh
- TextAdvance
configs:
  FateMacro:
    description: Name of the primary fate macro script.
    default: ""
  NumberToFarm:
    description: How many of each relicFodder to farm?
    default: 1
  RelicFoddertarget:
    description: Select the relic fodder you want to farm FATEs for.
    default: "None"
    is_choice: true
    choices: ["None",
        "2.2 - Atma",
        "5.35 - Memory of the Dying",
        ]

[[End Metadata]]
--]=====]

--[[
RelicFodder farming script meant to be used with `Fate Farming.lua`. This will go down
the list of relicFodder farming zones and farm fates until you have 12 of the required
relicFodders in your inventory, then teleport to the next zone and restart the fate
farming script.

    -> 0.9.0    Copied from Zodiac Atma farming for starting

--#region Settings

--[[
********************************************************************************
*                                   Settings                                   *
********************************************************************************
]]

FateMacro = Config.Get("FateMacro")
NumberToFarm = Config.Get("NumberToFarm")
RelicFoddertarget = Config.Get("RelicFoddertarget")

--#endregion Settings

------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
**************************************************************
*  Code: Don't touch this unless you know what you're doing  *
**************************************************************
]]

ScriptName = "Relic Fodder"


RelicFodder =
{
    {zoneName = "", zoneId = 134, itemName = "Tortured Memory of the Dying", itemId = 31573},
    {zoneName = "", zoneId = 138, itemName = "Sorrowful Memory of the Dying", itemId = 31574},
    {zoneName = "", zoneId = 135, itemName = "Harrowing Memory of the Dying", itemId = 31575},
}

CharacterCondition = {
    casting=27,
    betweenAreas=45
}

function OnChatMessage()
    local message = TriggerData.message
    local patternToMatch = "%[Fate%] Loop Ended !!"

    if message and message:find(patternToMatch) then
        Dalamud.Log("["..ScriptName.."] OnChatMessage triggered")
        FateMacroRunning = false
        Dalamud.Log("["..ScriptName.."] FateMacro has stopped")
    end
end

function GetAetheryteName(ZoneID)
    local territoryData = Excel.GetRow("TerritoryType", ZoneID)

    if territoryData and territoryData.Aetheryte and territoryData.Aetheryte.PlaceName then
        return tostring(territoryData.Aetheryte.PlaceName.Name)
    end
end

function GetNextRelicFodderTable()
    for _, relicFodderTable in pairs(RelicFodder) do
        if Inventory.GetItemCount(relicFodderTable.itemId) < NumberToFarm then
            return relicFodderTable
        end
    end
end

function TeleportTo(aetheryteName)
    yield("/li "..aetheryteName)
    yield("/wait 1") -- wait for casting to begin
    while Svc.Condition[CharacterCondition.casting] do
        Dalamud.Log("["..ScriptName.."] Casting teleport...")
        yield("/wait 1")
    end
    yield("/wait 1") -- wait for that microsecond in between the cast finishing and the transition beginning
    while Svc.Condition[CharacterCondition.betweenAreas] do
        Dalamud.Log("["..ScriptName.."] Teleporting...")
        yield("/wait 1")
    end
    yield("/wait 1")
end

yield("/at y")
NextRelicFodderTable = GetNextRelicFodderTable()
while NextRelicFodderTable ~= nil do
    if not Player.IsBusy and not FateMacroRunning then
        if Inventory.GetItemCount(NextRelicFodderTable.itemId) >= NumberToFarm then
            NextRelicFodderTable = GetNextRelicFodderTable()
        elseif Svc.ClientState.TerritoryType ~= NextRelicFodderTable.zoneId then
            Dalamud.Log("["..ScriptName.."] Teleport to "..NextRelicFodderTable.zoneName)
            TeleportTo(GetAetheryteName(NextRelicFodderTable.zoneId))
        else
            Dalamud.Log("["..ScriptName.."] Starting FateMacro: "..FateMacro)
            yield("/snd run "..FateMacro)
            FateMacroRunning = true
        end
        while FateMacroRunning do
            yield("/wait 3")
        end
    end
    yield("/wait 1")
end
