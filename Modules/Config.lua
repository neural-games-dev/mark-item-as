local MarkAsJunk = LibStub('AceAddon-3.0'):GetAddon('MarkAsJunk');
local Config = MarkAsJunk:NewModule('Config');

function Config:GetBlizzOptionsFrame()
   local p = MarkAsJunk.db.profile;

   return {
      desc = 'Configure the marking & selling options for your junk items.',
      handler = self,
      name = 'Mark As Junk',
      type = 'group',
      args = {
         markingOptions = {
            desc = '',
            name = 'Marking',
            order = 10,
            type = 'group',
            args = {
               keybindHeader = {
                  name = 'Keybind',
                  order = 11,
                  type = 'header',
                  width = 'full',
               },
               modifierKey = {
                  desc = 'This is the additional key to press, along with your activator, to mark your items.',
                  get = function()
                     return p.userSelectedModKey;
                  end,
                  name = 'Select your modifier key...',
                  order = 12,
                  set = function(info, value)
                     p.userSelectedModKey = MAJ_Constants.modKeysMap[value];
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
                  order = 13,
                  set = function(info, value)
                     p.userSelectedActivatorKey = MAJ_Constants.activatorKeysMap[value];
                  end,
                  type = 'select',
                  values = MAJ_Constants.activatorKeysMap,
               },
               itemMaskIconHeader = {
                  name = 'Item Mask & Icon',
                  order = 14,
                  type = 'header',
                  width = 'full',
               },
               overlayColorPicker = {
                  desc = 'This overlay will be added on top of the items you mark to better visualize your junk.',
                  hasAlpha = true,
                  get = function()
                     local r, g, b, a = p.overlayColor.r,
                     p.overlayColor.g,
                     p.overlayColor.b,
                     p.overlayColor.a;

                     return r, g, b, a;
                  end,
                  name = 'Overlay Color',
                  order = 15,
                  set = function(info, r, g, b, a)
                     p.overlayColor = { r = r, g = g, b = b, a = a };
                  end,
                  type = 'color',
               },
               -- TODO **[G]** :: Maybe add a border color picker here? -- order: 16
               -- TODO **[G]** :: Maybe add a border thickness slider here? -- order: 17
               markerIconLocation = {
                  desc = 'Select the position on the item where you want the MAJ icon to appear.',
                  get = function()
                     return p.markerIconLocationSelected;
                  end,
                  name = 'Select the location for the icon...',
                  order = 18,
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
            order = 20,
            type = 'group',
            args = {},
         },
         sortingOptions = {
            desc = '',
            name = 'Sorting',
            order = 30,
            type = 'group',
            args = {},
         },
         miscOptions = {
            desc = '',
            name = 'Miscellaneous',
            order = 40,
            type = 'group',
            args = {
               startupGreeting = {
                  desc = 'This will hide or show the initial greeting in chat when the game starts or reloads.',
                  get = function()
                     return p.showGreeting;
                  end,
                  name = 'Show startup greeting in chat?',
                  order = 41,
                  set = function(info, value)
                     p.showGreeting = value;
                  end,
                  type = 'toggle',
                  width = 'full',
               },
               slashCommandOutput = {
                  desc = 'This will hide or show the chat output after entering in a ' .. MAJ_Constants.slashCommandQuoted .. ' command.',
                  get = function()
                     return p.showSlashCommandOutput;
                  end,
                  name = 'Show slash command output?',
                  order = 43,
                  set = function(info, value)
                     p.showSlashCommandOutput = value;
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
