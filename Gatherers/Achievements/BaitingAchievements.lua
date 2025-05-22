--[[
********************************************************************************
*                                                                              *
*        BaitingAchievements                                                   *
*        version 0.9.0                                                         *
*                                                                              *
********************************************************************************

Concept: Iterate through all of the "Baiting" achievements.  If there's one that
hasn't been completed, go to a known fishing site for that achievement, set the 
Release List so that you don't run out of inventory space with useless content, 
fish there using Versatile Lure until you complete the achievement.  Move on to 
the next unfinished achievement in order until done.  Also provide the option
for users to select specific Achievements from this list.

Created by: John 'Skip' Reddy
Inspired by pot0to's FishingGathererScrips - https://github.com/pot0to/pot0to-SND-Scripts

v0.0.1 -> First pass writing/modification of reference code
v0.9.0 -> First testing version.

Assisting in the completion of the following Achievements:
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


********************************************************************************
*                             Required Plugins                                 *
********************************************************************************

1. AutoHook
2. VnavMesh
3. Lifestream
4. TeleporterI

********************************************************************************
*                             Local Settings                                   *
********************************************************************************
Set the following variable for your preferences.
]]

TargetAchievement        = 0 
--[[ TargetAchievement: If set to 0, then we'll cycle through all the achievements
     this character has not finished. Otherwise, select the number of the achievement
     as listed in the section above.  For example, set to 16 for Baiting Heavensward.
]]

UseCordials             = false    --If true, will use cordials when fishing
MoveSpotsAfter          = 30       --Number of minutes to fish at this spot before changing spots.
ResetHardAmissAfter     = 120      --Number of minutes to farm in current instance before teleporting away and back

Food                    = ""
Potion                  = ""
--[[ You don't really need to set Food or Potion.  These determine which consumables we'll be upkeeping.
     Append <hq> if you're using high quality consumables.
     Examples:
Food                    = "Nasi Goreng <hq>"   -- For more GP while gathering
Potion                  = "Superior Spiritbond Potion <hq>" -- If you're gathering, you may as well try for more materia
]]

-- Some settings you will probably want to have enabled
ExtractMateria          = true    --If true, will extract materia if possible
SelfRepair              = true    --If true, will do se;f repair if possible.  If not, it will travel to get repairs.
AutoBuy                 = true    --If true, will travel to Limsa to buy Dark Matter and Bait
RepairAmount            = 20       --repair threshold, adjust as needed



