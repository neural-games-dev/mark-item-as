local MarkAsJunk = LibStub('AceAddon-3.0'):GetAddon('MarkAsJunk');
local Config = MarkAsJunk:NewModule('Config');

function Config:GetBlizzOptionsFrame()
   local p = MarkAsJunk.db.profile;

   local activatorKeysMap = {
      ['LEFT-CLICK'] = 'LEFT-CLICK',
      ['RIGHT-CLICK'] = 'RIGHT-CLICK',
   };

   local modKeysMap = {
      ['ALT'] = 'ALT',
      ['CTRL'] = 'CTRL',
      ['SHIFT'] = 'SHIFT',
      ['ALT-CTRL'] = 'ALT-CTRL',
      ['ALT-SHIFT'] = 'ALT-SHIFT',
      ['CTRL-SHIFT'] = 'CTRL-SHIFT',
   };

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
               },
               modifierKey = {
                  desc = 'This is the additional key to press, along with your activator, to mark your items.',
                  get = function()
                     return p.userSelectedModKey;
                  end,
                  name = 'Select your modifier key...',
                  order = 12,
                  set = function(info, value)
                     p.userSelectedModKey = modKeysMap[value];
                  end,
                  type = 'select',
                  values = modKeysMap,
               },
               activatorKey = {
                  desc = 'This is the main mouse key to press, along with your modifier, to mark your items.',
                  get = function()
                     return p.userSelectedActivatorKey;
                  end,
                  name = 'Select your activator key...',
                  order = 13,
                  set = function(info, value)
                     p.userSelectedActivatorKey = activatorKeysMap[value];
                  end,
                  type = 'select',
                  values = activatorKeysMap,
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
            args = {},
         },
      },
   };
end

-- `addon` is a passed in reference of MarkAsJunk's `self`
function Config:Init(addon)
   LibStub('AceConfig-3.0'):RegisterOptionsTable('MarkAsJunk', self:GetBlizzOptionsFrame());
   self.optionsFrame = LibStub('AceConfigDialog-3.0'):AddToBlizOptions('MarkAsJunk', 'Mark As Junk');
end
