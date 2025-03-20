--[[
********************************************************************************
*                                                                              *
*        BaitingAchievements                                                   *
*                                                                              *
********************************************************************************

Intending to assist in the completion of the following Achievements:
 1 - Good Things Come to Those Who Bait: La Noscea I
 2 - Good Things Come to Those Who Bait: La Noscea II
 3 - Good Things Come to Those Who Bait: La Noscea III
 4 - Good Things Come to Those Who Bait: La Noscea IV
 5 - Good Things Come to Those Who Bait: La Noscea V
 6 - Good Things Come to Those Who Bait: Black Shroud I
 7 - Good Things Come to Those Who Bait: Black Shroud II
 8 - Good Things Come to Those Who Bait: Black Shroud III
 9 - Good Things Come to Those Who Bait: Black Shroud IV
10 - Good Things Come to Those Who Bait: Black Shroud V
11 - Good Things Come to Those Who Bait: Thanalan I
12 - Good Things Come to Those Who Bait: Thanalan II
13 - Good Things Come to Those Who Bait: Thanalan III
14 - Good Things Come to Those Who Bait: Thanalan IV
15 - Good Things Come to Those Who Bait: Thanalan V
16 - Baiting Heavensward
17 - Baiting Stormblood
18 - Baiting Shadowbringers
19 - Baiting the End
20 - Baiting Dawntrail

Concept: Iterate through all of the achievements.  If there's one that hasn't 
been completed, go to a known fishing site for that achievement, set the Release 
List so that you don't run out of inventory space with useless content, fish 
there using Versatile Lure until you complete the achievement.  Move on to the 
next unfinished achievement in order until done.

Created by: John 'Skip' Reddy
Inspired by pot0to's FishingGathererScrips - https://github.com/pot0to/pot0to-SND-Scripts

-> 0.0.1

********************************************************************************
*                               Required Plugins                               *
********************************************************************************

1. AutoHook
2. VnavMesh
3. Lifestream
4. TeleporterI

********************************************************************************
*                                   Settings                                   *
********************************************************************************
]]

TargetAchievement        = 0 
--[[ TargetAchievement: If set to 0, then we'll cycle through all the achievements
     this character has not finished. Otherwise, select the number of the achievement
     as listed in the section above.  For example, set to 16 for Baiting Heavensward.
]]

UseCordials              = false    --If true, will use cordials when fishing
MoveSpotsAfter           = 30       --Number of minutes to fish at this spot before changing spots.
ResetHardAmissAfter      = 120      --Number of minutes to farm in current instance before teleporting away and back

Food                     = ""
Potion                   = ""
--[[ If you're high enough level, then you won't really need to set Food or Potion.  These determine
     which consumables we'll be upkeeping.  Append <hq> if you're using high quality consumables.
     Examples:
Food                     = "Nasi Goreng <hq>"   -- For more GP while gathering
Potion                   = "Superior Spiritbond Potion <hq>" -- If you're gathering, you may as well try for more materia
]]

--things you want to enable
ExtractMateria           = true     --If true, will extract materia if possible
ReduceEphemerals         = true     --If true, will reduce ephemerals if possible
SelfRepair               = true     --If true, will do repair if possible set repair amount below
RepairAmount             = 1        --repair threshold, adjust as needed

-- Keep this? Maybe implement breakout for inventory full when processing materia -JR
--MinInventoryFreeSlots    = 1        --set carefully

--[[
*******************************************
*******************************************
*                                         *
*    Standard Variables                   *
*                                         *
*******************************************
*******************************************
]]

-- This name will be used whereever logging entries are made.
ThisScriptName = "BaitingAchievements"

-- Grade 8 Dark Matter is current highest, its item number
DarkMatter = 33916

