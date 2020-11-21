; This file contains pre-defined constants and functions to control a CytExpert application.
; This is not a executable, just definitions for further usage in other scripts.
#include-once
#include <GuiMenu.au3>
#include "CUIAutomation2.au3"
#include "UIAWrappers.au3"
AutoItSetOption("MustDeclareVars", 1)

; Application related constants.
Global Const $APP_WIN_NAME = "CytExpert"
Global Const $WORKING_DIR = "C:\Program Files\CytExpert\"
Global Const $EXEC_FILE = "C:\Program Files\CytExpert\CytExpert.exe"
Global Const $EXEC_NAME = "CytExpert.exe"

; Log-in credentials on program start-up. (Only needed when app is not already running).
; TODO: Insert CytExpert login credentials here:
Global Const $USERNAME = ""
Global Const $PASSWORD = ""

; Status bar states.
Global Const $STATE_STANDBY = "Standby"
Global Const $STATE_READY = "Ready"
Global Const $STATE_BACKFLUSHING = "Backflushing"
Global Const $STATE_INITIALIZING = "Initializing"
Global Const $STATE_ACQUIRING = "Acquiring"


; Start-up the program. Do not use this when the program is already running.
; To check if the program already runs use 'ProcessExists($EXEC_NAME)'.
Func StartApp()
    ; Set working directory to installation path.
    FileChangeDir($WORKING_DIR)
    Run($EXEC_FILE)

    ; Wait for the Window to become active.
    WinWaitActive($APP_WIN_NAME)
    ; Log-in.
    ControlSend($APP_WIN_NAME, "", "[CLASSNN:WindowsForms10.EDIT.app.0.3e799b_r6_ad11]", $USERNAME & "{Enter}")
    ControlSend($APP_WIN_NAME, "", "[CLASSNN:WindowsForms10.EDIT.app.0.3e799b_r6_ad12]", $PASSWORD & "{Enter}")
    ; Wait some time for the application to start-up.
    Sleep(22000)
EndFunc


