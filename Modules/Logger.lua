--## ===============================================================================================
--## ALL REQUIRED IMPORTS
--## ===============================================================================================
-- Libs / Packages
local MarkAsJunk = LibStub('AceAddon-3.0'):GetAddon('MarkAsJunk');

--## ===============================================================================================
--## INTERNAL VARS & SET UP
--## ===============================================================================================
local Logger = MarkAsJunk:NewModule('Logger');
local u = MarkAsJunk:GetModule('Utils');

--## ===============================================================================================
--## DEFINING THE LOGGER METHODS
--## ===============================================================================================
function Logger:Print(...)
   if (MarkAsJunk.db.profile.debugLogging) then
      MarkAsJunk:Print(u:debug('[DEBUGGING] '), ...);
   else
      MarkAsJunk:Print(...);
   end
end
