--local Baggins = Baggins; -- this will be so I can target Baggins to do stuff later
--local Bagnon = Bagnon; -- this will be so I can target Bagnon to do stuff later (need to verify this name)

local majAddOnName = '|cff00ffffMark As Junk|r';
local majAddOnNameQuoted = '|cff00ffff"Mark As Junk"|r';
local showSlashCommandOutput = true; -- TODO **[G]** :: Put this into a globally saved variable
local showGreeting = true; -- TODO **[G]** :: Put this into a globally saved variable

--## ==========================================================================
--## START UP & GREETING SCRIPTS
--## ==========================================================================
-- TODO **[G]** :: Update this condition to be based off of a UI setting/saved variable so that it disables this greeting
if (showGreeting) then
   local name = UnitName("player");
   print('Hi, ' .. name .. '! Thanks for using ' .. majAddOnNameQuoted .. '! Type |cffbada55"/maj"|r to get more info.');
end

--## ==========================================================================
--## MAIN CONFIG / OPTIONS WINDOW
--## ==========================================================================

-- Instantiating the config frame with default/starting values
local MAJ_Config = MAJ_Utils:CreateFrame();

-- Registering the frame so that hitting `ESC` closes it
tinsert(UISpecialFrames, MAJ_Config:GetName());

-- Registering the frame as movable so that users can adjust it
MAJ_Utils:MakeFrameMovable(MAJ_Config);

-- Making the frame resizable
MAJ_Utils:MakeFrameResizable(MAJ_Config);

--[[
   TODO :: Move these slash commands into their own file and then source them into here
]]
--## ==========================================================================
--## CUSTOM SLASH COMMANDS
--## ==========================================================================
SLASH_MAJ_RELOAD_UI1 = '/mrl'; -- For quicker reloading
SlashCmdList.MAJ_RELOAD_UI = ReloadUI;

SLASH_MAJ_FRAME_STK1 = '/mfs' -- For quicker access to the WoW frame stack
SlashCmdList.MAJ_FRAME_STK = function()
   -- TODO **[G]** :: Add logic to only enable this for me
   LoadAddOn('Blizzard_DebugTools');
   FrameStackTooltip_Toggle();
end

-- To be able to use the left and right arrows in the edit box
-- without rotating your character
for i = 1, NUM_CHAT_WINDOWS, 1 do
   _G['ChatFrame' .. i .. 'EditBox']:SetAltArrowKeyMode(false);
end

-- Display the MarkAsJunk commands and notes
SLASH_MAJ_INFO1 = '/maj';
SlashCmdList.MAJ_INFO = function(command)
   if (command == '') then
      --print('🌟💰🌟 |cff00ffff-- MARK AS JUNK COMMANDS --|r 🌟💰🌟');
      print('|cff00ffff----- MARK AS JUNK COMMANDS -----|r');
      print('|cffbada55/maj config (c)|r -- Shows the config window to customize this addon.');
      print('|cffbada55/maj options (o)|r -- This is an alias for "config".');
      print('|cffbada55/maj hidetext (ht)|r -- Disables the text output when triggering a |cffbada55"/maj"|r command.');
      print('|cffbada55/maj showtext (st)|r -- Enables the text output when triggering a |cffbada55"/maj"|r command.');
      return ;
   end

   if (command == 'config' or command == 'c') then
      MAJ_Utils:HandleConfigOptionsDisplay(MAJ_Config);
      return ;
   end

   if (command == 'options' or command == 'o') then
      MAJ_Utils:HandleConfigOptionsDisplay(MAJ_Config);
      return ;
   end

   if (command == 'hidetext' or command == 'ht') then
      showSlashCommandOutput = false;
      print(majAddOnName .. ': The slash command output text has been DISABLED.');
      return ;
   end

   if (command == 'showtext' or command == 'st') then
      showSlashCommandOutput = true;
      print(majAddOnName .. ': The slash command output text has been ENABLED.');
      return ;
   end

   print(majAddOnName .. ': "' .. command .. '" is an unknown command.');
   return ;
end
