--## ==========================================================================
--## ALL REQUIRED IMPORTS
--## ==========================================================================
-- Libs / Packages
local MarkAsJunk = LibStub('AceAddon-3.0'):GetAddon('MarkAsJunk');

--## ===============================================================================================
--## INTERNAL VARS & SET UP
--## ===============================================================================================
local Config = MarkAsJunk:NewModule('Config');
local u = MarkAsJunk:GetModule('Utils');

--## ==========================================================================
--## DEFINING THE MAIN OPTIONS FRAME
--## ==========================================================================
function Config:GetBlizzOptionsFrame()
   local p = MarkAsJunk.db.profile;

   return {
      desc = 'Configure the ' .. u:ace('MarkAsJunk') .. ' options for your junk items.',
      handler = self,
      name = 'Mark As Junk',
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
                     return u:getDbValue('userSelectedModKey');
                  end,
                  name = 'Select your modifier key...',
                  order = 102,
                  set = function(info, value)
                     u:setDbValue('userSelectedModKey', MAJ_Constants.modKeysMap[value])
                  end,
                  type = 'select',
                  values = MAJ_Constants.modKeysMap,
               },
               activatorKey = {
                  desc = 'This is the main mouse key to press, along with your modifier, to mark your items.',
                  get = function()
                     return p.userSelectedActivatorKey;
                  end,
                  name = 'Select your activator key...',
                  order = 103,
                  set = function(info, value)
                     p.userSelectedActivatorKey = MAJ_Constants.activatorKeysMap[value];
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
                     return u:getDbValue('enableOverlay');
                  end,
                  name = 'Enable overlay?',
                  order = 105,
                  set = function(info, value)
                     u:setDbValue('enableOverlay', value);
                  end,
                  type = 'toggle',
               },
               enableBorder = {
                  desc = '',
                  get = function()
                     return u:getDbValue('enableBorder');
                  end,
                  name = 'Enable border?',
                  order = 106,
                  set = function(info, value)
                     u:setDbValue('enableBorder', value);
                  end,
                  type = 'toggle',
               },
               overlayColorPicker = {
                  desc = 'This overlay will be added on top of the items you mark to better visualize your junk.',
                  disabled = not u:getDbValue('enableOverlay'), -- TODO :: Make this dynamic so that it updates when I toggle the enable buttons
                  hasAlpha = true,
                  get = function()
                     local r, g, b, a = p.overlayColor.r,
                     p.overlayColor.g,
                     p.overlayColor.b,
                     p.overlayColor.a;

                     return r, g, b, a;
                  end,
                  name = 'Overlay Color',
                  order = 107,
                  set = function(info, r, g, b, a)
                     p.overlayColor = { r = r, g = g, b = b, a = a };
                  end,
                  type = 'color',
               },
               borderColorPicker = {
                  desc = 'This border will be added around the items you mark to better visualize your junk.',
                  disabled = not u:getDbValue('enableBorder'), -- TODO :: Make this dynamic so that it updates when I toggle the enable buttons
                  hasAlpha = true,
                  get = function()
                     local r, g, b, a = p.borderColor.r,
                     p.borderColor.g,
                     p.borderColor.b,
                     p.borderColor.a;

                     return r, g, b, a;
                  end,
                  name = 'Border Color',
                  order = 108,
                  set = function(info, r, g, b, a)
                     p.borderColor = { r = r, g = g, b = b, a = a };
                  end,
                  type = 'color',
               },
               borderThicknessSlider = {
                  desc = 'Select the size of the border that will wrap around your marked item.',
                  disabled = not u:getDbValue('enableBorder'), -- TODO :: Make this dynamic so that it updates when I toggle the enable buttons
                  get = function()
                     return p.borderThickness;
                  end,
                  isPercent = false,
                  max = 2,
                  min = 0,
                  name = 'Border Thickness',
                  order = 109,
                  set = function(info, value)
                     p.borderThickness = value;
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
                  desc = 'Select the MAJ icon that you want to appear on the item.',
                  get = function()
                     return u:getDbValue('markerIconSelected');
                  end,
                  name = 'Select your icon...',
                  order = 111,
                  set = function(info, value)
                     u:setDbValue('markerIconSelected', value);
                  end,
                  type = 'select',
                  values = MAJ_Constants.iconListMap,
               },
               markerIconLocation = {
                  desc = 'Select the position on the item where you want the MAJ icon to appear.',
                  get = function()
                     return p.markerIconLocationSelected;
                  end,
                  name = 'Select your icon location...',
                  order = 112,
                  set = function(info, value)
                     p.markerIconLocationSelected = MAJ_Constants.iconLocationsMap[value];
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
                     return u:getDbValue('autoSortMarking');
                  end,
                  name = 'Auto sort bags after Marking?',
                  order = 301,
                  set = function(info, value)
                     u:setDbValue('autoSortMarking', value);
                  end,
                  type = 'toggle',
                  width = 'full',
               },
               sortAfterSelling = {
                  desc = 'When you sell your items at a merchant, this will sort your bags (i.e. "click" the broom icon) automatically.',
                  get = function()
                     return u:getDbValue('autoSortSelling');
                  end,
                  name = 'Auto sort bags after Selling?',
                  order = 302,
                  set = function(info, value)
                     u:setDbValue('autoSortSelling', value);
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
                     return u:getDbValue('showSaleSummary');
                  end,
                  name = 'Show summary after selling?',
                  order = 401,
                  set = function(info, value)
                     u:setDbValue('showSaleSummary', value);
                  end,
                  type = 'toggle',
                  width = 'full',
               },
               showWarnings = {
                  desc = 'This will hide/show the warnings in chat when another potentially conflicting addon is detected.',
                  get = function()
                     return u:getDbValue('showWarnings');
                  end,
                  name = 'Show addon warnings?',
                  order = 402,
                  set = function(info, value)
                     u:setDbValue('showWarnings', value);
                  end,
                  type = 'toggle',
                  width = 'full',
               },
               startupGreeting = {
                  desc = 'This will hide/show the initial greeting in chat when the game starts or reloads.',
                  get = function()
                     return u:getDbValue('showGreeting');
                  end,
                  name = 'Show startup greeting in chat?',
                  order = 403,
                  set = function(info, value)
                     u:setDbValue('showGreeting', value);
                  end,
                  type = 'toggle',
                  width = 'full',
               },
               slashCommandOutput = {
                  desc = 'This will hide/show the chat output after triggering a ' .. u:badass('MAJ') .. ' command.',
                  get = function()
                     return u:getDbValue('showCommandOutput');
                  end,
                  name = 'Show MAJ command output?',
                  order = 404,
                  set = function(info, value)
                     u:setDbValue('showCommandOutput', value);
                  end,
                  type = 'toggle',
                  width = 'full',
               },
               debugLogging = {
                  desc = 'This will enable/disable debug logging for this add-on. It is really only useful for other add-on devs.',
                  get = function()
                     return u:getDbValue('debugLogging');
                  end,
                  name = 'Show MAJ debug logging?',
                  order = 405,
                  set = function(info, value)
                     u:setDbValue('debugLogging', value);
                  end,
                  type = 'toggle',
                  width = 'full',
               },
            },
         },
      },
   };
end

-- `addon` is a passed in reference of MarkAsJunk's `self`
function Config:Init(addon)
   LibStub('AceConfig-3.0'):RegisterOptionsTable('MarkAsJunk', self:GetBlizzOptionsFrame());
   self.optionsFrame = LibStub('AceConfigDialog-3.0'):AddToBlizOptions('MarkAsJunk', 'Mark As Junk');
end
