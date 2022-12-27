--## ==========================================================================
--## ALL REQUIRED IMPORTS
--## ==========================================================================
-- Libs / Packages
local MarkAsJunk = LibStub('AceAddon-3.0'):GetAddon('MarkAsJunk');

--## ===============================================================================================
--## INTERNAL VARS & SET UP
--## ===============================================================================================
local Config = MarkAsJunk:NewModule('Config');

--## ==========================================================================
--## DEFINING THE MAIN OPTIONS FRAME
--## ==========================================================================
-- `addon` is a passed in reference of MarkAsJunk's `self`
function Config:Init(addon)
   LibStub('AceConfig-3.0'):RegisterOptionsTable('MarkAsJunk', self:GetBlizzOptionsFrame(addon));
   self.optionsFrame = LibStub('AceConfigDialog-3.0'):AddToBlizOptions('MarkAsJunk', 'Mark As Junk');
end

-- `maj` that's passed in is a reference to MarkAsJunk's `self`
function Config:GetBlizzOptionsFrame(maj)
   local db = maj.db.profile;

   return {
      desc = 'Configure the ' .. maj.chalk:ace('MarkAsJunk') .. ' options for your junk items.',
      --handler = self, -- keeping this for reference
      name = 'Mark As Junk (' .. tostring(maj.version) .. ')',
      type = 'group',
      args = {
         markingOptions = {
            desc = '',
            name = 'Marking',
            order = 100,
            type = 'group',
            args = {
               keybindHeader = {
                  name = 'Keybind',
                  order = 101,
                  type = 'header',
                  width = 'full',
               },
               modifierKey = {
                  desc = 'This is the additional key to press, along with your activator, to mark your items.',
                  get = function()
                     return maj.utils:getDbValue('userSelectedModKey');
                  end,
                  name = 'Select your modifier key...',
                  order = 102,
                  set = function(info, value)
                     maj.utils:setDbValue('userSelectedModKey', MAJ_Constants.modKeysMap[value])
                  end,
                  type = 'select',
                  values = MAJ_Constants.modKeysMap,
               },
               activatorKey = {
                  desc = 'This is the main mouse key to press, along with your modifier, to mark your items.',
                  get = function()
                     return db.userSelectedActivatorKey;
                  end,
                  name = 'Select your activator key...',
                  order = 103,
                  set = function(info, value)
                     db.userSelectedActivatorKey = MAJ_Constants.activatorKeysMap[value];
                  end,
                  type = 'select',
                  values = MAJ_Constants.activatorKeysMap,
               },
               itemMaskIconHeader = {
                  name = 'Overlay & Border',
                  order = 104,
                  type = 'header',
                  width = 'full',
               },
               enableOverlay = {
                  desc = '',
                  get = function()
                     return maj.utils:getDbValue('enableOverlay');
                  end,
                  name = 'Enable overlay?',
                  order = 105,
                  set = function(info, value)
                     maj.utils:setDbValue('enableOverlay', value);
                  end,
                  type = 'toggle',
               },
               enableBorder = {
                  desc = '',
                  get = function()
                     return maj.utils:getDbValue('enableBorder');
                  end,
                  name = 'Enable border?',
                  order = 106,
                  set = function(info, value)
                     maj.utils:setDbValue('enableBorder', value);
                  end,
                  type = 'toggle',
               },
               overlayColorPicker = {
                  desc = 'This overlay will be added on top of the items you mark to better visualize your junk.',
                  disabled = not maj.utils:getDbValue('enableOverlay'), -- TODO :: Make this dynamic so that it updates when I toggle the enable buttons
                  hasAlpha = true,
                  get = function()
                     local r, g, b, a = db.overlayColor.r,
                     db.overlayColor.g,
                     db.overlayColor.b,
                     db.overlayColor.a;

                     return r, g, b, a;
                  end,
                  name = 'Overlay Color',
                  order = 107,
                  set = function(info, r, g, b, a)
                     db.overlayColor = { r = r, g = g, b = b, a = a };
                  end,
                  type = 'color',
               },
               borderColorPicker = {
                  desc = 'This border will be added around the items you mark to better visualize your junk.',
                  disabled = not maj.utils:getDbValue('enableBorder'), -- TODO :: Make this dynamic so that it updates when I toggle the enable buttons
                  hasAlpha = true,
                  get = function()
                     local r, g, b, a = db.borderColor.r,
                     db.borderColor.g,
                     db.borderColor.b,
                     db.borderColor.a;

                     return r, g, b, a;
                  end,
                  name = 'Border Color',
                  order = 108,
                  set = function(info, r, g, b, a)
                     db.borderColor = { r = r, g = g, b = b, a = a };
                  end,
                  type = 'color',
               },
               borderThicknessSlider = {
                  desc = 'Select the size of the border that will wrap around your marked item.',
                  disabled = not maj.utils:getDbValue('enableBorder'), -- TODO :: Make this dynamic so that it updates when I toggle the enable buttons
                  get = function()
                     return db.borderThickness;
                  end,
                  isPercent = false,
                  max = 2,
                  min = 0,
                  name = 'Border Thickness',
                  order = 109,
                  set = function(info, value)
                     db.borderThickness = value;
                  end,
                  step = 0.05,
                  type = 'range',
               },
               iconHeader = {
                  name = 'Icon',
                  order = 110,
                  type = 'header',
                  width = 'full',
               },
               markerIcon = {
                  desc = 'Select the JUNK icon that you want to appear on the item.',
                  get = function()
                     return maj.utils:getDbValue('markerIconSelected');
                  end,
                  name = 'Select your icon...',
                  order = 111,
                  set = function(info, value)
                     local newValue = MAJ_Constants.iconListMap[value];
                     local oldValue = db.markerIconSelected;

                     maj.logger:Debug('SELECTED ICON CHANGED. Updating bags...\n' ..
                        'OLD VALUE = ' .. oldValue .. '\n' ..
                        'NEW VALUE = ' .. newValue .. '\n'
                     );

                     maj.utils:setDbValue('markerIconSelected', value);
                     maj.utils:updateBagMarkings();
                  end,
                  type = 'select',
                  values = MAJ_Constants.iconListMap,
               },
               markerIconLocation = {
                  desc = 'Select the position on the item where you want the JUNK icon to appear.',
                  get = function()
                     return db.markerIconLocationSelected;
                  end,
                  name = 'Select your icon location...',
                  order = 112,
                  set = function(info, value)
                     local newValue = MAJ_Constants.iconLocationsMap[value];
                     local oldValue = db.markerIconLocationSelected;

                     maj.logger:Debug('SELECTED ICON LOCATION CHANGED. Updating bags...\n' ..
                        'OLD VALUE = ' .. oldValue .. '\n' ..
                        'NEW VALUE = ' .. newValue .. '\n'
                     );

                     maj.utils:setDbValue('markerIconLocationSelected', newValue);
                     maj.utils:updateBagMarkings();
                  end,
                  type = 'select',
                  values = MAJ_Constants.iconLocationsMap,
               },
            },
         },
         sellingOptions = {
            desc = '',
            name = 'Selling',
            order = 200,
            type = 'group',
            args = {},
         },
         sortingOptions = {
            desc = '',
            name = 'Sorting',
            order = 300,
            type = 'group',
            args = {
               sortAfterMarking = {
                  desc = 'After an item gets marked, this will sort your bags (i.e. "click" the broom icon) automatically.',
                  get = function()
                     return maj.utils:getDbValue('autoSortMarking');
                  end,
                  name = 'Auto sort bags after Marking?',
                  order = 301,
                  set = function(info, value)
                     maj.utils:setDbValue('autoSortMarking', value);
                  end,
                  type = 'toggle',
                  width = 'full',
               },
               sortAfterSelling = {
                  desc = 'When you sell your items at a merchant, this will sort your bags (i.e. "click" the broom icon) automatically.',
                  get = function()
                     return maj.utils:getDbValue('autoSortSelling');
                  end,
                  name = 'Auto sort bags after Selling?',
                  order = 302,
                  set = function(info, value)
                     maj.utils:setDbValue('autoSortSelling', value);
                  end,
                  type = 'toggle',
                  width = 'full',
               },
            },
         },
         chatOptions = {
            desc = '',
            name = 'Chat',
            order = 400,
            type = 'group',
            args = {
               saleSummary = {
                  desc = 'This will hide/show the gold & items summary in chat after selling to a merchant.',
                  get = function()
                     return maj.utils:getDbValue('showSaleSummary');
                  end,
                  name = 'Show summary after selling?',
                  order = 401,
                  set = function(info, value)
                     maj.utils:setDbValue('showSaleSummary', value);
                  end,
                  type = 'toggle',
                  width = 'full',
               },
               showWarnings = {
                  desc = 'This will hide/show the warnings in chat when another potentially conflicting addon is detected.',
                  get = function()
                     return maj.utils:getDbValue('showWarnings');
                  end,
                  name = 'Show addon warnings?',
                  order = 402,
                  set = function(info, value)
                     maj.utils:setDbValue('showWarnings', value);
                  end,
                  type = 'toggle',
                  width = 'full',
               },
               startupGreeting = {
                  desc = 'This will hide/show the initial greeting in chat when the game starts or reloads.',
                  get = function()
                     return maj.utils:getDbValue('showGreeting');
                  end,
                  name = 'Show startup greeting in chat?',
                  order = 403,
                  set = function(info, value)
                     maj.utils:setDbValue('showGreeting', value);
                  end,
                  type = 'toggle',
                  width = 'full',
               },
               slashCommandOutput = {
                  desc = 'This will hide/show the chat output after triggering a ' .. maj.chalk:badass('MAJ') .. ' command or action.',
                  get = function()
                     return maj.utils:getDbValue('showCommandOutput');
                  end,
                  name = 'Show MAJ command output?',
                  order = 404,
                  set = function(info, value)
                     maj.utils:setDbValue('showCommandOutput', value);
                  end,
                  type = 'toggle',
                  width = 'full',
               },
               enableDebugging = {
                  desc = 'This will enable/disable debugging for this add-on. It is really only useful for other add-on devs.',
                  get = function()
                     return maj.utils:getDbValue('debugEnabled');
                  end,
                  name = 'Enable MAJ debugging?',
                  order = 405,
                  set = function(info, value)
                     maj.utils:setDbValue('debugEnabled', value);
                  end,
                  type = 'toggle',
                  width = 'full',
               },
            },
         },
      },
   };
end
