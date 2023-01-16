--## ==========================================================================
--## ALL REQUIRED IMPORTS
--## ==========================================================================
-- Libs / Packages
local MarkItemAs = LibStub('AceAddon-3.0'):GetAddon('MarkItemAs');

--## ===============================================================================================
--## INTERNAL VARS & SET UP
--## ===============================================================================================
local Config = MarkItemAs:NewModule('Config');

--## ==========================================================================
--## DEFINING THE MAIN OPTIONS FRAME
--## ==========================================================================
-- `addon` is a passed in reference of MarkItemAs's `self`
function Config:Init(addon)
   LibStub('AceConfig-3.0'):RegisterOptionsTable('MarkItemAs', self:GetBlizzOptionsFrame(addon));
   self.optionsFrame = LibStub('AceConfigDialog-3.0'):AddToBlizOptions('MarkItemAs', 'Mark Item As');
end

-- `mia` that's passed in is a reference to MarkItemAs's `self`
function Config:GetBlizzOptionsFrame(mia)
   local db = mia.db.profile;

   return {
      desc = 'Configure the ' .. mia.chalk:ace('MarkItemAs') .. ' options for your junk items.',
      --handler = self, -- keeping this for reference
      name = 'Mark Item As (' .. tostring(mia.version) .. ')',
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
                     return mia.utils:GetDbValue('userSelectedModKey');
                  end,
                  name = 'Select your modifier key...',
                  order = 102,
                  set = function(info, value)
                     mia.utils:SetDbValue('userSelectedModKey', MIA_Constants.modKeysMap[value])
                  end,
                  type = 'select',
                  values = MIA_Constants.modKeysMap,
               },
               activatorKey = {
                  desc = 'This is the main mouse key to press, along with your modifier, to mark your items.',
                  get = function()
                     return db.userSelectedActivatorKey;
                  end,
                  name = 'Select your activator key...',
                  order = 103,
                  set = function(info, value)
                     db.userSelectedActivatorKey = MIA_Constants.activatorKeysMap[value];
                  end,
                  type = 'select',
                  values = MIA_Constants.activatorKeysMap,
               },
               itemMaskIconHeader = {
                  name = 'Overlay & Border',
                  order = 104,
                  type = 'header',
                  width = 'full',
               },
               -- NOTE :: `enableOverlay` and `enableBorder` will be added in another phase
               --enableOverlay = {
               --   desc = '',
               --   get = function()
               --      return mia.utils:GetDbValue('enableOverlay');
               --   end,
               --   name = 'Enable overlay?',
               --   order = 105,
               --   set = function(info, value)
               --      mia.utils:SetDbValue('enableOverlay', value);
               --   end,
               --   type = 'toggle',
               --},
               --enableBorder = {
               --   desc = '',
               --   get = function()
               --      return mia.utils:GetDbValue('enableBorder');
               --   end,
               --   name = 'Enable border?',
               --   order = 106,
               --   set = function(info, value)
               --      mia.utils:SetDbValue('enableBorder', value);
               --   end,
               --   type = 'toggle',
               --},
               overlayColorPicker = {
                  desc = 'This overlay will be added on top of the items you mark to better visualize your junk.',
                  --disabled = not mia.utils:GetDbValue('enableOverlay'), -- TODO :: Make this dynamic so that it updates when I toggle the enable buttons
                  hasAlpha = true,
                  get = function()
                     local color = mia.utils:GetDbValue('overlayColor');
                     return color.r, color.g, color.b, color.a;
                  end,
                  name = 'Overlay Color',
                  order = 107,
                  set = function(info, r, g, b, a)
                     mia.utils:SetDbValue('overlayColor', { r = r, g = g, b = b, a = a });
                     mia.utils:UpdateBagMarkings();
                  end,
                  type = 'color',
               },
               borderColorPicker = {
                  desc = 'This border will be added around the items you mark to better visualize your junk.',
                  --disabled = not mia.utils:GetDbValue('enableBorder'), -- TODO :: Make this dynamic so that it updates when I toggle the enable buttons
                  hasAlpha = true,
                  get = function()
                     local color = mia.utils:GetDbValue('borderColor');
                     return color.r, color.g, color.b, color.a;
                  end,
                  name = 'Border Color',
                  order = 108,
                  set = function(info, r, g, b, a)
                     mia.utils:SetDbValue('borderColor', { r = r, g = g, b = b, a = a });
                     mia.utils:UpdateBagMarkings();
                  end,
                  type = 'color',
               },
               borderThicknessSlider = {
                  desc = 'Select the size of the border that will wrap around your marked item.',
                  --disabled = not mia.utils:GetDbValue('enableBorder'), -- TODO :: Make this dynamic so that it updates when I toggle the enable buttons
                  get = function()
                     return mia.utils:GetDbValue('borderThickness');
                  end,
                  isPercent = false,
                  max = 3,
                  min = 0,
                  name = 'Border Thickness',
                  order = 109,
                  set = function(info, value)
                     mia.utils:SetDbValue('borderThickness', value);
                     mia.utils:UpdateBagMarkings();
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
                     return mia.utils:GetDbValue('markerIconSelected');
                  end,
                  name = 'Select your icon...',
                  order = 111,
                  set = function(info, value)
                     local newValue = MIA_Constants.iconListMap[value];
                     local oldValue = db.markerIconSelected;

                     mia.logger:Debug('SELECTED ICON CHANGED. Updating bags...\n' ..
                        'OLD VALUE = ' .. oldValue .. '\n' ..
                        'NEW VALUE = ' .. newValue .. '\n'
                     );

                     mia.utils:SetDbValue('markerIconSelected', value);
                     mia.utils:UpdateBagMarkings();
                  end,
                  type = 'select',
                  values = MIA_Constants.iconListMap,
               },
               markerIconLocation = {
                  desc = 'Select the position on the item where you want the JUNK icon to appear.',
                  get = function()
                     return db.markerIconLocationSelected;
                  end,
                  name = 'Select your icon location...',
                  order = 112,
                  set = function(info, value)
                     local newValue = MIA_Constants.iconLocationsMap[value];
                     local oldValue = db.markerIconLocationSelected;

                     mia.logger:Debug('SELECTED ICON LOCATION CHANGED. Updating bags...\n' ..
                        'OLD VALUE = ' .. oldValue .. '\n' ..
                        'NEW VALUE = ' .. newValue .. '\n'
                     );

                     mia.utils:SetDbValue('markerIconLocationSelected', newValue);
                     mia.utils:UpdateBagMarkings();
                  end,
                  type = 'select',
                  values = MIA_Constants.iconLocationsMap,
               },
               tooltipHeader = {
                  name = 'Tooltip',
                  order = 113,
                  type = 'header',
                  width = 'full',
               },
               showTooltipText = {
                  desc = "This will add a text note to a marked item's tooltip.",
                  get = function()
                     return mia.utils:GetDbValue('showTooltipText');
                  end,
                  name = 'Show tooltip text?',
                  order = 114,
                  set = function(info, value)
                     mia.utils:SetDbValue('showTooltipText', value);
                  end,
                  type = 'toggle',
                  width = 'full',
               },
            },
         },
         sellingOptions = {
            desc = '',
            name = 'Selling',
            order = 200,
            type = 'group',
            args = {
               saleSummary = {
                  desc = 'This will hide/show the gold & items summary in chat during & after selling to a merchant.',
                  get = function()
                     return mia.utils:GetDbValue('showSaleSummary');
                  end,
                  name = 'Show selling info & summary?',
                  order = 201,
                  set = function(info, value)
                     mia.utils:SetDbValue('showSaleSummary', value);
                  end,
                  type = 'toggle',
                  width = 'full',
               },
               limitSales = {
                  desc = 'This will prevent you from selling more than 12 items at a time, so you can do a full buyback if wanted.',
                  get = function()
                     return mia.utils:GetDbValue('limitSaleItems');
                  end,
                  name = 'Limit number of items sold?',
                  order = 202,
                  set = function(info, value)
                     mia.utils:SetDbValue('limitSaleItems', value);
                  end,
                  type = 'toggle',
                  width = 'full',
               },
               unmarkAfterSelling = {
                  desc = 'After visiting a merchant and selling your items, you can set them as "un-marked".\n\nIf you leave them marked after selling, the overlay will be there when you buy back.',
                  get = function()
                     return mia.utils:GetDbValue('unmarkAfterSelling');
                  end,
                  name = 'Un-mark after selling?',
                  order = 203,
                  set = function(info, value)
                     mia.utils:SetDbValue('unmarkAfterSelling', value);
                  end,
                  type = 'toggle',
                  width = 'full',
               },
               autoSell = {
                  desc = "You can disable auto-selling marked items when visiting a merchant. But I'm not sure why you'd want to. ;-)",
                  get = function()
                     return mia.utils:GetDbValue('autoSellMerchant');
                  end,
                  name = 'Auto sell at merchant?',
                  order = 204,
                  set = function(info, value)
                     mia.utils:SetDbValue('autoSellMerchant', value);
                  end,
                  type = 'toggle',
                  width = 'full',
               },
            },
         },
         sortingOptions = {
            desc = '',
            name = 'Sorting',
            order = 300,
            type = 'group',
            args = {
               sortAfterMarking = {
                  desc = 'After an item gets MARKED, this will sort your bags (i.e. "click" the broom icon) automatically.',
                  get = function()
                     return mia.utils:GetDbValue('autoSortMarking');
                  end,
                  name = 'Auto sort bags after Marking?',
                  order = 301,
                  set = function(info, value)
                     mia.utils:SetDbValue('autoSortMarking', value);
                  end,
                  type = 'toggle',
                  width = 'full',
               },
               sortAfterUnmarking = {
                  desc = 'After an item gets UN-MARKED, this will sort your bags (i.e. "click" the broom icon) automatically.',
                  get = function()
                     return mia.utils:GetDbValue('autoSortUnmarking');
                  end,
                  name = 'Auto sort bags after Un-marking?',
                  order = 302,
                  set = function(info, value)
                     mia.utils:SetDbValue('autoSortUnmarking', value);
                  end,
                  type = 'toggle',
                  width = 'full',
               },
               sortAfterSelling = {
                  desc = 'When you sell your items at a merchant, this will sort your bags (i.e. "click" the broom icon) automatically.',
                  get = function()
                     return mia.utils:GetDbValue('autoSortSelling');
                  end,
                  name = 'Auto sort bags after Selling?',
                  order = 303,
                  set = function(info, value)
                     mia.utils:SetDbValue('autoSortSelling', value);
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
               showWarnings = {
                  desc = 'This will hide/show the warnings in chat when another potentially conflicting addon is detected.',
                  get = function()
                     return mia.utils:GetDbValue('showWarnings');
                  end,
                  name = 'Show addon warnings?',
                  order = 401,
                  set = function(info, value)
                     mia.utils:SetDbValue('showWarnings', value);
                  end,
                  type = 'toggle',
                  width = 'full',
               },
               startupGreeting = {
                  desc = 'This will hide/show the initial greeting in chat when the game starts or reloads.',
                  get = function()
                     return mia.utils:GetDbValue('showGreeting');
                  end,
                  name = 'Show startup greeting in chat?',
                  order = 402,
                  set = function(info, value)
                     mia.utils:SetDbValue('showGreeting', value);
                  end,
                  type = 'toggle',
                  width = 'full',
               },
               slashCommandOutput = {
                  desc = 'This will hide/show the chat output after triggering certain ' .. mia.chalk:badass('MIA') .. ' commands or actions.\n\nThink of this like INFO level logging.',
                  get = function()
                     return mia.utils:GetDbValue('showCommandOutput');
                  end,
                  name = 'Show MIA command output?',
                  order = 403,
                  set = function(info, value)
                     mia.utils:SetDbValue('showCommandOutput', value);
                  end,
                  type = 'toggle',
                  width = 'full',
               },
               enableDebugging = {
                  desc = 'This will enable/disable debugging for this add-on. It is really only useful for other add-on devs.\n\nBE WARNED! It can get SPAMMY!',
                  get = function()
                     return mia.utils:GetDbValue('debugEnabled');
                  end,
                  name = 'Enable MIA debugging?',
                  order = 404,
                  set = function(info, value)
                     mia.utils:SetDbValue('debugEnabled', value);
                  end,
                  type = 'toggle',
                  width = 'full',
               },
            },
         },
      },
   };
end
