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
   mia.logger:Debug('Initializing the Tooltip module...');

   if GameTooltip.OnTooltipSetItem then
      GameTooltip:HookScript("OnTooltipSetItem", function(tooltip)
         Tooltip:setGameTooltip(mia, tooltip, 'OnTooltipSetItem');
      end)
   elseif TooltipDataProcessor then
      TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
         Tooltip:setGameTooltip(mia, tooltip, 'TooltipDataProcessor');
      end)
   end
end

function Tooltip:setGameTooltip(mia, tooltip, context)
   mia.logger:Debug('setGameTooltip has been called. Show text? -> ' .. tostring(mia.db.showTooltipText));

   if (not tooltip.GetItem) then
      mia.logger:Debug(context .. ': No tooltip item found. Returning...');
      return ;
   end

   -- TODO **[G]** :: This condition is nil, need a better way to grab the DB value
   if (mia.db.showTooltipText) then
      if (mia.db.showCommandOutput and not mia.db.debugEnabled) then
         mia.logger:Print('Adding tooltip text to some itemID.');
      end

      mia.logger:Debug(context .. ': Adding item tooltip text.');
      -- TODO **[G]** :: This gets added no matter what, need to pass & check if the item is actually/currently marked
      tooltip:AddLine('Marked as Junk - To be sold');
   end
end
