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
function Utils:getModifierFunction(modKey)
   return MAJ_Constants.modFunctionsMap[modKey];
end

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

function Utils:handleOnClick(bagIndex, bagName, slotFrame)
   return function(frame, button, _down)
      if (self:isMajKeyCombo(button)) then
         maj.logger:Print('CONTAINER NUM SLOTS: ' .. C_Container.GetContainerNumSlots(bagIndex))
         maj.logger:Print('The bag name is: ' .. bagName)
         maj.logger:Print('EXTERNAL SLOT FRAME INFO: id=' .. slotFrame:GetID() .. ', size=' .. slotFrame:GetSize());
         maj.logger:Print('INTERNAL FRAME INFO: id=' .. frame:GetID());
         local item = Item:CreateFromBagAndSlot(bagIndex, slotFrame:GetID());

         -- this tells me if the bag/container slot has an item in there or not
         if (item:IsItemEmpty()) then
            maj.logger:Print('This container slot DOES NOT have an item.');
         else
            maj.logger:Print('This container slot DOES have an item.');
         end
      end
   end
end

function Utils:isMajKeyCombo(button)
   local db = maj.db.profile;
   local modFunction = self:getModifierFunction(db.userSelectedModKey);
   return button == db.userSelectedActivatorKey and modFunction();
end

function Utils:registerClickListeners()
   -- TODO :: Update this to iterate through all bags and item slots to attach click listeners
   local bagIndex = 0
   local bagName = _G["ContainerFrame" .. bagIndex + 1]:GetName()
   local slotIndex = 1
   local slotFrame = _G[bagName .. "Item" .. slotIndex]

   slotFrame:HookScript('OnClick', self:handleOnClick(bagIndex, bagName, slotFrame))
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
