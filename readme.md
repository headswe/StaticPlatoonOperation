# Static Platoon Ops
A rewrite of DSM.
## Authors
Snippers
Bear
Head
## Build script
By default, the `build.ps1` PowerShell script shipped with this repository will output mission variants for all "vanilla" terrains (Altis, Stratis, Tanoa and Livonia) into the addons folder.
You can specify your own list of terrains and your own destination folder (eg. your Arma 3 missions folder) by copying the `build-config.json.example` file, renaming it to `build-config.json` and changing parameters in this file. Output folder can also be given as a launch attribute for the script.