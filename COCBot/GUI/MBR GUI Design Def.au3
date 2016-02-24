; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design  Def
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: araboy
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $chkinferno, $chkmortar, $chkwizard, $chktesla, $chkair, $chkarcher, $chkcanon

Global $slddefTolerance , $hdefGUI
Global $lblTolerancedef, $LblChDef

Func GUI3()
	$hdefGUI = GUICreate(GetTranslated(25,1, "Choose majeur Trap"), 305, 300, 85, 60, -1, $WS_EX_MDICHILD, $frmbot)
	GUISetIcon($pIconLib, $eIcnGUI)
	$gui2Open = 1
	GUISetOnEvent($GUI_EVENT_CLOSE, "CloseGUI3") ; Run this function when the secondary GUI [X] is clicked
	$LblChDef = GUICtrlCreateLabel(GetTranslated(25,2, "Choose which defense is majeur Trap"), 5, 5, 290, 28)
	$x = 5
	$y = 45
	Local $txtTip1 = GetTranslated(25,3, "If this box is checked, then the bot will look")
	$chkinferno = GUICtrlCreateCheckbox(GetTranslated(25,4, "Enable Inferno Tower detect"), $x, $y)
		$txtTip = $txtTip1&@CRLF&GetTranslated(15,5," Inferno Tower near TownHall.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkinferno")
	$y+= 25
	$chkmortar = GUICtrlCreateCheckbox(GetTranslated(25,6, "Enable Mortar detect"), $x, $y)
		$txtTip = $txtTip1&@CRLF&GetTranslated(15,7,"Mortar near TownHall.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkmortar")
	$y+= 25
	$chkwizard = GUICtrlCreateCheckbox(GetTranslated(25,8, "Enable Wizard detect"), $x, $y)
		$txtTip = $txtTip1&@CRLF&GetTranslated(25,9,"Wizard near TownHall.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkwizard")
	$y+= 25
	$chktesla = GUICtrlCreateCheckbox(GetTranslated(25,10, "Enable Tesla detect"), $x, $y)
		$txtTip = $txtTip1&@CRLF&GetTranslated(25,11," Tesla near TownHall.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chktesla")
	$y+= 25
	$chkair = GUICtrlCreateCheckbox(GetTranslated(25,12, "Enable Air defense detect"), $x, $y)
		$txtTip = $txtTip1&@CRLF&GetTranslated(25,13," Air defense near TownHall.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkair")
	$y+= 25
	$chkarcher = GUICtrlCreateCheckbox(GetTranslated(25,14, "Enable Archer detect"), $x, $y)
		$txtTip = $txtTip1&@CRLF&GetTranslated(25,15," Archer tower near TownHall.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkarcher")
	$y+= 25
	$chkcanon = GUICtrlCreateCheckbox(GetTranslated(25,16, "Enable Canon detect"), $x, $y)
		$txtTip = $txtTip1&@CRLF&GetTranslated(25,17," Canon near TownHall.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkcanon")


	$y+= 50

	$lblTolerancedef = GUICtrlCreateLabel("-8" & _PadStringCenter(GetTranslated(25,18, "Tolerance"), 80, " ") & "8", 5, $y - 15)
	$slddefTolerance = GUICtrlCreateSlider(5, $y, 290, 20, BITOR($TBS_TOOLTIPS, $TBS_AUTOTICKS)) ;,
	$txtTip = GetTranslated(25,19, "Use this slider to adjust the tolerance of ALL images.") &@CRLF& GetTranslated(25,20, "If you want to adjust individual images, you must edit the files.")
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetTip(-1, $txtTip)
		_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
		_GUICtrlSlider_SetTicFreq(-1,1)
		GUICtrlSetLimit(-1, 8,-8) ; change max/min value
		GUICtrlSetData(-1, 0) ; default value
		GUICtrlSetOnEvent(-1, "slddefTolerance")

	$y+=30
	$btnSaveExitdef = GUICtrlCreateButton(GetTranslated(25,21, "Save And Close"), 5, $y, 290, 20)
	GUICtrlSetOnEvent(-1, "CloseGUI3")

EndFunc