-- Versatile Lure is the bait we're using here, its item number
VersatileLure = 29717

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
]]
ARRFishingAchievements = 
{
    {
        AchievementName = "Good Things Come to Those Who Bait: La Noscea I",
        AchievementNumber = 259,
        Spot = "West Agelyss River",
        ReleaseBitmask = 127,
        zoneId = 134,
        zoneName = "Middle La Noscea",
        fishingSpots = {
            maxHeight = 1024,
            waypoints = {
                { x=-45.90, y=45.59, z=-216.62 },
                { x=-46.08, y=45.05, z=-182.87 },
                { x=-76.85, y=44.86, z=-130.74 },
                { x=-105.57, y=44.95, z=-156.99 },
            },
            pointToFace = { x=-66.69, y=45.00, z=-173.75 },
        },
    },
--[[
    {
        AchievementName = "Good Things Come to Those Who Bait: La Noscea II",
        AchievementNumber = 261,
        Spot = "",
        ReleaseBitmask = ,
        zoneId = ,
        zoneName = "",
        fishingSpots = {
            maxHeight = 1024,
            waypoints = {
                { x=, y=, z= },
            },
            pointToFace = { x=, y=, z= },
        },
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: La Noscea III",
        AchievementNumber = 262,
        Location = "",
        ReleaseBitmask = ,
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: La Noscea IV",
        AchievementNumber = 263,
        Location = "",
        ReleaseBitmask = ,
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: La Noscea V",
        AchievementNumber = 264,
        Location = "",
        ReleaseBitmask = ,
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: Black Shroud I",
        AchievementNumber = 265,
        Location = "",
        ReleaseBitmask = ,
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: Black Shroud II",
        AchievementNumber = 266,
        Location = "",
        ReleaseBitmask = ,
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: Black Shroud III",
        AchievementNumber = 267,
        Location = "",
        ReleaseBitmask = ,
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: Black Shroud IV",
        AchievementNumber = 268,
        Location = "",
        ReleaseBitmask = ,
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: Black Shroud V",
        AchievementNumber = 269,
        Location = "",
        ReleaseBitmask = ,
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: Thanalan I",
        AchievementNumber = 271,
        Location = "",
        ReleaseBitmask = ,
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: Thanalan II",
        AchievementNumber = 272,
        Location = "",
        ReleaseBitmask = ,
    },
]]
    {
        AchievementName = "Good Things Come to Those Who Bait: Thanalan III",
        AchievementNumber = 273,
        Spot = "Burnt Lizard Creek",
        ReleaseBitmask = 63,
        zoneId = 146,
        zoneName = "Southern Thanalan",
        fishingSpots = {
            maxHeight = 1024,
            waypoints = {
                { x=37.10, y=3.40, z=-344.93 },
                { x=35.38, y=3.71, z=-308.11 },
                { x=-9.13, y=14.98, z=-321.11 },
            },
            pointToFace = { x=15.07, y=-16.25, z=-323.77 },
        },
    },
--[[
    {
        AchievementName = "Good Things Come to Those Who Bait: Thanalan IV",
        AchievementNumber = 274,
        Location = "",
        ReleaseBitmask = ,
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: Thanalan V",
        AchievementNumber = 275,
        Location = "",
        ReleaseBitmask = ,
    },
    {
        AchievementName = "Baiting Heavensward",
        AchievementNumber = 1311,
        Location = "",
        ReleaseBitmask = ,
    },
    {
        AchievementName = "Baiting Stormblood",
        AchievementNumber = 1858,
        Location = "",
        ReleaseBitmask = ,
    },
    {
        AchievementName = "Baiting Shadowbringers",
        AchievementNumber = 2290,
        Location = "",
        ReleaseBitmask = ,
    },
    {
        AchievementName = "Baiting the End",
        AchievementNumber = 2938,
        Location = "",
        ReleaseBitmask = ,
    },
    {
        AchievementName = "Baiting Dawntrail",
        AchievementNumber = 3477,
        Location = "",
        ReleaseBitmask = ,
    },
]]
}

-- RequiredPlugins - what we need to actually run this.
RequiredPlugins = {
    "Lifestream",
    "TeleporterPlugin",
    "vnavmesh",
    "AutoHook"
}

