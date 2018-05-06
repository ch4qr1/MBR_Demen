; #FUNCTION# ====================================================================================================================
; Name ..........: MOD GUI Design - Switch Accounts (#-12)
; Description ...: This file creates the "Switch Accounts" tab under the "MOD" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Demen
; Modified ......: Team AiO MOD++ (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hChkSwitchAcc = 0, $g_hCmbSwitchAcc = 0, $g_hChkSharedPrefs = 0, $g_hCmbTotalAccount = 0, $g_hChkSmartSwitch = 0, $g_hCmbTrainTimeToSkip = 0, $g_hChkDonateLikeCrazy = 0, _
	   $g_ahChkAccount[8], $g_ahCmbProfile[8], $g_ahChkDonate[8], _
	   $g_hRadSwitchGooglePlay = 0, $g_hRadSwitchSuperCellID = 0, $g_hRadSwitchSharedPrefs = 0
Global $g_hTxtSALog = 0

Func CreateModSwitchAcc()

	Local $x = 10, $y = 30

		$g_hCmbSwitchAcc = GUICtrlCreateCombo("", $x, $y, 175, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		Local $s = "No Switch Accounts Group"
		For $i = 1 To UBound($g_ahChkAccount)
			$s &= "|Switch Accounts Group " & $i
		Next
		GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "CmbSwitchAcc", $s), "No Switch Accounts Group")
		GUICtrlSetOnEvent(-1, "cmbSwitchAcc")

	$y += 25
		$g_hChkSwitchAcc = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "ChkSwitchAcc", "Enable Switch Accounts"), $x, $y, -1, -1)
		GUICtrlSetOnEvent(-1, "chkSwitchAcc")
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "ChkSwitchAcc_Info_01", "Enable or disable current selected Switch Accounts Group"))

		$g_hCmbTotalAccount = GUICtrlCreateCombo("", $x + 340, $y - 1, 77, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "2 accounts|3 accounts|4 accounts|5 accounts|6 accounts|7 accounts|8 accounts", "2 accounts")
		GUICtrlSetOnEvent(-1, "cmbTotalAcc")
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "CmbTotalAccount", "Total CoC Accounts") & ": ", $x + 220, $y + 4, -1, -1)

		$g_hRadSwitchGooglePlay = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "RadSwitchGooglePlay", "Google Play"), $x + 185, $y - 30, -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "RadSwitchGooglePlay_Info_01", "Only support for all Google Play accounts"))
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkAccSwitchMode")
		$g_hRadSwitchSuperCellID = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "RadSwitchSuperCellID", "SuperCell ID"), $x + 265, $y - 30, -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "RadSwitchSuperCellID_Info_01", "Only support for all SuperCell ID accounts"))
		GUICtrlSetOnEvent(-1, "chkAccSwitchMode")
		$g_hRadSwitchSharedPrefs = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "RadSwitchSharedPrefs", "Shared_prefs"), $x + 345, $y - 30, -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "RadSwitchSharedPrefs_Info_01", "Support for Google Play and SuperCell ID accounts"))
		GUICtrlSetOnEvent(-1, "chkAccSwitchMode")

	$y += 23
		$g_hChkSmartSwitch = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "ChkSmartSwitch", "Smart switch"), $x, $y, -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "ChkSmartSwitch_Info_01", "Switch to account with the shortest remain training time"))
		GUICtrlSetState(-1, $GUI_UNCHECKED)
		GUICtrlSetOnEvent(-1, "chkSmartSwitch")

		$g_hChkDonateLikeCrazy = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "DonateLikeCrazy", "Donate like Crazy"), $x + 100, $y, -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "DonateLikeCrazy_Info_01", "Enable it allows account switching in the order: Donate - Shortest Active - Donate - Shortest Active  - Donate...!"))
		GUICtrlSetOnEvent(-1, "chkSmartSwitch")

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "CmbTrainTime", "Skip switch if train time") & " <", $x + 220, $y + 4, -1, -1)
		$g_hCmbTrainTimeToSkip = GUICtrlCreateCombo("", $x + 340, $y - 1, 77, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "0 minute|1 minute|2 minutes|3 minutes|4 minutes|5 minutes|6 minutes|7 minutes|8 minutes|9 minutes", "1 minute")

	$y += 20
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Label_01", "Accounts"), $x - 5, $y, 60, -1, $SS_CENTER)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Label_02", "Profile name"), $x + 82, $y, 70, -1, $SS_CENTER)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Label_03", "Donate only"), $x + 170, $y, 60, -1, $SS_CENTER)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Label_04", "SwitchAcc log"), $x + 280, $y, -1, -1, $SS_CENTER)

	$y += 18
		GUICtrlCreateGraphic($x, $y, 417, 1, $SS_GRAYRECT)

	$y += 8
		For $i = 0 To UBound($g_ahChkAccount) - 1
			$g_ahChkAccount[$i] = GUICtrlCreateCheckbox("Acc " & $i + 1 & ".", $x, $y + ($i) * 25, -1, -1)
			GUICtrlSetOnEvent(-1, "chkAccountX")
			$g_ahCmbProfile[$i] = GUICtrlCreateCombo("", $x + 65, $y + ($i) * 25, 110, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "cmbSwitchAccProfileX")
			GUICtrlSetData(-1, _GUICtrlComboBox_GetList($g_hCmbProfile))
			$g_ahChkDonate[$i] = GUICtrlCreateCheckbox("", $x + 190, $y + ($i) * 25 - 3, -1, 25)
		Next

EndFunc   ;==>CreateBotSwitchAcc

Func CreateModSwitchAccLog()

	Local $x = 0, $y = 0
	Local $activeHWnD1 = WinGetHandle("") ; RichEdit Controls tamper with active window
	$g_hTxtSALog = _GUICtrlRichEdit_Create($g_hGUI_LOG_SA, "", $x, $y, 205, 215, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, $WS_HSCROLL, $ES_UPPERCASE, $ES_AUTOHSCROLL, $ES_AUTOVSCROLL, $ES_NUMBER, 0x200), $WS_EX_STATICEDGE)
	WinActivate($activeHWnD1) ; restore current active window

EndFunc   ;==>CreateBotSwitchAccLog
