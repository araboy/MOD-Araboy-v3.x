; #FUNCTION# ====================================================================================================================
; Name ..........: PushBullet
; Description ...: This function will report to your mobile phone your values and last attack
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Antidote (2015-03)
; Modified ......: Sardo and Didipe (2015-05) rewrite code
;				   kgns (2015-06) $pushLastModified addition
;				   Sardo (2015-06) compliant with new pushbullet syntax (removed title)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

#include <Array.au3>
#include <String.au3>
#include <WinAPI.au3>

Func ansi2unicode($str)
	Local $keytxt = StringSplit($str,"\n",1)
	Local $aSRE = StringRegExp($keytxt[1], "\\u(....)", 3)
	For $i = 0 To UBound($aSRE) - 1
		$keytxt[1] = StringReplace($keytxt[1], "\u" & $aSRE[$i], BinaryToString("0x" & $aSRE[$i], 3))
	Next
	if $keytxt[0] > 1  Then
		$ansiStr = $keytxt[1] &"\n" & $keytxt[2]
	Else
		$ansiStr = $keytxt[1]
	EndIf
	Return $ansiStr
EndFunc

Func _RemoteControl()
    If $pEnabled = 0 and $pEnabled2 = 0 Or $pRemote = 0 Then Return
   If $pEnabled=1 then
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$access_token = $PushToken
	Local $pushbulletApiUrl
	If $pushLastModified = 0 Then
		$pushbulletApiUrl = "https://api.pushbullet.com/v2/pushes?active=true&limit=1" ; if this is the first time looking for pushes, get the last one
	Else
		$pushbulletApiUrl = "https://api.pushbullet.com/v2/pushes?active=true&modified_after=" & $pushLastModified ; get the one pushed after the last one received
	EndIf
	$oHTTP.Open("Get", $pushbulletApiUrl, False)
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()
	$Result = $oHTTP.ResponseText

	Local $modified = _StringBetween($Result, '"modified":', ',', "", False)
	If UBound($modified) > 0 Then
		$pushLastModified = Number($modified[0]) ; modified date of the newest push that we received
		$pushLastModified -= 120 ; back 120 seconds to avoid loss of messages
	EndIf


	Local $findstr = StringRegExp(StringUpper($Result), '"BODY":"BOT')
	If $findstr = 1 Then
		Local $body = _StringBetween($Result, '"body":"', '"', "", False)
		Local $iden = _StringBetween($Result, '"iden":"', '"', "", False)
		For $x = UBound($body) - 1 To 0 Step -1
			If $body <> "" Or $iden <> "" Then
				$body[$x] = StringUpper(StringStripWS($body[$x], $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES))
				$iden[$x] = StringStripWS($iden[$x], $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES)

				Switch $body[$x]
					Case "BOT HELP"
						Local $txtHelp = "You can remotely control your bot sending commands following this syntax:"
						$txtHelp &= '\n' & "BOT HELP - send this help message"
						$txtHelp &= '\n' & "BOT DELETE  - delete all your previous Push message"
						$txtHelp &= '\n' & "BOT <Village Name> RESTART - restart the bot named <Village Name> and bluestacks"
						$txtHelp &= '\n' & "BOT <Village Name> STOP - stop the bot named <Village Name>"
						$txtHelp &= '\n' & "BOT <Village Name> PAUSE - pause the bot named <Village Name>"
						$txtHelp &= '\n' & "BOT <Village Name> RESUME   - resume the bot named <Village Name>"
						$txtHelp &= '\n' & "BOT <Village Name> STATS - send Village Statistics of <Village Name>"
						$txtHelp &= '\n' & "BOT <Village Name> LOG - send the current log file of <Village Name>"
						$txtHelp &= '\n' & "BOT <Village Name> LASTRAID - send the last raid loot screenshot of <Village Name>"
						$txtHelp &= '\n' & "BOT <Village Name> LASTRAIDTXT - send the last raid loot values of <Village Name>"
						$txtHelp &= '\n' & "BOT <Village Name> SCREENSHOT - send a screenshot of <Village Name>"
						$txtHelp &= '\n' & "BOT <Village Name> SENDCHAT <TEXT> - send TEXT in clan chat of <Village Name>"
						$txtHelp &= '\n' & "BOT <Village Name> GETCHATS <STOP|NOW|INTERVAL> - select any of this three option to do"
						$txtHelp &= '\n'
						$txtHelp &= '\n' & "Examples:"
						$txtHelp &= '\n' & "Bot MyVillage Pause"
						$txtHelp &= '\n' & "Bot Delete "
						$txtHelp &= '\n' & "Bot MyVillage ScreenShot"
						_Push($iOrigPushB & " | Request for Help" & "\n" & $txtHelp)
						SetLog("Pushbullet: Your request has been received from ' " & $iOrigPushB & ". Help has been sent", $COLOR_GREEN)
						_DeleteMessage($iden[$x])
					Case "BOT " & StringUpper($iOrigPushB) & " PAUSE"
						If $TPaused = False And $Runstate = True Then
							TogglePauseImpl("Push")
						Else
							SetLog("Pushbullet: Your bot is currently paused, no action was taken", $COLOR_GREEN)
							_Push($iOrigPushB & " | Request to Pause" & "\n" & "Your bot is currently paused, no action was taken")
						EndIf
						_DeleteMessage($iden[$x])
					Case "BOT " & StringUpper($iOrigPushB) & " RESUME"
						If $TPaused = True And $Runstate = True Then
							TogglePauseImpl("Push")
						Else
							SetLog("Pushbullet: Your bot is currently resumed, no action was taken", $COLOR_GREEN)
							_Push($iOrigPushB & " | Request to Resume" & "\n" & "Your bot is currently resumed, no action was taken")
						EndIf
						_DeleteMessage($iden[$x])
					Case "BOT DELETE"
						_DeletePush($PushToken)
						SetLog("Pushbullet: Your request has been received.", $COLOR_GREEN)
					Case "BOT " & StringUpper($iOrigPushB) & " LOG"
						SetLog("Pushbullet: Your request has been received from " & $iOrigPushB & ". Log is now sent", $COLOR_GREEN)
						_PushFile($sLogFName, "logs", "text/plain; charset=utf-8", $iOrigPushB & " | Current Log " & "\n")
						_DeleteMessage($iden[$x])
					Case "BOT " & StringUpper($iOrigPushB) & " LASTRAID"
						If $AttackFile <> "" Then
							_PushFile($AttackFile, "Loots", "image/jpeg", $iOrigPushB & " | Last Raid " & "\n" & $AttackFile)
						Else
							_Push($iOrigPushB & " | There is no last raid screenshot.")
						EndIf
						SetLog("Pushbullet: Push Last Raid Snapshot...", $COLOR_GREEN)
						_DeleteMessage($iden[$x])
					Case "BOT " & StringUpper($iOrigPushB) & " LASTRAIDTXT"
						SetLog("Pusbullet: Your request has been received. Last Raid txt sent", $COLOR_GREEN)
						_Push($iOrigPushB & " | Last Raid txt" & "\n" & "[G]: " & _NumberFormat($iGoldLast) & " [E]: " & _NumberFormat($iElixirLast) & " [D]: " & _NumberFormat($iDarkLast) & " [T]: " & $iTrophyLast)
						_DeleteMessage($iden[$x])
					Case "BOT " & StringUpper($iOrigPushB) & " STATS"
						SetLog("Pushbullet: Your request has been received. Statistics sent", $COLOR_GREEN)
						_Push($iOrigPushB & " | Stats Village Report" & "\n" & "At Start\n[G]: " & _NumberFormat($iGoldStart) & " [E]: " & _NumberFormat($iElixirStart) & " [D]: " & _NumberFormat($iDarkStart) & " [T]: " & $iTrophyStart & "\n\nNow (Current Resources)\n[G]: " & _NumberFormat($iGoldCurrent) & " [E]: " & _NumberFormat($iElixirCurrent) & " [D]: " & _NumberFormat($iDarkCurrent) & " [T]: " & $iTrophyCurrent & " [GEM]: " & $iGemAmount & "\n \n [No. of Free Builders]: " & $iFreeBuilderCount & "\n [No. of Wall Up]: G: " & $iNbrOfWallsUppedGold & "/ E: " & $iNbrOfWallsUppedElixir & "\n\nAttacked: " & GUICtrlRead($lblresultvillagesattacked) & "\nSkipped: " & $iSkippedVillageCount)
						_DeleteMessage($iden[$x])
					Case "BOT " & StringUpper($iOrigPushB) & " SCREENSHOT"
						SetLog("Pushbullet: ScreenShot request received", $COLOR_GREEN)
						$RequestScreenshot = 1
						_DeleteMessage($iden[$x])
					Case "BOT " & StringUpper($iOrigPushB) & " RESTART"
						_DeleteMessage($iden[$x])
						SetLog("Your request has been received. Bot and BS restarting...", $COLOR_GREEN)
						_Push($iOrigPushB & " | Request to Restart..." & "\n" & "Your bot and BS are now restarting...")
						SaveConfig()
						_Restart()
					Case "BOT " & StringUpper($iOrigPushB) & " STOP"
						_DeleteMessage($iden[$x])
						SetLog("Your request has been received. Bot is now stopped", $COLOR_GREEN)
						If $Runstate = True Then
							_Push($iOrigPushB & " | Request to Stop..." & "\n" & "Your bot is now stopping...")
							btnStop()
						Else
							_Push($iOrigPushB & " | Request to Stop..." & "\n" & "Your bot is currently stopped, no action was taken")
						EndIf
					Case Else ;chat bot
						$startCmd = StringLeft($body[$x], StringLen("BOT " & StringUpper($iOrigPushB) & " SENDCHAT "))
						If $startCmd = "BOT " & StringUpper($iOrigPushB) & " SENDCHAT " Then
							$chatMessage = StringRight($body[$x], StringLen($body[$x]) - StringLen("BOT " & StringUpper($iOrigPushB) & " SENDCHAT "))
							$chatMessage = StringLower($chatMessage)
							ChatbotPushbulletQueueChat($chatMessage)
							_DeleteMessage($iden[$x])
							_Push($iOrigPushB & " | Chat queued, will send on next idle")
						Else
							$startCmd = StringLeft($body[$x], StringLen("BOT " & StringUpper($iOrigPushB) & " GETCHATS "))
							If $startCmd == "BOT " & StringUpper($iOrigPushB) & " GETCHATS " Then
								_DeleteMessage($iden[$x])
								$Interval = StringRight($body[$x], StringLen($body[$x]) - StringLen("BOT " & StringUpper($iOrigPushB) & " GETCHATS "))
								If $Interval = "STOP" Then
									ChatbotPushbulletStopChatRead()
									_Push($iOrigPushB & " | Stopping interval sending")
								ElseIf $Interval = "NOW" Then
									ChatbotPushbulletQueueChatRead()
									_Push($iOrigPushB & " | Command queued, will send clan chat image on next idle")
								Else
									ChatbotPushbulletIntervalChatRead(Number($Interval))
									_Push($iOrigPushB & " | Command queued, will send clan chat image on interval")
								EndIf
							Else
								Local $lenstr = StringLen("BOT " & StringUpper($iOrigPushB) & " ")
								Local $teststr = StringLeft($body[$x], $lenstr)
								If $teststr = ("BOT " & StringUpper($iOrigPushB) & " ") Then
									SetLog("Pushbullet: received command syntax wrong, command ignored.", $COLOR_RED)
									_Push($iOrigPushB & " | Command not recognized" & "\n" & "Please push BOT HELP to obtain a complete command list.")
									_DeleteMessage($iden[$x])
								EndIf
							EndIf
						EndIf
				EndSwitch

				$body[$x] = ""
				$iden[$x] = ""
			EndIf
		Next
	EndIf
   EndIf
  If $pEnabled2=1 then
	  ;$access_token2 = $PushToken2
	  $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	  $url= "https://api.telegram.org/bot"
	  $oHTTP.Open("Get", $url & $access_token2 & "/getupdates" , False)
	  $oHTTP.Send()
	  $Result = $oHTTP.ResponseText
	  Local $findstr2 = StringRegExp(StringUpper($Result), '"TEXT":"')
      If $findstr2 = 1 Then
	   local $rmessage = _StringBetween($Result, 'text":"' ,'"}}' )           ;take message
	   local $uid = _StringBetween($Result, 'update_id":' ,'"message"' )             ;take update id
	   local $lastmessage = _Arraypop($rmessage)								 ;take last message
	   local $lastuid = _Arraypop($uid)
	   Local $uclm = ansi2unicode($lastmessage)
	   local $iuclm = StringUpper(StringStripWS($uclm, $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES)) ;upercase & remove space laset message

	  if $first = 0 then
		  $first = 1
		  $lastremote = $lastuid
		  $oHTTP.Open("Get", $url & $access_token2 & "/getupdates?offset=" & $lastuid  , False)
	      $oHTTP.Send()
	   EndIf
	   if $lastremote <> $lastuid Then
      	 $lastremote = $lastuid
		 		 Switch $iuclm
					case "\/START"
						$oHTTP.Open("Post", "https://api.telegram.org/bot"&$access_token2&"/sendmessage", False)
		                $oHTTP.SetRequestHeader("Content-Type", "application/json")
						local $ppush3 = '{"text": "' & GetTranslated(18,48,"select your remote") & '", "chat_id":' & $chat_id2 &', "reply_markup": {"keyboard": [["' & GetTranslated(18,16,"Stop") & '\n\u23f9","' & GetTranslated(18,3,"Pause") & '\n\u23f8","' & GetTranslated(18,15,"Restart") & '\n\u21aa","' & GetTranslated(18,4,"Resume") & '\n\u25b6"],["' & GetTranslated(18,2,"Help") & '\n\u2753","' & GetTranslated(18,5,"Delete") & '\n\ud83d\udeae","' & GetTranslated(18,11,"Lastraid") & '\n\ud83d\udcd1","' & GetTranslated(18,13,"Stats") & '\n\ud83d\udcca"],["' & GetTranslated(18,14,"Screenshot") & '\n\ud83c\udfa6","' & GetTranslated(18,12,"Last raid txt") & '\n\ud83d\udcc4","' & GetTranslated(18,6,"Power") & '\n\ud83d\udda5"]],"one_time_keyboard": false,"resize_keyboard":true}}}'
						$oHTTP.Send($pPush3)
					Case GetTranslated(18,2,"Help") & "\N\U2753"
						 Local $txtHelp =  GetTranslated(18,17,"You can remotely control your bot by selecting this key")
						$txtHelp &= "\n" & GetTranslated(18,18,"HELP - send this help message")
						$txtHelp &= "\n" & GetTranslated(18,19,"DELETE  - Use this if Remote dont respond to your request")
						$txtHelp &= "\n" & GetTranslated(18,20,"RESTART - restart the bot and bluestacks")
						$txtHelp &= "\n" & GetTranslated(18,21,"STOP - stop the bot")
						$txtHelp &= "\n" & GetTranslated(18,22,"PAUSE - pause the bot")
						$txtHelp &= "\n" & GetTranslated(18,23,"RESUME   - resume the bot")
						$txtHelp &= "\n" & GetTranslated(18,24,"STATS - send Village Statistics")
						;$txtHelp &= "\n" & "LOG - send the current log file of <Village Name>"
						$txtHelp &= "\n" & GetTranslated(18,25,"LASTRAID - send the last raid loot screenshot. you should check Take Loot snapshot in End Battle Tab ")
						$txtHelp &= "\n" & GetTranslated(18,26,"LASTRAIDTXT - send the last raid loot values")
						$txtHelp &= "\n" & GetTranslated(18,27,"SCREENSHOT - send a screenshot")
						$txtHelp &= "\n" & GetTranslated(18,28,"POWER - select powr option")
						$txtHelp &= "\n"
						$txtHelp &= "\n" & GetTranslated(18,101,"Send and recieve chats via Telegram. Use GETCHATS <interval|NOW|STOP> to get the latest clan chat as an image, and SENDCHAT <chat message> to send a chat to your clan")
						_Push($iOrigPushB & " | " & GetTranslated(18,29,"Request for Help") & "\n" & $txtHelp)
						SetLog("Telegram: Your request has been received from ' " & $iOrigPushB & ". Help has been sent", $COLOR_GREEN)
					Case GetTranslated(18,3,"Pause") & "\N\U23F8"
						If $TPaused = False And $Runstate = True Then
						 TogglePauseImpl("Push")
						Else
						 SetLog("Telegram: Your bot is currently paused, no action was taken", $COLOR_GREEN)
						 _Push($iOrigPushB & " | " & GetTranslated(18,30,"Request to Pause") & "\n" & GetTranslated(18,93,"Your bot is currently paused, no action was taken"))
						EndIf
					Case GetTranslated(18,4,"Resume") & "\N\U25B6"
						If $TPaused = True And $Runstate = True Then
						 TogglePauseImpl("Push")
						Else
						 SetLog("Telegram: Your bot is currently resumed, no action was taken", $COLOR_GREEN)
						 _Push($iOrigPushB & " | " & GetTranslated(18,31,"Request to Resume") & "\n" & GetTranslated(18,94,"Your bot is currently resumed, no action was taken"))
						EndIf
					Case GetTranslated(18,5,"Delete") & "\N\UD83D\UDEAE"
		                $oHTTP.Open("Get", $url & $access_token2 & "/getupdates?offset=" & $lastuid  , False)
	                    $oHTTP.Send()
						SetLog("Telegram: Your request has been received.", $COLOR_GREEN)
					;Case "LOG\N\UD83D\UDCD1"
						;SetLog("Telegram: Your request has been received from " & $iOrigPushB & ". Log is now sent", $COLOR_GREEN)
						;_PushFile2($sLogFName, "logs", "text/plain; charset=utf-8", $iOrigPushB & " | Current Log " & "\n")
						;_PushFile2($sLogFName, "logs", "application\/octet-stream", $iOrigPushB & " | Current Log " & "\n")
						;_PushFile2($sLogFName, "logs", "application/octet-stream", $iOrigPushB & " | Current Log " & "\n")
					Case GetTranslated(18,6,"Power") & "\N\Ud83D\UDDA5"
						SetLog("Telegram: Your request has been received from " & $iOrigPushB & ". POWER option now sent", $COLOR_GREEN)
						$oHTTP.Open("Post", "https://api.telegram.org/bot"&$access_token2&"/sendmessage", False)
		                $oHTTP.SetRequestHeader("Content-Type", "application/json")
						local $ppush3 = '{"text": "' & GetTranslated(18,49,"select POWER option") & '", "chat_id":' & $chat_id2 &', "reply_markup": {"keyboard": [["'&GetTranslated(18,7,"Hibernate")&'\n\u26a0\ufe0f","'&GetTranslated(18,8,"Shut down")&'\n\u26a0\ufe0f","'&GetTranslated(18,9,"Standby")&'\n\u26a0\ufe0f"],["'&GetTranslated(18,10,"Cancel")&'"]],"one_time_keyboard": true,"resize_keyboard":true}}}'
						$oHTTP.Send($pPush3)
					Case GetTranslated(18,7,"Hibernate") & "\N\U26A0\UFE0F"
						SetLog("Telegram: Your request has been received from " & $iOrigPushB & ". Hibernate PC", $COLOR_GREEN)
						$oHTTP.Open("Post", "https://api.telegram.org/bot"&$access_token2&"/sendmessage", False)
						$oHTTP.SetRequestHeader("Content-Type", "application/json")
						local $ppush3 = '{"text": "' & GetTranslated(18,50,"PC got Hibernate") & '", "chat_id":' & $chat_id2 &', "reply_markup": {"keyboard": [["'&GetTranslated(18,16,"Stop")&'\n\u23f9","'&GetTranslated(18,3,"Pause")&'\n\u23f8","'&GetTranslated(18,15,"Restart")&'\n\u21aa","'&GetTranslated(18,4,"Resume")&'\n\u25b6"],["'&GetTranslated(18,2,"Help")&'\n\u2753","'&GetTranslated(18,5,"Delete")&'\n\ud83d\udeae","'&GetTranslated(18,11,"Lastraid")&'\n\ud83d\udcd1","'&GetTranslated(18,13,"Stats")&'\n\ud83d\udcca"],["'&GetTranslated(18,14,"Screenshot")&'\n\ud83c\udfa6","'&GetTranslated(18,12,"Last raid txt")&'\n\ud83d\udcc4","'&GetTranslated(18,6,"Power")&'\n\ud83d\udda5"]],"one_time_keyboard": false,"resize_keyboard":true}}}'
						$oHTTP.Send($pPush3)
						Shutdown(64)
					Case GetTranslated(18,8,"Shut down") & "\N\U26A0\UFE0F"
						SetLog("Telegram: Your request has been received from " & $iOrigPushB & ". Shut down PC", $COLOR_GREEN)
						$oHTTP.Open("Post", "https://api.telegram.org/bot"&$access_token2&"/sendmessage", False)
						$oHTTP.SetRequestHeader("Content-Type", "application/json")
						local $ppush3 = '{"text": "' & GetTranslated(18,51,"PC got Shutdown") & '", "chat_id":' & $chat_id2 &', "reply_markup": {"keyboard": [["'&GetTranslated(18,16,"Stop")&'\n\u23f9","'&GetTranslated(18,3,"Pause")&'\n\u23f8","'&GetTranslated(18,15,"Restart")&'\n\u21aa","'&GetTranslated(18,4,"Resume")&'\n\u25b6"],["'&GetTranslated(18,2,"Help")&'\n\u2753","'&GetTranslated(18,5,"Delete")&'\n\ud83d\udeae","'&GetTranslated(18,11,"Lastraid")&'\n\ud83d\udcd1","'&GetTranslated(18,13,"Stats")&'\n\ud83d\udcca"],["'&GetTranslated(18,14,"Screenshot")&'\n\ud83c\udfa6","'&GetTranslated(18,12,"Last raid txt")&'\n\ud83d\udcc4","'&GetTranslated(18,6,"Power")&'\n\ud83d\udda5"]],"one_time_keyboard": false,"resize_keyboard":true}}}'
						$oHTTP.Send($pPush3)
						Shutdown(5)
					Case GetTranslated(18,9,"Standby") & "\N\U26A0\UFE0F"
						SetLog("Telegram: Your request has been received from " & $iOrigPushB & ". Standby PC", $COLOR_GREEN)
						$oHTTP.Open("Post", "https://api.telegram.org/bot"&$access_token2&"/sendmessage", False)
						$oHTTP.SetRequestHeader("Content-Type", "application/json")
						local $ppush3 = '{"text": "' & GetTranslated(18,52,"PC got Standby") & '", "chat_id":' & $chat_id2 &', "reply_markup": {"keyboard": [["'&GetTranslated(18,16,"Stop")&'\n\u23f9","'&GetTranslated(18,3,"Pause")&'\n\u23f8","'&GetTranslated(18,15,"Restart")&'\n\u21aa","'&GetTranslated(18,4,"Resume")&'\n\u25b6"],["'&GetTranslated(18,2,"Help")&'\n\u2753","'&GetTranslated(18,5,"Delete")&'\n\ud83d\udeae","'&GetTranslated(18,11,"Lastraid")&'\n\ud83d\udcd1","'&GetTranslated(18,13,"Stats")&'\n\ud83d\udcca"],["'&GetTranslated(18,14,"Screenshot")&'\n\ud83c\udfa6","'&GetTranslated(18,12,"Last raid txt")&'\n\ud83d\udcc4","'&GetTranslated(18,6,"Power")&'\n\ud83d\udda5"]],"one_time_keyboard": false,"resize_keyboard":true}}}'
						$oHTTP.Send($pPush3)
						Shutdown(32)
					Case GetTranslated(18,10,"Cancel")
						SetLog("Telegram: Your request has been received from " & $iOrigPushB & ". Cancel Power option", $COLOR_GREEN)
						$oHTTP.Open("Post", "https://api.telegram.org/bot"&$access_token2&"/sendmessage", False)
						$oHTTP.SetRequestHeader("Content-Type", "application/json")
						local $ppush3 = '{"text": "' & GetTranslated(18,53,"canceled") & '", "chat_id":' & $chat_id2 &', "reply_markup": {"keyboard": [["'&GetTranslated(18,16,"Stop")&'\n\u23f9","'&GetTranslated(18,3,"Pause")&'\n\u23f8","'&GetTranslated(18,15,"Restart")&'\n\u21aa","'&GetTranslated(18,4,"Resume")&'\n\u25b6"],["'&GetTranslated(18,2,"Help")&'\n\u2753","'&GetTranslated(18,5,"Delete")&'\n\ud83d\udeae","'&GetTranslated(18,11,"Lastraid")&'\n\ud83d\udcd1","'&GetTranslated(18,13,"Stats")&'\n\ud83d\udcca"],["'&GetTranslated(18,14,"Screenshot")&'\n\ud83c\udfa6","'&GetTranslated(18,12,"Last raid txt")&'\n\ud83d\udcc4","'&GetTranslated(18,6,"Power")&'\n\ud83d\udda5"]],"one_time_keyboard": false,"resize_keyboard":true}}}'
						$oHTTP.Send($pPush3)
					Case GetTranslated(18,11,"Lastraid") & "\N\UD83D\UDCD1"
						 If $LootFileName <> "" Then
						 _PushFile($LootFileName, "Loots", "image/jpeg", $iOrigPushB & " | " & GetTranslated(18,95,"Last Raid") & "\n" & $LootFileName)
						Else
						 _Push($iOrigPushB & " | " & GetTranslated(18,32,"There is no last raid screenshot."))
						EndIf
						SetLog("Telegram: Push Last Raid Snapshot...", $COLOR_GREEN)
					Case GetTranslated(18,12,"Last raid txt") & "\N\UD83D\UDCC4"
						SetLog("Telegram: Your request has been received. Last Raid txt sent", $COLOR_GREEN)
						_Push($iOrigPushB & " | " & GetTranslated(18,33,"Last Raid txt") & "\n" & "[G]: " & _NumberFormat($iGoldLast) & " [E]: " & _NumberFormat($iElixirLast) & " [D]: " & _NumberFormat($iDarkLast) & " [T]: " & $iTrophyLast)
					Case GetTranslated(18,13,"Stats") & "\N\UD83D\UDCCA"
						SetLog("Telegram: Your request has been received. Statistics sent", $COLOR_GREEN)
						_Push($iOrigPushB & " | " & GetTranslated(18,34,"Stats Village Report") & "\n" & GetTranslated(18,35,"At Start") & "\n[G]: " & _NumberFormat($iGoldStart) & " [E]: " & _NumberFormat($iElixirStart) & " [D]: " & _NumberFormat($iDarkStart) & " [T]: " & $iTrophyStart & "\n\n" & GetTranslated(18,36,"Now (Current Resources)") & "\n[G]: " & _NumberFormat($iGoldCurrent) & " [E]: " & _NumberFormat($iElixirCurrent) & " [D]: " & _NumberFormat($iDarkCurrent) & " [T]: " & $iTrophyCurrent & " [GEM]: " & $iGemAmount & "\n \n[" & GetTranslated(18,37,"No. of Free Builders") &"]:"  & $iFreeBuilderCount & "\n [" & GetTranslated(18,38,"No. of Wall Up") & "]: G: " & $iNbrOfWallsUppedGold & "/ E: " & $iNbrOfWallsUppedElixir & "\n\n" & GetTranslated(18,39,"Attacked") & ": " & GUICtrlRead($lblresultvillagesattacked) & "\n" & GetTranslated(18,40,"Skipped") & ": " & $iSkippedVillageCount)
					Case GetTranslated(18,14,"Screenshot") & "\N\UD83C\UDFA6"
						SetLog("Telegram: ScreenShot request received", $COLOR_GREEN)
						$RequestScreenshot = 1
					Case GetTranslated(18,15,"Restart") & "\N\U21AA"
						SetLog("Telegram: Your request has been received. Bot and BS restarting...", $COLOR_GREEN)
						_Push($iOrigPushB & " | " & GetTranslated(18,41,"Request to Restart...") & "\n" & GetTranslated(18,42,"Your bot and BS are now restarting..."))
						SaveConfig()
						_Restart()
					Case GetTranslated(18,16,"Stop") & "\N\U23F9"
						SetLog("Telegram: Your request has been received. Bot is now stopped", $COLOR_GREEN)
						If $Runstate = True Then
						 _Push($iOrigPushB & " | " & GetTranslated(18,43,"Request to Stop...") & "\n" & GetTranslated(18,44,"Your bot is now stopping..."))
						 btnStop()
						Else
						 _Push($iOrigPushB & " | " & GetTranslated(18,43,"Request to Stop...") & "\n" & GetTranslated(18,45,"Your bot is currently stopped, no action was taken"))
						EndIf
					Case Else ; Chat Bot
						$startCmd = StringLeft($iuclm, StringLen("SENDCHAT "))
						If $startCmd = "SENDCHAT " Then
							$chatMessage = StringRight($iuclm, StringLen($iuclm) - StringLen("SENDCHAT "))
							$chatMessage = StringLower($chatMessage)
							ChatbotPushbulletQueueChat($chatMessage)
							_Push($iOrigPushB & " | " & GetTranslated(18,97,"Chat queued, will send on next idle"))
						Else
							$startCmd = StringLeft($iuclm, StringLen("GETCHATS "))
							If $startCmd == "GETCHATS " Then
								$Interval = StringRight($iuclm, StringLen($iuclm) - StringLen("GETCHATS "))
								If $Interval = "STOP" Then
									ChatbotPushbulletStopChatRead()
									_Push($iOrigPushB & " | " & GetTranslated(18,98,"Stopping interval sending"))
								ElseIf $Interval = "NOW" Then
									ChatbotPushbulletQueueChatRead()
									_Push($iOrigPushB & " | " & GetTranslated(18,99,"Command queued, will send clan chat image on next idle"))
								Else
									ChatbotPushbulletIntervalChatRead(Number($Interval))
									_Push($iOrigPushB & " | " & GetTranslated(18,100,"Command queued, will send clan chat image on interval"))
								EndIf
							Else
								Local $lenstr = StringLen("Test ")
								Local $teststr = StringLeft($iuclm, $lenstr)
								If $teststr = ("Test ") Then
									SetLog("Telegram: received command syntax wrong, command ignored.", $COLOR_RED)
									_Push($iOrigPushB & " | " & GetTranslated(18,46,"Command not recognized") & "\n" & GetTranslated(18,47,"Please push BOT HELP to obtain a complete command list."))
								EndIf
							EndIf
						EndIf
		 EndSwitch

	   EndIf
      EndIf
   EndIf
