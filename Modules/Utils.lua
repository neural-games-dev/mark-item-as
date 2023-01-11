--## ===============================================================================================
--## ALL REQUIRED IMPORTS
--## ===============================================================================================
-- Libs / Packages
local dialog = LibStub("AceConfigDialog-3.0");
local mia = LibStub('AceAddon-3.0'):GetAddon('MarkItemAs');

--## ===============================================================================================
--## INTERNAL VARS & SET UP
--## ===============================================================================================
local Utils = mia:NewModule('Utils');
local itemLock;
local ilConfig;

if (IsAddOnLoaded('ItemLock')) then
   itemLock = LibStub('AceAddon-3.0'):GetAddon('ItemLock');

   if (itemLock) then
      ilConfig = itemLock:GetModule('Config');
   end
end

--## ===============================================================================================
--## DEFINING ALL CUSTOM UTILS TO BE USED THROUGHOUT THE ADDON
--## ===============================================================================================
function Utils:getModifierFunction(modKey)
   return MIA_Constants.modFunctionsMap[modKey];
end

function Utils:handleConfigOptionsDisplay()
   local db = mia.db.profile;

   if (dialog.OpenFrames['MarkItemAs']) then
      if (db.showCommandOutput) then
         mia.logger:Print('Hiding the config options window.');
      end

      dialog:Close('MarkItemAs');
   else
      if (db.showCommandOutput) then
         mia.logger:Print('Showing the config options window.');
      end

      dialog:Open('MarkItemAs');
   end
end

function Utils:handleOnClick(bagIndex, bagName, slotFrame, numSlots)
   -- "down" is a boolean that tells me that the current `button` is pressed?
   return function(frame, button, down)
      local db = mia.db.profile;
      -- NOTE **[G]** :: CLEAN UP: Can this `slotFrame` below be replaced by the `frame` from the returned handler instead?
      local item = Item:CreateFromBagAndSlot(bagIndex, slotFrame:GetID());
      local itemID = item:GetItemID();
      local itemName = item:GetItemName();
      local frameID = frame:GetID();
      local itemSellPrice = select('11', GetItemInfo(itemName));

      --## ==========================================================================
      --## Handling "ItemLock" addon key bind actions & conflicts
      --## ==========================================================================
      if (ilConfig and ilConfig:IsClickBindEnabled()) then
         local isItemLockKeyCombo = self:isItemLockKeyCombo(button, ilConfig);
         mia.logger:Debug('Was ItemLock key combo pressed? -> ' .. tostring(isItemLockKeyCombo));

         if (isItemLockKeyCombo and self:isMiaKeyCombo(button)) then
            if (db.showWarnings) then
               mia.logger:Print(MIA_Constants.warnings.itemLockConflict);
            end

            return ;
         elseif (isItemLockKeyCombo and frame.markedJunkOverlay and frame.markedJunkOverlay:IsShown()) then
            if (db.showWarnings) then
               mia.logger:Print(MIA_Constants.warnings.itemLockDoubledUp);
            end

            return ;
         end
      end

      mia.logger:DebugClickInfo(
         bagIndex, bagName, button, down, frame, frameID,
         item, itemID, itemSellPrice, numSlots, slotFrame
      );

      --## ==========================================================================
      --## Handling "MarkItemAs" key bind actions
      --## ==========================================================================
      if (self:isMiaKeyCombo(button)) then
         if (item:IsItemEmpty()) then
            -- ☝ use `frame.hasItem` instead?
            if (db.showCommandOutput and not db.debugEnabled) then
               mia.logger:Print('No item present. Ignoring marking.');
            end

            return ;
         elseif (IsAddOnLoaded('ItemLock') and frame.lockItemsAppearanceOverlay.texture:IsShown()) then
            if (db.showCommandOutput and not db.debugEnabled) then
               mia.logger:Print('Item is locked. Ignoring marking.');
            end

            return ;
         elseif (itemSellPrice == 0 or itemSellPrice == nil) then
            if (db.showCommandOutput and not db.debugEnabled) then
               mia.logger:Print('Item is not sellable. Ignoring marking.');
            end

            return ;
         elseif (not frame.markedJunkOverlay) then
            self:updateMarkedOverlay(
               MIA_Constants.overlayStatus.MISSING, bagIndex, db.overlayColor, db,
               frame, frameID, itemName, itemID
            );

            self:updateMarkedBorder(frame.markedJunkOverlay, db.borderThickness, db.borderColor);

            if (db.autoSortMarking) then
               self:sortBags();
            end

            return ;
         elseif (not frame.markedJunkOverlay:IsShown()) then
            self:updateMarkedOverlay(
               MIA_Constants.overlayStatus.HIDDEN, bagIndex, db.overlayColor, db,
               frame, frameID, itemName, itemID
            );

            self:updateMarkedBorder(frame.markedJunkOverlay, db.borderThickness, db.borderColor);

            if (db.autoSortMarking) then
               self:sortBags();
            end

            return ;
         else
            self:updateMarkedOverlay(
               MIA_Constants.overlayStatus.SHOWING, bagIndex, db.overlayColor, db,
               frame, frameID, itemName, itemID
            );

            self:updateMarkedBorder(frame.markedJunkOverlay, 0, MIA_Constants.colorReset);

            if (db.autoSortUnmarking) then
               self:sortBags();
            end

            return ;
         end
      else
         mia.logger:Debug('Add-on key combo was not pressed. Ignoring click event listener.');
         return ;
      end
   end
