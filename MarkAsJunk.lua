local majAddOnName = '|cff00ffffMark As Junk|r';
local majAddOnNameQuoted = '|cff00ffff"Mark As Junk"|r';
local showCommandText = true; -- TODO **[G]** :: Put this into a globally saved variable
local showGreeting = true; -- TODO **[G]** :: Put this into a globally saved variable

--[[
   TODO :: Move these slash commands into their own file and then source them into here
]]
--## ==========================================================================
--## CUSTOM SLASH COMMANDS
--## ==========================================================================
SLASH_MAJRELOADUI1 = '/rl'; -- For quicker reloading
SlashCmdList.MAJRELOADUI = ReloadUI;

SLASH_FRAMESTK1 = '/mfs' -- For quicker access to the WoW frame stack
SlashCmdList.FRAMESTK = function()
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
SLASH_MAJINFO1 = '/maj';
SlashCmdList.MAJINFO = function(command)
   if (command == '') then
      --print('🌟💰🌟 |cff00ffff-- MARK AS JUNK COMMANDS --|r 🌟💰🌟');
      print('|cff00ffff----- MARK AS JUNK COMMANDS -----|r');
      print('|cffbada55/maj config|r -- Shows the options window to customize this addon.');
      print('|cffbada55/maj options|r -- This is an alias for "config".');
      print('|cffbada55/maj notext|r -- Disables the text output when triggering a "/maj" command.');
      print('|cffbada55/maj showtext|r -- Enables the text output when triggering a "/maj" command.');
      return ;
   end

   if (command == 'config') then
      -- TODO **[G]** :: Add a UI setting/saved variable to enable/disable these messages
      if (showCommandText) then
         print('You are now seeing the ' .. majAddOnNameQuoted .. ' config/options window.');
      end

      return ;
   end

   if (command == 'options') then
      -- TODO **[G]** :: Add a UI setting/saved variable to enable/disable these messages
      if (showCommandText) then
         print('You are now seeing the ' .. majAddOnNameQuoted .. ' config/options window.');
      end

      return ;
   end

   if (command == 'notext') then
      showCommandText = false;
      print(majAddOnName .. ': Command output text has been disabled.');
      return ;
   end

   if (command == 'showtext') then
      showCommandText = true;
      print(majAddOnName .. ': Command output text has been enabled.');
      return ;
   end

   print(majAddOnName .. ': "' .. command .. '" is an unknown command.');
   return ;
end

--## ==========================================================================
--## START UP & GREETING SCRIPTS
--## ==========================================================================
-- TODO **[G]** :: Update this condition to be based off of a UI setting/saved variable so that it disables this greeting
if (showGreeting) then
   local name = UnitName("player");
   print('Hi, ' .. name .. '! Thanks for using ' .. majAddOnNameQuoted .. '! Type "/maj" to get more info.');
end

--## ==========================================================================
--## MAIN CONFIG / OPTIONS WINDOW
--## ==========================================================================
local MAJConfig = CreateFrame('Frame', 'MAJ_Config', UIParent, 'BasicFrameTemplateWithInset');
MAJConfig:SetSize(600, 480);
MAJConfig:SetPoint('CENTER', UIParent, 'CENTER');
MAJConfig:SetFrameStrata('HIGH');
