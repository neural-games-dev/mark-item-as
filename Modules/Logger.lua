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
function Logger:Debug(...)
   if (MarkItemAs.db.profile.debugEnabled) then
      local chalk = MarkItemAs.chalk;
      local prefix = chalk:debug('[DEBUG] ') .. chalk:ace('(' .. tostring(date()) .. ')');
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
   if (MarkItemAs.db.profile.debugEnabled) then
      self:Debug(...);
   else
      MarkItemAs:Print(...);
   end
end
