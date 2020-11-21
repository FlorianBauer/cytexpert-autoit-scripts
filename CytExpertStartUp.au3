#include <GuiMenu.au3>
#include "CytExpertDefs.au3"

; Check if the program needs to be started.
If Not ProcessExists($EXEC_NAME) Then
    StartApp()
Else
    ; Program is already running, so activate it and get the focus on the app window.
    WinActivate($APP_WIN_NAME)
    WinWaitActive($APP_WIN_NAME)
EndIf

; Retriev the current app state.
Local $oStateElement = _GetAppStateElement()
If Not IsObj($oStateElement) Then
    ; Exit with error 10.
    ConsoleWriteError("Can not get state from status bar. (10)")
    Exit(10)
EndIf

; Check if the the app can be used ("Standby" or "Ready" state).
Local $sState = WaitUntilReady()
If $sState = 0 Then
    ; Is in "Standby"-state and must be initialized first.
    Initialize()
    ; Do a back-flush.
    Backflush()
ElseIf $sState <> 1 Then
    ; Exit with error 11.
    ConsoleWriteError("The program is busy or in an unusable state. (11)")
    Exit(11)
EndIf

Exit(0)
