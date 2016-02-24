; #FUNCTION# ====================================================================================================================
; Name ..........: algorith_AllTroops
; Description ...: This file contens all functions to attack algorithm will all Troops , using Barbarians, Archers, Goblins, Giants and Wallbreakers as they are available
; Syntax ........: algorithm_AllTroops()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: Didipe (May-2015), ProMac(2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func getHeroes() ;Get information about your heroes
	; $debugSetlog = 1
	Local $aDeployButtonPositions = getUnitLocationArray()
	; $debugSetlog = 0

	$King = $aDeployButtonPositions[$eKing]
	$Queen = $aDeployButtonPositions[$eQueen]
	$Warden = $aDeployButtonPositions[$eWarden]
	$CC = $aDeployButtonPositions[$eCastle]

	If $debugSetlog = 1 Then
		SetLog("Use king  SLOT n° " & $King, $COLOR_PURPLE)
		SetLog("Use queen SLOT n° " & $Queen, $COLOR_PURPLE)
		SetLog("Use Warden SLOT n° " & $Warden, $COLOR_PURPLE)
		SetLog("Use CC SLOT n° " & $CC, $COLOR_PURPLE)
	EndIf
EndFunc   ;==>getHeroes

Func useHeroesAbility() ;Use the heroes abilities if appropriate
	;Activate KQ's power
	If ($checkKPower Or $checkQPower) And $iActivateKQCondition = "Manual" Then
		SetLog("Waiting " & $delayActivateKQ / 1000 & " seconds before activating Hero abilities", $COLOR_BLUE)
		If _Sleep($delayActivateKQ) Then Return
		If $checkKPower Then
			SetLog("Activating King's power", $COLOR_BLUE)
			SelectDropTroop($King)
			$checkKPower = False
		EndIf
		If $checkQPower Then
			SetLog("Activating Queen's power", $COLOR_BLUE)
			SelectDropTroop($Queen)
			$checkQPower = False
		EndIf
	EndIf
EndFunc   ;==>useHeroesAbility

Func useTownHallSnipe() ;End battle after a town hall snipe
	SwitchAttackTHType()
	If $zoomedin = True Then
		ZoomOut()
		$zoomedin = False
		$zCount = 0
		$sCount = 0
	EndIf
	If $ichkDrillZapTH = 1 Then
		DEDropSmartSpell()
	EndIf
	;If $OptTrophyMode = 1 And SearchTownHallLoc() Then Return ;Exit attacking if trophy hunting and not bullymode
	If ($THusedKing = 0 And $THusedQueen = 0) Then
		Setlog("Wait few sec before close attack")
		If _Sleep(Random(2, 5, 1) * 1000) Then Return ;wait 2-5 second before exit if king and queen are not dropped
	Else
		SetLog("King and/or Queen dropped, close attack")
	EndIf
	CloseBattle()
EndFunc   ;==>useTownHallSnipe

Func useSmartDeploy() ;Gets infomation about the red area for Smart Deploy
		SetLog("Calculating Smart Attack Strategy", $COLOR_BLUE)
		Local $hTimer = TimerInit()

		SetLog("Calculated  (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds) :")
		;SetLog("	[" & UBound($PixelTopLeft) & "] pixels TopLeft")
		;SetLog("	[" & UBound($PixelTopRight) & "] pixels TopRight")
		;SetLog("	[" & UBound($PixelBottomLeft) & "] pixels BottomLeft")
		;SetLog("	[" & UBound($PixelBottomRight) & "] pixels BottomRight")


		If ($iChkSmartAttack[$iMatchMode][0] = 1 Or $iChkSmartAttack[$iMatchMode][1] = 1 Or $iChkSmartAttack[$iMatchMode][2] = 1) Then
			SetLog("Locating Mines, Collectors & Drills", $COLOR_BLUE)
			$hTimer = TimerInit()
			Global $PixelMine[0]
			Global $PixelElixir[0]
			Global $PixelDarkElixir[0]
			Global $PixelNearCollector[0]

			Global $iPixelElixir[0]
			Global $iPixelDarkElixir[0]
			Global $wrongcollectornumber = 0
			local  $truegoldminenumber[1]
			local  $trueelixirnumber[1]
			local  $truedarkelixirnumber[1]

			; If drop troop near gold mine
			If ($iChkSmartAttack[$iMatchMode][0] = 1) Then
				$PixelMine = GetLocationMine2()
				If (IsArray($PixelMine)) Then
					_ArrayAdd($PixelNearCollector, $PixelMine)
				EndIf
				SetLog("[" & UBound($PixelMine) & "] original Gold Mines")
					; fix GetLocationMine2() bug in dll
					If ($smartsaveTH <> "-") And ($smartsaveTH >= 10) And (UBound($PixelMine) > 7) Then
						$wrongcollectornumber += (UBound($PixelMine) - 7)
						$truegoldminenumber[0] = 7
					ElseIf ($smartsaveTH <> "-") And ($smartsaveTH < 10) And (UBound($PixelMine) > 6) Then
						$wrongcollectornumber += (UBound($PixelMine) - 6)
						$truegoldminenumber[0] = 6
					Else
						$truegoldminenumber[0] = UBound($PixelMine)
					EndIf
					SetLog("[" & $truegoldminenumber[0] & "] Gold Mines")
			EndIf

			_WinAPI_DeleteObject($hBitmapFirst)
			$hBitmapFirst = _CaptureRegion2()
		    _GetRedArea()

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
				; fix GetLocationelixir() bug in dll
				If ($smartsaveTH <> "-") And ($smartsaveTH >= 10) And (UBound($iPixelElixir) > 7) Then
					$wrongcollectornumber += (UBound($iPixelElixir) - 7)
					$trueelixirnumber[0] = 7
				ElseIf ($smartsaveTH <> "-") And ($smartsaveTH < 10) And (UBound($iPixelElixir) > 6) Then
					$wrongcollectornumber += (UBound($iPixelElixir) - 6)
					$trueelixirnumber[0] = 6
				Else
					$trueelixirnumber[0] = UBound($iPixelElixir)
				EndIf
				SetLog("[" & $trueelixirnumber[0] & "] Elixir Collectors")
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
				; fix GetLocationdarkelixir() bug in dll
				If ($smartsaveTH <> "-") And ($smartsaveTH >= 10) And (UBound($iPixelDarkElixir) > 7) Then
					$wrongcollectornumber += (UBound($iPixelDarkElixir) - 7)
					$truedarkelixirnumber[0] = 7
				ElseIf ($smartsaveTH <> "-") And ($smartsaveTH < 10) And (UBound($iPixelDarkElixir) > 6) Then
					$wrongcollectornumber += (UBound($iPixelDarkElixir) - 6)
					$truedarkelixirnumber[0] = 6
				Else
					$truedarkelixirnumber[0] = UBound($iPixelDarkElixir)
				EndIf
				SetLog("[" & $truedarkelixirnumber[0] & "] Dark Elixir Drill/s")
			EndIf


			SetLog("Located  (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds) :")


			$iNbrOfDetectedMines[$iMatchMode] += $truegoldminenumber[0]
			$iNbrOfDetectedCollectors[$iMatchMode] += $trueelixirnumber[0]
			$iNbrOfDetectedDrills[$iMatchMode] += $truedarkelixirnumber[0]
			UpdateStats()
		EndIf
EndFunc

Func getNumberOfSides() ;Returns the number of sides to attack from
	Local $nbSides = 0
	Switch $iChkDeploySettings[$iMatchMode]
		Case 0 ;Single sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking on a single side", $COLOR_BLUE)
			$nbSides = 1
		Case 1 ;Two sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking on two sides", $COLOR_BLUE)
			$nbSides = 2
		Case 2 ;Three sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking on three sides", $COLOR_BLUE)
			$nbSides = 3
		Case 3 ;All sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking on all sides", $COLOR_BLUE)
			$nbSides = 4
		Case 4 ;FFF ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			If $iMatchMode = $DB Then
				SetLog("Attacking four finger fight style", $COLOR_BLUE)
				$nbSides = 5
				$FourFinger = 1
			Else
				SetLog("Attacking on Dark Elixir Side.", $COLOR_BLUE)
				$nbSides = 1
				If Not ($iChkRedArea[$iMatchMode]) Then GetBuildingEdge($eSideBuildingDES) ; Get DE Storage side when Redline is not used.
			EndIf
		Case 5 ;DE Side - Live Base only or smart save troop - Dead base only ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			If $iMatchMode = $DB Then
				SetLog("Attacking on Smart Save Troop", $COLOR_BLUE)
				$nbSides = 4
				$saveTroops =1 ; smart save troop active
			Else  ;TH Side - Live Base only ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				SetLog("Attacking on Town Hall Side.", $COLOR_BLUE)
				$nbSides = 1
				If Not ($iChkRedArea[$iMatchMode]) Then GetBuildingEdge($eSideBuildingTH) ; Get Townhall side when Redline is not used.
			EndIf
	EndSwitch
	Return $nbSides
EndFunc   ;==>getNumberOfSides

Func getDeploymentInfo($nbSides) ; Returns the Deployment array for LaunchTroops
		; $ListInfoDeploy = [Troop, No. of Sides, $WaveNb, $MaxWaveNb, $slotsPerEdge]
	If $iMatchMode = $LB And ($iChkDeploySettings[$LB] = 5 Or $iChkDeploySettings[$LB] = 6) Then ; Customise DE side wave deployment here
		Local $listInfoDeploy[13][5] = [[$eGiant, $nbSides, 1, 1, 2] _
				, [$eWall, $nbSides, 1, 1, 2] _
				, [$eBarb, $nbSides, 1, 2, 2] _
				, [$eArch, $nbSides, 1, 3, 3] _
				, [$eBarb, $nbSides, 2, 2, 2] _
				, [$eArch, $nbSides, 2, 3, 3] _
				, ["CC", 1, 1, 1, 1] _
				, ["HEROES", 1, 2, 1, 0] _
				, [$eHogs, $nbSides, 1, 1, 1] _
				, [$eWiza, $nbSides, 1, 1, 0] _
				, [$eMini, $nbSides, 1, 1, 0] _
				, [$eArch, $nbSides, 3, 3, 2] _
				, [$eGobl, $nbSides, 1, 1, 1] _
				]

	ElseIf $nbSides = 5 Then
		Local $listInfoDeploy[11][5] = [[$eGiant, $nbSides, 1, 1, 2] _
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

	ElseIf $saveTroops =1 Then
		Local $listInfoDeploy[11][5] = [[$eGiant, $nbSides, 1, 2, 2] _
			, [$eBarb, $nbSides, 1, 2, 0] _
			, [$eWall, $nbSides, 1, 2, 1] _
			, [$eArch, $nbSides, 1, 2, 0] _
			, [$eGobl, $nbSides, 1, 2, 0] _
			, ["CC", 1, 1, 1, 1] _
			, [$eHogs, $nbSides, 1, 2, 1] _
			, [$eWiza, $nbSides, 1, 2, 0] _
			, [$eBall, $nbSides, 1, 2, 0] _
			, [$eMini, $nbSides, 1, 2, 0] _
			, ["HEROES", 1, 1, 1, 1] _
			]

	Else
		If $debugSetlog = 1 Then SetLog("listdeploy standard for attack", $COLOR_PURPLE)
		Local $listInfoDeploy[13][5] = [[$eGiant, $nbSides, 1, 1, 2] _
				, [$eBarb, $nbSides, 1, 2, 0] _
				, [$eWall, $nbSides, 1, 1, 1] _
				, [$eArch, $nbSides, 1, 2, 0] _
				, [$eBarb, $nbSides, 2, 2, 0] _
				, [$eGobl, $nbSides, 1, 2, 0] _
				, ["CC", 1, 1, 1, 1] _
				, [$eHogs, $nbSides, 1, 1, 1] _
				, [$eWiza, $nbSides, 1, 1, 0] _
				, [$eMini, $nbSides, 1, 1, 0] _
				, [$eArch, $nbSides, 2, 2, 0] _
				, [$eGobl, $nbSides, 2, 2, 0] _
				, ["HEROES", 1, 2, 1, 1] _
				]
	EndIf
	Return $listInfoDeploy
EndFunc    ;==>getDeploymentInfo

Func dropRemainingTroops($nbSides) ; Uses any left over troops
	SetLog("Dropping left over troops", $COLOR_BLUE)
	For $x = 0 To 1
		PrepareAttack($iMatchMode, True) ;Check remaining quantities
		For $i = $eBarb To $eLava ; lauch all remaining troops
			;If $i = $eBarb Or $i = $eArch Then
			LauchTroop($i, $nbSides, 0, 1)
			CheckHeroesHealth()
			If _Sleep($iDelayalgorithm_AllTroops5) Then Return
		Next
	Next
EndFunc   ;==>dropRemainingTroops

Func CloseBattle()
		For $i = 1 To 30
			;_CaptureRegion()
			If _ColorCheck(_GetPixelColor($aWonOneStar[0], $aWonOneStar[1], True), Hex($aWonOneStar[2], 6), $aWonOneStar[3]) = True Then ExitLoop ;exit if not 'no star'
			If _Sleep($iDelayalgorithm_AllTroops2) Then Return
		Next

		If IsAttackPage() Then ClickP($aSurrenderButton, 1, 0, "#0030") ;Click Surrender
		If _Sleep($iDelayalgorithm_AllTroops3) Then Return
		If IsEndBattlePage() Then
		   ClickP($aConfirmSurrender, 1, 0, "#0031") ;Click Confirm
		   If _Sleep($iDelayalgorithm_AllTroops1) Then Return
		 EndIf

EndFunc

Func algorithm_AllTroops() ;Attack Algorithm for all existing troops
	If $debugSetlog = 1 Then Setlog("algorithm_AllTroops", $COLOR_PURPLE)
	getHeroes()
	$saveTroops = 0
	$smartsaveend = 0
	Global $FourFinger = 0
	If _Sleep($iDelayalgorithm_AllTroops1) Then Return
	If $iMatchMode = $TS Then
		useTownHallSnipe()
		Return
	EndIf
	If ($iChkRedArea[$iMatchMode]) Then
		useSmartDeploy()
	EndIf
	Local $nbSides = getNumberOfSides()
	If $nbSides = 0 Then Return
	If _Sleep($iDelayalgorithm_AllTroops2) Then Return
	Local $listInfoDeploy = getDeploymentInfo($nbSides)
	$isCCDropped = False
	$DeployCCPosition[0] = -1
	$DeployCCPosition[1] = -1
	$isHeroesDropped = False
	$DeployHeroesPosition[0] = -1
	$DeployHeroesPosition[1] = -1
	If $saveTroops = 1 Then
		If $useFFBarchST = 1 Then $listInfoDeploy = outsidecollector($nbSides,$listInfoDeploy)
		Savetroop($listInfoDeploy, $CC, $King, $Queen, $Warden)
	Else
		LaunchTroop2($listInfoDeploy, $CC, $King, $Queen, $Warden)
	EndIf

	If _Sleep($iDelayalgorithm_AllTroops4) Then Return
	If $smartsaveend = 0 then
		dropRemainingTroops($nbSides)
	EndIf
	useHeroesAbility()
	SetLog("Finished Attacking, waiting for the battle to end")
EndFunc   ;==>algorithm_AllTroops
