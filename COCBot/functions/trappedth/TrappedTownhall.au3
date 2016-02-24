;l; #FUNCTION# ====================================================================================================================
; Name ..........: TrapedTownhalls
; Description ...: This file Includes the Variables and functions to detect certain defenses near TH, based on checkTownhall.au3
; Syntax ........:
; Parameters ....: None
; Return values .:
; Author ........: The Master
; Modified ......:
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================


Func TrappedTHCond()

	If $icmbDetectTrapedTH <> 0 Then
		If $searchTH <> "-" Then
			$searchDef = checkDefense()
			SetLog($searchDef)
			$TrappedAllIn = False


				Switch $icmbDetectTrapedTH
					Case 0
						;do nothing
					    SetLog($GetResourcesTXT, $COLOR_GREEN, "Lucida Console", 7.5)
						SetLog("      " & "TH Outside Found! " , $COLOR_GREEN, "Lucida Console", 7.5)
						$logwrited = True
						$iMatchMode = $TS
					Case 1
						$TrappedAllIn = True
						Setlog("Trapped TH detected.. Let's do this!", $COLOR_ORANGE)
						$iMatchMode = $TS
					Case 2
						$searchTH = "-"
						Setlog("Trapped TH detected..Skipping Th", $COLOR_ORANGE)
				EndSwitch

		EndIf
	EndIf
EndFunc   ;==>TrappedTHCond


Func AttackTrappedTHAllIn()

	$TrappedAllIn = False


	SetLog("Attack Th all In...sending Traps Eaters...", $COLOR_GREEN)
	AttackTHGrid($eBarb, 4, 1, 2000,  0) ; deploys 4 Barbarians to "reveal" teslas or bombs
	If CheckOneStar() Then Return
	AttackTHGrid($eGiant, 4, 1, 1000, 0) ;releases 4 giants spread out to take traps
	If CheckOneStar() Then Return

	Setlog("Send In every one!", $COLOR_GREEN)
	SpellTHGrid($eHSpell)
	If CheckOneStar() Then Return
	SpellTHGrid($eRSpell)
	If CheckOneStar() Then Return
	AttackTHGrid($eGiant, 4, 6, 100, 0) ; deploys up to 24 giants
	If CheckOneStar() Then Return
	AttackTHGrid($eHeal, 1, 1, 10, 0) ; deploys 1 healer
	If CheckOneStar() Then Return
	AttackTHGrid($eWall, 2, 1, 100,  0) ; deploys 2 wallbreakers
	If CheckOneStar() Then Return
	AttackTHGrid($eWall, 2, 1, 100, 0) ; deploys 2 wallbreakers
	If CheckOneStar() Then Return
	AttackTHGrid($eWall, 2, 1, 100,  0) ; deploys 2 wallbreakers
	If CheckOneStar() Then Return
	AttackTHGrid($eWall, 2, 1, 100,  0) ; deploys 2 wallbreakers
	If CheckOneStar() Then Return
	AttackTHGrid($eCastle, 1, 1, 100,  0) ; deploys CC
	If CheckOneStar() Then Return
	AttackTHGrid($eKing, 1, 1, 100,  0) ; deploys King
	If CheckOneStar() Then Return
	AttackTHGrid($eQueen, 1, 1, 100,  0) ; deploys Queen
	If CheckOneStar() Then Return
	AttackTHGrid($eHeal, 2, 1, 10,  0) ; deploys 2 healer
	If CheckOneStar() Then Return
	AttackTHGrid($eBarb, 5, 10, 100,  0) ; deploys up to 50 barbarians
	If CheckOneStar() Then Return
	AttackTHGrid($eArch, 5, 10, 100,  0) ; deploys up to 50 archers
	If CheckOneStar() Then Return
	AttackTHGrid($eBarb, 5, 10, 100,  0) ; deploys up to 50 barbarians
	If CheckOneStar() Then Return
	AttackTHGrid($eArch, 5, 10, 100, 0) ; deploys up to 50 archers
	If CheckOneStar() Then Return

	For $i = $eHSpell To $eHaSpell ; Deploy one from all spells types
		If CheckOneStar() Then Return
		SpellTHGrid($i)
	Next

	For $i = $eBarb To $eArch ; Deploy Remaining Barb,archers
		If CheckOneStar() Then Return
		AttackTHGrid($i, 5, 20, 100, 0)
	Next

	For $i = $eGole To $eLava ; Deploy Remaining troops
		If CheckOneStar() Then Return
		AttackTHGrid($i, 5, 2, 100, 0)
	Next

	For $i = $eGiant To $eValk ; Deploy Remaining troops
		If CheckOneStar() Then Return
		AttackTHGrid($i, 5, 10, 100, 0)
	Next

	For $i = 1 To 5 ; struck TH by all lightning spells
		If CheckOneStar() Then Return
		SpellTHGrid($eLSpell)
	Next

	SetLog("~Finished Attacking, waiting to finish", $COLOR_GREEN)

	For $count = 0 To 60
		If CheckOneStar() Then Return
		If _Sleep(1000) Then Return
	Next

EndFunc   ;==>AttackTrappedTHAllIn
