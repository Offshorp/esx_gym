### Forked from [P4NDAzzGaming/esx_gym](https://github.com/P4NDAzzGaming/esx_gym)
### Edited by [Offshorp](https://github.com/Offshorp/)

# Requirements
* [ES_EXTENDED](https://github.com/esx-framework/es_extended)
* [ESX_MENU_DEFAULT](https://github.com/esx-framework/esx_menu_default)
* [ESX_MENU_DIALOG](https://github.com/esx-framework/esx_menu_dialog)
* [ESX_MENU_LIST](https://github.com/esx-framework/esx_menu_list)
* [ESX_STATUS](https://github.com/esx-framework/esx_status)
* [ESX_BASICNEEDS](https://github.com/esx-framework/esx_basicneeds)
* **NEW** [ESX_AMBULANCEJOB](https://github.com/esx-framework/esx_ambulancejob)

# Features
* Plenty of exercises such as Yoga, Situps, Pushups, Weights, Chins/pull-ups, Bicycle exercise (rental).
* In order to exercise you need to purchase the gym membership in the gym menu.
* After you've done an exercise there'll be a cooldown for 60 seconds which means you can't do any exercise for 60 seconds.
* A gym shop where you can purchase: water, sportlunch, protein shake, Powerade & bandage.
* Business hours, pretty much it just prints that the gym is open 24hrs/ day.
* Before any exercise the script will ALWAYS doublecheck if the player actually has a membership or not, if the player needs to rest or not and if the player already is training or not etc.
* The script doesn't really take too much CPU usage, I've never received a script warning from ESX_GYM.
* The bandage is giving the player their max health divided with 3 + their current health.

# Installation
1. Extract **esx_gym.zip** into your resource folder.
2. Start the script in your `server.cfg` or wherever you start scripts. Correct row: **ensure esx_gym**
3. Import the `esx_gym.sql` into your database (table: items) or do it manually. **NEW** Find there in `localization` directory
4. Start/Restart your server.
5. Done, have a good time at the gym and get healthy!
