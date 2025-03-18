--[[
********************************************************************************
*                             *
*                            *
********************************************************************************

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






--[[
*******************************************
*******************************************
*                                         *
*    Standard Variables                   *
*                                         *
*******************************************
*******************************************
]]

--[[
ARRFishingAchievements - List of Achievements to complete, and where to fish for them.
    AchievementName   - Name as listed in Achievements -> Crafting & Gathering -> Fisher
    AchievementNumber - RowID from SND Excel Browser -> Achievement
    Location          - Area to fish
    ReleaseBitmask    - Unsigned Int for setting the Release List; we don't want to keep these fish
]]
ARRFishingAchievements = 
{
    {
        AchievementName = "Good Things Come to Those Who Bait: La Noscea I",
        AchievementNumber = 259,
        Location = "",
        ReleaseBitmask = ,
    },
    {
        AchievementName = "Good Things Come to Those Who Bait: La Noscea II",
        AchievementNumber = 261,
        Location = "",
        ReleaseBitmask = ,
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
    {
        AchievementName = "Good Things Come to Those Who Bait: Thanalan III",
        AchievementNumber = 273,
        Location = "",
        ReleaseBitmask = ,
    },
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
}

-- RequiredPlugins - set the basic list of variables
RequiredPlugins = {
    "Lifestream",
    "TeleporterPlugin",
    "vnavmesh",
    "AutoHook"
}
if Retainers then
    table.insert(RequiredPlugins, "AutoRetainer")
end
if GrandCompanyTurnIn then
    table.insert(RequiredPlugins, "Deliveroo")
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
    yield("/e "..exitstring)
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
*******************************************
*                                         *
*    Fishing Functions                    *
*                                         *
*******************************************
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
*******************************************
*                                         *
*    Main Loop                            *
*                                         *
*******************************************
*******************************************
]]

for _, Achievement in ipairs(ARRFishingAchievements) do
    if IsAchievementComplete(Achievement.AchievementNumber) then
        yield("/echo Completed: "..Achievement.AchievementName..".")
    else
        yield("/echo Needs work: "..Achievement.AchievementName..".")
    end
end
