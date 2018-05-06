; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyHeroCount
; Description ...: Obtains count of heroes available from Training - Army Overview window
; Syntax ........: getArmyHeroCount()
; Parameters ....: $bOpenArmyWindow  = Bool value true if train overview window needs to be opened
;				 : $bCloseArmyWindow = Bool value, true if train overview window needs to be closed
; Return values .: None
; Author ........:
; Modified ......: MonkeyHunter (06-2016), MR.ViPER (10-2016), Fliegerfaust (03-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getArmyHeroCount($bOpenArmyWindow = False, $bCloseArmyWindow = False, $CheckWindow = True, $bSetLog = True)

	If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("Begin getArmyHeroCount:", $COLOR_DEBUG)

	If $CheckWindow Then
		If Not $bOpenArmyWindow And Not IsTrainPage() Then ; check for train page
			SetError(1)
			Return ; not open, not requested to be open - error.
		ElseIf $bOpenArmyWindow Then
			If Not OpenArmyOverview(True, "getArmyHeroCount()") Then
				SetError(2)
				Return ; not open, requested to be open - error.
			EndIf
			If _Sleep($DELAYCHECKARMYCAMP5) Then Return
		EndIf
	EndIf

	$g_iHeroAvailable = $eHeroNone ; Reset hero available data
	Local $iDebugArmyHeroCount = 0 ; local debug flag

	; Detection by OCR
	Local $sResult
	Local Const $iHeroes = 3
	Local $sMessage = ""

	For $i = 0 To $iHeroes - 1
		$sResult = ArmyHeroStatus($i)
		If $sResult <> "" Then ; we found something, figure out what?
			Select
				Case StringInStr($sResult, "king", $STR_NOCASESENSEBASIC)
					If $bSetLog Then SetLog(" - Barbarian King Available", $COLOR_SUCCESS)
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroKing)
				Case StringInStr($sResult, "queen", $STR_NOCASESENSEBASIC)
					If $bSetLog Then SetLog(" - Archer Queen Available", $COLOR_SUCCESS)
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroQueen)
				Case StringInStr($sResult, "warden", $STR_NOCASESENSEBASIC)
					If $bSetLog Then SetLog(" - Grand Warden Available", $COLOR_SUCCESS)
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroWarden)
				Case StringInStr($sResult, "heal", $STR_NOCASESENSEBASIC)
					If $g_bDebugSetlogTrain Or $iDebugArmyHeroCount = 1 Then
						Switch $i
							Case 0
								$sMessage = "-Barbarian King"
							Case 1
								$sMessage = "-Archer Queen"
							Case 2
								$sMessage = "-Grand Warden"
							Case Else
								$sMessage = "-Very Bad Monkey Needs"
						EndSwitch
						SetLog("Hero slot#" & $i + 1 & $sMessage & " Healing", $COLOR_DEBUG)
					EndIf
				Case StringInStr($sResult, "upgrade", $STR_NOCASESENSEBASIC)
					Switch $i
						Case 0
							$sMessage = "-Barbarian King"
							; safety code to warn user when wait for hero found while being upgraded to reduce stupid user posts for not attacking
							If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroKing) = $eHeroKing) Or _
									($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroKing) = $eHeroKing) Then ; check wait for hero status
								If $g_iSearchNotWaitHeroesEnable Then
									$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroKing)
								Else
									SetLog("Warning: King Upgrading & Wait enabled, Disable Wait for King or may never attack!", $COLOR_ERROR)
								EndIf
								_GUI_Value_STATE("SHOW", $groupKingSleeping) ; Show king sleeping icon
							EndIf
						Case 1
							$sMessage = "-Archer Queen"
							; safety code
							If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroQueen) = $eHeroQueen) Or _
									($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroQueen) = $eHeroQueen) Then
								If $g_iSearchNotWaitHeroesEnable Then
									$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroQueen)
								Else
									SetLog("Warning: Queen Upgrading & Wait enabled, Disable Wait for Queen or may never attack!", $COLOR_ERROR)
								EndIf
								_GUI_Value_STATE("SHOW", $groupQueenSleeping) ; Show Queen sleeping icon
							EndIf
						Case 2
							$sMessage = "-Grand Warden"
							; safety code
							If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroWarden) = $eHeroWarden) Or _
									($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroWarden) = $eHeroWarden) Then
								If $g_iSearchNotWaitHeroesEnable Then
									$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroWarden)
								Else
									SetLog("Warning: Warden Upgrading & Wait enabled, Disable Wait for Warden or may never attack!", $COLOR_ERROR)
								EndIf
								_GUI_Value_STATE("SHOW", $groupWardenSleeping) ; Show Warden sleeping icon
							EndIf
						Case Else
							$sMessage = "-Need to Feed Code Monkey some bananas"
					EndSwitch
					If $g_bDebugSetlogTrain Or $iDebugArmyHeroCount = 1 Then SetLog("Hero slot#" & $i + 1 & $sMessage & " Upgrade in Process", $COLOR_DEBUG)
				Case StringInStr($sResult, "none", $STR_NOCASESENSEBASIC)
					If $g_bDebugSetlogTrain Or $iDebugArmyHeroCount = 1 Then SetLog("Hero slot#" & $i + 1 & " Empty, stop count", $COLOR_DEBUG)
					ExitLoop ; when we find empty slots, done looking for heroes
				Case Else
					If $bSetLog Then SetLog("Hero slot#" & $i + 1 & " bad OCR string returned!", $COLOR_ERROR)
			EndSelect
		Else
			If $bSetLog Then SetLog("Hero slot#" & $i + 1 & " status read problem!", $COLOR_ERROR)
		EndIf
	Next

	If $g_bDebugSetlogTrain Or $iDebugArmyHeroCount = 1 Then SetLog("Hero Status K|Q|W : " & BitAND($g_iHeroAvailable, $eHeroKing) & "|" & BitAND($g_iHeroAvailable, $eHeroQueen) & "|" & BitAND($g_iHeroAvailable, $eHeroWarden), $COLOR_DEBUG)

	If $bCloseArmyWindow Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($DELAYCHECKARMYCAMP4) Then Return
	EndIf

EndFunc   ;==>getArmyHeroCount

Func ArmyHeroStatus($i)
	Local $DebugThisFunc = 0
	Local $sImageDir = @ScriptDir & "\imgxml\trainwindow\herostatus", $sResult = ""
	Local Const $aHeroesRect[3][4] = [[606, 338, 682, 390], [681, 338, 756, 390], [755, 338, 833, 390]]

	$sResult = QuickMIS("N1", $sImageDir, $aHeroesRect[$i][0], $aHeroesRect[$i][1], $aHeroesRect[$i][2], $aHeroesRect[$i][3])

    If $DebugThisFunc = 1 Then
        Setlog("return from quickMis for " & NameOfTroop($i+$eKing) & ":" & $sResult)
    EndIf

	Return $sResult

EndFunc   ;==>ArmyHeroStatus
