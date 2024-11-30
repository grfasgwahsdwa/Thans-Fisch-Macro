#SingleInstance, force

; ==============================================================
; SETTINGS
ControlRod := 0.15
clickholdtime := 50
valreducedholdtime := 20
sleepTime := 15
shaketimeout := 50
navigationKey := "\"
kp := 1.0
ki := 0.1
kd := 0.025
; ==============================================================

if (A_ScreenDPI*100//96 != 100) {
	Run, ms-settings:display
	msgbox, 0x1030, WARNING!!, % "Your Display Scale seems to be a value other than 100`%. This means the macro will NOT work correctly!`n`nTo change this, right click on your Desktop -> Click 'Display Settings' -> Under 'Scale & Layout', set Scale to 100`% -> Close and Restart Roblox before starting the macro.", 60
	ExitApp
}
If !FileExist("Settings.ini") {
	Msgbox,,Fisch Macro,You don't have a settings file yet. Would you like to create one? Press OK to proceed
	IniWrite, %ControlRod%, Settings.ini, Fisch, Control
	IniWrite, %clickholdtime%, Settings.ini, Fisch, clickHoldTime
	IniWrite, %valreducedholdtime%, Settings.ini, Fisch, ValReducedHoldTime
	IniWrite, %sleepTime%, Settings.ini, Fisch, sleeptime
	IniWrite, %shaketimeout%, Settings.ini, Fisch, shakeTimeout
	IniWrite, %navigationKey%, Settings.ini, Fisch, NavigationKey
	IniWrite, %kp%, Settings.ini, PID, Proportional
	IniWrite, %ki%, Settings.ini, PID, Integral
	IniWrite, %kd%, Settings.ini, PID, Derivative
}
IniRead, Control, Settings.ini, Fisch, Control
If (Control = "ERROR") {
	IniWrite, %ControlRod%, Settings.ini, Fisch, Control
	Control := ControlRod
}
IniRead, clickHoldTime, Settings.ini, Fisch, clickHoldTime
If (clickHoldTime = "ERROR") {
	IniWrite, %clickholdtime%, Settings.ini, Fisch, clickHoldTime
	clickHoldTime := clickholdtime
}
IniRead, ValReducedHoldTime, Settings.ini, Fisch, ValReducedHoldTime
If (ValReducedHoldTime = "ERROR") {
	IniWrite, %valreducedholdtime%, Settings.ini, Fisch, ValReducedHoldTime
	ValReducedHoldTime := valreducedholdtime
}
IniRead, sleeptime, Settings.ini, Fisch, sleeptime
If (sleeptime = "ERROR") {
	IniWrite, %sleepTime%, Settings.ini, Fisch, sleeptime
	sleeptime := sleepTime
}
IniRead, shakeTimeout, Settings.ini, Fisch, shakeTimeout
If (shakeTimeout = "ERROR") {
	IniWrite, %shaketimeout%, Settings.ini, Fisch, shakeTimeout
	shakeTimeout := shaketimeout
}
IniRead, NavigationKey, Settings.ini, Fisch, NavigationKey
If (NavigationKey = "ERROR") {
	IniWrite, %navigationKey%, Settings.ini, Fisch, NavigationKey
	NavigationKey := navigationKey
}
IniRead, Kp, Settings.ini, PID, Proportional
If (Kp = "ERROR") {
	IniWrite, %kp%, Settings.ini, PID, Proportional
	Kp := kp
}
IniRead, Ki, Settings.ini, PID, Integral
If (Ki = "ERROR") {
	IniWrite, %ki%, Settings.ini, PID, Integral
	Ki := ki
}
IniRead, Kd, Settings.ini, PID, Derivative
If (Kd = "ERROR") {
	IniWrite, %kd%, Settings.ini, PID, Derivative
	Kd := kd
}

global RodControl := Control
global ShakeTimeout := shakeTimeout * 2
global NavigationKey := NavigationKey
global Kp := Kp
global Ki := Ki
global Kd := Kd

Control := StrSplit(Control, "|")