-- autohookPreset - Decide which Preset to use via UseCordials.  Only difference is Cordials or no.
if UseCordials then
    autohookPreset = "AH4_H4sIAAAAAAAACuVWwXKbMBD9lYzOZgawwCY3x3XSzDhppk7bQ6YHGRZbY4IcIdK4Gf97V4BswDhOO7n1Brurt2+1qye9klGuxJhlKhvHC3L+SiYpmycwShJyrmQOPaKdU57C3hkZ1zV+ucOgR+4kF5KrDTl30JpNXsIkjyDam3X8tsS6ESJcarDiw9VfBY4/7JGr9f1SQrYUCVoc224gvw1dYASDxgr7JJnxMn88Uhh1bNpi5LYYGRCRJBAqUwkudOph7mkWQkacJQVA+gzSGJrBvS6WvkOdEyzdhn80F8/Yy5glmUl/ybPlZANZrQCvhel5Tcy+aSZbwWzJY3XBeLEB2pAZw0yxcIWwiFa1+BC4AUsr2DumOKQh1Bj57YV+k5Fnlkr+G8ZMlTNm0von9sivVt8vWcLZKrtkz0JqgIbB1NPvNe1fIcRNxXhHb1PXIUEK7WHqH47322264Isr9ljsyShdJCAzw0dPmEYc2PSg0EaO4RaxJi9KssZp33HVTbsXs19sfZ2qnCsu0ivGU7OTFnKc5hJuIMvYApkQ0iO3BSdyK1AiKoTNGi16RDrwpiJT/4x3h3VBN0NikSP+MmPh3/OZrfHESpaMcykhVR9UZQv1w2rtZHtQcWf2IupSyBCKE4lhptmFMdLWSjsdVM9ysmZKrLUq8HQxU4ArnHqV1fSN5McUV4cr2H5L+VMOGpcEtu1EjIZWDIFj0aHrWoHbH1pe0GeRHTLPiYAg3pRn6kusc+BxeHgtsukCdhpQVneM43fMj5KTwJmO0IC3Qj6y5LMQKw1h9OgHsNX+2GgvVlHf08pUFkqdQaBrrRbPlBTp4v3L3cCvrZ7CAtKIyc3fAnwSOcYa5s0AP9gF7NkdDWlQ6Ii6l3x9LNPAc/u7kGO5GkFvZKvi9JSOYgWov+gbizxVZh92rjHLF0t8vzzq64l6qNyHs227tHrmYPOLW1B/1MS+FFcvaF9ebz4w9JvESJCZo6/wlHMJEWKrXF+M+tHTHq73zVAryu4fm5WuwP9gJhqNR3nqkrT39Lx9bZ/qeU28wIvcmPrUcu0otujAH1gsjGMLQhY6A/DAdhyy/WnUq3oYP+wMpYDp/1IuK7G6AnU2wefGRuliWno5oPF8HjKL0WFoUTv2LWajXtoQzgMah95wyMj2D4fQ4FL2CwAA"