EndFunc   ;==>_RemoteControl

Func _PushBullet($pMessage = "")
    If ($pEnabled = 0 and $pEnabled2 = 0)  Or ($PushToken = "" and $PushToken2 = "") Then Return
    If $pEnabled = 1 Then
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$access_token = $PushToken
	$oHTTP.Open("Get", "https://api.pushbullet.com/v2/devices", False)
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.Send()
	$Result = $oHTTP.ResponseText
	Local $device_iden = _StringBetween($Result, 'iden":"', '"')
	Local $device_name = _StringBetween($Result, 'nickname":"', '"')
	Local $device = ""
	Local $pDevice = 1
	$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
	Local $Time = @HOUR & "." & @MIN
	Local $pPush = '{"type": "note", "body": "' & $pMessage & "\n" & $Date & "__" & $Time & '"}'
	$oHTTP.Send($pPush)
    EndIf
	if $pEnabled2= 1 then
		 $access_token2 = $PushToken2
		 $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		 $oHTTP.Open("Get", "https://api.telegram.org/bot" & $access_token2 & "/getupdates" , False)
		 $oHTTP.Send()
		 $Result = $oHTTP.ResponseText
		 local $chat_id = _StringBetween($Result, 'm":{"id":', ',"f')
		 $chat_id2 = _Arraypop($chat_id)
		 $oHTTP.Open("Post", "https://api.telegram.org/bot" & $access_token2&"/sendmessage", False)
		 $oHTTP.SetRequestHeader("Content-Type", "application/json")
	     Local $Date = @YEAR & '-' & @MON & '-' & @MDAY
		 Local $Time = @HOUR & '.' & @MIN
		 local $pPush3 = '{"text":"' & $pmessage & '\n' & $Date & '__' & $Time & '", "chat_id":' & $chat_id2 & '}}'
		 $oHTTP.Send($pPush3)
	  EndIf
