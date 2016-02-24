
; #FUNCTION# ====================================================================================================================
; Name ..........: savetroop
; Description ...:
; Syntax ........: savetroop($troopKind, $nbSides, $waveNb, $maxWaveNb[, $slotsPerEdge = 0])
; Parameters ....: $troopKind           - a dll struct value.
;                  $nbSides             - a general number value.
;                  $waveNb              - an unknown value.
;                  $maxWaveNb           - a map.
;                  $slotsPerEdge        - [optional] a string value. Default is 0.
; Return values .: None
; Author ........:
; Modified ......: Araboy
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func Savetroop($listInfoDeploy, $CC, $King, $Queen, $Warden)
	If $debugSetlog = 1 Then SetLog("savetroop with CC " & $CC & ", K " & $King & ", Q " & $Queen & ", W " & $Warden, $COLOR_PURPLE)
	Local $listListInfoDeployTroopPixel[0]
	Local $pixelRandomDrop[2]
	Local $pixelRandomDropcc[2]
	$countFindPixCloser = 0
	$countCollectorexposed = 0

	If ($iChkRedArea[$iMatchMode] = 1) And $FourFinger = 0 Then
		For $i = 0 To UBound($listInfoDeploy) - 1
			Local $troop = -1
			Local $troopNb = 0
			Local $name = ""
			$troopKind = $listInfoDeploy[$i][0]
			$nbSides = $listInfoDeploy[$i][1]
			$waveNb = $listInfoDeploy[$i][2]
			$maxWaveNb = $listInfoDeploy[$i][3]
			$slotsPerEdge = $listInfoDeploy[$i][4]
			If $debugSetlog = 1 Then SetLog("**ListInfoDeploy row " & $i & ": USE " & $troopKind & " SIDES " & $nbSides & " WAVE " & $waveNb & " XWAVE " & $maxWaveNb & " SLOTXEDGE " & $slotsPerEdge, $COLOR_PURPLE)
			If (IsNumber($troopKind)) Then
				For $j = 0 To UBound($atkTroops) - 1 ; identify the position of this kind of troop
					If $atkTroops[$j][0] = $troopKind Then
						$troop = $j
						$troopNb = Ceiling($atkTroops[$j][1] / $maxWaveNb)
						Local $plural = 0
						If $troopNb > 1 Then $plural = 1
						$name = NameOfTroop($troopKind, $plural)
					EndIf
				Next
			EndIf
			If ($troop <> -1 And $troopNb > 0) Or IsString($troopKind) Then
				Local $listInfoDeployTroopPixel
				If (UBound($listListInfoDeployTroopPixel) < $waveNb) Then
					ReDim $listListInfoDeployTroopPixel[$waveNb]
					Local $newListInfoDeployTroopPixel[0]
					$listListInfoDeployTroopPixel[$waveNb - 1] = $newListInfoDeployTroopPixel
				EndIf
				$listInfoDeployTroopPixel = $listListInfoDeployTroopPixel[$waveNb - 1]

				ReDim $listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) + 1]
				If (IsString($troopKind)) Then
					Local $arrCCorHeroes[1] = [$troopKind]
					$listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) - 1] = $arrCCorHeroes
				Else
					Local $infoDropTroop = DropTroop2($troop, $nbSides, $troopNb, $slotsPerEdge, $name)
					$listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) - 1] = $infoDropTroop
				EndIf
				$listListInfoDeployTroopPixel[$waveNb - 1] = $listInfoDeployTroopPixel
			EndIf
		Next

		If (($iChkSmartAttack[$iMatchMode][0] = 1 Or $iChkSmartAttack[$iMatchMode][1] = 1 Or $iChkSmartAttack[$iMatchMode][2] = 1) And UBound($PixelNearCollector) = 0) Then
			SetLog("Error, no pixel found near collector => Normal attack near red line")
		EndIf
		If ($iCmbSmartDeploy[$iMatchMode] = 0) Then
			For $numWave = 0 To UBound($listListInfoDeployTroopPixel) - 1
				Local $listInfoDeployTroopPixel = $listListInfoDeployTroopPixel[$numWave]
				For $i = 0 To UBound($listInfoDeployTroopPixel) - 1
					Local $infoPixelDropTroop = $listInfoDeployTroopPixel[$i]
					If (IsString($infoPixelDropTroop[0]) And ($infoPixelDropTroop[0] = "CC" Or $infoPixelDropTroop[0] = "HEROES")) Then

						If $DeployHeroesPosition[0] <> -1 Then
							$pixelRandomDrop[0] = $DeployHeroesPosition[0]
							$pixelRandomDrop[1] = $DeployHeroesPosition[1]
							If $debugSetlog = 1 Then SetLog("Deploy Heroes $DeployHeroesPosition")
						Else
							$pixelRandomDrop[0] = $BottomRight[2][0]
							$pixelRandomDrop[1] = $BottomRight[2][1] ;
							If $debugSetlog = 1 Then SetLog("Deploy Heroes $BottomRight")
						EndIf
						If $DeployCCPosition[0] <> -1 Then
							$pixelRandomDropcc[0] = $DeployCCPosition[0]
							$pixelRandomDropcc[1] = $DeployCCPosition[1]
							If $debugSetlog = 1 Then SetLog("Deploy CC $DeployHeroesPosition")
						Else
							$pixelRandomDrop[0] = $BottomRight[2][0]
							$pixelRandomDrop[1] = $BottomRight[2][1] ;
							If $debugSetlog = 1 Then SetLog("Deploy CC $BottomRight")
						EndIf

						If ($infoPixelDropTroop[0] = "CC") Then
							dropCC($pixelRandomDropcc[0], $pixelRandomDropcc[1], $CC)
							$isCCDropped = True
						ElseIf ($infoPixelDropTroop[0] = "HEROES") Then
							dropHeroes($pixelRandomDrop[0], $pixelRandomDrop[1], $King, $Queen, $Warden)
							$isHeroesDropped = True
						EndIf
					Else
						If _Sleep($iDelayLaunchTroop21) Then Return
						SelectDropTroop($infoPixelDropTroop[0]) ;Select Troop
						If _Sleep($iDelayLaunchTroop21) Then Return
						Local $waveName = "first"
						If $numWave + 1 = 2 Then $waveName = "second"
						If $numWave + 1 = 3 Then $waveName = "third"
						If $numWave + 1 = 0 Then $waveName = "last"
						SetLog("Dropping " & $waveName & " wave of " & $infoPixelDropTroop[5] & " " & $infoPixelDropTroop[4], $COLOR_GREEN)


						DropOnPixel($infoPixelDropTroop[0], $infoPixelDropTroop[1], $infoPixelDropTroop[2], $infoPixelDropTroop[3])
					EndIf
					If ($isHeroesDropped) Then
						If _Sleep($iDelayLaunchTroop22) Then Return ; delay Queen Image  has to be at maximum size : CheckHeroesHealth checks the y = 573
						CheckHeroesHealth()
					EndIf
					If _Sleep(SetSleep(1)) Then Return
				Next
					Local $timeSC = 0
					While $timeSC < 35
						CheckHeroesHealth()
						If _Sleep(1000) Then Return
						CheckHeroesHealth()
						$timeSC += 1
					WEnd

					Setlog("Checking for remaining collectors...")


					Global $PixelMine[0]
					Global $PixelElixir[0]
					Global $PixelDarkElixir[0]
					Global $PixelNearCollector[0]

					; If drop troop near gold mine
					If ($iChkSmartAttack[$iMatchMode][0] = 1) Then
						$PixelMine = GetLocationMine2()
						If (IsArray($PixelMine)) Then
							_ArrayAdd($PixelNearCollector, $PixelMine)
						EndIf
						SetLog("[" & UBound($PixelMine) & "] Gold Mines")
					EndIf


					_WinAPI_DeleteObject($hBitmapFirst)
					$hBitmapFirst = _CaptureRegion2()
					; If drop troop near elixir collector
					If ($iChkSmartAttack[$iMatchMode][1] = 1) Then
						$PixelElixir = GetLocationElixir()
						local $PixelElixirx = 0
						Global $iPixelElixir[0]
						If (IsArray($PixelElixir)) Then
							For $i = 0 To UBound($PixelElixir) - 1
								If isInsideDiamond($PixelElixir[$i]) Then
									$PixelElixirx +=1
									ReDim $iPixelElixir[$PixelElixirx]
									$iPixelElixir[$PixelElixirx - 1] = $PixelElixir[$i]
								EndIf
							Next
							_ArrayAdd($PixelNearCollector, $iPixelElixir)
						EndIf
						SetLog("[" & UBound($iPixelElixir) & "] Elixir Collectors")
						EndIf

					; If drop troop near dark elixir drill
					If ($iChkSmartAttack[$iMatchMode][2] = 1) Then
						$PixelDarkElixir = GetLocationDarkElixir()
						local $PixelDarkElixirx = 0
						Global $iPixelDarkElixir[0]
						If (IsArray($PixelDarkElixir)) Then
							For $i = 0 To UBound($PixelDarkElixir) - 1
								If isInsideDiamond($PixelDarkElixir[$i]) Then
									$PixelDarkElixirx +=1
									ReDim $iPixelDarkElixir[$PixelDarkElixirx]
									$iPixelDarkElixir[$PixelDarkElixirx - 1] = $PixelDarkElixir[$i]
								EndIf
							Next
							_ArrayAdd($PixelNearCollector, $iPixelDarkElixir)
						EndIf
						SetLog("[" & UBound($iPixelDarkElixir) & "] Dark Elixir Drill/s")
					EndIf


					If  UBound($PixelNearCollector) > $wrongcollectornumber Then
						SetLog("Continue attacking...")
					Else
						SetLog("No remaining collectors. End battle!...")
						$smartsaveend = 1
						Return
					EndIf

					Local $listListInfoDeployTroopPixel[0]

					For $i = 0 To UBound($listInfoDeploy) - 1
						Local $troop = -1
						Local $troopNb = 0
						Local $name = ""
						$troopKind = $listInfoDeploy[$i][0]
						$nbSides = $listInfoDeploy[$i][1]
						$waveNb = $listInfoDeploy[$i][2]
						$maxWaveNb = $listInfoDeploy[$i][3]
						$slotsPerEdge = $listInfoDeploy[$i][4]
						If (IsNumber($troopKind)) Then
							For $j = 0 To UBound($atkTroops) - 1 ; identify the position of this kind of troop
								If $atkTroops[$j][0] = $troopKind Then
									$troop = $j
									$troopNb = Ceiling($atkTroops[$j][1] / $maxWaveNb)
									Local $plural = 0
									If $troopNb > 1 Then $plural = 1
									$name = NameOfTroop($troopKind, $plural)
								EndIf
							Next
						EndIf
						If ($troop <> -1 And $troopNb > 0) Or IsString($troopKind) Then
							Local $listInfoDeployTroopPixel
							If (UBound($listListInfoDeployTroopPixel) < $waveNb) Then
								ReDim $listListInfoDeployTroopPixel[$waveNb]
								Local $newListInfoDeployTroopPixel[0]
								$listListInfoDeployTroopPixel[$waveNb - 1] = $newListInfoDeployTroopPixel
							EndIf
						$listInfoDeployTroopPixel = $listListInfoDeployTroopPixel[$waveNb - 1]

						ReDim $listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) + 1]
						If (IsString($troopKind)) Then
							Local $arrCCorHeroes[1] = [$troopKind]
							$listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) - 1] = $arrCCorHeroes
						Else
							If $troopNb > (UBound($PixelNearCollector)*5) Then $troopNb = (UBound($PixelNearCollector)*5)
							Local $infoDropTroop = DropTroop2($troop, $nbSides, $troopNb, $slotsPerEdge, $name)
							$listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) - 1] = $infoDropTroop
						EndIf
						$listListInfoDeployTroopPixel[$waveNb - 1] = $listInfoDeployTroopPixel
						EndIf
					Next
			Next
		Else
			For $numWave = 0 To UBound($listListInfoDeployTroopPixel) - 1
				Local $listInfoDeployTroopPixel = $listListInfoDeployTroopPixel[$numWave]
				If (UBound($listInfoDeployTroopPixel) > 0) Then
					Local $infoTroopListArrPixel = $listInfoDeployTroopPixel[0]
					Local $numberSidesDropTroop = 1

					For $i = 0 To UBound($listInfoDeployTroopPixel) - 1
						$infoTroopListArrPixel = $listInfoDeployTroopPixel[$i]
						If (UBound($infoTroopListArrPixel) > 1) Then
							Local $infoListArrPixel = $infoTroopListArrPixel[1]
							$numberSidesDropTroop = UBound($infoListArrPixel)
							ExitLoop
						EndIf
					Next

					If ($numberSidesDropTroop > 0) Then
						For $i = 0 To $numberSidesDropTroop - 1
							For $j = 0 To UBound($listInfoDeployTroopPixel) - 1
								$infoTroopListArrPixel = $listInfoDeployTroopPixel[$j]
								If (IsString($infoTroopListArrPixel[0]) And ($infoTroopListArrPixel[0] = "CC" Or $infoTroopListArrPixel[0] = "HEROES")) Then

									If $DeployHeroesPosition[0] <> -1 Then
										$pixelRandomDrop[0] = $DeployHeroesPosition[0]
										$pixelRandomDrop[1] = $DeployHeroesPosition[1]
										If $debugSetlog = 1 Then SetLog("Deploy Heroes $DeployHeroesPosition")
									Else
										$pixelRandomDrop[0] = $BottomRight[2][0]
										$pixelRandomDrop[1] = $BottomRight[2][1] ;
										If $debugSetlog = 1 Then SetLog("Deploy Heroes $BottomRight")
									EndIf
									If $DeployCCPosition[0] <> -1 Then
										$pixelRandomDropcc[0] = $DeployCCPosition[0]
										$pixelRandomDropcc[1] = $DeployCCPosition[1]
										If $debugSetlog = 1 Then SetLog("Deploy CC $DeployHeroesPosition")
									Else
										$pixelRandomDrop[0] = $BottomRight[2][0]
										$pixelRandomDrop[1] = $BottomRight[2][1] ;
										If $debugSetlog = 1 Then SetLog("Deploy CC $BottomRight")
									EndIf

									If ($isCCDropped = False And $infoTroopListArrPixel[0] = "CC") Then
										dropCC($pixelRandomDrop[0], $pixelRandomDrop[1], $CC)
										$isCCDropped = True
									ElseIf ($isHeroesDropped = False And $infoTroopListArrPixel[0] = "HEROES" And $i = $numberSidesDropTroop - 1) Then
										dropHeroes($pixelRandomDrop[0], $pixelRandomDrop[1], $King, $Queen, $Warden)
										$isHeroesDropped = True
									EndIf
								Else
									$infoListArrPixel = $infoTroopListArrPixel[1]
									$listPixel = $infoListArrPixel[$i]
									;infoPixelDropTroop : First element in array contains troop and list of array to drop troop
									If _Sleep($iDelayLaunchTroop21) Then Return
									SelectDropTroop($infoTroopListArrPixel[0]) ;Select Troop
									If _Sleep($iDelayLaunchTroop23) Then Return
									SetLog("Dropping " & $infoTroopListArrPixel[2] & "  of " & $infoTroopListArrPixel[5] & " => on each side (side : " & $i + 1 & ")", $COLOR_GREEN)
									Local $pixelDropTroop[1] = [$listPixel]
									DropOnPixel($infoTroopListArrPixel[0], $pixelDropTroop, $infoTroopListArrPixel[2], $infoTroopListArrPixel[3])
								EndIf
								If ($isHeroesDropped) Then
									If _sleep(1000) Then Return ; delay Queen Image  has to be at maximum size : CheckHeroesHealth checks the y = 573
									CheckHeroesHealth()
								EndIf
							Next
						Next
					EndIf
				EndIf
				If _Sleep(SetSleep(1)) Then Return

					Local $timeSC = 0
					While $timeSC < 35
						CheckHeroesHealth()
						If _Sleep(1000) Then Return
						CheckHeroesHealth()
						$timeSC += 1
					WEnd

					Setlog("Checking for remaining collectors...")

					Global $PixelMine[0]
					Global $PixelElixir[0]
					Global $PixelDarkElixir[0]
					Global $PixelNearCollector[0]

					; If drop troop near gold mine
					If ($iChkSmartAttack[$iMatchMode][0] = 1) Then
						$PixelMine = GetLocationMine2()
						If (IsArray($PixelMine)) Then
							_ArrayAdd($PixelNearCollector, $PixelMine)
						EndIf
						SetLog("[" & UBound($PixelMine) & "] Gold Mines")
					EndIf

					_WinAPI_DeleteObject($hBitmapFirst)
					$hBitmapFirst = _CaptureRegion2()
					; If drop troop near elixir collector
					If ($iChkSmartAttack[$iMatchMode][1] = 1) Then
						$PixelElixir = GetLocationElixir()
						local $PixelElixirx = 0
						Global $iPixelElixir[0]
						If (IsArray($PixelElixir)) Then
							For $i = 0 To UBound($PixelElixir) - 1
								If isInsideDiamond($PixelElixir[$i]) Then
									$PixelElixirx +=1
									ReDim $iPixelElixir[$PixelElixirx]
									$iPixelElixir[$PixelElixirx - 1] = $PixelElixir[$i]
								EndIf
							Next
							_ArrayAdd($PixelNearCollector, $iPixelElixir)
						EndIf
						SetLog("[" & UBound($iPixelElixir) & "] Elixir Collectors")
						EndIf

					; If drop troop near dark elixir drill
					If ($iChkSmartAttack[$iMatchMode][2] = 1) Then
						$PixelDarkElixir = GetLocationDarkElixir()
						local $PixelDarkElixirx = 0
						Global $iPixelDarkElixir[0]
						If (IsArray($PixelDarkElixir)) Then
							For $i = 0 To UBound($PixelDarkElixir) - 1
								If isInsideDiamond($PixelDarkElixir[$i]) Then
									$PixelDarkElixirx +=1
									ReDim $iPixelDarkElixir[$PixelDarkElixirx]
									$iPixelDarkElixir[$PixelDarkElixirx - 1] = $PixelDarkElixir[$i]
								EndIf
							Next
							_ArrayAdd($PixelNearCollector, $iPixelDarkElixir)
						EndIf
						SetLog("[" & UBound($iPixelDarkElixir) & "] Dark Elixir Drill/s")
					EndIf


					If UBound($PixelNearCollector) > $wrongcollectornumber Then
						SetLog("Continue attacking...")
					Else
						SetLog("No remaining collectors. End battle!...")
						$smartsaveend = 1
						Return
					EndIf

					Local $listListInfoDeployTroopPixel[0]

					For $i = 0 To UBound($listInfoDeploy) - 1
						Local $troop = -1
						Local $troopNb = 0
						Local $name = ""
						$troopKind = $listInfoDeploy[$i][0]
						$nbSides = $listInfoDeploy[$i][1]
						$waveNb = $listInfoDeploy[$i][2]
						$maxWaveNb = $listInfoDeploy[$i][3]
						$slotsPerEdge = $listInfoDeploy[$i][4]
						If (IsNumber($troopKind)) Then
							For $j = 0 To UBound($atkTroops) - 1 ; identify the position of this kind of troop
								If $atkTroops[$j][0] = $troopKind Then
									$troop = $j
									$troopNb = Ceiling($atkTroops[$j][1] / $maxWaveNb)
									Local $plural = 0
									If $troopNb > 1 Then $plural = 1
									$name = NameOfTroop($troopKind, $plural)
								EndIf
							Next
						EndIf
						If ($troop <> -1 And $troopNb > 0) Or IsString($troopKind) Then
							Local $listInfoDeployTroopPixel
							If (UBound($listListInfoDeployTroopPixel) < $waveNb) Then
								ReDim $listListInfoDeployTroopPixel[$waveNb]
								Local $newListInfoDeployTroopPixel[0]
								$listListInfoDeployTroopPixel[$waveNb - 1] = $newListInfoDeployTroopPixel
							EndIf
						$listInfoDeployTroopPixel = $listListInfoDeployTroopPixel[$waveNb - 1]

						ReDim $listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) + 1]
						If (IsString($troopKind)) Then
							Local $arrCCorHeroes[1] = [$troopKind]
							$listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) - 1] = $arrCCorHeroes
						Else
							If $troopNb > (UBound($PixelNearCollector)*5) Then $troopNb = (UBound($PixelNearCollector)*5)
							Local $infoDropTroop = DropTroop2($troop, $nbSides, $troopNb, $slotsPerEdge, $name)
							$listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) - 1] = $infoDropTroop
						EndIf
						$listListInfoDeployTroopPixel[$waveNb - 1] = $listInfoDeployTroopPixel
						EndIf
					Next
			Next
		EndIf
		For $numWave = 0 To UBound($listListInfoDeployTroopPixel) - 1
			Local $listInfoDeployTroopPixel = $listListInfoDeployTroopPixel[$numWave]
			For $i = 0 To UBound($listInfoDeployTroopPixel) - 1
				Local $infoPixelDropTroop = $listInfoDeployTroopPixel[$i]
				If Not (IsString($infoPixelDropTroop[0]) And ($infoPixelDropTroop[0] = "CC" Or $infoPixelDropTroop[0] = "HEROES")) Then
					Local $numberLeft = ReadTroopQuantity($infoPixelDropTroop[0])
					;SetLog("NumberLeft : " & $numberLeft)
					If ($numberLeft > 0) Then
						If _Sleep($iDelayLaunchTroop21) Then Return
						SelectDropTroop($infoPixelDropTroop[0]) ;Select Troop
						If _Sleep($iDelayLaunchTroop23) Then Return
						If $numberLeft > (UBound($PixelNearCollector)*5) Then $numberLeft =  (UBound($PixelNearCollector)*5)
						SetLog("Dropping last " & $numberLeft & "  of " & $infoPixelDropTroop[5], $COLOR_GREEN)

						DropOnPixel($infoPixelDropTroop[0], $infoPixelDropTroop[1], Ceiling($numberLeft / UBound($infoPixelDropTroop[1])), $infoPixelDropTroop[3])
					EndIf
				EndIf
			Next
		Next

					Local $timeSC = 0
					While $timeSC < 20
						CheckHeroesHealth()
						If _Sleep(1000) Then Return
						CheckHeroesHealth()
						$timeSC += 1
					WEnd

					Setlog("Checking for remaining collectors...")

					Global $PixelMine[0]
					Global $PixelElixir[0]
					Global $PixelDarkElixir[0]
					Global $PixelNearCollector[0]

					; If drop troop near gold mine
					If ($iChkSmartAttack[$iMatchMode][0] = 1) Then
						$PixelMine = GetLocationMine2()
						If (IsArray($PixelMine)) Then
							_ArrayAdd($PixelNearCollector, $PixelMine)
						EndIf
						SetLog("[" & UBound($PixelMine) & "] Gold Mines")
					EndIf


					_WinAPI_DeleteObject($hBitmapFirst)
					$hBitmapFirst = _CaptureRegion2()
					; If drop troop near elixir collector
					If ($iChkSmartAttack[$iMatchMode][1] = 1) Then
						$PixelElixir = GetLocationElixir()
						local $PixelElixirx = 0
						Global $iPixelElixir[0]
						If (IsArray($PixelElixir)) Then
							For $i = 0 To UBound($PixelElixir) - 1
								If isInsideDiamond($PixelElixir[$i]) Then
									$PixelElixirx +=1
									ReDim $iPixelElixir[$PixelElixirx]
									$iPixelElixir[$PixelElixirx - 1] = $PixelElixir[$i]
								EndIf
							Next
							_ArrayAdd($PixelNearCollector, $iPixelElixir)
						EndIf
						SetLog("[" & UBound($iPixelElixir) & "] Elixir Collectors")
						EndIf

					; If drop troop near dark elixir drill
					If ($iChkSmartAttack[$iMatchMode][2] = 1) Then
						$PixelDarkElixir = GetLocationDarkElixir()
						local $PixelDarkElixirx = 0
						Global $iPixelDarkElixir[0]
						If (IsArray($PixelDarkElixir)) Then
							For $i = 0 To UBound($PixelDarkElixir) - 1
								If isInsideDiamond($PixelDarkElixir[$i]) Then
									$PixelDarkElixirx +=1
									ReDim $iPixelDarkElixir[$PixelDarkElixirx]
									$iPixelDarkElixir[$PixelDarkElixirx - 1] = $PixelDarkElixir[$i]
								EndIf
							Next
							_ArrayAdd($PixelNearCollector, $iPixelDarkElixir)
						EndIf
						SetLog("[" & UBound($iPixelDarkElixir) & "] Dark Elixir Drill/s")
					EndIf


					If UBound($PixelNearCollector) > $wrongcollectornumber Then
						SetLog("Continue attacking...")
					Else
						SetLog("No remaining collectors. End battle!...")
						$smartsaveend = 1
						Return
					EndIf

	Else
		For $i = 0 To UBound($listInfoDeploy) - 1
			If (IsString($listInfoDeploy[$i][0]) And ($listInfoDeploy[$i][0] = "CC" Or $listInfoDeploy[$i][0] = "HEROES")) Then
				If $iMatchMode = $LB And $iChkDeploySettings[$LB] >= 4 Then ; Used for DE or TH side attack
					Local $RandomEdge = $Edges[$BuildingEdge]
					Local $RandomXY = 2
				Else
					Local $RandomEdge = $Edges[Round(Random(0, 3))]
					Local $RandomXY = Round(Random(1, 3))
				EndIf
				If ($listInfoDeploy[$i][0] = "CC") Then
					dropCC($RandomEdge[$RandomXY][0], $RandomEdge[$RandomXY][1], $CC)
				ElseIf ($listInfoDeploy[$i][0] = "HEROES") Then
					dropHeroes($RandomEdge[$RandomXY][0], $RandomEdge[$RandomXY][1], $King, $Queen, $Warden)
				EndIf
			Else
				If LauchTroop($listInfoDeploy[$i][0], $listInfoDeploy[$i][1], $listInfoDeploy[$i][2], $listInfoDeploy[$i][3], $listInfoDeploy[$i][4]) Then
					If _Sleep(SetSleep(1)) Then Return
				EndIf
			EndIf
		Next

	EndIf
	Return True