else
    autohookPreset = "AH4_H4sIAAAAAAAACuVWwXLaMBD9lYzOeMY2ssG5EUpoZkiaKWl7yPQg7DVoMBaR5TQ0w793ZVtgGwhpJ7fe7N3V27fa1ZNeySBXYsgylQ3jObl8JaOUzRIYJAm5VDKHDtHOCU9h74yM6wa/3H7QIfeSC8nVhlw6aM1GL2GSRxDtzTp+W2LdChEuNFjx4eqvAsfvd8h4/bCQkC1EghbHthvIb0MXGEGvscI+S2a4yFcnCqOOTVuM3BYjAyKSBEJlKsGFTj3MPc9CyIizpABIn0EaQzO4pOU71DlDy234BzPxjM2LWZKZfNc8W4w2kNUYey1Mz2tidk332BKmCx6rK8aLirUhM4apYuESYRGt6ukhcAOWVrD3THFIQ6gx8tsL/SYjzyyV/DcMmSqHyqT1z+yRX61+WLCEs2V2zZ6F1AANg6mn22nav0KIm4rxjt6mY6cCKbSnp3s4z2+36YrPx2xV7MkgnScgM8NHj5RG7Nn0oNBGjv4WsUYvSrLG8d5x1U17ENNfbH2TqpwrLtIx46nZSQs5TnIJt5BlbI5MCOmQu4ITuROoCRXCZo0WPSJH8CYiU/+Md491wXGGxCIn/GXGwr/nM13jEZUsGeZSQqo+qMoW6ofVepTtQcVHsxdR10KGUJxIDDPNLoyRtlZi6aBclpM1VWKtVYGn86kCXOHUq6ymbyA/prg6XMH2W8qfctC4JLBtJ2I0tGIIHIv2XdcK3G7f8oIui+yQeU4EBPEmPFNfYp0Dj8Pja5FNF7DTgLK6Uxy/Y36UnAQudIQGvBNyxZLPQiw1hNGjH8CW+2OjvVhFfU8rU1kodXqBrrVaPFVSpPP3L3cDv7Z6AnNIIyY3fwvwSeQYa5g3A/xgF7BndzKkQeFI1IPk61OZep7b3YWcytUIeiNbFaendBArQP1F31DkqTL7sHMNWT5f4INlpa8n6qFyH8627dLqXYPNL25B/VET+1JcvaB9eb35otCPECNBZo6+wlPOJUSIrXJ9MepXTnu43jdDrSi7e2pWjgX+BzPRaDzK0zFJe0/P29f2uZ7XxAu8yI2pTy3XjmKL9vyexcI4tiBkodMDD2zHIdufRr2ql/DjzlAKmP4v5bISqzGoixE+NzZKF9PSyx6NZ7OQWYz2Q4vasW8xG/XShnAW0Dj0+n1Gtn8AGG5RFecLAAA="
end


--[[
*******************************************
*******************************************
*                                         *
*    Control Functions                    *
*                                         *
*******************************************
*******************************************
]]

-- BreakOut() - exit because we encountered a problem we can't deal with.  Hopefully you'll get some debugging
function BreakOut(exitstring)
    yield("/echo "..exitstring)
    yield("/snd stop")
end

-- VerifyPlugins() - Check to make sure we have all the plugins we need
function VerifyPlugins(PluginList)
    StopFlag = false
    MissingList = ""
    for _, plugin in ipairs(RequiredPlugins) do
        if not HasPlugin(plugin) then
            if StopFlag then
                MissingList = MissingList..", "..plugin
            else
                MissingList = plugin
                StopFlag = true
            end
        end
    end
    if StopFlag then
        BreakOut("Missing required plugin(s): "..MissingList.."! Stopping script. Please install the required plugin(s) and try again.")
    end
end




--[[
*******************************************
*******************************************
*                                         *
*    Travel Functions                     *
*                                         *
*******************************************
*******************************************
]]





--[[
*******************************************
*                                         *
*    Fishing Functions                    *
*                                         *
*******************************************
]]

-- SetReleaseList() - we don't want to keep these fish, so set a release list before we start fishing here.
function SetReleaseList(bitmask)
    yield("/ac \"Release List\"")
    yield("/wait 1")
    yield("/callback FishRelease true 2 "..bitmask.."u "..bitmask.."u")
    yield("/wait 1")
    yield("/callback FishRelease true 0")
    yield("/wait 1")
    yield("/callback FishRelease true 1")
    yield("/wait 1")
end



--[[
*******************************************
*                                         *
*    State Machine High Level             *
*                                         *
*******************************************
]]

--[[
TeleportToFishingZone - Teleport to the zone, making sure we arrive safely before moving on

- If not in the target fishing zone, then
    - teleport to an Aetheryte in that zone
- If in the target fishing zone, then
    - Select one of the fishing hole for the current achievement
    - Change state to go to the fishing hole
]]
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