EndFunc   ;==>_PushBullet

Func _Push($pMessage)
    If ($pEnabled = 0 and $pEnabled2 = 0)  Or ($PushToken = "" and $PushToken2 = "") Then Return
	If $pEnabled = 1 Then
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$access_token = $PushToken
	$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
	Local $Time = @HOUR & "." & @MIN
	Local $pPush = '{"type": "note", "body": "' & $pMessage & "\n" & $Date & "__" & $Time & '"}'
	$oHTTP.Send($pPush)
	EndIf
	If $pEnabled2= 1 then
		   $access_token2 = $PushToken2
		   $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		   $url= "https://api.telegram.org/bot"
		   $oHTTP.Open("Post",  $url & $access_token2&"/sendmessage", False)
		   $oHTTP.SetRequestHeader("Content-Type", "application/json")
		   Local $Date = @YEAR & '-' & @MON & '-' & @MDAY
	       Local $Time = @HOUR & '.' & @MIN
		   local $pPush3 = '{"text":"' & $pmessage & '\n' & $Date & '__' & $Time & '", "chat_id":' & $chat_id2 & '}}'
		   $oHTTP.Send($pPush3)
	EndIf
EndFunc   ;==>_Push

Func Getchatid()
    If $pEnabled2 = 0 Or $PushToken2 = "" Then Return
		$access_token2 = $PushToken2
		$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		$oHTTP.Open("Get", "https://api.telegram.org/bot" & $access_token2 & "/getupdates" , False)
		$oHTTP.Send()
		$Result = $oHTTP.ResponseText
		local $chat_id = _StringBetween($Result, 'm":{"id":', ',"f')
		$chat_id2 = _Arraypop($chat_id)
		$oHTTP.Open("Post", "https://api.telegram.org/bot"&$access_token2&"/sendmessage", False)
		$oHTTP.SetRequestHeader("Content-Type", "application/json")
		local $ppush3 = '{"text": "' & GetTranslated(18,48,"select your remote") & '", "chat_id":' & $chat_id2 &', "reply_markup": {"keyboard": [["'&GetTranslated(18,16,"Stop")&'\n\u23f9","'&GetTranslated(18,3,"Pause")&'\n\u23f8","'&GetTranslated(18,15,"Restart")&'\n\u21aa","'&GetTranslated(18,4,"Resume")&'\n\u25b6"],["'&GetTranslated(18,2,"Help")&'\n\u2753","'&GetTranslated(18,5,"Delete")&'\n\ud83d\udeae","'&GetTranslated(18,11,"Lastraid")&'\n\ud83d\udcd1","'&GetTranslated(18,13,"Stats")&'\n\ud83d\udcca"],["'&GetTranslated(18,14,"Screenshot")&'\n\ud83c\udfa6","'&GetTranslated(18,12,"Last raid txt")&'\n\ud83d\udcc4","'&GetTranslated(18,6,"Power")&'\n\ud83d\udda5"]],"one_time_keyboard": false,"resize_keyboard":true}}}'
		$oHTTP.Send($pPush3)
