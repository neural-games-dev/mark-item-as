MAJ_Utils = {};

function MAJ_Utils:CreateFrame()
   local frame = CreateFrame('Frame', 'MAJ_ConfigOptions', UIParent, 'BasicFrameTemplateWithInset');
   frame:SetFrameStrata('FULLSCREEN_DIALOG');
   frame:SetSize(600, 480);
   frame:SetPoint('CENTER', UIParent, 'CENTER');
   frame:Hide();

   -- Creating the config frame title
   frame.title = frame:CreateFontString(nil, 'OVERLAY');
   frame.title:SetFontObject('GameFontHighlight');
   frame.title:SetPoint('CENTER', frame.TitleBg, 'CENTER', 0, 0);
   frame.title:SetText('Mark as Junk - Config Options');

   return frame;
end

function MAJ_Utils:HandleConfigOptionsDisplay(frame)
   if (frame:IsShown()) then
      -- TODO **[G]** :: Add a UI setting/saved variable to enable/disable these messages
      if (showSlashCommandOutput) then
         print('Now hiding the ' .. majAddOnNameQuoted .. ' config options window.');
      end

      frame:Hide();
   else
      -- TODO **[G]** :: Add a UI setting/saved variable to enable/disable these messages
      if (showSlashCommandOutput) then
         print('You are now seeing the ' .. majAddOnNameQuoted .. ' config options window.');
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
