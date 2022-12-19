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
   local db = maj.db.profile;

   if (dialog.OpenFrames['MarkAsJunk']) then
      if (db.showCommandOutput) then
         maj.logger:Print('Hiding the config options window.');
      end

      dialog:Close('MarkAsJunk');
   else
      if (db.showCommandOutput) then
         maj.logger:Print('Showing the config options window.');
      end

      dialog:Open('MarkAsJunk');
   end
end

function Utils:handleOnClick(bagIndex, bagName, slotFrame, numSlots)
   -- "down" is a boolean that tells me that the current `button` is pressed?
   return function(frame, button, down)
      local db = maj.db.profile;
      local item = Item:CreateFromBagAndSlot(bagIndex, slotFrame:GetID());
      local itemID = item:GetItemID();
      local itemName = item:GetItemName();
      local frameID = frame:GetID();

      if (db.debugEnabled) then
         maj.logger:PrintClickInfo(
            bagIndex, bagName, button, down, frame,
            frameID, item, itemID, numSlots, slotFrame
         );
      end

      if (self:isMajKeyCombo(button)) then
         if (item:IsItemEmpty()) then
            -- use `frame.hasItem` instead?
            if (db.showCommandOutput and not db.debugEnabled) then
               maj.logger:Print('No item present. Ignoring.');
            end

            return ;
         elseif (IsAddOnLoaded('ItemLock') and frame.lockItemsAppearanceOverlay.texture:IsShown()) then
            -- TODO **[G]** :: Add another condition above this to check if item is sellable or not
            if (db.showCommandOutput and not db.debugEnabled) then
               maj.logger:Print('Item is locked. Ignoring.');
            end

            return ;
         elseif (not frame.markedJunkOverlay) then
            self:updateMarkedJunkOverlay(
               'overlayMissing', bagIndex, db.overlayColor, db,
               frame, frameID, itemName, itemID
            );

            return ;
         elseif (not frame.markedJunkOverlay:IsShown()) then
            self:updateMarkedJunkOverlay(
               'overlayHidden', bagIndex, db.overlayColor, db,
               frame, frameID, itemName, itemID
            );

            return ;
         else
            self:updateMarkedJunkOverlay(
               'overlayShowing', bagIndex, db.overlayColor, db,
               frame, frameID, itemName, itemID
            );

            return ;
         end
      else
         if (db.debugEnabled) then
            maj.logger:Print('Add-on key combo was not pressed. Ignoring click event listener.');
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

   if (C_Container) then
      C_Container.SortBags();
   else
      local sortButton = _G[BagItemAutoSortButton:GetName()];
      sortButton:Click();
   end
end

function Utils:updateMarkedJunkOverlay(status, bagIndex, color, db, frame, frameID, itemName, itemID)
   if (status == 'overlayMissing' or status == 'overlayHidden') then
      if (db.showCommandOutput and not db.debugEnabled) then
         maj.logger:Print('Marking "' .. tostring(itemName) .. '" as junk.');
      end

      if (status == 'overlayMissing') then
         frame.markedJunkOverlay = CreateFrame("FRAME", nil, frame, "BackdropTemplate");
         frame.markedJunkOverlay:SetSize(frame:GetSize());
         frame.markedJunkOverlay:SetPoint("CENTER");

         frame.markedJunkOverlay:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background"
         });
      end

      frame.markedJunkOverlay:SetFrameLevel(20);
      frame.markedJunkOverlay:SetBackdropColor(color.r, color.g, color.b, color.a);

      if (status == 'overlayHidden') then
         frame.markedJunkOverlay:Show();
      end

      db.markedItems[itemID] = true;
      return ;
   end

   if (status == 'overlayShowing') then
      if (db.showCommandOutput and not db.debugEnabled) then
         maj.logger:Print('Removing the junk marking from "' .. tostring(itemName) .. '".');
      end

      if (db.debugEnabled) then
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
      db.markedItems[itemID] = false;
      return ;
   end
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
