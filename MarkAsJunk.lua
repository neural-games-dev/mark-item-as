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
   self.utils = self:GetModule('Utils');

   -- do you init or not bro?!
   self.config:Init(self)

   -- we're slashing prices so much it's like we're crazy!
   self:RegisterChatCommand('maj', 'SlashCommandInfoConfig');
   self:RegisterChatCommand('nrl', 'SlashCommandReload');
   self:RegisterChatCommand('nfs', 'SlashCommandFrameStack');

   if (self.db.profile.showGreeting) then
      self.logger:Print('Hi, ' .. UnitName('player') .. '! Thanks for using "MarkAsJunk"! Type ' .. MAJ_Constants.slashCommandQuoted .. ' to get more info.');
   end

   if (self.db.profile.showWarnings) then
      if (IsAddOnLoaded('Peddler')) then
         self.logger:Print(MAJ_Constants.warnings.peddlerLoaded);
      end
   end
end

--## ===============================================================================================
--## MAIN CONFIG / OPTIONS WINDOW
--## ===============================================================================================
function MarkAsJunk:OnEnable()
   local u = self.utils;
   -- TODO :: Iterating through all bags and item slots to attach click listeners
   local bagIndex = 0

   if C_Container then
      print('we have a c container')
      print(C_Container.GetContainerNumSlots(bagIndex))
   end

   local bagName = _G["ContainerFrame" .. bagIndex + 1]:GetName()
   local slotIndex = 1

   print('The bag name is: ' .. bagName)

   local slotFrame = _G[bagName .. "Item" .. slotIndex]
   print('The slot frame ID is: ' .. slotFrame:GetID() .. ', with size: ' .. slotFrame:GetSize())

   slotFrame:HookScript('OnClick', function(frame, button, _down)
      if (u:isMajKeyCombo(button)) then
         print('do we click?' .. ', frame: ' .. frame:GetID())
         local item = Item:CreateFromBagAndSlot(bagIndex, slotFrame:GetID());
         self.logger:Print(item:IsItemEmpty()); -- this tells me if the bag/container slot has an item in there or not
      end
   end)
end

--[[
   TODO :: Move these slash commands into their own file and then INIT them from here
]]
--## ===============================================================================================
--## CUSTOM SLASH COMMANDS
--## ===============================================================================================
function MarkAsJunk:SlashCommandFrameStack()
   LoadAddOn('Blizzard_DebugTools');
   FrameStackTooltip_Toggle();
end

function MarkAsJunk:SlashCommandInfoConfig(command)
   local u = self.utils;
   command = command:trim();

   -- Display the MarkAsJunk commands and notes
   if (command == '') then
      --print('🌟💰🌟 |cFF00ffff-- MARK AS JUNK COMMANDS --|r 🌟💰🌟');
      self.logger:Print(u:cyan('----- COMMANDS -----') .. '\n' ..
         u:badass('/maj config (c)') .. ' -- Shows the config window to customize this addon.\n' ..
         u:badass('/maj options (o)') .. ' -- This is an alias for "config".\n' ..
         u:badass('/maj hidetext (ht)') .. ' -- ' .. u:red('DISABLES') .. ' text output when using a ' .. MAJ_Constants.slashCommandQuoted .. ' command.\n' ..
         u:badass('/maj showtext (st)') .. ' -- ' .. u:green('ENABLES') .. ' text output when using a ' .. MAJ_Constants.slashCommandQuoted .. ' command.'
      );

      return ;
   end

   local isConfigOptionsCommand = command == 'config' or
      command == 'c' or
      command == 'options' or
      command == 'o';

   if (isConfigOptionsCommand) then
      u:handleConfigOptionsDisplay();
      return ;
   end

   if (command == 'hidetext' or command == 'ht') then
      self.logger:Print('The slash command output text has been ' .. u:red('DISABLED'));
      u:setDbValue('showSlashCommandOutput', false);
      return ;
   end

   if (command == 'showtext' or command == 'st') then
      self.logger:Print('The slash command output text has been ' .. u:green('ENABLED'));
      u:setDbValue('showSlashCommandOutput', true);
      return ;
   end

   self.logger:Print('"' .. command .. '" is an unknown command.');
   return ;
end

function MarkAsJunk:SlashCommandReload()
   ReloadUI();
end
