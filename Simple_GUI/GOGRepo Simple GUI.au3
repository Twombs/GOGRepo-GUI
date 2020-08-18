;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                                       ;;
;;  AutoIt Version: 3.3.14.2                                                             ;;
;;                                                                                       ;;
;;  Template AutoIt script.                                                              ;;
;;                                                                                       ;;
;;  AUTHOR:  Timboli                                                                     ;;
;;                                                                                       ;;
;;  SCRIPT FUNCTION:  A limited simple GUI frontend for gogrepo.py                       ;;
;;                                                                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; FUNCTIONS
; MainGUI(), FillTheGamesList(), GetAllowedName(), ReplaceForeignCharacters($text), ReplaceOtherCharacters($text)

#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <ColorConstants.au3>
#include <ListBoxConstants.au3>
#include <StaticConstants.au3>
#include <GuiListBox.au3>
#include <Misc.au3>
#include <File.au3>
#include <Array.au3>

_Singleton("gog-repo-simple-gui-timboli")

Global $Button_exit, $Button_find, $Button_get, $Button_info, $Checkbox_exact, $Group_drop, $Group_games, $Group_status
Global $Input_file, $Input_name, $Input_title, $Label_drop, $Label_status, $Label_title, $List_games
;
Global $a, $ans, $array, $atts, $boxcol, $cmdpid, $cookies, $entries, $entry, $file, $find, $fsum, $games, $gamesfle, $gogrepo
Global $handle, $height, $icoI, $icoS, $icoX, $ind, $inifle, $lang, $left, $line, $logfle, $manifest, $match, $md5, $name, $names
Global $open, $OS, $out, $pid, $res, $resfle, $results, $resumeman, $ret, $shell, $SimpleGUI, $size, $srcfld, $srcfle, $style
Global $target, $text, $textcol, $title, $titlist, $top, $user, $version, $w, $width, $winpos, $wins, $wintit
;
$7zip = @ScriptDir & "\7-Zip\7za.exe"
$cookies = @ScriptDir & "\gog-cookies.dat"
$foldrar = @ScriptDir & "\UnRAR"
$foldzip = @ScriptDir & "\7-Zip"
$fsum = @ScriptDir & "\FSUM\fsum.exe"
$gamesfle = @ScriptDir & "\Games.ini"
$gogrepo = @ScriptDir & "\gogrepo.py"
$inifle = @ScriptDir & "\Options.ini"
$innoextract = @ScriptDir & "\innoextract.exe"
$logfle = @ScriptDir & "\Log.txt"
$manifest = @ScriptDir & "\gog-manifest.dat"
$resfle = @ScriptDir & "\Checksums.txt"
$resumeman = @ScriptDir & "\gog-resume-manifest.dat"
$target = @LF & "Drag && Drop" & @LF & "Downloaded" & @LF & "Game Files" & @LF & "HERE"
$titlist = @ScriptDir & "\Titles.txt"
$unrar = @ScriptDir & "\UnRAR\UnRAR.exe"
$version = "v1.0"

If Not FileExists($titlist) Then _FileCreate($titlist)

If FileExists($titlist) Then
	If FileExists($gogrepo) Then
		MainGUI()
	Else
		MsgBox(262192, "Program Error", "Required 'gogrepo.py' file could not be found!", 0)
	EndIf
Else
	MsgBox(262192, "Program Error", "Titles.txt file could not be created!", 0)
EndIf

Exit

