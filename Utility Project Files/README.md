# Sonic 1 Utility Project Files
This folder contains project files for some of the most commonly used ROM hacking utilities. Here is an overview:

## `SonLVL INI Files`
Project files for the [SonLVL level editor](https://info.sonicretro.org/SonLVL), which is the most popular choice for level editing.

* The file `SonLVL.rev01.ini` serves as the main and default project file for REV01/REVXB
* The file `SonLVL.rev00.ini` is for the older REV00
* The file `SonLVL.log` records all recent events, including errors, and is useful for troubleshooting project definition mistakes
* All other files are for object definitions, either zone-specific or generic

## `SonPLN.ini`
Project file for the [SonPLN](https://info.sonicretro.org/SonPLN) plane mappings editor. Some entries have two versions to account for differences between REV00 and REV01.

## `sonic1.flex.json`
Project file for the [Flex 2](https://info.sonicretro.org/Flex_2) sprites editor. Note that due to a bug, you will need to set the game format to "Sonic 2" in order to properly load Sonic's character sprites.

Also see [ClownMapEd](https://info.sonicretro.org/ClownMapEd) as an alternative (does not require project files).

## `S1SSEdit.ini`
Project file for the [S1SSEdit](https://info.sonicretro.org/S1SSEdit) special stage editor.

## `Legacy Utility Project Files.zip`
Archive that contains project files for [PlaneEd](https://info.sonicretro.org/PlaneEd) and both major versions of [SonED2](https://info.sonicretro.org/SonED2). These are only provided for historical purposes, as the utilities themselves are considered superseded by modern alternatives, and they may require additional adjustments to match newer naming conventions.
