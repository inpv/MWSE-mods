Improved Vanilla Leveling
Author: Merzasphor
Version: 1.7

 Contents:
 
 -> Description
 -> Requirements
 -> Installation
 -> Using this Mod
 -> Removal
 -> Known Issues
 -> Changelog
 -> Incompatibilities & Save Game Warnings
 -> Credits
 -> License
 
-----------------------------------------------------------------------------------------------------
 Description:

 This mod attempts to preserve vanilla leveling mechanics while eliminating the need to micromanage
 skill and attribute increases in order to achieve optimal character progression. In other words, it
 allows one to just play without having to count skill increases or plan levels ahead of time, while
 still enjoying progress faithful to the original vanilla system.

 Leveling up happens as in vanilla, but with three significant changes:

 1. Excess progress is not wasted. Any excess progress toward attribute multipliers at level up is
    not lost but carried forward to the next level. This includes progress in excess of what's 
    needed to receive a 5x multiplier.
 
 2. Non-max multipliers are not wasted. Choosing an attribute at level up that doesn't have a 5x 
    multiplier (other than Luck, by default) allows for progression of the attribute via skill 
    increases up to what it would have been if the multiplier had been 5x. If that attribute has 
    already received sufficient increases at level up to reach 100 via additional skill increases, 
    that additional potential is applied to other attributes instead.

 3. Health is gained retroactively. Health is calculated as if the maximum possible endurance 
    increase was applied as early as possible, up to the current endurance value. The eliminates
    the penalty for not getting 5x endurance increases each level as early as possible. This is 
    optional, see below.

 Some implications of the the above:

 * Luck will never increase unless it's selected at level up (or unless governing attributes have
   been changed, see below). It's the player's decision whether to increase Luck or not.
 
 * Characters with lower starting endurance and strength will still have a smaller total maximum 
   health. This means there's still a small tradeoff between different races and classes, as in 
   vanilla.

 Optional Retroactive Health Calculation:
 The retroactive health calculation can be disabled via the mod config menu, to allow the use of
 another that provides a different health calculation. Set to "Off" in the MCM and follow the
 instructions of whatever mod you'd like to use in its place. To go back to the included 
 retroactive health calculation, simply change the setting and reload the character; health will be
 recalculated when the character is loaded.

 Enhanced Level Up Progress Tooltip:
 This mod adds the option to display an enhanced tooltip similar to the MCP tooltip (if the MCP
 tooltip is enabled, the new tooltip replaces it). To enable the enhanced tooltip, visit the Mod 
 Config Menu; it is disabled by default. This new tooltip adds the following information for each
 attribute:
 Attribute (base/potential) level_ups
 base - the current base value of the attribute
 potential - how high the attribute can be raised via skill increases without gaining another 
 character level
 level_ups - the number of related skill increases; this could be negative if an attribute has
 been increased without sufficient skill increases at character level up (based on 10 / 
 iLevelUp10Mult), or it could be a fraction (rounded to nearest 0.1), if iLevelUp10Mult has been
 changed such that 10 / iLevelUp10Mult is not an integer.

 Example:
 Strength (41/45) -2.0
 This character added 1 to strength at level up without any strength related skill increases. He
 now has to "pay" for that strength increase with 2 strength skill increases, to bring him to 0.
 After that, he can increase strength up to 4 more times (up to 45), with 8 additional strength 
 skill increases (maintaining the vanilla 5/10 ratio).

 Playing with a new character using vanilla settings is recommended, but read on for other options.

 Existing Characters:
 The recommended way to play this mod is with a new character, but it can be added to an existing
 game if desired. However, any lost progress or non-max multipliers prior to adding the mod cannot 
 be recovered or otherwise mitigated.

 GMSTs and Balance Mods:
 This mod was designed with vanilla settings in mind, but it should be compatible with balance mods
 that alter progression by tweaking the GMSTs that affect leveling or by changing skills' governing
 attributes.
 
 Governing attributes are checked as needed, so any changes made via an ESP will be honored by this
 mod. If Luck is added as a governing attribute to one or more skills, then it will be treated as
 the others when it comes to multipliers and skill increases. Conversely, if another attribute is
 removed from all skills, it will be treated as Luck in vanilla.

 This mod uses the following GMSTs directly and will honor changes made to them via ESPs (and 
 scripts, in most cases):
 
 * iLevelUp10Mult determines how quickly attributes rise relative to skill increases. In vanilla,
   this has a value of 5, resulting in 1 attribute increase for every 2 skill increases.
 
 * fLevelUpHealthEndMult determines the percentage of endurance to add to health each level.

 The remaining GMSTs influence how character progression happens. Changing them will have the same
 impact as in a pure vanilla game.

 Special note on iLevelupMajorMult* and iLevelupMinorMult*:
 There's a bug in the engine that causes these GMSTs to be applied incorrectly to skill increases
 received via NPC training and skill books. If these have been modified and the bug fix is not
 present this mod will be disabled, with a message on screen and in the log. The fix can be
 downloaded at: https://www.nexusmods.com/morrowind/mods/48029/
 You do not need this fix to play this mod with vanilla settings.

 Morrowind Code Patch:
 The MCP adds three options that are relevant to this mod.

 1. Interface changes -> Level-up skills tooltip
    This shows the number of skill increases linked to each of your attributes. In some cases, after
    receiving a skill increase the relevant attribute count will not increase. This is due to the 
    way skill and attribute increases are tracked in this mod, and the game's inability to properly
    handle fractions or negative numbers for these values. This is just a display issue; everything
    is handled correctly behind the scenes. Alternatively, enable the enhanced tooltip in the Mod
    Config Menu to replace this tooltip.

 2. Game mechanics -> Attribute uncap
    This allows increasing the eight main attributes past 100. This mod will detect this setting
    and should behave appropriately, but this has not been extensively tested.

 3. Game mechanics -> Skill uncap
    This allows leveling of player skills past 100. This should work with this mod, but has not been
    extensively tested.
 
 Final Thoughts:

 This mod is not for everyone. Some will want a more complete overhaul and rebalancing of the 
 leveling system, which this does not provide. Conversely, I'm sure there are some who prefer the 
 pure vanilla experience, either enjoying the process of meticulously planning skill increases and 
 progression, simply taking progression as it happens with all that implies, or landing somewhere in 
 between.

 This mod is the spiritual successor to the "Automatic Leveling" mod I posted on the Bethesda forums
 a few years ago. I don't know if it saw much use, but building that mod was my primary motivation
 for tinkering with the MWSE source code.

