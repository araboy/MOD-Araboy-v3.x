;l; #FUNCTION# ====================================================================================================================
; Name ..........: checkDefense
; Description ...: This file Includes the Variables and functions to detect certain defenses near TH, based on checkTownhall.au3
; Syntax ........: checkDefense()
; Parameters ....: None
; Return values .: $Defx, $Defy
; Author ........: barracoda
; Modified ......: by Araboy
; Remarks .......: This file is part of mybotrun Copyright 2016
;                  mybotrun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================

#cs
	*******************************************************************
	HOW TO USE:
	1) If you're using "Normal" TH Snipe algorithm (or one that uses Ground & Air troops), set both $grdTroops & $airTroops to 1.
	If you set $grdTroops to 1, it will ignore air defense. If you set $airTroops to 1, it will ignore mortars.
	3) Set $chkMortar, $chkWiz, $chkInferno, $chkTesla, $chkAir to 1 if you want to skip bases that have these near the TH. Otherwise set them to 0. By default, only inferno is set to 1.
	4) The default algorithms are not recommended, as they use both ground and air troops (B.A.M.).
	*******************************************************************
#ce



Global $ppath[7] = ["inferno" , "tesla" , "mortar" , "wizard" ,  "air" , "archer" , "canon"]
Global $Defx = 0, $Defy = 0
Global $DefText[7] ; Text of Defense Type
$DefText[0] = "Inferno Tower"
$DefText[1] = "Wizard Tower"
$DefText[2] = "Mortar"
$DefText[3] = "Hidden Tesla"
$DefText[4] = "Air Defense"
$DefText[5] = "Archer Tower"
$DefText[6] = "Canon"
Global $allTroops = False, $skipBase = False

Global $DefImages0, $DefImages1, $DefImages2, $DefImages3, $DefImages4 , $DefImages5 , $DefImages6
global $airTroops = 1 , $grdTroops = 1
Global $defTolerance

Func checkDefense()
	SetLog("Checking Trapped TH", $COLOR_BLUE)
	$Defx = 0
	$Defy = 0
	$allTroops = False
	$skipBase = False
	$numDefFound = 0

	$iLeft = $THx - 125
	$iTop = $THy - 90
	$iRight = $THx + 125
	$iBottom = $THy + 90

	If $iLeft < 80 Then
	$iLeft = 80
	EndIf
	If $iTop < 70 Then
	$iTop = 70
	EndIf
	If $iRight > 780  then
	$iRight = 780
	EndIf
	If $iBottom > 600 Then
	$iBottom = 600
	EndIf

;~ 	$iw = $iRight - $iLeft
;~ 	$ih = $iBottom -  $iTop

;~ 	_CaptureTH($iLeft , $iTop , $iRight , $iBottom , False)
	_CaptureRegion()
	$sendHBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)
;~ 	$DefaultCocSearchArea = "70|70|720|540"
	$DefaultCocSearchArea = $iLeft &"|"& $iTop &"|"& $iRight &"|"& $iBottom
	$DefaultCocDiamond = "430,70|787,335|430,605|67,333"
	For $t = 0 To 6
		If Execute("$DefImages" & $t & "[0]") > 0  Then
			For $i = 1 To Execute("$DefImages" & $t & "[0]")

				$defTolerancee = StringSplit (Execute("$DefImages" & $t & "["& $i & "]") , "T")
				$Tolerance = $defTolerancee[2] + ($tolerancedefOffset/100)
				$FFile = @ScriptDir & "\images\Defense\" & $ppath[$t] & "\" & Execute("$DefImages" & $t & "["& $i & "]")
				$res = DllCall($LibDir & "\ImgLoc.dll", "str", "SearchTile", "handle", $sendHBitmap, "str", $FFile , "float", $Tolerance, "str" ,$DefaultCocSearchArea, "str",$DefaultCocDiamond )
				$DefLocation = StringSplit($res[0],"|")
