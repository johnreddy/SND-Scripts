--[=====[
[[SND Metadata]]
author: johnreddy
version: 0.1
description: |
  Slogging through Fishing achievements.  Just tries to catch everything.  Does not help towards anything other than the straight-up fishing numbers.
  -  Moves around from time to time.
  -  Lets you your gear before it breaks.
  -  Skips achievements you already have.
plugin_dependencies:
- Lifestream
- vnavmesh
- Autohook
configs:
  Self repair?:
    description: If checked, will attempt to repair your gear. If not checked, will go to Limsa mender.
    default: true
  Good Things Come to Those Who Bait: La Noscea I:
    description: "Fish 20 times from level 1-10 waters"
    default: false
  Good Things Come to Those Who Bait: La Noscea II:
    description: "Fish 100 times from level 11-20 waters"
    default: false
  Good Things Come to Those Who Bait: La Noscea III:
    description: "Fish 300 times from level 21-30 waters"
    default: false
  Good Things Come to Those Who Bait: La Noscea IV:
    description: "Fish 500 times from level 31-40 waters"
    default: false
  Good Things Come to Those Who Bait: La Noscea V:
    description: "Fish 1000 times from level 41-50 waters"
    default: false
  Good Things Come to Those Who Bait: Black Shroud I:
    description: "Fish 20 times from level 1-10 waters"
    default: false
  Good Things Come to Those Who Bait: Black Shroud II:
    description: "Fish 100 times from level 11-20 waters"
    default: false
  Good Things Come to Those Who Bait: Black Shroud III:
    description: "Fish 300 times from level 21-30 waters"
    default: false
  Good Things Come to Those Who Bait: Black Shroud IV:
    description: "Fish 500 times from level 31-40 waters"
    default: false
  Good Things Come to Those Who Bait: Black Shroud V:
    description: "Fish 1000 times from level 41-50 waters"
    default: false
  Good Things Come to Those Who Bait: Thanalan I:
    description: "Fish 20 times from level 1-10 waters"
    default: false
  Good Things Come to Those Who Bait: Thanalan II:
    description: "Fish 100 times from level 11-20 waters"
    default: false
  Good Things Come to Those Who Bait: Thanalan III:
    description: "Fish 300 times from level 21-30 waters"
    default: false
  Good Things Come to Those Who Bait: Thanalan IV:
    description: "Fish 500 times from level 31-40 waters"
    default: false
  Good Things Come to Those Who Bait: Thanalan V:
    description: "Fish 1000 times from level 41-50 waters"
    default: false
  Baiting Heavensward:
    description: "Fish 3000 times from level 51-60 waters"
    default: false
  Baiting Stormblood:
    description: "Fish 3000 times from level 61-70 waters"
    default: false
  Baiting Shadowbringers:
    description: "Fish 3000 times from level 71-80 waters"
    default: false
  Baiting the End:
    description: "Fish 3000 times from level 81-90 waters"
    default: false
  Baiting Dawntrail:
    description: "Fish 3000 times from level 91-100 waters"
    default: false
[[End Metadata]]
--]=====]

  
--[[
********************************************************************************
*                                  Changelog                                   *
********************************************************************************
  ->   0.1  Rewriting for SND release around June 2025.  Also, new Lua.


  
********************************************************************************
********************************************************************************
*                                                                              *
*    System Variables                                                          *
*                                                                              *
*    Don't mess below here, you could break stuff!                             *
*                                                                              *
********************************************************************************
********************************************************************************
]]

import("System.Numerics")

CharacterCondition = {
    dead=2,
    mounted=4,
    inCombat=26,
    casting=27,
    occupiedInEvent=31,
    occupiedInQuestEvent=32,
    occupied=33,
    boundByDuty34=34,
    occupiedMateriaExtractionAndRepair=39,
    betweenAreas=45,
    jumping48=48,
    jumping61=61,
    occupiedSummoningBell=50,
    betweenAreasForDuty=51,
    boundByDuty56=56,
    mounting57=57,
    mounting64=64,
    beingMoved=70,
    flying=77
}

