--## ===============================================================================================
--## ALL REQUIRED IMPORTS
--## ===============================================================================================
-- Libs / Packages
local maj = LibStub('AceAddon-3.0'):GetAddon('MarkAsJunk');

--## ===============================================================================================
--## INTERNAL VARS & SET UP
--## ===============================================================================================
local u = maj:GetModule('Utils');

--## ==========================================================================
--## DEFINING THE GLOBAL CONSTANTS TABLE TO BE USED THROUGHOUT THE ADDON
--## ==========================================================================
MAJ_Constants = {
   activatorKeysMap = {
      ['LeftButton'] = 'LeftButton',
      ['RightButton'] = 'RightButton',
   },
   addOnName = u:ace('Mark As Junk'),
   addOnNameQuoted = u:ace('"Mark As Junk"'),
   iconListMap = {
      Coin = 'Coin',
      Stack = 'Stack',
      Trash = 'Trash',
   },
   iconLocationsMap = {
      TOPLEFT = 'TOPLEFT',
      TOP = 'TOP',
      TOPRIGHT = 'TOPRIGHT',
      LEFT = 'LEFT',
      CENTER = 'CENTER',
      RIGHT = 'RIGHT',
      BOTTOMLEFT = 'BOTTOMLEFT',
      BOTTOM = 'BOTTOM',
      BOTTOMRIGHT = 'BOTTOMRIGHT',
   },
   iconPathMap = {
      Coin = 'Interface/Icons/INV_Misc_Coin_01', -- or maybe use INV_Misc_Coin_17 or INV_Misc_Coin_05
      Stack = 'Interface/Icons/INV_Misc_Coin_02',
      Trash = '',
   },
   modFunctionsMap = {
      ['Alt'] = IsAltKeyDown,
      ['Ctrl'] = IsControlKeyDown,
      ['Shift'] = IsShiftKeyDown,
   },
   modKeysMap = {
      ['Alt'] = 'Alt',
      ['Ctrl'] = 'Ctrl',
      ['Shift'] = 'Shift',
   },
   numContainers = 4,
   slashCommand = '|cFFbada55/maj|r',
   slashCommandQuoted = '|cFFbada55"/maj"|r',
   warnings = {
      bagginsLoaded = u:warn('(WARNING): Auto sorting is disabled. Baggins is loaded and provides its own auto sort functionality.'),
      peddlerLoaded = u:warn('(WARNING): "Peddler" addon is also loaded. There may be conflicts in behavior.'),
   },
};
