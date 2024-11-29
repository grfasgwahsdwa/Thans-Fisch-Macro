#SingleInstance, force

; ==============================================================
; SETTINGS
ControlRod := 0.15
clickholdtime := 50
valreducedholdtime := 20
sleepTime := 15
navigationKey := "\"
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
	IniWrite, %navigationKey%, Settings.ini, Fisch, NavigationKey
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
IniRead, NavigationKey, Settings.ini, Fisch, NavigationKey
If (NavigationKey = "ERROR") {
	IniWrite, %navigationKey%, Settings.ini, Fisch, NavigationKey
	NavigationKey := navigationKey
}

RodControl := Control
global NavigationKey = NavigationKey

Control := StrSplit(Control, "|")

If (Control[2]) {
	Msgbox The control settings are outdated.`nRestored the settings to their default values.
	IniWrite, 0.05, Settings.ini, Fisch, Control
	ExitApp
}
Control := Floor(96+(Control[1]*326.67)) ; calculating the catch bar size pretty pro right
Tooltip % Control
If (!Control) {
	Msgbox, Failed to retrieve control from settings.ini
	ExitApp
}

Calculations:
	WinGetActiveStats, Title, WindowWidth, WindowHeight, WindowLeft, WindowTop

	TooltipX := WindowWidth/1.1
	Tooltip1 := (WindowHeight/2)-(20*9)
	Tooltip2 := (WindowHeight/2)-(20*8)
	Tooltip3 := (WindowHeight/2)-(20*7)
	Tooltip4 := (WindowHeight/2)-(20*6)
	Tooltip5 := (WindowHeight/2)-(20*5)
	Tooltip6 := (WindowHeight/2)-(20*4)
	Tooltip7 := (WindowHeight/2)-(20*3)
	Tooltip8 := (WindowHeight/2)-(20*2)
	Tooltip9 := (WindowHeight/2)-(20*1)
	Tooltip10 := (WindowHeight/2)
	Tooltip11 := (WindowHeight/2)+(20*1)
	Tooltip12 := (WindowHeight/2)+(20*2)
	Tooltip13 := (WindowHeight/2)+(20*3)
	Tooltip14 := (WindowHeight/2)+(20*4)
	Tooltip15 := (WindowHeight/2)+(20*5)
	Tooltip16 := (WindowHeight/2)+(20*6)
	Tooltip17 := (WindowHeight/2)+(20*7)
	Tooltip18 := (WindowHeight/2)+(20*8)
	Tooltip19 := (WindowHeight/2)+(20*9)
	Tooltip20 := (WindowHeight/2)+(20*10)

	caught := 0
	total := 0
	debounce := 0

	tooltip, Made By thansar62, %TooltipX%, %Tooltip1%, 1
	tooltip, Current Task: Paused, %TooltipX%, %Tooltip2%, 2
	tooltip, Press "P" to Start, %TooltipX%, %Tooltip4%, 4
	tooltip, Press "O" to Reload, %TooltipX%, %Tooltip5%, 5
	tooltip, Press "M" to Exit, %TooltipX%, %Tooltip6%, 6
	tooltip, Rod Control: %RodControl%, %TooltipX%, %Tooltip8%, 8
	tooltip, Caught: %caught% / %total%, %TooltipX%, %Tooltip12%, 12

$o:: reload
$m:: exitapp
$p::

	if GetRobloxHWND() {
		x := A_ScreenWidth
		y := A_ScreenHeight
		WinActivate, ahk_exe RobloxPlayerbeta.exe
		WinMove, ahk_exe RobloxPlayerBeta.exe,, x/2-408, y/2-408, 100, 100
	} else {
		Msgbox Roblox need to be opened
		ExitApp
	}
	tooltip, Made By Thansar25, %TooltipX%, %Tooltip1%, 1
	tooltip, Current Task: Waiting..., %TooltipX%, %Tooltip2%, 2
	tooltip, Press "O" to Reload, %TooltipX%, %Tooltip4%, 4
	tooltip, Press "M" to Exit, %TooltipX%, %Tooltip5%, 5
	tooltip, , , , 6
	tooltip, Caught: %caught% / %total%, %TooltipX%, %Tooltip12%, 12

	Reels()
	Timer := A_TickCount
	Loop,
	{
		tooltip, Current Task: Shaking, %TooltipX%, %Tooltip2%, 2
		debounce := 0
		sleep 175
		Send {down}{enter}
		If (A_TickCount - Timer >= 40000) {
			Reels()
			Timer := A_TickCount
		}
		PixelSearch, Px, Py, 246, 533, 569, 533, 0xf1f1f1, 20, FastRGB
		if (ErrorLevel = 0) {
			PixelSearch, Px, Py, 246, 533, 569, 533, 0x434b5b, 3, FastRGB
			If (ErrorLevel = 0) {
				MouseMove, 100, 400
				Loop
				{
					PixelSearch, Px, Py, 246, 533, 569, 533, 0x434b5b, 3, FastRGB
					if (ErrorLevel = 1) {
						Reels()
						tooltip
						Timer := A_TickCount
						Break
					}
					PixelSearch, Px, Py, 246, 533, 569, 533, 0xf1f1f1, 20,FastRGB
					If (ErrorLevel = 0) {
						tooltip, Current Task: Catching, %TooltipX%, %Tooltip2%, 2
						tooltip, Fish Bar gray, %TooltipX%, %Tooltip3%, 3
						total := total + 1
						debounce := 0
						Loop
						{
							if(debounce = 0) {
								PixelSearch, xTarget,, 440, 563, 490, 563, 0x000002, 100, FastRGB
								if(ErrorLevel = 1) {
								} else {
									if(xTarget >= 445) {
										debounce := 1
										caught := caught + 1
									}
								}
							}
							tooltip, Caught: %caught% / %total%, %TooltipX%, %Tooltip12%, 12
							PixelSearch, CurrentTarget,, 246, 533, 569, 533, 0x434b5b, 3, FastRGB
							If (ErrorLevel = 1) {
								Break
							} else {
								tooltip, Fish Bar gray, %TooltipX%, %Tooltip3%, 3
								tooltip, ., CurrentTarget, 580, 6
								If (CurrentTarget <= (Control + 247 - 40)) {
									tooltip, |, 247, 570, 8
									tooltip, V, 247 + (Control / 2), 570, 7
									tooltip, <, Control + 247 - 40, 570, 9
									Sleep 40
									tooltip go left
								} else If (CurrentTarget >= (568 - Control + 40)) {
									tooltip, >, 568 - Control + 40, 570, 8
									tooltip, |, 568, 570, 9
									tooltip, V, 568 - (Control / 2), 570, 7
									Click, Down
									tooltip go right
									Loop
									{
										if(debounce = 0) {
											PixelSearch, xTarget,, 440, 563, 490, 563, 0x000002, 100, FastRGB
											if(ErrorLevel = 1) {
											} else {
												if(xTarget >= 445) {
													debounce := 1
													caught := caught + 1
												}
											}
										}
										Tooltip, % A_Index
										PixelSearch, CurrentTarget,, 246, 533, 569, 533, 0x434b5b, 3, FastRGB
										If (ErrorLevel = 0) {
											tooltip, ., CurrentTarget, 580, 6
											tooltip, >, 568 - Control + 40, 570, 8
											tooltip, |, 568, 570, 9
											tooltip, V, 568 - (Control / 2), 570, 7
											If (CurrentTarget <= (568 - Control + 40)) {
												tooltip,,,, 8
												Break
											}
										} else {
											Break
										}
									}
									Click, Up
									AtRight := True
								} else {
									tooltip, ?, 251, 570, 10
									tooltip, ?, 564, 570, 11
									PixelSearch, CurrentBarPosition,, 251, 533, 564, 533, 0xf1f1f1, 20,FastRGB ; calculation stuff
									If (ErrorLevel = 0) {
										PixelSearch, CurrentTarget,, 246, 533, 569, 533, 0x434b5b, 3, FastRGB
										CurrentBarPositionLeft := CurrentBarPosition
										CurrentBarPositionRight := CurrentBarPosition + Control
										CurrentBarPositionMiddle := CurrentBarPosition + (Control / 2)
										Distance := CurrentTarget - CurrentBarPositionMiddle
										Percentage := (Distance / Control) * 100
										Tooltip % Percentage "x" Distance "x" CurrentBarPosition
										tooltip, ., CurrentTarget, 580, 6
										tooltip, V, CurrentBarPositionMiddle, 570, 7
										tooltip, |, CurrentBarPositionLeft, 570, 8
										tooltip, |, CurrentBarPositionRight, 570, 9
										if (Percentage >= 0) {
											Val := Floor(140 + ((440 - 140) * (Percentage / 100)))
											tooltip % Val
											If (Val = 0) {
												Reels(clickHoldTime)
											} else {
												Reels(Val - ValReducedHoldTime)
											}
										} else {
											Val := 0 + ((100 - 0) * (Percentage / 100))
											Val := Floor((-1 * Val))
											if (Val < 30) {
												tooltip, i'd click
												Reels(clickHoldTime - 10)
											} else {
												tooltip % Val - 50 " sleeptime"
												Sleep sleeptime
											}
										}
									} else {
										tooltip, ?, 251, 570, 10
										tooltip, ?, 564, 570, 11
										PixelSearch, CurrentBarPosition,, 251, 533, 564, 533, 0x4c4437, 35,FastRGB ; if bar color is different
										If (ErrorLevel = 0) {
											PixelSearch, CurrentTarget,, 246, 533, 569, 533, 0x434b5b, 3, FastRGB
											CurrentBarPositionLeft := CurrentBarPosition
											CurrentBarPositionRight := CurrentBarPosition + Control
											CurrentBarPositionMiddle := CurrentBarPosition + (Control / 2)
											Distance := CurrentTarget - CurrentBarPositionMiddle
											Percentage := (Distance / Control) * 100
											Tooltip % Percentage "x" Distance "x" CurrentBarPosition
											tooltip, ., CurrentTarget, 580, 6
											tooltip, V, CurrentBarPositionMiddle, 570, 7
											tooltip, |, CurrentBarPositionLeft, 570, 8
											tooltip, |, CurrentBarPositionRight, 570, 9
											if (Percentage >= 0) {
												Val := Floor(140 + ((440 - 140) * (Percentage / 100)))
												tooltip % Val
												If (Val = 0) {
													Reels(clickHoldTime)
												} else {
													Reels(Val - ValReducedHoldTime)
												}
											} else {
												Val := 0 + ((100 - 0) * (Percentage / 100))
												Val := Floor((-1 * Val))
												if (Val < 30) {
													tooltip, i'd click
													Reels(clickHoldTime - 10)
												} else {
													tooltip % Val - 50 " sleeptime"
													Sleep sleeptime
												}
											}
										} else {
											break
										}
									}
								}
							}
						}
						PixelSearch, CurrentTarget,, 246, 533, 569, 533, 0x434b5b, 3, FastRGB
						If (CurrentTarget > 408) {
							AtRight := True
							tooltip, ., CurrentTarget, 580, 6
							tooltip, >, 568 - Control + 40, 570, 8
							tooltip, |, 568, 570, 9
							tooltip, V, 568 - (Control / 2), 570, 7
						}
					} else {
						PixelSearch, CurrentTarget,, 246, 533, 569, 533, 0x434b5b, 3, FastRGB
						If (ErrorLevel = 0) {
							tooltip, ., CurrentTarget, 580, 6
							tooltip, Fish Bar gray, %TooltipX%, %Tooltip3%, 3
							If (CurrentTarget <= (Control + 247)) {
								Sleep 40
								tooltip go left
							} else If (CurrentTarget >= (568 - Control - 10)) {
								Click, Down
								tooltip go right
								Loop
								{
									Tooltip, % A_Index " 2"
									PixelSearch, CurrentTarget,, 246, 533, 569, 533, 0x434b5b, 3, FastRGB
									If (ErrorLevel = 0) {
										tooltip, ., CurrentTarget, 580, 6
										If (CurrentTarget <= (568 - Control + 10)) {
											Break
										}
									} else {
										Break
									}
								}
								Click, Up
							} else {
								If (AtRight and (CurrentTarget >= 408)) {
									Sleep 100
									AtRight := false
								} else {
									Tooltip, i reel 100
									Reels(clickHoldTime, True)
								}
							}

							PixelSearch, CurrentTarget,, 246, 533, 569, 533, 0x434b5b, 3, FastRGB
							If (CurrenTarget > 408) {
								AtRight := True
								tooltip, ., CurrentTarget, 580, 6
							}
						}
					}
				}
			}
		}
	}
ExitApp

Reels(x := 0, Stop := false) {
	If (!x) {
		checkCameraMode()
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
		Sleep 2000
		Send %NavigationKey%
		Return True
	}
	Click, Down
	Timer := A_TickCount
	Loop
	{
		If (Stop) {
			PixelSearch,,, 246, 533, 569, 533, 0xf1f1f1, 20, FastRGB
			If (ErrorLevel = 0) {
				Whitebar := true
				tooltip, Current Task: Fishing, %TooltipX%, %Tooltip2%, 2
				Break
			}
		}
		If (A_TickCount - Timer >= x) {
			Break
		}
	}
	Click, Up
	Return % Whitebar
}

GetRobloxHWND() {
	if (hwnd := WinExist("Roblox ahk_exe RobloxPlayerBeta.exe"))
		return hwnd
} ; yoooo fire macro with 200 line???

checkCameraMode() {
	tooltip, Current Task: Checking Camera Mode, %TooltipX%, %Tooltip2%, 2
	PixelGetColor, color, 779, 67
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
	cameraDebounce := 1
}