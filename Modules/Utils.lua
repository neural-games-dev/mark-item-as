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
local itemLockConfig;

if (IsAddOnLoaded('ItemLock')) then
   itemLock = LibStub('AceAddon-3.0'):GetAddon('ItemLock');

   if (itemLock) then
      itemLockConfig = itemLock:GetModule('Config');
   end
end

--## ===============================================================================================
--## DEFINING ALL CUSTOM UTILS TO BE USED THROUGHOUT THE ADDON
--## ===============================================================================================
function Utils:AddLeadingZero(number)
   if (number < 10) then
      return '0' .. tostring(number);
   end

   return number;
end

function Utils:Capitalize(str)
   local lower = string.lower(str);
   return (lower:gsub("^%l", string.upper));
end

function Utils:DedupeList(list)
   local hash = {};
   local result = {};

   for _, val in ipairs(list) do
      if (not hash[val]) then
         result[#result + 1] = val;
         hash[val] = true;
      end
   end

   return result;
end

function Utils:GetModifierFunction(modKey)
   return MIA_Constants.modFunctionsMap[modKey];
end

function Utils:GetSellableItemsLength(table)
   local length = 0;

   for k, v in pairs(table) do
      if (v) then
         mia.logger:Debug('GetSellableItemsLength: Counting "' ..
            tostring(k) .. ': ' .. tostring(v) .. '" as part of the table length.');
         length = length + 1;
      end
   end

   return length;
end

function Utils:HandleConfigOptionsDisplay()
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

function Utils:HandleOnClick(bagIndex, bagName, slotFrame, numSlots)
   -- "down" is a boolean that tells me that the current `button` is pressed?
   return function(frame, button, down)
      local db = mia.db.profile;
      -- NOTE **[G]** :: CLEAN UP: Can this `slotFrame` below be replaced by the `frame` from the returned handler instead?
      local item = Item:CreateFromBagAndSlot(bagIndex, slotFrame:GetID());
      local itemID = item:GetItemID();
      local itemName = item:GetItemName();
      local frameID = frame:GetID();
      local itemSellPrice;

      if (itemName) then
         itemSellPrice = self:SelectRespValue(11, itemName);
      else
         itemSellPrice = 'N/A';
      end

      --## ==========================================================================
      --## Handling "ItemLock" addon key bind actions & conflicts
      --## ==========================================================================
      if (itemLockConfig and itemLockConfig:IsClickBindEnabled()) then
         local isItemLockKeyCombo = self:IsItemLockKeyCombo(button, itemLockConfig);
         mia.logger:Debug('Was ItemLock key combo pressed? -> ' .. tostring(isItemLockKeyCombo));

         if (isItemLockKeyCombo and self:IsMiaKeyCombo(button)) then
            if (db.showWarnings) then
               mia.logger:Print(MIA_Constants.warnings.itemLockConflict);
            end

            return;
         elseif (isItemLockKeyCombo and frame.markedJunkOverlay and frame.markedJunkOverlay:IsShown()) then
            if (db.showWarnings) then
               mia.logger:Print(MIA_Constants.warnings.itemLockDoubledUp);
            end

            return;
         end
      end

      mia.logger:DebugClickInfo(
         bagIndex, bagName, button, down, frame, frameID,
         item, itemID, itemSellPrice, numSlots, slotFrame
      );

      --## ==========================================================================
      --## Handling "MarkItemAs" key bind actions
      --## ==========================================================================
      if (self:IsMiaKeyCombo(button)) then
         if (item:IsItemEmpty()) then
            mia.logger:Debug('HandleOnClick: Processing item is empty scenario...');

            if (db.showCommandOutput and not db.debugEnabled) then
               local suffix = 'from the Alliance.';

               if (db.playerInfo.factionGroup == 'Alliance') then
                  suffix = 'from the Horde.';
               end

               if (db.playerInfo.factionGroup == 'Neutral') then
                  suffix = 'a Monk.';
               end

               mia.logger:Print("There's nothing to mark! You must be " .. suffix);
            end

            return;
         elseif (self:GetDbValue('isLoaded.itemLock') and frame.lockItemsAppearanceOverlay.texture:IsShown()) then
            mia.logger:Debug('HandleOnClick: Processing item is locked scenario...');

            if (db.showCommandOutput and not db.debugEnabled) then
               mia.logger:Print('Item is locked. Ignoring marking.');
            end

            return;
         elseif (itemSellPrice == 0 or itemSellPrice == nil) then
            mia.logger:Debug('HandleOnClick: Processing item is NOT sellable scenario...');

            if (db.showCommandOutput and not db.debugEnabled) then
               mia.logger:Print('Item is not sellable. Ignoring marking.');
            end

            return;
         elseif (not frame.markedJunkOverlay) then
            mia.logger:Debug('HandleOnClick: Processing `overlayStatus.MISSING` scenario...');
            mia.utils:SetDbTableItem('junkItems', itemID, true);
            self:UpdateBagMarkings(true); -- `true` = isClickEvent

            if (db.autoSortMarking and not self:GetDbValue('isLoaded.baggins')) then
               self:SortBags();
            end

            return;
         elseif (not frame.markedJunkOverlay:IsShown()) then
            mia.logger:Debug('HandleOnClick: Processing `overlayStatus.HIDDEN` scenario...');
            mia.utils:SetDbTableItem('junkItems', itemID, true);
            self:UpdateBagMarkings(true); -- `true` = isClickEvent

            if (db.autoSortMarking and not self:GetDbValue('isLoaded.baggins')) then
               self:SortBags();
            end

            return;
         else
            mia.logger:Debug('HandleOnClick: Processing `overlayStatus.SHOWING` scenario...');
            mia.utils:SetDbTableItem('junkItems', itemID, false);
            self:UpdateBagMarkings(true); -- `true` = isClickEvent

            if (db.autoSortUnmarking and not self:GetDbValue('isLoaded.baggins')) then
               self:SortBags();
            end

            return;
         end
      else
         mia.logger:Debug('Add-on key combo was not pressed. Ignoring click event listener.');
         return;
      end
   end
end

function Utils:IsItemLockKeyCombo(button, config)
   local ilModKey = self:Capitalize(config:GetClickBindModifier());
   local modKeyIsPressed = self:GetModifierFunction(ilModKey);
   return button == config:GetClickBindButton() and modKeyIsPressed();
end

function Utils:IsMiaKeyCombo(button)
   local db = mia.db.profile;
   local modKeyIsPressed = self:GetModifierFunction(db.userSelectedModKey);
   return button == db.userSelectedActivatorKey and modKeyIsPressed();
end

function Utils:PriceToGold(price)
   local gold = price / 10000;
   local silver = (price % 10000) / 100;
   local copper = (price % 10000) % 100;

   gold = math.floor(gold);
   silver = math.floor(silver);
   copper = math.floor(copper);

   local goldPadded = self:AddLeadingZero(gold);
   local silverPadded = self:AddLeadingZero(silver);
   local copperPadded = self:AddLeadingZero(copper);

   return goldPadded ..
       '|cFFffcc33g|r ' .. silverPadded .. '|cFFc9c9c9s|r ' .. copperPadded .. '|cFFcc8890c|r';
end

function Utils:RegisterClickListeners()
   for bagIndex = 0, MIA_Constants.numContainers, 1 do
      local bagName = _G["ContainerFrame" .. bagIndex + 1]:GetName();
      local numSlots = C_Container.GetContainerNumSlots(bagIndex);

      if (numSlots > 0) then
         for slotIndex = 1, numSlots, 1 do
            local slotIndexInverted = numSlots - slotIndex + 1; -- Blizz bag slot indexes are weird
            local slotFrame = _G[bagName .. 'Item' .. slotIndexInverted];
            slotFrame:HookScript('OnClick', self:HandleOnClick(bagIndex, bagName, slotFrame, numSlots));
         end
      else
         mia.logger:Debug('Container at bag index "' .. tostring(bagIndex) .. '" appears to be empty. Skipping.');
      end
   end
end

function Utils:SelectRespValue(position, itemName)
   return select(position, GetItemInfo(itemName));
end

function Utils:SortBags()
   if (C_Container) then
      C_Container.SortBags();
      return;
   else
      local sortButton = _G[BagItemAutoSortButton:GetName()];
      sortButton:Click();
      return;
   end
end

function Utils:UpdateBagMarkings(isClickEvent)
   local db = mia.db.profile;
   mia.logger:Debug('UPDATING BAG MARKINGS. Beginning iteration...');
   local numMarkedActions = 0;

   for bagIndex = 0, MIA_Constants.numContainers, 1 do
      local bagName = _G["ContainerFrame" .. bagIndex + 1]:GetName();
      local numSlots = C_Container.GetContainerNumSlots(bagIndex);
      local isBagOpen = IsBagOpen(bagIndex);
      local wasBagOpened = false;

      mia.logger:Debug('——————————————————————————————————————————');
      mia.logger:Debug('Processing Bag Number: ' .. tostring(bagIndex));
      mia.logger:Debug('——————————————————————————————————————————');
      mia.logger:Debug('bagName = ' .. tostring(bagName) .. '\n' ..
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
         local slotIndexInverted = numSlots - slotIndex + 1; -- Blizz bag slot indexes are weird
         local slotFrame = _G[bagName .. 'Item' .. slotIndexInverted];
         local slotFrameID = slotFrame:GetID();
         local item = Item:CreateFromBagAndSlot(bagIndex, slotFrameID);
         local itemName = item:GetItemName();
         local itemID = item:GetItemID();
         local isItemEmpty = item:IsItemEmpty();
         local shouldLogMarkingAction = isClickEvent and numMarkedActions == 1;

         if (itemID ~= nil) then
            mia.logger:Debug('Processing Item & Slot Frame:\n' ..
               'item = ' .. tostring(item) .. '\n' ..
               'itemName = ' .. tostring(itemName) .. '\n' ..
               'itemID = ' .. tostring(itemID) .. '\n' ..
               'isItemEmpty = ' .. tostring(isItemEmpty) .. '\n' ..
               'slotIndex = ' .. tostring(slotIndex) .. '\n' ..
               'slotIndexInverted = ' .. tostring(slotIndexInverted) .. '\n' ..
               'slotFrameID = ' .. tostring(slotFrameID)
            );

            local isItemMarkedJunk = db.junkItems[itemID];
            local overlayStatus = '';

            if (isItemMarkedJunk) then
               if (not slotFrame.markedJunkOverlay) then
                  -- This should just be for when we login/reload and we need to re-apply the MIA overlays
                  overlayStatus = MIA_Constants.overlayStatus.MISSING;
               elseif (slotFrame.markedJunkOverlay:IsShown()) then
                  -- OLD COMMENT:
                  -- This should just be for when we need to update the overlays visually
                  -- because the user has been been logged in/reloaded for a while
                  -- and has interacted with the bags already
                  -- NEW COMMENT:
                  -- This status is for re-showing the overlay when the user moves a marked item
                  overlayStatus = MIA_Constants.overlayStatus.UPDATE;
               else
                  -- This re-shows the overlay after moving an item back to a previous spot
                  overlayStatus = MIA_Constants.overlayStatus.HIDDEN;
               end

               numMarkedActions = numMarkedActions + 1;

               mia.logger:Debug('Item is marked. Updating marking for:\n' ..
                  'itemName = ' .. tostring(itemName) .. '\n' ..
                  'itemID = ' .. tostring(itemID) .. '\n' ..
                  'markerIconLocation = ' .. tostring(db.markerIconLocationSelected) .. '\n' ..
                  'numMarkedActions = ' .. tostring(numMarkedActions) .. '\n' ..
                  'overlayStatus = ' .. tostring(overlayStatus)
               );

               self:UpdateMarkedOverlay(
                  overlayStatus, bagIndex, db.overlayColor, db,
                  slotFrame, slotFrameID, itemName, itemID, shouldLogMarkingAction
               );

               self:UpdateMarkedBorder(slotFrame.markedJunkOverlay, db.borderThickness, db.borderColor);
            elseif (slotFrame.markedJunkOverlay and slotFrame.markedJunkOverlay:IsShown()) then
               numMarkedActions = numMarkedActions + 1;
               -- Clearing the still showing bag slot's overlay because it was moved,
               self:UpdateMarkedOverlay(
                  MIA_Constants.overlayStatus.SHOWING, bagIndex, MIA_Constants.colorReset, db,
                  slotFrame, slotFrameID, itemName, itemID, shouldLogMarkingAction
               );

               self:UpdateMarkedBorder(slotFrame.markedJunkOverlay, 0, MIA_Constants.colorReset);
            end
         elseif (slotFrame.markedJunkOverlay and slotFrame.markedJunkOverlay:IsShown()) then
            numMarkedActions = numMarkedActions + 1;
            -- Clearing the still showing bag slot's overlay because it is empty,
            -- or it has been emptied by moving the item
            self:UpdateMarkedOverlay(
               MIA_Constants.overlayStatus.SHOWING, bagIndex, MIA_Constants.colorReset, db,
               slotFrame, slotFrameID, itemName, itemID, shouldLogMarkingAction
            );

            self:UpdateMarkedBorder(slotFrame.markedJunkOverlay, 0, MIA_Constants.colorReset);
         end
      end

      -- Closing the bags opened by MIA and leaving the user opened bags alone
      if (wasBagOpened) then
         CloseBag(bagIndex);
      end
   end
end

function Utils:UpdateMarkedBorder(frame, thickness, color)
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

function Utils:UpdateMarkedOverlay(status, bagIndex, color, db, frame, frameID, itemName, itemID, shouldLogMarkingAction)
   local isMissingHiddenOrUpdate = status == MIA_Constants.overlayStatus.MISSING or
       status == MIA_Constants.overlayStatus.HIDDEN or
       status == MIA_Constants.overlayStatus.UPDATE;

   if (isMissingHiddenOrUpdate) then
      if (db.showCommandOutput and not db.debugEnabled and shouldLogMarkingAction) then
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
               'iconPath = ' .. tostring(iconPath) .. '\n' ..
               'position = ' .. tostring(position) .. '\n' ..
               'status = ' .. tostring(status)
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
      local isHiddenOrUpdate = status == MIA_Constants.overlayStatus.HIDDEN or
          status == MIA_Constants.overlayStatus.UPDATE;

      if (isHiddenOrUpdate) then
         mia.logger:Debug('Updating the frame overlay texture for "' .. tostring(itemName) .. '"...\n' ..
            'iconPath = ' .. tostring(iconPath) .. '\n' ..
            'position = ' .. tostring(position) .. '\n' ..
            'status = ' .. tostring(status)
         );

         -- `ClearAllPoints` will clear the previous location before setting a/the new one
         -- Not using `ClearAllPoints` will make the icon image stretch all over the place
         frame.markedJunkOverlay.texture:ClearAllPoints();
         frame.markedJunkOverlay.texture:SetTexture(iconPath);
         frame.markedJunkOverlay.texture:SetPoint(position);
         frame.markedJunkOverlay:Show();
         frame.markedJunkOverlay.texture:Show();
      end

      db.junkItems[itemID] = true;
      return;
   end

   if (status == MIA_Constants.overlayStatus.SHOWING) then
      if (db.showCommandOutput and not db.debugEnabled and shouldLogMarkingAction) then
         mia.logger:Print('Removing the junk marking from "' .. tostring(itemName) .. '".');
      end

      mia.logger:Debug('Clearing the overlay:\n' ..
         'bag = ' .. tostring(bagIndex) .. '\n' ..
         'frame = ' .. tostring(frameID) .. '\n' ..
         'status = ' .. tostring(status)
      );

      frame.markedJunkOverlay:SetFrameLevel(0);
      frame.markedJunkOverlay:SetBackdropColor(0, 0, 0, 0);
      frame.markedJunkOverlay:Hide();
      frame.markedJunkOverlay.texture:Hide();

      if (itemID) then
         db.junkItems[itemID] = false;
      end

      return;
   end
end

--## --------------------------------------------------------------------------
--## DATABASE OPERATION FUNCTIONS
--## --------------------------------------------------------------------------
function Utils:GetDbValue(key)
   local value;
   local isMultiKey = key:match('%.');

   if (isMultiKey) then
      local key1, key2 = string.match(key, '(.*)%.(.*)');
      value = mia.db.profile[key1][key2];
   else
      value = mia.db.profile[key];
   end

   if (mia.db.profile.enableVerboseLogging) then
      mia.logger:Debug('GetDbValue: Returning "' .. tostring(value) .. '" for "' .. tostring(key) .. '".');
   end

   return value;
end

function Utils:SetDbTableItem(table, key, value)
   if (mia.db.profile.enableVerboseLogging) then
      mia.logger:Debug('SetDbTableItem: Setting "' ..
         tostring(key) .. '" to "' .. tostring(value) .. '" in table "' .. tostring(table) .. '".');
   end

   mia.db.profile[table][key] = value;
end

function Utils:SetDbValue(key, value)
   if (mia.db.profile.enableVerboseLogging) then
      mia.logger:Debug('SetDbValue: Setting "' .. tostring(key) .. '" to "' .. tostring(value) .. '".');
   end

   mia.db.profile[key] = value;
end