-- This name will be used whereever logging entries are made.
ThisScriptName = "BaitingAchievements"

-- FisherJobNum - As a variable in case patching ever changes job numbers.
FisherJobNum = 18

--[[
ARRFishingAchievements - List of Achievements to complete, and where to fish for them.
    AchievementName   - Name as listed in Achievements -> Crafting & Gathering -> Fisher
    AchievementNumber - RowID from SND Excel Browser -> Achievement
    Spot              - Identified Fishing Hole name from Fishing Log
    ReleaseBitmask    - Unsigned Int for setting the Release List; we don't want to keep these fish
    zoneId            - number for vnavmesh and other plugins to identify the zone
    zoneName          - What we humans use to identify the zone
    fishingSpots      - Contains travel information for getting to the fishing spots, and various locations at each one
        maxHeight     - Highest you should fly to get around
        waypoints     - an array of coordinates describing a line for possible starting
        pointToFace   - The point at the center of the fishing area, the point to move towards when starting from the waypoint line
]]
ARRFishingAchievements = 
{
    {
        AchievementName = "Good Things Come to Those Who Bait: La Noscea I",
        AchievementNumber = 259,
        Spot = "West Agelyss River",
        NumberOfFish = 7,
        zoneId = 134,
        zoneName = "Middle La Noscea",
        fishingSpots = {
            maxHeight = 1024,
            waypoints = {
                { x=-34.80, y=45.87, z=-203.31 },
                { x=-53.75, y=45.08, z=-176.26 },
                { x=-88.09, y=44.98, z=-148.15 },
            },
            pointToFace = { x=-66.69, y=45.00, z=-173.75 },
        },
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: La Noscea II",
        AchievementNumber = 260,
        Spot = "Empty Heart",
        NumberOfFish = 9,
        zoneId = 135,
        zoneName = "Lower La Noscea",
        fishingSpots = {
            maxHeight = 1024,
            waypoints = {
                { x=21.16, y=35.65, z=697.33 },
                { x=8.35, y=35.44, z=689.45 },
                { x=8.22, y=35.44, z=673.76 },
            },
            pointToFace = { x=23.02, y=35.44, z=674.69 },
        },
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: La Noscea III",
        AchievementNumber = 261,
        Spot = "South Bloodshore",
        NumberOfFish = 10,
        zoneId = 137,
        zoneName = "Eastern La Noscea",
        fishingSpots = {
            maxHeight = 1024,
            waypoints = {
                { x=566.71, y=8.71, z=581.70 },
                { x=525.50, y=8.66, z=682.77 },
            },
            pointToFace = { x=573.53, y=8.4, z=651.59 },
        },
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: La Noscea IV",
        AchievementNumber = 262,
        Spot = "North Bloodshore",
        NumberOfFish = 10,
        zoneId = 137,
        zoneName = "Eastern La Noscea",
        fishingSpots = {
            maxHeight = 1024,
            waypoints = {
                { x=554.80, y=8.72, z=173.22 },
                { x=533.35, y=8.81, z=118.77 },
            },
            pointToFace = { x=573.04, y=8.43, z=131.18 },
        },
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: La Noscea V",
        AchievementNumber = 263,
        Spot = "The Ship Graveyard",
        NumberOfFish = 10,
        zoneId = 138,
        zoneName = "Western La Noscea",
        fishingSpots = {
            maxHeight = 1024,
            waypoints = {
                { x=-244.92, y=-42.24, z=732.19 },
                { x=-305.71, y=-42.26, z=706.13 },
                { x=-344.85, y=-42.22, z=711.24 },
            },
            pointToFace = { x=-295.06, y=-42.27, z=728.24 },
        },
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: Black Shroud I",
        AchievementNumber = 265,
        Spot = "The Vein",
        NumberOfFish = 8,
        zoneId = 148,
        zoneName = "Central Shroud",
        fishingSpots = {
            maxHeight = 1024,
            waypoints = {
                { x=52.08, y=-12, z=-37.22 },
                { x=73.42, y=-12, z=29.91 }, -- Watermill
                { x=81.09, y=-12, z=37.42 },
            },
            pointToFace = { x=81.14, y=-12, z=85.49 },
        },
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: Black Shroud II",
        AchievementNumber = 266,
        Spot = "Springripple Brook",
        NumberOfFish = 8,
        zoneId = 152,
        zoneName = "East Shroud",
        fishingSpots = {
            maxHeight = 1024,
            waypoints = {
                { x=114.28, y=7.76, z=190.25 },
                { x=114.88, y=8.02, z=192.07 },
            },
            pointToFace = { x=125.08, y=5.22, z=176.13 },
        },
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: Black Shroud III",
        AchievementNumber = 267,
        Spot = "Verdant Drop",
        NumberOfFish = 9,
        zoneId = 152,
        zoneName = "East Shroud",
        fishingSpots = {
            maxHeight = 1024,
            waypoints = {
                { x=-61.87, y=16.91, z=5.12 },
                { x=-29.82, y=17.15, z=0.29 },
            },
            pointToFace = { x=-46.73, y=15.69, z=-15.86 },
        },
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: Black Shroud IV",
        AchievementNumber = 268,
        Spot = "Rootslake",
        NumberOfFish = 7,
        zoneId = 153,
        zoneName = "South Shroud",
        fishingSpots = {
            maxHeight = 1024,
            waypoints = {
                { x=-108.74, y=-0.43, z=336.70 },
                { x=-146.36, y=-0.44, z=387.20 },
            },
            pointToFace = { x=-158.16, y=-0.15, z=355.32 },
        },
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: Black Shroud V",
        AchievementNumber = 269,
        Spot = "Lake Tahtotl",
        NumberOfFish = 9,
        zoneId = 154,
        zoneName = "North Shroud",
        fishingSpots = {
            maxHeight = 1024,
            waypoints = {
                { x=-155.23, y=-10.39, z=-73.63 },
                { x=-160.29, y=-9.54, z=-88.65 },
            },
            pointToFace = { x=-207.99, y=-10.02, z=-86.55 },
        },
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: Thanalan I",
        AchievementNumber = 271,
        Spot = "Upper Soot Creek",
        NumberOfFish = 6,
        zoneId = 141,
        zoneName = "Central Thanalan",
        fishingSpots = {
            maxHeight = 1024,
            waypoints = {
                { x=100.56, y=-2, z=-165.39 },
                { x=124.34, y=-2, z=-183.17 },
            },
            pointToFace = { x=172.29, y=-2, z=-242.88 },
        },
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: Thanalan II",
        AchievementNumber = 272,
        Spot = "The Unholy Heir",
        NumberOfFish = 8,
        zoneId = 141,
        zoneName = "Central Thanalan",
        fishingSpots = {
            maxHeight = 1024,
            waypoints = {
                { x=299.11, y=-19.72, z=-165.64 },
                { x=265.05, y=-19.72, z=-132.28 },
                { x=281.53, y=-19.72, z=-86.03 },
            },
            pointToFace = { x=316.14, y=-19.72, z=-115.08 },
        },
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: Thanalan III",
        AchievementNumber = 273,
        Spot = "Burnt Lizard Creek",
        NumberOfFish = 6,
        zoneId = 146,
        zoneName = "Southern Thanalan",
        fishingSpots = {
            maxHeight = 1024,
            waypoints = {
                { x=34.73, y=3.61, z=-336.61 },
                { x=35.65, y=3.56, z=-309.33 },
            },
            pointToFace = { x=15.07, y=-16.25, z=-323.77 },
        },
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: Thanalan IV",
        AchievementNumber = 274,
        Spot = "Sagolii Desert",
        NumberOfFish = 9,
        zoneId = 146,
        zoneName = "Southern Thanalan",
        fishingSpots = {
            maxHeight = 1024,
            waypoints = {
                { x=-435.83, y=-0.59, z=645.48 },
                { x=-423.32, y=-0.95, z=691.30 },
            },
            pointToFace = { x=-496.03, y=-0.59, z=655.54 },
        },
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: Thanalan V",
        AchievementNumber = 275,
        Spot = "Ceruleum Field",
        NumberOfFish = 9,
        zoneId = 147,
        zoneName = "Northern Thanalan",
        fishingSpots = {
            maxHeight = 1024,
            waypoints = {
                { x=-69.48, y=47, z=29.85 },
                { x=-57.91, y=46.79, z=40.89 },
                { x=-49.24, y=46.87, z=43.11 },
            },
            pointToFace = { x=-68.69, y=47, z=68.65 },
        },
    },
    {
        AchievementName = "Baiting Heavensward",
        AchievementNumber = 1311,
        Spot = "The Blue Window",
        NumberOfFish = 9,
        zoneId = 401,
        zoneName = "The Sea of Clouds",
        fishingSpots = {
            maxHeight = 1024,
            waypoints = {
                { x=-643.67, y=-64.19, z=-484.30 },
                { x=-638.45, y=-64.92, z=-515.86 },
                { x=-621.05, y=-65.20, z=-541.71 },
                { x=-606.60, y=-64.19, z=-554.24 },
            },
            pointToFace = { x=-738.11, y=-65, z=-548.02 },
        },
    },
    {
        AchievementName = "Baiting Stormblood",
        AchievementNumber = 1858,
        Spot = "Onokoro",
        NumberOfFish = 7,
        zoneId = 613,
        zoneName = "The Ruby Sea",
        fishingSpots = {
            maxHeight = 1024,
            waypoints = {
                { x=-85.85, y=-0.44, z=-572.17 },
                { x=-124.40, y=-0.5, z=-527.79 },
            },
            pointToFace = { x=23.39, y=-0.5, z=-521.56 },
        },
    },
    {
        AchievementName = "Baiting Shadowbringers",
        AchievementNumber = 2290,
        Spot = "The Jealous One",
        NumberOfFish = 5,
        zoneId = 816,
        zoneName = "Il Mheg",
        fishingSpots = {
            maxHeight = 1024,
            waypoints = {
                { x=229.15, y=70.76, z=-706.48 },
                { x=214.81, y=64.52, z=-670.44 },
                { x=210.81, y=51.18, z=-619.13 },
            },
            pointToFace = { x=187.97, y=25.39, z=-569.34 },
        },
    },
    {
        AchievementName = "Baiting the End",
        AchievementNumber = 2938,
        Spot = "The Mover Beta",
        NumberOfFish = 7,
        zoneId = 956,
        zoneName = "Labyrinthos",
        fishingSpots = {
            maxHeight = 1024,
            waypoints = {
                { x=323.77, y=154.17, z=-573.98 },
                { x=245.83, y=142.84, z=-532.72 },
            },
            pointToFace = { x=198.89, y=140.34, z=-508.89 },
        },
    },
    {
        AchievementName = "Baiting Dawntrail",
        AchievementNumber = 3477,
        Spot = "Miyakabek'zoma",
        NumberOfFish = 5,
        zoneId = 1188,
        zoneName = "Kozama'uka",
        fishingSpots = {
            maxHeight = 1024,
            waypoints = {
                { x=-99.37, y=109.2, z=291.20 },
                { x=-141.66, y=109.2, z=471.10 },
                { x=-207.56, y=109.2, z=538.69 },
            },
            pointToFace = { x=-356.19, y=109.2, z=355.41 },
        },
    },
}    

