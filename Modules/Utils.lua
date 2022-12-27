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
      -- CLEAN UP: Can this `slotFrame` below be replaced by the `frame` from the returned handler instead?
      local item = Item:CreateFromBagAndSlot(bagIndex, slotFrame:GetID());
      local itemID = item:GetItemID();
      local itemName = item:GetItemName();
      local frameID = frame:GetID();

      maj.logger:DebugClickInfo(
         bagIndex, bagName, button, down, frame,
         frameID, item, itemID, numSlots, slotFrame
      );

      if (self:isMajKeyCombo(button)) then
         if (item:IsItemEmpty()) then
            -- ☝ use `frame.hasItem` instead?
            if (db.showCommandOutput and not db.debugEnabled) then
               maj.logger:Print('No item present. Ignoring.');
            end

            return ;
         elseif (IsAddOnLoaded('ItemLock') and frame.lockItemsAppearanceOverlay.texture:IsShown()) then
            -- TODO **[G]** :: Add another condition above this to check if item is sellable or not -- DO THIS ON `selling` PR/BRANCH
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
         maj.logger:Debug('Add-on key combo was not pressed. Ignoring click event listener.');
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
            local slotFrame = _G[bagName .. 'Item' .. slotIndex];
            slotFrame:HookScript('OnClick', self:handleOnClick(bagIndex, bagName, slotFrame, numSlots));
         end
      else
         maj.logger:Debug('Container at bag index "' .. tostring(bagIndex) .. '" appears to be empty. Skipping.');
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

function Utils:updateBagMarkings()
   local db = maj.db.profile;
   maj.logger:Debug('UPDATING BAG MARKINGS. Beginning iteration...');

   for bagIndex = 0, MAJ_Constants.numContainers, 1 do
      local bagName = _G["ContainerFrame" .. bagIndex + 1]:GetName();
      local numSlots = C_Container.GetContainerNumSlots(bagIndex);
      local isBagOpen = IsBagOpen(bagIndex);
      local wasBagOpened = false;

      maj.logger:Debug('Processing Bag Number: ' .. tostring(bagIndex) .. '\n' ..
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
            maj.logger:Debug('Processing Item & Slot Frame:\n' ..
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
                  -- This should just be for when we login/reload and we need to re-apply the MAJ overlays
                  overlayStatus = 'overlayMissing';
               elseif (slotFrame.markedJunkOverlay:IsShown()) then
                  -- This should just be for when we need to update the overlays visually
                  -- because the user has been been logged in/reloaded for a while
                  -- and has interacted with the bags already
                  overlayStatus = 'updateOverlay';
               end

               maj.logger:Debug('Item is marked. Updating marking for:\n' ..
                  'itemName = ' .. tostring(itemName) .. '\n' ..
                  'itemID = ' .. tostring(itemID) .. '\n' ..
                  'markerIconLocation = ' .. tostring(db.markerIconLocationSelected) .. '\n' ..
                  'overlayStatus = ' .. tostring(overlayStatus)
               );

               self:updateMarkedJunkOverlay(
                  overlayStatus, bagIndex, db.overlayColor, db,
                  slotFrame, slotFrameID, itemName, itemID
               );
            end
         elseif (slotFrame.markedJunkOverlay and slotFrame.markedJunkOverlay:IsShown()) then
            -- Clearing the still showing bag slot's overlay because it is empty,
            -- or it has been emptied by moving the item
            self:updateMarkedJunkOverlay(
               'overlayShowing', bagIndex, { r = 0, g = 0, b = 0, a = 0 }, db,
               slotFrame, slotFrameID, itemName, itemID
            );
         end
      end

      -- Closing the bags opened by MAJ and leaving the user opened bags alone
      if (wasBagOpened) then
         CloseBag(bagIndex);
      end
   end
end

function Utils:updateMarkedJunkOverlay(status, bagIndex, color, db, frame, frameID, itemName, itemID)
   if (status == 'overlayMissing' or status == 'overlayHidden' or status == 'updateOverlay') then
      if (db.showCommandOutput and not db.debugEnabled) then
         maj.logger:Print('Marking "' .. tostring(itemName) .. '" as junk.');
      end

      local iconPath = MAJ_Constants.iconPathMap[db.markerIconSelected];
      local position = MAJ_Constants.iconLocationsMap[db.markerIconLocationSelected];

      if (status == 'overlayMissing') then
         frame.markedJunkOverlay = CreateFrame("FRAME", nil, frame, "BackdropTemplate");
         frame.markedJunkOverlay:SetSize(frame:GetSize());
         frame.markedJunkOverlay:SetPoint("CENTER");

         frame.markedJunkOverlay:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background"
         });

         if (not frame.markedJunkOverlay.texture) then
            maj.logger:Debug('Adding a frame overlay texture to "' .. tostring(itemName) .. '"...\n' ..
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

      if (status == 'overlayHidden' or status == 'updateOverlay') then
         maj.logger:Debug('Updating the frame overlay texture for "' .. tostring(itemName) .. '"...\n' ..
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

   if (status == 'overlayShowing') then
      if (db.showCommandOutput and not db.debugEnabled) then
         maj.logger:Print('Removing the junk marking from "' .. tostring(itemName) .. '".');
      end

      if (db.debugEnabled) then
         local overlayHexID = tostring(frame.markedJunkOverlay):gsub("table: ", "", 1);

         maj.logger:Debug('Clearing the overlay:\n' ..
            'bag = ' .. tostring(bagIndex) .. '\n' ..
            'frame = ' .. tostring(frameID) .. '\n' ..
            'overlayHexID = ' .. overlayHexID
         );
      end

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
   return maj.db.profile[key];
end

function Utils:setDbValue(key, value)
   maj.db.profile[key] = value;
end
