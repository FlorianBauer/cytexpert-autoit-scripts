#include <GuiMenu.au3>
#include "CytExpertDefs.au3"

; Check if at least the template file (*.xitm) was provided.
If $CmdLine[0] >= 1 Then
    Local $sTemplateFile = $CmdLine[1]
    Local $sExperimentOutFile = ""

    If Not FileExists($sTemplateFile) Then
        ; Exit with error 12.
        ConsoleWriteError("File '" & $sTemplateFile & "' does not exist. (12)")
        Exit(12)
    EndIf

    If $CmdLine[0] >= 2 Then
        ; Set the second, optional argument for the output file, if avialable.
        $sExperimentOutFile = $CmdLine[2]
    EndIf

    ; Check if the program is started.
    If ProcessExists($EXEC_NAME) Then
        ; Activate the program and get the focus on the app window.
        WinActivate($APP_WIN_NAME)
        WinWaitActive($APP_WIN_NAME)
    Else
        ConsoleWriteError("The program is not running. (13)")
        Exit(13)
    EndIf

    ; Retriev the current app state.
    Local $oStateElement = _GetAppStateElement()
    If Not IsObj($oStateElement) Then
        ; Exit with error 10.
        ConsoleWriteError("Can not get state from status bar. (10)")
        Exit(10)
    EndIf

    ; Check if the the app can be used ("Standby" or "Ready" state).
    Local $sState= _UIA_getPropertyValue($oStateElement, $UIA_LegacyIAccessibleValuePropertyId)
    If $sState = $STATE_STANDBY Then
        ; Is in "Standby"-state and must be initialized first.
        Initialize()
    ElseIf Not ($sState = $STATE_READY) Then
        ; Exit with error 11.
        ConsoleWriteError("The program is busy or in an unusable state. (11)")
        Exit(11)
    EndIf

    ; Now load the experiment files.
    LoadTemplate($sTemplateFile, $sExperimentOutFile)

    ; Open the device hatch. After that, the sample can be inserted (manually or by roboter arm).
    OpenHatch()
    ; The job of this scipt is now done. To run the actual loaded experiment start the "RunCytExpert.au3" script.
    Exit(0)
Else
    ConsoleWriteError("No template file argument was provided. (2)")
    Exit(2)
EndIf
