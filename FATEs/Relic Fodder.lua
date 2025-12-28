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
    description: "How many of each relicFodder to farm?  Generally atma 1, 5.35 memories: 20, 5.45 memories: 18, demiatma: 6"
    default: 1
  RelicFodderTarget:
    description: Select the relic fodder you want to farm FATEs for.
    default: "None"
    is_choice: true
    choices: ["None",
        "2.2 - Atma - Up in Arms",
        "5.35 - Memories - For Want of a Memory",
        "5.45 - Memories - The Resistance Remembers",
        "7.25 - Demiatma - Arcane Artistry"]
[[End Metadata]]
--]=====]

--[[
RelicFodder farming script meant to be used with `Fate Farming.lua`. This will go down
the list of relicFodder farming zones and farm fates until you have the selected number
of the required relicFodders in your inventory, then teleport to the next zone and 
restart the fate farming script.

    -> 0.9.0    Copied from Zodiac Atma farming for starting

--#region Settings
]]
--[[
********************************************************************************
*                                   Settings                                   *
********************************************************************************
]]

FateMacro = Config.Get("FateMacro")
NumberToFarm = Config.Get("NumberToFarm")
RelicFodderTarget = Config.Get("RelicFodderTarget")

--#endregion Settings

------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
**************************************************************
*  Code: Don't touch this unless you know what you're doing  *
**************************************************************
]]

ScriptName = "Relic Fodder"

RelicFodderOptions = {
  { RelicTarget = "None",
    RelicFodder = {},
  },
  { RelicTarget = "2.2 - Atma - Up in Arms",
    RelicFodder = {
      {itemName = "Atma of the Maiden", itemId = 7851, zoneName = "Central Shroud", zoneId = 148, },
      {itemName = "Atma of the Scorpion", itemId = 7852, zoneName = "Southern Thanalan", zoneId = 146, flying=false, },
      {itemName = "Atma of the Water-bearer", itemId = 7853, zoneName = "Upper La Noscea", zoneId = 139, },
      {itemName = "Atma of the Goat", itemId = 7854, zoneName = "East Shroud", zoneId = 152, },
      {itemName = "Atma of the Bull", itemId = 7855, zoneName = "Eastern Thanalan", zoneId = 145, },
      {itemName = "Atma of the Ram", itemId = 7856, zoneName = "Middle La Noscea", zoneId = 134, },
      {itemName = "Atma of the Twins", itemId = 7857, zoneName = "Western Thanalan", zoneId = 140, },
      {itemName = "Atma of the Lion", itemId = 7858, zoneName = "Outer La Noscea", zoneId = 180, flying=false, },
      {itemName = "Atma of the Fish", itemId = 7859, zoneName = "Lower La Noscea", zoneId = 135, },
      {itemName = "Atma of the Archer", itemId = 7860, zoneName = "North Shroud", zoneId = 154, },
      {itemName = "Atma of the Scales", itemId = 7861, zoneName = "Central Thanalan", zoneId = 141, },
      {itemName = "Atma of the Crab", itemId = 7862, zoneName = "Western La Noscea", zoneId = 138, },
    },
  },
  { RelicTarget = "5.35 - Memories - For Want of a Memory",
    RelicFodder = {
      {itemName = "Tortured Memory of the Dying", itemId = 31573,  zoneName = "Coerthas Western Highlands", zoneId = 397 },
      {itemName = "Sorrowful Memory of the Dying", itemId = 31574, zoneName = "The Dravanian Forelands", zoneId = 398, },
      {itemName = "Harrowing Memory of the Dying", itemId = 31575, zoneName = "The Dravanian Hinterlands", zoneId = 399 },
    },
  },
  { RelicTarget = "5.45 - Memories - The Resistance Remembers",
    RelicFodder = {
      {itemName = "Haunting Memory of the Dying", itemId = 32957,  zoneName = " The Fringes", zoneId = 612, },
      {itemName = "Vexatious  Memory of the Dying", itemId = 32958,  zoneName = "The Azim Steppe", zoneId = 622, },
    },
  },
  { RelicTarget = "7.25 - Demiatma - Arcane Artistry",
    RelicFodder = {
      { itemName="Azurite Demiatma", itemId=47744, zoneName = "Urqopacha", zoneId = 1187 },
      { itemName="Verdigris Demiatma", itemId=47745, zoneName = "Kozama'uka", zoneId = 1188, },
      { itemName="Malachite Demiatma", itemId=47746, zoneName = "Yak T'el", zoneId = 1189, },
      { itemName="Realgar Demiatma", itemId=47747, zoneName = "Shaaloani", zoneId = 1190, },
      { itemName="Caput Mortuum Demiatma", itemId=47748, zoneName = "Heritage Found", zoneId = 1191, },
      { itemName="Orpiment Demiatma", itemId=47749, zoneName = "Living Memory", zoneId = 1192, },
    },
  },
}

CharacterCondition = {
    casting=27,
    betweenAreas=45
}

--[[
**************************************************************
* Functions
**************************************************************
]]
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

--[[ Select the specific fodder and zone to farm next. ]]
function GetNextRelicFodderTable()
    for _, relicFodderTable in pairs(RelicFodder) do
        if Inventory.GetItemCount(relicFodderTable.itemId) < NumberToFarm then
            return relicFodderTable
        end
    end
end

--[[ Select the list of fodder and zones for the relic we're going to be hunting for. ]]
function GetRelicFodderTables()
    for foddertarget, foddertable in pairs(RelicFodderOptions) do
        if foddertarget == RelicFodderTarget then
            return foddertable
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


--[[
**************************************************************
* Main loop start
**************************************************************
]]
yield("/at y")
RelicFodder = GetRelicFodderTables()
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
