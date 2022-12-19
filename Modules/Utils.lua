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
   if (dialog.OpenFrames['MarkAsJunk']) then
      if (maj.db.profile.showCommandOutput) then
         maj.logger:Print('Hiding the config options window.');
      end

      dialog:Close('MarkAsJunk');
   else
      if (maj.db.profile.showCommandOutput) then
         maj.logger:Print('Showing the config options window.');
      end

      dialog:Open('MarkAsJunk');
   end
end

function Utils:handleOnClick(bagIndex, bagName, slotFrame, numSlots)
   return function(frame, button, _down)
      -- "down" is a boolean that tells me that a key is pressed down?
      local item = Item:CreateFromBagAndSlot(bagIndex, slotFrame:GetID());
      local itemID = item:GetItemID();
      local frameID = frame:GetID();

      if (maj.db.profile.debugEnabled) then
         maj.logger:Print('HANDLE ON CLICK INFO:\n' ..
            '————————————————————————\n' ..
            'BagName: ' .. tostring(bagName) .. '\n' ..
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

      if (self:isMajKeyCombo(button)) then
         -- use `frame.hasItem` instead?
         if (item:IsItemEmpty()) then
            if (maj.db.profile.showCommandOutput and not maj.db.profile.debugEnabled) then
               maj.logger:Print('No item present. Ignoring.');
            end

            return ;
            -- TODO **[G]** :: Re-enable this ItemLock check once I have marking work properly
            --elseif (IsAddOnLoaded('ItemLock') and not not frame.lockItemsAppearanceOverlay) then
            --   maj.logger:Print('Item is locked, ignoring.');
            --   return ;
         elseif (not frame.markedJunkOverlay) then
            if (maj.db.profile.showCommandOutput and not maj.db.profile.debugEnabled) then
               maj.logger:Print('Adding an overlay to "' .. tostring(item:GetItemName()) .. '".');
            end

            local oc = maj.db.profile.overlayColor;
            frame.markedJunkOverlay = CreateFrame("FRAME", nil, frame, "BackdropTemplate");
            frame.markedJunkOverlay:SetSize(frame:GetSize());
            frame.markedJunkOverlay:SetPoint("CENTER");

            frame.markedJunkOverlay:SetBackdrop({
               bgFile = "Interface/Tooltips/UI-Tooltip-Background"
            });

            frame.markedJunkOverlay:SetFrameLevel(20);
            frame.markedJunkOverlay:SetBackdropColor(oc.r, oc.g, oc.b, oc.a);
            maj.db.profile.markedItems[itemID] = true;
            return ;
         else
            if (maj.db.profile.showCommandOutput and not maj.db.profile.debugEnabled) then
               maj.logger:Print('Removing the overlay from "' .. tostring(item:GetItemName()) .. '".');
            end

            if (maj.db.profile.debugEnabled) then
               maj.logger:Print('Clearing the overlay for bag: ' .. bagIndex .. ', frame: ' .. tostring(frameID));
            end

            frame.markedJunkOverlay:SetBackdropColor(0, 0, 0, 0);
            frame.markedJunkOverlay = nil;
            maj.db.profile.markedItems[itemID] = false;
            return ;
         end
      else
         if (maj.db.profile.debugEnabled) then
            maj.logger:Print('MAJ key combo was not pressed. Ignoring.');
         end

         return ;
      end
   end
end

function Utils:isMajKeyCombo(button)
   local db = maj.db.profile;
   local modKeyIsPressed = self:getModifierFunction(db.userSelectedModKey);
   return button == db.userSelectedActivatorKey and modKeyIsPressed();
end

function Utils:registerClickListeners()
   for bagIndex = 0, MAJ_Constants.numContainers, 1 do
      local bagName = _G["ContainerFrame" .. bagIndex + 1]:GetName();
      local numSlots = C_Container.GetContainerNumSlots(bagIndex);

      if (numSlots > 0) then
         for slotIndex = 1, numSlots, 1 do
            local slotFrame = _G[bagName .. "Item" .. slotIndex];
            slotFrame:HookScript('OnClick', self:handleOnClick(bagIndex, bagName, slotFrame, numSlots));
         end
      else
         if (maj.db.profile.debugEnabled) then
            maj.logger:Print('Container at bag index "' .. tostring(bagIndex) .. '" appears to be empty.');
         end
      end
   end
end

function Utils:sortBags()
   if (IsAddOnLoaded('Baggins')) then
      maj.logger:Print(MAJ_Constants.warnings.bagginsLoaded);
      return ;
   end

   -- TODO :: This might be better as it's probably more stable if Blizz makes changes in the future, but test it out
   -- C_Container.SortBags();
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

function Utils:debug(text)
   return '|cFFfd4a4a' .. text .. '|r';
end

function Utils:green(text)
   return '|cFF00ff00' .. text .. '|r';
end

function Utils:red(text)
   return '|cFFfd4a4a' .. text .. '|r';
end

function Utils:warn(text)
   return '|cFFfa8200' .. text .. '|r';
end
