; #FUNCTION# ====================================================================================================================
; Name ..........: Functions_Demen_MOD
; Description ...: This file Includes several files in the current script.
; Syntax ........: #include
; Parameters ....: None
; Return values .: None
; Author ........: Demen_MOD
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

#include "functions\Config\saveConfig.au3"
#include "functions\Config\readConfig.au3"
#include "functions\Config\applyConfig.au3"

; Check Collector Outside
#include "functions\Mod's\AreCollectorsOutside.au3"

; Attack Now
#include "functions\Mod's\Attack Now.au3"

; Switch Accounts - Demen_MOD
#include "functions\Switch Account\SwitchAcc.au3"
#include "functions\Switch Account\UpdateMultiStats.au3"

; Smart Train - Demen_MOD
#include "functions\Smart Train\SmartTrain.au3"
#include "functions\Smart Train\CheckQueue.au3"
#include "functions\Smart Train\CheckTrainingTab.au3"
#include "functions\Smart Train\CheckPreciseTroop.au3"

; Hero and Lab Status - Demen_MOD
#include "functions\Switch Account\UpdateLabStatus.au3"

; Bot Humanization - AIO MOD
#include "functions\Bot Humanization\BotHumanization.au3"
#include "functions\Bot Humanization\AttackNDefenseActions.au3"
#include "functions\Bot Humanization\BestClansNPlayersActions.au3"
#include "functions\Bot Humanization\ChatActions.au3"
#include "functions\Bot Humanization\ClanActions.au3"
#include "functions\Bot Humanization\ClanWarActions.au3"

; Goblin XP - AIO MOD
#include "functions\GoblinXP\GoblinXP.au3"
#include "functions\GoblinXP\multiSearch.au3"
#include "functions\GoblinXP\ArrayFunctions.au3"

; ExtendedAttackBar - Demen_MOD
#include "functions\Mod's\ExtendedAttackBarCheck.au3"

; Chatbot - AIO MOD
#include "functions\Chatbot\Chatbot.au3"
#include "functions\Chatbot\Multy Lang.au3"

; CheckCC Troops - Demen_MOD
#include "functions\Mod's\CheckCC.au3"

; Switch Profile - Demen_MOD
#include "functions\Mod's\ProfileSwitch.au3"

; Check Grand Warden Mode - Demen_MOD
#include "functions\Mod's\CheckWardenMode.au3"

; Farm Schedule - Demen_MOD
#include "functions\Mod's\FarmSchedule.au3"

; Multi Finger - samm0d
#include "functions\Multi Fingers\Vectors\fourFingerStandard.au3"
#include "functions\Multi Fingers\Vectors\fourFingerSpiralLeft.au3"
#include "functions\Multi Fingers\Vectors\fourFingerSpiralRight.au3"
#include "functions\Multi Fingers\Vectors\eightFingerPinWheelLeft.au3"
#include "functions\Multi Fingers\Vectors\eightFingerPinWheelRight.au3"
#include "functions\Multi Fingers\Vectors\eightFingerBlossom.au3"
#include "functions\Multi Fingers\Vectors\eightFingerImplosion.au3"
#include "functions\Multi Fingers\fourFinger.au3"
#include "functions\Multi Fingers\eightFinger.au3"
#include "functions\Multi Fingers\multiFinger.au3"
#include "functions\Multi Fingers\unitInfo.au3"
