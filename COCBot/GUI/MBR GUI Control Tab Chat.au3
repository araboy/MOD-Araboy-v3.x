; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Tab Chat
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015) ,Araboy(2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


Func Global_Chat()
	If GUICtrlRead($chkGlobalChat) = $GUI_CHECKED Then
		GUICtrlSetState($chkGlobalScramble, $GUI_ENABLE)
		GUICtrlSetState($chkSwitchLang , $GUI_ENABLE)
		GUICtrlSetState($editGlobalMessages1, $GUI_ENABLE)
		GUICtrlSetState($editGlobalMessages2 , $GUI_ENABLE)
		GUICtrlSetState($editGlobalMessages3 , $GUI_ENABLE)
		GUICtrlSetState($editGlobalMessages4, $GUI_ENABLE)
	Else
		GUICtrlSetState($chkGlobalScramble, $GUI_DISABLE)
		GUICtrlSetState($chkSwitchLang , $GUI_DISABLE)
		GUICtrlSetState($editGlobalMessages1 , $GUI_DISABLE)
		GUICtrlSetState($editGlobalMessages2 , $GUI_DISABLE)
		GUICtrlSetState($editGlobalMessages3, $GUI_DISABLE)
		GUICtrlSetState($editGlobalMessages4, $GUI_DISABLE)
	EndIf
EndFunc   ;===> Global_Chat()

Func Clan_Chat()
	If GUICtrlRead($chkClanChat) = $GUI_CHECKED Then
		GUICtrlSetState($chkUseResponses , $GUI_ENABLE)
		GUICtrlSetState($chkUseBotlibre , $GUI_ENABLE)
		GUICtrlSetState($chkUseSimsimi , $GUI_ENABLE)
		GUICtrlSetState($chkUseGeneric , $GUI_ENABLE)
		GUICtrlSetState($chkChatPushbullet , $GUI_ENABLE)
		GUICtrlSetState($chkPbSendNewChats , $GUI_ENABLE)
		GUICtrlSetState($editResponses , $GUI_ENABLE)
		GUICtrlSetState($editGeneric , $GUI_ENABLE)
	Else
		GUICtrlSetState($chkUseResponses , $GUI_DISABLE)
		GUICtrlSetState($chkUseBotlibre , $GUI_DISABLE)
		GUICtrlSetState($chkUseSimsimi , $GUI_DISABLE)
		GUICtrlSetState($chkUseGeneric , $GUI_DISABLE)
		GUICtrlSetState($chkChatPushbullet , $GUI_DISABLE)
		GUICtrlSetState($chkPbSendNewChats , $GUI_DISABLE)
		GUICtrlSetState($editResponses , $GUI_DISABLE)
		GUICtrlSetState($editGeneric , $GUI_DISABLE)
	EndIf
EndFunc   ;===> Clan_Chat()


Func ChatGuiCheckboxUpdate()
 	If GUICtrlRead($chkUseSimsimi) = $GUI_CHECKED Then
		GUICtrlSetState($chkUseBotlibre , $GUI_UNCHECKED)
	EndIf
EndFunc

Func ChatGuiCheckboxUpdate2()
	If GUICtrlRead($chkUseBotlibre) = $GUI_CHECKED Then
		GUICtrlSetState($chkUseSimsimi , $GUI_UNCHECKED)
	EndIf
EndFunc

