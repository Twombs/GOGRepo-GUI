;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                                       ;;
;;  AutoIt Version: 3.3.14.2                                                             ;;
;;                                                                                       ;;
;;  Template AutoIt script.                                                              ;;
;;                                                                                       ;;
;;  AUTHOR:  Timboli                                                                     ;;
;;                                                                                       ;;
;;  SCRIPT FUNCTION:  A progress and feedback GUI frontend for gogrepo.py                ;;
;;                                                                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; FUNCTIONS
; CloseEvent(), KeepWidth()

#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <ColorConstants.au3>
#include <Misc.au3>

_Singleton("gog-repo-progress-timboli")

Global $Edit_console, $Label_files, $Label_percent, $Label_size, $Label_status, $Label_title, $Progress_bar
;
Global $cnt, $complete, $count, $done, $downlist, $download, $err, $exit, $extras, $file, $files, $gamefold
Global $gogrepo, $height, $inifle, $left, $minimize, $num, $out, $outfle, $output, $params, $percent, $pid
Global $process, $progress, $ProgressGUI, $results, $ret, $size, $status, $style, $titfold, $title, $top
Global $width, $winpos

$downlist = @ScriptDir & "\Downloads.ini"
$gogrepo = @ScriptDir & "\gogrepo.py"
$inifle = @ScriptDir & "\Settings.ini"
$outfle = @ScriptDir & "\Output.txt"

If $Cmdline[0] = 0 Then
	$status = ""
Else
	$status = $Cmdline[1]
	If $status = "Download" Then
		$status = "Downloading"
	ElseIf $status = "Verify" Then
		$status = "Verifying"
	Else
		$status = ""
	EndIf
EndIf

