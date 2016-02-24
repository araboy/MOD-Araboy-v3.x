; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Controls SmartZap
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

;MBR GUI_SMARTZAP CONTROLS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Func SmartLightSpell()
	If GUICtrlRead($chkSmartLightSpell) = $GUI_CHECKED Then
		GUICtrlSetState($txtMinDark, $GUI_ENABLE)
		GUICtrlSetState($chkTrainLightSpell, $GUI_ENABLE)
		$ichkSmartLightSpell = 1
	Else
		GUICtrlSetState($txtMinDark, $GUI_DISABLE)
		GUICtrlSetState($chkTrainLightSpell, $GUI_DISABLE)
		GUICtrlSetState($chkTrainLightSpell, $GUI_UNCHECKED)
		$ichkSmartLightSpell = 0

	EndIf
 EndFunc   ;==>GUILightSpell

Func autoLightSpell()
	If GUICtrlRead($chkTrainLightSpell) = $GUI_CHECKED Then
	  $ichkTrainLightSpell = 1
	  Else
      $ichkTrainLightSpell = 0
    EndIf

EndFunc


Func txtMinDark()
	$itxtMinDark = GUICtrlRead($txtMinDark)
	IniWrite($config, "options", "txtMinDark", $itxtMinDark)
EndFunc