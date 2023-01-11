--## ===============================================================================================
--## ALL REQUIRED IMPORTS
--## ===============================================================================================
-- Libs / Packages
local MarkItemAs = LibStub('AceAddon-3.0'):GetAddon('MarkItemAs');

--## ===============================================================================================
--## INTERNAL VARS & SET UP
--## ===============================================================================================
local Tooltip = MarkItemAs:NewModule('Tooltip');
local Utils = MarkItemAs:GetModule('Utils');

--## ===============================================================================================
--## DEFINING ALL CUSTOM UTILS TO BE USED THROUGHOUT THE ADDON
--## ===============================================================================================
function Tooltip:Init(logger)
   logger:Debug('Initializing the Tooltip module...');

   if GameTooltip.OnTooltipSetItem then
      GameTooltip:HookScript("OnTooltipSetItem", function(tooltip)
         Tooltip:setGameTooltip(logger, tooltip, 'OnTooltipSetItem');
      end)
   elseif TooltipDataProcessor then
      TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
         Tooltip:setGameTooltip(logger, tooltip, 'TooltipDataProcessor');
      end)
   end
end

function Tooltip:setGameTooltip(logger, tooltip, context)
   local debugEnabled = Utils:getDbValue('debugEnabled');
   local markedItems = Utils:getDbValue('markedItems');
   local showCommandOutput = Utils:getDbValue('showCommandOutput');
   local showTooltipText = Utils:getDbValue('showTooltipText');

   logger:Debug(context .. ': setGameTooltip has been called. Show text? -> ' .. tostring(showTooltipText));

   if (not tooltip.GetItem) then
      logger:Debug(context .. ': No tooltip item found. Returning...');
      return ;
   end

   if (showTooltipText) then
      local itemName, itemLink = tooltip:GetItem();
      local itemID = tonumber(string.match(itemLink, 'item:(%d+):'));
      local isItemMarked = markedItems[itemID];

      if (isItemMarked) then
         if (showCommandOutput and not debugEnabled) then
            logger:Print('Adding tooltip text to "' .. tostring(itemName) .. '".');
         end

         logger:Debug(context .. ': Adding item tooltip text to "' .. tostring(itemName) .. '", with ID: ' .. tostring(itemID));
         tooltip:AddLine('Marked as Junk - To be sold');
      end
   end
end
