MAJ_Utils = {
   autoSortMarking = false,
   autoSortSelling = false,
   isBagginsLoaded = IsAddOnLoaded('Baggins'),
   showGreeting = true,
   showSlashCommandOutput = true,
};

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
         print(MAJ_Constants.addOnName .. ': Hiding the config options window.');
      end

      frame:Hide();
   else
      -- TODO **[G]** :: Add a UI setting/saved variable to enable/disable these messages
      if (MAJ_Utils.showSlashCommandOutput) then
         print(MAJ_Constants.addOnName .. ': Showing the config options window.');
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
   if (MAJ_Utils.isBagginsLoaded) then
      print(MAJ_Constants.bagginsLoadedWarning);
      return ;
   end

   local sortButton = _G[BagItemAutoSortButton:GetName()];
   sortButton:Click();
end
