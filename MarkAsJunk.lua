--## ==========================================================================
--## ALL REQUIRED IMPORTS
--## ==========================================================================
-- Libs / Packages
local MarkAsJunk = LibStub('AceAddon-3.0'):NewAddon('MarkAsJunk', 'AceConsole-3.0', 'AceEvent-3.0');

-- TODO **[G]** :: Add local vars for AdiBags, ArkInventory, and OneBag3
--local Baggins = Baggins; -- this will be so I can target Baggins to do stuff later
--local Bagnon = Bagnon; -- this will be so I can target Bagnon to do stuff later (need to verify this name)

--## ==========================================================================
--## START UP & GREETING SCRIPTS
--## ==========================================================================
MarkAsJunk.version = GetAddOnMetadata('MarkAsJunk', 'Version');

function MarkAsJunk:OnInitialize()
   self.db = LibStub('AceDB-3.0'):New('MarkAsJunkDB', { profile = MAJ_Defaults }, true);

   -- NOTE :: Do I want to keep this? This came from Mayron's YT video
   -- To be able to use the left and right arrows in the edit box
   -- without rotating your character
   for i = 1, NUM_CHAT_WINDOWS, 1 do
      _G['ChatFrame' .. i .. 'EditBox']:SetAltArrowKeyMode(false);
   end

   -- calling all modules! all modules to the front!
   self.config = self:GetModule('Config');
   self.logger = self:GetModule('Logger');

   -- do you init or not bro?!
   self.config:Init(self)

   -- we're slashing prices so much it's like we're crazy!
   self:RegisterChatCommand('maj', 'SlashCommandInfoConfig');
   self:RegisterChatCommand('nrl', 'SlashCommandReload');
   self:RegisterChatCommand('nfs', 'SlashCommandFrameStack');

   if (self.db.profile.showGreeting) then
      self.logger:Print('Hi, ' .. UnitName('player') .. '! Thanks for using this addon! Type ' .. MAJ_Constants.slashCommandQuoted .. ' to get more info.');
   end
end

--## ==========================================================================
--## MAIN CONFIG / OPTIONS WINDOW
--## ==========================================================================
function MarkAsJunk:OnEnable()
   -- TODO :: What do I (need to) do here?
end

--[[
   TODO :: Move these slash commands into their own file and then INIT them from here
]]
--## ==========================================================================
--## CUSTOM SLASH COMMANDS
--## ==========================================================================
function MarkAsJunk:SlashCommandFrameStack()
   LoadAddOn('Blizzard_DebugTools');
   FrameStackTooltip_Toggle();
end

function MarkAsJunk:SlashCommandInfoConfig(command)
   local Utils = MarkAsJunk:GetModule('Utils');
   command = command:trim();

   -- Display the MarkAsJunk commands and notes
   if (command == '') then
      --print('🌟💰🌟 |cFF00ffff-- MARK AS JUNK COMMANDS --|r 🌟💰🌟');
      self.logger:Print(Utils:cyanText('----- COMMANDS -----') .. '\n' ..
         Utils:badassText('/maj config (c)') .. ' -- Shows the config window to customize this addon.\n' ..
         Utils:badassText('/maj options (o)') .. ' -- This is an alias for "config".\n' ..
         Utils:badassText('/maj hidetext (ht)') .. ' -- ' .. Utils:redText('DISABLES') .. ' text output when using a ' .. MAJ_Constants.slashCommandQuoted .. ' command.\n' ..
         Utils:badassText('/maj showtext (st)') .. ' -- ' .. Utils:greenText('ENABLES') .. ' text output when using a ' .. MAJ_Constants.slashCommandQuoted .. ' command.'
      );

      return ;
   end

   local isConfigOptionsCommand = command == 'config' or
      command == 'c' or
      command == 'options' or
      command == 'o';

   if (isConfigOptionsCommand) then
      Utils:handleConfigOptionsDisplay();
      return ;
   end

   if (command == 'hidetext' or command == 'ht') then
      self.logger:Print('The slash command output text has been ' .. Utils:redText('DISABLED'));
      Utils:setDbValue('showSlashCommandOutput', false);
      return ;
   end

   if (command == 'showtext' or command == 'st') then
      self.logger:Print('The slash command output text has been ' .. Utils:greenText('ENABLED'));
      Utils:setDbValue('showSlashCommandOutput', true);
      return ;
   end

   self.logger:Print('"' .. command .. '" is an unknown command.');
   return ;
end

function MarkAsJunk:SlashCommandReload()
   ReloadUI();
end
