--local Baggins = Baggins; -- this will be so I can target Baggins to do stuff later
--local Bagnon = Bagnon; -- this will be so I can target Bagnon to do stuff later (need to verify this name)

--## ==========================================================================
--## START UP & GREETING SCRIPTS
--## ==========================================================================
-- TODO **[G]** :: Update this condition to be based off of a UI setting/saved variable so that it disables this greeting
if (MAJ_Utils.showGreeting) then
   local name = UnitName("player");
   print('Hi, ' .. name .. '! Thanks for using ' .. MAJ_Constants.addOnNameQuoted .. '! Type ' .. MAJ_Constants.slashCommandQuoted .. ' to get more info.');
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

-- Create/generate and insert the options and their defaults
MAJ_Utils:CreateDefaultOptions(MAJ_Config);

--[[
   TODO :: Move these slash commands into their own file and then source them into here
]]
--## ==========================================================================
--## CUSTOM SLASH COMMANDS
--## ==========================================================================
SLASH_MAJ_RELOAD_UI1 = '/nrl'; -- For quicker reloading
SlashCmdList.MAJ_RELOAD_UI = ReloadUI;

SLASH_MAJ_FRAME_STK1 = '/nfs' -- For quicker access to the WoW frame stack
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
      print('|cffbada55/maj hidetext (ht)|r -- Disables the text output when triggering a ' .. MAJ_Constants.slashCommandQuoted .. ' command.');
      print('|cffbada55/maj showtext (st)|r -- Enables the text output when triggering a ' .. MAJ_Constants.slashCommandQuoted .. ' command.');
      return ;
   end

   if (command == 'config' or command == 'c') then
      --print('BLLR? -- CONFIG, Show slash command output: ' .. tostring(MAJ_Utils.showSlashCommandOutput));
      MAJ_Utils:HandleConfigOptionsDisplay(MAJ_Config);
      return ;
   end

   if (command == 'options' or command == 'o') then
      --print('BLLR? -- OPTIONS, Show slash command output: ' .. tostring(MAJ_Utils.showSlashCommandOutput));
      MAJ_Utils:HandleConfigOptionsDisplay(MAJ_Config);
      return ;
   end

   if (command == 'hidetext' or command == 'ht') then
      -- TODO **[G]** :: This needs to affect the checkbox in the options window
      MAJ_Utils.showSlashCommandOutput = false;
      print(MAJ_Constants.addOnName .. ': The slash command output text has been DISABLED.');
      return ;
   end

   if (command == 'showtext' or command == 'st') then
      -- TODO **[G]** :: This needs to affect the checkbox in the options window
      MAJ_Utils.showSlashCommandOutput = true;
      print(MAJ_Constants.addOnName .. ': The slash command output text has been ENABLED.');
      return ;
   end

   print(MAJ_Constants.addOnName .. ': "' .. command .. '" is an unknown command.');
   return ;
end