SelfRepair                      = Config.Get("Self repair?")








--#region Main

CharacterState = {
    ready                   = Ready,
    dead                    = HandleDeath,
    unexpectedCombat        = HandleUnexpectedCombat,
    mounting                = MountState,
    npcDismount             = NpcDismount,
    MiddleOfFateDismount    = MiddleOfFateDismount,
    moveToFate              = MoveToFate,
    interactWithNpc         = InteractWithFateNpc,
    collectionsFateTurnIn   = CollectionsFateTurnIn,
    doFate                  = DoFate,
    waitForContinuation     = WaitForContinuation,
    changingInstances       = ChangeInstance,
    changeInstanceDismount  = ChangeInstanceDismount,
    flyBackToAetheryte      = FlyBackToAetheryte,
    extractMateria          = ExtractMateria,
    repair                  = Repair,
    exchangingVouchers      = ExecuteBicolorExchange,
    processRetainers        = ProcessRetainers,
    gcTurnIn                = GrandCompanyTurnIn,
    summonChocobo           = SummonChocobo,
    autoBuyGysahlGreens     = AutoBuyGysahlGreens
}

--- Fate state enum mapping (values confirmed from FFXIV SND)
FateState = {
    None       = 0,  -- no state / unknown
    Preparing  = 1,  -- fate is setting up
    Waiting    = 2,  -- waiting before spawn
    Spawning   = 3,  -- mobs/NPCs spawning
    Running    = 4,  -- fate active and in progress
    Ending     = 5,  -- fate nearing completion
    Ended      = 6,  -- fate finished successfully
    Failed     = 7   -- fate failed
}

