MAJ_Utils = {
   autoSort = false,
   showGreeting = true,
   showSlashCommandOutput = true,
};

function MAJ_Utils:CreateDefaultOptions(frame)
   -- Auto-sort after selling items
   local autoSortCheckbox = CreateFrame("CheckButton", "MAJ_CheckBox_AutoSort", frame, "ChatConfigCheckButtonTemplate");
   autoSortCheckbox:SetPoint('TOPLEFT', frame.TitleBg, 'BOTTOMLEFT', 24, -24);
   local autoSortCheckboxLabel = _G[autoSortCheckbox:GetName() .. "Text"];
   autoSortCheckboxLabel:SetText('Auto-sort bags after selling?');
   autoSortCheckboxLabel:SetPoint('TOPLEFT', autoSortCheckbox, 'RIGHT', 5, 7);
   autoSortCheckbox.tooltip = 'When you sell your items at a merchant, this will sort your bags (i.e. "click" the broom icon) automatically.';
   autoSortCheckbox:SetChecked(MAJ_Utils.autoSort);

   -- Toggle slash command output in the chat box
   local slashCommandOutputCheckbox = CreateFrame("CheckButton", "MAJ_CheckBox_SlashCommandOutput", frame, "ChatConfigCheckButtonTemplate");
   slashCommandOutputCheckbox:SetPoint('TOPLEFT', frame.TitleBg, 'BOTTOMLEFT', 24, -48);
   local slashCommandOutputCheckboxLabel = _G[slashCommandOutputCheckbox:GetName() .. "Text"];
   slashCommandOutputCheckboxLabel:SetText('Show slash command output?');
   slashCommandOutputCheckboxLabel:SetPoint('TOPLEFT', slashCommandOutputCheckbox, 'RIGHT', 5, 7);
   slashCommandOutputCheckbox.tooltip = 'This will hide or show the chat output after entering in a ' .. MAJ_Constants.slashCommandQuoted .. ' command.';
   slashCommandOutputCheckbox:SetChecked(MAJ_Utils.showSlashCommandOutput);
   --print('BLLR? -- UTILS: Show slash command output: ' .. tostring(MAJ_Utils.showSlashCommandOutput));
end

function MAJ_Utils:CreateFrame()
   local frame = CreateFrame('Frame', 'MAJ_ConfigOptions', UIParent, 'BasicFrameTemplateWithInset');

   -- Setting the size and the position
   frame:SetFrameStrata('FULLSCREEN_DIALOG');
   frame:SetSize(600, 480);
   frame:SetPoint('CENTER', UIParent, 'CENTER');
   frame:Hide();

   -- Creating the config frame title
   frame.title = frame:CreateFontString(nil, 'OVERLAY');
   frame.title:SetFontObject('GameFontNormalLarge');
   frame.title:SetPoint('CENTER', frame.TitleBg, 'CENTER', 0, 0);
   frame.title:SetText('Mark as Junk - Config Options');

   -- Setting the background image
   --local background = CreateFrame('Frame', 'MAJ_BgFrame', frame, 'BackdropTemplate');
   --background:SetPoint('CENTER');
   --background:SetSize(600, 480);
   --
   --background:SetBackdrop({
   --   bgFile = 'Interface\\AddOns\\mark-as-junk\\mark-as-junk-logo',
   --});

   return frame;
end

function MAJ_Utils:HandleConfigOptionsDisplay(frame)
   if (frame:IsShown()) then
      -- TODO **[G]** :: Add a UI setting/saved variable to enable/disable these messages
      if (MAJ_Utils.showSlashCommandOutput) then
         print(MAJ_Constants.addOnName .. ': HIDING the config options window.');
      end

      frame:Hide();
   else
      -- TODO **[G]** :: Add a UI setting/saved variable to enable/disable these messages
      if (MAJ_Utils.showSlashCommandOutput) then
         print(MAJ_Constants.addOnName .. ': SHOWING the config options window.');
      end

      frame:Show();
   end
end

function MAJ_Utils:MakeFrameMovable(frame)
   frame:SetMovable(true);
   frame:EnableMouse(true);
   frame:RegisterForDrag('LeftButton');

   frame:SetScript('OnDragStart', function(self, button)
      self:StartMoving();
   end);

   frame:SetScript('OnDragStop', function(self)
      self:StopMovingOrSizing();
   end);
end

function MAJ_Utils:MakeFrameResizable(frame)
   frame:SetResizable(true);
   frame:SetResizeBounds(600, 480, 1440, 900);

   local resizeButton = CreateFrame('Button', nil, frame);
   resizeButton:EnableMouse(true);
   resizeButton:SetPoint('BOTTOMRIGHT');
   resizeButton:SetSize(24, 24);
   resizeButton:SetNormalTexture('Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down')
   resizeButton:SetHighlightTexture('Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight')
   resizeButton:SetPushedTexture('Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up')

   resizeButton:SetScript('OnMouseDown', function(self)
      self:GetParent():StartSizing('BOTTOMRIGHT')
   end)

   resizeButton:SetScript('OnMouseUp', function(self)
      self:GetParent():StopMovingOrSizing('BOTTOMRIGHT')
   end)
end

function MAJ_Utils:SortBags()
   -- TODO **[G]** :: How does this need to change when using other bag addons?
   -- TODO **[G]** :: Does this even need to change? Or is/can it be consistently global no matter the bag addon?
   local sortButton = _G[BagItemAutoSortButton:GetName()];
   sortButton:Click();
end
