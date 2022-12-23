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

function MarkAsJunk:OnEnable()
   --self:RegisterEvent("BAG_UPDATE");
   --self:RegisterEvent("MERCHANT_CLOSED");
   --self:RegisterEvent("MERCHANT_SHOW");
   --self:RegisterEvent("PLAYER_LOGIN"); -- use this to `UpdateSlots` and iterate through everything to re-add the junk markings

   self.utils:registerClickListeners();
   -- TODO **[G]** :: Add the invocation of the util that will loop through all the bag slots and update their marked status/overlays

   if (self.db.profile.showGreeting) then
      self.logger:Print('Hi, ' .. UnitName('player') ..
         '! Thanks for using "MarkAsJunk"! Type ' ..
         MAJ_Constants.slashCommandQuoted .. ' to get more info.'
      );
   end

   if (self.db.profile.showWarnings) then
      if (IsAddOnLoaded('Baggins')) then
         self.logger:Print(MAJ_Constants.warnings.bagginsLoaded);
      end

      if (IsAddOnLoaded('Peddler')) then
         self.logger:Print(MAJ_Constants.warnings.peddlerLoaded);
      end
   end

   return ;
end

--## ===============================================================================================
--## bllr
--## ===============================================================================================
