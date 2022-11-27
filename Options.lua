local function selectActivatorKey(activatorKey)
   UIDropDownMenu_SetSelectedID(MAJ_DropDown_MarkingActivatorKey, activatorKey:GetID());
   MAJ_Utils.userSelectedActivatorKey = activatorKey.value;
end

local function selectModKey(modKey)
   UIDropDownMenu_SetSelectedID(MAJ_DropDown_MarkingModKey, modKey:GetID());
   MAJ_Utils.userSelectedModKey = modKey.value;
end

local function insertActivatorKeyOptions()
   local activatorKeysList = {
      'LEFT-CLICK',
      'RIGHT-CLICK',
   };

   for idx, activatorKey in pairs(activatorKeysList) do
      local activatorKeyOption = UIDropDownMenu_CreateInfo();
      activatorKeyOption.text = activatorKey;
      activatorKeyOption.value = activatorKey;
      activatorKeyOption.func = selectActivatorKey;

      UIDropDownMenu_AddButton(activatorKeyOption);

      if activatorKey == MAJ_Utils.userSelectedActivatorKey then
         UIDropDownMenu_SetSelectedID(MAJ_DropDown_MarkingActivatorKey, idx);
      end
   end
end

local function insertModKeyOptions()
   local modKeysList = {
      'ALT',
      'CTRL',
      'SHIFT',
      'ALT-CTRL',
      'ALT-SHIFT',
      'CTRL-SHIFT',
   };

   for idx, modKey in pairs(modKeysList) do
      local modKeyOption = UIDropDownMenu_CreateInfo();
      modKeyOption.text = modKey;
      modKeyOption.value = modKey;
      modKeyOption.func = selectModKey;

      UIDropDownMenu_AddButton(modKeyOption);

      if modKey == MAJ_Utils.userSelectedModKey then
         UIDropDownMenu_SetSelectedID(MAJ_DropDown_MarkingModKey, idx);
      end
   end
end