If (Control[2]) {
	Msgbox The control settings are outdated.`nRestored the settings to their default values.
	IniWrite, 0.05, Settings.ini, Fisch, Control
	ExitApp
}
global BarSize := Floor(96+(Control[1]*326.67)) ; calculating the catch bar size pretty pro right
If (!Control) {
	Msgbox, Failed to retrieve control from settings.ini
	ExitApp
}

Calculations:
	WinGetActiveStats, Title, WindowWidth, WindowHeight, WindowLeft, WindowTop

	global TooltipX := WindowWidth/1.1
	global Tooltip1 := (WindowHeight/2)-(20*9)
	global Tooltip2 := (WindowHeight/2)-(20*8)
	global Tooltip3 := (WindowHeight/2)-(20*7)
	global Tooltip4 := (WindowHeight/2)-(20*6)
	global Tooltip5 := (WindowHeight/2)-(20*5)
	global Tooltip6 := (WindowHeight/2)-(20*4)
	global Tooltip7 := (WindowHeight/2)-(20*3)
	global Tooltip8 := (WindowHeight/2)-(20*2)
	global Tooltip9 := (WindowHeight/2)-(20*1)
	global Tooltip10 := (WindowHeight/2)
	global Tooltip11 := (WindowHeight/2)+(20*1)
	global Tooltip12 := (WindowHeight/2)+(20*2)
	global Tooltip13 := (WindowHeight/2)+(20*3)
	global Tooltip14 := (WindowHeight/2)+(20*4)
	global Tooltip15 := (WindowHeight/2)+(20*5)
	global Tooltip16 := (WindowHeight/2)+(20*6)
	global Tooltip17 := (WindowHeight/2)+(20*7)
	global Tooltip18 := (WindowHeight/2)+(20*8)
	global Tooltip19 := (WindowHeight/2)+(20*9)
	global Tooltip20 := (WindowHeight/2)+(20*10)

	global caught := 0
	global total := 0
	global debounce := 0

	global PreviousError := 0
	global IntegralError := 0

	tooltip, Made By thansar62, %TooltipX%, %Tooltip1%, 1
	tooltip, Current Task: Paused, %TooltipX%, %Tooltip2%, 2
	tooltip, Press "P" to Start, %TooltipX%, %Tooltip4%, 4
	tooltip, Press "O" to Reload or "R" to Pause, %TooltipX%, %Tooltip5%, 5
	tooltip, Press "M" to Exit, %TooltipX%, %Tooltip6%, 6
	tooltip, Rod Control: %RodControl%, %TooltipX%, %Tooltip8%, 8
	tooltip, Caught: %caught% / %total%, %TooltipX%, %Tooltip12%, 12

$o:: reload
$m:: exitapp
$r:: pause()
$p:: run()

run() {
	setup()

}

pause() {
	tooltip, Made By thansar62, %TooltipX%, %Tooltip1%, 1
	tooltip, Current Task: Paused, %TooltipX%, %Tooltip2%, 2
	tooltip,,,, 4
	tooltip, Press "O" to Unpause & Reload, %TooltipX%, %Tooltip5%, 5
	tooltip, Press "M" to Exit, %TooltipX%, %Tooltip6%, 6
	tooltip, Rod Control: %RodControl%, %TooltipX%, %Tooltip8%, 8
	tooltip, Caught: %caught% / %total%, %TooltipX%, %Tooltip12%, 12
	Pause, On
}

setup() {
	minimizeWindow()
	setupTooltips()
	loopProgram()
}

loopProgram() {
	Loop, {
		Loop, {
			checkCameraMode()
			cast()
			if (shake()) {
				break
			} else {
				continue
			}
		}
		catchFish()
		Sleep 500
	}
}

minimizeWindow() {
	if GetRobloxHWND() {
		x := A_ScreenWidth
		y := A_ScreenHeight
		WinActivate, ahk_exe RobloxPlayerbeta.exe
		WinMove, ahk_exe RobloxPlayerBeta.exe,, x/2-408, y/2-408, 100, 100
	} else {
		Msgbox Roblox need to be opened
		ExitApp
	}
}

catchFish() {
	debounce := 0
	total++
	tooltip, Current Task: Catching, %TooltipX%, %Tooltip2%, 2
	tooltip, Caught: %caught% / %total%, %TooltipX%, %Tooltip12%, 12
	loop, {
		PixelSearch, Px, Py, 246, 533, 569, 533, 0xf1f1f1, 20, FastRGB
		if(ErrorLevel = 0) {
			catchCalculations()
		} else {
			PixelSearch, Px, Py, 246, 533, 569, 533, 0x434b5b, 3, FastRGB
			if(ErrorLevel = 0) {
				catchCalculations()
			} else {
				tooltip,,,
				PreviousError := 0
				IntegralError := 0
				break
			}
		}
	}
}

catchCalculations() {
	loop, {
		PixelSearch, CurrentTarget,, 246, 533, 569, 533, 0x434b5b, 3, FastRGB
		if(ErrorLevel = 1) {
			Break
		} else {
			checkProgress()
			tooltip, ., CurrentTarget, 580, 6
			If (CurrentTarget <= ((BarSize / 2) + 247)) {
				PreviousError := 0
				IntegralError := 0
				tooltip, |, 247, 570, 8
				tooltip, V, 247 + (BarSize / 2), 570, 7
				tooltip, <, BarSize + 247 - 40, 570, 9
				Sleep 40
				tooltip go left
			} else If (CurrentTarget >= (568 - (BarSize / 2))) {
				PreviousError := 0
				IntegralError := 0
				tooltip, >, 568 - BarSize + 40, 570, 8
				tooltip, |, 568, 570, 9
				tooltip, V, 568 - (BarSize / 2), 570, 7
				Click, Down
				tooltip go right
				Loop
				{
					checkProgress()
					PixelSearch, CurrentTarget,, 246, 533, 569, 533, 0x434b5b, 3, FastRGB
					If (ErrorLevel = 0) {
						tooltip, ., CurrentTarget, 580, 6
						tooltip, >, 568 - BarSize + 40, 570, 8
						tooltip, |, 568, 570, 9
						tooltip, V, 568 - (BarSize / 2), 570, 7
						If (CurrentTarget <= (568 - (BarSize / 2))) {
							tooltip,,,, 8
							Break
						}
					} else {
						Break
					}
				}
				Click, Up
			} else {
				PixelSearch, CurrentBarPosition,, 251, 533, 564, 533, 0xf1f1f1, 20, FastRGB
				if(ErrorLevel = 0) {
					PIDClick(CurrentBarPosition)
				} else {
					PixelSearch, CurrentBarPosition,, 251, 533, 564, 533, 0x4c4437, 15, FastRGB
					if(ErrorLevel = 0) {
						PIDClick(CurrentBarPosition)
					} else {
						PixelSearch, CurrentBarPosition,, 251, 533, 564, 533, 0x4f2725, 15, FastRGB
						if(ErrorLevel = 0) {
							PIDClick(CurrentBarPosition)
						} else {
							PixelSearch, CurrentBarPosition,, 251, 533, 564, 533, 0x495d44, 15, FastRGB
							if(ErrorLevel = 0) {
								PIDClick(CurrentBarPosition)
							}
						}
					}
				}
			}
		}
	}
}

PIDClick(CurrentBarPosition) {
	PixelSearch, CurrentTarget,, 246, 533, 569, 533, 0x434b5b, 3, FastRGB
	CurrentBarPositionLeft := CurrentBarPosition
	CurrentBarPositionRight := CurrentBarPosition + BarSize
	CurrentBarPositionMiddle := CurrentBarPosition + (BarSize / 2)
	Distance := CurrentTarget - CurrentBarPositionMiddle
	Percentage := (Distance / BarSize) * 100
	tooltip, ., CurrentTarget, 580, 6
	tooltip, |, CurrentBarPositionLeft, 570, 8
	tooltip, |, CurrentBarPositionRight, 570, 9
	Proportional := Kp * Distance
	IntegralError := IntegralError + Distance
	Integral := Ki * IntegralError
	Derivative := Kd * (Distance - PreviousError)
	PIDOutput := Proportional + Integral + Derivative

	PreviousError := Derivative

	if(PIDOutput > 100) {
		tooltip, %PIDOutput%, CurrentBarPositionMiddle, 570, 7
		PIDOutput := PIDOutput * 15
		Click, Down, 100, 400
		sleep PIDOutput
		Click, Up, 100, 400
	} else if (PIDOutput > 75) {
		tooltip, %PIDOutput%, CurrentBarPositionMiddle, 570, 7
		PIDOutput := PIDOutput * 6
		Click, Down, 100, 400
		sleep PIDOutput
		Click, Up, 100, 400
	} else if (PIDOutput > 0) {
		tooltip, %PIDOutput%, CurrentBarPositionMiddle, 570, 7
		PIDOutput := PIDOutput * 5
		Click, Down, 100, 400
		sleep PIDOutput
		Click, Up, 100, 400
	} else if (PIDOutput > -100) {
		tooltip, %PIDOutput%, CurrentBarPositionMiddle, 570, 7
		tempPID = Abs(PIDOutput) * 1.5
		PIDOutput := Abs(PIDOutput) * 0.05
		Click, Down, 100, 400
		sleep PIDOutput
		Click, Up, 100, 400
		sleep tempPID
	} else {
		tooltip, %PIDOutput%, CurrentBarPositionMiddle, 570, 7
	}
}

checkProgress() {
	if(debounce > 0) {
		return
	}
	PixelSearch, xTarget,, 450, 563, 490, 563, 0x000002, 100, FastRGB
	if(ErrorLevel = 1) {
	} else {
		if(xTarget >= 455) {
			debounce := 1
			caught := caught + 1
			tooltip, Caught: %caught% / %total%, %TooltipX%, %Tooltip12%, 12
		}
	}
}

setupTooltips() {
	tooltip, Made By thansar62, %TooltipX%, %Tooltip1%, 1
	tooltip, Current Task: Waiting..., %TooltipX%, %Tooltip2%, 2
	tooltip, Press "O" to Reload or "R" to Pause, %TooltipX%, %Tooltip4%, 4
	tooltip, Press "M" to Exit, %TooltipX%, %Tooltip5%, 5
	tooltip, , , , 6
	tooltip, Caught: %caught% / %total%, %TooltipX%, %Tooltip12%, 12
}

cast() {
	tooltip, Current Task: Casting, %TooltipX%, %Tooltip2%, 2
	tooltip,, , , 6
	tooltip,, , , 7
	tooltip,, , , 8
	tooltip,, , , 9
	tooltip,, , , 10
	tooltip,, , , 11
	Sleep 1750
	Click, Down, 100, 400
	Sleep 1000
	Click, Up, 100, 400
	tooltip, Current Task: Waiting for shake, %TooltipX%, %Tooltip2%, 2
	Sleep 1000
	Send %NavigationKey%
	Return True
}

shake() {
	Timer := A_TickCount
	check := 0
	timeout := 0
	Loop, {
		tooltip, Current Task: Shaking, %TooltipX%, %Tooltip2%, 2
		sleep 175
		Send {down}{enter}
		If (timeout >= ShakeTimeout) {
			Timer := A_TickCount
			check := 2
			break
		}
		if (scanForFishBar()) {
			check := 1
			break
		}
		timeout++
	}
	if(check = 1) {
		return True
	} else {
		Click, Down, 100, 400
		Sleep 10
		Click, up, 100, 400
		return False
	}
}

scanForFishBar() {
	PixelSearch, Px, Py, 246, 533, 569, 533, 0xf1f1f1, 20, FastRGB
	if(errorLevel = 0) {
		PixelSearch, Px, Py, 246, 533, 569, 533, 0x434b5b, 3, FastRGB
		if(errorLevel = 0) {
			Return True
		} else if (errorLevel = 2) {
			msgbox, There was an issue with PixelSearch. Stopping Program before things go haywire
			exitapp
		}
	}
	Return False
}

checkCameraMode() {
	tooltip, Current Task: Checking Camera Mode, %TooltipX%, %Tooltip2%, 2
	PixelGetColor, color, 779, 67
	if(errorLevel = 1) {
		msgbox, There was an issue with PixelSearch. Stopping Program before things go haywire
		exitapp
	}
	if(color = "0xedeae8") {
		Send %NavigationKey%
		Sleep 150
		Send {right}
		Sleep 150
		Send {right}
		Sleep 150
		Send {right}
		Sleep 150
		Send {right}
		Sleep 150
		Send {enter}
		Sleep 150
		Send %NavigationKey%
		Sleep 500
		checkCameraMode()
	} else {
		Sleep 500
	}
}

GetRobloxHWND() {
	if (hwnd := WinExist("Roblox ahk_exe RobloxPlayerBeta.exe"))
		return hwnd
}