If FileExists($gogrepo) Then
	$minimize = IniRead($inifle, "Progress Bar Or Console", "minimize", "")
	$height = 160
	$width = 600
	$style = $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU + $WS_CLIPSIBLINGS + $WS_MINIMIZEBOX + $WS_SIZEBOX
	If $minimize = 1 Then $style = $style + $WS_MINIMIZE
	$left = IniRead($inifle, "Progress Window", "left", 2)
	$top = IniRead($inifle, "Progress Window", "top", @DesktopHeight - $height - 100)
	$ProgressGUI = GuiCreate("Floating Progress", $width, 160, $left, $top, $style, $WS_EX_TOPMOST)
	GUISetBkColor($COLOR_SKYBLUE, $ProgressGUI)
	; CONTROLS
	$Label_status = GUICtrlCreateLabel($status, 10, 10, 80, 20, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_status, $COLOR_BLUE)
	GUICtrlSetColor($Label_status, $COLOR_WHITE)
	GUICtrlSetFont($Label_status, 7, 600, 0, "Small Fonts")
	GUICtrlSetResizing($Label_status, $GUI_DOCKALL)
	$Label_title = GUICtrlCreateLabel("", 90, 10, 360, 20, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_title, $COLOR_GRAY)
	GUICtrlSetColor($Label_title, $COLOR_RED)
	GUICtrlSetFont($Label_title, 9, 600)
	GUICtrlSetResizing($Label_title, $GUI_DOCKALL)
	$Label_files = GUICtrlCreateLabel("", 455, 10, 60, 20, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_files, 0xFFB366)
	GUICtrlSetColor($Label_files, $COLOR_BLUE)
	GUICtrlSetFont($Label_files, 7, 600, 0, "Small Fonts")
	GUICtrlSetResizing($Label_files, $GUI_DOCKALL)
	$Label_size = GUICtrlCreateLabel("", 520, 10, 70, 20, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_size, 0xF0F000)
	GUICtrlSetColor($Label_size, $COLOR_GREEN)
	GUICtrlSetFont($Label_size, 7, 600, 0, "Small Fonts")
	GUICtrlSetResizing($Label_size, $GUI_DOCKALL)
	$Edit_console = GUICtrlCreateEdit("", 10, 40, 580, 80, $ES_MULTILINE + $ES_READONLY) ; $ES_AUTOVSCROLL + $WS_VSCROLL + + $ES_WANTRETURN
	GUICtrlSetBkColor($Edit_console, $COLOR_BLACK)
	GUICtrlSetColor($Edit_console, $COLOR_WHITE)
	GUICtrlSetFont($Edit_console, 7, 600, 0, "Small Fonts")
	GUICtrlSetResizing($Edit_console, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH) ; + $GUI_DOCKLEFT + $GUI_DOCKRIGHT
	;
	$Progress_bar = GUICtrlCreateProgress(10, 130, 580, 20, $PBS_SMOOTH)
	GUICtrlSetResizing($Progress_bar, $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	$Label_percent = GUICtrlCreateLabel("", 20, 131, 570, 18, $SS_CENTER + $SS_CENTERIMAGE)
	GUICtrlSetBkColor($Label_percent, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor($Label_percent, $COLOR_BLACK)
	GUICtrlSetFont($Label_percent, 9, 600)
	GUICtrlSetResizing($Label_percent, $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	;
	; SETTINGS
	;$title = ""
	;$title = "memoranda"
	;$gamefold = "G:\GOG\GoG"
	;If $title <> "" Then
	;	$titfold = $gamefold & "\" & $title
	;	If FileExists($titfold) Then DirRemove($titfold, 1)
	;EndIf
	;$files = 1
	;$extras = 1
	$title = IniRead($inifle, "Current Download", "title", "")
	GUICtrlSetData($Label_title, $title)
	$gamefold = IniRead($inifle, "Current Download", "destination", "")
	$files = IniRead($inifle, "Current Download", "files", "")
	$extras = IniRead($inifle, "Current Download", "extras", "")
	$pid = 0
	$exit = ""
	;
	; Example
;~ 	GUICtrlSetData($Label_title, "memoranda")
;~ 	GUICtrlSetData($Label_files, "1 of 7")
;~ 	GUICtrlSetData($Label_size, "735.24MB")
;~ 	$text = "21:23:38 |    577.8MB      5.0MB/s  1x  memoranda/setup_memoranda_gog-4_(11000).exe"
;~ 	$text = $text & @CRLF & "21:23:38 | 0.56GB remaining"
;~ 	GUICtrlSetData($Edit_console, "setup_memoranda_gog-4_(11000).exe" & @CRLF & $text)
;~ 	GUICtrlSetData($Label_percent, "33%")
;~ 	GUICtrlSetData($Progress_bar, 33)
	;
	Opt("GUIOnEventMode", 1)
	;
	GUISetOnEvent($GUI_EVENT_CLOSE, "CloseEvent")
	GUISetOnEvent($GUI_EVENT_RESIZED, "KeepWidth")

	GuiSetState()
	While 1
		; Start downloading and monitor
		If $title <> "" Then
			If $gamefold <> "" Then
				If $status = "Downloading" Then
					$file = FileOpen($outfle, 2)
					GUICtrlSetData($Edit_console, "Starting ....")
					Local $params = " -skipextras -skipgames"
					If $files = 1 Then $params = StringReplace($params, " -skipgames", "")
					If $extras = 1 Then $params = StringReplace($params, " -skipextras", "")
					$ret = Run(@ComSpec & ' /c gogrepo.py download' & $params & ' -id ' & $title & ' "' & $gamefold & '"', @ScriptDir, @SW_HIDE, $STDERR_MERGED)
					$pid = $ret
					IniWrite($inifle, "Current Download", "pid", $pid)
					$complete = ""
					$count = 0
					$download = ""
					$num = 0
					$results = ""
					$size = 0
					$title = ""
					While 1
						$out = StdoutRead($ret)
						If @error Then
							; Exit the loop if the process closes or StdoutRead returns an error.
							; NOTE - If process closes without error, then two Exitloops should occur, without getting an error $val.
							While 1
								$out = StderrRead($ret)
								If @error Then
									; Exit the loop if the process closes or StderrRead returns an error.
									ExitLoop
								EndIf
								MsgBox($MB_SYSTEMMODAL, "Stderr Read:", $out)
								$err = 1
							WEnd
							;If $out <> "" Then $results &= $out
							;If $out <> "" Then FileWriteLine($file, "LAST = " & $out)
							ExitLoop 2
						Else
							$out = StringStripWS($out, 3)
							If $out <> "" Then
								FileWriteLine($file, $out)
								$results &= @CRLF & $out
								$results = StringStripWS($results, 1)
								If $size = 0 Then
									GUICtrlSetData($Progress_bar, 0)
									If StringInStr($out, "  1x  ") > 0 Then
										$size = StringSplit($out, "  1x  ", 1)
										$download = $size[2]
										$download = StringSplit($download, "/", 1)
										$download = $download[2]
										If StringInStr($download, " remaining") > 0 Then
											$download = StringSplit($download, " remaining", 1)
											$download = $download[1]
											$download = StringSplit($download, @CRLF, 1)
											$download = $download[1]
										EndIf
										$size = $size[1]
										$size = StringSplit($size, "|", 1)
										$size = $size[2]
										$size = StringStripWS($size, 1)
										$size = StringSplit($size, " ", 1)
										$size = $size[1]
										GUICtrlSetData($Label_size, $size)
										$size = StringRegExpReplace($size, "\D", "")
										If $count = 0 Then
											$count = StringSplit($results, "     download   ", 1)
											$count = $count[0] - 1
										EndIf
										$num = $num + 1
										GUICtrlSetData($Label_files, $num & " of " & $count)
									EndIf
								Else
									If StringInStr($out, "  1x  ") > 0 Then
										$done = StringSplit($out, "  1x  ", 1)
										$done = $done[1]
										$done = StringSplit($done, "|", 1)
										$done = $done[2]
										$done = StringStripWS($done, 1)
										$done = StringSplit($done, " ", 1)
										$done = $done[1]
										$done = StringRegExpReplace($done, "\D", "")
										If $percent <> "100%" Then
											$progress = $size - $done
											$percent = ($progress / $size) * 100
											GUICtrlSetData($Progress_bar, $percent)
											$percent = Floor($percent) & "%"
											If $done = "0.0" Then
												$percent = "100%"
											EndIf
											If $percent = "100%" Then $complete = 1
											GUICtrlSetData($Label_percent, $percent)
											GUICtrlSetTip($Progress_bar, $percent)
										EndIf
									ElseIf $complete = 1 Then
										GUICtrlSetData($Progress_bar, 100)
										GUICtrlSetData($Label_percent, "100%")
										Sleep(150)
										$complete = ""
										$size = 0
										$results = ""
										$percent = 0
										GUICtrlSetData($Edit_console, "")
									EndIf
								EndIf
								$results = StringReplace($results, @CRLF, @CR)
								$results = StringReplace($results, @LF, @CR)
								$results = StringReplace($results, @CR, @CRLF)
								If $size = 0 And $num < 1 Then
									If StringInStr($results, " remaining") < 1 Then
										$output = $results
									Else
										$output = ""
									EndIf
								Else
									$output = StringSplit($results, @CRLF, 1)
									$cnt = $output[0]
									If $cnt > 1 Then
										$first = $output[$cnt - 1]
										$second = $output[$cnt]
										$output = ""
										If $download <> "" Then
											$output = $download & @CRLF
										EndIf
										If $first <> "" Then
											If StringInStr($first, " remaining") < 1 Then
												$output = $output & $first & @CRLF
											EndIf
										EndIf
										If $second <> "" Then
											If StringInStr($second, " remaining") > 0 Then
												$first = StringSplit($second, " remaining", 1)
												If $first[0] > 2 Then
													$second = $first[2] & " remaining"
													$second = StringStripWS($second, 3)
												EndIf
											EndIf
											$output = $output & $second
										EndIf
									Else
										If StringInStr($results, " remaining") < 1 Then
											$output = $results
										Else
											$output = ""
										EndIf
									EndIf
								EndIf
								GUICtrlSetData($Edit_console, "")
								GUICtrlSetData($Edit_console, "")
								GUICtrlSetData($Edit_console, $output)
								If StringInStr($output, "total time:") > 0 Then
									Sleep(2000)
								EndIf
							EndIf
						EndIf
						If $exit = 1 Then
							If $pid <> 0 Then
								If ProcessExists($pid) Then ProcessClose($pid)
								; Need to be careful doing these. Perhaps check for number of instances.
								$ans = MsgBox(262177, "Processes Close Query", _
									"Do you also want to close any running" & @LF & _
									"'py.exe' and 'Python.exe' process?", $wait, $QueueGUI)
								If $ans = 1 Then
									If ProcessExists("py.exe") Then
										$process = ProcessList("py.exe")
										If @error <> 1 Then
											If $process[0][0] = 1 Then ProcessClose("py.exe")
										EndIf
									EndIf
									If ProcessExists("Python.exe") Then
										$process = ProcessList("Python.exe")
										If @error <> 1 Then
											If $process[0][0] = 1 Then ProcessClose("Python.exe")
										EndIf
									EndIf
								EndIf
							EndIf
							GUIDelete($ProgressGUI)
							ExitLoop 2
						EndIf
					WEnd
					FileWriteLine($file, $size)
					FileClose($file)
					ExitLoop
				ElseIf $status = "Verifying" Then
				EndIf
			EndIf
		EndIf
		Sleep(10)
		If $exit = 1 Then
			ExitLoop
		EndIf
	WEnd
	$winpos = WinGetPos($ProgressGUI, "")
	$left = $winpos[0]
	If $left < 0 Then
		$left = 2
	ElseIf $left > @DesktopWidth - $width Then
		$left = @DesktopWidth - $width - 25
	EndIf
	IniWrite($inifle, "Progress Window", "left", $left)
	$top = $winpos[1]
	If $top < 0 Then
		$top = 2
	ElseIf $top > @DesktopHeight - $height - 40 Then
		$top = @DesktopHeight - $height - 100
	EndIf
	IniWrite($inifle, "Progress Window", "top", $top)
	;
	GUIDelete($ProgressGUI)
Else
	MsgBox(262192, "Program Error", "The 'gogrepo.py' file could not be found!", 0)
EndIf

Exit

Func CloseEvent()
	; Exit / Close / Quit the program
	If $status = "" Then
		$exit = 1
	Else
		MsgBox(262192, "Close Error", "Use the QUEUE window STOP button!", 3, $ProgressGUI)
	EndIf
EndFunc ;=> CloseEvent

Func KeepWidth()
	; Keep the same window width
	Local $height, $winpos
	$winpos = WinGetPos($ProgressGUI, "")
	$height = $winpos[3]
	If $height < 200 Then $height = 200
	WinMove($ProgressGUI, "", $winpos[0], $winpos[1], $width + 15, $height)
EndFunc ;=> KeepWidth
