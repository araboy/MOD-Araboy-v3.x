#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
; #FUNCTION# ====================================================================================================================
; Name ..........: clanHop.au3
; Description ...: This functions joins random clans and fills requests
; Syntax ........: clanHop()
; Parameters ....: None
; Return values .: None
; Author ........: zengzeng
; Modified ......: Rhinoceros
; Remarks .......: This file is a part of MyBotRun. Copyright 2015
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://mybot.run/forums/thread-9319.html
; Example .......:  =====================================================================================================================
;MBR GUI_Taskbar CONTROLS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Func clanHop()
    If GUICtrlRead($chkClanHop) = $GUI_CHECKED Then
		$ichkClanHop = 1
		SetLog("Start Clan Hopping", $COLOR_BLUE)
	Else
		$ichkClanHop = 0
        Return
    EndIf
    Local $boostInterval = 2400           ; Change this to change how often to boost. Unit is seconds
    Local $trainInterval = 900            ; Change this to change how often to train troops. Unit is seconds
    Local $collectInterval = 900          ; Change this to change how often the bot collects your resources. unit is seconds
	Local $checkcampInterval = 300        ; Change this to change how often the bot check the army inside your camps. unit is seconds           
    	
    Local $boostTimer = TimerInit()
    Local $trainTimer = TimerInit()
    Local $collecttimer = TimerInit()
	Local $checkcamptimer = TimerInit()
	
    While 1
        If (TimerDiff($boostTimer)/1000)>= $boostInterval Then
            SetLog("Time for boosting!", $COLOR_GREEN)
            BoostBarracks()
            SetLog("Done boosting. Returning to hopping", $COLOR_BLUE)
            $boostTimer = TimerInit()                       ; Reset boost timer
        EndIf
        If (TimerDiff($trainTimer)/1000)>=$trainInterval Then
            $FirstStart = False
            SetLog("Time to train some troops")
			Train()
			$trainTimer = TimerInit()                       ; Reset Train timer
        EndIf
        If (TimerDiff($collecttimer)/1000)>= $collectInterval Then
            Collect()
			SetLog("Time to collect ressources")
            $collecttimer = TimerInit()                     ; Reset collect timer
		EndIf
		If (TimerDiff($checkcamptimer)/1000)>= $checkcampInterval Then                           ; Check Army Camps
            SetLog("Check troops")                                                               ;
			If _Sleep(600) Then Return                                                           ; 
		    Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0,"#0347")                      ; Click Button Army Overview
            If _Sleep(500) Then Return                                                           ; 
			checkArmyCamp()                                                                      ; 
			If $CurCamp <= 50  Then                                                              ; If < or = 50 troops in camps then train
			   SetLog("NEED TROOPS NOW !!! Waiting for troops to train...", $COLOR_RED)          ; 
		       Train()                                                                           ; 
			   SetLog("Waiting 2 x 4 minutes to have enough troops in camps...", $COLOR_RED)     ; Wait 8 minutes while training troops
			   SetLog("Waiting state 1/2 ...")                                                   ; (in 2 times to prevent disconnection)
			   If _SleepStatus(240000) Then Return                                               ;
			   ClickP($aaway)                                                                    ;
			   ClickP($aaway)                                                                    ;
			   SetLog("Waiting state 2/2 ...")                                                   ;
			   If _SleepStatus(240000) Then Return                                               ;
			   SetLog("Done !", $COLOR_GREEN)                                                    ;
			   SetLog("... Troops trained, resume hopping")                                      ; 
		       $checkcamptimer = TimerInit()                ; Reset Check Camp timer             ;  
			Else                                                                                 ; if more than 50 troops in camps then continue
               SetLog("... We have enough troops in camps.", $COLOR_GREEN)                       ; 
		       $checkcamptimer = TimerInit()                ; Reset Check Camp timer             ; 
			EndIf                                                                                ; 
        EndIf                                                                                    ;
        checkMainScreen(False)
        Local $icount
        ClickP($aaway)
        If _Sleep(500) Then Return
        Click(220, 33, 1, 0)                                              ; Click Info Profile Button
        If _Sleep(600) Then Return
        _CaptureRegion()
        While _ColorCheck(_GetPixelColor(242, 80, True), Hex(0x000000, 6), 20) = False ; Wait for Info Profile to open
            $iCount += 1
            ;If _Sleep(600) Then Return
            If $iCount >= 3 Then ExitLoop
        WEnd
        Click(369,80)                                                     ; Click clan tab
        If _Sleep(600) Then Return
           _CaptureRegion()
        If _ColorCheck(_GetPixelColor(720,340), Hex(0xE55050,6)) Then     ; If red leave clan button is there
            SetLog("Leaving clan", $COLOR_BLUE)
    		Click(720,340)                                                ; Click leave button
            If _Sleep(600) THen Return
            _CaptureRegion()
            If _Colorcheck(_GetPIxelColor(393,412), Hex(0xF0B964,6)) Then ; If orange do you really want to leave cancel button
                Click(508,420)                                            ; Click okay
            Else
               SetLog("Error, cancel button not available, restarting...", $COLOR_RED)
               ContinueLoop
            EndIf
            If _Sleep(1000) Then Return
            Click(220, 33, 1, 0)                                          ; Click Info Profile Button
            $icount = 0
            While _ColorCheck(_GetPixelColor(222, 60, True), Hex(0x000000, 6), 20) = False ; Wait for Info Profile to open
                $iCount += 1
                If _Sleep(600) Then Return
                If $iCount >= 3 Then ExitLoop
            WEnd
            SetLog("Searching for a new clan", $COLOR_BLUE)
            Click(336,80)                                                 ; Click clan tab
        EndIf
        If _Sleep(500) THen Return
        For $i = 0 To Random(0,5,1)                                       ; Scroll down clan list (random 0 to 5 times, max 8)
            Local $sCount = 0
            While $sCount < 1
                If _Sleep(300) Then Return
                _PostMessage_ClickDrag(500, 650, 500, 316, "left", 600)   ; Replace 300 with 600 for slow computers
				If _Sleep(300) Then Return
                $sCount += 1
            WEnd
        Next
        SetLog("... Clan found !", $COLOR_BLUE)
		If _Sleep(600) Then Return
        Click(113, Random(285,650,1))                                       ; Click random clan
		If _Sleep(800) THen Return
        If _ColorCheck(_GetPixelColor(720,335,True), Hex(0xC0E158,6)) Then  ; Is join button there
		    SetLog("Entering clan", $COLOR_BLUE)
            Click(720,335)
        Else
            SetLog("Oh oh ! I did something wrong, restarting...", $COLOR_RED)
            ContinueLoop
        EndIf
        If _Sleep(3000) THen Return
		SetLog("Time to donate troops")
        DonateCC(False)
		If _Sleep(500) THen Return
		SetLog("Check if I missed some requests")
		DonateCC(False)
		If _Sleep(500) THen Return
		VillageReport()
		ProfileSwitch()
        ;$cycleCount =$cycleCount+1
    WEnd
EndFunc