--[[
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

-- RequiredPlugins - what we need to actually run this.
RequiredPlugins = {
    "Lifestream",
    "TeleporterPlugin",
    "vnavmesh",
    "AutoHook",
}

-- autohookPreset - Decide which Preset to use via UseCordials.  Only difference is Cordials or no.
if UseCordials then
    autohookPreset = "AH4_H4sIAAAAAAAACuVWwXKbMBD9lYzOZgawwCY3x3XSzDhppk7bQ6YHGRZbY4IcIdK4Gf97V4BswDhOO7n1Brurt2+1qye9klGuxJhlKhvHC3L+SiYpmycwShJyrmQOPaKdU57C3hkZ1zV+ucOgR+4kF5KrDTl30JpNXsIkjyDam3X8tsS6ESJcarDiw9VfBY4/7JGr9f1SQrYUCVoc224gvw1dYASDxgr7JJnxMn88Uhh1bNpi5LYYGRCRJBAqUwkudOph7mkWQkacJQVA+gzSGJrBvS6WvkOdEyzdhn80F8/Yy5glmUl/ybPlZANZrQCvhel5Tcy+aSZbwWzJY3XBeLEB2pAZw0yxcIWwiFa1+BC4AUsr2DumOKQh1Bj57YV+k5Fnlkr+G8ZMlTNm0von9sivVt8vWcLZKrtkz0JqgIbB1NPvNe1fIcRNxXhHb1PXIUEK7WHqH47322264Isr9ljsyShdJCAzw0dPmEYc2PSg0EaO4RaxJi9KssZp33HVTbsXs19sfZ2qnCsu0ivGU7OTFnKc5hJuIMvYApkQ0iO3BSdyK1AiKoTNGi16RDrwpiJT/4x3h3VBN0NikSP+MmPh3/OZrfHESpaMcykhVR9UZQv1w2rtZHtQcWf2IupSyBCKE4lhptmFMdLWSjsdVM9ysmZKrLUq8HQxU4ArnHqV1fSN5McUV4cr2H5L+VMOGpcEtu1EjIZWDIFj0aHrWoHbH1pe0GeRHTLPiYAg3pRn6kusc+BxeHgtsukCdhpQVneM43fMj5KTwJmO0IC3Qj6y5LMQKw1h9OgHsNX+2GgvVlHf08pUFkqdQaBrrRbPlBTp4v3L3cCvrZ7CAtKIyc3fAnwSOcYa5s0AP9gF7NkdDWlQ6Ii6l3x9LNPAc/u7kGO5GkFvZKvi9JSOYgWov+gbizxVZh92rjHLF0t8vzzq64l6qNyHs227tHrmYPOLW1B/1MS+FFcvaF9ebz4w9JvESJCZo6/wlHMJEWKrXF+M+tHTHq73zVAryu4fm5WuwP9gJhqNR3nqkrT39Lx9bZ/qeU28wIvcmPrUcu0otujAH1gsjGMLQhY6A/DAdhyy/WnUq3oYP+wMpYDp/1IuK7G6AnU2wefGRuliWno5oPF8HjKL0WFoUTv2LWajXtoQzgMah95wyMj2D4fQ4FL2CwAA"
else
    autohookPreset = "AH4_H4sIAAAAAAAACuVWwXLaMBD9lYzOeMY2ssG5EUpoZkiaKWl7yPQg7DVoMBaR5TQ0w793ZVtgGwhpJ7fe7N3V27fa1ZNeySBXYsgylQ3jObl8JaOUzRIYJAm5VDKHDtHOCU9h74yM6wa/3H7QIfeSC8nVhlw6aM1GL2GSRxDtzTp+W2LdChEuNFjx4eqvAsfvd8h4/bCQkC1EghbHthvIb0MXGEGvscI+S2a4yFcnCqOOTVuM3BYjAyKSBEJlKsGFTj3MPc9CyIizpABIn0EaQzO4pOU71DlDy234BzPxjM2LWZKZfNc8W4w2kNUYey1Mz2tidk332BKmCx6rK8aLirUhM4apYuESYRGt6ukhcAOWVrD3THFIQ6gx8tsL/SYjzyyV/DcMmSqHyqT1z+yRX61+WLCEs2V2zZ6F1AANg6mn22nav0KIm4rxjt6mY6cCKbSnp3s4z2+36YrPx2xV7MkgnScgM8NHj5RG7Nn0oNBGjv4WsUYvSrLG8d5x1U17ENNfbH2TqpwrLtIx46nZSQs5TnIJt5BlbI5MCOmQu4ITuROoCRXCZo0WPSJH8CYiU/+Md491wXGGxCIn/GXGwr/nM13jEZUsGeZSQqo+qMoW6ofVepTtQcVHsxdR10KGUJxIDDPNLoyRtlZi6aBclpM1VWKtVYGn86kCXOHUq6ymbyA/prg6XMH2W8qfctC4JLBtJ2I0tGIIHIv2XdcK3G7f8oIui+yQeU4EBPEmPFNfYp0Dj8Pja5FNF7DTgLK6Uxy/Y36UnAQudIQGvBNyxZLPQiw1hNGjH8CW+2OjvVhFfU8rU1kodXqBrrVaPFVSpPP3L3cDv7Z6AnNIIyY3fwvwSeQYa5g3A/xgF7BndzKkQeFI1IPk61OZep7b3YWcytUIeiNbFaendBArQP1F31DkqTL7sHMNWT5f4INlpa8n6qFyH8627dLqXYPNL25B/VET+1JcvaB9eb35otCPECNBZo6+wlPOJUSIrXJ9MepXTnu43jdDrSi7e2pWjgX+BzPRaDzK0zFJe0/P29f2uZ7XxAu8yI2pTy3XjmKL9vyexcI4tiBkodMDD2zHIdufRr2ql/DjzlAKmP4v5bISqzGoixE+NzZKF9PSyx6NZ7OQWYz2Q4vasW8xG/XShnAW0Dj0+n1Gtn8AGG5RFecLAAA="
end

-- Where to buy fishing bait
Material = {
     VersatileLure= {
        itemNumber = 29717,
        itemName = "Versatile Lure",
        vendor = {
            npcName = "Merchant & Mender",
            shopItemEntry = 3,
            x=-398, y=3, z=80,
            zoneId = 129,
            aetheryte = "Limsa Lominsa",
            aethernet = {
                name = "Arcanists' Guild",
                x=-336, y=12, z=56,
            },
        },
    },
    DarkMatter = {
        itemNumber = 33916,
        itemName = "Dark Matter Grade 8",
        vendor = {
            npcName = "Unsynrael",
            shopItemEntry = 40,
            x=-257.71, y=16.19, z=50.11,
            zoneId = 129,
            aetheryte = "Limsa Lominsa",
            aethernet = {
                name = "Hawkers' Alley",
                x=-213.95, y=15.99, z=49.35
            },
        },
    },
}

-- Descibe the name and location of the Mender you wish 
mender = { 
    npcName="Alistair", 
    x=-246.87, y=16.19, z=49.83,
    zoneId = 129,
    aetheryte = "Limsa Lominsa",
    aethernet = {
        name = "Hawkers' Alley",
        x=-213.95, y=15.99, z=49.35,
    },
}

-- Various character conditions and their numerical values
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


--[[
********************************************************************************
*                                                                              *
*    Support Functions                                                         *
*                                                                              *
********************************************************************************
]]

--[[ GetClosestAetheryte() - Get the closest Aetheryte (direct line) to the target location in the zone
-
]]
function GetClosestAetheryte(x, y, z, zoneId, teleportTimePenalty)
    local closestAetheryte = nil
    local closestTravelDistance = math.maxinteger
    local zoneAetherytes = GetAetherytesInZone(zoneId)
    for i=0, zoneAetherytes.Count-1 do
        local aetheryteId = zoneAetherytes[i]
        local aetheryteRawPos = GetAetheryteRawPos(aetheryteId)
        LogInfo(aetheryteRawPos)
        local distanceAetheryteToPoint = DistanceBetween(aetheryteRawPos.Item1, y, aetheryteRawPos.Item2, x, y, z)
        local comparisonDistance = distanceAetheryteToPoint + teleportTimePenalty
        local aetheryteName = GetAetheryteName(aetheryteId)
        LogInfo("["..ThisScriptName.."] Distance via "..aetheryteName.." adjusted for tp penalty is "..tostring(comparisonDistance))

        if comparisonDistance < closestTravelDistance then
            LogInfo("["..ThisScriptName.."] Updating closest aetheryte to "..aetheryteName)
            closestTravelDistance = comparisonDistance
            closestAetheryte = {
                aetheryteId = aetheryteId,
                aetheryteName = aetheryteName
            }
        end
    end

    return closestAetheryte
end


--[[ TeleportTo() - Given an aetheryte name, teleport there
-
]]
function TeleportTo(aetheryteName)
    yield("/tp "..aetheryteName)
    yield("/wait 1") -- wait for casting to begin
    while GetCharacterCondition(CharacterCondition.casting) do
        LogInfo("["..ThisScriptName.."] Casting teleport...")
        yield("/wait 1")
    end
    yield("/wait 1") -- wait for that microsecond in between the cast finishing and the transition beginning
    while GetCharacterCondition(CharacterCondition.betweenAreas) do
        LogInfo("["..ThisScriptName.."] Teleporting...")
        yield("/wait 1")
    end
    yield("/wait 1")
end


--[[ VerifyPlugins() - Check to make sure we have all the plugins we need
Iterate through the plugins we need.  If none are valid, then stop SND, because needs fixed
]]
function VerifyPlugins(PluginList)
    BreakOut = false
    MissingList = ""
    for _, plugin in ipairs(RequiredPlugins) do
        if not HasPlugin(plugin) then
            if BreakOut then
                MissingList = MissingList..", "..plugin
            else
                MissingList = plugin
                BreakOut = true
            end
        end
    end
    if BreakOut then
        Message="["..ThisScriptName.."] Missing required plugin(s): "..MissingList.."! Stopping script. Please install the required plugin(s) and try again."
        yield("/echo "..Message)
        LogInfo(Message)
        yield("/snd stop")
    end
end


--[[  FoodCheck() - ensure that if a Food item has been specified, it's running
]]
function FoodCheck()
    if not HasStatusId(48) and Food ~= "" then
        yield("/item " .. Food)
    end
end


--[[   PotionCheck() - ensure that if a Potion item has been specified, it's running
]]
function PotionCheck()
    if not HasStatusId(49) and Potion ~= "" then
        yield("/item " .. Potion)
    end
end


--[[  Mount() - Get on a mount
- If mounted, then jump, else, get on mount roulette
]]
function Mount()
    if GetCharacterCondition(CharacterCondition.mounted) then
        yield("/gaction jump")
    else
        yield('/gaction "mount roulette"')
    end
    yield("/wait 1")
end


--[[  Dismount() - Get off the mount
- If moving courtesy vnav, then stop
- If mounted in the air or on the ground, dismount
]]
function Dismount()
    if PathIsRunning() or PathfindInProgress() then
        yield("/vnav stop")
        return
    end

    if GetCharacterCondition(CharacterCondition.flying) or GetCharacterCondition(CharacterCondition.mounted) then
        yield('/ac dismount')
    end
    yield("/wait 1")
end


--[[ GoShopping() - Teleport to the town, use the fastest route to the vendor, buy the item
The neededItem variable should have the following structure
    neededItem = {
            itemNumber = number,
            itemName = string,
            vendor = {
                npcName = string,
                shopItemEntry = number,
                x=-number, y=number, z=number,
                zoneId = number,
                aetheryte = string,
                aethernet = {
                    name = string,
                    x=-number, y=number, z=number,
                },
            },
]]
function GoShopping(neededItem)
    local distanceToMerchant = GetDistanceToPoint(neededItem.vendor.x, neededItem.vendor.y, neededItem.vendor.z)
    local distanceViaAethernet = DistanceBetween(neededItem.vendor.aethernet.x, neededItem.aethernet.vendor.y, neededItem.aethernet.vendor.z,neededItem.vendor.x, neededItem.vendor.y, neededItem.vendor.z)
    -- Get to town
    if not IsInZone(neededItem.vendor.zoneId) then
        if Echo == "All" then
            yield("/echo Out of "..neededItem.itemName.."! Purchasing more from "..neededItem.vendor.aetheryte..".")
        end
        TeleportTo(neededItem.vendor.aetheryte)
        return
    end
    -- Grab Aethernet if it's faster
    if distanceToMerchant > (distanceViaAethernet + 20) then
        if not LifestreamIsBusy() then
            yield("/li "..neededItem.vendor.aethernet.name)
        end
        return
    end
    -- TODO: Identify why multiple scripts use this TelepotTown snippit
    if IsAddonVisible("TelepotTown") then
        yield("/callback TelepotTown false -1")
        return
    end
    -- Use pathfinding to get to the merchant
    if distanceToMerchant > 5 then
        if not (PathfindInProgress() or PathIsRunning()) then
            PathfindAndMoveTo(neededItem.vendor.x, neededItem.vendor.y, neededItem.vendor)
        end
        return
    end
    -- Target the vendor
    if not HasTarget() or GetTargetName() ~= neededItem.vendor.npcName then
        yield("/target "..neededItem.vendor.npcName)
        return
    end
    -- Perform the transaction
    if not GetCharacterCondition(CharacterCondition.occupiedInQuestEvent) then
        yield("/interact")
    elseif IsAddonVisible("SelectYesno") then
        yield("/callback SelectYesno true 0")
    elseif IsAddonVisible("Shop") then
        yield("/callback Shop true 0 "..neededItem.vendor.shopItemEntry.." 99 0")
    end
    State = CharacterState.ready
end


--[[ RandomAdjustCoordinates() - randomly select a point within maxDistance of a given point.
- 
]]
function RandomAdjustCoordinates(x, y, z, maxDistance)
    local angle = math.random() * 2 * math.pi
    local x_adjust = maxDistance * math.random()
    local z_adjust = maxDistance * math.random()

    local randomX = x + (x_adjust * math.cos(angle))
    local randomY = y + maxDistance
    local randomZ = z + (z_adjust * math.sin(angle))

    return randomX, randomY, randomZ
end


--[[ InterpolateCoordinates() - 
- 
]]
function InterpolateCoordinates(startCoords, endCoords, n)
    local x = startCoords.x + n * (endCoords.x - startCoords.x)
    local y = startCoords.y + n * (endCoords.y - startCoords.y)
    local z = startCoords.z + n * (endCoords.z - startCoords.z)
    return {waypointX=x, waypointY=y, waypointZ=z}
end


--[[ GetWaypoint() - 
Use the Wayponts defined in the Achievement to describe a line, moving around potential obstacles.
Select a point on that line where someone can land on and begin the fishing attempt from.  The
Point on that line is passed as "n", which should be a number between 0 and 1.
]]
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


--[[ SelectNewFishingHole() - Randomly pick one of the predefined waypoints for the target Achievement.
- 
]]
function SelectNewFishingHole()
    LogInfo("["..ThisScriptName.."] Selecting new fishing hole")
    -- Select a waypoint at random
    SelectedFishingSpot = GetWaypoint(Achievement.fishingSpots.waypoints, math.random())
    SelectedFishingSpot.waypointY = QueryMeshPointOnFloorY(
        SelectedFishingSpot.waypointX, Achievement.fishingSpots.maxHeight, SelectedFishingSpot.waypointZ, false, 50)
    -- Record the pointToFace (approximate center of the fishing spot)
    SelectedFishingSpot.x = Achievement.fishingSpots.pointToFace.x
    SelectedFishingSpot.y = Achievement.fishingSpots.pointToFace.y
    SelectedFishingSpot.z = Achievement.fishingSpots.pointToFace.z
    -- Record when we're starting so that we know when to move on, or check for being stuck
    SelectedFishingSpot.startTime = os.clock()
    SelectedFishingSpot.lastStuckCheckPosition = {
        x=GetPlayerRawXPos(), y=GetPlayerRawYPos(), z=GetPlayerRawZPos()
    }
    SelectedFishingSpot.active = false
end


--[[ SetReleaseList() - we don't want to keep these fish, so set a release list before we start fishing here.
-
]]
function SetReleaseList(NumberOfFish)
    bitmask = math.floor(2^NumberOfFish-1)
    yield("/ac \"Release List\"")
    yield("/wait 1")
    yield("/callback FishRelease true 2 "..bitmask.." "..bitmask)
    yield("/wait 0.3")
    yield("/callback FishRelease true 0")
    yield("/wait 0.3")
    yield("/callback FishRelease true 1")
    yield("/wait 0.3")
end


--[[
********************************************************************************
*                                                                              *
*    State Machine High Level                                                  *
*                                                                              *
********************************************************************************
]]

--[[ Fishing() - 
- 
]]
function Fishing()
    if GetItemCount(Material.VersatileLure.itemNumber) == 0 then
        LogInfo("State Change: Fishing -> Buy Fishing Bait")
        State = CharacterState.buyFishingBait
        return
    end
    
    if os.clock() - ResetHardAmissTime > (ResetHardAmissAfter*60) then
        if GetCharacterCondition(CharacterCondition.gathering) then
            if not GetCharacterCondition(CharacterCondition.fishing) then
                yield("/ac Quit")
                yield("/wait 1")
                yield("/ahoff")
                yield("/wait 1")
            end
        else
            State = CharacterState.teleportToFishingZone
            LogInfo("["..ThisScriptName.."] State Change: Fishing -> TeleportToFishingZone")
        end
        return
    elseif os.clock() - SelectedFishingSpot.startTime > (MoveSpotsAfter*60) then
        LogInfo("["..ThisScriptName.."] Switching fishing spots")
        if GetCharacterCondition(CharacterCondition.gathering) then
            if not GetCharacterCondition(CharacterCondition.fishing) then
                yield("/ac Quit")
                yield("/wait 1")
                yield("/ahoff")
                yield("/wait 1")
            end
        else
            SelectNewFishingHole()
            State = CharacterState.ready
            LogInfo("["..ThisScriptName.."] State Change: Timeout Ready")
        end
        return
    elseif GetCharacterCondition(CharacterCondition.gathering) then
        if (PathfindInProgress() or PathIsRunning()) then
            yield("/vnav stop")
        end
        yield("/wait 1")
        return
    end

    LogInfo("Checking to see if stuck")
    if os.clock() - SelectedFishingSpot.startTime > 10 then
        local x = GetPlayerRawXPos()
        local y = GetPlayerRawYPos()
        local z = GetPlayerRawZPos()
        local lastStuckCheckPosition = SelectedFishingSpot.lastStuckCheckPosition
        if GetDistanceToPoint(lastStuckCheckPosition.x, lastStuckCheckPosition.y, lastStuckCheckPosition.z) < 2 then
            LogInfo("["..ThisScriptName.."] Stuck in same spot for over 10 seconds.")
            if PathfindInProgress() or PathIsRunning() then
                yield("/vnav stop")
            end
            SelectNewFishingHole()
            State = CharacterState.ready
            LogInfo("["..ThisScriptName.."] State Change: Stuck Ready")
            return
        else
            SelectedFishingSpot.lastStuckCheckPosition = { x = x, y = y, z = z }
        end
    end

    -- run towards fishing hole and cast until the fishing line hits the water
    LogInfo("-- run towards fishing hole and cast until the fishing line hits the water")
    if not PathfindInProgress() and not PathIsRunning() then
        PathMoveTo(SelectedFishingSpot.x, SelectedFishingSpot.y, SelectedFishingSpot.z)
        return
    end
    yield("/ac Cast")
    yield("/wait 0.1")
    LogInfo("We've found somewhere to fish")
    if GetCharacterCondition(CharacterCondition.fishing) and not SelectedFishingSpot.active then
        -- If we've found a location to fish, immediately stop fishing
        yield("/wait 1")
        yield("/ahoff")
        yield("/wait 1")
        yield("/ac Rest")
        yield("/wait 2")
        -- Set the Realease List so that inventory doesn't fill up.
        SetReleaseList(Achievement.NumberOfFish)
        -- Enable AutoHook, and start.
        yield("/ahon")
        yield("/wait 0.3")
        yield("/ahstart")
        yield("/wait 0.1")
        SelectedFishingSpot.active = true
    end
end


--[[ BuyDarkMatter - 
- 
]]
function BuyDarkMatter()
    GoShopping(Material.DarkMatter)
end

--[[ BuyFishingBait - 
- 
]]
function BuyFishingBait()
    GoShopping(Material.VersatileLure)
end


--[[ ExecuteRepair - If gear needs to be repaired, then do that.
- 
]]
function ExecuteRepair()
    -- Not sure why this is here
    if IsAddonVisible("SelectYesno") then
        yield("/callback SelectYesno true 0")
        return
    end
    -- If Repair window open, try to repair.
    if IsAddonVisible("Repair") then
        if not NeedsRepair(RepairAmount) then
            yield("/callback Repair true -1") -- if you don't need repair anymore, close the menu
        else
            yield("/callback Repair true 0") -- select repair
        end
        return
    end
    -- if occupied by repair, then just wait
    if GetCharacterCondition(CharacterCondition.occupiedMateriaExtractionAndRepair) then
        LogInfo("["..ThisScriptName.."] Repairing...")
        yield("/wait 1")
        return
    end
    -- Open repair window if you're doing a self repair, or close it if we're done
    if SelfRepair then
        if GetItemCount(DarkMatter) > 0 then
            if NeedsRepair(RepairAmount) then
                if not IsAddonVisible("Repair") then
                    LogInfo("["..ThisScriptName.."] Opening repair menu...")
                    yield("/generalaction repair")
                end
            else
                -- No more repairs needed.  Go back to Ready state
                State = CharacterState.ready
                LogInfo("["..ThisScriptName.."] State Change: Ready")
            end
        else
            if Echo == "All" then
                yield("/echo Out of Dark Matter and \"AutoBuy\" is false. Switching to Limsa mender.")
            end
            SelfRepair = false
        end
    else
        -- We're not self-repairing, so heading to our selected repair shop
        if NeedsRepair(RepairAmount) then
            if not IsInZone(mender.zoneId) then
                TeleportTo(mender.aetheryte)
                return
            end
            -- We're in town now, get distances to pick the fastest route
            local distanceToMender = GetDistanceToPoint(mender.x, mender.y, mender.z)
            local distanceViaAethernet = DistanceBetween(mender.aethernet.x, mender.aethernet.y, mender.aethernet.z,mender.x, mender.y, mender.z)
            if distanceToMender > (distanceViaAethernet + 10) then
                yield("/li "..mender.aethernet.name)
                yield("/wait 1") -- give it a moment to register
            -- TODO: Identify why multiple scripts use this TelepotTown snippit
            elseif IsAddonVisible("TelepotTown") then
                yield("/callback TelepotTown false -1")
            -- Keep moving towards the destination
            elseif GetDistanceToPoint(mender.x, mender.y, mender.z) > 5 then
                if not (PathfindInProgress() or PathIsRunning()) then
                    PathfindAndMoveTo(mender.x, mender.y, mender.z)
                end
            else
                -- At the vendor, now open the repair dialog
                if not HasTarget() or GetTargetName() ~= mender.npcName then
                    yield("/target "..mender.npcName)
                elseif not GetCharacterCondition(CharacterCondition.occupiedInQuestEvent) then
                    yield("/interact")
                end
            end
        else
            -- No more repairs needed.  Go back to Ready state
            State = CharacterState.ready
            LogInfo("["..ThisScriptName.."] State Change: Ready")
        end
    end
end

--[[ ExecuteExtractMateria - If there's more than 1 free space in inventory, extract the next available materia.
- Make sure we're unmounted
- Make sure we're not doing anything and are able to extact
- If there's materia to extract and more than one inventory space available then extract one materia
- If there's no more materia to extract, then change State to Ready
]]
function ExecuteExtractMateria()
    -- Make sure we're unmounted
    if GetCharacterCondition(CharacterCondition.mounted) then
        Dismount()
        LogInfo("["..ThisScriptName.."] State Change: Dismounting")
        return
    end
    -- If we're doing something, wait a little bit
    if GetCharacterCondition(CharacterCondition.occupiedMateriaExtractionAndRepair) then
        return
    end
    -- Open materia extraction window and start extracting until there's nothing left to extract
    if CanExtractMateria(100) and GetInventoryFreeSlotCount() > 1 then
        if not IsAddonVisible("Materialize") then -- open material window
            yield("/generalaction \"Materia Extraction\"")
            yield("/wait 1") -- give it a second to stick
            return
        end
        LogInfo("["..ThisScriptName.."] Extracting materia...")
        if IsAddonVisible("MaterializeDialog") then
            yield("/callback MaterializeDialog true 0")
        else
            yield("/callback Materialize true 2 0")
        end
    else
        if IsAddonVisible("Materialize") then
            yield("/callback Materialize true -1")
        else
            State = CharacterState.ready
            LogInfo("["..ThisScriptName.."] State Change: Ready")
        end
    end
end

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
    else
        SelectNewFishingHole()
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
    -- Get mounted, move closer to destination
    if GetDistanceToPoint(SelectedFishingSpot.waypointX, GetPlayerRawYPos(), SelectedFishingSpot.waypointZ) > 11 then
        LogInfo("["..ThisScriptName.."] Too far from waypoint! Currently "..GetDistanceToPoint(SelectedFishingSpot.waypointX, GetPlayerRawYPos(), SelectedFishingSpot.waypointZ).." distance.")
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
    -- At destination, unmount
    if GetCharacterCondition(CharacterCondition.mounted) then
        LogInfo("["..ThisScriptName.."] Action: Dismount")
        Dismount()
        return
    end
    -- Okay we're there, now we can start fishing
    LogInfo("["..ThisScriptName.."] State Change: GoToFishingHole -> Fishing")
    State = CharacterState.fishing
end

--[[
selectAchievement - Get the achievement(s) to complete, and exit the script when done.
- If we don't know have a current achievement, use the specifically requested one, or iterated start from the first
- If the specifically requested one is completed, then exit.
- Otherwise, iterate through the list until we get one that's not complete yet.  If they're all completed, then exit.
]]
function SelectAchievement()
    if Achievement == nil then 
        if TargetAchievement > 0 then
            CurrentFishingSpot = TargetAchievement
        else
            CurrentFishingSpot = 1
        end
        Achievement = ARRFishingAchievements[CurrentFishingSpot]
        Achievement.closestAetheryte = GetClosestAetheryte(
            Achievement.fishingSpots.pointToFace.x,
            Achievement.fishingSpots.pointToFace.y,
            Achievement.fishingSpots.pointToFace.z,
            Achievement.zoneId,
            0)
        LogInfo("Selected Achievement: "..Achievement.AchievementName)
        return
    else
        if IsAchievementComplete(Achievement.AchievementNumber) and TargetAchievement > 0 then
            LogInfo("["..ThisScriptName.."] Specific requested Achievement completed: "..Achievement.AchievementName)
            StopFlag = true
            return
        elseif IsAchievementComplete(Achievement.AchievementNumber) and TargetAchievement == 0 then
            if CurrentFishingSpot == #ARRFishingAchievements then
                LogInfo("["..ThisScriptName.."] All achievements completed")
                StopFlag = true
                return
            else 
                CurrentFishingSpot = CurrentFishingSpot + 1
                Achievement = ARRFishingAchievements[CurrentFishingSpot]
                Achievement.closestAetheryte = GetClosestAetheryte(
                    Achievement.fishingSpots.pointToFace.x,
                    Achievement.fishingSpots.pointToFace.y,
                    Achievement.fishingSpots.pointToFace.z,
                    Achievement.zoneId,
                    0)
                LogInfo("Selected Achievement: "..Achievement.AchievementName)
                return
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
    - Select Achievement to work on
    - Check for Achievement completion
    - Check for sufficient bait (and then go buy it if needed)
    - Check for sufficient dark matter (and then go buy it if needed)
    - Perform repairs
    - Extract materia
    - Go to the fishing hole
]]
function Ready()
    FoodCheck()
    PotionCheck()

    if not LogInfo("["..ThisScriptName.."] Ready -> IsPlayerAvailable()") and not IsPlayerAvailable() then
        -- do nothing
    elseif not LogInfo("["..ThisScriptName.."] Ready -> SelectAchievement") and Achievement == nil then
        State = CharacterState.selectAchievement
        LogInfo("["..ThisScriptName.."] State Change: Selecting Achievement, select first")
    elseif not LogInfo("["..ThisScriptName.."] Ready -> SelectAchievement") and IsAchievementComplete(Achievement.AchievementNumber) then
        State = CharacterState.selectAchievement
        LogInfo("["..ThisScriptName.."] State Change: Selecting Achievement, need a new one")
    elseif AutoBuy and GetItemCount(Material.VersatileLure.itemNumber) == 0 then
        State = CharacterState.buyFishingBait
        LogInfo("["..ThisScriptName.."] State Change: GoShopping, "..Material.VersatileLure.itemName)
    elseif AutoBuy and GetItemCount(Material.DarkMatter.itemNumber) < 12 then
        State = CharacterState.buyDarkMatter
        LogInfo("["..ThisScriptName.."] State Change: GoShopping, "..Material.DarkMatter.itemName)
    elseif not LogInfo("["..ThisScriptName.."] Ready -> Repair") and RepairAmount > 0 and NeedsRepair(RepairAmount) then
        State = CharacterState.repair
        LogInfo("["..ThisScriptName.."] State Change: Repair")
    elseif not LogInfo("["..ThisScriptName.."] Ready -> ExtractMateria") and ExtractMateria and CanExtractMateria(100) and GetInventoryFreeSlotCount() > 1 then
        State = CharacterState.extractMateria
        LogInfo("["..ThisScriptName.."] State Change: ExtractMateria")
    else
        State = CharacterState.goToFishingHole
        LogInfo("["..ThisScriptName.."] State Change: GoToFishingHole")
    end
end

--[[
********************************************************************************
*                                                                              *
*    Main Execution                                                            *
*                                                                              *
********************************************************************************
]]

-- ResetHardAmissTime - used to make sure we don't spend too long in a zone without teleporting.
-- Setting at start of Main execution in case we don't actually teleport into the target zone.
ResetHardAmissTime = os.clock()

-- Make sure that all the plugins we need are installed.
VerifyPlugins(RequiredPlugins)

-- Delete any "anon_*" presents, and then load our preset as "anon_"
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
    buyDarkMatter = BuyDarkMatter,
    buyFishingBait = BuyFishingBait,
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