end

function Utils:capitalize(str)
   local lower = string.lower(str);
   return (lower:gsub("^%l", string.upper));
end

function Utils:isItemLockKeyCombo(button, config)
   local ilModKey = self:capitalize(config:GetClickBindModifier());
   local modKeyIsPressed = self:getModifierFunction(ilModKey);
   return button == config:GetClickBindButton() and modKeyIsPressed();
end

function Utils:isMiaKeyCombo(button)
   local db = mia.db.profile;
   local modKeyIsPressed = self:getModifierFunction(db.userSelectedModKey);
   return button == db.userSelectedActivatorKey and modKeyIsPressed();
end

function Utils:registerClickListeners()
   for bagIndex = 0, MIA_Constants.numContainers, 1 do
      local bagName = _G["ContainerFrame" .. bagIndex + 1]:GetName();
      local numSlots = C_Container.GetContainerNumSlots(bagIndex);

      if (numSlots > 0) then
         for slotIndex = 1, numSlots, 1 do
            local slotFrame = _G[bagName .. 'Item' .. slotIndex];
            slotFrame:HookScript('OnClick', self:handleOnClick(bagIndex, bagName, slotFrame, numSlots));
         end
      else
         mia.logger:Debug('Container at bag index "' .. tostring(bagIndex) .. '" appears to be empty. Skipping.');
      end
   end
end

function Utils:sortBags()
   if (IsAddOnLoaded('Baggins')) then
      mia.logger:Print(MIA_Constants.warnings.bagginsLoaded);
      return ;
   elseif (C_Container) then
      C_Container.SortBags();
      return ;
   else
      local sortButton = _G[BagItemAutoSortButton:GetName()];
      sortButton:Click();
      return ;
   end
end

