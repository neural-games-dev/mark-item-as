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
   self.mia.logger:Debug('Iterating through the items now and selling them...');
end
