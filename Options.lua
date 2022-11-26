function MAJ_Utils:CreateDefaultOptions(frame)
   --## ==========================================================================
   --## Auto-sort header text
   --## ==========================================================================
   local autoSortHeaderText = frame:CreateFontString(nil, 'OVERLAY');
   autoSortHeaderText:SetFontObject('GameFontNormal');
   autoSortHeaderText:SetPoint('TOPLEFT', frame.TitleBg, 'BOTTOMLEFT', 24, -24);
   autoSortHeaderText:SetText('Auto Sorting Options:');

   --## ==========================================================================
   --## Auto sort after marking items
   --## ==========================================================================
   local autoSortMarkingCheckbox = CreateFrame("CheckButton", "MAJ_CheckBox_AutoSortMarking", frame, "ChatConfigCheckButtonTemplate");
   autoSortMarkingCheckbox:SetPoint('TOPLEFT', frame.TitleBg, 'BOTTOMLEFT', 48, -48);
   local autoSortMarkingCheckboxLabel = _G[autoSortMarkingCheckbox:GetName() .. "Text"];
   autoSortMarkingCheckboxLabel:SetPoint('TOPLEFT', autoSortMarkingCheckbox, 'RIGHT', 5, 7);

   autoSortMarkingCheckbox:SetScript('OnClick', function(checkbox)
      MAJ_Utils.autoSortMarking = checkbox:GetChecked();
   end);

   --## ==========================================================================
   --## Auto sort after selling items
   --## ==========================================================================
   local autoSortSellingCheckbox = CreateFrame("CheckButton", "MAJ_CheckBox_AutoSortSelling", frame, "ChatConfigCheckButtonTemplate");
   autoSortSellingCheckbox:SetPoint('TOPLEFT', frame.TitleBg, 'BOTTOMLEFT', 48, -72);
   local autoSortSellingCheckboxLabel = _G[autoSortSellingCheckbox:GetName() .. "Text"];
   autoSortSellingCheckboxLabel:SetPoint('TOPLEFT', autoSortSellingCheckbox, 'RIGHT', 5, 7);

   autoSortSellingCheckbox:SetScript('OnClick', function(checkbox)
      MAJ_Utils.autoSortSelling = checkbox:GetChecked();
   end);

   --## ==========================================================================
   --## Disabling auto sorting and warning user if Baggins is installed
   --## ==========================================================================
   if (MAJ_Utils.isBagginsLoaded) then
      autoSortMarkingCheckbox.tooltip = 'DISABLED: Baggins is loaded and provides its own auto sort functionality.';
      autoSortMarkingCheckboxLabel:SetText('|cff717070Auto sort bags after selling?|r');
      autoSortSellingCheckbox.tooltip = 'DISABLED: Baggins is loaded and provides its own auto sort functionality.';
      autoSortSellingCheckboxLabel:SetText('|cff717070Auto sort bags after marking?|r');
      print(MAJ_Constants.bagginsLoadedWarning);
      autoSortMarkingCheckbox:Disable();
      autoSortSellingCheckbox:Disable();
   else
      autoSortMarkingCheckbox.tooltip = 'After an item gets marked, this will sort your bags (i.e. "click" the broom icon) automatically.';
      autoSortMarkingCheckboxLabel:SetText('Auto sort bags after selling?');
      autoSortSellingCheckbox.tooltip = 'When you sell your items at a merchant, this will sort your bags (i.e. "click" the broom icon) automatically.';
      autoSortSellingCheckboxLabel:SetText('Auto sort bags after marking?');
   end

   --## ==========================================================================
   --## Toggle slash command output in the chat box
   --## ==========================================================================
   local slashCommandOutputCheckbox = CreateFrame("CheckButton", "MAJ_CheckBox_SlashCommandOutput", frame, "ChatConfigCheckButtonTemplate");
   slashCommandOutputCheckbox:SetPoint('TOPLEFT', frame.TitleBg, 'BOTTOMLEFT', 24, -96);
   local slashCommandOutputCheckboxLabel = _G[slashCommandOutputCheckbox:GetName() .. "Text"];
   slashCommandOutputCheckboxLabel:SetText('Show slash command output?');
   slashCommandOutputCheckboxLabel:SetPoint('TOPLEFT', slashCommandOutputCheckbox, 'RIGHT', 5, 7);
   slashCommandOutputCheckbox.tooltip = 'This will hide or show the chat output after entering in a ' .. MAJ_Constants.slashCommandQuoted .. ' command.';
   slashCommandOutputCheckbox:SetChecked(MAJ_Utils.showSlashCommandOutput);

   slashCommandOutputCheckbox:SetScript('OnClick', function(checkbox)
      MAJ_Utils.showSlashCommandOutput = checkbox:GetChecked();
   end);
end
