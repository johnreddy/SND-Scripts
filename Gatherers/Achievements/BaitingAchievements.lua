--[[
********************************************************************************
*                                                                              *
*        BaitingAchievements                                                   *
*                                                                              *
********************************************************************************

Intending to assist in the completion of the following Achievements:
- A Fisher's Life for Me: Greater Eorzea
  - Includes "A Fisher's Life for Me: La Noscea"
    - Includes "Good Things Come to Those Who Bait: La Noscea" I, II, III, IV, V
  - Includes "A Fisher's Life for Me: Black Shroud"
    - Includes "Good Things Come to Those Who Bait: Black Shroud" I, II, III, IV, V
  - Includes "A Fisher's Life for Me: Thanalan"
    - Includes "Good Things Come to Those Who Bait: Thanalan" I, II, III, IV, V
- Baiting Heavensward
- Baiting Stormblood
- Baiting Shadowbringers
- Baiting the End
- Baiting Dawntrail

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

UseCordials                = false     --If true, will use cordials when fishing
ExtractMateria             = true      --If true, will extract materia if possible



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
            pointToFace = { x=-66.69, y=45.00, z=-173.75 }
        },
    },
--[[
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

VerifyPlugins(RequiredPlugins)






for _, Achievement in ipairs(ARRFishingAchievements) do
    if IsAchievementComplete(Achievement.AchievementNumber) then
        yield("/echo Completed: "..Achievement.AchievementName..".")
    else
        yield("/echo Needs work: "..Achievement.AchievementName..".")
    end
end


-- Activate Autohook, delete any "anon_*" presents, and then load our preset as "anon_"
yield("/ahon")
DeleteAllAutoHookAnonymousPresets()
UseAutoHookAnonymousPreset(autohookPreset)


-- Make sure we're a Fisher
if GetClassJobId() ~= 18 then
    yield("/gs change Fisher")
    yield("/wait 1")
end

-- Start the state machine
CharacterState = {
    ready = Ready,
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
while not StopFlag do
    State()
    yield("/wait 0.1")
end
