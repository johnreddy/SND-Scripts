---
# FATE scripts

FATE centered SND2 lua scripts. 

## Scripts
- FATE Farming
  - Farm FATEs in given area
  - Purchase Bicolor gemstone items
  - Process Retainers when available 
- Companion Scripts
  - Multi Zone Farming
    - Multi zone farming script meant to be used with `Fate Farming.lua`.  Use in Dawntrail content
  - Relic Fodder
    - Farming script meant to be used with `Fate Farming.lua`.  Select the type of relic fodder you want, and the number of each you want.

## Known Issues
- None at the moment

## Installation
- Copy script's Github URL and paste into SND2 GitHub URL option to import and update.  ie.:
  - `https://github.com/johnreddy/SND-Scripts/blob/main/FATEs/Fate%20Farming.lua`
### or
- Copy script's contents and paste into a new lua macro and update manually. 


## History
These scripts originally created by [pot0to](https://github.com/pot0to/), then updated for SND2 by [baanderson40](https://github.com/baanderson40). 

# General how-to
## Get the Necessary plugins
Ensure you have the plugin repositories configured:
* https://puni.sh/api/repository/veyn
* https://puni.sh/api/repository/croizat
* https://github.com/NightmareXIV/MyDalamudPlugins/raw/main/pluginmaster.json

Then, install the following plugins
* **TextAdvance**
* **Lifestream**
* **vnavmesh**
* An auto-rotation tool (This example uses **Boss Mod**)
* An auto-dodge tool (This example uses **Boss Mod**)
* **Something Need Doing** (aka SND)

## Configure TextAdvance
No work needed here

## Configure Lifestream
No work required here

## Configure vnavmesh
No work required here

## Configure Boss Mod
You will have to design two Autorotation Presets.  The first is for general work. The other is for single targets, specifically for when Forlorn Maiden/The Forlorn shows up.  I set mine up for Warrior, because of its ability to take hits and heal itself.
### "WAR AOE"
<img align=right width="412" height="91" alt="image" src="https://github.com/user-attachments/assets/3d8645f1-9928-4eac-9886-ff37121a52e4" />Note the name of your rotation.  I named mine "WAR AOE" because ... well that's the goal.  I added the following sets to WAR AOE, and then set the following settings for each:
* FATE helper
  * **Hand-in**: Automatically hand in FATE items at 10+
  * **Collect**: Try to collect FATE items instead of engaging
  * **Sync**: Do nothing
* Veyn WAR
  * **AOE**: Use aoe rotation if 3+ targets would be hit; break combo if necessary
  * **Burst**: Spend gauge freely
  * **Potion**: Do not use automatically
  * **Infuriate**: Try to delay uses until raidbuffs, avoiding overcap
  * **IR** (Inner Release): Use normally (whenever ST is up)
  * **Upheaval**: Use normally (ASAP, assuming ST is up)
  * **PR** (Primal Rend): Use normally: rend only when already in melee
  * **Onslaught**: Use as gapcloser if outside melee range
  * **Tomahawk**: Use if outsidew melee range
  * **Wrath**: Use normally (ASAP, assuming ST is up)
  * **Bozja**: Use generic buff lost actions together
* Utility: WAR
  * **Vengeance**: Use Vengeance_  (Allows the ability to function in pre-DT content)
  * **Rampart**: Use Rampart
  * **Thrill**: Use Thrill of Battle
  * **Holmgang**: Do not use automatically
  * **BW** (Bloodwhetting): Use Raw Intuition  (Allows the ability to function in pre-DT content)
  * **Equi** (Equilibrium): Use Equilibrium
  * **ArmsL** (Arms Length): Use Arms Length
  * **Reprisal**: Use Reprisal (10s)  (Allows the ability to function in pre-DT content)
  * **SIO** (Shake It Off): Use Shake It Off
  * **Provoke**: Do not use automatically
  * **Shirk**: Do not use automatically
  * **Spring**: Use Sprint
  * **Stance**: Use stance if not already active
  * **LB** (Limit Break): Do not use automatically
* Automatic Movement
  * **Desination**: Use standard pathfinding to find best position
  * **Overdodge**: Prefer to stay 0.5y away from forbidden zone
  * **Range**: Go directly to destination
  * **Cast**: Continue slidecasting as long as there is enough time to get to safety
  * **Delay Movement**: Do not delay movement
### "WAR ST"
The single-target rotation is the same as the "WAR AOE" rotation with the following changes:
* FATE helper
  * This toolset is not included
* Veyn WAR
  * **AOE**: Use single-target rotation
* Utility: WAR
  * No changes
* Automatic Movement
  * No changes
 
## Configure Something Need Doing
Load in your scripts, and then configure them.  Note, you can choose to just run [Fate Farming.lua](https://github.com/johnreddy/SND-Scripts/blob/main/FATEs/Fate%20Farming.lua).  It will automatically farm the zone you're currently in until you manually stop it.  If you want to run with a purpose, then use [Multi Zone Farming.lua](https://github.com/johnreddy/SND-Scripts/blob/main/FATEs/Multi%20Zone%20Farming.lua) or [Relic Fodder.lua](https://github.com/johnreddy/SND-Scripts/blob/main/FATEs/Relic%20Fodder.lua), which will Zone-jump as needed to meet your goals.
### Load your scripts
In MacrosLibray, create a new macro.  You can copy and paste, but I prefer to do Git syncs.
1. Add Fate Farming.lua
  1. Click "Creat a new macro"
  2. **Name**: Fate Farming
  3. **Type**: Lua
  4. **GitHub URL**: copy in the URL for [Fate Farming.lua](https://github.com/johnreddy/SND-Scripts/blob/main/FATEs/Fate%20Farming.lua)
2. Add Multi Zone Farming.lua (optional)
  1. Click "Creat a new macro"
  2. **Name**: Multi Zone Farming
  3. **Type**: Lua
  4. **GitHub URL**: copy in the URL for [Multi Zone Farming.lua](https://github.com/johnreddy/SND-Scripts/blob/main/FATEs/Multi%20Zone%20Farming.lua)
3. Add Relic Fodder.lua (optional)
  1. Click "Creat a new macro"
  2. **Name**: Relic Fodder
  3. **Type**: Lua
  4. **GitHub URL**: copy in the URL for [Relic Fodder.lua](https://github.com/johnreddy/SND-Scripts/blob/main/FATEs/Relic%20Fodder.lua)

### Configure Fate Farming
<img width="505" align=right height="112" alt="image" src="https://github.com/user-attachments/assets/6ff357b2-3858-41a9-84a8-19a596153bdd" />
When you've got Something Need Doing (SND) open, select the Fate Farming script and click the gear icon in the top right of the SND window to make sure the config options for Fate Farming Showing.  It will also automatically teleport to the appropriate vendor for restocking Gysahl Greens or Dark Matter, or spending your Bicolor Gemstones on the item you select.
* **Rotation Plugin**: BossMod  (You can use any of the ones listed, I just use BossMod for the example)
* **Dodging Plugin**: None  (if using BossMod or BossModReborn for rotation, you don't need to specify)
* **BMR/VBM Specific Settings**: This is a do-nothing field to note the following features are for Boss Mod Reborn (BMR) and Boss Mod (VBM) users
* **Single Target Rotation**: WAR ST  (as noted in the example above)
* **AoE Rotation**: WAR AOE  (as noted in the example above)
* **Hold Buff Rotation**: WAR AOE  (uses the AoE rotation, because I don't both with Holding the buff rotation)
* **Food**: Text entry for whatever food type you want.  You need to specify "<HQ>" if your food is High QUality.  For example "Mate Cookie" versus "Mate Cookie <HQ>"
* **Potion**:  Text entry for whatever food type you want.  You need to specify "<HQ>" if your food is High QUality.  For example "Superior Spiritbond Potion" versus "Superior Spiritbond Potion <HQ>"
* **Exchange bicolor gemstones for**: Exhaustive pull-down list.
* **Pause for retainers**: Will periodically use the [AutoRetainer](https://github.com/PunishXIV/AutoRetainer) plugin.  Use if ya like.
* **Dump extra gear at GC**: Will periodically use the [AutoRetainer](https://github.com/PunishXIV/AutoRetainer) plugin.  Use if ya like.
* **Companion Script Mode**: If you're going to use this script alone to just farm a single zone, then leave it unchecked.  If you're going to use this script with the companion scripts, then check here.

### Configure Multi Zone Farming
The configuration is simple.  Make a note of the name you gave Fate Farming.lua up above in the "Load your scripts" section.  
* **FateMacro**: Fate Farming
  
### Configure Relic Fodder
The configuration is slightly more complex than Multi Zone Farming.  Make a note of the name you gave Fate Farming.lua up above in the "Load your scripts" section.  
* **FateMacro**: Fate Farming
* **RelicFodderTarget**: Pull down for which Relic Fodder you want
  * **2.2 - Atma** - For [Up in Arms](https://ffxiv.consolegameswiki.com/wiki/Up_in_Arms)
  * **5.35 - Memories** - Tortured, Sorrowful, Harrowing Memory of the Dying for [For Want of a Memory](https://ffxiv.consolegameswiki.com/wiki/For_Want_of_a_Memory)
  * **5.45 - Memories** - Haunting, Vexatious Memory of the Dying for [The Resistance Remembers](https://ffxiv.consolegameswiki.com/wiki/The_Resistance_Remembers)
  * **7.25 - Demiatma** - For [Arcane Artistry](https://ffxiv.consolegameswiki.com/wiki/Arcane_Artistry)
* **NumberToFarm** - The number of each target you wish to farm.  Typical amounts, though you can farm more if you like.  It's up to you to make sure you're in the right step of the sequence.
  * **2.2 - Atma** - 1
  * **5.35 - Memories** - 20
  * **5.45 - Memories** - 18
  * **7.25 - Demiatma** - 6

## Run the scripts!
<img align=right width="552" height="124" alt="image" src="https://github.com/user-attachments/assets/dcf0d0e8-fe50-4e1d-8579-da54dd8e5306" /> To run your script of choice, go to the MacrosLibrary in SND, select your script, and click the "start" button (looks like a "play" icon).  When you've done so, you'll see a green "playing" button on the right side.  You can click that to see all the Macros currently playing.
<img align=right width="552" height="124" alt="image" src="https://github.com/user-attachments/assets/fce61dd5-3d3c-4f4f-a8c3-190535f2fbf1" />
<img align=right width="496" height="189" alt="image" src="https://github.com/user-attachments/assets/e288dc7d-3ec7-4700-9c6f-0f1cfa5f0f5c" />

## Stop the scripts?
**Relic Fodder** will automatically end on its own when you reach the desired number of items.  However should you want to stop it prematurely, or stop any SND running, then click the "Stop" icon either in the main SND window, or in the SND "Macro Status" window.  Remember that Relic Fodder and Multi Zone Farming both spawn Fate Farming, so you'll need to stop both scripts to completely stop.  The Macro Status window is useful for that.