function MAJ_Utils:CreateDefaultOptions(frame)
   --## ==========================================================================
   --## Auto sort header text
   --## ==========================================================================
   local autoSortHeaderText = frame:CreateFontString(nil, 'OVERLAY');
   autoSortHeaderText:SetFontObject('GameFontNormal');
   autoSortHeaderText:SetPoint('TOPLEFT', frame.TitleBg, 'BOTTOMLEFT', 36, -36);
   autoSortHeaderText:SetText('Auto Sorting Options:');

   --## ==========================================================================
   --## Auto sort after marking items
   --## ==========================================================================
   local autoSortMarkingCheckbox = CreateFrame('CheckButton', 'MAJ_CheckBox_AutoSortMarking', frame, 'ChatConfigCheckButtonTemplate');
   autoSortMarkingCheckbox:SetPoint('TOPLEFT', frame.TitleBg, 'BOTTOMLEFT', 48, -60);

   local autoSortMarkingCheckboxLabel = _G[autoSortMarkingCheckbox:GetName() .. 'Text'];
   autoSortMarkingCheckboxLabel:SetPoint('TOPLEFT', autoSortMarkingCheckbox, 'RIGHT', 5, 7);

   autoSortMarkingCheckbox:SetScript('OnClick', function(checkbox)
      MAJ_Utils.autoSortMarking = checkbox:GetChecked();
   end);

   --## ==========================================================================
   --## Auto sort after selling items
   --## ==========================================================================
   local autoSortSellingCheckbox = CreateFrame('CheckButton', 'MAJ_CheckBox_AutoSortSelling', frame, 'ChatConfigCheckButtonTemplate');
   autoSortSellingCheckbox:SetPoint('TOPLEFT', frame.TitleBg, 'BOTTOMLEFT', 48, -84);

   local autoSortSellingCheckboxLabel = _G[autoSortSellingCheckbox:GetName() .. 'Text'];
   autoSortSellingCheckboxLabel:SetPoint('TOPLEFT', autoSortSellingCheckbox, 'RIGHT', 5, 7);

   autoSortSellingCheckbox:SetScript('OnClick', function(checkbox)
      MAJ_Utils.autoSortSelling = checkbox:GetChecked();
   end);

   --## ==========================================================================
   --## Disabling auto sorting and warning user if Baggins is installed
   --## ==========================================================================
   if (MAJ_Utils.isBagginsLoaded) then
      autoSortMarkingCheckbox.tooltip = 'DISABLED: Baggins is loaded and provides its own auto sort functionality.';
      autoSortMarkingCheckboxLabel:SetText('|cff717070Auto sort bags after Selling?|r');

      autoSortSellingCheckbox.tooltip = 'DISABLED: Baggins is loaded and provides its own auto sort functionality.';
      autoSortSellingCheckboxLabel:SetText('|cff717070Auto sort bags after Marking?|r');

      print(MAJ_Constants.bagginsLoadedWarning);

      autoSortMarkingCheckbox:Disable();
      autoSortSellingCheckbox:Disable();
   else
      autoSortMarkingCheckbox.tooltip = 'After an item gets marked, this will sort your bags (i.e. "click" the broom icon) automatically.';
      autoSortMarkingCheckboxLabel:SetText('Auto sort bags after Marking?');

      autoSortSellingCheckbox.tooltip = 'When you sell your items at a merchant, this will sort your bags (i.e. "click" the broom icon) automatically.';
      autoSortSellingCheckboxLabel:SetText('Auto sort bags after Selling?');
   end

   --## ==========================================================================
   --## Marking options header text
   --## ==========================================================================
   local markingOptionsHeaderText = frame:CreateFontString(nil, 'OVERLAY');
   markingOptionsHeaderText:SetFontObject('GameFontNormal');
   markingOptionsHeaderText:SetPoint('TOPLEFT', frame.TitleBg, 'BOTTOMLEFT', 36, -120);
   markingOptionsHeaderText:SetText('Marking Options:');

   --## ==========================================================================
   --## Marking modifier key heading text
   --## ==========================================================================
   local markingModKeyHeading = frame:CreateFontString(nil, 'OVERLAY');
   markingModKeyHeading:SetFontObject('GameFontWhite');
   markingModKeyHeading:SetPoint('TOPLEFT', frame.TitleBg, 'BOTTOMLEFT', 36, -144);
   markingModKeyHeading:SetText('Select your marking mod key...');

   --## ==========================================================================
   --## Marking modifier key drop down
   --## ==========================================================================
   local markingModKey = CreateFrame('Button', 'MAJ_DropDown_MarkingModKey', frame, 'UIDropDownMenuTemplate');
   markingModKey:SetPoint('TOPLEFT', frame.TitleBg, 'BOTTOMLEFT', 36, -168);

   UIDropDownMenu_Initialize(MAJ_DropDown_MarkingModKey, insertModKeyOptions)
   UIDropDownMenu_SetWidth(MAJ_DropDown_MarkingModKey, 120);
   UIDropDownMenu_SetButtonWidth(MAJ_DropDown_MarkingModKey, 120);

   --## ==========================================================================
   --## Marking activator key heading text
   --## ==========================================================================
   local activatorKeyHeading = frame:CreateFontString(nil, 'OVERLAY');
   activatorKeyHeading:SetFontObject('GameFontWhite');
   activatorKeyHeading:SetPoint('TOPLEFT', frame.TitleBg, 'BOTTOMLEFT', 36, -208);
   activatorKeyHeading:SetText('Select your marking activator...');

   --## ==========================================================================
   --## Marking activator key drop down
   --## ==========================================================================
   local markingActivatorKey = CreateFrame('Button', 'MAJ_DropDown_MarkingActivatorKey', frame, 'UIDropDownMenuTemplate');
   markingActivatorKey:SetPoint('TOPLEFT', frame.TitleBg, 'BOTTOMLEFT', 36, -232);

   UIDropDownMenu_Initialize(MAJ_DropDown_MarkingActivatorKey, insertActivatorKeyOptions)
   UIDropDownMenu_SetWidth(MAJ_DropDown_MarkingActivatorKey, 120);
   UIDropDownMenu_SetButtonWidth(MAJ_DropDown_MarkingActivatorKey, 120);

   --## ==========================================================================
   --## Miscellaneous options header text
   --## ==========================================================================
   local miscellaneousHeaderText = frame:CreateFontString(nil, 'OVERLAY');
   miscellaneousHeaderText:SetFontObject('GameFontNormal');
   miscellaneousHeaderText:SetPoint('TOPLEFT', frame.TitleBg, 'BOTTOMLEFT', 312, -36);
   miscellaneousHeaderText:SetText('Miscellaneous Options:');

   --## ==========================================================================
   --## Toggle slash command output in the chat box
   --## ==========================================================================
   local slashCommandOutputCheckbox = CreateFrame('CheckButton', 'MAJ_CheckBox_SlashCommandOutput', frame, 'ChatConfigCheckButtonTemplate');
   slashCommandOutputCheckbox:SetPoint('TOPLEFT', frame.TitleBg, 'BOTTOMLEFT', 324, -60);

   local slashCommandOutputCheckboxLabel = _G[slashCommandOutputCheckbox:GetName() .. 'Text'];
   slashCommandOutputCheckboxLabel:SetText('Show slash command output?');
   slashCommandOutputCheckboxLabel:SetPoint('TOPLEFT', slashCommandOutputCheckbox, 'RIGHT', 5, 7);
   slashCommandOutputCheckbox.tooltip = 'This will hide or show the chat output after entering in a ' .. MAJ_Constants.slashCommandQuoted .. ' command.';
   slashCommandOutputCheckbox:SetChecked(MAJ_Utils.showSlashCommandOutput);

   slashCommandOutputCheckbox:SetScript('OnClick', function(checkbox)
      MAJ_Utils.showSlashCommandOutput = checkbox:GetChecked();
   end);

   --## ==========================================================================
   --## Creating the Selling options
   --## ==========================================================================
   local sellingOptionsHeaderText = frame:CreateFontString(nil, 'OVERLAY');
   sellingOptionsHeaderText:SetFontObject('GameFontNormal');
   sellingOptionsHeaderText:SetPoint('TOPLEFT', frame.TitleBg, 'BOTTOMLEFT', 312, -120);
   sellingOptionsHeaderText:SetText('Selling Options:');
end
