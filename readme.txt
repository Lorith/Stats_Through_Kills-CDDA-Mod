Originally found on japanese wiki in a broken state.  Translated with google translate, fixed so it worked, and added some features.

On creating a character, it will open a configuration menu.  First pick if you want your stat points to be chosen at random, chosen by you, or assigned equally to all stats.

If you decide you want to pick, it will then ask you for anti-oops settings -- this is to prevent you from accidentally assigning your stats, such as if you are holding 2 when it opens the menu.  It is recommended to set it to at least 2, as it has been set to never pick the same number that you picked on the next run.

Afterwards, you will get a menu showing an example of how many kills you need for the first five stat points.  From this screen, you can choose to open menus to set the initial kills per stat and the additional per stat.  Initial kills cannot go below 1, but additional can be set to 0 if desired for a flat X kills per stat increase, instead of an ever-increasing number of kills.  Once you close this menu, you cannot return back to it without save editing, so make sure you are happy with your choice before you hit done.

To add to an existing world, edit mods.json and include "StatsThroughKills" at the end, making sure the entry before it has a comma at the end.  The first time the script fires (daily) it will open the configuration menu, and then it will consider all your kills so far and determine if it needs to give you additional stats or not.