function Utils:updateBagMarkings()
   local db = mia.db.profile;
   mia.logger:Debug('UPDATING BAG MARKINGS. Beginning iteration...');

   for bagIndex = 0, MIA_Constants.numContainers, 1 do
      local bagName = _G["ContainerFrame" .. bagIndex + 1]:GetName();
      local numSlots = C_Container.GetContainerNumSlots(bagIndex);
      local isBagOpen = IsBagOpen(bagIndex);
      local wasBagOpened = false;

      mia.logger:Debug('Processing Bag Number: ' .. tostring(bagIndex) .. '\n' ..
         'bagName = ' .. tostring(bagName) .. '\n' ..
         'numSlots = ' .. tostring(numSlots) .. '\n' ..
         'isBagOpen = ' .. tostring(isBagOpen)
      );

      -- The bags need to be open, or at least to have been opened, so that the `itemID`'s show up
      -- This mostly just covers when a reload or initial game login occurs
      -- and the location value has been changed before the bags have been opened
      if (not isBagOpen) then
         OpenBag(bagIndex);
         wasBagOpened = true;
      end

      for slotIndex = 1, numSlots, 1 do
         local slotFrame = _G[bagName .. 'Item' .. slotIndex];
         local slotFrameID = slotFrame:GetID();
         local item = Item:CreateFromBagAndSlot(bagIndex, slotFrame:GetID());
         local itemName = item:GetItemName();
         local itemID = item:GetItemID();
         local isItemEmpty = item:IsItemEmpty();

         if (itemID ~= nil) then
            mia.logger:Debug('Processing Item & Slot Frame:\n' ..
               'item = ' .. tostring(item) .. '\n' ..
               'itemName = ' .. tostring(itemName) .. '\n' ..
               'itemID = ' .. tostring(itemID) .. '\n' ..
               'isItemEmpty = ' .. tostring(isItemEmpty) .. '\n' ..
               'slotIndex = ' .. tostring(slotIndex) .. '\n' ..
               'slotFrameID = ' .. tostring(slotFrameID)
            );

            local isItemMarked = db.markedItems[itemID];

            if (isItemMarked) then
               local overlayStatus = '';

               if (not slotFrame.markedJunkOverlay) then
                  -- This should just be for when we login/reload and we need to re-apply the MIA overlays
                  overlayStatus = MIA_Constants.overlayStatus.MISSING;
               elseif (slotFrame.markedJunkOverlay:IsShown()) then
                  -- This should just be for when we need to update the overlays visually
                  -- because the user has been been logged in/reloaded for a while
                  -- and has interacted with the bags already
                  overlayStatus = MIA_Constants.overlayStatus.UPDATE;
               else
                  -- This re-shows the overlay after moving an item back to a previous spot
                  overlayStatus = MIA_Constants.overlayStatus.HIDDEN;
               end

               mia.logger:Debug('Item is marked. Updating marking for:\n' ..
                  'itemName = ' .. tostring(itemName) .. '\n' ..
                  'itemID = ' .. tostring(itemID) .. '\n' ..
                  'markerIconLocation = ' .. tostring(db.markerIconLocationSelected) .. '\n' ..
                  'overlayStatus = ' .. tostring(overlayStatus)
               );

               self:updateMarkedOverlay(
                  overlayStatus, bagIndex, db.overlayColor, db,
                  slotFrame, slotFrameID, itemName, itemID
               );

               self:updateMarkedBorder(slotFrame.markedJunkOverlay, db.borderThickness, db.borderColor);
            end
         elseif (slotFrame.markedJunkOverlay and slotFrame.markedJunkOverlay:IsShown()) then
            -- Clearing the still showing bag slot's overlay because it is empty,
            -- or it has been emptied by moving the item
            self:updateMarkedOverlay(
               MIA_Constants.overlayStatus.SHOWING, bagIndex, MIA_Constants.colorReset, db,
               slotFrame, slotFrameID, itemName, itemID
            );

            self:updateMarkedBorder(slotFrame.markedJunkOverlay, 0, MIA_Constants.colorReset);
         end
      end

      -- Closing the bags opened by MIA and leaving the user opened bags alone
      if (wasBagOpened) then
         CloseBag(bagIndex);
      end
   end
end

function Utils:updateMarkedBorder(frame, thickness, color)
   if (not frame.border) then
      frame.border = {};
   end

   local borderOffset = thickness / 2;

   for i = 0, 3, 1 do
      if (not frame.border[i]) then
         frame.border[i] = frame:CreateLine(nil, 'BACKGROUND', nil, 0);
      end

      frame.border[i]:SetColorTexture(color.r, color.g, color.b, color.a);
      frame.border[i]:SetThickness(thickness);

      if i == 0 then
         frame.border[i]:SetStartPoint('TOPLEFT', -borderOffset, 0);
         frame.border[i]:SetEndPoint('TOPRIGHT', borderOffset, 0);
      elseif i == 1 then
         frame.border[i]:SetStartPoint('TOPRIGHT', 0, borderOffset);
         frame.border[i]:SetEndPoint('BOTTOMRIGHT', 0, -borderOffset);
      elseif i == 2 then
         frame.border[i]:SetStartPoint('BOTTOMRIGHT', borderOffset, 0);
         frame.border[i]:SetEndPoint('BOTTOMLEFT', -borderOffset, 0);
      else
         frame.border[i]:SetStartPoint('BOTTOMLEFT', 0, -borderOffset);
         frame.border[i]:SetEndPoint('TOPLEFT', 0, borderOffset);
      end
   end