EndFunc   ;==>Getchatid

Func _PushFile($File, $Folder, $FileType, $body)
    If ($pEnabled = 0 and $pEnabled2 = 0)  Or ($PushToken = "" and $PushToken2 = "") Then Return
    If $pEnabled = 1 Then
	If FileExists($sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File) Then
		$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		$access_token = $PushToken
		$oHTTP.Open("Post", "https://api.pushbullet.com/v2/upload-request", False)
		$oHTTP.SetCredentials($access_token, "", 0)
		$oHTTP.SetRequestHeader("Content-Type", "application/json")

		Local $pPush = '{"file_name": "' & $File & '", "file_type": "' & $FileType & '"}'
		$oHTTP.Send($pPush)
		$Result = $oHTTP.ResponseText

		Local $upload_url = _StringBetween($Result, 'upload_url":"', '"')
		Local $awsaccesskeyid = _StringBetween($Result, 'awsaccesskeyid":"', '"')
		Local $acl = _StringBetween($Result, 'acl":"', '"')
		Local $key = _StringBetween($Result, 'key":"', '"')
		Local $signature = _StringBetween($Result, 'signature":"', '"')
		Local $policy = _StringBetween($Result, 'policy":"', '"')
		Local $file_url = _StringBetween($Result, 'file_url":"', '"')

		If IsArray($upload_url) And IsArray($awsaccesskeyid) And IsArray($acl) And IsArray($key) And IsArray($signature) And IsArray($policy) Then
			$Result = RunWait($pCurl & " -i -X POST " & $upload_url[0] & ' -F awsaccesskeyid="' & $awsaccesskeyid[0] & '" -F acl="' & $acl[0] & '" -F key="' & $key[0] & '" -F signature="' & $signature[0] & '" -F policy="' & $policy[0] & '" -F content-type="' & $FileType & '" -F file=@"' & $sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File & '"', "", @SW_HIDE)

			$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
			$oHTTP.SetCredentials($access_token, "", 0)
			$oHTTP.SetRequestHeader("Content-Type", "application/json")
			Local $pPush = '{"type": "file", "file_name": "' & $File & '", "file_type": "' & $FileType & '", "file_url": "' & $file_url[0] & '", "body": "' & $body & '"}'
			$oHTTP.Send($pPush)
		Else
			SetLog("Pusbullet: Unable to send file " & $File, $COLOR_RED)
			_Push($iOrigPushB & " | Unable to Upload File" & "\n" & "Occured an error type 1 uploading file to PushBullet server...")
		EndIf
	Else
		SetLog("Pushbullet: Unable to send file " & $File, $COLOR_RED)
		_Push($iOrigPushB & " | Unable to Upload File" & "\n" & "Occured an error type 2 uploading file to PushBullet server...")
	EndIf
	EndIf
	 If $pEnabled2=1 then
		 If FileExists($sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File) Then
			$access_token2 = $PushToken2
			$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
			Local $telegram_url = "https://api.telegram.org/bot" & $access_token2 & "/sendPhoto"
			$Result = RunWait($pCurl & " -i -X POST " & $telegram_url & ' -F chat_id="' & $chat_id2 &' " -F photo=@"' & $sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File  & '"', "", @SW_HIDE)
			$oHTTP.Open("Post", "https://api.telegram.org/bot" & $access_token2 & "/sendPhoto", False)
			$oHTTP.SetRequestHeader("Content-Type", "application/json")
			Local $pPush = '{"type": "file", "file_name": "' & $File & '", "file_type": "' & $FileType & '", "file_url": "' & $telegram_url & '", "body": "' & $body & '"}'
			$oHTTP.Send($pPush)
		 Else
			SetLog("Telegram: Unable to send file " & $File, $COLOR_RED)
			_Push($iOrigPushB & " | " & GetTranslated(18,54,"Unable to Upload File") & "\n" & GetTranslated(18,55,"Occured an error type 2 uploading file to Telegram server..."))
		 EndIf
	 EndIf
