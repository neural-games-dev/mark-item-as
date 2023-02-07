--## ===============================================================================================
--## ALL REQUIRED IMPORTS
--## ===============================================================================================
-- Libs / Packages
local mia = LibStub('AceAddon-3.0'):GetAddon('MarkItemAs');

--## ===============================================================================================
--## INTERNAL VARS & SET UP
--## ===============================================================================================
local chalk = mia:GetModule('Chalk');

--## ==========================================================================
--## DEFINING THE GLOBAL CONSTANTS TABLE TO BE USED THROUGHOUT THE ADDON
--## ==========================================================================
-- TODO **[G]** :: Can/should I attach this as part of the main addon/self as a property?
MIA_Constants = {
   activatorKeysMap = {
      ['LeftButton'] = 'LeftButton',
      ['RightButton'] = 'RightButton',
   },
   addOnName = chalk:ace('Mark Item As'),
   addOnNameQuoted = chalk:ace('"Mark Item As"'),
   buybackLimit = 12,
   colorReset = { r = 0, g = 0, b = 0, a = 0 },
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
      -- COIN ALTS: Interface/Icons/INV_Misc_Coin_17, Ability_dragonriding_glyph01
      Stack = 'Interface/Icons/INV_Misc_Coin_02',
      -- COIN ALTS: Interface/Icons/INV_Misc_Coin_01, INV_Misc_Coin_05
      Trash = 'Interface/AddOns/mark-item-as/trash-sm',
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
   overlayStatus = {
      HIDDEN = 'overlayHidden',
      MISSING = 'overlayMissing',
      SHOWING = 'overlayShowing',
      UPDATE = 'updateOverlay',
   },
   slashCommand = '|cFFbada55/mia|r',
   slashCommandQuoted = '|cFFbada55"/mia"|r',
   warnings = {
      bagginsLoaded = chalk:warn('(WARNING): Auto sorting is disabled. Baggins is loaded and provides its own auto sort functionality.'),
      bagginsLoadedMultiline = chalk:warn('(WARNING): Auto sorting is disabled.\nBaggins is loaded and provides its own auto sort functionality.'),
      itemLockConflict = chalk:warn('"ItemLock" and "MarkItemAs" have the same key bind combo. Please change one of them or you can disable the "ItemLock" key binds. Ignoring marking.'),
      itemLockDoubledUp = chalk:warn('The item has already been marked as junk. Locking it on top causes issues. Reloads help but it is better to not double up.'),
      peddlerLoaded = chalk:warn('(WARNING): "Peddler" addon is also loaded. There may be conflicting behavior.'),
   },
};