--[[
GoToFishingHole - Travel within the zone to get to the fishing hole

- Check if not in the target fishing zone, if not, then
    - Change state to get to the fishing hole
    - return from function to let state maching continue
- If stuck in location for > 10 seconds, then adjust position
- If distance to destination is > 10, then 
    - Make sure we're mounted
    - Make sure Pathfind is moving us towards target
    - return from function to let state maching continue
- If distance to destination is =< 10 and we're mounted, then
    - Dismount
    - return from function to let state maching continue
- If none of the above triggers, then
    - We're at destination
    - Change state to start fishing
]]
function GoToFishingHole()
    if not IsInZone(Achievement.zoneId) then
        State = CharacterState.teleportToFishingZone
        LogInfo("["..ThisScriptName.."] TeleportToFishingZone")
        return
    end

    -- if stuck for over 10s, adjust
    local now = os.clock()
    if now - SelectedFishingSpot.startTime > 10 then
        SelectedFishingSpot.startTime = now
        local x = GetPlayerRawXPos()
        local y = GetPlayerRawYPos()
        local z = GetPlayerRawZPos()
        local lastStuckCheckPosition = SelectedFishingSpot.lastStuckCheckPosition
        if GetDistanceToPoint(lastStuckCheckPosition.x, lastStuckCheckPosition.y, lastStuckCheckPosition.z) < 2 then
            LogInfo("["..ThisScriptName.."] Stuck in same spot for over 10 seconds.")
            if PathfindInProgress() or PathIsRunning() then
                yield("/vnav stop")
            end
            local randomX, randomY, randomZ = RandomAdjustCoordinates(x, y, z, 20)
            if randomX ~= nil and randomY ~= nil and randomZ ~= nil then
                PathfindAndMoveTo(randomX, randomY, randomZ, GetCharacterCondition(CharacterCondition.mounted))
            end
            return
        else
            SelectedFishingSpot.lastStuckCheckPosition = { x = x, y = y, z = z }
        end
    end

    if GetDistanceToPoint(SelectedFishingSpot.waypointX, GetPlayerRawYPos(), SelectedFishingSpot.waypointZ) > 10 then
        LogInfo(""..ThisScriptName.."] Too far from waypoint! Currently "..GetDistanceToPoint(SelectedFishingSpot.waypointX, GetPlayerRawYPos(), SelectedFishingSpot.waypointZ).." distance.")
        if not GetCharacterCondition(CharacterCondition.mounted) then
            Mount(CharacterState.goToFishingHole)
            LogInfo("State Change: Mounting")
        elseif not (PathfindInProgress() or PathIsRunning()) then
            LogInfo("["..ThisScriptName.."] Moving to waypoint: ("..SelectedFishingSpot.waypointX..", "..SelectedFishingSpot.waypointY..", "..SelectedFishingSpot.waypointZ..")")
            PathfindAndMoveTo(SelectedFishingSpot.waypointX, SelectedFishingSpot.waypointY, SelectedFishingSpot.waypointZ, true)
        end
        yield("/wait 1")
        return
    end

    if GetCharacterCondition(CharacterCondition.mounted) then
        Dismount()
        LogInfo("["..ThisScriptName.."] State Change: Dismount")
        return
    end

    State = CharacterState.fishing
    LogInfo("["..ThisScriptName.."] State Change: Fishing")
end

