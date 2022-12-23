--## ===============================================================================================
--## ALL REQUIRED IMPORTS
--## ===============================================================================================
-- Libs / Packages
local maj = LibStub('AceAddon-3.0'):GetAddon('MarkAsJunk');

--## ===============================================================================================
--## INTERNAL VARS & SET UP
--## ===============================================================================================
local chalk = maj:GetModule('Chalk');

--## ==========================================================================
--## DEFINING THE GLOBAL CONSTANTS TABLE TO BE USED THROUGHOUT THE ADDON
--## ==========================================================================
-- TODO **[G]** :: Can/should I attach this as part of the main addon/self as a property?
MAJ_Constants = {
   activatorKeysMap = {
      ['LeftButton'] = 'LeftButton',
      ['RightButton'] = 'RightButton',
   },
   addOnName = chalk:ace('Mark As Junk'),
   addOnNameQuoted = chalk:ace('"Mark As Junk"'),
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
      Coin = 'Interface/Buttons/UI-GroupLoot-Coin-Up',
      -- COIN ALTS: Interface/Icons/INV_Misc_Coin_17
      Stack = 'Interface/Icons/INV_Misc_Coin_02',
      -- COIN ALTS: Interface/Icons/INV_Misc_Coin_01, INV_Misc_Coin_05
      Trash = 'Interface/AddOns/mark-as-junk/trash-sm',
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
      bagginsLoaded = chalk:warn('(WARNING): Auto sorting is disabled. Baggins is loaded and provides its own auto sort functionality.'),
      peddlerLoaded = chalk:warn('(WARNING): "Peddler" addon is also loaded. There may be conflicting behavior.'),
   },
};
