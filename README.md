# Starscape-Datamine
Collected System Data and collection tools for Roblox Starscape

To use, inject and run both .lua files. Then run the .py file and input the directory of both generated .json files.

`SystemLinkMiner.lua` generates `system_links.json`, a collection of every connection between systems.

`SystemInfoMiner.lua` generates `system_data.json`, which contains information about each system.

After running `SystemDataParser.py`, `system_data_complete.json` will be generated, which combines the information from `system_links.json` and `system_data.json` into a more readable format.

This `README.md` was last updated July 10, 2025, and this repository had information collected from the then current Starscape Public Testing Server build. If you would like to update the information, please create a Pull Request.

In order to use these scripts, you will need some form of injector/executor into Roblox memory while the game is running. Please do research to ensure the one you use does not include a virus.
I do not provide nor are affiliated with any "Roblox Cheat" creator.
