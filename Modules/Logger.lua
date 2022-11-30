local MarkAsJunk = LibStub("AceAddon-3.0"):GetAddon("MarkAsJunk");
local Logger = MarkAsJunk:NewModule("Logger");

function Logger:Print(...)
   MarkAsJunk:Print(...);
end
