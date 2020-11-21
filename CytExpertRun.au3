#include <GuiMenu.au3>
#include <MsgBoxConstants.au3>
#include "CytExpertDefs.au3"

; Check if the program is started.
If ProcessExists($EXEC_NAME) Then
    ; Activate the program and get the focus on the app window.
    WinActivate($APP_WIN_NAME)
    WinWaitActive($APP_WIN_NAME)
Else
    ConsoleWriteError("The program is not running. (13)")
    Exit(13)
EndIf

Local $oStateElement = _GetAppStateElement()
If Not IsObj($oStateElement) Then
    ; Exit with error 10.
    ConsoleWriteError("Can not get state from status bar. (10)")
    Exit(10)
EndIf

; Check if the the app can be used.
Local $sState= _UIA_getPropertyValue($oStateElement, $UIA_LegacyIAccessibleValuePropertyId)
If Not ($sState = $STATE_READY) Then
    ; Exit with error 11.
    ConsoleWriteError("The program is busy or in an unusable state. (11)")
    Exit(11)
EndIf

; Loads the inserted sample.
CloseHatch()
; Start the loaded experiment.
AutoRecord()
; Wait until the experiment has finished (un-)successfuly.
WaitUntilReady()
; Cleanup afterwards.
CloseExperiment()

Exit(0)