EndFunc   ;==>_PushFile

Func ReportPushBullet()
    If ($pEnabled = 0 and $pEnabled2 = 0)  Or ($PushToken = "" and $PushToken2 = "") Then Return
	If $iAlertPBVillage = 1 Then
		_PushBullet($iOrigPushB & " | " & GetTranslated(18,96,"My Village") & ":" & "\n" & " [G]: " & _NumberFormat($iGoldCurrent) & " [E]: " & _NumberFormat($iElixirCurrent) & " [D]: " & _NumberFormat($iDarkCurrent) & "  [T]: " & _NumberFormat($iTrophyCurrent) & " [FB]: " & _NumberFormat($iFreeBuilderCount))
	EndIf
	If $iLastAttack = 1 Then
		If Not ($iGoldLast = "" And $iElixirLast = "") Then _PushBullet($iOrigPushB & " | " & GetTranslated(18,56,"Last Gain") & ":" & "\n" & " [G]: " & _NumberFormat($iGoldLast) & " [E]: " & _NumberFormat($iElixirLast) & " [D]: " & _NumberFormat($iDarkLast) & "  [T]: " & _NumberFormat($iTrophyLast))
	EndIf
	If _Sleep($iDelayReportPushBullet1) Then Return
	checkMainScreen(False)