;~ 				$DefLocation = _ImageSearchArea(@ScriptDir & "\images\Defense\" & $ppath[$t] & "\" & Execute("$DefImages" & $t & "["& $i & "]"), 1,0,0,$iw,$ih, $Defx, $Defy, $defTolerance) ; Getting Defense Location

				global $abcd = Execute("$DefImages" & $t & "["& $i & "]")

					If $DefLocation[1] > 0 then
					$numDefFound += 1
					for $n = 2 to (UBound($DefLocation)-2) Step +2
						Global $Defx = $DefLocation[$n]
						Global $Defy = $DefLocation[$n+1]

;~ 						Setlog(Execute("$DefImages" & $t & "["& $i & "]") & " Found")

						If $chkinfernoEnabled = 1 And $t = 0 Then
							If ($Defx > ($iLeft+40) And $Defx < ($iRight-40)) And ($Defy > ($iTop+30) And $Defy < ($iBottom-30)) Then
								$skipBase = True
								Return "Inferno Tower found near TH..."
							Else
								$skipBase = False
							EndIf
						ElseIf $chkteslaEnabled = 1 And $t = 1 Then
							If ($Defx > ($iLeft+58) And $Defx < ($iRight-58)) And ($Defy > ($iTop+45) And $Defy < ($iBottom-45)) Then
								$skipBase = True
								Return "Hidden Tesla found near TH..."
							Else
								$skipBase = False
							EndIf
						ElseIf $chkmortarEnabled = 1 And $t = 2 Then
							If ($Defx > ($iLeft+5) And $Defx < ($iRight-5)) And ($Defy > ($iTop+10) And $Defy < ($iBottom-10)) Then
								$skipBase = True
								Return "Mortar found near TH..."
							Else
								$skipBase = False
							EndIf
						ElseIf $chkwizardEnabled = 1 And $t = 3 Then
							If ($Defx > ($iLeft+53) And $Defx < ($iRight-53)) And ($Defy > ($iTop+42) And $Defy < ($iBottom-42)) Then
								$skipBase = True
								Return "Wizard Tower found near TH..."
							Else
								$skipBase = False
							EndIf
						ElseIf $chkairEnabled = 1 And $t = 4 Then
							If ($Defx > ($iLeft+15) And $Defx < ($iRight-15)) And ($Defy > ($iTop+20) And $Defy < ($iBottom-20)) Then
								$skipBase = True
								Return "Air Defense found near TH..."
							Else
								$skipBase = False
							EndIf
						ElseIf $chkarcherEnabled = 1 And $t = 5 Then
							If ($Defx > ($iLeft+15) And $Defx < ($iRight-15)) And ($Defy > ($iTop+20) And $Defy < ($iBottom-20)) Then
								$skipBase = True
								Return "Archer Tower found near TH..."
							Else
								$skipBase = False
							EndIf
						ElseIf $chkcanonEnabled = 1 And $t = 6 Then
							If ($Defx > ($iLeft+40) And $Defx < ($iRight-40)) And ($Defy > ($iTop+30) And $Defy < ($iBottom-30)) Then
								$skipBase = True
								Return "Canon found near TH..."
							Else
								$skipBase = False
							EndIf
						Else
							If ($t = 4 And $airTroops = 0) Or ( $t = 2 And $grdTroops = 0) Then
								$skipBase = False
							ElseIf ($Defx > ($iLeft+5) And $Defx < ($iRight-5)) And ($Defy > ($iTop+10) And $Defy < ($iBottom-10)) Then
								$skipBase = False
								$allTroops = True
								Return $DefText[$t] & " found at " & $Defx & "," & $Defy & ". Using alternative attack strategy!"
							EndIf
						EndIf
					;If _Sleep(100) Then Return
					Next
				EndIf
			Next
		EndIf
	Next
	If $numDefFound > 0 Then
		Setlog($Defx & " " & $Defy & " " & $THx & " " & $THy)
		$skipBase = False
		Return "Defence found, but not near TH."
	Else
		$skipBase = False
		Return "No major traps found near TH."
	EndIf
EndFunc   ;==>checkDefense

Func _CaptureTH($iLeft , $iTop , $iRight , $iBottom , $ReturnBMP = False)
	_GDIPlus_BitmapDispose($hBitmap)
	_WinAPI_DeleteObject($hHBitmap)

	If $ichkBackground = 1 Then
		Local $iW = Number($iRight) - Number($iLeft), $iH = Number($iBottom) - Number($iTop)

		Local $hDC_Capture = _WinAPI_GetWindowDC(ControlGetHandle($Title, "", "[CLASS:BlueStacksApp; INSTANCE:1]"))
		Local $hMemDC = _WinAPI_CreateCompatibleDC($hDC_Capture)
		$hHBitmap = _WinAPI_CreateCompatibleBitmap($hDC_Capture, $iW, $iH)
		Local $hObjectOld = _WinAPI_SelectObject($hMemDC, $hHBitmap)

		DllCall("user32.dll", "int", "PrintWindow", "hwnd", $HWnD, "handle", $hMemDC, "int", 0)
		_WinAPI_SelectObject($hMemDC, $hHBitmap)
		_WinAPI_BitBlt($hMemDC, 0, 0, $iW, $iH, $hDC_Capture, $iLeft, $iTop, 0x00CC0020)

		Global $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmap)

		_WinAPI_DeleteDC($hMemDC)
		_WinAPI_SelectObject($hMemDC, $hObjectOld)
		_WinAPI_ReleaseDC($HWnD, $hDC_Capture)
	Else
		getBSPos()
		$hHBitmap = _ScreenCapture_Capture("", $iLeft + $BSpos[0], $iTop + $BSpos[1], $iRight + $BSpos[0], $iBottom + $BSpos[1])
		Global $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmap)
	EndIf

	If $ReturnBMP Then Return $hBitmap
EndFunc   ;==>_CaptureTH

Func LoadDefImage()
;~     Setlog("loading Def image")
	Local $x
	Local $useimages = "*NORM*.bmp"

	For $t = 0 To 6
		;assign DefImages0... DefImages6  an array empty with Defimagesx[0]=0
		Assign("DefImages" & $t, StringSplit("", ""))
		;put in a temp array the list of files matching condition "*T*.bmp or *NORM*.bmp"
		$x = _FileListToArrayRec(@ScriptDir & "\images\Defense\" & $ppath[$t] & "\", $useimages, $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
		;assign value at DefImages0... DefImages6 if $x it's not empty
		If UBound($x) Then Assign("DefImages" & $t , $x)
;~ 		Setlog("def image:" & _ArrayToString($x))
	Next
EndFunc   ;==>LoadDefImage