; Loads the template file in the application.
; $sTemplateFile: The path to the template file as String (e.g. "C:\Users\CytoFLEX-PC\Documents\CytExpert Data\User\MyTemplateFile.xitm")
; $sExperimentOutFile: (Optional) The output file the results get stored in (e.g. " "C:\Users\CytoFLEX-PC\Documents\CytExpert Data\User\MyExperimentOutFile.xit")
Func LoadTemplate($sTemplateFile, $sExperimentOutFile = "")
    If Not FileExists($sTemplateFile) Then
        ConsoleWriteError("Template file '" & $sTemplateFile & "' does not exist.")
        Exit(21)
    EndIf
    ; Open the menu via key strokes.
    Send("{Alt}{f}{f}")

    Local Const $sLoadTemplateWinTitle = "New Experiment from Template"
    WinWaitActive($sLoadTemplateWinTitle)
    ControlClick($sLoadTemplateWinTitle, "", "[NAME:sBtnExperimentBrowse]")
    WinWaitActive("New")
    If $sExperimentOutFile <> "" Then
        ; Type-in the out-file path (if available).
        Send($sExperimentOutFile & "{ENTER}")
    Else
        Send("{ENTER}")
    EndIf

    WinWaitActive($sLoadTemplateWinTitle)
    ControlClick($sLoadTemplateWinTitle, "", "[NAME:sBtnTemplateBrowse]")
    WinWaitActive("Open")
    ; Enter the template file path.
    Send($sTemplateFile & "{ENTER}")

    WinWaitActive($sLoadTemplateWinTitle)
    ControlClick($sLoadTemplateWinTitle, "", "[NAME:sBtnOK]")
    Sleep(1000)

    ; In case of default experiment output path.
    If WinWaitActive("New", "", 5) Then
        Send("{ENTER}")
    EndIf

    WinWaitActive($APP_WIN_NAME)
EndFunc


; Starts the device initialization. The state afterwards shown in the status bar should be "Ready".
Func Initialize()
    ; Wait until the "Initialize"-button gets enabled.
    While Not ControlCommand($APP_WIN_NAME, "Initialize", "[NAME:sBtnInitialize]", "IsEnabled")
        Sleep(1000)
    WEnd
    ControlClick($APP_WIN_NAME, "Initialize", "[NAME:sBtnInitialize]")

    ; In case of "Daily Clean" pop-up (No on default).
    If WinWait("Confirm", "", 5) Then
        Send("{Alt}{N}")
        WinWaitActive($APP_WIN_NAME)
    EndIf
EndFunc


; Proceeds a back-flush on the device. The state afterwards shown in the status bar should be "Completed Backflush.".
Func Backflush()
    ; Wait until "Backflush"-button gets enabled.
    While Not ControlCommand($APP_WIN_NAME, "Backflush", "[NAME:sBtnClean]", "IsEnabled")
        Sleep(1000)
    WEnd

    ControlClick($APP_WIN_NAME, "Backflush", "[NAME:sBtnClean]")
    WaitUntilStateChanged($STATE_READY)
EndFunc


; Opens the device hatch as soon as the "Eject"-button becomes enabled (e.g. before or after a experiment run).
Func OpenHatch()
    ; Activate the program and get the focus on the app window.
    WinActivate($APP_WIN_NAME)
    WinWaitActive($APP_WIN_NAME)

    ; Wait until "Eject"-button gets enabled.
    While Not ControlCommand($APP_WIN_NAME, "Eject", "[NAME:sBtnEject]", "IsEnabled")
        Sleep(1000)
    WEnd
    ControlClick($APP_WIN_NAME, "Eject", "[NAME:sBtnEject]")
    Sleep(3000)
EndFunc


; Closes the device hatch as soon as the "Load"-button becomes enabled. This is only the case if the hatch stands currently open.
Func CloseHatch()
    ; Activate the program and get the focus on the app window.
    WinActivate($APP_WIN_NAME)
    WinWaitActive($APP_WIN_NAME)

    ; Wait until "Load"-button gets enabled.
    While Not ControlCommand($APP_WIN_NAME, "Load", "[NAME:sBtnLoad]", "IsEnabled")
        Sleep(1000)
    WEnd

    ControlClick($APP_WIN_NAME, "Load", "[NAME:sBtnLoad]")
    Sleep(3000)
EndFunc


; Starts "Auto Record" as soon as the button becomes enabled.
Func AutoRecord()
    ; Activate the program and get the focus on the app window.
    WinActivate($APP_WIN_NAME)
    WinWaitActive($APP_WIN_NAME)

    ; Wait until "Auto Record"-button gets enabled.
    While Not ControlCommand($APP_WIN_NAME, "Auto Record", "[NAME:sBtnAutoRecord]", "IsEnabled")
        Sleep(1000)
    WEnd
    ControlClick($APP_WIN_NAME, "Auto Record", "[NAME:sBtnAutoRecord]")
EndFunc


; Closes the currently opened experiment.
Func CloseExperiment()
    ; Activate the program and get the focus on the app window.
    WinActivate($APP_WIN_NAME)

    ; Close experiment.
    Send("{Alt}{f}{c}")
EndFunc


; Retrieve the GUI element in the status bar which holds the info about the current state.
Func _GetAppStateElement()
    Local $oP2=_UIA_getObjectByFindAll($UIA_oDesktop, ";controltype:=UIA_WindowControlTypeId;class:=WindowsForms10.Window.8.app.0.3e799b_r6_ad1", $treescope_children)
    Local $oP1=_UIA_getObjectByFindAll($oP2, "Title:=Dock Bottom;controltype:=UIA_GroupControlTypeId;class:=WindowsForms10.Window.8.app.0.3e799b_r6_ad1", $treescope_children)
    Local $oP0=_UIA_getObjectByFindAll($oP1, "Title:=Status bar;controltype:=UIA_StatusBarControlTypeId;class:=WindowsForms10.Window.8.app.0.3e799b_r6_ad1", $treescope_children)
    Local $oUIElement=_UIA_getObjectByFindAll($oP0, "title:=Static;ControlType:=UIA_TextControlTypeId", $treescope_subtree)

    If Not _UIA_IsElement($oP0) Then
        Return Null
    EndIf

    Local $oAutomationElementArray
    Local $pStatusBarElements
    Local $pStateUiElement
    $oP0.FindAll($treescope_subtree, $UIA_oTRUECondition, $pStatusBarElements)
    $oAutomationElementArray = ObjCreateInterface($pStatusBarElements, $sIID_IUIAutomationElementArray, $dtagIUIAutomationElementArray)
    ; Get the second element form the status bar.
    $oAutomationElementArray.GetElement(2, $pStateUiElement)
    Return ObjCreateInterface($pStateUiElement, $sIID_IUIAutomationElement, $dtagIUIAutomationElement)
EndFunc


; Waits until the program changes its state in the status bar to the given target state.
; $sTargetState: The desired state to wait on as a String (e.g. "Ready").
Func WaitUntilStateChanged($sTargetState)
    Local Const $oStateElement = _GetAppStateElement()
    If Not IsObj($oStateElement) Then
        Exit (22)
    EndIf

    Local $sState
    Do
        $sState = _UIA_getPropertyValue($oStateElement, $UIA_LegacyIAccessibleValuePropertyId)
        if $sState = $sTargetState then ExitLoop
        Sleep(5000)
    Until False
EndFunc


; Waits until the program changes its state in the status bar to "Standby" or "Ready".
; returns: 0 on "Standby", 1 on "Ready" or -1 on error.
Func WaitUntilReady()
    Local Const $oStateElement = _GetAppStateElement()
    If Not IsObj($oStateElement) Then
        Return -1
    EndIf

    Local $sState
    Do
        $sState = _UIA_getPropertyValue($oStateElement, $UIA_LegacyIAccessibleValuePropertyId)
        if $sState = $STATE_STANDBY then Return 0
        if $sState = $STATE_READY then Return 1
        Sleep(5000)
    Until False
EndFunc
