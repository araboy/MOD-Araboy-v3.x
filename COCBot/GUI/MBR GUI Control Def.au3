; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Def
; Description ...: This file Includes all functions to current GUI
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

Global $chkinfernoEnabled
Global $chkmortarEnabled
Global $chkwizardEnabled
Global $chkteslaEnabled
Global $chkairEnabled
Global $chkarcherEnabled
Global $chkcanonEnabled

Global $tolerancedefOffset

Func chkinferno()
	If GUICtrlRead($chkinferno) = $GUI_CHECKED Then
		$chkinfernoEnabled = "1"
	Else
		$chkinfernoEnabled = "0"
	EndIf
EndFunc
Func chkmortar()
	If GUICtrlRead($chkmortar) = $GUI_CHECKED Then
		$chkmortarEnabled = "1"

	Else
		$chkmortarEnabled = "0"

	EndIf
EndFunc
Func chkwizard()
	If GUICtrlRead($chkwizard) = $GUI_CHECKED Then
		$chkwizardEnabled = "1"

	Else
		$chkwizardEnabled = "0"

	EndIf
EndFunc
Func chktesla()
	If GUICtrlRead($chktesla) = $GUI_CHECKED Then
		$chkteslaEnabled = "1"

	Else
		$chkteslaEnabled = "0"

	EndIf
EndFunc
Func chkair()
	If GUICtrlRead($chkair) = $GUI_CHECKED Then
		$chkairEnabled = "1"

	Else
		$chkairEnabled = "0"

	EndIf
EndFunc
Func chkarcher()
	If GUICtrlRead($chkarcher) = $GUI_CHECKED Then
		$chkarcherEnabled = "1"

	Else
		$chkarcherEnabled = "0"

	EndIf
EndFunc
Func chkcanon()
	If GUICtrlRead($chkcanon) = $GUI_CHECKED Then
		$chkcanonEnabled = "1"

	Else
		$chkcanonEnabled = "0"

	EndIf
EndFunc

Func slddefTolerance()
	$tolerancedefOffset = GUICtrlRead($slddefTolerance)
EndFunc
Func readdefConfig()
	$chkinfernoEnabled = IniRead($config,"def", "infernoEnabled", "1")
	$chkmortarEnabled = IniRead($config,"def", "mortarEnabled", "1")
	$chkwizardEnabled = IniRead($config,"def", "wizardEnabled", "1")
	$chkteslaEnabled = IniRead($config,"def", "teslaEnabled", "1")
	$chkairEnabled = IniRead($config,"def", "airEnabled", "0")
	$chkarcherEnabled = IniRead($config,"def", "archerEnabled", "0")
	$chkcanonEnabled = IniRead($config,"def", "canonEnabled", "0")

	$tolerancedefOffset = IniRead($config, "def", "deftolerance", "0")
EndFunc
Func savedefConfig()
	Iniwrite($config,"def", "infernoEnabled", $chkinfernoEnabled)
	Iniwrite($config,"def", "mortarEnabled", $chkmortarEnabled)
	Iniwrite($config,"def", "wizardEnabled", $chkwizardEnabled)
	Iniwrite($config,"def", "teslaEnabled", $chkteslaEnabled)
	Iniwrite($config,"def", "airEnabled", $chkairEnabled)
	Iniwrite($config,"def", "archerEnabled", $chkarcherEnabled)
	Iniwrite($config,"def", "canonEnabled", $chkcanonEnabled)

	IniWrite($config, "def", "deftolerance", $tolerancedefOffset)
EndFunc
Func applydefConfig()
	If $chkinfernoEnabled = "1" Then
		GUICtrlSetState($chkinferno, $GUI_CHECKED)

	Else
		GUICtrlSetState($chkinferno, $GUI_UNCHECKED)

	EndIf
	If $chkmortarEnabled = "1" Then
		GUICtrlSetState($chkmortar, $GUI_CHECKED)

	Else
		GUICtrlSetState($chkmortar, $GUI_UNCHECKED)

	EndIf
	If $chkwizardEnabled = "1" Then
		GUICtrlSetState($chkwizard, $GUI_CHECKED)

	Else
		GUICtrlSetState($chkwizard, $GUI_UNCHECKED)

	EndIf
	If $chkteslaEnabled = "1" Then
		GUICtrlSetState($chktesla, $GUI_CHECKED)

	Else
		GUICtrlSetState($chktesla, $GUI_UNCHECKED)

	EndIf
	If $chkairEnabled = "1" Then
		GUICtrlSetState($chkair, $GUI_CHECKED)

	Else
		GUICtrlSetState($chkair, $GUI_UNCHECKED)

	EndIf
	If $chkarcherEnabled = "1" Then
		GUICtrlSetState($chkarcher, $GUI_CHECKED)

	Else
		GUICtrlSetState($chkarcher, $GUI_UNCHECKED)

	EndIf
	If $chkcanonEnabled = "1" Then
		GUICtrlSetState($chkcanon, $GUI_CHECKED)

	Else
		GUICtrlSetState($chkcanon, $GUI_UNCHECKED)

	EndIf


	GUICtrlSetData($slddefTolerance, $tolerancedefOffset)
EndFunc
Func OpenGUI3()
	GUI3()
	readdefConfig()
	applydefConfig()
	GUISetState(@SW_SHOW, $hdefGUI)
	GUISetState(@SW_DISABLE, $frmBot)
EndFunc
Func CloseGUI3()
	$gui2open = 0
	savedefConfig()
	GUIDelete($hdefGUI)
	GUISetState(@SW_ENABLE, $frmBot)
	WinActivate($frmBot)
EndFunc