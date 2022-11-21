local majAddOnName = '|cff00ffffMark As Junk|r';
local majAddOnNameQuotes = '|cff00ffff"Mark As Junk"|r';

--[[
   TODO :: Move these slash commands into their own file and then source them into here
]]
SLASH_RELOADUI1 = '/rl'; -- For quicker reloading
SlashCmdList.RELOADUI = ReloadUI;

SLASH_FRAMESTK1 = '/fs' -- For quicker access to the WoW frame stack
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
SLASH_MARKASJUNKINFO1 = '/maj';
SlashCmdList.MARKASJUNKINFO = function(command)
   if (command == '') then
      --print('🌟💰🌟 |cff00ffff-- MARK AS JUNK COMMANDS --|r 🌟💰🌟');
      print('|cff00ffff----- MARK AS JUNK COMMANDS -----|r');
      print('|cffbada55/maj config|r -- Shows the options window to customize this addon.');
      print('|cffbada55/maj options|r -- This is an alias for "config".');
      return;
   end

   if (command == 'config') then
      -- TODO **[G]** :: Add a UI setting to enable/disable these messages
      if (true) then
         print('You are now seeing the ' .. majAddOnNameQuotes .. ' config/options window.');
      end

      return;
   end

   if (command == 'options') then
      -- TODO **[G]** :: Add a UI setting to enable/disable these messages
      if (true) then
         print('You are now seeing the ' .. majAddOnNameQuotes .. ' config/options window.');
      end

      return;
   end

   print(majAddOnName .. ': "' .. command .. '" is an unknown command.');
   return;
end

-- update this condition to be based off of a UI setting so that it disables this greeting
if true then
   local name = UnitName("player");
   print('Hi, ' .. name .. '! Thanks for using ' .. majAddOnNameQuotes .. '! Type "/maj" to get more info.');
end
