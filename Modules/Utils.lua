-- TODO **[G]** :: 🚀--BLLR?: BREAK THIS UP INTO SMALLER FILES!!!!!
--## ===============================================================================================
--## ALL REQUIRED IMPORTS
--## ===============================================================================================
-- Libs / Packages
local dialog = LibStub("AceConfigDialog-3.0")
local mia = LibStub("AceAddon-3.0"):GetAddon("MarkItemAs")

--## ===============================================================================================
--## INTERNAL VARS & SET UP
--## ===============================================================================================
local Utils = mia:NewModule("Utils")
local itemLock
local itemLockConfig

if C_AddOns.IsAddOnLoaded("ItemLock") then
   itemLock = LibStub("AceAddon-3.0"):GetAddon("ItemLock")

   if itemLock then
      itemLockConfig = itemLock:GetModule("Config")
   end
end

--## ===============================================================================================
--## DEFINING ALL CUSTOM UTILS TO BE USED THROUGHOUT THE ADDON
--## ===============================================================================================
function Utils:Capitalize(str)
   local lower = string.lower(str)
   return (lower:gsub("^%l", string.upper))
end

function Utils:DedupeList(list)
   local hash = {}
   local result = {}

   for _, val in ipairs(list) do
      if not hash[val] then
         result[#result + 1] = val
         hash[val] = true
      end
   end

   return result
end

function Utils:GetModifierFunction(modKey)
   return MIA_Constants.modFunctionsMap[modKey]
end

function Utils:GetNumSellableItems(table)
   local length = 0

   for k, v in pairs(table) do
      if v then
         mia.logger:Debug(
            'GetNumSellableItems: Counting "'
               .. tostring(k)
               .. ": "
               .. tostring(v)
               .. '" as part of the table length.'
         )
         length = length + 1
      end
   end

   return length
end

function Utils:HandleConfigOptionsDisplay()
   local db = mia.db.profile

   if dialog.OpenFrames["MarkItemAs"] then
      if db.showCommandOutput then
         mia.logger:Print("Hiding the config options window.")
      end

      dialog:Close("MarkItemAs")
   else
      if db.showCommandOutput then
         mia.logger:Print("Showing the config options window.")
      end

      dialog:Open("MarkItemAs")
   end
end

function Utils:HandleOnClick(bagIndex, bagName, slotFrame, numSlots)
   -- "down" is a boolean that tells me that the current `button` is pressed?
   return function(frame, button, down)
      if not self:IsMiaKeyCombo(button) then
         mia.logger:Debug("Add-on key combo was not pressed. Ignoring click event listener.")
         return
      end

      local db = mia.db.profile
      -- NOTE **[G]** :: CLEAN UP: Can this `slotFrame` below be replaced by the `frame` from the returned handler instead?
      local item = Item:CreateFromBagAndSlot(bagIndex, slotFrame:GetID())
      local itemID = item:GetItemID()
      local itemName = item:GetItemName()
      local frameID = frame:GetID()
      local itemSellPrice

      if itemName then
         itemSellPrice = self:SelectRespValue(11, itemName)
      else
         itemSellPrice = "N/A"
      end

      --## ==========================================================================
      --## Handling "ItemLock" addon key bind actions & conflicts
      --## ==========================================================================
      if itemLockConfig and itemLockConfig:IsClickBindEnabled() then
         local isItemLockKeyCombo = self:IsItemLockKeyCombo(button, itemLockConfig)
         mia.logger:Debug("Was ItemLock key combo pressed? -> " .. tostring(isItemLockKeyCombo))

         if isItemLockKeyCombo and self:IsMiaKeyCombo(button) then
            if db.showWarnings then
               mia.logger:Print(MIA_Constants.warnings.itemLockConflict)
            end

            return
         elseif
            isItemLockKeyCombo
            and frame.marked_junk_overlay
            and frame.marked_junk_overlay:IsShown()
         then
            if db.showWarnings then
               mia.logger:Print(MIA_Constants.warnings.itemLockDoubledUp)
            end

            return
         end
      end

      mia.logger:DebugClickInfo(
         bagIndex,
         bagName,
         button,
         down,
         frame,
         frameID,
         item,
         itemID,
         itemSellPrice,
         numSlots,
         slotFrame
      )

      --## ==========================================================================
      --## Handling "MarkItemAs" key bind actions
      --## ==========================================================================
      if item:IsItemEmpty() then
         mia.logger:Debug("HandleOnClick: Processing item is empty scenario...")

         if db.showCommandOutput and not db.debugEnabled then
            local suffix = "from the Alliance."

            if db.playerInfo.factionGroup == "Alliance" then
               suffix = "from the Horde."
            end

            if db.playerInfo.factionGroup == "Neutral" then
               suffix = "a Monk."
            end

            mia.logger:Print("There's nothing to mark! You must be " .. suffix)
         end

         return
      elseif
         self:GetDbValue("isLoaded.itemLock") and frame.lockItemsAppearanceOverlay.texture:IsShown()
      then
         mia.logger:Debug("HandleOnClick: Processing item is locked scenario...")

         if db.showCommandOutput and not db.debugEnabled then
            mia.logger:Print("Item is locked. Ignoring marking.")
         end

         return
      elseif itemSellPrice == 0 or itemSellPrice == nil then
         mia.logger:Debug("HandleOnClick: Processing item is NOT sellable scenario...")

         if db.showCommandOutput and not db.debugEnabled then
            mia.logger:Print("Item is not sellable. Ignoring marking.")
         end

         return
      elseif not frame.marked_junk_overlay then
         mia.logger:Debug("HandleOnClick: Processing `overlayStatus.MISSING` scenario...")
         mia.utils:SetDbTableItem("junkItems", itemID, true)
         self:UpdateBagMarkings(true) -- `true` = isClickEvent

         if db.autoSortMarking and not self:GetDbValue("isLoaded.baggins") then
            self:SortBags()
         end

         return
      elseif not frame.marked_junk_overlay:IsShown() then
         mia.logger:Debug("HandleOnClick: Processing `overlayStatus.HIDDEN` scenario...")
         mia.utils:SetDbTableItem("junkItems", itemID, true)
         self:UpdateBagMarkings(true) -- `true` = isClickEvent

         if db.autoSortMarking and not self:GetDbValue("isLoaded.baggins") then
            self:SortBags()
         end

         return
      else
         mia.logger:Debug("HandleOnClick: Processing `overlayStatus.SHOWING` scenario...")
         mia.utils:SetDbTableItem("junkItems", itemID, false)
         self:UpdateBagMarkings(true) -- `true` = isClickEvent

         if db.autoSortUnmarking and not self:GetDbValue("isLoaded.baggins") then
            self:SortBags()
         end

         return
      end
   end
end

function Utils:IsItemLockKeyCombo(button, config)
   local ilModKey = self:Capitalize(config:GetClickBindModifier())
   local modKeyIsPressed = self:GetModifierFunction(ilModKey)
   return button == config:GetClickBindButton() and modKeyIsPressed()
end

function Utils:IsMiaKeyCombo(button)
   local db = mia.db.profile
   local modKeyIsPressed = self:GetModifierFunction(db.userSelectedModKey)
   return button == db.userSelectedActivatorKey and modKeyIsPressed()
end

function Utils:PadNumber(number)
   if number < 10 then
      return "0" .. tostring(number)
   end

   return number
end

function Utils:PriceToGold(price)
   local gold = price / 10000
   local silver = (price % 10000) / 100
   local copper = (price % 10000) % 100

   gold = math.floor(gold)
   silver = math.floor(silver)
   copper = math.floor(copper)

   local goldPadded = self:PadNumber(gold)
   local silverPadded = self:PadNumber(silver)
   local copperPadded = self:PadNumber(copper)

   return goldPadded
      .. "|cFFffcc33g|r "
      .. silverPadded
      .. "|cFFc9c9c9s|r "
      .. copperPadded
      .. "|cFFcc8890c|r"
end

function Utils:RegisterClickListeners()
   for bagIndex = 0, MIA_Constants.numContainers, 1 do
      local bagName = _G["ContainerFrame" .. bagIndex + 1]:GetName()
      local numSlots = C_Container.GetContainerNumSlots(bagIndex)

      if numSlots > 0 then
         for slotIndex = 1, numSlots, 1 do
            local slotIndexInverted = numSlots - slotIndex + 1 -- Blizz bag slot indexes are weird
            local slotFrame = _G[bagName .. "Item" .. slotIndexInverted]
            slotFrame:HookScript(
               "OnClick",
               self:HandleOnClick(bagIndex, bagName, slotFrame, numSlots)
            )
         end
      else
         mia.logger:Debug(
            'Container at bag index "' .. tostring(bagIndex) .. '" appears to be empty. Skipping.'
         )
      end
   end
end

function Utils:SelectRespValue(position, itemName)
   return select(position, GetItemInfo(itemName))
end

function Utils:SortBags()
   if C_Container then
      C_Container.SortBags()
      return
   else
      local sortButton = _G[BagItemAutoSortButton:GetName()]
      sortButton:Click()
      return
   end
end

---@param is_click_event boolean
function Utils:UpdateBagMarkings(is_click_event)
   local db = mia.db.profile
   local num_marked_actions = 0
   mia.logger:Debug("UPDATING BAG MARKINGS. Beginning iteration...")

   for bag_idx = 0, MIA_Constants.numContainers, 1 do
      local bag_idx_proper = bag_idx + 1
      local bag_name = _G["ContainerFrame" .. bag_idx_proper]:GetName()
      local is_bag_open = IsBagOpen(bag_idx)
      local num_slots = C_Container.GetContainerNumSlots(bag_idx)

      mia.logger:Debug("Processing Bag Number: " .. tostring(bag_idx_proper))

      mia.logger:Debug(
         "bag_name = "
            .. tostring(bag_name)
            .. "\n"
            .. "is_bag_open = "
            .. tostring(is_bag_open)
            .. "\n"
            .. "num_slots = "
            .. tostring(num_slots)
      )

      -- TODO **[G]** :: DOING THE FOLLOWING COULD BE COOL TO COLOR THE BAG BORDER IF AN ITEM HAS BEEN MARKED
      -- ContainerFrame1.NineSlice:SetBorderColor(0,1,1,1)

      for slot_idx = 1, num_slots, 1 do
         mia.logger:Debug("processing slot index: " .. tostring(slot_idx))

         local item_info = C_Container.GetContainerItemInfo(bag_idx, slot_idx)
         local should_log_marking_action = is_click_event and num_marked_actions == 1

         if item_info and not (item_info.itemID == nil) then
            mia.logger:Debug(
               "item found, processing:\n"
                  .. "item_name = "
                  .. tostring(item_info.itemName)
                  .. "\n"
                  .. "item_id = "
                  .. tostring(item_info.itemID)
                  .. "\n"
                  .. "slot_idx = "
                  .. tostring(slot_idx)
                  .. "\n"
                  .. "slot_frame_id = "
                  .. tostring(slot_frame_id or "n/a")
                  .. "\n"
                  .. "should_log_marking_action = "
                  .. tostring(should_log_marking_action or "n/a")
                  .. "\n"
            )

            local item_id_stored_in_db = db.junkItems[item_info.itemID]
            local overlay_status = ""

            if not (item_id_stored_in_db == nil) then
               mia.logger:Debug(
                  'item id "'
                     .. item_info.itemID
                     .. '" is stored in the db, checking for overlay...'
               )

               if not slotframe.marked_junk_overlay then
                  -- this should just be for when we login/reload and we need to re-apply the mia overlays
                  overlay_status = MIA_Constants.overlayStatus.MISSING
               elseif slotframe.marked_junk_overlay:isshown() then
                  -- old comment:
                  -- this should just be for when we need to update the overlays visually
                  -- because the user has been been logged in/reloaded for a while
                  -- and has interacted with the bags already
                  -- new comment:
                  -- this status is for re-showing the overlay when the user moves a marked item
                  overlay_status = MIA_Constants.overlayStatus.UPDATE
               else
                  -- this re-shows the overlay after moving an item back to a previous spot
                  overlay_status = MIA_Constants.overlayStatus.HIDDEN
               end

               num_marked_actions = num_marked_actions + 1

               mia.logger:Debug(
                  "item is marked. updating marking for:\n"
                     .. "item_name = "
                     .. tostring(item_info.itemName)
                     .. "\n"
                     .. "item_id = "
                     .. tostring(item_info.itemID)
                     .. "\n"
                     .. "markericonlocation = "
                     .. tostring(db.markericonlocationselected)
                     .. "\n"
                     .. "num_marked_actions = "
                     .. tostring(num_marked_actions)
                     .. "\n"
                     .. "overlay_status = "
                     .. tostring(overlay_status)
               )

               self:updatemarkedoverlay(
                  overlay_status,
                  bag_idx,
                  db.overlaycolor,
                  db,
                  slotframe,
                  item_info.itemName,
                  item_info.itemID,
                  should_log_marking_action
               )

               self:updatemarkedborder(
                  slotframe.marked_junk_overlay,
                  db.borderthickness,
                  db.bordercolor
               )
            elseif
               slotframe
               and slotframe.marked_junk_overlay
               and slotframe.marked_junk_overlay:isshown()
            then
               mia.logger:Debug(
                  'item id "' .. item_info.itemID .. '" is not stored in the db, adding overlay...'
               )

               num_marked_actions = num_marked_actions + 1

               -- clearing the still showing bag slot's overlay because it was moved,
               self:updatemarkedoverlay(
                  MIA_Constants.overlayStatus.SHOWING,
                  bag_idx,
                  MIA_Constants.colorreset,
                  db,
                  slotframe,
                  item_info.itemName,
                  item_info.itemID,
                  should_log_marking_action
               )

               self:updatemarkedborder(slotframe.marked_junk_overlay, 0, MIA_Constants.colorreset)
            else
               mia.logger:Debug("boo!!! nothing happened")
            end
         elseif
            slotframe
            and slotframe.marked_junk_overlay
            and slotframe.marked_junk_overlay:isshown()
         then
            mia.logger:Debug("item NOT found, slot frame was empty but overlay still exists. clearing...")
            num_marked_actions = num_marked_actions + 1
            -- clearing the still showing bag slot's overlay because it is empty,
            -- or it has been emptied by moving the item
            self:updatemarkedoverlay(
               MIA_Constants.overlayStatus.SHOWING,
               bag_idx,
               MIA_Constants.colorReset,
               db,
               slotframe,
               item_info.itemName,
               item_info.itemID,
               should_log_marking_action
            )

            self:UpdateMarkedBorder(slotframe.marked_junk_overlay, 0, MIA_Constants.colorReset)
         else
            mia.logger:Debug(
               "no item id found and slot frame was missing or did not contain an overlay, ignoring..."
            )
         end
      end
   end
end

function Utils:UpdateMarkedBorder(frame, thickness, color)
   if not frame.border then
      frame.border = {}
   end

   local borderOffset = thickness / 2

   for i = 0, 3, 1 do
      if not frame.border[i] then
         frame.border[i] = frame:CreateLine(nil, "BACKGROUND", nil, 0)
      end

      frame.border[i]:SetColorTexture(color.r, color.g, color.b, color.a)
      frame.border[i]:SetThickness(thickness)

      if i == 0 then
         frame.border[i]:SetStartPoint("TOPLEFT", -borderOffset, 0)
         frame.border[i]:SetEndPoint("TOPRIGHT", borderOffset, 0)
      elseif i == 1 then
         frame.border[i]:SetStartPoint("TOPRIGHT", 0, borderOffset)
         frame.border[i]:SetEndPoint("BOTTOMRIGHT", 0, -borderOffset)
      elseif i == 2 then
         frame.border[i]:SetStartPoint("BOTTOMRIGHT", borderOffset, 0)
         frame.border[i]:SetEndPoint("BOTTOMLEFT", -borderOffset, 0)
      else
         frame.border[i]:SetStartPoint("BOTTOMLEFT", 0, -borderOffset)
         frame.border[i]:SetEndPoint("TOPLEFT", 0, borderOffset)
      end
   end
end

function Utils:UpdateMarkedOverlay(
   status,
   bagIndex,
   color,
   db,
   frame,
   itemName,
   itemID,
   shouldLogMarkingAction
)
   local isMissingHiddenOrUpdate = status == MIA_Constants.overlayStatus.MISSING
      or status == MIA_Constants.overlayStatus.HIDDEN
      or status == MIA_Constants.overlayStatus.UPDATE

   if isMissingHiddenOrUpdate then
      if db.showCommandOutput and not db.debugEnabled and shouldLogMarkingAction then
         mia.logger:Print('Marking "' .. tostring(itemName) .. '" as junk.')
      end

      local iconPath = MIA_Constants.iconPathMap[db.markerIconSelected]
      local position = MIA_Constants.iconLocationsMap[db.markerIconLocationSelected]

      if not frame then
         print("BLLR? -- FRAME DOES NOT EXIST")
      else
         print("BLLR? -- FRAME DOES EXIST")
         -- mia.dump:print(frame);
         print(mia.inspecty:dump(frame:GetParent()))
      end

      -- if not frame.GetObjectType then
      --    print("BLLR? -- FRAME DOES NOT HAVE A GetObjectType METHOD")
      -- else
      --    print("BLLR? -- FRAME HAS AN OBJECT TYPE: " .. frame:GetObjectType())
      -- end

      -- if not frame.GetTexture then
      --    print("BLLR? -- FRAME DOES NOT HAVE A GetTexture METHOD")
      -- else
      --    print("BLLR? -- FRAME DOES HAVE A TEXTURE: " .. frame:GetTexture())
      -- end

      -- if not frame.GetID then
      --    print("BLLR? -- FRAME DOES NOT HAVE A GetID METHOD")
      -- else
      --    print("BLLR? -- FRAME DOES HAVE AN ID: " .. frame:GetID())
      -- end

      -- if not frame.GetSize then
      --    print("BLLR? -- FRAME DOES NOT HAVE A GetSize METHOD")
      -- else
      --    print("BLLR? -- FRAME DOES HAVE AN ID: " .. frame:GetSize())
      -- end

      if status == MIA_Constants.overlayStatus.MISSING then
         frame.marked_junk_overlay = CreateFrame("Button", nil, frame, "BackdropTemplate")
         frame.marked_junk_overlay:SetSize(frame:GetSize())
         frame.marked_junk_overlay:SetPoint("CENTER")

         frame.marked_junk_overlay:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
         })

         if not frame.marked_junk_overlay.texture then
            mia.logger:Debug(
               'Adding a frame overlay texture to "'
                  .. tostring(itemName)
                  .. '"...\n'
                  .. "iconPath = "
                  .. tostring(iconPath)
                  .. "\n"
                  .. "position = "
                  .. tostring(position)
                  .. "\n"
                  .. "status = "
                  .. tostring(status)
            )

            frame.marked_junk_overlay.texture = frame.marked_junk_overlay:CreateTexture(nil, "OVERLAY")
            frame.marked_junk_overlay.texture:ClearAllPoints()
            frame.marked_junk_overlay.texture:SetTexture(iconPath)
            frame.marked_junk_overlay.texture:SetPoint(position)
            frame.marked_junk_overlay.texture:SetSize(20, 20)
         end
      end

      frame.marked_junk_overlay:SetFrameLevel(17)
      frame.marked_junk_overlay:SetBackdropColor(color.r, color.g, color.b, color.a)
      local isHiddenOrUpdate = status == MIA_Constants.overlayStatus.HIDDEN
         or status == MIA_Constants.overlayStatus.UPDATE

      if isHiddenOrUpdate then
         mia.logger:Debug(
            'Updating the frame overlay texture for "'
               .. tostring(itemName)
               .. '"...\n'
               .. "iconPath = "
               .. tostring(iconPath)
               .. "\n"
               .. "position = "
               .. tostring(position)
               .. "\n"
               .. "status = "
               .. tostring(status)
         )

         -- `ClearAllPoints` will clear the previous location before setting a/the new one
         -- Not using `ClearAllPoints` will make the icon image stretch all over the place
         frame.marked_junk_overlay.texture:ClearAllPoints()
         frame.marked_junk_overlay.texture:SetTexture(iconPath)
         frame.marked_junk_overlay.texture:SetPoint(position)
         frame.marked_junk_overlay:Show()
         frame.marked_junk_overlay.texture:Show()
      end

      db.junkItems[itemID] = true
      return
   end

   if status == MIA_Constants.overlayStatus.SHOWING then
      if db.showCommandOutput and not db.debugEnabled and shouldLogMarkingAction then
         mia.logger:Print('Removing the junk marking from "' .. tostring(itemName) .. '".')
      end

      mia.logger:Debug(
         "Clearing the overlay:\n"
            .. "bag = "
            .. tostring(bagIndex)
            .. "\n"
            .. "status = "
            .. tostring(status)
      )

      frame.marked_junk_overlay:SetFrameLevel(0)
      frame.marked_junk_overlay:SetBackdropColor(0, 0, 0, 0)
      frame.marked_junk_overlay:Hide()
      frame.marked_junk_overlay.texture:Hide()

      if itemID then
         db.junkItems[itemID] = false
      end

      return
   end
