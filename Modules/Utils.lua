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
--## DEFINING ALL CUSTOM UTILS TO BE USED THROUGHOUT THE ADDON
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
   -- "down" is a boolean that tells me that a key is pressed down?
   return function(frame, button, down)
      local item = Item:CreateFromBagAndSlot(bagIndex, slotFrame:GetID());
      local itemID = item:GetItemID();
      local itemName = item:GetItemName();
      local frameID = frame:GetID();
      local oc = maj.db.profile.overlayColor;

      if (maj.db.profile.debugEnabled) then
         maj.logger:PrintClickInfo(
            bagIndex, bagName, button, down, frame,
            frameID, item, itemID, numSlots, slotFrame
         );
      end

      if (self:isMajKeyCombo(button)) then
         -- use `frame.hasItem` instead?
         if (item:IsItemEmpty()) then
            if (maj.db.profile.showCommandOutput and not maj.db.profile.debugEnabled) then
               maj.logger:Print('No item present. Ignoring.');
            end

            return ;
         elseif (IsAddOnLoaded('ItemLock') and frame.lockItemsAppearanceOverlay.texture:IsShown()) then
            if (maj.db.profile.showCommandOutput and not maj.db.profile.debugEnabled) then
               maj.logger:Print('Item is locked. Ignoring.');
            end

            return ;
         elseif (not frame.markedJunkOverlay) then
            if (maj.db.profile.showCommandOutput and not maj.db.profile.debugEnabled) then
               maj.logger:Print('Marking "' .. tostring(itemName) .. '" as junk.');
            end

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
         elseif (not frame.markedJunkOverlay:IsShown()) then
            if (maj.db.profile.showCommandOutput and not maj.db.profile.debugEnabled) then
               maj.logger:Print('Marking "' .. tostring(itemName) .. '" as junk.');
            end

            frame.markedJunkOverlay:SetFrameLevel(20);
            frame.markedJunkOverlay:SetBackdropColor(oc.r, oc.g, oc.b, oc.a);
            frame.markedJunkOverlay:Show();
            maj.db.profile.markedItems[itemID] = true;
            return ;
         else
            if (maj.db.profile.showCommandOutput and not maj.db.profile.debugEnabled) then
               maj.logger:Print('Removing the junk marking from "' .. tostring(itemName) .. '".');
            end

            if (maj.db.profile.debugEnabled) then
               local overlayHexID = tostring(frame.markedJunkOverlay):gsub("table: ", "", 1);

               maj.logger:Print('Clearing the overlay:\n' ..
                  'bag: ' .. tostring(bagIndex) .. '\n' ..
                  'frame: ' .. tostring(frameID) .. '\n' ..
                  'overlayHexID: ' .. overlayHexID
               );
            end

            frame.markedJunkOverlay:SetFrameLevel(0);
            frame.markedJunkOverlay:SetBackdropColor(0, 0, 0, 0);
            frame.markedJunkOverlay:Hide();
            maj.db.profile.markedItems[itemID] = false;
            return ;
         end
      else
         if (maj.db.profile.debugEnabled) then
            maj.logger:Print('handleOnClick: MAJ key combo was not pressed. Ignoring.');
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
