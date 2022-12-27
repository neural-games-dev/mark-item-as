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
   -- Third args can be passed to these callbacks
   -- these args are extra values that you want the CBs to have
   self:RegisterEvent('BAG_UPDATE', 'BagUpdateCB');
   self:RegisterEvent('MERCHANT_CLOSED', 'MerchantClosedCB');
   self:RegisterEvent('MERCHANT_SHOW', 'MerchantShowCB');
   self:RegisterEvent('PLAYER_LOGIN', 'PlayerLoginCB');
   self.utils:registerClickListeners();

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
--## REGISTERED EVENT LISTENER CALLBACKS
--## ===============================================================================================
function MarkAsJunk:BagUpdateCB()
   self.logger:Debug('BAG_UPDATE registered event callback has been triggered. Doing stuff...');
   self.utils:updateBagMarkings();
end

function MarkAsJunk:MerchantClosedCB()
   self.logger:Debug('MERCHANT_CLOSED registered event callback has been triggered. Doing stuff...');
end

function MarkAsJunk:MerchantShowCB()
   self.logger:Debug('MERCHANT_SHOW registered event callback has been triggered. Doing stuff...');
end

-- This handles both when the player logs in (as is obvious by the name)
-- but it also handles when the game reloads
function MarkAsJunk:PlayerLoginCB()
   self.logger:Debug('PLAYER_LOGIN registered event callback has been triggered. Doing stuff...');
   self.utils:updateBagMarkings();
end
