--## ===============================================================================================
--## ALL REQUIRED IMPORTS
--## ===============================================================================================
-- Libs / Packages
local MarkItemAs = LibStub('AceAddon-3.0'):GetAddon('MarkItemAs');

--## ===============================================================================================
--## INTERNAL VARS & SET UP
--## ===============================================================================================
local Selling = MarkItemAs:NewModule('Selling');

--## ===============================================================================================
--## DEFINING THE `SELLING` MODULE & ITS METHODS
--## ===============================================================================================
function Selling:Init(mia)
   self.mia = mia;
end

function Selling:SellItems()
   local junkItems = self.mia.utils:GetDbValue('junkItems');
   local junkItemsLength = self.mia.utils:GetSellableItemsLength(junkItems);
   local suffix = junkItemsLength == 1 and ' item.' or ' items.';

   self.mia.logger:Debug('Iterating through all of the bags now and selling ' .. tostring(junkItemsLength) .. suffix);

   local itemsSoldLinksList = {};
   local totalItemsSold = 0;
   local totalSellPrice = 0;
   local uniqueItemsSold = 0;

   for bagIndex = 0, MIA_Constants.numContainers, 1 do
      local bagName = _G["ContainerFrame" .. bagIndex + 1]:GetName();
      local numSlots = C_Container.GetContainerNumSlots(bagIndex);

      for slotIndex = 1, numSlots, 1 do
         local slotFrame = _G[bagName .. 'Item' .. slotIndex];
         local slotFrameID = slotFrame:GetID();
         local item = Item:CreateFromBagAndSlot(bagIndex, slotFrameID);
         local itemName = item:GetItemName();
         local itemID = item:GetItemID();
         local isItemEmpty = item:IsItemEmpty();
         local isItemMarkedJunk = junkItems[itemID];

         if (not isItemEmpty and isItemMarkedJunk) then
            local slotIndexInverted = numSlots - slotIndex + 1; -- Blizz bag slot indexes are weird
            local itemLink = select('2', GetItemInfo(itemName));
            local itemLocation = ItemLocation:CreateFromBagAndSlot(bagIndex, slotIndexInverted);
            local itemSellPrice = select('11', GetItemInfo(itemName));
            local itemStackCount = C_Item.GetStackCount(itemLocation);

            if (self.mia.utils:GetDbValue('showSaleSummary')) then
               self.mia.logger:Print('Selling ' .. tostring(itemStackCount) .. ' ' .. itemLink .. ' for:\n' ..
                  self.mia.utils:PriceToGold(itemSellPrice) .. ' each.\n' ..
                  self.mia.utils:PriceToGold(itemSellPrice * itemStackCount) .. ' total.'
               );
            end

            self.mia.logger:Debug('Current total sell price: ' .. self.mia.utils:PriceToGold(totalSellPrice));
            -- actually sell the item to the merchant
            C_Container.PickupContainerItem(bagIndex, slotIndexInverted);
            PickupMerchantItem();
            self.mia.utils:SetDbValue('soldItemsAtMerchant', true);

            -- calculate the tallies up, bruh!
            totalSellPrice = totalSellPrice + (itemSellPrice * itemStackCount);
            totalItemsSold = totalItemsSold + itemStackCount;
            uniqueItemsSold = uniqueItemsSold + 1
            table.insert(itemsSoldLinksList, itemLink);

            -- Setting the item to `false` in the db to remove the overlay & border
            self.mia.utils:SetDbTableItem('junkItems', itemID, false);

            -- stop selling once we've already sold 12 unique items
            local limitSaleItems = self.mia.utils:GetDbValue('limitSaleItems');
            local isTooManyItemsSold = uniqueItemsSold > MIA_Constants.buybackLimit;

            if (limitSaleItems and isTooManyItemsSold) then
               self.mia.logger:Debug('SellItems: 12 unique items have already been sold. Stopping selling iteration.');
               break ;
            end
         end
      end
   end

   self.mia.utils:UpdateBagMarkings();

   if (self.mia.utils:GetDbValue('soldItemsAtMerchant') and self.mia.utils:GetDbValue('showSaleSummary')) then
      self.mia.logger:PrintSaleSummary(
         totalSellPrice,
         totalItemsSold,
         uniqueItemsSold,
         itemsSoldLinksList
      );
   end
end
