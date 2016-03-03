; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design Option
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: RuiF
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

$tabOption = GUICtrlCreateTabItem(GetTranslated(17,16,"Option"))
	;;;;;;;;;;;;;;;;;
    ;;;;SmartZap;;;;;
    ;;;;;;;;;;;;;;;;;
    Local $x = 35, $y = 155
    $grpSmartZapAttack = GUICtrlCreateGroup(GetTranslated(17,1,"SmartZap Attack"), $x - 20, $y - 20, 218, 95)
		$picSmartZapAttackLS = GUICtrlCreateIcon($pIconLib, $eIcnLightSpell, $x - 10, $y + 20, 24, 24)
		$picSmartZapAttackDrill = GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x -10, $y - 7, 24, 24)
		$chkSmartLightSpell = GUICtrlCreateCheckbox(GetTranslated(17,2,"Use Lightning"), $x + 20, $y - 5, -1, -1)
			$txtTip = GetTranslated(17,3,"Check this to drop Lightning Spells on top of drills of Dark Elixir.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "SmartLightSpell")
		$chkTrainLightSpell = GUICtrlCreateCheckbox(GetTranslated(17,4,"Auto-Training of Spells"), $x + 20, $y + 20, -1, -1)
			$txtTip = GetTranslated(17,5,"This option is to continuously create lightning spells.")
			GUICtrlSetTip(-1, $txtTip)
		$lblSmartZapAttack = GUICtrlCreateLabel(GetTranslated(17,6,"Min. amount of Dark Elixir"), $x - 10, $y + 47, -1, -1)
		$txtMinDark = GUICtrlCreateInput("478", $x + 155, $y + 45, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		    $txtTip = GetTranslated(17,7,"The added value here depends a lot on what level is your TH, put a value between 500-1500.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 4)
			GUICtrlSetOnEvent(-1, "txtMinDark")
			GUICtrlSetState(-1, $GUI_DISABLE)
	Local $x =35, $y = 255
	   $grpStatsMiscTips = GUICtrlCreateGroup(GetTranslated(17,8,"Tips"), $x - 20, $y - 20, 440, 70)
	   $lblSmartZapTips = GUICtrlCreateLabel(GetTranslated(17,9,"Remember to go to the tab 'troops' and put the maximum capacity of your spell factory and the number of spells so that the bot can function perfectly."), $x -10, $y + 1, 420, 70, $SS_LEFT)
	Local $x =236, $y = 155
		$grpStatuszap = GUICtrlCreateGroup(GetTranslated(17,10,"Status"), $x, $y - 20, 218, 95)
		$picSmartZapStatusDark = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 160, $y + 3, 24, 24)
		$lblSmartZap = GUICtrlCreateLabel("0", $x +60, $y + 5, 80, 30, $SS_RIGHT)
			GUICtrlSetFont(-1, 16, $FW_BOLD, Default, "arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, 0x279B61)
		$txtTip = GetTranslated(17,11,"Number of dark elixir zapped during the attack with lightning.")
			GUICtrlSetTip(-1, $txtTip)
		$picSmartZapStatusSP = GUICtrlCreateIcon($pIconLib, $eIcnLightSpell, $x + 160, $y + 40, 24, 24)
		$lblLightningUsed = GUICtrlCreateLabel("0", $x +60, $y + 40, 80, 30, $SS_RIGHT)
			GUICtrlSetFont(-1, 16, $FW_BOLD, Default, "arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1,0x279B61)
			$txtTip = GetTranslated(17,12,"Amount of used spells.")
			GUICtrlSetTip(-1, $txtTip)
    Local $x = 35, $y = 325

	   $grpzapTHS = GUICtrlCreateGroup(GetTranslated(17,13,"TH snipe DE Drill Zap"), $x - 20, $y - 20, 220, 85)
		$picSmartZapStatusDrill = GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x - 10, $y, 24, 24)
		$chkDrillZapTH = GUICtrlCreateCheckbox(GetTranslated(17,14,"Zap DE Drills"), $x + 20, $y+1, -1, -1)
			$txtTip = GetTranslated(17,15,"Use this if you want to Zap Drill when TH Snipping")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)

	Local $x = 15, $y = 390
	$grpSaveTroops = GUICtrlCreateGroup(GetTranslated(17,19,"Save Troops"), $x , $y , 440, 85)
		$txtTip = GetTranslated(17,20,"If collectors outside less than Percent Do Action")
		$chkChangeFF = GUICtrlCreateCheckbox(GetTranslated(17,21,"Outside collector"), $x + 10, $y +12, -1, -1)
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "chkChangeFF")
		$lbloutsidecol = GUICtrlCreateLabel(GetTranslated(17,22,"If outside collector is less than "), $x + 10 , $y + 34, -1, -1)
		GUICtrlSetTip(-1, $txtTip)
		$txtTHpercentCollectors = GUICtrlCreateInput("80", $x + 155 , $y + 34, 21, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetLimit(-1, 3)
		$lblChangeFF = GUICtrlCreateLabel(GetTranslated(17,23,"% Use "), $x + 180 , $y + 36, -1, -1)
		GUICtrlSetTip(-1, $txtTip)
		$cmbInsideCol = GUICtrlCreateCombo("", $x + 220, $y +34, 64, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "4Sides|4Fingers|Return", "4Fingers")
		$lbloutsidecollector = GUICtrlCreateLabel(GetTranslated(17,24,"Distance between red line and collector <"), $x + 10 , $y + 65, -1, -1)
		GUICtrlSetTip(-1, $txtTip)
		$txttilefromredline = GUICtrlCreateInput("5", $x + 210 , $y + 60, 21, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		$txtTip = GetTranslated(17,26,"set Number tile(s) from Redline")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetLimit(-1, 2)
		$lbloutsidecollector2 = GUICtrlCreateLabel(GetTranslated(17,25,"Tile(s)"), $x + 235 , $y + 65, -1, -1)
		GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)


	;Mod AttackHour
	Local $x = 258, $y = 325
	$grpScheduler3 = GUICtrlCreateGroup(GetTranslated(17,27, "Attack Scheduler"), $x - 20, $y - 20, 220, 85)
		$chkattackHours = GUICtrlCreateCheckbox(GetTranslated(17,28, "Only during these hours of day"), $x-15, $y-7)
		$y += 13
		$x -= 25
		GUICtrlSetOnEvent(-1, "chkattackHours")
		$lbattackhours1 = GUICtrlCreateLabel(" 0", $x + 30, $y)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$lbattackhours2 = GUICtrlCreateLabel(" 1", $x + 45, $y)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$lbattackhours3 = GUICtrlCreateLabel(" 2", $x + 60, $y)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$lbattackhours4 = GUICtrlCreateLabel(" 3", $x + 75, $y)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$lbattackhours5 = GUICtrlCreateLabel(" 4", $x + 90, $y)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$lbattackhours6 = GUICtrlCreateLabel(" 5", $x + 105, $y)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$lbattackhours7 = GUICtrlCreateLabel(" 6", $x + 120, $y)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$lbattackhours8 = GUICtrlCreateLabel(" 7", $x + 135, $y)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$lbattackhours9 = GUICtrlCreateLabel(" 8", $x + 150, $y)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$lbattackhours10 = GUICtrlCreateLabel(" 9", $x + 165, $y)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$lbattackhours11 = GUICtrlCreateLabel("10", $x + 180, $y)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$lbattackhours12 = GUICtrlCreateLabel("11", $x + 195, $y)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$y += 15
		$chkattackhours0 = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$chkattackhours1 = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$chkattackhours2 = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$chkattackhours3 = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$chkattackhours4 = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$chkattackhours5 = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$chkattackhours6 = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$chkattackhours7 = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$chkattackhours8 = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$chkattackhours9 = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$chkattackhours10 = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$chkattackhours11 = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$chkattackhoursE1 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
		GUICtrlSetImage(-1, $pIconLib, $eIcnGoldStar, 0)
		GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)
		$txtTip = GetTranslated(20,50, "This button will clear or set the entire row of boxes")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "chkattackhoursE1")
		$lbattackhoursAM = GUICtrlCreateLabel("AM", $x + 10, $y)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$y += 15
		$chkattackhours12 = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$chkattackhours13 = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$chkattackhours14 = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$chkattackhours15 = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$chkattackhours16 = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$chkattackhours17 = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$chkattackhours18 = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$chkattackhours19 = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$chkattackhours20 = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$chkattackhours21 = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$chkattackhours22 = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$chkattackhours23 = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$chkattackhoursE2 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
		GUICtrlSetImage(-1, $pIconLib, $eIcnGoldStar, 0)
		GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)
		$txtTip = GetTranslated(20,50, "This button will clear or set the entire row of boxes")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "chkattackhoursE2")
		$lbattackhoursPM = GUICtrlCreateLabel("PM", $x + 10, $y)
		GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
;--> Mod AttackHour


		$x = 25
		$y = 480
		$chkCoCStats = GUICtrlCreateCheckbox("CoCStats Activate", $x , $y , -1, -1)
		$txtTip = "Activate sending raid results to CoCStats.com"
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "chkCoCStats")
		$x += 130
		$lblAPIKey = GUICtrlCreateLabel("API Key :", $x, $y+5 , -1, 21, $SS_LEFT)
		$txtAPIKey = GUICtrlCreateInput("", $x + 40, $y , 200, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
		$txtTip = "Join in CoCStats.com and input API Key here"
		GUICtrlSetTip(-1, $txtTip)



GUICtrlCreateTabItem("")