-- Settings Area
-- Buffs
Food                            = Config.Get("Food")
Potion                          = Config.Get("Potion")

-- Chocobo
ResummonChocoboTimeLeft            = 3 * 60        --Resummons chocobo if there's less than this many seconds left on the timer, so it doesn't disappear on you in the middle of a fate.
ChocoboStance                   = Config.Get("Chocobo Companion Stance") -- Options: Follow, Free, Defender, Healer, Attacker, None. Do not summon if None.
ShouldSummonChocobo =  ChocoboStance == "Follow"
                    or ChocoboStance == "Free"
                    or ChocoboStance == "Defender"
                    or ChocoboStance == "Healer"
                    or ChocoboStance == "Attacker"
ShouldAutoBuyGysahlGreens       = Config.Get("Buy Gysahl Greens?")
MountToUse                      = "mount roulette"       --The mount youd like to use when flying between fates

-- Retainer




  


-- Variable initialzization
StopScript                      = false
MovingAnnouncementLock          = false
LastTeleportTimeStamp           = 0
LastStuckCheckTime              = os.clock()
LastStuckCheckPosition          = Player.Entity.Position
MainClass                       = Player.Job

--Post Fate Settings
MinWait                        = 3          --Min number of seconds it should wait until mounting up for next fate.
MaxWait                        = 10         --Max number of seconds it should wait until mounting up for next fate.
    --Actual wait time will be a randomly generated number between MinWait and MaxWait.
