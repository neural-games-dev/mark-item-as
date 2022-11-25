MAJ_Utils = {};
MAJ_Utils.showGreeting = true;
MAJ_Utils.showSlashCommandOutput = true;

function MAJ_Utils:CreateDefaultOptions(frame)
   local slashCommandOutputCheckbox = CreateFrame("CheckButton", "MAJ_CheckBox_SlashCommandOutput", frame, "ChatConfigCheckButtonTemplate");
   slashCommandOutputCheckbox:SetPoint('TOPLEFT', frame.TitleBg, 'BOTTOMLEFT', 16, -26);
   local slashCommandOutputCheckboxLabel = _G[slashCommandOutputCheckbox:GetName() .. "Text"];
   slashCommandOutputCheckboxLabel:SetText('Show slash command output?');
   slashCommandOutputCheckboxLabel:SetPoint('TOPLEFT', slashCommandOutputCheckbox, 'RIGHT', 5, 7);
   slashCommandOutputCheckbox.tooltip = 'Bueller goes here.';
   slashCommandOutputCheckbox:SetChecked(MAJ_Utils.showSlashCommandOutput);
end

function MAJ_Utils:CreateFrame()
   local frame = CreateFrame('Frame', 'MAJ_ConfigOptions', UIParent, 'BasicFrameTemplateWithInset');
   frame:SetFrameStrata('FULLSCREEN_DIALOG');
   frame:SetSize(600, 480);
   frame:SetPoint('CENTER', UIParent, 'CENTER');
   frame:Hide();

   -- Creating the config frame title
   frame.title = frame:CreateFontString(nil, 'OVERLAY');
   frame.title:SetFontObject('GameFontNormalLarge');
   frame.title:SetPoint('CENTER', frame.TitleBg, 'CENTER', 0, 0);
   frame.title:SetText('Mark as Junk - Config Options');

   return frame;
end

function MAJ_Utils:HandleConfigOptionsDisplay(frame)
   if (frame:IsShown()) then
      -- TODO **[G]** :: Add a UI setting/saved variable to enable/disable these messages
      if (MAJ_Utils.showSlashCommandOutput) then
         print('Now hiding the ' .. MAJ_Constants.addOnNameQuoted .. ' config options window.');
      end

      frame:Hide();
   else
      -- TODO **[G]** :: Add a UI setting/saved variable to enable/disable these messages
      if (MAJ_Utils.showSlashCommandOutput) then
         print('You are now seeing the ' .. MAJ_Constants.addOnNameQuoted .. ' config options window.');
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