--[[
selectAchievement - Get the achievement(s) to complete, and exit the script when done.
- If we don't know have a current achievement, use the specifically requested one, or iterated start from the first
- If the specifically requested one is completed, then exit.
- Otherwise, iterate through the list until we get one that's not complete yet.  If they're all completed, then exit.
]]
function SelectAchievement()
    if Achievement == nil and 
        if TargetAchievement > 0 then
            CurrentFishingSpot = TargetAchievement
        else
            CurrentFishingSpot = 1
        end
        Achievement = ARRFishingAchievements[CurrentFishingSpot]
        return
    else
        if IsAchievementComplete(Achievement.AchievementNumber) and TargetAchievement > 0 then
            LogInfo("["..ThisScriptName.."] Specific requested Achievement completed: "..Achievement.AchievementName)
            StopFlag = true
            return
        elseif IsAchievementComplete(Achievement.AchievementNumber) and TargetAchievement = 0 then
            if CurrentFishingSpot == #ARRFishingAchievements
                LogInfo("["..ThisScriptName.."] All achievements completed")
                StopFlag = true
                return
            else 
                CurrentFishingSpot = CurrentFishingSpot + 1
                Achievement = ARRFishingAchievements[CurrentFishingSpot]
            end
        end
    end
    State = CharacterState.ready
end

--[[
Ready - initialize a cycle
- Make sure food & pots are consumed if needed
- Make sure player is ready to do something
- Change state to do one of:
    - Select Achievement to work (or check completion)
    - Perform repairs
    - Extract materia
    - Check for sufficient bait (and then go buy it if needed)
    - Go to the fishing hole
]]
function Ready()
    FoodCheck()
    PotionCheck()

    if not LogInfo("["..ThisScriptName.."] Ready -> IsPlayerAvailable()") and not IsPlayerAvailable() then
        -- do nothing
    elseif not LogInfo("["..ThisScriptName.."] Ready -> SelectAchievement") and Achievement == nil then
        State = CharacterState.selectAchievement
        LogInfo("["..ThisScriptName.."] State Change: Selecting Achievement")
    elseif not LogInfo("["..ThisScriptName.."] Ready -> SelectAchievement") and IsAchievementComplete(Achievement.AchievementNumber) then
        State = CharacterState.selectAchievement
        LogInfo("["..ThisScriptName.."] State Change: Selecting Achievement")
    elseif not LogInfo("["..ThisScriptName.."] Ready -> Repair") and RepairAmount > 0 and NeedsRepair(RepairAmount) and
        (not shouldWaitForBonusBuff or (SelfRepair and GetItemCount(DarkMatter) > 0)) then
        State = CharacterState.repair
        LogInfo("["..ThisScriptName.."] State Change: Repair")
    elseif not LogInfo("["..ThisScriptName.."] Ready -> ExtractMateria") and ExtractMateria and CanExtractMateria(100) and GetInventoryFreeSlotCount() > 1 then
        State = CharacterState.extractMateria
        LogInfo("["..ThisScriptName.."] State Change: ExtractMateria")
    elseif GetItemCount(VersatileLure) == 0 then
        State = CharacterState.buyFishingBait
        LogInfo("["..ThisScriptName.."] State Change: Buy Fishing Bait")
    else
        State = CharacterState.goToFishingHole
        LogInfo("["..ThisScriptName.."] State Change: GoToFishingHole")
    end
end

--[[
*******************************************
*                                         *
*    Main Execution                       *
*                                         *
*******************************************
]]

-- Make sure that all the plugins we need are installed.
VerifyPlugins(RequiredPlugins)

-- Activate Autohook, delete any "anon_*" presents, and then load our preset as "anon_"
yield("/ahon")
DeleteAllAutoHookAnonymousPresets()
UseAutoHookAnonymousPreset(autohookPreset)

-- Make sure we're a Fisher
if GetClassJobId() ~= FisherJobNum then
    yield("/gs change Fisher")
    yield("/wait 1")
end

-- Prep the state machine
CharacterState = {
    ready = Ready,
    selectAchievement = SelectAchievement,
    teleportToFishingZone = TeleportToFishingZone,
    goToFishingHole = GoToFishingHole,
    extractMateria = ExecuteExtractMateria,
    repair = ExecuteRepair,
    fishing = Fishing,
    goToHubCity = GoToHubCity,
    buyFishingBait = BuyFishingBait
}
StopFlag = false
State = CharacterState.ready

-- Initialize this to nil so we have something to check against in the state machine
Achievement = nil

-- Run the state machine
while not StopFlag do
    State()
    yield("/wait 0.1")
end
