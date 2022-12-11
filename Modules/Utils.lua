-- TODO **[G]** :: Convert this into a module
--## ==========================================================================
--## ALL REQUIRED IMPORTS
--## ==========================================================================
-- Libs / Packages
local dialog = LibStub("AceConfigDialog-3.0");
local maj = LibStub('AceAddon-3.0'):GetAddon('MarkAsJunk');
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

function Utils:SortBags()
   local isBagginsLoaded = self:getDbValue('isBagginsLoaded');

   if (isBagginsLoaded) then
      print(MAJ_Constants.bagginsLoadedWarning);
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
function Utils:badassText(textToColorize)
   return '|cFFbada55' .. textToColorize .. '|r';
end

function Utils:greenText(textToColorize)
   return '|cFF00ff00' .. textToColorize .. '|r';
end

function Utils:redText(textToColorize)
   return '|cFFff0000' .. textToColorize .. '|r';
end
