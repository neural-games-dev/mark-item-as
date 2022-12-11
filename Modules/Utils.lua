--## ===============================================================================================
--## ALL REQUIRED IMPORTS
--## ===============================================================================================
-- Libs / Packages
local dialog = LibStub("AceConfigDialog-3.0");
local maj = LibStub('AceAddon-3.0'):GetAddon('MarkAsJunk');

--## ===============================================================================================
--## INTERNAL VARS & SET UP
--## ===============================================================================================
local Utils = maj:NewModule('Utils');

--## ===============================================================================================
--##DEFINING ALL CUSTOM UTILS TO BE USED THROUGHOUT THE ADDON
--## ===============================================================================================
function Utils:handleConfigOptionsDisplay()
   local showSlashCommandOutput = self:getDbValue('showSlashCommandOutput');

   if (dialog.OpenFrames['MarkAsJunk']) then
      if (showSlashCommandOutput) then
         maj.logger:Print('Hiding the config options window.');
      end

      dialog:Close('MarkAsJunk');
   else
      if (showSlashCommandOutput) then
         maj.logger:Print('Showing the config options window.');
      end

      dialog:Open('MarkAsJunk');
   end
end

function Utils:isMajKeyCombo(button)
   local db = maj.db.profile;
   return button == db.userSelectedActivatorKey and IsAltKeyDown();
end

function Utils:sortBags()
   if (IsAddOnLoaded('Baggins')) then
      maj.logger:Print(MAJ_Constants.warnings.bagginsLoaded);
      return ;
   end

   local sortButton = _G[BagItemAutoSortButton:GetName()];
   sortButton:Click();
end

--## --------------------------------------------------------------------------
--## DATABASE OPERATION FUNCTIONS
--## --------------------------------------------------------------------------
function Utils:getDbValue(key)
   return maj.db.profile[key];
end

function Utils:setDbValue(key, value)
   maj.db.profile[key] = value;
end

--## --------------------------------------------------------------------------
--## TEXT COLORIZING FUNCTIONS
--## --------------------------------------------------------------------------
function Utils:ace(text)
   return '|cFF33ff99' .. text .. '|r';
end

function Utils:badass(text)
   return '|cFFbada55' .. text .. '|r';
end

function Utils:cyan(text)
   return '|cFF00ffff' .. text .. '|r';
end

function Utils:green(text)
   return '|cFF00ff00' .. text .. '|r';
end

function Utils:red(text)
   return '|cFFff0000' .. text .. '|r';
end

function Utils:warn(text)
   return '|cFFfa8200' .. text .. '|r';
end
