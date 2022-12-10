--## ==========================================================================
--## ALL REQUIRED IMPORTS
--## ==========================================================================
-- Libs / Packages
local acd = LibStub("AceConfigDialog-3.0");

--## ==========================================================================
--## DEFINING ALL CUSTOM UTILS TO BE USED THROUGHOUT THE ADDON
--## ==========================================================================
function MAJ_Utils:CreateFrame()
   local frame = CreateFrame('Frame', 'MAJ_ConfigOptions', UIParent, 'BasicFrameTemplateWithInset');

   -- Setting the size and the position
   frame:SetFrameStrata('FULLSCREEN_DIALOG');
   frame:SetSize(800, 600);
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

function MAJ_Utils:HandleConfigOptionsDisplay()
   if (acd.OpenFrames['MarkAsJunk']) then
      acd:Close('MarkAsJunk');
   else
      acd:Open('MarkAsJunk');
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