EndFunc   ;==>ReportPushBullet

Func _DeletePush($token)

    If $pEnabled = 0 Or $PushToken = "" Then Return
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$access_token = $token
	$oHTTP.Open("DELETE", "https://api.pushbullet.com/v2/pushes", False)
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()

EndFunc   ;==>_DeletePush

Func _DeleteMessage($iden)

    If $pEnabled = 0 Or $PushToken = "" Then Return
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$access_token = $PushToken
	$oHTTP.Open("Delete", "https://api.pushbullet.com/v2/pushes/" & $iden, False)
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()
	$iden = ""

EndFunc   ;==>_DeleteMessage

Func PushMsg($Message, $Source = "")

    If $pEnabled = 0 and $pEnabled2 = 0 Then Return
	Local $hBitmap_Scaled
	Switch $Message
		Case "Restarted"
			If ($pEnabled = 1 or $pEnabled2 = 1 ) And $pRemote = 1 Then _Push($iOrigPushB & " | " & GetTranslated(18,57,"Bot restarted"))
		Case "OutOfSync"
			If ($pEnabled = 1 or $pEnabled2 = 1 ) And $pOOS = 1 Then _Push($iOrigPushB & " | " & GetTranslated(18,58,"Restarted after Out of Sync Error") & "\n" & GetTranslated(18,59,"Attacking now..."))
		Case "LastRaid"
			If ($pEnabled = 1 or $pEnabled2 = 1 ) And $iAlertPBLastRaidTxt = 1 Then
				_Push($iOrigPushB & " | " & GetTranslated(18,60,"Last Raid txt") & "\n" & "[G]: " & _NumberFormat($iGoldLast) & " [E]: " & _NumberFormat($iElixirLast) & " [D]: " & _NumberFormat($iDarkLast) & " [T]: " & $iTrophyLast)
				If _Sleep($iDelayPushMsg1) Then Return
				SetLog("Pushbullet/Telegram: Last Raid Text has been sent!", $COLOR_GREEN)
			EndIf
			If ($pEnabled = 1 or $pEnabled2 = 1 ) And $pLastRaidImg = 1 Then
				_CaptureRegion(0, 0, $DEFAULT_WIDTH, $DEFAULT_HEIGHT - 45)
				;create a temporary file to send with pushbullet...
				Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
				Local $Time = @HOUR & "." & @MIN
				If $ScreenshotLootInfo = 1 Then
					$AttackFile = $Date & "__" & $Time & " G" & $iGoldLast & " E" & $iElixirLast & " DE" & $iDarkLast & " T" & $iTrophyLast & " S" & StringFormat("%3s", $SearchCount) & ".jpg" ; separator __ is need  to not have conflict with saving other files if $TakeSS = 1 and $chkScreenshotLootInfo = 0
				Else
					$AttackFile = $Date & "__" & $Time & ".jpg" ; separator __ is need  to not have conflict with saving other files if $TakeSS = 1 and $chkScreenshotLootInfo = 0
				EndIf
				$hBitmap_Scaled = _GDIPlus_ImageResize($hBitmap, _GDIPlus_ImageGetWidth($hBitmap) / 2, _GDIPlus_ImageGetHeight($hBitmap) / 2) ;resize image
				_GDIPlus_ImageSaveToFile($hBitmap_Scaled, $dirLoots & $AttackFile)
				_GDIPlus_ImageDispose($hBitmap_Scaled)
				;push the file
				SetLog("Pushbullet/Telegram: Last Raid screenshot has been sent!", $COLOR_GREEN)
				_PushFile($AttackFile, "Loots", "image/jpeg", $iOrigPushB & " | " & GetTranslated(18,61,"Last Raid") & "\n" & $AttackFile)
				;wait a second and then delete the file
				If _Sleep($iDelayPushMsg1) Then Return
				Local $iDelete = FileDelete($dirLoots & $AttackFile)
				If Not ($iDelete) Then SetLog("Pushbullet/Telegram: An error occurred deleting temporary screenshot file.", $COLOR_RED)
			EndIf
		Case "FoundWalls"
			If ($pEnabled = 1 or $pEnabled2 = 1 ) And $pWallUpgrade = 1 Then _Push($iOrigPushB & " | " & GetTranslated(18,62,"Found Wall level") & $icmbWalls + 4 & "\n" & GetTranslated(18,63," Wall segment has been located...") & "\n" & GetTranslated(18,64,"Upgrading ..."))
		Case "SkypWalls"
			If ($pEnabled = 1 or $pEnabled2 = 1 ) And $pWallUpgrade = 1 Then _Push($iOrigPushB & " | " & GetTranslated(18,65,"Cannot find Wall level")  & $icmbWalls + 4 & "\n" & GetTranslated(18,66,"Skip upgrade ..."))
		Case "AnotherDevice3600"
			If ($pEnabled = 1 or $pEnabled2 = 1 ) And $pAnotherDevice = 1 Then _Push($iOrigPushB & " | 1." & GetTranslated(18,67,"Another Device has connected") & "\n" & GetTranslated(18,68,"Another Device has connected, waiting ") & Floor(Floor($sTimeWakeUp / 60) / 60) & GetTranslated(18,69," hours ")  & Floor(Mod(Floor($sTimeWakeUp / 60), 60)) & GetTranslated(18,70," minutes ") & Floor(Mod($sTimeWakeUp, 60)) & GetTranslated(18,71," seconds"))
		Case "AnotherDevice60"
			If ($pEnabled = 1 or $pEnabled2 = 1 ) And $pAnotherDevice = 1 Then _Push($iOrigPushB & " | 2." & GetTranslated(18,67,"Another Device has connected") & "\n" & GetTranslated(18,68,"Another Device has connected, waiting ") & Floor(Mod(Floor($sTimeWakeUp / 60), 60)) & GetTranslated(18,70," minutes ") & Floor(Mod($sTimeWakeUp, 60)) & GetTranslated(18,71," seconds"))
		Case "AnotherDevice"
			If ($pEnabled = 1 or $pEnabled2 = 1 ) And $pAnotherDevice = 1 Then _Push($iOrigPushB & " | 3." & GetTranslated(18,67,"Another Device has connected") & "\n" & GetTranslated(18,68,"Another Device has connected, waiting ") & Floor(Mod($sTimeWakeUp, 60)) & GetTranslated(18,71," seconds"))
		Case "TakeBreak"
			If ($pEnabled = 1 or $pEnabled2 = 1 ) And $pTakeAbreak = 1 Then _Push($iOrigPushB & " | " & GetTranslated(18,72,"Chief, we need some rest!") & "\n" & GetTranslated(18,73,"Village must take a break.."))
		Case "CocError"
			If ($pEnabled = 1 or $pEnabled2 = 1 ) And $pOOS = 1 Then _Push($iOrigPushB & " | " & GetTranslated(18,74,"CoC Has Stopped Error ....."))
		Case "Pause"
			If ($pEnabled = 1 or $pEnabled2 = 1 ) And $pRemote = 1 And $Source = "Push" Then _Push($iOrigPushB & " | " & GetTranslated(18,75,"Request to Pause...") & "\n" & GetTranslated(18,76,"Your request has been received. Bot is now paused"))
		Case "Resume"
			If ($pEnabled = 1 or $pEnabled2 = 1 ) And $pRemote = 1 And $Source = "Push" Then _Push($iOrigPushB & " | " & GetTranslated(18,77,"Request to Resume...") & "\n" & GetTranslated(18,78,"Your request has been received. Bot is now resumed"))
		Case "OoSResources"
			If ($pEnabled = 1 or $pEnabled2 = 1 ) And $pOOS = 1 Then _Push($iOrigPushB & " | " & GetTranslated(18,79,"Disconnected after ") & StringFormat("%3s", $SearchCount) & GetTranslated(18,80," skip(s)") & "\n" & GetTranslated(18,81,"Cannot locate Next button, Restarting Bot..."))
		Case "MatchFound"
			If ($pEnabled = 1 or $pEnabled2 = 1 ) And $pMatchFound = 1 Then _Push($iOrigPushB & " | " & $sModeText[$iMatchMode] & GetTranslated(18,82," Match Found! after ") & StringFormat("%3s", $SearchCount) & GetTranslated(18,80," skip(s)") & "\n" & "[G]: " & _NumberFormat($searchGold) & "; [E]: " & _NumberFormat($searchElixir) & "; [D]: " & _NumberFormat($searchDark) & "; [T]: " & $searchTrophy)
		Case "UpgradeWithGold"
			If ($pEnabled = 1 or $pEnabled2 = 1 ) And $pWallUpgrade = 1 Then _Push($iOrigPushB & " | " & GetTranslated(18,83,"Upgrade completed by using GOLD") & "\n" & GetTranslated(18,84,"Complete by using GOLD ..."))
		Case "UpgradeWithElixir"
			If ($pEnabled = 1 or $pEnabled2 = 1 ) And $pWallUpgrade = 1 Then _Push($iOrigPushB & " | " & GetTranslated(18,85,"Upgrade completed by using ELIXIR") & "\n" & GetTranslated(18,86,"Complete by using ELIXIR ..."))
		Case "NoUpgradeWallButton"
			If ($pEnabled = 1 or $pEnabled2 = 1 ) And $pWallUpgrade = 1 Then _Push($iOrigPushB & " | " & GetTranslated(18,87,"No Upgrade Gold Button") & "\n" & GetTranslated(18,88,"Cannot find gold upgrade button ..."))
		Case "NoUpgradeElixirButton"
			If ($pEnabled = 1 or $pEnabled2 = 1 ) And $pWallUpgrade = 1 Then _Push($iOrigPushB & " | " & GetTranslated(18,89,"No Upgrade Elixir Button") & "\n" & GetTranslated(18,90,"Cannot find elixir upgrade button ..."))
		Case "RequestScreenshot"
			Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
			Local $Time = @HOUR & "." & @MIN
			_CaptureRegion(0, 0, $DEFAULT_WIDTH, $DEFAULT_HEIGHT)
			$hBitmap_Scaled = _GDIPlus_ImageResize($hBitmap, _GDIPlus_ImageGetWidth($hBitmap) / 2, _GDIPlus_ImageGetHeight($hBitmap) / 2) ;resize image
			Local $Screnshotfilename = "Screenshot_" & $Date & "_" & $Time & ".jpg"
			_GDIPlus_ImageSaveToFile($hBitmap_Scaled, $dirTemp & $Screnshotfilename)
			_GDIPlus_ImageDispose($hBitmap_Scaled)
			_PushFile($Screnshotfilename, "Temp", "image/jpeg", $iOrigPushB & " | " &  GetTranslated(18,91,"Screenshot of your village") & "\n" & $Screnshotfilename)
			SetLog("Pushbullet/Telegram: Screenshot sent!", $COLOR_GREEN)
			$RequestScreenshot = 0
			;wait a second and then delete the file
			If _Sleep($iDelayPushMsg2) Then Return
			Local $iDelete = FileDelete($dirTemp & $Screnshotfilename)
			If Not ($iDelete) Then SetLog("Pushbullet/Telegram: An error occurred deleting the temporary screenshot file.", $COLOR_RED)
		Case "DeleteAllPBMessages"
			_DeletePush(GUICtrlRead($PushBTokenValue))
			SetLog("PushBullet/Telegram: All messages deleted.", $COLOR_GREEN)
			$iDeleteAllPushesNow = False ; reset value
		Case "CampFull"
			If ($pEnabled = 1 or $pEnabled2 = 1 ) And $ichkAlertPBCampFull = 1 Then
				If $ichkAlertPBCampFullTest = 0 Then
					_Push($iOrigPushB & " | " & GetTranslated(18,92,"Your Army Camps are now Full"))
					$ichkAlertPBCampFullTest = 1
				EndIf
			EndIf
	EndSwitch

