--## ===============================================================================================
--## ALL REQUIRED IMPORTS
--## ===============================================================================================
-- Libs / Packages
local MarkAsJunk = LibStub('AceAddon-3.0'):GetAddon('MarkAsJunk');

--## ===============================================================================================
--## INTERNAL VARS & SET UP
--## ===============================================================================================
--local Slashies = MarkAsJunk:NewModule('Utils');

--## ===============================================================================================
--## DEFINING ALL CUSTOM UTILS TO BE USED THROUGHOUT THE ADDON
--## ===============================================================================================
function MarkAsJunk:SlashCommandFrameStack()
   if (self.db.profile.debugEnabled) then
      LoadAddOn('Blizzard_DebugTools');
      FrameStackTooltip_Toggle();
   end

   return ;
end

function MarkAsJunk:SlashCommandInfoConfig(command)
   command = command:trim();

   -- Display the MarkAsJunk commands and notes
   if (command == '') then
      --print('🌟💰🌟 |cFF00ffff-- MARK AS JUNK COMMANDS --|r 🌟💰🌟');
      self.logger:Print(self.chalk:cyan('----- COMMANDS -----') .. '\n' ..
         self.chalk:badass('/mia config (c)') .. ' -- Shows the config window to customize this addon.\n' ..
         self.chalk:badass('/mia options (o)') .. ' -- This is an alias for "config".\n' ..
         self.chalk:badass('/mia hidetext (ht)') .. ' -- ' .. self.chalk:red('DISABLES') .. ' text output when using a ' .. MAJ_Constants.slashCommandQuoted .. ' command.\n' ..
         self.chalk:badass('/mia showtext (st)') .. ' -- ' .. self.chalk:green('ENABLES') .. ' text output when using a ' .. MAJ_Constants.slashCommandQuoted .. ' command.\n' ..
         self.chalk:badass('/mia debug (d)') .. ' -- This enables debug logging. Really only useful for add-on devs.'
      );

      return ;
   end

   local isConfigOptionsCommand = command == 'config' or
      command == 'c' or
      command == 'options' or
      command == 'o';

   if (isConfigOptionsCommand) then
      self.utils:handleConfigOptionsDisplay();
      return ;
   end

   local isShowHideOutputCommand = command == 'hidetext' or
      command == 'ht' or
      command == 'showtext' or
      command == 'st';

   if (isShowHideOutputCommand) then
      local showOutputLogMessage;
      local showOutputValue;

      if (command == 'hidetext' or command == 'ht') then
         showOutputLogMessage = self.chalk:red('DISABLED');
         showOutputValue = false;
      end

      if (command == 'showtext' or command == 'st') then
         showOutputLogMessage = self.chalk:green('ENABLED');
         showOutputValue = true;
      end

      self.logger:Print('The slash command output text has been ' .. showOutputLogMessage .. '.');
      self.utils:setDbValue('showCommandOutput', showOutputValue);
      return ;
   end

   local isDebugCommand = command == 'debug' or command == 'd';

   if (isDebugCommand) then
      local debugValue = not (self.db.profile.debugEnabled == true);
      local debugValueDisplay = string.upper(tostring(debugValue));

      if (self.db.profile.showCommandOutput) then
         self.logger:Print('Setting the debug value to: ' .. self.chalk:debug(debugValueDisplay));
      end

      self.utils:setDbValue('debugEnabled', debugValue);
      return ;
   end

   self.logger:Print('"' .. command .. '" is an unknown command.');
   return ;
end

function MarkAsJunk:SlashCommandReload()
   ReloadUI();
   return ;
end
