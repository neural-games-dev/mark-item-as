local MarkAsJunk = LibStub('AceAddon-3.0'):GetAddon('MarkAsJunk');
local MAJConfig = MarkAsJunk:NewModule('MAJConfig');

function MAJConfig:GetBlizzOptionsFrame()
   local activatorKeysMap = {
      leftClick = 'LEFT-CLICK',
      rightClick = 'RIGHT-CLICK',
   };

   local modKeysMap = {
      alt = 'ALT',
      ctrl = 'CTRL',
      shift = 'SHIFT',
      altCtrl = 'ALT-CTRL',
      altShift = 'ALT-SHIFT',
      ctrlShift = 'CTRL-SHIFT',
   };

   return {
      type = 'group',
      name = 'Mark As Junk',
      desc = 'Configure the marking & selling options for your junk items.',
      args = {
         markingOptions = {
            name = 'Marking',
            type = 'group',
            desc = '',
            order = 1,
            args = {
               keybinds = {
                  name = 'Keybinds',
                  order = 1,
                  type = 'header',
               },
               modKey = {
                  desc = 'This is the additional key to press, along with your activator, to mark your items.',
                  get = function()
                     -- TODO **[G]** :: Update this to use the DB stored value instead
                     return MAJ_Utils.userSelectedModKey;
                  end,
                  name = 'Select your marking mod key...',
                  order = 2,
                  set = function(modKeyTable, value)
                     print('modKey set was activated with: ' .. value);
                     MAJ_Utils.userSelectedModKey = modKeysMap[value];
                  end,
                  type = 'select',
                  values = modKeysMap,
               },
               activatorKey = {
                  desc = 'This is the main mouse key to press, along with your modifier, to mark your items.',
                  get = function()
                     -- TODO **[G]** :: Update this to use the DB stored value instead
                     return MAJ_Utils.userSelectedActivatorKey;
                  end,
                  name = 'Select your marking activator...',
                  order = 3,
                  set = function(activatorTable, value)
                     print('activatorKey set was activated with: ' .. value .. ' || ' .. activatorKeysMap[value]);
                     MAJ_Utils.userSelectedActivatorKey = activatorKeysMap[value];
                  end,
                  type = 'select',
                  values = activatorKeysMap,
               },
            },
         },
         sellingOptions = {
            name = 'Selling',
            type = 'group',
            desc = '',
            order = 2,
            args = {},
         },
         sortingOptions = {
            name = 'Sorting',
            type = 'group',
            desc = '',
            order = 3,
            args = {},
         },
         miscOptions = {
            name = 'Miscellaneous',
            type = 'group',
            desc = '',
            order = 4,
            args = {},
         },
      },
   };
end

-- `addon` is a passed in reference of MarkAsJunk's `self`
function MAJConfig:Init(addon)
   LibStub('AceConfig-3.0'):RegisterOptionsTable('MarkAsJunk', self:GetBlizzOptionsFrame());
   self.optionsFrame = LibStub('AceConfigDialog-3.0'):AddToBlizOptions('MarkAsJunk', 'Mark As Junk');
end
