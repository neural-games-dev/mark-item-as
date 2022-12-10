--## ==========================================================================
--## DEFAULT OPTIONS TABLE
--## ==========================================================================
-- TODO **[G]** :: Change this name to "defaults" of some sort, after I re/move the connected methods below
-- TODO **[G]** :: Move to constants file when ready
MAJ_Utils = {
   autoSortMarking = false,
   autoSortSelling = false,
   borderColor = { r = 1, g = 1, b = 1, a = 1 },
   borderThickness = 1.25,
   isBagginsLoaded = IsAddOnLoaded('Baggins'),
   markerIconLocationSelected = 'BOTTOMLEFT',
   markerIconSelected = 'Coin',
   overlayColor = { r = 1, g = 1, b = 1, a = 1 },
   showGreeting = true,
   showSlashCommandOutput = true,
   userSelectedActivatorKey = 'RIGHT-CLICK',
   userSelectedModKey = 'ALT',
};

--## ==========================================================================
--## GLOBAL CONSTANTS TABLE TO BE USED THROUGHOUT THE ADDON
--## ==========================================================================
-- TODO **[G]** :: Convert this into a module?
MAJ_Constants = {
   activatorKeysMap = {
      ['LEFT-CLICK'] = 'LEFT-CLICK',
      ['RIGHT-CLICK'] = 'RIGHT-CLICK',
   },
   addOnName = '|cFF00ffffMark As Junk|r',
   addOnNameQuoted = '|cFF00ffff"Mark As Junk"|r',
   bagginsLoadedWarning = '|cFF00ffffMark As Junk|r (|cFFfa8200WARNING|r): Auto sorting is disabled. Baggins is loaded and provides its own auto sort functionality.',
   iconListMap = {
      Coin = 'Coin',
      Stack = 'Stack',
      Trash = 'Trash',
   },
   iconLocationsMap = {
      TOPLEFT = "TOPLEFT",
      TOP = "TOP",
      TOPRIGHT = "TOPRIGHT",
      LEFT = "LEFT",
      CENTER = "CENTER",
      RIGHT = "RIGHT",
      BOTTOMLEFT = "BOTTOMLEFT",
      BOTTOM = "BOTTOM",
      BOTTOMRIGHT = "BOTTOMRIGHT",
   },
   iconPathMap = {
      Coin = 'Interface/Icons/INV_Misc_Coin_01',
      Stack = '',
      Trash = '',
   },
   modKeysMap = {
      ['ALT'] = 'ALT',
      ['CTRL'] = 'CTRL',
      ['SHIFT'] = 'SHIFT',
      ['ALT-CTRL'] = 'ALT-CTRL',
      ['ALT-SHIFT'] = 'ALT-SHIFT',
      ['CTRL-SHIFT'] = 'CTRL-SHIFT',
   },
   slashCommand = '|cFFbada55/maj|r',
   slashCommandQuoted = '|cFFbada55"/maj"|r',
};
