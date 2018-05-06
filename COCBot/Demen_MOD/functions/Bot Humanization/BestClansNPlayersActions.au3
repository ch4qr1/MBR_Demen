; #FUNCTION# ====================================================================================================================
; Name ..........: Bot Humanization
; Description ...: This file contains all functions of Bot Humanization feature - Best Clans and Players Part
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: RoroTiti
; Modified ......: 11/11/2016
; Remarks .......: This file is part of MyBotRun. Copyright 2018
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: ---
;================================================================================================================================

Func VisitBestPlayers()
	Click(40, 80) ; open the cup menu
	randomSleep(1500)

	If IsClanOverview() Then
		Click(540, 80) ; open best players menu
		randomSleep(3000)

		If IsBestPlayers() Then
			Local $PlayerList = Random(1, 2, 1)
			Switch $PlayerList
				Case 1
					Click(270, 140) ; look at global list
					Click(580, 350 + 52 * Random(0, 6, 1))
					randomSleep(500)
					VisitAPlayer()
					Click(70, 680) ; return home
				Case 2
					Click(640, 140) ; look at local list
					randomSleep(1000)
					Click(580, 190 + 52 * Random(0, 9, 1))
					randomSleep(500)
					VisitAPlayer()
					Click(70, 680) ; return home
			EndSwitch
		Else
			SetLog("Error when trying to open Best Players menu... skipping...", $COLOR_WARNING)
		EndIf
	Else
		SetLog("Error when trying to open League menu... skipping...", $COLOR_WARNING)
	EndIf
EndFunc   ;==>VisitBestPlayers

Func LookAtBestClans()
	Click(40, 80) ; open the cup menu
	randomSleep(1500)

	If IsClanOverview() Then
		Click(360, 80) ; open best clans menu
		randomSleep(3000)

		If IsBestClans() Then
			Local $PlayerList = Random(1, 2, 1)
			Switch $PlayerList
				Case 1
					Click(270, 140) ; look at global list
					Click(580, 330 + 52 * Random(0, 6, 1))
				Case 2
					Click(640, 140) ; look at local list
					Click(580, 190 + 52 * Random(0, 9, 1))
			EndSwitch
			randomSleep(1500)

			If QuickMIS("BC1", @ScriptDir & "\imgxml\Resources\Bot Humanization\WarLog") Then
				SetLog("We have found a War log button, let's look at it...", $COLOR_ACTION1)
				Click(100, 340) ; open war log if available
				randomSleep(1500)
				SetLog("Let's scrolling the War log...", $COLOR_ACTION1)
				Scroll(Random(0, 2, 1)) ; scroll the war log
				SetLog("Exiting War log window...", $COLOR_ACTION1)
				Click(50, 80) ; click Return
			EndIf

			randomSleep(1500)
			SetLog("Let's scrolling the Clan member list...", $COLOR_ACTION1)
			Scroll(Random(3, 5, 1)) ; scroll the member list

			Click(830, 80) ; close window

		Else
			SetLog("Error when trying to open Best Players menu... skipping...", $COLOR_WARNING)
		EndIf
	Else
		SetLog("Error when trying to open League menu... skipping...", $COLOR_WARNING)
	EndIf
EndFunc   ;==>LookAtBestClans