end

function Utils:updateMarkedOverlay(status, bagIndex, color, db, frame, frameID, itemName, itemID)
   local isMissingHiddenOrUpdate = status == MIA_Constants.overlayStatus.MISSING or
      status == MIA_Constants.overlayStatus.HIDDEN or
      status == MIA_Constants.overlayStatus.UPDATE;

   if (isMissingHiddenOrUpdate) then
      if (db.showCommandOutput and not db.debugEnabled) then
         mia.logger:Print('Marking "' .. tostring(itemName) .. '" as junk.');
      end

      local iconPath = MIA_Constants.iconPathMap[db.markerIconSelected];
      local position = MIA_Constants.iconLocationsMap[db.markerIconLocationSelected];

      if (status == MIA_Constants.overlayStatus.MISSING) then
         frame.markedJunkOverlay = CreateFrame("FRAME", nil, frame, "BackdropTemplate");
         frame.markedJunkOverlay:SetSize(frame:GetSize());
         frame.markedJunkOverlay:SetPoint("CENTER");

         frame.markedJunkOverlay:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background"
         });

         if (not frame.markedJunkOverlay.texture) then
            mia.logger:Debug('Adding a frame overlay texture to "' .. tostring(itemName) .. '"...\n' ..
               'position = ' .. position .. '\n' ..
               'iconPath = ' .. iconPath
            );

            frame.markedJunkOverlay.texture = frame.markedJunkOverlay:CreateTexture(nil, 'OVERLAY');
            frame.markedJunkOverlay.texture:ClearAllPoints();
            frame.markedJunkOverlay.texture:SetTexture(iconPath);
            frame.markedJunkOverlay.texture:SetPoint(position);
            frame.markedJunkOverlay.texture:SetSize(20, 20);
         end
      end

      frame.markedJunkOverlay:SetFrameLevel(17);
      frame.markedJunkOverlay:SetBackdropColor(color.r, color.g, color.b, color.a);
      local isHiddenOrUpdate = status == MIA_Constants.overlayStatus.HIDDEN or status == MIA_Constants.overlayStatus.UPDATE;

      if (isHiddenOrUpdate) then
         mia.logger:Debug('Updating the frame overlay texture for "' .. tostring(itemName) .. '"...\n' ..
            'position = ' .. position .. '\n' ..
            'iconPath = ' .. iconPath
         );

         -- `ClearAllPoints` will clear the previous location before setting a/the new one
         -- Not using `ClearAllPoints` will make the icon image stretch all over the place
         frame.markedJunkOverlay.texture:ClearAllPoints();
         frame.markedJunkOverlay.texture:SetTexture(iconPath);
         frame.markedJunkOverlay.texture:SetPoint(position);
         frame.markedJunkOverlay:Show();
         frame.markedJunkOverlay.texture:Show();
      end

      db.markedItems[itemID] = true;
      return ;
   end

   if (status == MIA_Constants.overlayStatus.SHOWING) then
      if (db.showCommandOutput and not db.debugEnabled) then
         mia.logger:Print('Removing the junk marking from "' .. tostring(itemName) .. '".');
      end

      mia.logger:Debug('Clearing the overlay:\n' ..
         'bag = ' .. tostring(bagIndex) .. '\n' ..
         'frame = ' .. tostring(frameID)
      );

      frame.markedJunkOverlay:SetFrameLevel(0);
      frame.markedJunkOverlay:SetBackdropColor(0, 0, 0, 0);
      frame.markedJunkOverlay:Hide();
      frame.markedJunkOverlay.texture:Hide();

      if (itemID) then
         db.markedItems[itemID] = false;
      end

      return ;
   end
end

--## --------------------------------------------------------------------------
--## DATABASE OPERATION FUNCTIONS
--## --------------------------------------------------------------------------
function Utils:getDbValue(key)
   local value = mia.db.profile[key];
   mia.logger:Debug('getDbValue: Returning "' .. tostring(value) .. '" for "' .. tostring(key) .. '".');
   return value;
end

function Utils:setDbValue(key, value)
   mia.logger:Debug('setDbValue: Setting "' .. tostring(key) .. '" to "' .. tostring(value) .. '".');
   mia.db.profile[key] = value;
end
