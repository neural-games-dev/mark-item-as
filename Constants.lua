-- TODO :: Convert this into a module
--## ==========================================================================
--## DEFINING THE GLOBAL CONSTANTS TABLE TO BE USED THROUGHOUT THE ADDON
--## ==========================================================================
MAJ_Constants = {
   activatorKeysMap = {
      ['LeftButton'] = 'LeftButton',
      ['RightButton'] = 'RightButton',
   },
   addOnName = '|cFF33ff99Mark As Junk|r',
   addOnNameQuoted = '|cFF33ff99"Mark As Junk"|r',
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
      Coin = 'Interface/Icons/INV_Misc_Coin_01',
      Stack = '',
      Trash = '',
   },
   modKeysMap = {
      ['Alt'] = 'Alt',
      ['Ctrl'] = 'Ctrl',
      ['Shift'] = 'Shift',
      ['Alt-Ctrl'] = 'Alt-Ctrl',
      ['Alt-Shift'] = 'Alt-Shift',
      ['Ctrl-Shift'] = 'Ctrl-Shift',
   },
   slashCommand = '|cFFbada55/maj|r',
   slashCommandQuoted = '|cFFbada55"/maj"|r',
   warnings = {
      bagginsLoaded = '|cFF33ff99Mark As Junk|r (|cFFfa8200WARNING|r): Auto sorting is disabled. Baggins is loaded and provides its own auto sort functionality.',
      peddlerLoaded = '(|cFFfa8200WARNING|r): "Peddler" addon is also loaded. There may be conflicts in behavior.',
   },
};