RemainingDurabilityToRepair    = 10         --the amount it needs to drop before Repairing (set it to 0 if you don't want it to repair)
ShouldAutoBuyDarkMatter        = true       --Automatically buys a 99 stack of Grade 8 Dark Matter from the Limsa gil vendor if you're out
ShouldExtractMateria           = true       --should it Extract Materia

-- Config settings
SelfRepair                      = Config.Get("Self repair?")
--Retainers                       = Config.Get("Pause for retainers?")
--Echo                            = string.lower(Config.Get("Echo logs"))

-- Plugin warnings
--[[
if Retainers and not HasPlugin("AutoRetainer") then
    Retainers = false
    yield("/echo [FATE] Warning: you have enabled the feature to process retainers, but you do not have AutoRetainer installed.")
end

if ShouldGrandCompanyTurnIn and not HasPlugin("AutoRetainer") then
    ShouldGrandCompanyTurnIn = false
    yield("/echo [FATE] Warning: you have enabled the feature to process GC turn ins, but you do not have AutoRetainer installed.")
end
]]

-- Functions

--Set selected zone
SelectedAchievement = SelectNextAchievement()
if SelectedAchievement.zoneName ~= "" and Echo == "all" then
    yield("/echo ["..ThisScriptName.."] Fishing at "..SelectedAchievement.spot.."in "..SelectedAchievement.zoneName)
end
Dalamud.Log("["..ThisScriptName.."] Fishing at "..SelectedAchievement.spot.."in "..SelectedAchievement.zoneName)

if ShouldExchangeBicolorGemstones ~= false then
    for _, shop in ipairs(BicolorExchangeData) do
        for _, item in ipairs(shop.shopItems) do
            if item.itemName == ItemToPurchase then
                SelectedBicolorExchangeData = {
                    shopKeepName = shop.shopKeepName,
                    zoneId = shop.zoneId,
                    aetheryteName = shop.aetheryteName,
                    miniAethernet = shop.miniAethernet,
                    position = shop.position,
                    item = item
                }
            end
        end
    end
    if SelectedBicolorExchangeData == nil then
        yield("/echo [FATE] Cannot recognize bicolor shop item "..ItemToPurchase.."! Please make sure it's in the BicolorExchangeData table!")
        StopScript = true
    end
end

if InActiveFate() then
    CurrentFate = BuildFateTable(Fates.GetNearestFate())
end

if ShouldSummonChocobo and GetBuddyTimeRemaining() > 0 then
    yield('/cac "'..ChocoboStance..' stance"')
end

Dalamud.Log("[FATE] Starting fate farming script.")

State = CharacterState.ready
CurrentFate = nil

if CompanionScriptMode then
    yield("/echo The companion script will overwrite changing instances.")
    EnableChangeInstance = false
end

while not StopScript do
    local nearestFate = Fates.GetNearestFate()
    if not IPC.vnavmesh.IsReady() then
        yield("/echo [FATE] Waiting for vnavmesh to build...")
        Dalamud.Log("[FATE] Waiting for vnavmesh to build...")
        repeat
            yield("/wait 1")
        until IPC.vnavmesh.IsReady()
    end
    if State ~= CharacterState.dead and Svc.Condition[CharacterCondition.dead] then
        State = CharacterState.dead
        Dalamud.Log("[FATE] State Change: Dead")
    elseif not Player.IsMoving then
        if State ~= CharacterState.unexpectedCombat
        and State ~= CharacterState.doFate
        and State ~= CharacterState.waitForContinuation
        and State ~= CharacterState.collectionsFateTurnIn
        and Svc.Condition[CharacterCondition.inCombat]
        and (
            not InActiveFate()
            or (InActiveFate() and IsCollectionsFate(nearestFate.Name) and nearestFate.Progress == 100)
            )
        then
            State = CharacterState.unexpectedCombat
            Dalamud.Log("[FATE] State Change: UnexpectedCombat")
        end
    end

    BicolorGemCount = Inventory.GetItemCount(26807)

    if WaitingForFateRewards ~= nil then
        local state = WaitingForFateRewards.fateObject and WaitingForFateRewards.fateObject.State or nil
        if WaitingForFateRewards.fateObject == nil
            or state == nil
            or state == FateState.Ended
            or state == FateState.Failed
        then
            local msg = "[FATE] WaitingForFateRewards.fateObject is nil or fate state ("..tostring(state)..") indicates fate is finished for fateId: "..tostring(WaitingForFateRewards.fateId)..". Clearing it."
            Dalamud.Log(msg)
            if Echo == "all" then
                yield("/echo "..msg)
            end
            WaitingForFateRewards = nil
        else
            local msg = "[FATE] Not clearing WaitingForFateRewards: fate state="..tostring(state)..", expected one of [Ended: "..tostring(FateState.Ended)..", Failed: "..tostring(FateState.Failed).."] or nil."
            Dalamud.Log(msg)
            if Echo == "all" then
                yield("/echo "..msg)
            end
        end
    end
    if not (Svc.Condition[CharacterCondition.betweenAreas]
        or Svc.Condition[CharacterCondition.occupiedMateriaExtractionAndRepair]
        or IPC.Lifestream.IsBusy())
        then
            State()
    end
    yield("/wait 0.25")
end
yield("/vnav stop")

if Player.Job.Id ~= MainClass.Id then
    yield("/gs change "..MainClass.Name)
end

yield("/echo [Fate] Loop Ended !!")
--#endregion Main
