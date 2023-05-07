--## ===============================================================================================
--## ALL REQUIRED IMPORTS
--## ===============================================================================================
-- Libs / Packages
local MarkItemAs = LibStub('AceAddon-3.0'):GetAddon('MarkItemAs');

--## ===============================================================================================
--## INTERNAL VARS & SET UP
--## ===============================================================================================
local Tooltip = MarkItemAs:NewModule('Tooltip');

--## ===============================================================================================
--## DEFINING ALL CUSTOM UTILS TO BE USED THROUGHOUT THE ADDON
--## ===============================================================================================
function Tooltip:Init(mia)
   self.mia = mia;
   mia.logger:Debug('Initializing the Tooltip module...');

   if GameTooltip.OnTooltipSetItem then
      GameTooltip:HookScript("OnTooltipSetItem", function(tooltip)
         Tooltip:SetGameTooltip(tooltip, 'OnTooltipSetItem');
      end)
   elseif TooltipDataProcessor then
      TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
         Tooltip:SetGameTooltip(tooltip, 'TooltipDataProcessor');
      end)
   end
end

function Tooltip:SetGameTooltip(tooltip, context)
   local enableVerboseLogging = self.mia.utils:GetDbValue('enableVerboseLogging');
   local junkItems = self.mia.utils:GetDbValue('junkItems');
   local showTooltipText = self.mia.utils:GetDbValue('showTooltipText');

   if (enableVerboseLogging) then
      self.mia.logger:Debug(context .. ': SetGameTooltip has been called. Show text? -> ' .. tostring(showTooltipText));
   end

   if (not tooltip.GetItem) then
      self.mia.logger:Debug(context .. ': SetGameTooltip -- No tooltip `GetItem` found. Returning...');
      return ;
   end

   if (showTooltipText) then
      local itemName, itemLink = tooltip:GetItem();

      if (itemLink) then
         local itemID = tonumber(string.match(itemLink, 'item:(%d+):'));
         local isItemMarkedJunk = junkItems[itemID];

         if (isItemMarkedJunk) then
            if (enableVerboseLogging) then
               self.mia.logger:Debug(context .. ': SetGameTooltip -- Adding item tooltip text to "' .. tostring(itemName) .. '", with ID: ' .. tostring(itemID));
            end

            tooltip:AddLine('Marked as Junk - To be sold');
         end
      else
         self.mia.logger:Debug(context .. ': SetGameTooltip -- No `itemLink` found to add tooltip text.');
      end
   end
end
