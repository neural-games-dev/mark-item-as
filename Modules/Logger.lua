--## ===============================================================================================
--## ALL REQUIRED IMPORTS
--## ===============================================================================================
-- Libs / Packages
local MarkAsJunk = LibStub('AceAddon-3.0'):GetAddon('MarkAsJunk');

--## ===============================================================================================
--## INTERNAL VARS & SET UP
--## ===============================================================================================
local Logger = MarkAsJunk:NewModule('Logger');

--## ===============================================================================================
--## DEFINING THE LOGGER METHODS
--## ===============================================================================================
function Logger:Debug(...)
   if (MarkAsJunk.db.profile.debugEnabled) then
      local chalk = MarkAsJunk.chalk;
      local prefix = chalk:debug('[DEBUGGING] ') .. chalk:ace('(' .. tostring(date()) .. ')');
      MarkAsJunk:Print(prefix, ...);
   end
end

function Logger:DebugClickInfo(bagIndex, bagName, button, down, frame, frameID, item, itemID, numSlots, slotFrame)
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
      'ItemLocation.SlotIndex = ' .. tostring(item:GetItemLocation().slotIndex) .. '\n' ..
      '————————————————————————'
   );
end

function Logger:Print(...)
   if (MarkAsJunk.db.profile.debugEnabled) then
      self:Debug(...);
   else
      MarkAsJunk:Print(...);
   end
end