EndFunc   ;==>PushMsg

Func _DeleteOldPushes()

    If $pEnabled = 0 Or $PushToken = "" Or $ichkDeleteOldPushes = 0 Then Return
	;local UTC time
	Local $tLocal = _Date_Time_GetLocalTime()
	Local $tSystem = _Date_Time_TzSpecificLocalTimeToSystemTime(DllStructGetPtr($tLocal))
	Local $timeUTC = _Date_Time_SystemTimeToDateTimeStr($tSystem, 1)

	;local $timestamplimit = _DateDiff( 's',"1970/01/01 00:00:00", _DateAdd("h",-48,$timeUTC) ) ; limit to 48h read push, antiban purpose
	Local $timestamplimit = 0

	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$access_token = $PushToken
	$oHTTP.Open("Get", "https://api.pushbullet.com/v2/pushes?active=true&modified_after=" & $timestamplimit, False) ; limit to 48h read push, antiban purpose
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()
	$Result = $oHTTP.ResponseText
	Local $findstr = StringRegExp($Result, ',"created":')
	Local $msgdeleted = 0
	If $findstr = 1 Then
		Local $body = _StringBetween($Result, '"body":"', '"', "", False)
		Local $iden = _StringBetween($Result, '"iden":"', '"', "", False)
		Local $created = _StringBetween($Result, '"created":', ',', "", False)
		If IsArray($body) And IsArray($iden) And IsArray($created) Then
			For $x = 0 To UBound($created) - 1
				If $iden <> "" And $created <> "" Then
					Local $hdif = _DateDiff('h', _GetDateFromUnix($created[$x]), $timeUTC)
					If $hdif >= $icmbHoursPushBullet Then
						;	setlog("Pushbullet, deleted message: (+" & $hdif & "h)" & $body[$x] )
						$msgdeleted += 1
						_DeleteMessage($iden[$x])
						;else
						;	setlog("Pushbullet, skypped message: (+" & $hdif & "h)" & $body[$x] )
					EndIf
				EndIf
				$body[$x] = ""
				$iden[$x] = ""
			Next
		EndIf
	EndIf
	If $msgdeleted > 0 Then
		setlog("Pushbullet: removed " & $msgdeleted & " messages older than " & $icmbHoursPushBullet & " h ", $COLOR_GREEN)
		;_Push($iOrigPushB & " | removed " & $msgdeleted & " messages older than " & $icmbHoursPushBullet & " h ")
	EndIf