Func MainGUI()
	Local $dir, $drv, $fext, $fnam
	;
	$width = 580
	$height = 345
	$left = IniRead($inifle, "Program Window", "left", @DesktopWidth - $width - 25)
	$top = IniRead($inifle, "Program Window", "top", @DesktopHeight - $height - 30)
	$style = $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU + $WS_CLIPSIBLINGS + $WS_MINIMIZEBOX ; + $WS_VISIBLE
	$SimpleGUI = GuiCreate("GOGRepo Simple GUI", $width, $height, $left, $top, $style, $WS_EX_TOPMOST + $WS_EX_ACCEPTFILES)
	GUISetBkColor($COLOR_SKYBLUE, $SimpleGUI)
	; CONTROLS
	$Group_games = GuiCtrlCreateGroup("Games", 10, 10, 370, 323)
	$List_games = GuiCtrlCreateList("", 20, 30, 350, 220)
	GUICtrlSetBkColor($List_games, 0xBBFFBB)
	GUICtrlSetTip($List_games, "List of games!")
	$Input_name = GUICtrlCreateInput("", 20, 250, 350, 20)
	GUICtrlSetBkColor($Input_name, 0xFFFFB0)
	GUICtrlSetTip($Input_name, "Game Name!")
	$Label_title = GuiCtrlCreateLabel("Title", 20, 275, 38, 20, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN + $SS_NOTIFY)
	GUICtrlSetBkColor($Label_title, $COLOR_BLUE)
	GUICtrlSetColor($Label_title, $COLOR_WHITE)
	GUICtrlSetFont($Label_title, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Label_title, "Click to restore last search text to Title input field!")
	$Input_title = GUICtrlCreateInput("", 58, 275, 240, 20) ;, $ES_READONLY
	GUICtrlSetBkColor($Input_title, 0xBBFFBB)
	GUICtrlSetTip($Input_title, "Game Title!")
	$Button_find = GuiCtrlCreateButton("?", 301, 274, 22, 22, $BS_ICON)
	GUICtrlSetTip($Button_find, "Find the specified game title on list!")
	$Checkbox_exact = GUICtrlCreateCheckbox("Exact", 325, 275, 45, 20)
	GUICtrlSetTip($Checkbox_exact, "Exact from left!")
	$Label_file = GuiCtrlCreateLabel("File", 20, 300, 38, 20, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN + $SS_NOTIFY)
	GUICtrlSetBkColor($Label_file, $COLOR_FUCHSIA)
	GUICtrlSetColor($Label_file, $COLOR_BLUE)
	GUICtrlSetFont($Label_file, 7, 600, 0, "Small Fonts")
	;GUICtrlSetTip($Label_file, "Dropped game file!")
	$Input_file = GUICtrlCreateInput("", 58, 300, 310, 20)
	;GUICtrlSetBkColor($Input_file, 0xBBFFBB)
	GUICtrlSetBkColor($Input_file, 0xFFD5FF)
	GUICtrlSetTip($Input_file, "Dropped game file!")
	;
	$Group_drop = GuiCtrlCreateGroup("Drop Zone", 390, 10, 180, 110)
	$Label_drop = GUICtrlCreateLabel($target, 400, 30, 160, 80, $SS_CENTER)
	GUICtrlSetFont($Label_drop, 9, 600, 0, "Small Fonts")
	GUICtrlSetState($Label_drop, $GUI_DROPACCEPTED)
	GUICtrlSetTip($Label_drop, "Drag & Drop downloaded game files here!")
	$boxcol = $COLOR_YELLOW
	$textcol = $COLOR_RED
	GUICtrlSetBkColor($Label_drop, $boxcol)
	GUICtrlSetColor($Label_drop, $textcol)
	;
	$Button_get = GuiCtrlCreateButton("RETRIEVE LIST OF GAMES", 390, 130, 180, 40)
	GUICtrlSetFont($Button_get, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_get, "Get game title from GOG library!")
	;
	$Group_status = GuiCtrlCreateGroup("Status", 390, 175, 180, 50)
	$Label_status = GuiCtrlCreateLabel("Waiting", 400, 193, 160, 22, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_status, $COLOR_BLUE)
	GUICtrlSetColor($Label_status, $COLOR_WHITE)
	GUICtrlSetFont($Label_status, 9, 600)
	;
	$Button_verify = GuiCtrlCreateButton("VERIFY DROPPED FILE", 390, 235, 180, 40)
	GUICtrlSetFont($Button_verify, 8.5, 600)
	GUICtrlSetTip($Button_verify, "Verify the dropped game file!")
	;
	$Button_setup = GuiCtrlCreateButton("SETUP", 390, 285, 60, 50)
	GUICtrlSetFont($Button_setup, 8, 600)
	GUICtrlSetTip($Button_setup, "Program Setup!")
	;
	$Button_info = GuiCtrlCreateButton("Info", 460, 285, 50, 50, $BS_ICON)
	GUICtrlSetTip($Button_info, "Program Information!")
	;
	$Button_exit = GuiCtrlCreateButton("EXIT", 520, 285, 50, 50, $BS_ICON)
	GUICtrlSetTip($Button_exit, "Exit / Close / Quit the program!")
	;
	; OS SETTINGS
	$user = @SystemDir & "\user32.dll"
	$shell = @SystemDir & "\shell32.dll"
	$icoI = -5
	$icoS = -23
	$icoX = -4
	GUICtrlSetImage($Button_find, $shell, $icoS, 0)
	GUICtrlSetImage($Button_info, $user, $icoI, 1)
	GUICtrlSetImage($Button_exit, $user, $icoX, 1)
	;
	; SETTINGS
	GUICtrlSetState($Checkbox_exact, $GUI_CHECKED)
	;
	FillTheGamesList()

	GuiSetState(@SW_SHOWNORMAL, $SimpleGUI)
	While 1
		$msg = GuiGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Button_exit
			; Exit / Close / Quit the program
			$winpos = WinGetPos($SimpleGUI, "")
			$left = $winpos[0]
			If $left < 0 Then
				$left = 2
			ElseIf $left > @DesktopWidth - $width Then
				$left = @DesktopWidth - $width - 25
			EndIf
			IniWrite($inifle, "Program Window", "left", $left)
			$top = $winpos[1]
			If $top < 0 Then
				$top = 2
			ElseIf $top > @DesktopHeight - $height Then
				$top = @DesktopHeight - $height - 30
			EndIf
			IniWrite($inifle, "Program Window", "top", $top)
			;
			GUIDelete($SimpleGUI)
			ExitLoop
		Case $msg = $GUI_EVENT_DROPPED
			$srcfle = @GUI_DragFile
			$atts = FileGetAttrib($srcfle)
			If StringInStr($atts, "D") > 0 Then
				MsgBox(262192, "Drop Error", "Folders are not supported!", 0, $SimpleGUI)
			Else
				_PathSplit($srcfle, $drv, $dir, $fnam, $fext)
				If $fext = ".exe" Or $fext = ".bin" Or $fext = ".rar" Or $fext = ".zip" Or $fext = ".7z" Or $fext = ".sh" Then
					GUICtrlSetData($Input_file, $srcfle)
					IniWrite($inifle, "Last File", "path", $srcfle)
					$file = StringSplit($srcfle, "\", 1)
					$file = $file[$file[0]]
					$file = StringReplace($file, "setup_", "")
					$file = StringSplit($file, "_", 1)
					$find = $file[1]
					If $find = "the" Or $find = "a" Then
						$find = $find & " " & $file[2]
					EndIf
					GUICtrlSetData($Input_title, $find)
					GUICtrlSetData($Input_name, "")
					If GUICtrlRead($Label_status) <> "Waiting" Then
						GUICtrlSetData($Label_status, "Waiting")
						GUICtrlSetBkColor($Label_status, $COLOR_BLUE)
						GUICtrlSetColor($Label_status, $COLOR_WHITE)
						GUICtrlSetFont($Label_status, 9, 600)
					EndIf
				Else
					MsgBox(262192, "Drop Error", "File type not supported!", 0, $SimpleGUI)
				EndIf
			EndIf
		Case $msg = $Button_verify
			; Verify the dropped game file
			$ans = MsgBox(262177, "Verify Query", _
				"Verify integrity of dropped file for selected game title?", 0, $SimpleGUI)
			If $ans = 1 Then
				$name = GUICtrlRead($Input_name)
				$title = GUICtrlRead($Input_title)
				If $name <> "" And $title <> "" Then
					$srcfle = GUICtrlRead($Input_file)
					If $srcfle <> "" Then
						GUICtrlSetBkColor($Label_status, $COLOR_RED)
						GUICtrlSetColor($Label_status, $COLOR_WHITE)
						GUICtrlSetFont($Label_status, 9, 600)
						GUICtrlSetData($Label_status, "Downloading Data")
						If FileExists($resumeman) Then FileDelete($resumeman)
						FileChangeDir(@ScriptDir)
						$OS =  "windows linux"
						$lang = "en"
						RunWait(@ComSpec & ' /c gogrepo.py update -os ' & $OS & ' -lang ' & $lang & ' -id ' & $title, @ScriptDir)
						;'name': 'setup_death_and_taxes_demo_1.1.7_(40162).exe',
						;'md5': '6a873ce8827655de5789bbf5687182d6', one before
						;'size': 472006808, second after
						;'name': 'death_and_taxes_demo_1_1_7_40256.sh',
						;'md5': '4a192a9ec26337ddb35607d6f04f6a38', one before
						;'size': 466231659, second after
						_PathSplit($srcfle, $drv, $dir, $fnam, $fext)
						$srcfld = StringTrimRight($drv & $dir, 1)
						$file = $fnam & $fext
						;$file = StringSplit($srcfle, "\", 1)
						;$file = $file[$file[0]]
						GUICtrlSetData($Label_status, "Verifying File")
						$res = _FileReadToArray($manifest, $array, 1)
						If $res = 1 Then
							$md5 = ""
							$size = ""
							For $a = 2 To $array[0]
								$line = $array[$a]
								If $line <> "" Then
									If StringInStr($line, $file) > 0 Then
										$a = $a - 1
										If $fext = ".exe" Or $fext = ".bin" Or $fext = ".sh" Then
											$line = $array[$a]
											If StringInStr($line, "'md5':") > 0 Then
												$md5 = $line
												$md5 = StringSplit($md5, "'", 1)
												$md5 = $md5[$md5[0]-1]
												$md5 = StringSplit($md5, "'", 1)
												$md5 = $md5[$md5[0]]
											EndIf
										EndIf
										$a = $a + 3
										$line = $array[$a]
										If StringInStr($line, "'size':") < 1 Then
											$a = $a + 1
											$line = $array[$a]
											If StringInStr($line, "'size':") < 1 Then
												$a = $a + 1
												$line = $array[$a]
											EndIf
										EndIf
										If StringInStr($line, "'size':") > 0 Then
											$size = $line
											$size = StringSplit($size, ",", 1)
											$size = $size[1]
											$size = StringSplit($size, "'size':", 1)
											;$size = StringSplit($size, " ", 1)
											$size = $size[2]
											$size = StringStripWS($size, 3)
											;MsgBox(262192, "Got Here", $size, 0, $SimpleGUI)
											If StringIsDigit($size) = 0 Then $size = ""
										EndIf
										ExitLoop
									EndIf
								EndIf
							Next
							;MsgBox(262192, "Data", "MD5 = " & $md5 & @LF & "Size = " & $size, 0, $SimpleGUI)
							$match = ""
							If $md5 <> "" Then
								If FileExists($fsum) Then
									FileChangeDir(@ScriptDir & "\FSUM")
									RunWait(@ComSpec & ' /c fsum.exe -jnc -md5 -d"' & $srcfld & '" ' & $file & ' >"'  & $resfle & '"')
									$res = _FileReadToArray($resfle, $array, 1)
									If $res = 1 Then
										$match = $array[1]
										$match = StringSplit($match, " ", 1)
										$match = $match[1]
										If $match = $md5 Then
											$match = "MD5 Passed."
										Else
											$match = "MD5 Failed."
										EndIf
									EndIf
								EndIf
							EndIf
							If $size <> "" Then
								If FileGetSize($srcfle) = $size Then
									$match = $match & " Size Passed."
								Else
									$match = $match & " Size Failed."
								EndIf
							EndIf
							$match = StringStripWS($match, 1)
							GUICtrlSetBkColor($Label_status, $COLOR_LIME)
							GUICtrlSetColor($Label_status, $COLOR_BLACK)
							GUICtrlSetFont($Label_status, 7, 600, 0, "Small Fonts")
							GUICtrlSetData($Label_status, $match)
						Else
							MsgBox(262192, "Read Error", "Manifest could not be opened!", 0, $SimpleGUI)
						EndIf
					Else
						MsgBox(262192, "Source Error", "File is missing!", 0, $SimpleGUI)
					EndIf
				Else
					MsgBox(262192, "Selection Error", "Title not selected correctly!", 0, $SimpleGUI)
				EndIf
			EndIf
		Case $msg = $Button_get
			; Get game title from GOG library
			GUICtrlSetBkColor($Label_status, $COLOR_RED)
			GUICtrlSetColor($Label_status, $COLOR_WHITE)
			GUICtrlSetFont($Label_status, 9, 600)
			GUICtrlSetData($Label_status, "Retrieving Titles")
			FileChangeDir(@ScriptDir)
			If FileExists($resumeman) Then FileDelete($resumeman)
			_FileCreate($titlist)
			GUICtrlSetData($List_games, "")
			; Create a list of all titles in the resume manifest.
			_FileWriteLog($logfle, "Getting list of game titles.")
			$ret = Run(@ComSpec & ' /c gogrepo.py update', @ScriptDir, @SW_SHOW, $STDERR_MERGED) ;@SW_HIDE
			$pid = $ret
			$out = ""
			$results = ""
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
					ExitLoop
				Else
					$out = StringStripWS($out, 3)
					If $out <> "" Then
						;_FileWriteLog($stagefile, $out)
						$results &= @CRLF & $out
						$results = StringStripWS($results, 7)
						If StringInStr($results, "saved resume manifest") > 0 Then
							$wintit = @SystemDir & "\cmd.exe"
							$wins = WinList($wintit, "")
							For $w = 1 To $wins[0][0]
								$handle = $wins[$w][1]
								$cmdpid = WinGetProcess($handle, "")
								If $cmdpid = $pid Then
									WinClose($handle, "")
									GUICtrlSetData($Label_status, "Bingo!")
									Sleep(1000)
								EndIf
							Next
							If ProcessExists($pid) Then ProcessClose($pid)
							ExitLoop
						EndIf
					EndIf
				EndIf
				If ProcessExists($pid) = 0 Then ExitLoop
			WEnd
			; Create a list of all titles.
			GUICtrlSetData($Label_status, "Extracting Titles")
			If FileExists($resumeman) Then
				$res = _FileReadToArray($resumeman, $array, 1)
				If $res = 1 Then
					$entries = ""
					$entry = ""
					$name = ""
					$names = ""
					$title = ""
					For $a = 2 To $array[0]
						$line = $array[$a]
						If $line <> "" Then
							If StringInStr($line, "'long_title': '") > 0 Then
								$line = StringSplit($line, "'long_title': '", 1)
								$line = $line[2]
								$line = StringSplit($line, "',", 1)
								$line = $line[1]
								$name = StringStripWS($line, 7)
							ElseIf StringInStr($line, "'long_title': ") > 0 Then
								$line = StringSplit($line, "'long_title': ", 1)
								$line = $line[2]
								$line = StringSplit($line, '",', 1)
								$line = $line[1]
								$line = StringReplace($line, '"', '')
								$name = StringStripWS($line, 7)
							ElseIf StringInStr($line, "'title': '") > 0 Then
								$line = StringSplit($line, "'title': '", 1)
								$line = $line[2]
								$line = StringSplit($line, "'}", 1)
								$line = $line[1]
								$title = StringStripWS($line, 8)
							EndIf
							If $name <> "" And $title <> "" Then
								GetAllowedName()
								If $names = "" Then
									$names = $name
								Else
									$names = $names & @CRLF & $name
								EndIf
								$entry = "[" & $name & "]" & @CRLF
								$entry = $entry & "title=" & $title & @CRLF
								If $entries = "" Then
									$entries = $entry
								Else
									$entries = $entries & $entry
								EndIf
								$name = ""
								$title = ""
							EndIf
						EndIf
					Next
					GUICtrlSetData($Label_status, "Finalizing")
					If $entries <> "" Then
						$open = FileOpen($gamesfle, 2)
						FileWriteLine($open, $entries)
						FileClose($open)
						$entries = ""
					EndIf
					If $names <> "" Then
						$names = StringSplit($names, @CRLF, 1)
						_ArraySort($names, 0, 1)
						$names = _ArrayToString($names, @CRLF, 1)
						$file = FileOpen($titlist, 2)
						FileWrite($file, $names & @CRLF)
						FileClose($file)
						$names = ""
					EndIf
				Else
					MsgBox(262192, "Extract Error", "Could not get titles!", 0, $SimpleGUI)
				EndIf
			Else
				MsgBox(262192, "Update Error", "Could not find the resume manifest file!", 0, $SimpleGUI)
			EndIf
			_FileWriteLog($logfle, "Titles retrieved.")
			FillTheGamesList()
			GUICtrlSetBkColor($Label_status, $COLOR_BLUE)
			GUICtrlSetData($Label_status, "Finished")
		Case $msg = $Button_find
			; Find the specified game title on list
			$title = GUICtrlRead($Input_title)
			If $title <> "" Then
				GUICtrlSetData($Input_name, "")
				$find = $title
				$ind = _GUICtrlListBox_GetCurSel($List_games)
				If GUICtrlRead($Checkbox_exact) = $GUI_CHECKED Then
					$ind = _GUICtrlListBox_SelectString($List_games, $title, $ind)
				Else
					$ind = _GUICtrlListBox_FindInText($List_games, $title, $ind, True)
				EndIf
				If $ind > -1 Then
					_GUICtrlListBox_SetCurSel($List_games, $ind)
					;_GUICtrlListBox_ClickItem($List_games, $ind)
				EndIf
			EndIf
		Case $msg = $Label_title
			; Click to restore last search text to Title input field
			GUICtrlSetData($Input_title, $find)
		Case $msg = $Label_file
			; Click to find nearest Title beginning with first word
			$srcfle = GUICtrlRead($Input_file)
			If $srcfle <> "" Then
				$file = StringSplit($srcfle, "\", 1)
				$file = $file[$file[0]]
				$file = StringReplace($file, "setup_", "")
				$file = StringSplit($file, "_", 1)
				$find = $file[1]
				If $find = "the" Or $find = "a" Then
					$find = $find & " " & $file[2]
				EndIf
				GUICtrlSetData($Input_title, $find)
				GUICtrlSetData($Input_name, "")
				If GUICtrlRead($Label_status) <> "Waiting" Then
					GUICtrlSetData($Label_status, "Waiting")
					GUICtrlSetBkColor($Label_status, $COLOR_BLUE)
					GUICtrlSetColor($Label_status, $COLOR_WHITE)
					GUICtrlSetFont($Label_status, 9, 600)
				EndIf
			Else
				$srcfle = IniRead($inifle, "Last File", "path", "")
				GUICtrlSetData($Input_file, $srcfle)
			EndIf
		Case $msg = $List_games
			; List of games
			$name = GUICtrlRead($List_games)
			GUICtrlSetData($Input_name, $name)
			$title = IniRead($gamesfle, $name, "title", "error")
			GUICtrlSetData($Input_title, $title)
		Case Else
			;;;
		EndSelect
	WEnd
EndFunc ;=> MainGUI

Func FillTheGamesList()
	If FileExists($titlist) Then
		$res = _FileReadToArray($titlist, $array)
		If $res = 1 Then
			$games = 0
			For $a = 1 To $array[0]
				$line = $array[$a]
				If $line <> "" Then
					$name = $line
					GUICtrlSetData($List_games, $name)
					$games = $games + 1
				EndIf
			Next
			If $games > 0 Then GUICtrlSetData($Group_games, "Games  (" & $games & ")")
		EndIf
	EndIf
EndFunc ;=> FillTheGamesList

Func GetAllowedName()
	$name = StringReplace($name, Chr(150), "-")
	$name = StringReplace($name, Chr(151), "-")
	$name = StringReplace($name, Chr(175), "-")
	$name = StringReplace($name, "–", "-")
	$name = ReplaceForeignCharacters($name)
	$name = ReplaceOtherCharacters($name)
	$name = StringStripWS($name, 7)
EndFunc ;=> GetAllowedName

Func ReplaceForeignCharacters($text)
	Local $char, $let, $p, $pair, $pairs
	$pairs = "À,A|Á,A|Â,A|Ã,A|Ä,A|Å,A|Æ,AE|Ç,C|È,E|É,E|Ê,E|Ë,E|Ì,I|Í,I|Î,I|Ï,I|Ð,D|Ñ,N|Ò,O|Ó,O|Ô,O|Õ,O|Ö,O|×,x|Ø,O|Ù,U|Ú,U|Û,U|Ü,U|Ý,Y|ß,B|" _
		& "à,a|á,a|â,a|ã,a|ä,a|å,a|æ,ae|ç,c|è,e|é,e|ê,e|ë,e|ì,i|í,i|î,i|ï,i|ð,o|ñ,n|ò,o|ó,o|ô,o|õ,o|ö,o|ø,o|ù,u|ú,u|û,u|ü,u|ý,y|ÿ,y"
	$pairs = StringSplit($pairs, "|", 1)
	For $p = 1 To $pairs[0]
		$pair = $pairs[$p]
		$pair = StringSplit($pair, ",", 1)
		$char = $pair[1]
		$let = $pair[2]
		$text = StringReplace($text, $char, $let, 0, 1)
	Next
	Return $text
EndFunc ;=> ReplaceForeignCharacters

Func ReplaceOtherCharacters($text)
	Local $char, $l, $len, $let
	$let = StringLeft($text, 1)
	If $let = "'" Or $let = '"' Then $text = StringTrimLeft($text, 1)
	$let = StringRight($text, 1)
	If $let = "'" Or $let = '"' Then $text = StringTrimRight($text, 1)
	;
	$text = StringReplace($text, "[", "{")
	$text = StringReplace($text, "]", "}")
	$text = StringReplace($text, "|", " ")
	;
	$name = ""
	$len = StringLen($text)
	For $l = 1 To $len
		$let = StringMid($text, $l, 1)
		$char = Asc($let)
		If $char > 31 And $char < 127 Then
			$name = $name & $let
		EndIf
	Next
	$text = $name
	Return $text
EndFunc ;=> ReplaceOtherCharacters
