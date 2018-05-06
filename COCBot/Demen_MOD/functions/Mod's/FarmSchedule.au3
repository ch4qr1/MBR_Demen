; #FUNCTION# ====================================================================================================================
; Name ..........: Farm Schedule (#-27)
; Description ...:
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: Demen
; Modified ......: Team AiO MOD++ (2017)
; Remarks .......: This file is part of MyBotRun. Copyright 2018
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......:  =====================================================================================================================

Func CheckFarmSchedule()

	If Not ProfileSwitchAccountEnabled() Then Return

	Static $aiActionDone[8] = [0, 0, 0, 0, 0, 0, 0, 0]
	Static $iStartHour = @HOUR
	Local $bNeedSwitchAcc = False, $bNeedRunBot = False

	If $g_bFirstStart And $iStartHour = -1 Then $iStartHour = @HOUR
	Local $bActionDone = False
	If $g_bDebugSetlog Then SetDebugLog("Checking Farm Schedule...")

	For $i = 0 To 7
		If $i > $g_iTotalAcc Then ExitLoop
		If $g_abChkSetFarm[$i] Then
			Local $iAction = -1

			; Check timing schedule
			Local $iTimer1 = 25, $iTimer2 = 25
			If $g_aiCmbAction1[$i] >= 1 And $g_aiCmbCriteria1[$i] = 5 And $g_aiCmbTime1[$i] >= 0 Then $iTimer1 = Number($g_aiCmbTime1[$i])
			If $g_aiCmbAction2[$i] >= 1 And $g_aiCmbCriteria2[$i] = 5 And $g_aiCmbTime2[$i] >= 0 Then $iTimer2 = Number($g_aiCmbTime2[$i])

			If @HOUR < _Min($iTimer1, $iTimer2) Then ; both timers are ahead.
				$aiActionDone[$i] = 0
				$iStartHour = 0
			ElseIf @HOUR < _Max($iTimer1, $iTimer2) Then ; 1 timer has passed, 1 timer ahead
				If @HOUR = _Min($iTimer1, $iTimer2) Then $iStartHour = -1 ; in case @Hour = 0 or Missing 1st IF condition
				If $iTimer1 < $iTimer2 Then ; reach timer1, let's do action1
					If $aiActionDone[$i] <> 1 And $iStartHour < $iTimer1 Then
						$iAction = $g_aiCmbAction1[$i] - 1
						$aiActionDone[$i] = 1
					EndIf
				Else ; reach timer2, let's do action2
					If $aiActionDone[$i] <> 2 And $iStartHour < $iTimer2 Then
						$iAction = $g_aiCmbAction2[$i] - 1
						$aiActionDone[$i] = 2
					EndIf
				EndIf
			Else ; passed both timers
				If $iTimer1 < $iTimer2 Then
					If $aiActionDone[$i] <> 2 And $iStartHour < $iTimer2 Then
						$iAction = $g_aiCmbAction2[$i] - 1
						$aiActionDone[$i] = 2
					EndIf
				Else
					If $aiActionDone[$i] <> 1 And $iStartHour < $iTimer1 Then
						$iAction = $g_aiCmbAction1[$i] - 1
						$aiActionDone[$i] = 1
					EndIf
				EndIf
			EndIf

			If $g_bDebugSetlog Then SetDebugLog($i + 1 & ". $iTimer1 = " & $iTimer1 & ", $iTimer2 = " & $iTimer2 & ", Max = " & _Max($iTimer1, $iTimer2) & ", $iStartHour = " & $iStartHour &", $iAction = " & $iAction)

			; Check resource criteria for current account
			If $i = $g_iCurAccount And $iAction = -1 Then
				Local $asText[4] = ["Gold", "Elixir", "DarkE", "Trophy"]
				While 1
					If $g_aiCmbAction1[$i] >= 1 And $g_aiCmbCriteria1[$i] >= 1 And $g_aiCmbCriteria1[$i] <= 4 Then
						For $r = 1 To 4
							If $g_aiCmbCriteria1[$i] = $r And Number($g_aiCurrentLoot[$r - 1]) >= Number($g_aiTxtResource1[$i]) Then
								SetLog("Village " & $asText[$r - 1] & " detected above 1st criterium: " & $g_aiTxtResource1[$i])
								$iAction = $g_aiCmbAction1[$i] - 1
								ExitLoop 2
							EndIf
						Next
					EndIf
					If $g_aiCmbAction2[$i] >= 1 And $g_aiCmbCriteria2[$i] >= 1 And $g_aiCmbCriteria2[$i] <= 4 Then
						For $r = 1 To 4
							If $g_aiCmbCriteria2[$i] = $r And Number($g_aiCurrentLoot[$r - 1]) < Number($g_aiTxtResource2[$i]) And Number($g_aiCurrentLoot[$r - 1]) > 1 Then
								SetLog("Village " & $asText[$r - 1] & " detected below 2nd criterium: " & $g_aiTxtResource2[$i])
								$iAction = $g_aiCmbAction2[$i] - 1
								ExitLoop 2
							EndIf
						Next
					EndIf
					ExitLoop
				WEnd
			EndIf

			; Action
			Switch $iAction
				Case 0 ; turn Off (idle)
					If GUICtrlRead($g_ahChkAccount[$i]) = $GUI_CHECKED Then

						; Checking if this is the last active account
						Local $iSleeptime = CheckLastActiveAccount($i)
						If $iSleeptime > 1 Then
							SetLog("This is the last active/donate account to turn off.")
							SetLog("Let's go sleep until another account is scheduled to turn active/donate")
							SetSwitchAccLog("   Acc. " & $i + 1 & " go sleep", $COLOR_BLUE)
							UniversalCloseWaitOpenCoC($iSleeptime * 60 * 1000, "FarmSchedule", False, True) ; wake up & full restart
						EndIf

						GUICtrlSetState($g_ahChkAccount[$i], $GUI_UNCHECKED)
						chkAccount($i)
						$bActionDone = True
						If $i = $g_iCurAccount Then $bNeedSwitchAcc = True
						SetLog("Acc [" & $i + 1 & "] turned OFF")
						SetSwitchAccLog("   Acc. " & $i + 1 & " now Idle", $COLOR_BLUE)
					EndIf
				Case 1 ; turn Donate
					If GUICtrlRead($g_ahChkDonate[$i]) = $GUI_UNCHECKED Then
						_GUI_Value_STATE("CHECKED", $g_ahChkAccount[$i] & "#" & $g_ahChkDonate[$i])
						$bActionDone = True
						If $i = $g_iCurAccount Then $bNeedRunBot = True
						SetLog("Acc [" & $i + 1 & "] turned ON for Donating")
						SetSwitchAccLog("   Acc. " & $i + 1 & " now Donate", $COLOR_BLUE)
					EndIf
				Case 2 ; turn Active
					If GUICtrlRead($g_ahChkAccount[$i]) = $GUI_UNCHECKED Or GUICtrlRead($g_ahChkDonate[$i]) = $GUI_CHECKED Then
						GUICtrlSetState($g_ahChkAccount[$i], $GUI_CHECKED)
						GUICtrlSetState($g_ahChkDonate[$i], $GUI_UNCHECKED)
						$bActionDone = True
						If $i = $g_iCurAccount Then $bNeedRunBot = True
						SetLog("Acc [" & $i + 1 & "] turned ON for Farming")
						SetSwitchAccLog("   Acc. " & $i + 1 & " now Active", $COLOR_BLUE)
					EndIf
			EndSwitch
		EndIf
	Next

	If $bActionDone Then
		SaveConfig_SwitchAcc()
		ReadConfig_SwitchAcc()
		UpdateMultiStats(False)
	EndIf

	If _Sleep(500) Then Return

	If $bNeedSwitchAcc Then
		Local $aActiveAccount = _ArrayFindAll($g_abAccountNo, True)
		If UBound($aActiveAccount) >= 1 Then
			$g_iNextAccount = $aActiveAccount[0]
			SwitchCOCAcc($g_iNextAccount)
		EndIf

	ElseIf $bNeedRunBot Then
		runBot()
	EndIf

EndFunc   ;==>CheckFarmSchedule

Func CheckLastActiveAccount($i)

	Local $iSleeptime = 0 ; result in minutes
	Local $aActiveAccount = _ArrayFindAll($g_abAccountNo, True)

	If $i = $g_iCurAccount And UBound($aActiveAccount) <= 1 Then
		Local $iCurrentTime = @HOUR + @MIN / 60 + @SEC / 3600 ; decimal hour
		Local $iSoonestTimer = -1
		For $i = 0 To 7
			If $i > $g_iTotalAcc Then ExitLoop
			If $g_abChkSetFarm[$i] Then
				If $g_aiCmbAction1[$i] >= 1 And $g_aiCmbCriteria1[$i] = 5 And $g_aiCmbTime1[$i] >= 0 Then
					Local $ConvertTime1 = $g_aiCmbTime1[$i] + $g_aiCmbTime1[$i] <= @HOUR ? 24 : 0
					If $iSoonestTimer = -1 Or $iSoonestTimer > $ConvertTime1 Then $iSoonestTimer = $ConvertTime1
				EndIf
				If $g_aiCmbAction2[$i] >= 1 And $g_aiCmbCriteria2[$i] = 5 And $g_aiCmbTime2[$i] >= 0 Then
					Local $ConvertTime2 = $g_aiCmbTime2[$i] + $g_aiCmbTime2[$i] <= @HOUR ? 24 : 0
					If $iSoonestTimer = -1 Or $iSoonestTimer > $ConvertTime2 Then $iSoonestTimer = $ConvertTime2
				EndIf
				If $g_bDebugSetlog Then SetDebugLog("@Hour: " & @HOUR & "Timers " & $i + 1 & ": " & $g_aiCmbTime1[$i] & " / " & $g_aiCmbTime2[$i] & ". $iSoonestTimer = " & $iSoonestTimer)
			EndIf
		Next
		If $g_bDebugSetlog Then SetDebugLog("$iSoonestTimer = " & $iSoonestTimer)
		If $iSoonestTimer >= 0 Then $iSleeptime = ($iSoonestTimer - $iCurrentTime) * 60
	EndIf

	If $g_bDebugSetlog Then SetDebugLog("$iSleeptime: " & Round($iSleeptime, 2) & " m")

	Return $iSleeptime

EndFunc   ;==>CheckLastActiveAccount