EndFunc   ;==>savetroop

Func outsidecollector($nbSides,$listInfoDeploy) ; change the sterategy
	Local $listListInfoDeployTroopPixel[0]
	Local $pixelRandomDrop[2]
	Local $pixelRandomDropcc[2]
	$countFindPixCloser = 0
	$countCollectorexposed = 0

		For $i = 0 To UBound($listInfoDeploy) - 1
			Local $troop = -1
			Local $troopNb = 0
			Local $name = ""
			$troopKind = $listInfoDeploy[$i][0]
			$nbSides = $listInfoDeploy[$i][1]
			$waveNb = $listInfoDeploy[$i][2]
			$maxWaveNb = $listInfoDeploy[$i][3]
			$slotsPerEdge = $listInfoDeploy[$i][4]
			If $debugSetlog = 1 Then SetLog("**ListInfoDeploy row " & $i & ": USE " & $troopKind & " SIDES " & $nbSides & " WAVE " & $waveNb & " XWAVE " & $maxWaveNb & " SLOTXEDGE " & $slotsPerEdge, $COLOR_PURPLE)
			If (IsNumber($troopKind)) Then
				For $j = 0 To UBound($atkTroops) - 1 ; identify the position of this kind of troop
					If $atkTroops[$j][0] = $troopKind Then
						$troop = $j
						$troopNb = Ceiling($atkTroops[$j][1] / $maxWaveNb)
						Local $plural = 0
						If $troopNb > 1 Then $plural = 1
						$name = NameOfTroop($troopKind, $plural)
					EndIf
				Next
			EndIf
			If ($troop <> -1 And $troopNb > 0) Or IsString($troopKind) Then
				Local $listInfoDeployTroopPixel
				If (UBound($listListInfoDeployTroopPixel) < $waveNb) Then
					ReDim $listListInfoDeployTroopPixel[$waveNb]
					Local $newListInfoDeployTroopPixel[0]
					$listListInfoDeployTroopPixel[$waveNb - 1] = $newListInfoDeployTroopPixel
				EndIf
				$listInfoDeployTroopPixel = $listListInfoDeployTroopPixel[$waveNb - 1]

				ReDim $listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) + 1]
				If (IsString($troopKind)) Then
					Local $arrCCorHeroes[1] = [$troopKind]
					$listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) - 1] = $arrCCorHeroes
				Else
					Local $infoDropTroop = DropTroop2($troop, $nbSides, $troopNb, $slotsPerEdge, $name)
					$listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) - 1] = $infoDropTroop
				EndIf
				$listListInfoDeployTroopPixel[$waveNb - 1] = $listInfoDeployTroopPixel
			EndIf
		Next

		Setlog("There are " & $countCollectorexposed & " collector(s) near RED LINE out of " & (UBound($PixelNearCollector)-$wrongcollectornumber) & " collectors")
		If _Sleep(100) Then Return

		If ($countCollectorexposed / (UBound($PixelNearCollector) - $wrongcollectornumber) * 100) < $percentCollectors Then
			Switch ($icmbInsideCol + 1)
				Case 1
					SetLog("Changing Attack Strategy to All Sides Attack!...")
					If _Sleep(50) Then Return
					$nbSides = 4
					$saveTroops = 0
					Local $listInfoDeploy2[14][5] = [[$eGiant, $nbSides, 1, 1, 2] _
							, [$eBarb, $nbSides, 1, 2, 0] _
							, [$eWall, $nbSides, 1, 1, 1] _
							, [$eArch, $nbSides, 1, 2, 0] _
							, [$eBarb, $nbSides, 2, 2, 0] _
							, [$eGobl, $nbSides, 1, 2, 0] _
							, ["CC", 1, 1, 1, 1] _
							, [$eHogs, $nbSides, 1, 1, 1] _
							, [$eWiza, $nbSides, 1, 1, 0] _
							, [$eBall, $nbSides, 1, 1, 0] _
							, [$eMini, $nbSides, 1, 1, 0] _
							, [$eArch, $nbSides, 2, 2, 0] _
							, [$eGobl, $nbSides, 2, 2, 0] _
							, ["HEROES", 1, 2, 1, 1] _
							]

				Case 2
					SetLog("Changing Attack Strategy to Four Finger Barch!...")
					If _Sleep(50) Then Return
					$nbSides = 5
					$FourFinger = 1
					Local $listInfoDeploy2[11][5] = [[$eGiant, $nbSides, 1, 1, 2] _
												  , [$eBarb, $nbSides, 1, 1, 0] _
												  , [$eWall, $nbSides, 1, 1, 1] _
												  , [$eArch, $nbSides, 1, 1, 0] _
												  , [$eGobl, $nbSides, 1, 2, 0] _
												  , ["CC", 1, 1, 1, 1] _
												  , [$eHogs, $nbSides, 1, 1, 1] _
												  , [$eWiza, $nbSides, 1, 1, 0] _
												  , [$eMini, $nbSides, 1, 1, 0] _
												  , [$eGobl, $nbSides, 2, 2, 0] _
												  , ["HEROES", 1, 2, 1, 1] _
													]
				Case 3
					Return
			EndSwitch
		Else
			Local $listInfoDeploy2 = $listInfoDeploy
		EndIf
	Return $listInfoDeploy2
EndFunc ;end function outside collector

Func FindPixelDistance($iPixel = 0, $iPixelCloser = 0)

	If $saveTroops = 1 Then
		If $countFindPixCloser < UBound($PixelNearCollector) Then
			Local $DistancePixeltoPixCLoser = Sqrt(($iPixelCloser[0] - $iPixel[0]) ^ 2 + ($iPixelCloser[1] - $iPixel[1]) ^ 2)
			;setlog("Distance is " & $DistancePixeltoPixCLoser)
			If $DistancePixeltoPixCLoser < 51 Then $countCollectorexposed += 1
			$countFindPixCloser += 1
		EndIf
	EndIf

EndFunc   ;==>FindPixelDistance
