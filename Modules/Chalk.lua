--## ===============================================================================================
--## ALL REQUIRED IMPORTS
--## ===============================================================================================
-- Libs / Packages
local mia = LibStub('AceAddon-3.0'):GetAddon('MarkAsJunk');

--## ===============================================================================================
--## INTERNAL VARS & SET UP
--## ===============================================================================================
local Chalk = mia:NewModule('Chalk');

--## ===============================================================================================
--## DEFINING ALL TEXT COLORIZING UTILS TO BE USED THROUGHOUT THE ADDON
--## ===============================================================================================
function Chalk:ace(text)
   return '|cFF33ff99' .. text .. '|r';
end

function Chalk:badass(text)
   return '|cFFbada55' .. text .. '|r';
end

function Chalk:cyan(text)
   return '|cFF00ffff' .. text .. '|r';
end

function Chalk:debug(text)
   return '|cFFfd4a4a' .. text .. '|r';
end

function Chalk:green(text)
   return '|cFF00ff00' .. text .. '|r';
end

function Chalk:red(text)
   return '|cFFfd4a4a' .. text .. '|r';
end

function Chalk:warn(text)
   return '|cFFfa8200' .. text .. '|r';
end
