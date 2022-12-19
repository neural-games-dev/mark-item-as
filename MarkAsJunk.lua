--## ===============================================================================================
--## ALL REQUIRED IMPORTS
--## ===============================================================================================
-- Libs / Packages
local MarkAsJunk = LibStub('AceAddon-3.0'):NewAddon('MarkAsJunk', 'AceConsole-3.0', 'AceEvent-3.0');

-- TODO :: Add local vars (?) for AdiBags, ArkInventory, and OneBag3 or will the Plugin modules take care of this?
--local Baggins = Baggins; -- this will be so I can target Baggins to do stuff later
--local Bagnon = Bagnon; -- this will be so I can target Bagnon to do stuff later (need to verify this name)

--## ===============================================================================================
--## START UP & GREETING SCRIPTS
--## ===============================================================================================
MarkAsJunk.version = GetAddOnMetadata('MarkAsJunk', 'Version');

function MarkAsJunk:OnInitialize()
   self.version = 'v0.1.0';
   self.db = LibStub('AceDB-3.0'):New('MarkAsJunkDB', { profile = MAJ_Defaults }, true);

   -- calling all modules! all modules to the front!
   self.chalk = self:GetModule('Chalk');
   self.config = self:GetModule('Config');
   self.logger = self:GetModule('Logger');
   self.utils = self:GetModule('Utils');

   -- do you init or not bro?!
   self.config:Init(self)

   -- we're slashing prices so much it's like we're crazy!
   self:RegisterChatCommand('maj', 'SlashCommandInfoConfig');
   self:RegisterChatCommand('nrl', 'SlashCommandReload');
   self:RegisterChatCommand('nfs', 'SlashCommandFrameStack');
end

--## ===============================================================================================
--## MAIN CONFIG / OPTIONS WINDOW
--## ===============================================================================================
function MarkAsJunk:OnEnable()
   self.utils:registerClickListeners();
   -- TODO **[G]** :: Add the invocation of the util that will loop through all the bag slots and update their marked status/overlays

   if (self.db.profile.showGreeting) then
      self.logger:Print('Hi, ' .. UnitName('player') ..
         '! Thanks for using "MarkAsJunk"! Type ' ..
         MAJ_Constants.slashCommandQuoted .. ' to get more info.'
      );
   end

   if (self.db.profile.showWarnings) then
      if (IsAddOnLoaded('Peddler')) then
         self.logger:Print(MAJ_Constants.warnings.peddlerLoaded);
      end
   end

   return ;
end

--[[
   TODO :: Move these slash commands into their own file and then INIT them from here
]]
--## ===============================================================================================
--## CUSTOM SLASH COMMANDS
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
         self.chalk:badass('/maj config (c)') .. ' -- Shows the config window to customize this addon.\n' ..
         self.chalk:badass('/maj options (o)') .. ' -- This is an alias for "config".\n' ..
         self.chalk:badass('/maj hidetext (ht)') .. ' -- ' .. self.chalk:red('DISABLES') .. ' text output when using a ' .. MAJ_Constants.slashCommandQuoted .. ' command.\n' ..
         self.chalk:badass('/maj showtext (st)') .. ' -- ' .. self.chalk:green('ENABLES') .. ' text output when using a ' .. MAJ_Constants.slashCommandQuoted .. ' command.\n' ..
         self.chalk:badass('/maj debug (d)') .. ' -- This enables debug logging. Really only useful for add-on devs.'
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
