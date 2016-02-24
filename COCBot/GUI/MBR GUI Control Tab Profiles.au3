; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
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

Func cmbProfile()
	saveConfig()

	FileClose($hLogFileHandle)
	FileClose($hAttackLogFileHandle)

	; Setup the profile in case it doesn't exist.
	setupProfile()

	readConfig()
	applyConfig()
	saveConfig()

	SetLog(_PadStringCenter("Profile " & $sCurrProfile & " loaded from " & $config, 50, "="), $COLOR_GREEN)
EndFunc   ;==>cmbProfile

Func btnAddConfirm()
	Switch GUICtrlRead($btnAddConfirm)
		Case "Add"
			GUICtrlSetState($cmbProfile, $GUI_HIDE)
			GUICtrlSetState($txtVillageName, $GUI_SHOW)
			GUICtrlSetData($btnAddConfirm, "Confirm")
			GUICtrlSetData($btnDeleteCancel, "Cancel")
			GUICtrlSetState($btnDeleteCancel, $GUI_ENABLE)
		Case "Confirm"
			Local $newProfileName = StringRegExpReplace(GUICtrlRead($txtVillageName), '[/:*?"<>|]', '_')
			If FileExists($sProfilePath & "\" & $newProfileName) Then
				MsgBox($MB_ICONWARNING, "Profile Already Exists", "A profile named " & $newProfileName & " already exists." & @CRLF & _
					"Please choose another name for your profile")
				Return
			EndIf

			$sCurrProfile = $newProfileName
			; Setup the profile if it doesn't exist.
			createProfile()
			setupProfileComboBox()
			setupProfileComboBoxswitch()
			selectProfile()
			GUICtrlSetState($txtVillageName, $GUI_HIDE)
			GUICtrlSetState($cmbProfile, $GUI_SHOW)
			GUICtrlSetData($btnAddConfirm, "Add")
			GUICtrlSetData($btnDeleteCancel, "Delete")
		Case Else
			SetLog("If you are seeing this log message there is something wrong.", $COLOR_RED)
	EndSwitch
EndFunc   ;==>btnAddConfirm

Func btnDeleteCancel()
	Switch GUICtrlRead($btnDeleteCancel)
		Case "Delete"
			Local $msgboxAnswer = MsgBox($MB_ICONWARNING + $MB_OKCANCEL, "Delete Profile", "Are you sure you really want to delete the profile?" & @CRLF & _
				"This action can not be undone.")
			If $msgboxAnswer = $IDOK Then
				; Confirmed profile deletion so delete it.
				deleteProfile()
				setupProfileComboBox()
				setupProfileComboBoxswitch()
				selectProfile()
			EndIf
		Case "Cancel"
			GUICtrlSetState($txtVillageName, $GUI_HIDE)
			GUICtrlSetState($cmbProfile, $GUI_SHOW)
			GUICtrlSetData($btnAddConfirm, "Add")
			GUICtrlSetData($btnDeleteCancel, "Delete")
		Case Else
			SetLog("If you are seeing this log message there is something wrong.", $COLOR_RED)
	EndSwitch

	If GUICtrlRead($cmbProfile) = "<No Profiles>" Then
		GUICtrlSetState($btnDeleteCancel, $GUI_DISABLE)
	EndIf
EndFunc   ;==>btnDeleteCancel
Func setupProfileComboBoxswitch()
		; Clear the combo box current data in case profiles were deleted
		GUICtrlSetData($cmbGoldMaxProfile, "", "")
		; Set the new data of available profiles
		GUICtrlSetData($cmbGoldMaxProfile, $profileString, "<No Profiles>")
		; Clear the combo box current data in case profiles were deleted
		GUICtrlSetData($cmbGoldMinProfile, "", "")
		; Set the new data of available profiles
		GUICtrlSetData($cmbGoldMinProfile, $profileString, "<No Profiles>")
		; Clear the combo box current data in case profiles were deleted
		GUICtrlSetData($cmbElixirMaxProfile, "", "")
		; Set the new data of available profiles
		GUICtrlSetData($cmbElixirMaxProfile, $profileString, "<No Profiles>")
		; Clear the combo box current data in case profiles were deleted
		GUICtrlSetData($cmbElixirMinProfile, "", "")
		; Set the new data of available profiles
		GUICtrlSetData($cmbElixirMinProfile, $profileString, "<No Profiles>")
		; Clear the combo box current data in case profiles were deleted
		GUICtrlSetData($cmbDEMaxProfile, "", "")
		; Set the new data of available profiles
		GUICtrlSetData($cmbDEMaxProfile, $profileString, "<No Profiles>")
		; Clear the combo box current data in case profiles were deleted
		GUICtrlSetData($cmbDEMinProfile, "", "")
		; Set the new data of available profiles
		GUICtrlSetData($cmbDEMinProfile, $profileString, "<No Profiles>")
		; Clear the combo box current data in case profiles were deleted
		GUICtrlSetData($cmbTrophyMaxProfile, "", "")
		; Set the new data of available profiles
		GUICtrlSetData($cmbTrophyMaxProfile, $profileString, "<No Profiles>")
		; Clear the combo box current data in case profiles were deleted
		GUICtrlSetData($cmbTrophyMinProfile, "", "")
		; Set the new data of available profiles
		GUICtrlSetData($cmbTrophyMinProfile, $profileString, "<No Profiles>")
EndFunc   ;==>setupProfileComboBox
