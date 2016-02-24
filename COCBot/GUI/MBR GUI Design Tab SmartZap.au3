; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design SmartZap
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

$tabSmartZap = GUICtrlCreateTabItem(GetTranslated(17,16,"SmartZap"))
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
    Local $x = 35, $y = 330

	   $grpzapTHS = GUICtrlCreateGroup(GetTranslated(17,13,"TH snipe DE Drill Zap"), $x - 20, $y - 20, 440, 70)
		$picSmartZapStatusDrill = GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x - 16, $y, 24, 24)
		$chkDrillZapTH = GUICtrlCreateCheckbox(GetTranslated(17,14,"Zap DE Drills"), $x + 12, $y+1, -1, -1)
			$txtTip = GetTranslated(17,15,"Use this if you want to Zap Drill when TH Snipping")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)

GUICtrlCreateTabItem("")