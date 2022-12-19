--## ===============================================================================================
--## ALL REQUIRED IMPORTS
--## ===============================================================================================
-- Libs / Packages
local MarkAsJunk = LibStub('AceAddon-3.0'):GetAddon('MarkAsJunk');

--## ===============================================================================================
--## INTERNAL VARS & SET UP
--## ===============================================================================================
local Logger = MarkAsJunk:NewModule('Logger');
local u = MarkAsJunk:GetModule('Utils');

--## ===============================================================================================
--## DEFINING THE LOGGER METHODS
--## ===============================================================================================
function Logger:Print(...)
   if (MarkAsJunk.db.profile.debugEnabled) then
      MarkAsJunk:Print(u:debug('[DEBUGGING] '), ...);
   else
      MarkAsJunk:Print(...);
   end
end

function Logger:PrintClickInfo(bagIndex, bagName, button, down, frame, frameID, item, itemID, numSlots, slotFrame)
   self:Print('HANDLE ON CLICK INFO:\n' ..
      '————————————————————————\n' ..
      'BagName: ' .. tostring(bagName) .. '\n' ..
      'BagIndex: ' .. tostring(bagIndex) .. '\n' ..
      'ContainerNumSlots: ' .. tostring(numSlots) .. '\n' ..
      '————————————————————————\n' ..
      'SlotFrameName: ' .. tostring(slotFrame:GetName()) .. '\n' ..
      'SlotFrameID: ' .. tostring(slotFrame:GetID()) .. '\n' ..
      '————————————————————————\n' ..
      'FrameName: ' .. tostring(frame:GetName()) .. '\n' ..
      'FrameID: ' .. tostring(frameID) .. '\n' ..
      '————————————————————————\n' ..
      'ItemName: ' .. tostring(item:GetItemName()) .. '\n' ..
      'ItemID: ' .. tostring(itemID) .. '\n' ..
      'ItemLocation.SlotIndex: ' .. tostring(item:GetItemLocation().slotIndex) .. '\n' ..
      '————————————————————————'
   );
end
