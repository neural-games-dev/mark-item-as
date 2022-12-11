--## ==========================================================================
--## ALL REQUIRED IMPORTS
--## ==========================================================================
-- Libs / Packages
local acd = LibStub("AceConfigDialog-3.0");

--## ==========================================================================
--## DEFINING ALL CUSTOM UTILS TO BE USED THROUGHOUT THE ADDON
--## ==========================================================================
function MAJ_Utils:HandleConfigOptionsDisplay()
   if (acd.OpenFrames['MarkAsJunk']) then
      acd:Close('MarkAsJunk');
   else
      acd:Open('MarkAsJunk');
   end
end

function MAJ_Utils:SortBags()
   -- TODO **[G]** :: How does this need to change when using other bag addons?
   -- TODO **[G]** :: Does this even need to change? Or is/can it be consistently global no matter the bag addon?
   if (MAJ_Utils.isBagginsLoaded) then
      print(MAJ_Constants.bagginsLoadedWarning);
      return ;
   end

   local sortButton = _G[BagItemAutoSortButton:GetName()];
   sortButton:Click();
end
