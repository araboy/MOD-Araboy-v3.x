; #FUNCTION# ====================================================================================================================
; Name ..........: CoCStats
; Description ...:
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: JK
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CoCStats($starsearned)

If $ichkCoCStats = 0 Then Return

   SetLog("Sending attack report to CoCStats.com...", $COLOR_BLUE)
   $sPD = 'apikey=' & $MyApiKey & '&ctrophy=' & $iTrophyCurrent & '&cgold=' & $iGoldCurrent & '&celix=' & $iElixirCurrent & '&cdelix=' & $iDarkCurrent & '&search=' & $SearchCount & '&gold=' & $iGoldLast & '&elix=' & $iElixirLast & '&delix=' & $iDarkLast & '&trophy=' & $iTrophyLast & '&bgold=' & $iGoldLastBonus & '&belix=' & $iElixirLastBonus & '&bdelix=' & $iDarkLastBonus & '&stars=' & $starsearned & '&thlevel=' & $iTownHallLevel & '&log='

   $tempLogText = _GuiCtrlRichEdit_GetText($txtLog, True)
   For $i = 1 To StringLen($tempLogText)
	  $acode = Asc(StringMid($tempLogText, $i, 1))
	  Select
		 Case ($acode >= 48 And $acode <= 57) Or _
			   ($acode >= 65 And $acode <= 90) Or _
			   ($acode >= 97 And $acode <= 122)
			$sPD = $sPD & StringMid($tempLogText, $i, 1)
		 Case $acode = 32
			$sPD = $sPD & "+"
		 Case Else
			$sPD = $sPD & "%" & Hex($acode, 2)
	  EndSelect
   Next

   $oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
   $oHTTP.Open("POST", "https://cocstats.com/api/log.php", False)
   $oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")

   $oHTTP.Send($sPD)

   $oReceived = $oHTTP.ResponseText
   $oStatusCode = $oHTTP.Status
   SetLog("Report sent. " & $oStatusCode & " " & $oReceived, $COLOR_BLUE)

EndFunc
