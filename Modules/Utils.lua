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
      if (self:isMajKeyCombo(button)) then
         local item = Item:CreateFromBagAndSlot(bagIndex, slotFrame:GetID());

         if (maj.db.profile.debugLogging) then
            maj.logger:Print('HANDLE ON CLICK INFO:\n' ..
               'BagName: ' .. tostring(bagName) .. '\n' ..
               'SlotFrameName: ' .. tostring(slotFrame:GetName()) .. '\n' ..
               'SlotFrameID: ' .. tostring(slotFrame:GetID()) .. '\n' ..
               'ContainerNumSlots: ' .. tostring(numSlots) .. '\n' ..
               'FrameName: ' .. tostring(frame:GetName()) .. '\n' ..
               'FrameID: ' .. tostring(frame:GetID()) .. '\n' ..
               'ItemName: ' .. tostring(item:GetItemName()) .. '\n' ..
               'ItemID: ' .. tostring(item:GetItemID()) .. '\n' ..
               'ItemLocation.SlotIndex: ' .. tostring(item:GetItemLocation().slotIndex) .. '\n'
            );
         end

         -- this tells me if the bag/container slot has an item in there or not
         if (item:IsItemEmpty()) then
            -- keep using this or use this? -- frame.hasItem
            if (maj.db.profile.showCommandOutput and not maj.db.profile.debugLogging) then
               maj.logger:Print('No item present. Ignoring.');
            end

            return ;
            -- TODO **[G]** :: Re-enable this ItemLock check once I have marking work properly
            --elseif (IsAddOnLoaded('ItemLock') and not not frame.lockItemsAppearanceOverlay) then
            --   maj.logger:Print('Item is locked, ignoring.');
            --   return ;
         elseif (not item.markedJunkOverlay) then
            --for k, v in pairs(item:GetItemLocation()) do
            --   maj.logger:Print('FRAME KEY: '.. tostring(k) .. ', FRAME VALUE: ' .. tostring(v));
            --end

            if (maj.db.profile.showCommandOutput and not maj.db.profile.debugLogging) then
               -- TODO **[G]** :: Clean this log up to be more user friendly
               maj.logger:Print('Adding an overlay to "' .. tostring(item:GetItemName()) .. '"');
            end

            local oc = maj.db.profile.overlayColor;
            item.markedJunkOverlay = CreateFrame("FRAME", nil, frame, "BackdropTemplate");
            item.markedJunkOverlay:SetSize(frame:GetSize());
            item.markedJunkOverlay:SetPoint("CENTER");

            item.markedJunkOverlay:SetBackdrop({
               bgFile = "Interface/Tooltips/UI-Tooltip-Background"
            });

            item.markedJunkOverlay:SetFrameLevel(20);
            item.markedJunkOverlay:SetBackdropColor(oc.r, oc.g, oc.b, oc.a);
            return ;
         else
            maj.logger:Print('Clearing the frame overlay?');
            item.markedJunkOverlay = nil;
            return ;
         end
      else
         -- MAJ key combo was not pressed, ignoring and returning
         if (maj.db.profile.debugLogging) then
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
   for i = 0, MAJ_Constants.numContainers, 1 do
      local bagIndex = i;
      local bagName = _G["ContainerFrame" .. bagIndex + 1]:GetName();
      local numSlots = C_Container.GetContainerNumSlots(bagIndex);

      if (numSlots > 0) then
         for j = 1, numSlots, 1 do
            local slotIndex = j;
            local slotFrame = _G[bagName .. "Item" .. slotIndex];
            slotFrame:HookScript('OnClick', self:handleOnClick(bagIndex, bagName, slotFrame, numSlots));
         end
      else
         if (maj.db.profile.debugLogging) then
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
