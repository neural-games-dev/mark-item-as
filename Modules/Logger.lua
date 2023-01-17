--## ===============================================================================================
--## ALL REQUIRED IMPORTS
--## ===============================================================================================
-- Libs / Packages
local MarkItemAs = LibStub('AceAddon-3.0'):GetAddon('MarkItemAs');

--## ===============================================================================================
--## INTERNAL VARS & SET UP
--## ===============================================================================================
local Logger = MarkItemAs:NewModule('Logger');

--## ===============================================================================================
--## DEFINING THE LOGGER METHODS
--## ===============================================================================================
function Logger:Init(mia)
   self.mia = mia;
   self.isPratLoaded = self.mia.utils:GetDbValue('isLoaded.prat');
end

function Logger:Debug(...)
   if (MarkItemAs.db.profile.debugEnabled) then
      local prefix;

      if (self.isPratLoaded) then
         prefix = self.mia.chalk:debug('[DEBUG]');
      else
         prefix = self.mia.chalk:debug('[DEBUG] ') .. self.mia.chalk:ace('(' .. tostring(date()) .. ')');
      end

      MarkItemAs:Print(prefix, ...);
   end
end

function Logger:DebugClickInfo(bagIndex, bagName, button, down, frame, frameID, item, itemID, itemSellPrice, numSlots, slotFrame)
   self:Debug('HANDLE ON CLICK INFO:\n' ..
      '————————————————————————\n' ..
      'BagName = ' .. tostring(bagName) .. '\n' ..
      'BagIndex = ' .. tostring(bagIndex) .. '\n' ..
      'ContainerNumSlots = ' .. tostring(numSlots) .. '\n' ..
      '————————————————————————\n' ..
      'SlotFrameName = ' .. tostring(slotFrame:GetName()) .. '\n' ..
      'SlotFrameID = ' .. tostring(slotFrame:GetID()) .. '\n' ..
      '————————————————————————\n' ..
      'FrameName = ' .. tostring(frame:GetName()) .. '\n' ..
      'FrameID = ' .. tostring(frameID) .. '\n' ..
      '————————————————————————\n' ..
      'ItemName = ' .. tostring(item:GetItemName()) .. '\n' ..
      'ItemID = ' .. tostring(itemID) .. '\n' ..
      'ItemSellPrice = ' .. tostring(itemSellPrice) .. '\n' ..
      'ItemLocation.SlotIndex = ' .. tostring(item:GetItemLocation().slotIndex) .. '\n' ..
      '————————————————————————'
   );
end

function Logger:Print(...)
   if (self.mia.utils:GetDbValue('debugEnabled')) then
      self:Debug(...);
   else
      MarkItemAs:Print(...);
   end
end

function Logger:PrintSaleSummary(totalSellPrice, totalItemsSold, uniqueItemsSold, itemLinksList)
   local summaryOutput = self.mia.chalk:money('$$$$$ SALE SUMMARY $$$$$') .. '\n' ..
      self.mia.chalk:money('Total Money Made: ') .. tostring(self.mia.utils:PriceToGold(totalSellPrice)) .. '\n' ..
      self.mia.chalk:money('Total Unique Items Sold: ') .. tostring(uniqueItemsSold) .. '\n' ..
      self.mia.chalk:money('Total Items Count Sold: ') .. tostring(totalItemsSold) .. '\n' ..
      self.mia.chalk:money('Items List:') .. '\n';

   for idx, itemLink in ipairs(itemLinksList) do
      local itemLinkLine = '   ' .. tostring(idx) .. '. ' .. itemLink .. '\n';
      summaryOutput = summaryOutput .. itemLinkLine;
   end

   self:Print(summaryOutput);
end