-----------------------------------------------------------------------------------------------------
 Requirements:

 This is a MWSE-Lua mod, and requires MGE XE 0.10.1 or later with MWSE 2.1 or later.

-----------------------------------------------------------------------------------------------------
 Installation:

 Extract the archive into .\Data Files in your Morrowind installation directory. The mod should 
 contain the following files:
    .\Data Files\MWSE\mods\merz\improved_vanilla_leveling\main.lua
    .\Data Files\MWSE\mods\merz\improved_vanilla_leveling\config.lua
    .\Data Files\MWSE\mods\merz\improved_vanilla_leveling\mcm.lua
    
-----------------------------------------------------------------------------------------------------
 Using this Mod:

 There is no esp file to activate. Simply install the MWSE 2.1 and this mod, and load up an old or 
 new game. A new game is recommended, see < Description > above for further discussion.

-----------------------------------------------------------------------------------------------------
 Removal:

 Delete the .\Data Files\MWSE\mods\merz\improved_vanilla_leveling folder.
 
 To remove the extra character data, extract the Improved Vanilla Leveling Cleanup archive into 
 .\Data Files in your Morrowind installation directory. Contents:
    .\Data Files\MWSE\mods\merz\improved_vanilla_leveling_cleanup\main.lua
 
 Load the game to clean. When prompted to remove the data, select remove. This cannot be undone.
 Save the game.

 When finished, delete the .\Data Files\MWSE\mods\merz\improved_vanilla_leveling_cleanup folder.

-----------------------------------------------------------------------------------------------------
 Known Issues:
 
 If using a mod that changes levelupsPerAttribute without triggering a custom event (e.g. anything
 using Skills Module, Ashfall, etc.), any attribute increases that should arise from that skill 
 increase will be delayed until either you raise a vanilla skill that shares the same governing 
 attribute or your character levels up. Progress is still tracked and accounted for correctly.
 
 If those mods add a custom event to signal that their custom skill has been raised, I could
 incorporate that event here and treat it like a vanilla skill increase. Until then, this is the
 best that can be done, without doing something excessive like checking every frame.

-----------------------------------------------------------------------------------------------------
 Changelog:

 1.0 [2020-05-17]:
    * Initial release.
 
 1.1 [2020-05-17]:
    * Fix an issue where new character data was saved too early.
 
 1.2 [2020-05-17]:
    * Calculate health retroactively for existing characters.

 1.3 [2020-05-26]
    * Check GMSTs when needed instead of just at start up. This should be more compatible with other
      mods that alter them via scripts.
    * Add an enhanced Level Up Progress tooltip that shows attribute potential and skill level ups
      per attribute. It can be enabled via the Mod Config Menu.
    * Gracefully handle the case where chargen is complete, but the character does not have a 
      birthsign. This should be more compatible with mods that break chargen.

 1.4 [2020-05-26]
    * Fix an issue where the updated tooltip did not appear when mousing over the "Level" text.

 1.5 [2020-05-28]
    * Distribute excess attribute cap more evenly at level up.
    * Add an option to disable retroactive health calculation, to allow this mod to be more easily 
      used with other mods that provide alternative health implementations.
 
 1.6 [2020-05-31]
    * Change how attribute potential is tracked internally. This should be more compatible with mods
      that make changes to attributes at character creation, as well as better handling other 
      changes to attributes (e.g. quest rewards).
    * Track changes made to levelupsPerAttribute by other mods that don't trigger custom events.

 1.7 [2020-06-01]
    * Disable the enhanced tooltip until chargen is complete.

 1.8 [2022-05-31]
    * Fix an issue where health was not updated correctly when under the effect of Fortify Health.
    * Fix an issue where birthsigns that add endurance were not detected.
    * Improve tooltip.
 
-----------------------------------------------------------------------------------------------------
 Incompatibilities & Save Game Warnings

 This mod should not be used with other leveling systems. It may be compatible with mods that
 adjust progression via GMSTs, see < Description > above for further discussion.

 This mod adds a small amount of data to the save file via lua. To remove this data, see < Removal >
 above.

-----------------------------------------------------------------------------------------------------
 Credits:

 Thanks to Petethegoat for pointing out that it was possible to perform the retroactive health
 calculation for existing characters, and Merlord for some related scripting pointers.

 Special thanks to all the MWSE developers past and present, especially NullCascade, Greatness7, 
 OperatorJack, and Petethegoat.

-----------------------------------------------------------------------------------------------------
 License:

 MIT License (https://opensource.org/licenses/MIT)

 Copyright 2020-2022 Merzasphor

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and 
 associated documentation files (the "Software"), to deal in the Software without restriction, 
 including without limitation the rights to use, copy, modify, merge, publish, distribute, 
 sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is 
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or 
 substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT 
 NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
 DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
 OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.