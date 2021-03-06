; #FUNCTION# ====================================================================================================================
; Name ..........: Chatbot.au3
; Description ...: Sends chat messages in global and clan chat
; Syntax ........: chat
; Parameters ....: NA
; Return values .: NA
; Author ........:DankMemes
; Modified ......: Araboy(2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

#include <Process.au3>
#include <Array.au3>
#include <String.au3>

Func ChatbotChatOpen() ; open the chat area
	Click($aOpenChat[0] ,$aOpenChat[1] , 1, 0, "") ; open chat
    If _Sleep(1000) Then Return False
    Return True
EndFunc

Func ChatbotSelectClanChat() ; select clan tab
   Click($aClanTab[0] ,$aClanTab[1] , 1, 0, ""); switch to clan
   If _Sleep(1000) Then Return False
   Click( $aClanTab[0],$aClanTab[1] , 1, 0, ""); scroll to top
   If _Sleep(1000) Then Return False
   Return True
EndFunc

Func ChatbotSelectGlobalChat() ; select global tab
   Click( 76, 22, 1, 0, ""); switch to globa
   If _Sleep(1000) Then Return False
   Return True
EndFunc

Func ChatbotChatClose() ; close chat area
   Click($aChatTab[0] ,$aChatTab[1] , 1, 0, ""); close chat
   waitMainScreen()
   Return True
EndFunc

Func ChatbotChatClanInput() ; select the textbox for clan chat
   Click(112 ,97 , 1, 0, ""); select the textbox
   If _Sleep(1000) Then Return False
   Return True
EndFunc

Func ChatbotChatGlobalInput() ; select the textbox for global chat
   Click(112 ,63 , 1, 0, ""); select the textbox
   If _Sleep(1000) Then Return False
   Return True
EndFunc

Func ChatbotChatInput($message) ; input the text
   SendText($message)
   Return True
EndFunc

Func ChatbotChatSendClan() ; click send
   If _Sleep(1000) Then Return False
   Click(282 ,90 , 1, 0, ""); send
   If _Sleep(2000) Then Return False
   Return True
EndFunc

Func ChatbotChatSendGlobal() ; click send
   If _Sleep(1000) Then Return False
   Click(282 ,60 , 1, 0, ""); send
   If _Sleep(2000) Then Return False
   Return True
EndFunc

Func ChatbotStartTimer()
   $ChatbotStartTime = TimerInit()
EndFunc

Func ChatbotIsInterval()
   $Time_Difference = TimerDiff($ChatbotStartTime)
   If $Time_Difference > $ChatbotReadInterval * 1000 Then
	  Return True
   Else
	  Return False
   EndIf
EndFunc

; Returns the response from Botlibre or simsimi, if any
Func runHelper($msg, $isBotlibre) ; run a script to get a response from Botlibre.com or simsimi.com
    Dim  $Message = ''

    $HelperStartTime = TimerInit()
    $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	While $Message = ''
		$Time_Difference = TimerDiff($HelperStartTime)
		If $Time_Difference > 5000 Then
			SetLog("Chatbot helper is taking too long!", $COLOR_RED)
			Return ""
		EndIf

		SetLog("waiting for chatbot helper...")
		If  $isBotlibre = 1 Then
			$oHTTP.Open("Get", "http://www.botlibre.com/rest/botlibre/form-get-all-instances?sort=monthlyConnects" , False)
			$oHTTP.Send()
			$Result = $oHTTP.ResponseText
			local $botid = _StringBetween($Result, 'id="', '" name')
			$ibotid = $botid[0]
			$link = "http://www.botlibre.com/rest/botlibre/form-chat?instance="&$ibotid&"&message="
			$oHTTP.Open("Get", $link & $msg , False)
			$oHTTP.Send()
			$Result = $oHTTP.ResponseText
			local $chatpm = _StringBetween($Result, 'sage>', '</mes')
			$Message = _ArrayToString($chatpm)
		Else
			$simsimitoken = "16a6fc86-2f0c-48ec-b1cb-3b10195b3eea"  ;  change this key with a paid plan key http://developer.simsimi.com/
			$link = "http://sandbox.api.simsimi.com/request.p?key="& $simsimitoken &"&lc=en&ft=1.0&text="
			$oHTTP.Open("Get", $link & $msg , False)
			$oHTTP.Send()
			$Result = $oHTTP.ResponseText
			local $chatpm = _StringBetween($Result, 'onse":"', '","')
			$Message = _ArrayToString($chatpm)
		EndIf
	WEnd

   Return $Message
EndFunc

Func ChatbotIsLastChatNew() ; returns true if the last chat was not by you, false otherwise
;~     _CaptureRegion()
;~     For $x = 36 To 60
;~ 		If _ColorCheck(_GetPixelColor($x, 137), Hex(0x92ee4d, 6), 5) Then Return False ; detect the green name
;~ 		Next
;~     Return True
	If $iCheckSumchat = PixelChecksum(15, 155, 265, 265,"",$Title,"") Then
		Return False
	Else
		$iCheckSumchat = PixelChecksum(15, 155, 265, 265,"",$Title,"")
		Return True
	EndIf

EndFunc

Func ChatbotPushbulletSendChat()
   If $ichkChatPushbullet = 0 Then Return
   _CaptureRegion(0, 0, 320, 675)
   Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
   Local $Time = @HOUR & "." & @MIN

   $ChatFile = $Date & "__" & $Time & ".jpg" ; separator __ is need  to not have conflict with saving other files if $TakeSS = 1 and $chkScreenshotLootInfo = 0
   _GDIPlus_ImageSaveToFile($hBitmap, $dirLoots & $ChatFile)
   _GDIPlus_ImageDispose($hBitmap)
   ;push the file
   SetLog("Chatbot: Sent chat image", $COLOR_GREEN)
   _PushFile($ChatFile, "Loots", "image/jpeg", $iOrigPushB & " | Last Clan Chats" & "\n" & $ChatFile)
   ;wait a second and then delete the file
   _Sleep(500)
   Local $iDelete = FileDelete($dirLoots & $ChatFile)
   If Not ($iDelete) Then SetLog("Chatbot: Failed to delete temp file", $COLOR_RED)
EndFunc

Func ChatbotPushbulletQueueChat($Chat)
   If $ichkChatPushbullet = 0 Then Return
   _ArrayAdd($ChatbotQueuedChats, $Chat)
EndFunc

Func ChatbotPushbulletQueueChatRead()
   If $ichkChatPushbullet = 0 Then Return
   $ChatbotReadQueued = True
EndFunc

Func ChatbotPushbulletStopChatRead()
   If $ichkChatPushbullet = 0 Then Return
   $ChatbotReadInterval = 0
   $ChatbotIsOnInterval = False
EndFunc

Func ChatbotPushbulletIntervalChatRead($Interval)
   If $ichkChatPushbullet = 0 Then Return
   $ChatbotReadInterval = $Interval
   $ChatbotIsOnInterval = True
   ChatbotStartTimer()
EndFunc

Func ChangeLanguageToEN()
Click(820 ,585 , 1, 0, "");settings
   Sleep(500)
Click(210 ,420 , 1, 0, "");language
;~    Sleep(1000)
;~    MouseWheel("up",5)      ;scroll up
   Sleep(1000)
  Click(170 ,175 , 1, 0, "");English
   Sleep(500)
Click(515 ,420 , 1, 0, "");language
   Sleep(1000)
EndFunc

Func ChangeLanguageToGER()
 Click(820 ,585 , 1, 0, "");settings
   Sleep(500)
 Click(210 ,420 , 1, 0, "");language
;~    Sleep(1000)
;~    MouseWheel("up",5)      ;scroll up
   Sleep(1000)
Click(170 ,280 , 1, 0, "");german
   Sleep(500)
Click(515 ,420 , 1, 0, "");language
   Sleep(1000)
EndFunc

; MAIN SCRIPT ==============================================

Func ChatbotMessage() ; run the chatbot

   If $ichkGlobalChat = 1 Then
	  SetLog("Chatbot: Sending some chats", $COLOR_GREEN)
   ElseIf $ichkClanChat = 1 Then
	  SetLog("Chatbot: Sending some chats", $COLOR_GREEN)
   EndIf


   If $ichkGlobalChat = 1 Then
	  If Not ChatbotChatOpen() Then Return
	  SetLog("Chatbot: Sending chats to global", $COLOR_GREEN)
	  ; assemble a message
	  Local $Message[4]
	  $Message[0] = $GlobalMessages1[Random(0, UBound($GlobalMessages1) - 1, 1)]
	  $Message[1] = $GlobalMessages2[Random(0, UBound($GlobalMessages2) - 1, 1)]
	  $Message[2] = $GlobalMessages3[Random(0, UBound($GlobalMessages3) - 1, 1)]
	  $Message[3] = $GlobalMessages4[Random(0, UBound($GlobalMessages4) - 1, 1)]
	  If $ichkGlobalScramble = 1 Then
		 _ArrayShuffle($Message)
	  EndIf
	  ; Send the message
	  If Not ChatbotSelectGlobalChat() Then Return
	  If Not ChatbotChatGlobalInput() Then Return
	  If Not ChatbotChatInput(_ArrayToString($Message, " ")) Then Return
	  If Not ChatbotChatSendGlobal() Then Return
	  If Not ChatbotChatClose() Then Return

	  If $ichkSwitchLang = 1 Then
		 SetLog("Chatbot: Switching languages", $COLOR_GREEN)
		 ChangeLanguageToGER()
		 waitMainScreen()
		 ChangeLanguageToEN()
		 waitMainScreen()
	  EndIf
   EndIf

    If $ichkClanChat = 1 Then
	  If Not ChatbotChatOpen() Then Return
	  SetLog("Chatbot: Sending chats to clan", $COLOR_GREEN)
	  If Not ChatbotSelectClanChat() Then Return

	  $SentClanChat = False

	  If $ChatbotReadQueued =1 Then
		 ChatbotPushbulletSendChat()
		 $ChatbotReadQueued = False
		 $SentClanChat = True
	  ElseIf $ChatbotIsOnInterval Then
		 If ChatbotIsInterval() Then
			ChatbotStartTimer()
			ChatbotPushbulletSendChat()
			$SentClanChat = True
		 EndIf
	  EndIf

	  If UBound($ChatbotQueuedChats) > 0 Then
		 SetLog("Chatbot: Sending pushbullet chats", $COLOR_GREEN)

		 For $a = 0 To UBound($ChatbotQueuedChats) - 1
			$ChatToSend = $ChatbotQueuedChats[$a]
			If Not ChatbotChatClanInput() Then Return
			If Not ChatbotChatInput($ChatToSend) Then Return
			If Not ChatbotChatSendClan() Then Return
		 Next

		 Dim $Tmp[0] ; clear queue
		 $ChatbotQueuedChats = $Tmp

		 ChatbotPushbulletSendChat()

		 If Not ChatbotChatClose() Then Return
		 SetLog("Chatbot: Done", $COLOR_GREEN)
		 Return
	  EndIf

	  If ChatbotIsLastChatNew() Then
		 ; get text of the latest message
		 $ChatMsg = StringStripWS(getOcrAndCapture("coc-latinA", 30, 148, 270, 13, False), 7)
		 SetLog("Found chat message: " & $ChatMsg, $COLOR_GREEN)
		 $SentMessage = False

		 If $ChatMsg = "" Or $ChatMsg = " " Then
			If $ichkUseGeneric = 1 Then
			   If Not ChatbotChatClanInput() Then Return
			   If Not ChatbotChatInput($ClanMessages[Random(0, UBound($ClanMessages) - 1, 1)]) Then Return
			   If Not ChatbotChatSendClan() Then Return
			   $SentMessage = True
			EndIf
		 EndIf

		 If $ichkUseResponses = 1 And Not $SentMessage Then
			For $a = 0 To UBound($ClanResponses) - 1
			   If StringInStr($ChatMsg, $ClanResponses[$a][0]) Then
				  $Response = $ClanResponses[$a][1]
				  SetLog("Sending response: " & $Response, $COLOR_GREEN)
				  If Not ChatbotChatClanInput() Then Return
				  If Not ChatbotChatInput($Response) Then Return
				  If Not ChatbotChatSendClan() Then Return
				  $SentMessage = True
				  ExitLoop
			   EndIf
			Next
		 EndIf

		 If ($ichkUseBotlibre = 1 Or $ichkUseSimsimi = 1) And Not $SentMessage Then
			$ChatResponse = runHelper($ChatMsg, $ichkUseBotlibre)
			SetLog("Got Botlibre response: " & $ChatResponse, $COLOR_GREEN)
			If  $ChatResponse = "" Or $ChatResponse = " " Then
			   If $ichkUseGeneric = 1 Then
				  If Not ChatbotChatClanInput() Then Return
				  If Not ChatbotChatInput($ClanMessages[Random(0, UBound($ClanMessages) - 1, 1)]) Then Return
				  If Not ChatbotChatSendClan() Then Return
				  $SentMessage = True
			   EndIf
			Else
			   If Not ChatbotChatClanInput() Then Return
			   If Not ChatbotChatInput($ChatResponse) Then Return
			   If Not ChatbotChatSendClan() Then Return
			EndIf
		 EndIf

		 If Not $SentMessage Then
			If $ichkUseGeneric =1 Then
			   If Not ChatbotChatClanInput() Then Return
			   If Not ChatbotChatInput($ClanMessages[Random(0, UBound($ClanMessages) - 1, 1)]) Then Return
			   If Not ChatbotChatSendClan() Then Return
			EndIf
		 EndIf

		 ; send it via pushbullet if it's new
		 ; putting the code here makes sure the (Botlibre, specifically) response is sent as well :P
		 If $ichkChatPushbullet =1 And $ichkPbSendNewChats =1 Then
			If Not $SentClanChat Then
				_Push("New chat message: "& $ChatMsg)
				ChatbotPushbulletSendChat()
			EndIf
		 EndIf
	  ElseIf $ichkUseGeneric =1 Then
		 If Not ChatbotChatClanInput() Then Return
		 If Not ChatbotChatInput($ClanMessages[Random(0, UBound($ClanMessages) - 1, 1)]) Then Return
		 If Not ChatbotChatSendClan() Then Return
	  EndIf

	  If Not ChatbotChatClose() Then Return
   EndIf
   If $ichkGlobalChat = 1 Then
	  SetLog("Chatbot: Done chatting", $COLOR_GREEN)
   ElseIf $ichkClanChat = 1 Then
	  SetLog("Chatbot: Done chatting", $COLOR_GREEN)
   EndIf
EndFunc
