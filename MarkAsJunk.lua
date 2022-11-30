local MarkAsJunk = LibStub("AceAddon-3.0"):NewAddon("MarkAsJunk", "AceConsole-3.0", "AceEvent-3.0");
MarkAsJunk.version = GetAddOnMetadata("MarkAsJunk", "Version");

--local Baggins = Baggins; -- this will be so I can target Baggins to do stuff later
--local Bagnon = Bagnon; -- this will be so I can target Bagnon to do stuff later (need to verify this name)

--## ==========================================================================
--## START UP & GREETING SCRIPTS
--## ==========================================================================
local MAJ_Config;

function MarkAsJunk:OnInitialize()
   self.db = LibStub("AceDB-3.0"):New("MarkAsJunkDB", { profile = MAJ_Utils });

   -- To be able to use the left and right arrows in the edit box
   -- without rotating your character
   for i = 1, NUM_CHAT_WINDOWS, 1 do
      _G['ChatFrame' .. i .. 'EditBox']:SetAltArrowKeyMode(false);
   end

   self.logger = self:GetModule("Logger");

   self:RegisterChatCommand("maj", "SlashCommandInfoConfig");
   self:RegisterChatCommand("nrl", "SlashCommandReload");
   self:RegisterChatCommand("nfs", "SlashCommandFrameStack");

   -- TODO **[G]** :: Update this condition to be based off of a UI setting/saved variable so that it disables this greeting
   if (MAJ_Utils.showGreeting) then
      local name = UnitName("player");
      self.logger:Print('Hi, ' .. name .. '! Thanks for using this addon! Type ' .. MAJ_Constants.slashCommandQuoted .. ' to get more info.');
   end
end

--## ==========================================================================
--## MAIN CONFIG / OPTIONS WINDOW
--## ==========================================================================
function MarkAsJunk:OnEnable()
   -- TODO :: What do I (need to) do here?
   -- Instantiating the config frame with default/starting values
   MAJ_Config = MAJ_Utils:CreateFrame();

   -- Registering the frame so that hitting `ESC` closes it
   tinsert(UISpecialFrames, MAJ_Config:GetName());

   -- Registering the frame as movable so that users can adjust it
   MAJ_Utils:MakeFrameMovable(MAJ_Config);

   -- Making the frame resizable
   MAJ_Utils:MakeFrameResizable(MAJ_Config);

   -- Create/generate and insert the options and their defaults
   MAJ_Utils:CreateDefaultOptions(MAJ_Config);
end

--[[
   TODO :: Move these slash commands into their own file and then source them into here
]]
--## ==========================================================================
--## CUSTOM SLASH COMMANDS
--## ==========================================================================
function MarkAsJunk:SlashCommandFrameStack()
   LoadAddOn('Blizzard_DebugTools');
   FrameStackTooltip_Toggle();
end

function MarkAsJunk:SlashCommandInfoConfig(command)
   command = command:trim();

   -- Display the MarkAsJunk commands and notes
   if (command == '') then
      --print('🌟💰🌟 |cFF00ffff-- MARK AS JUNK COMMANDS --|r 🌟💰🌟');
      self.logger:Print([[
|cFF00ffff----- COMMANDS -----|r
|cFFbada55/maj config (c)|r -- Shows the config window to customize this addon.
|cFFbada55/maj options (o)|r -- This is an alias for "config".
|cFFbada55/maj hidetext (ht)|r -- DISABLES text output when using a |cFFbada55"/maj"|r command.
|cFFbada55/maj showtext (st)|r -- ENABLES text output when using a |cFFbada55"/maj"|r command.
      ]]);

      return ;
   end

   if (command == 'config' or command == 'c') then
      --self.logger:Print('BLLR? -- CONFIG, Show slash command output: ' .. tostring(MAJ_Utils.showSlashCommandOutput));
      MAJ_Utils:HandleConfigOptionsDisplay(MAJ_Config);
      return ;
   end

   if (command == 'options' or command == 'o') then
      --self.logger:Print('BLLR? -- OPTIONS, Show slash command output: ' .. tostring(MAJ_Utils.showSlashCommandOutput));
      MAJ_Utils:HandleConfigOptionsDisplay(MAJ_Config);
      return ;
   end

   if (command == 'hidetext' or command == 'ht') then
      -- TODO **[G]** :: This needs to affect the checkbox in the options window
      MAJ_Utils.showSlashCommandOutput = false;
      self.logger:Print('The slash command output text has been DISABLED.');
      local slashCommandOutputCheckbox = _G[MAJ_CheckBox_SlashCommandOutput:GetName()];
      slashCommandOutputCheckbox:SetChecked(false);
      return ;
   end

   if (command == 'showtext' or command == 'st') then
      -- TODO **[G]** :: This needs to affect the checkbox in the options window
      MAJ_Utils.showSlashCommandOutput = true;
      self.logger:Print('The slash command output text has been ENABLED.');
      local slashCommandOutputCheckbox = _G[MAJ_CheckBox_SlashCommandOutput:GetName()];
      slashCommandOutputCheckbox:SetChecked(true);
      return ;
   end

   self.logger:Print('"' .. command .. '" is an unknown command.');
   return ;
end

function MarkAsJunk:SlashCommandReload()
   ReloadUI();
end
