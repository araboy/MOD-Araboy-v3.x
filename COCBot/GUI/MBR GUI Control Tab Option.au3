; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Controls Option
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

Func chkChangeFF()
	If GUICtrlRead($chkChangeFF) = $GUI_CHECKED Then
		GUICtrlSetState($lblChangeFF, $GUI_ENABLE)
		GUICtrlSetState($txtTHpercentCollectors, $GUI_ENABLE)
		GUICtrlSetState($cmbInsideCol, $GUI_ENABLE)
		GUICtrlSetState($txttilefromredline, $GUI_ENABLE)
	Else
		GUICtrlSetState($lblChangeFF, $GUI_DISABLE)
		GUICtrlSetState($txtTHpercentCollectors, $GUI_DISABLE)
		GUICtrlSetState($cmbInsideCol, $GUI_DISABLE)
		GUICtrlSetState($txttilefromredline, $GUI_DISABLE)
	EndIf
EndFunc ;==>chksavetroop

;Mod AttackHour
Func chkAttackHours()
	If GUICtrlRead($chkAttackHours) = $GUI_CHECKED Then
		For $i = $lbAttackHours1 To $lbAttackHoursPM
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		For $i = $lbAttackHours1 To $lbAttackHoursPM
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc

Func chkattackhoursE1()
	If GUICtrlRead($chkattackhoursE1) = $GUI_CHECKED And GUICtrlRead($chkattackhours0) = $GUI_CHECKED Then
		For $i = $chkattackhours0 To $chkattackhours11
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Next
	Else
		For $i = $chkattackhours0 To $chkattackhours11
			GUICtrlSetState($i, $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($chkattackhoursE1, $GUI_UNCHECKED)
EndFunc   ;==>chkattackhoursE1

Func chkattackhoursE2()
	If GUICtrlRead($chkattackhoursE2) = $GUI_CHECKED And GUICtrlRead($chkattackhours12) = $GUI_CHECKED Then
		For $i = $chkattackhours12 To $chkattackhours23
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Next
	Else
		For $i = $chkattackhours12 To $chkattackhours23
			GUICtrlSetState($i, $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($chkattackhoursE2, $GUI_UNCHECKED)
EndFunc ;==>chkAttackHours
;Mod AttackHour

;CocStats
Func chkCoCStats()
    If GUICtrlRead($chkCoCStats) = $GUI_CHECKED Then
	  GUICtrlSetState($txtAPIKey, $GUI_ENABLE)
    Else
	  GUICtrlSetState($txtAPIKey, $GUI_DISABLE)
	EndIf
EndFunc ;==> chkCoCStats