end

--## --------------------------------------------------------------------------
--## DATABASE OPERATION FUNCTIONS
--## --------------------------------------------------------------------------
function Utils:GetDbValue(key)
   local value
   -- the line below does a RegExp `match` for strings that look like 'someTable.someKey'
   local isMultiKey = key:match("%.")

   if isMultiKey then
      local table_name, key_name = string.match(key, "(.*)%.(.*)")
      self:VerifyDbTable(table_name, key_name)
      value = mia.db.profile[table_name][key_name]
   else
      value = mia.db.profile[key]
   end

   if mia.db.profile.enableVerboseLogging then
      mia.logger:Debug(
         'GetDbValue: Returning "' .. tostring(value) .. '" for "' .. tostring(key) .. '".'
      )
   end

   return value
end

function Utils:SetDbTableItem(table_name, key_name, value)
   if mia.db.profile.enableVerboseLogging then
      mia.logger:Debug(
         'SetDbTableItem: Setting "'
            .. tostring(key_name)
            .. '" to "'
            .. tostring(value)
            .. '" in table "'
            .. tostring(table_name)
            .. '".'
      )
   end

   self:VerifyDbTable(table_name, key_name)
   mia.db.profile[table_name][key_name] = value
end

function Utils:SetDbValue(key, value)
   if mia.db.profile.enableVerboseLogging then
      mia.logger:Debug(
         'SetDbValue: Setting "' .. tostring(key) .. '" to "' .. tostring(value) .. '".'
      )
   end

   mia.db.profile[key] = value
end

function Utils:VerifyDbTable(table_name, key_name)
   if not mia.db.profile[table_name] then
      mia.logger:Debug("VerifyDbTable: Table missing, creating an empty one...")
      mia.db.profile[table_name] = {}
   end

   if not mia.db.profile[table_name][key_name] then
      mia.logger:Debug("VerifyDbTable: Key missing, setting a starting nil value...")
      mia.db.profile[table_name][key_name] = {}
   end
end
