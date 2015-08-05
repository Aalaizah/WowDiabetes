Wow Diabetes
============

WoW Addon for diabetes research

## Installation Instructions

1. Download from [Curse](http://www.curse.com/addons/wow/wow-diabetes), or [GitHub](https://github.com/amm4108/WowDiabetes)(then move to step 2) or install it straight through the Curse Client(If done this way you're all set)

2. Move the folder into the World of Warcraft/Interface/AddOns Folder.

3. Restart the World of Warcraft Client.

For Developers
==================

The Localization folder holds all files needed for localization of the addon. To add new localizations find the correct [localization code](http://wowprogramming.com/docs/api/GetLocale) then add a file named Localization.coDE.lua where coDE is replaced
with your localization code. Then add a line to the .toc file with the file name.

The table folder includes files with the tables for food and drinks. Add new food/drinks to these files depending on which type of spell is cast. Feasts are also included in these files but require a little more work.

Feasts have two locations that they need information. The food id value that is what the game recognizes needs to go into the foodList.lua file with a value that affects the blood sugar level. It also needs to be in the feastList.lua file.
The key for the array is foodspell and drink spell cast seperated by a colon(foodSpell:drinkSpell). The value for this key is the key from the foodList.lua file. 

To check for bugs in the add-on I use a combination of two add-ons that are available through [Curse](http://www.curse.com/addons/wow) - [BugSack](http://www.curse.com/addons/wow/bugsack) which requires [!BugGrabber](http://www.curse.com/addons/wow/bug-grabber).
