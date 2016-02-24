; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
$tabProfiles = GUICtrlCreateTabItem(GetTranslated(19,33,"Profiles"))

Local $x = 30, $y = 150
	$grpControls = GUICtrlCreateGroup(GetTranslated(19,1,"Profiles"), $x - 20, $y - 20, 450, 45)
		$lblProfile = GUICtrlCreateLabel(GetTranslated(19,2,"Current Profile:"), $x, $y, -1, -1)
		$cmbProfile = GUICtrlCreateCombo("", $x + 75, $y - 5, 220, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		$txtTip =GetTranslated(19,3, "Use this to switch to a different profile") & @CRLF & GetTranslated(19,4,"Your profiles can be found in") & ": " & @CRLF &  $sProfilePath
		GUICtrlSetTip(-1, $txtTip)
		setupProfileComboBox()
		GUICtrlSetState(-1, $GUI_SHOW)
		GUICtrlSetOnEvent(-1, "cmbProfile")
		$txtVillageName = GUICtrlCreateInput(GetTranslated(19,5,"MyVillage"), $x + 75, $y - 4, 220, 20, BitOR($SS_CENTER, $ES_AUTOHSCROLL))
		GUICtrlSetLimit (-1, 100, 0)
		GUICtrlSetFont(-1, 9, 400, 1)
		GUICtrlSetTip(-1, GetTranslated(19,6,"Your village/profile's name"))
		GUICtrlSetState(-1, $GUI_HIDE)
		$btnAddConfirm = GUICtrlCreateButton("Add", $x + 310, $y - 5, 45, 24)
		GUICtrlSetOnEvent(-1, "btnAddConfirm")
		$btnDeleteCancel = GUICtrlCreateButton("Delete", $x + 360, $y - 5, 45, 24)
		GUICtrlSetOnEvent(-1, "btnDeleteCancel")
		If GUICtrlRead($cmbProfile) = "<No Profiles>" Then
			GUICtrlSetState(-1, $GUI_DISABLE)
		Else
			GUICtrlSetState(-1, $GUI_ENABLE)
		EndIf
	GUICtrlCreateGroup("", -99, -99, 1, 1)

		$y -= 5

Local $x = 30, $y = 200
	$grpGoldSwitch = GUICtrlCreateGroup(GetTranslated(19,7,"Gold Switch Profile Conditions"), $x - 20, $y - 20, 450, 75) ;Gold Switch
		$chkGoldSwitchMax = GUICtrlCreateCheckbox(GetTranslated(19,8,"Switch To"), $x-10, $y - 5, -1, -1)
			$txtTip = GetTranslated(19,9,"Enable this to switch profiles when gold is above amount.")
			GUICtrlSetTip(-1, $txtTip)
		$cmbGoldMaxProfile = GUICtrlCreateCombo("", $x + 60, $y - 5, 75, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(19,10,"Select which profile to be switched to when conditions met")
			GUICtrlSetTip(-1, $txtTip)
		$lblGoldMax = GUICtrlCreateLabel(GetTranslated(19,11,"When Gold is Above"), $x + 145, $y, -1, -1)
		$txtMaxGoldAmount = GUICtrlCreateInput("6000000", $x + 275, $y - 5, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(19,12,"Set the amount of Gold to trigger switching Profile.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 7)
$y += 30
		$chkGoldSwitchMin = GUICtrlCreateCheckbox(GetTranslated(19,8,"Switch To"), $x-10, $y - 5, -1, -1)
			$txtTip = GetTranslated(19,13,"Enable this to switch profiles when gold is below amount.")
			GUICtrlSetTip(-1, $txtTip)
		$cmbGoldMinProfile = GUICtrlCreateCombo("", $x + 60, $y - 5, 75, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(19,10,"Select which profile to be switched to when conditions met")
			GUICtrlSetTip(-1, $txtTip)
		$lblGoldMin = GUICtrlCreateLabel(GetTranslated(19,14,"When Gold is Below"), $x + 145, $y, -1, -1)
		$txtMinGoldAmount = GUICtrlCreateInput("500000", $x + 275, $y - 5, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(19,12,"Set the amount of Gold to trigger switching Profile.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 7)
		$picProfileGold = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 360, $y - 40, 64, 64)
		$picProfileGold = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 350, $y - 30, 16, 16)
		$picProfileGold = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 330, $y - 15, 32, 32)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
$y += 50
	$grpElixirSwitch = GUICtrlCreateGroup(GetTranslated(19,15,"Elixir Switch Profile Conditions"), $x - 20, $y - 20, 450, 75) ; Elixir Switch
		$chkElixirSwitchMax = GUICtrlCreateCheckbox(GetTranslated(19,8,"Switch To"), $x-10, $y - 5, -1, -1)
			$txtTip = GetTranslated(19,16,"Enable this to switch profiles when Elixir is above amount.")
			GUICtrlSetTip(-1, $txtTip)

		$cmbElixirMaxProfile = GUICtrlCreateCombo("", $x + 60, $y - 5, 75, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(19,10,"Select which profile to be switched to when conditions met")
			GUICtrlSetTip(-1, $txtTip)
		$lblElixirMax = GUICtrlCreateLabel(GetTranslated(19,17,"When Elixir is Above"), $x + 145, $y, -1, -1)
		$txtMaxElixirAmount = GUICtrlCreateInput("6000000", $x + 275, $y - 5, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(19,18,"Set the amount of Elixir to trigger switching Profile.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 7)
$y += 30
		$chkElixirSwitchMin = GUICtrlCreateCheckbox(GetTranslated(19,8,"Switch To"), $x-10, $y - 5, -1, -1)
			$txtTip = GetTranslated(19,19,"Enable this to switch profiles when Elixir is below amount.")
			GUICtrlSetTip(-1, $txtTip)
		$cmbElixirMinProfile = GUICtrlCreateCombo("", $x + 60, $y - 5, 75, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(19,10,"Select which profile to be switched to when conditions met")
			GUICtrlSetTip(-1, $txtTip)
		$lblElixirMin = GUICtrlCreateLabel(GetTranslated(19,20,"When Elixir is Below"), $x + 145, $y, -1, -1)
		$txtMinElixirAmount = GUICtrlCreateInput("500000", $x + 275, $y - 5, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(19,18,"Set the amount of Elixir to trigger switching Profile.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 7)
		$picProfileElixir = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 360, $y - 40, 64, 64)
		$picProfileElixir = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 350, $y - 30, 16, 16)
		$picProfileElixir = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 330, $y - 15, 32, 32)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
$y += 50
	$grpDESwitch = GUICtrlCreateGroup(GetTranslated(19,21,"Dark Elixir Switch Profile Conditions"), $x - 20, $y - 20, 450, 75) ;DE Switch
		$chkDESwitchMax = GUICtrlCreateCheckbox(GetTranslated(19,8,"Switch To"), $x-10, $y - 5, -1, -1)
			$txtTip = GetTranslated(19,22,"Enable this to switch profiles when Dark Elixir is above amount.")
			GUICtrlSetTip(-1, $txtTip)
		$cmbDEMaxProfile = GUICtrlCreateCombo("", $x + 60, $y - 5, 75, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(19,10,"Select which profile to be switched to when conditions met")
			GUICtrlSetTip(-1, $txtTip)
		$lblDEMax = GUICtrlCreateLabel(GetTranslated(19,23,"When Dark Elixir is Above"), $x + 145, $y, -1, -1)
		$txtMaxDEAmount = GUICtrlCreateInput("200000", $x + 275, $y - 5, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(19,24,"Set the amount of Dark Elixir to trigger switching Profile.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
$y += 30
		$chkDESwitchMin = GUICtrlCreateCheckbox(GetTranslated(19,8,"Switch To"), $x-10, $y - 5, -1, -1)
			$txtTip = GetTranslated(19,25,"Enable this to switch profiles when Dark Elixir is below amount.")
			GUICtrlSetTip(-1, $txtTip)
		$cmbDEMinProfile = GUICtrlCreateCombo("", $x + 60, $y - 5, 75, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(19,10,"Select which profile to be switched to when conditions met")
			GUICtrlSetTip(-1, $txtTip)
		$lblDEMin = GUICtrlCreateLabel(GetTranslated(19,26,"When  Dark Elixir is Below"), $x + 145, $y, -1, -1)
		$txtMinDEAmount = GUICtrlCreateInput("10000", $x + 275, $y - 5, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(19,24,"Set the amount of Dark Elixir to trigger switching Profile.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
		$picProfileDE = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 360, $y - 40, 64, 64)
		$picProfileDE = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 350, $y - 30, 16, 16)
		$picProfileDE = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 330, $y - 15, 32, 32)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
$y += 50
	$grpTrophySwitch = GUICtrlCreateGroup(GetTranslated(19,27,"Trophy Switch Profile Conditions"), $x - 20, $y - 20, 450, 85) ; Trophy Switch
		$chkTrophySwitchMax = GUICtrlCreateCheckbox(GetTranslated(19,8,"Switch To"), $x-10, $y - 5, -1, -1)
			$txtTip = GetTranslated(19,28,"Enable this to switch profiles when Trophies are above amount.")
			GUICtrlSetTip(-1, $txtTip)
		$cmbTrophyMaxProfile = GUICtrlCreateCombo("", $x + 60, $y - 5, 75, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(19,10,"Select which profile to be switched to when conditions met")
			GUICtrlSetTip(-1, $txtTip)
		$lblTrophyMax = GUICtrlCreateLabel(GetTranslated(19,29,"When Trophies are Above"), $x + 145, $y, -1, -1)
		$txtMaxTrophyAmount = GUICtrlCreateInput("3000", $x + 275, $y - 5, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(19,30,"Set the amount of Trophies to trigger switching Profile.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 4)
$y += 30
		$chkTrophySwitchMin = GUICtrlCreateCheckbox(GetTranslated(19,8,"Switch To"), $x-10, $y - 5, -1, -1)
			$txtTip = GetTranslated(19,31,"Enable this to switch profiles when Trophies are below amount.")
			GUICtrlSetTip(-1, $txtTip)
		$cmbTrophyMinProfile = GUICtrlCreateCombo("", $x + 60, $y - 5, 75, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(19,10,"Select which profile to be switched to when conditions met")
			GUICtrlSetTip(-1, $txtTip)
		$lblTrophyMin = GUICtrlCreateLabel(GetTranslated(19,32,"When Trophies are Below"), $x + 145, $y, -1, -1)
		$txtMinTrophyAmount = GUICtrlCreateInput("1000", $x + 275, $y - 5, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(19,30,"Set the amount of Trophies to trigger switching Profile.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 4)
		$picProfileTrophy = GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 360, $y - 40, 64, 64)
		$picProfileTrophy = GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 345, $y - 35, 16, 16)
		$picProfileTrophy = GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 330, $y - 15, 32, 32)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
		setupProfileComboBoxswitch()
GUICtrlCreateTabItem("")