EndFunc   ;==>_DeleteOldPushes

Func _GetDateFromUnix($nPosix)

    If $pEnabled = 0 and $pEnabled2 = 0 Then Return

	Local $nYear = 1970, $nMon = 1, $nDay = 1, $nHour = 00, $nMin = 00, $nSec = 00, $aNumDays = StringSplit("31,28,31,30,31,30,31,31,30,31,30,31", ",")
	While 1
		If (Mod($nYear + 1, 400) = 0) Or (Mod($nYear + 1, 4) = 0 And Mod($nYear + 1, 100) <> 0) Then; is leap year
			If $nPosix < 31536000 + 86400 Then ExitLoop
			$nPosix -= 31536000 + 86400
			$nYear += 1
		Else
			If $nPosix < 31536000 Then ExitLoop
			$nPosix -= 31536000
			$nYear += 1
		EndIf
	WEnd
	While $nPosix > 86400
		$nPosix -= 86400
		$nDay += 1
	WEnd
	While $nPosix > 3600
		$nPosix -= 3600
		$nHour += 1
	WEnd
	While $nPosix > 60
		$nPosix -= 60
		$nMin += 1
	WEnd
	$nSec = $nPosix
	For $i = 1 To 12
		If $nDay < $aNumDays[$i] Then ExitLoop
		$nDay -= $aNumDays[$i]
		$nMon += 1
	Next
	;   Return $nDay & "/" & $nMon & "/" & $nYear & " " & $nHour & ":" & $nMin & ":" & $nSec
	Return $nYear & "-" & $nMon & "-" & $nDay & " " & $nHour & ":" & $nMin & ":" & StringFormat("%02i", $nSec)

EndFunc   ;==>_GetDateFromUnix