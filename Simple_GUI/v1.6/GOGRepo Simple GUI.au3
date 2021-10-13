;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                                       ;;
;;  AutoIt Version: 3.3.14.2                                                             ;;
;;                                                                                       ;;
;;  Template AutoIt script.                                                              ;;
;;                                                                                       ;;
;;  AUTHOR:  Timboli                                                                     ;;
;;                                                                                       ;;
;;  SCRIPT FUNCTION:  A limited simple GUI frontend for gogrepo.py (or gogrepo.exe)      ;;
;;                                                                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; FUNCTIONS
; MainGUI(), SetupGUI()
; AddFileToCombo($add, $filepth), DetermineFindText(), FillTheGamesList(), GetAllowedName(), ReplaceForeignCharacters($text)
; ReplaceOtherCharacters($text), SetControlsState($state)

#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <ColorConstants.au3>
#include <ListBoxConstants.au3>
#include <StaticConstants.au3>
#include <GuiListBox.au3>
#include <GuiComboBox.au3>
#include <Misc.au3>
#include <File.au3>
#include <Date.au3>
#include <Crypt.au3>
#include <Array.au3>
#include "ExtProp.au3"

_Singleton("gog-repo-simple-gui-timboli")

Global $Button_exit, $Button_find, $Button_fold, $Button_get, $Button_info, $Button_log, $Button_setup, $Button_verify
Global $Checkbox_exact, $Checkbox_update, $Combo_file, $Group_drop, $Group_games, $Group_size, $Group_status, $Input_name
Global $Input_title, $Label_drop, $Label_size, $Label_status, $Label_title, $List_games
;
Global $7zip, $a, $add, $ans, $array, $atts, $boxcol, $cmdpid, $cnt, $cookies, $entries, $entry, $f, $file, $filefld, $filepth
Global $files, $find, $foldrar, $foldzip, $found, $g, $games, $gamesfle, $gogrepo, $handle, $hash, $height, $icoD, $icoI, $icoS
Global $icoT, $icoX, $ind, $inifle, $lang, $left, $line, $logfle, $manifest, $match, $md5, $name, $names, $open, $OS, $OSget
Global $out, $outcome, $pid, $pos, $prog, $property, $repoGUI, $required, $res, $results, $resumeman, $ret, $script, $shell
Global $show, $SimpleGUI, $size, $srcfld, $srcfle, $state, $style, $target, $text, $textcol, $thanks, $title, $titlist, $top
Global $unrar, $update, $updated, $user, $val, $version, $w, $warning, $width, $winpos, $wins, $wintit, $zipexe
;Global $innoextract
;
Global $gaDropFiles[1], $hWnd, $lParam, $msgID, $wParam
; NOTE - If using older AutoIt, then $WM_DROPFILES = 0x233 may need to be declared.
;
$7zip = @ScriptDir & "\7-Zip\7z.exe"
$cookies = @ScriptDir & "\gog-cookies.dat"
$foldrar = @ScriptDir & "\UnRAR"
$foldzip = @ScriptDir & "\7-Zip"
$gamesfle = @ScriptDir & "\Games.ini"
$gogrepo = @ScriptDir & "\gogrepo.exe"
$inifle = @ScriptDir & "\Options.ini"
;$innoextract = @ScriptDir & "\innoextract.exe"
$logfle = @ScriptDir & "\Log.txt"
$manifest = @ScriptDir & "\gog-manifest.dat"
;$resumeman = @ScriptDir & "\gog-resume-manifest.dat"
$target = @LF & "Drag && Drop" & @LF & "GOG Game" & @LF & "Files or Folder" & @LF & "HERE"
$titlist = @ScriptDir & "\Titles.txt"
$unrar = @ScriptDir & "\UnRAR\UnRAR.exe"
$version = "v1.6"

If FileExists($gogrepo) Then
	$prog = "gogrepo.exe"
Else
	$gogrepo = @ScriptDir & "\gogrepo.py"
	$prog = "gogrepo.py"
EndIf

If FileExists($7zip) Then
	$zipexe = "7z.exe"
Else
	$7zip = @ScriptDir & "\7-Zip\7za.exe"
	If FileExists($7zip) Then
		$zipexe = "7za.exe"
	EndIf
EndIf

$repoGUI = @ScriptDir & "\GOGRepo GUI.au3"
If FileExists($repoGUI) Then
	$warning = 1
Else
	$repoGUI = @ScriptDir & "\GOGRepo GUI.exe"
	If FileExists($repoGUI) Then
		$warning = 1
	EndIf
EndIf
If $warning = 1 Then
	MsgBox(262192, "Program Warning", "This program cannot exist and run in the same folder" _
		& @LF & "as my GOGRepo GUI program. It will now close (exit).", 0)
	Exit
EndIf

If Not FileExists($foldrar) Then DirCreate($foldrar)
If Not FileExists($foldzip) Then DirCreate($foldzip)

If Not FileExists($titlist) Then _FileCreate($titlist)

If FileExists($titlist) Then
	If FileExists($gogrepo) Then
		If $prog = "gogrepo.py" Then
			$res = _FileReadToArray($gogrepo, $array)
			If $res = 1 Then
				$ind = _ArraySearch($array, "RESUME_MANIFEST_FILENAME = r'gog-resume-manifest.dat'", 0)
				;MsgBox(262192, "Line Search", $ind, 0, $GOGRepoGUI)
				If $ind = -1 Then
					$ind = _ArraySearch($array, "TITLES_FILENAME = r'gog-titles.dat'", 0)
					If $ind = -1 Then
						$ans = MsgBox(262179, "Script Alert & Query", _
							"The version of 'gogrepo.py' found, is not currently" & @LF & _
							"suitable in its present state, for use with this simple" & @LF & _
							"program. It is recommended that you use Kalanyr's" & @LF & _
							"forked version of the 'gogrepo.py' script." & @LF & @LF & _
							"However, it is also possible to modify the current" & @LF & _
							"version to be suitable (if the modification works)." & @LF & @LF & _
							"YES = Attempt to modify the existing script." & @LF & _
							"NO = Acquire the Kalanyr version (web connect)." & @LF & _
							"CANCEL = Abort & manually fix the issue etc." & @LF & @LF & _
							"NOTE - By 'web connect' we mean taken via your" & @LF & _
							"browser to the GitHub web page, where you can" & @LF & _
							"download the Kalanyr script." & @LF & @LF & _
							"Both NO and CANCEL exit this program.", 0)
						If $ans = 6 Then
							Local $chunk, $exist, $modify = "", $repotemp = $gogrepo & ".tmp"
							$res = FileCopy($gogrepo, $repotemp, 1)
							If $res = 1 Then
								$exist = "MANIFEST_FILENAME = r'gog-manifest.dat'" & @LF
								$chunk = $exist & "TITLES_FILENAME = r'gog-titles.dat'" & @LF
								$res = _ReplaceStringInFile($gogrepo, $exist, $chunk)
								If $res = 1 Then
									$exist = "    # fetch item details" & @LF
									$chunk = $exist & "    titlesdb = sorted(items, key=lambda item: item.title)" & @LF _
										& "    save_titles(titlesdb)" & @LF & @LF & "    # fetch item details" & @LF
									$res = _ReplaceStringInFile($gogrepo, $exist, $chunk)
									If $res = 1 Then
										$exist = "    gamesdb = load_manifest()" & @LF
										$chunk = $exist & @LF & "    try:" & @LF & "        titlesdb = load_titles()" & @LF _
											& "    except:" & @LF & "	    titlesdb = None" & @LF
										$res = _ReplaceStringInFile($gogrepo, $exist, $chunk, 0, 0)
										If $res = 1 Then
											$exist = "def save_manifest(items):" & @LF & "    info('saving manifest...')" & @LF _
												& "    with codecs.open(MANIFEST_FILENAME, 'w', 'utf-8') as w:" & @LF _
												& "        print('# {} games'.format(len(items)), file=w)" & @LF _
												& "        pprint.pprint(items, width=123, stream=w)" & @LF
											$chunk = $exist & @LF & @LF _
												& "def load_titles(filepath=TITLES_FILENAME):" & @LF & "    info('loading local titles...')" & @LF _
												& "    try:" & @LF & "        with codecs.open(TITLES_FILENAME, 'rU', 'utf-8') as r:" & @LF _
												& "            ad = r.read().replace('{', 'AttrDict(**{').replace('}', '})')" & @LF & "        return eval(ad)" & @LF _
												& "    except IOError:" & @LF & "        return []" & @LF & @LF & @LF _
												& "def save_titles(items):" & @LF & "    info('saving titles...')" & @LF _
												& "    with codecs.open(TITLES_FILENAME, 'w', 'utf-8') as w:" & @LF _
												& "        print('# {} games'.format(len(items)), file=w)" & @LF _
												& "        pprint.pprint(items, width=123, stream=w)" & @LF _
												& "    info('saved titles')" & @LF
											$res = _ReplaceStringInFile($gogrepo, $exist, $chunk)
											If $res = 1 Then
												$modify = 1
											EndIf
										EndIf
									EndIf
								EndIf
								If $modify = 1 Then
									$script = "default"
									$resumeman = @ScriptDir & "\gog-titles.dat"
									MainGUI()
								Else
									$res = FileMove($repotemp, $gogrepo, 1)
									If $res = 1 Then
										MsgBox(262192, "Program Error", "The modification appears to have failed!", 0)
									Else
										MsgBox(262192, "Program Error", "The modification appears to have failed, and the" & @LF & _
											"backup of 'gogrepo.py' could not be restored!" & @LF & @LF & _
											"Please restore or replace the 'gogrepo.py' file" & @LF & _
											"manually (i.e. rename 'gogrepo.py.tmp').", 0)
									EndIf
								EndIf
							Else
								MsgBox(262192, "Program Error", "Backup has failed, no modification occurred!", 0)
							EndIf
						ElseIf $ans = 7 Then
							Local $website = "https://github.com/Kalanyr/gogrepoc"
							ShellExecute($website)
						EndIf
					Else
						$script = "default"
						$resumeman = @ScriptDir & "\gog-titles.dat"
						MainGUI()
					EndIf
				Else
					$script = "forked"
					$resumeman = @ScriptDir & "\gog-resume-manifest.dat"
					MainGUI()
				EndIf
			Else
				MsgBox(262192, "Program Error", "The 'gogrepo.py' file could not be checked!", 0)
			EndIf
		Else
			; Should do an MD5 check of the EXE version of gogrepo.py
			$md5 = "ebd7d5426d584e5ffe3558aa87dd083f"
			_Crypt_Startup()
			$hash = _Crypt_HashFile($gogrepo, $CALG_MD5)
			$hash = StringTrimLeft($hash, 2)
			_Crypt_Shutdown()
			If $hash = $md5 Then
				$script = "default"
				$resumeman = @ScriptDir & "\gog-titles.dat"
				MainGUI()
			Else
				MsgBox(262192, "Program Error", "The 'gogrepo.exe' file failed the MD5 check!", 0)
			EndIf
		EndIf
	Else
		MsgBox(262192, "Program Error", "Required '" & $prog & "' file could not be found!", 0)
	EndIf
Else
	MsgBox(262192, "Program Error", "Titles.txt file could not be created!", 0)
EndIf

Exit

Func MainGUI()
	Local $bytes, $date, $diff, $dir, $drv, $exe, $fext, $fnam, $mass, $o, $output, $rar, $sh, $zip
	;
	$width = 580
	$height = 395
	$left = IniRead($inifle, "Program Window", "left", @DesktopWidth - $width - 25)
	$top = IniRead($inifle, "Program Window", "top", @DesktopHeight - $height - 30)
	$style = $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU + $WS_CLIPSIBLINGS + $WS_MINIMIZEBOX ; + $WS_VISIBLE
	$SimpleGUI = GuiCreate("GOGRepo Simple GUI " & $version, $width, $height, $left, $top, $style, $WS_EX_TOPMOST + $WS_EX_ACCEPTFILES)
	GUISetBkColor($COLOR_SKYBLUE, $SimpleGUI)
	; CONTROLS
	$Group_files = GuiCtrlCreateGroup("", 10, 5, 560, 47)
	$Label_file = GuiCtrlCreateLabel("Files", 20, 22, 38, 19, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN + $SS_NOTIFY)
	GUICtrlSetBkColor($Label_file, $COLOR_FUCHSIA)
	GUICtrlSetColor($Label_file, $COLOR_BLUE)
	GUICtrlSetFont($Label_file, 7, 600, 0, "Small Fonts")
	;GUICtrlSetTip($Label_file, "Dropped game file!")
	$Combo_file = GUICtrlCreateCombo("", 58, 22, 502, 21)
	GUICtrlSetFont($Combo_file, 7, 400, 0, "Small Fonts")
	GUICtrlSetBkColor($Combo_file, 0xFFD5FF)
	GUICtrlSetTip($Combo_file, "Dropped game file(s)!")
	$Group_games = GuiCtrlCreateGroup("Games", 10, 60, 370, 323)
	$List_games = GuiCtrlCreateList("", 20, 80, 350, 240)
	GUICtrlSetBkColor($List_games, 0xBBFFBB)
	GUICtrlSetTip($List_games, "List of games!")
	$Input_name = GUICtrlCreateInput("", 20, 326, 350, 20)
	GUICtrlSetBkColor($Input_name, 0xFFFFB0)
	GUICtrlSetTip($Input_name, "Game Name!")
	$Label_title = GuiCtrlCreateLabel("Title", 20, 351, 38, 20, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN + $SS_NOTIFY)
	GUICtrlSetBkColor($Label_title, $COLOR_BLUE)
	GUICtrlSetColor($Label_title, $COLOR_WHITE)
	GUICtrlSetFont($Label_title, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Label_title, "Click to restore last search text to Title input field!")
	$Input_title = GUICtrlCreateInput("", 58, 351, 215, 20) ;, $ES_READONLY
	GUICtrlSetBkColor($Input_title, 0xBBFFBB)
	GUICtrlSetTip($Input_title, "Game Title!")
	$Button_find = GuiCtrlCreateButton("?", 276, 350, 22, 22, $BS_ICON)
	GUICtrlSetTip($Button_find, "Find the specified game title on list!")
	$Checkbox_exact = GUICtrlCreateCheckbox("Exact", 300, 351, 45, 20)
	GUICtrlSetTip($Checkbox_exact, "Exact from left!")
	$Button_fold = GuiCtrlCreateButton("D", 350, 351, 20, 20, $BS_ICON)
	GUICtrlSetTip($Button_fold, "Use folder name for find!")
	;
	$Group_drop = GuiCtrlCreateGroup("Drop Zone", 390, 60, 180, 110)
	$Label_drop = GUICtrlCreateLabel($target, 400, 80, 160, 80, $SS_CENTER)
	GUICtrlSetFont($Label_drop, 9, 600, 0, "Small Fonts")
	GUICtrlSetState($Label_drop, $GUI_DROPACCEPTED)
	GUICtrlSetTip($Label_drop, "Drag & Drop downloaded game files here!")
	$boxcol = $COLOR_YELLOW
	$textcol = $COLOR_RED
	GUICtrlSetBkColor($Label_drop, $boxcol)
	GUICtrlSetColor($Label_drop, $textcol)
	;
	$Button_get = GuiCtrlCreateButton("RETRIEVE LIST" & @LF & "OF GAMES", 390, 180, 105, 40, $BS_MULTILINE)
	GUICtrlSetFont($Button_get, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_get, "Get game title from GOG library!")
	;
	$Group_size = GuiCtrlCreateGroup("Size", 505, 175, 65, 43)
	$Label_size = GuiCtrlCreateLabel("", 512, 190, 51, 20, $SS_CENTER + $SS_CENTERIMAGE) ; + $SS_SUNKEN
	GUICtrlSetBkColor($Label_size, $COLOR_MONEYGREEN)
	GUICtrlSetColor($Label_size, $COLOR_GREEN)
	;GUICtrlSetColor($Label_size, 0xBBFFBB)
	;
	$Group_status = GuiCtrlCreateGroup("Status", 390, 225, 180, 50)
	$Label_status = GuiCtrlCreateLabel("Waiting", 400, 243, 160, 22, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_status, $COLOR_BLUE)
	GUICtrlSetColor($Label_status, $COLOR_WHITE)
	GUICtrlSetFont($Label_status, 9, 600)
	;
	$Button_verify = GuiCtrlCreateButton("VERIFY ALL" & @LF & "DROPPED FILES", 390, 285, 130, 40, $BS_MULTILINE)
	GUICtrlSetFont($Button_verify, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_verify, "Verify the dropped game file!")
	;
	$Button_log = GuiCtrlCreateButton("Log", 525, 285, 45, 40, $BS_ICON)
	GUICtrlSetTip($Button_log, "Log Record!")
	;
	$Checkbox_update = GUICtrlCreateCheckbox("Update", 393, 327, 57, 20)
	GUICtrlSetTip($Checkbox_update, "Update selected game title detail!")
	;
	$Button_setup = GuiCtrlCreateButton("SETUP", 390, 350, 60, 35)
	GUICtrlSetFont($Button_setup, 8, 600)
	GUICtrlSetTip($Button_setup, "Program Setup!")
	;
	$Button_info = GuiCtrlCreateButton("Info", 460, 335, 50, 50, $BS_ICON)
	GUICtrlSetTip($Button_info, "Program Information!")
	;
	$Button_exit = GuiCtrlCreateButton("EXIT", 520, 335, 50, 50, $BS_ICON)
	GUICtrlSetTip($Button_exit, "Exit / Close / Quit the program!")
	;
	; OS SETTINGS
	$user = @SystemDir & "\user32.dll"
	$shell = @SystemDir & "\shell32.dll"
	$icoD = -4
	$icoI = -5
	$icoS = -23
	$icoT = -71
	$icoX = -4
	GUICtrlSetImage($Button_find, $shell, $icoS, 0)
	GUICtrlSetImage($Button_fold, $shell, $icoD, 0)
	GUICtrlSetImage($Button_log, $shell, $icoT, 1)
	GUICtrlSetImage($Button_info, $user, $icoI, 1)
	GUICtrlSetImage($Button_exit, $user, $icoX, 1)
	;
	; SETTINGS
	GUICtrlSetState($Checkbox_exact, $GUI_CHECKED)
	;
	$update = 1
	GUICtrlSetState($Checkbox_update, $update)
	;
	FillTheGamesList()
	;
	$OSget = IniRead($inifle, "Update Options", "OS", "")
	If $OSget = "" Then
		$OSget = "windows linux"
		IniWrite($inifle, "Update Options", "OS", $OSget)
	EndIf
	;
	$lang = IniRead($inifle, "Update Options", "language", "")
	If $lang = "" Then
		$lang = "en"
		$val = InputBox("Language Query", "Please enter the two character" _
			& @LF & "code for your language ... plus" _
			& @LF & "any other languages you wish" _
			& @LF & "to download for, using a space" _
			& @LF & "as divider between." & @LF _
			& @LF & "i.e. de en fr", _
			$lang, "", 100, 205, Default, Default, 0, $SimpleGUI)
		If Not @error Then
			$lang = $val
		EndIf
		IniWrite($inifle, "Update Options", "language", $lang)
	EndIf
	;
	If Not FileExists($cookies) Then
		GUICtrlSetState($Button_get, $GUI_DISABLE)
		GUICtrlSetState($Button_verify, $GUI_DISABLE)
	EndIf

	GUIRegisterMsg($WM_DROPFILES, "WM_DROPFILES_FUNC")

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
			$cnt = UBound($gaDropFiles)
			If $cnt = 1 Then
				$srcfle = @GUI_DragFile
				$atts = FileGetAttrib($srcfle)
				If StringInStr($atts, "D") > 0 Then
					;MsgBox(262192, "Drop Error", "Folders are not supported!", 0, $SimpleGUI)
					$srcfld = $srcfle & "\"
					IniWrite($inifle, "Source Folder", "path", $srcfld)
					$array = _FileListToArrayRec($srcfld, "*", $FLTAR_FILES, $FLTAR_RECUR, $FLTAR_SORT, $FLTAR_RELPATH)
					If @error <> 1 Then
						$files = ""
						For $a = 1 To $array[0]
							$file = $array[$a]
							$srcfle = $srcfld & $file
							_PathSplit($srcfle, $drv, $dir, $fnam, $fext)
							If $fext = ".exe" Or $fext = ".bin" Or $fext = ".rar" Or $fext = ".zip" Or $fext = ".7z" Or $fext = ".sh" Then
								AddFileToCombo(1, $file)
							EndIf
						Next
					ElseIf @extended = 9 Then
						MsgBox(262192, "Source Error", "No files found!", 0, $SimpleGUI)
					Else
						MsgBox(262192, "Source Error", "Files couldn't be returned!", 0, $SimpleGUI)
					EndIf
				Else
					_PathSplit($srcfle, $drv, $dir, $fnam, $fext)
					If $fext = ".exe" Or $fext = ".bin" Or $fext = ".rar" Or $fext = ".zip" Or $fext = ".7z" Or $fext = ".sh" Then
						$srcfld = $drv & $dir
						IniWrite($inifle, "Source Folder", "path", $srcfld)
						$file = $fnam & $fext
						AddFileToCombo(0, $file)
					Else
						MsgBox(262192, "Drop Error", "File type not supported!", 0, $SimpleGUI)
					EndIf
				EndIf
			Else
				$files = ""
				$srcfld = ""
				For $g = 0 To $cnt - 1
					$srcfle = $gaDropFiles[$g]
					$atts = FileGetAttrib($srcfle)
					If StringInStr($atts, "D") > 0 Then
						MsgBox(262192, "Drop Error", "Folders are not supported in multiple drop!", 2, $SimpleGUI)
					Else
						_PathSplit($srcfle, $drv, $dir, $fnam, $fext)
						If $fext = ".exe" Or $fext = ".bin" Or $fext = ".rar" Or $fext = ".zip" Or $fext = ".7z" Or $fext = ".sh" Then
							If $srcfld = "" Then
								$srcfld = $drv & $dir
								IniWrite($inifle, "Source Folder", "path", $srcfld)
							EndIf
							$file = $fnam & $fext
							AddFileToCombo(1, $file)
						Else
							MsgBox(262192, "Drop Error", "File type (" & $fext & ") not supported!", 0, $SimpleGUI)
						EndIf
					EndIf
				Next
			EndIf
		Case $msg = $Button_verify
			; Verify the dropped game file
			$ans = MsgBox(262177, "Verify Query", _
				"Verify integrity of dropped file for selected game title?", 0, $SimpleGUI)
			If $ans = 1 Then
				SetControlsState($GUI_DISABLE)
				GUICtrlSetData($Label_size, "")
				$name = GUICtrlRead($Input_name)
				$title = GUICtrlRead($Input_title)
				If $name <> "" And $title <> "" Then
					If $title = IniRead($gamesfle, $name, "title", "") Then
						$files = _GUICtrlComboBox_GetList($Combo_file)
						If $files <> "" Then
							$srcfld = IniRead($inifle, "Source Folder", "path", "")
							If $srcfld <> "" Then
								;MsgBox(262192, "$files", $files, 0, $SimpleGUI)
								;ContinueLoop
								GUICtrlSetBkColor($Label_status, 0xFFCE9D)
								GUICtrlSetColor($Label_status, $COLOR_BLUE)
								GUICtrlSetFont($Label_status, 9, 600)
								_FileWriteLog($logfle, "NAME = " & $name)
								_FileWriteLog($logfle, "TITLE = " & $title)
								$updated = IniRead($gamesfle, $name, "updated", "")
								If $updated <> "" Then
									$date = _NowCalc()
									$diff = _DateDiff('h', $updated, $date)
									If $diff >= 24 And $update = 4 Then
										$ans = MsgBox(262177, "Update Query", _
											"This game title has been checked before," & @LF & _
											"but that was more than 24 hours ago." & @LF & @LF & _
											"OK = Update the details again." & @LF & _
											"CANCEL = Continue with existing." & @LF & @LF & _
											"NOTE - CANCEL resets for 24 hours.", 0, $SimpleGUI)
										If $ans = 1 Then
											$updated = ""
										ElseIf $ans = 2 Then
											IniWrite($gamesfle, $name, "updated", $date)
										EndIf
									ElseIf $diff < 24 And $update = 1 Then
										$ans = MsgBox(262177, "Update Query", _
											"This game title has been checked before," & @LF & _
											"but that was less than 24 hours ago." & @LF & @LF & _
											"OK = Update the details again." & @LF & _
											"CANCEL = Continue with existing.", 0, $SimpleGUI)
										If $ans = 2 Then
											$update = 4
											GUICtrlSetState($Checkbox_update, $update)
										EndIf
									EndIf
								;ElseIf $update = 4 Then
								EndIf
								If $update = 1 Or $updated = "" Then
									GUICtrlSetData($Label_status, "Downloading Data")
									If FileExists($resumeman) Then FileDelete($resumeman)
									FileChangeDir(@ScriptDir)
									If $OSget = "" Then $OSget = "windows linux"
									If $lang = "" Then $lang = "en"
									RunWait(@ComSpec & ' /c ' & $prog & ' update -os ' & $OSget & ' -lang ' & $lang & ' -id ' & $title, @ScriptDir)
									$updated = _NowCalc()
									IniWrite($gamesfle, $name, "updated", $updated)
								EndIf
								_Crypt_Startup()
								$outcome = ""
								$show = ""
								$files = StringSplit($files, "|", 1)
								$cnt = $files[0]
								For $f = 1 To $cnt
									$filepth = $files[$f]
									$ind = _GUICtrlComboBox_FindString($Combo_file, $filepth, -1)
									If $ind > -1 Then
										_GUICtrlComboBox_SetCurSel($Combo_file, $ind)
									EndIf
									$srcfle = $srcfld & $filepth
									If FileExists($srcfle) Then
										$bytes = FileGetSize($srcfle)
										$mass = GetTheSize($bytes)
										GUICtrlSetData($Label_size, $mass)
										_PathSplit($srcfle, $drv, $dir, $fnam, $fext)
										$filefld = StringTrimRight($drv & $dir, 1)
										$file = $fnam & $fext
										_FileWriteLog($logfle, "VERIFYING = " & $file)
										GUICtrlSetData($Label_status, "Verifying File")
										$res = _FileReadToArray($manifest, $array, 1)
										If $res = 1 Then
											$err = ""
											$out = ""
											$results = ""
											;
											$exe = ""
											$md5 = ""
											$rar = ""
											$sh = ""
											$size = ""
											$zip = ""
											For $a = 2 To $array[0]
												$line = $array[$a]
												If $line <> "" Then
													If StringInStr($line, $file) > 0 Then
														_FileWriteLog($logfle, "File found in manifest.")
														$a = $a - 1
														If $fext = ".exe" Or $fext = ".bin" Or $fext = ".sh" Then
															GUICtrlSetData($Label_status, "Getting MD5")
															$line = $array[$a]
															If StringInStr($line, "'md5':") > 0 Then
																$md5 = $line
																$md5 = StringSplit($md5, "'", 1)
																$md5 = $md5[$md5[0]-1]
																$md5 = StringSplit($md5, "'", 1)
																$md5 = $md5[$md5[0]]
															EndIf
														ElseIf $fext = ".zip" Or $fext = ".7z" Then
															If FileExists($7zip) Then
																If $fext = ".zip" Then
																	GUICtrlSetData($Label_status, "Checking ZIP file")
																ElseIf $fext = ".7z" Then
																	GUICtrlSetData($Label_status, "Checking 7Z file")
																EndIf
																FileChangeDir($foldzip)
																$ret = Run($zipexe & ' t "' & $srcfle & '"', "", @SW_SHOW, $STDERR_MERGED)
																;$pid = $ret
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
																			;MsgBox($MB_SYSTEMMODAL, "Stderr Read:", $out)
																			$err = 1
																		WEnd
																		If $out <> "" Then $results &= $out
																		ExitLoop
																	Else
																		If $out <> "" Then
																			$output = StringSplit($out, @CR, 1)
																			For $o = 1 To $output[0]
																				$out = $output[$o]
																				$out = StringStripWS($out, 7)
																				If $out <> "" Then
																					$out = $out & @CRLF
																					If StringInStr($out, "Everything is Ok") > 0 Then
																						$zip = "Passed."
																						;MsgBox($MB_SYSTEMMODAL, "Stderr Read:", $out)
																					EndIf
																					$results &= $out
																				EndIf
																			Next
																		EndIf
																	EndIf
																Wend
																If $zip <> "Passed." Then
																	$zip = "Failed."
																EndIf
																If $fext = ".zip" Then
																	$zip = "ZIP " & $zip
																ElseIf $fext = ".7z" Then
																	$zip = "7Z " & $zip
																EndIf
															Else
																$zip = "7-Zip Missing."
															EndIf
														ElseIf $fext = ".rar" Then
															If FileExists($unrar) Then
																GUICtrlSetData($Label_status, "Checking RAR file")
																FileChangeDir($foldrar)
																$ret = Run('UnRAR.exe t "' & $srcfle & '"', "", @SW_SHOW, $STDERR_MERGED)
																;$pid = $ret
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
																			;MsgBox($MB_SYSTEMMODAL, "Stderr Read:", $out)
																			$err = 1
																		WEnd
																		If $out <> "" Then $results &= $out
																		ExitLoop
																	Else
																		If $out <> "" Then
																			$output = StringSplit($out, @CR, 1)
																			For $o = 1 To $output[0]
																				$out = $output[$o]
																				$out = StringStripWS($out, 7)
																				If $out <> "" Then
																					$out = $out & @CRLF
																					If StringInStr($out, "All OK") > 0 Then
																						$rar = "RAR Passed."
																						;MsgBox($MB_SYSTEMMODAL, "Stderr Read:", $out)
																					EndIf
																					$results &= $out
																				EndIf
																			Next
																		EndIf
																	EndIf
																Wend
																If $rar <> "RAR Passed." Then $rar = "RAR Failed."
															Else
																$rar = "UnRAR Missing."
															EndIf
														EndIf
														If $md5 = "" Then
															If $fext = ".exe" Or $fext = ".bin" Then
																If FileExists($7zip) Then
																	If $fext = ".exe" Then
																		GUICtrlSetData($Label_status, "Checking EXE file")
																	ElseIf $fext = ".bin" Then
																		GUICtrlSetData($Label_status, "Checking BIN file")
																	EndIf
																	FileChangeDir($foldzip)
																	$ret = Run($zipexe & ' t -t# "' & $srcfle & '"', "", @SW_HIDE, $STDERR_MERGED)
																	;$pid = $ret
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
																				;MsgBox($MB_SYSTEMMODAL, "Stderr Read:", $out)
																				$err = 1
																			WEnd
																			If $out <> "" Then $results &= $out
																			ExitLoop
																		Else
																			If $out <> "" Then
																				$output = StringSplit($out, @CR, 1)
																				For $o = 1 To $output[0]
																					$out = $output[$o]
																					$out = StringStripWS($out, 7)
																					If $out <> "" Then
																						$out = $out & @CRLF
																						If StringInStr($out, "Everything is Ok") > 0 Then
																							$exe = "Passed."
																							;MsgBox($MB_SYSTEMMODAL, "Stderr Read:", $out)
																						EndIf
																						$results &= $out
																					EndIf
																				Next
																			EndIf
																		EndIf
																	Wend
																	If $exe <> "Passed." Then
																		$exe = "Failed."
																	EndIf
																	If $fext = ".exe" Then
																		$exe = "EXE " & $exe
																	ElseIf $fext = ".bin" Then
																		$exe = "BIN " & $exe
																	EndIf
																Else
																	$exe = "7-Zip Missing."
																EndIf
															ElseIf $fext = ".sh" Then
																If FileExists($7zip) Then
																	GUICtrlSetData($Label_status, "Checking SH file")
																	FileChangeDir($foldzip)
																	$ret = Run($zipexe & ' t -tzip "' & $srcfle & '"', "", @SW_SHOW, $STDERR_MERGED)
																	;$pid = $ret
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
																				;MsgBox($MB_SYSTEMMODAL, "Stderr Read:", $out)
																				$err = 1
																			WEnd
																			If $out <> "" Then $results &= $out
																			ExitLoop
																		Else
																			If $out <> "" Then
																				$output = StringSplit($out, @CR, 1)
																				For $o = 1 To $output[0]
																					$out = $output[$o]
																					$out = StringStripWS($out, 7)
																					If $out <> "" Then
																						$out = $out & @CRLF
																						If StringInStr($out, "Everything is Ok") > 0 Then
																							$sh = "SH Passed."
																							;MsgBox($MB_SYSTEMMODAL, "Stderr Read:", $out)
																						EndIf
																						$results &= $out
																					EndIf
																				Next
																			EndIf
																		EndIf
																	Wend
																	If $sh <> "SH Passed." Then $sh = "SH Failed."
																Else
																	$sh = "7-Zip Missing."
																EndIf
															EndIf
														EndIf
														GUICtrlSetData($Label_status, "Getting Size")
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
												GUICtrlSetData($Label_status, "Comparing MD5")
												$hash = _Crypt_HashFile($srcfle, $CALG_MD5)
												$hash = StringTrimLeft($hash, 2)
												If $hash = $md5 Then
													$match = "MD5 Passed."
												Else
													$match = "MD5 Failed."
												EndIf
											Else
												If (($fext = ".exe" Or $fext = ".bin") And $exe = "") Or ($fext = ".sh" And $sh = "") Then
													$match = "MD5 Missing."
												ElseIf $fext = ".exe" Or $fext = ".bin" Or $fext = ".sh" Then
													_FileWriteLog($logfle, "MD5 Missing.")
												EndIf
											EndIf
											If $exe <> "" Then
												$match = $exe
											EndIf
											If $rar <> "" Then
												$match = $rar
											EndIf
											If $sh <> "" Then
												$match = $sh
											EndIf
											If $zip <> "" Then
												$match = $zip
											EndIf
											If $size <> "" Then
												;If FileGetSize($srcfle) = $size Then
												If $bytes = $size Then
													$match = $match & " Size Passed."
												Else
													$match = $match & " Size Failed."
												EndIf
											Else
												$match = " Size Missing."
											EndIf
											$match = StringStripWS($match, 1)
											_FileWriteLog($logfle, $match)
											If StringInStr($match, "Failed") > 0 Or StringInStr($match, "Missing") > 0 Or StringInStr($match, "Error") > 0 Then
												GUICtrlSetBkColor($Label_status, $COLOR_WHITE)
												GUICtrlSetColor($Label_status, $COLOR_RED)
											Else
												GUICtrlSetBkColor($Label_status, $COLOR_LIME)
												GUICtrlSetColor($Label_status, $COLOR_BLACK)
											EndIf
											GUICtrlSetFont($Label_status, 7, 600, 0, "Small Fonts")
											GUICtrlSetData($Label_status, $match)
											If $outcome = "" Then
												$outcome = "Source Folder = " & $srcfld
												$outcome = $outcome & @LF & "-------------------"
												$outcome = $outcome & @LF & "(" & $match & ") " & $filepth
											Else
												$outcome = $outcome & @LF & "-------------------"
												$outcome = $outcome & @LF & "(" & $match & ") " & $filepth
												$show = 1
											EndIf
											If $cnt > 1 Then Sleep(3000)
										Else
											MsgBox(262192, "Read Error", "Manifest could not be opened!", 0, $SimpleGUI)
										EndIf
									Else
										MsgBox(262192, "Source Error", "Source file doesn't exist!", 0, $SimpleGUI)
										ExitLoop
									EndIf
								Next
								_Crypt_Shutdown()
								If $outcome <> "" And $show = 1 Then
									MsgBox(262208, "Verify Results", _
										$outcome & @LF & @LF & _
										$cnt & " files were processed." & @LF & @LF & _
										"See the Log file for more detail.", 0, $SimpleGUI)
								EndIf
							Else
								MsgBox(262192, "Source Error", "Source folder is missing!", 0, $SimpleGUI)
							EndIf
						Else
							MsgBox(262192, "Source Error", "File(s) are missing!", 0, $SimpleGUI)
						EndIf
					Else
						MsgBox(262192, "Game Selection Error", "Title and Name pairing are incorrect!", 0, $SimpleGUI)
					EndIf
				Else
					MsgBox(262192, "Game Selection Error", "Title not selected correctly!", 0, $SimpleGUI)
				EndIf
				SetControlsState($GUI_ENABLE)
			EndIf
		Case $msg = $Button_setup
			; Setup username and password
			GuiSetState(@SW_DISABLE, $SimpleGUI)
			SetupGUI()
			GuiSetState(@SW_ENABLE, $SimpleGUI)
			If FileExists($cookies) Then
				GUICtrlSetState($Button_get, $GUI_ENABLE)
				GUICtrlSetState($Button_verify, $GUI_ENABLE)
			EndIf
		Case $msg = $Button_log
			; Log Record
			If FileExists($logfle) Then ShellExecute($logfle)
		Case $msg = $Button_info
			; Program Information
			If $prog = "gogrepo.py" Then
				$required = "Python needs to be installed on your PC." & @LF & _
					"Python needs to have the html5lib (etc) installed." & @LF & _
					"If installing manually html2text is optional but advised." & @LF & _
					"If using Kalanyr's forked version of gogrepo.py, then some other" & @LF & _
					"Python libraries are required, and installed from SETUP window." & @LF
				$thanks = "BIG THANKS to those responsible for 'gogrepo.py' versions" & @LF & _
					"(woolymethodman, Kalanyr, etc)." & @LF & @LF
			Else
				$required = ""
				$thanks = "BIG THANKS to those responsible for original 'gogrepo.py'" & @LF & _
					"(woolymethodman, etc), which I compiled to 'gogrepo.exe'." & @LF & @LF
			EndIf
			$ans = MsgBox(262209 + 256, "Program Information", _
				"This program is a limited frontend GUI for 'gogrepo.py' (Python)" & @LF & _
				"program that can get manifest detail from your GOG.com games" & @LF & _
				"library, to verify the integrity of specified game files." & @LF & @LF & _
				"GOGRepo Simple GUI program is totally reliant on 'gogrepo.py'," & @LF & _
				"for game detail, but has some handy abilities of its own, when it" & @LF & _
				"comes to verifying your downloaded GOG game file types, etc." & @LF & @LF & _
				"Before starting with GOGRepo Simple GUI, you need a cookie file," & @LF & _
				"which can be created, if you haven't got one, via SETUP button." & @LF & @LF & _
				"REQUIREMENTS" & @LF & _
				"------------------" & @LF & $required & _
				"The " & $prog & " file needs to be located in the same folder as" & @LF & _
				"GOGRepo Simple GUI. We call this the main or parent folder." & @LF & _
				"The free program 7-Zip is required for ZIP & 7Z checking, and" & @LF & _
				"needs to be located in the main folder, as a 7-Zip sub-folder." & @LF & _
				"7-Zip can also be used for EXE, BIN or SH files if MD5 is missing." & @LF & _
				"The free program UnRAR is required for RAR checking, and also" & @LF & _
				"needs to be located in the main folder, as an UnRAR sub-folder." & @LF & @LF & _
				"Click OK to see more information.", 0, $SimpleGUI)
			If $ans = 1 Then
				MsgBox(262208, "Program Information (continued)", _
					"DISCLAIMER - As always, you use my programs at your own" & @LF & _
					"risk. That said, I strive to ensure they work safe. I also cannot" & @LF & _
					"guarantee the results (or my read) of the 3rd party programs." & @LF & _
					"This is Freeware that I have voluntarily given many hours to." & @LF & @LF & _
					$thanks & _
					"Praise & BIG thanks as always, to Jon & team for free AutoIt." & @LF & @LF & _
					"© August 2020 - Created by Timboli (aka TheSaint). (" & $version & ")", 0, $SimpleGUI)
			EndIf
		Case $msg = $Button_get
			; Get game title from GOG library
			SetControlsState($GUI_DISABLE)
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
			$ret = Run(@ComSpec & ' /c ' & $prog & ' update', @ScriptDir, @SW_SHOW, $STDERR_MERGED) ;@SW_HIDE
			$pid = $ret
			$out = ""
			$results = ""
			If $script = "default" Then
				$text = "saved titles"
			Else
				$text = "saved resume manifest"
			EndIf
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
						;If StringInStr($results, "saved resume manifest") > 0 Then
						If StringInStr($results, $text) > 0 Then
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
			SetControlsState($GUI_ENABLE)
		Case $msg = $Button_fold
			; Use folder name for find
			$file = GUICtrlRead($Combo_file)
			If $file <> "" Then
				If $srcfld <> "" Then
					$srcfle = $srcfld & $file
					_PathSplit($srcfle, $drv, $dir, $fnam, $fext)
					$foldpth = StringTrimRight($drv & $dir, 1)
					_PathSplit($foldpth, $drv, $dir, $fnam, $fext)
					$fnam = StringReplace($fnam, "_", " ")
					If StringInStr($fnam, ", The ") > 0 Then
						$fnam = "The " & StringReplace($fnam, ", The ", " ")
					EndIf
					$fnam = StringStripWS($fnam, 7)
					GUICtrlSetData($Input_title, $fnam)
				EndIf
			Else
				MsgBox(262192, "Folder Error", "No source file found!", 0, $SimpleGUI)
			EndIf
		Case $msg = $Button_find
			; Find the specified game title on list
			$title = GUICtrlRead($Input_title)
			If $title <> "" Then
				GUICtrlSetData($Input_name, "")
				$find = $title
				While 1
					$ind = _GUICtrlListBox_GetCurSel($List_games)
					If GUICtrlRead($Checkbox_exact) = $GUI_CHECKED Then
						$ind = _GUICtrlListBox_SelectString($List_games, $find, $ind)
					Else
						$ind = _GUICtrlListBox_FindInText($List_games, $find, $ind, True)
					EndIf
					If $ind > -1 Then
						_GUICtrlListBox_SetCurSel($List_games, $ind)
						If _GUICtrlListBox_GetText($List_games, $ind) = $find Then
							_GUICtrlListBox_ClickItem($List_games, $ind)
							ExitLoop
						ElseIf StringLeft(_GUICtrlListBox_GetText($List_games, $ind), StringLen($find)) = $find Then
							;_GUICtrlListBox_ClickItem($List_games, $ind)
							ExitLoop
						ElseIf StringInStr(_GUICtrlListBox_GetText($List_games, $ind), $find) > 0 Then
							ExitLoop
						EndIf
					EndIf
					If StringInStr($find, " - ") > 0 And StringInStr($find, ": ") < 1 Then
						$pos = StringInStr($find, " - ")
						$find = StringLeft($find, $pos - 1) & ":" & StringMid($find, $pos + 2)
						;$find = StringReplace($find, " - ", ": ")
					ElseIf StringInStr($find, ": ") > 0 Then
						If StringInStr($find, " - ") > 0 Then
							$find = StringSplit($find, " - ", 1)
						Else
							$find = StringSplit($find, ": ", 1)
						EndIf
						$find = $find[1]
					ElseIf StringInStr($find, " ") > 0 Then
						$find = StringSplit($find, " ", 1)
						$find = $find[1]
					Else
						ExitLoop
					EndIf
				WEnd
			EndIf
		Case $msg = $Checkbox_update
			; Update selected game title detail
			If GUICtrlRead($Checkbox_update) = $GUI_CHECKED Then
				$update = 1
			Else
				$update = 4
			EndIf
		Case $msg = $Label_title
			; Click to restore last search text to Title input field
			GUICtrlSetData($Input_title, $find)
		Case $msg = $Label_file
			; Click to find nearest Title beginning with first word
			$file = GUICtrlRead($Combo_file)
			If $file <> "" Then
				If $srcfld <> "" Then
					$srcfle = $srcfld & $file
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
				EndIf
			Else
				$srcfle = IniRead($inifle, "Last File", "path", "")
				_PathSplit($srcfle, $drv, $dir, $fnam, $fext)
				$srcfld = $drv & $dir
				$file = $fnam & $fext
				GUICtrlSetData($Combo_file, $file)
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

Func SetupGUI()
	; Script generated by GUIBuilder Prototype 0.9
	Local $Button_attach, $Button_close, $Button_cookie, $Button_install, $Combo_lang, $Combo_langs, $Combo_OS
	Local $Group_lang, $Input_pass, $Input_user, $Label_info, $Label_lang, $Label_langs, $Label_pass, $Label_user
	;
	Local $above, $combos, $high, $langs, $long, $OSes, $password, $side, $titval, $username, $wide
	;
	$wide = 235
	If $prog = "gogrepo.py" Then
		$high = 430
	Else
		$high = 350
	EndIf
	$val = $high - $height
	$side = IniRead($inifle, "Setup Window", "left", $left)
	$above = IniRead($inifle, "Setup Window", "top", $top - $val)
	If $prog = "gogrepo.py" Then
		$titval = "Setup - Python & Cookie etc"
	Else
		$titval = "Setup - Cookie etc"
	EndIf
	$SetupGUI = GuiCreate($titval, $wide, $high, $side, $above, $WS_OVERLAPPED + $WS_CAPTION _
										+ $WS_SYSMENU + $WS_VISIBLE + $WS_CLIPSIBLINGS, $WS_EX_TOPMOST, $SimpleGUI)
	GUISetBkColor(0xFFFFB0, $SetupGUI)
	;
	; CONTROLS
	If $prog = "gogrepo.py" Then
		$Label_info = GuiCtrlCreateLabel("Before using gogrepo.py to interact with your" _
			& @LF & "GOG game library, you will need a cookie file." _
			& @LF & "You also need html5lib etc installed in Python." _
			& @LF & "Both those require an active web connection." & @LF _
			& @LF & "Please supply your GOG username (or email)" _
			& @LF & "and password, to have it create a cookie file" _
			& @LF & "to use with GOG. Install Python etc first." & @LF _
			& @LF & "GOGRepo GUI does not store that detail.", 11, 10, 215, 130)
	Else
		$Label_info = GuiCtrlCreateLabel("Prior using gogrepo.exe to interact with your" _
			& @LF & "GOG game library, you will need a cookie file." _
			& @LF & "That will require an active web connection." & @LF _
			& @LF & "Please supply your GOG username (or email)" _
			& @LF & "and password, to have it create a cookie file" _
			& @LF & "to use with GOG. That detail is not stored.", 11, 10, 215, 90)
	EndIf
	;
	If $prog = "gogrepo.py" Then
		$Button_install = GuiCtrlCreateButton("INSTALL Required Libraries", 10, 150, 215, 35)
		GUICtrlSetTip($Button_install, "Install html5lib, requests, pyopenssl & html2text in Python!")
		GUICtrlSetFont($Button_install, 9, 600)
	EndIf
	;
	$Group_lang = GuiCtrlCreateGroup("Language(s) - Select One Option", 10, $high - 236, 215, 53)
	$Label_lang = GuiCtrlCreateLabel("User", 20, $high - 216, 37, 21, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_lang, $COLOR_BLUE)
	GUICtrlSetColor($Label_lang, $COLOR_WHITE)
	GUICtrlSetFont($Label_lang, 7, 600, 0, "Small Fonts")
	$Combo_lang = GUICtrlCreateCombo("", 57, $high - 216, 34, 21)
	GUICtrlSetTip($Combo_lang, "User language!")
	$Label_langs = GuiCtrlCreateLabel("Multi", 96, $high - 216, 39, 21, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_langs, $COLOR_BLUE)
	GUICtrlSetColor($Label_langs, $COLOR_WHITE)
	GUICtrlSetFont($Label_langs, 7, 600, 0, "Small Fonts")
	$Combo_langs = GUICtrlCreateCombo("", 135, $high - 216, 50, 21)
	GUICtrlSetTip($Combo_langs, "Multiple languages!")
	$Button_attach = GuiCtrlCreateButton("+", 190, $high - 216, 25, 20)
	GUICtrlSetFont($Button_attach, 9, 600)
	GUICtrlSetTip($Button_attach, "Add a single language or combination (with CTRL to remove)!")
	;
	$Group_OS = GuiCtrlCreateGroup("", 10, $high - 177, 215, 50)
	$Label_OS = GuiCtrlCreateLabel("OS Options", 20, $high - 160, 73, 21, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_OS, $COLOR_BLUE)
	GUICtrlSetColor($Label_OS, $COLOR_WHITE)
	GUICtrlSetFont($Label_OS, 7, 600, 0, "Small Fonts")
	$Combo_OS = GUICtrlCreateCombo("", 93, $high - 160, 122, 21)
	GUICtrlSetBkColor($Combo_OS, 0xFFD5FF)
	GUICtrlSetTip($Combo_OS, "OS to download files for!")
	;
	$Label_user = GuiCtrlCreateLabel("User or Email", 10, $high - 115, 80, 20, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_user, $COLOR_BLACK)
	GUICtrlSetColor($Label_user, $COLOR_WHITE)
	GUICtrlSetFont($Label_user, 7, 600, 0, "Small Fonts")
	$Input_user = GuiCtrlCreateInput("", 90, $high - 115, 135, 20)
	GUICtrlSetTip($Input_user, "Username or Email to access your GOG game library!")
	;
	$Label_pass = GuiCtrlCreateLabel("Password", 10, $high - 90, 63, 20, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_pass, $COLOR_BLACK)
	GUICtrlSetColor($Label_pass, $COLOR_WHITE)
	GUICtrlSetFont($Label_pass, 7, 600, 0, "Small Fonts")
	$Input_pass = GuiCtrlCreateInput("", 73, $high - 90, 152, 20)
	GUICtrlSetTip($Input_pass, "Password to access your GOG game library!")
	;
	$Button_cookie = GuiCtrlCreateButton("CREATE COOKIE", 10, $high - 60, 145, 50)
	GUICtrlSetFont($Button_cookie, 9, 600)
	GUICtrlSetTip($Button_cookie, "Create or Update the cookie file!")
	;
	$Button_close = GuiCtrlCreateButton("EXIT", 165, $high - 60, 60, 50, $BS_ICON)
	GUICtrlSetTip($Button_close, "Exit / Close / Quit the window!")
	;
	; SETTINGS
	GUICtrlSetImage($Button_close, $user, $icoX, 1)
	;
	$langs = IniRead($inifle, "Update Languages", "singles", "")
	If $langs = "" Then
		$langs = "||de|en|fr|"
		IniWrite($inifle, "Update Languages", "singles", $langs)
	EndIf
	$combos = IniRead($inifle, "Update Languages", "combined", "")
	If $combos = "" Then
		$combos = "||de en|de fr|fr en|"
		IniWrite($inifle, "Update Languages", "combined", $combos)
	EndIf
	$long = StringLen($lang)
	If $long = 2 Then
		GUICtrlSetData($Combo_lang, $langs, $lang)
		GUICtrlSetData($Combo_langs, $combos, "")
	Else
		GUICtrlSetData($Combo_lang, $langs, "")
		GUICtrlSetData($Combo_langs, $combos, $lang)
	EndIf
	;
	$OSes = "windows linux mac|windows linux|windows mac|linux mac|windows|linux|mac"
	GUICtrlSetData($Combo_OS, $OSes, $OSget)


	GuiSetState(@SW_SHOW, $SetupGUI)
	While 1
		$msg = GuiGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Button_close
			; Exit / Close / Quit the window
			$winpos = WinGetPos($SetupGUI, "")
			$side = $winpos[0]
			If $side < 0 Then
				$side = 2
			ElseIf $side > @DesktopWidth - $wide Then
				$side = @DesktopWidth - $wide - 25
			EndIf
			IniWrite($inifle, "Setup Window", "left", $side)
			$above = $winpos[1]
			If $above < 0 Then
				$above = 2
			ElseIf $above > @DesktopHeight - $high Then
				$above = @DesktopHeight - $high - 30
			EndIf
			IniWrite($inifle, "Setup Window", "top", $above)
			;
			GUIDelete($SetupGUI)
			ExitLoop
		Case $msg = $Button_install And $prog = "gogrepo.py"
			; Install html5lib & html2text etc in Python
			GuiSetState(@SW_DISABLE, $SetupGUI)
			RunWait(@ComSpec & ' /c pip install html5lib html2text requests pyopenssl &&pause', "")
			GuiSetState(@SW_ENABLE, $SetupGUI)
		Case $msg = $Button_cookie
			; Create or Update the cookie file
			If FileExists($gogrepo) Then
				If FileExists($cookies) Then
					$ans = MsgBox(262177, "Update Query", _
						"An existing cookie file was found." & @LF & @LF & _
						"Do you want to update (overwrite)?", 0, $SetupGUI)
				Else
					$ans = 1
				EndIf
				If $ans = 1 Then
					$username = GUICtrlRead($Input_user)
					If $username <> "" Then
						$password = GUICtrlRead($Input_pass)
						If $password <> "" Then
							GuiSetState(@SW_DISABLE, $SetupGUI)
							RunWait(@ComSpec & ' /c ' & $prog & ' login ' & $username & ' ' & $password & ' &&pause', @ScriptDir)
							$username = ""
							$password = ""
							GuiSetState(@SW_ENABLE, $SetupGUI)
						Else
							MsgBox(262192, "Cookie Error", "Password field is blank!", 0, $SetupGUI)
						EndIf
					Else
						MsgBox(262192, "Cookie Error", "User or Email field is blank!", 0, $SetupGUI)
					EndIf
				EndIf
			Else
				MsgBox(262192, "Program Error", "Required file '" & $prog & "' not found!", 0, $SetupGUI)
			EndIf
		Case $msg = $Button_attach
			; Add a single language or combination
			$val = GUICtrlRead($Combo_langs)
			If $val <> "" And GUICtrlRead($Combo_lang) <> "" Then
				MsgBox(262192, "Add Error", _
					"When adding a new language or combined language entry," & @LF & _
					"the other field should be blank, and you should have typed" & @LF & _
					"over the entry in the field you want to add to." & @LF & @LF & _
					"Try Again!", 0, $SetupGUI)
				ContinueLoop
			EndIf
			$long = StringLen($val)
			If $long > 3 Then
				$lang = $val
				If _IsPressed("11") Then
					If $lang <> "de en" Then
						If StringInStr($combos, "|" & $lang & "|") > 0 Then
							$combos = StringReplace($combos, "|" & $lang & "|", "|")
							IniWrite($inifle, "Update Languages", "combined", $combos)
							GUICtrlSetData($Combo_langs, "", "")
							$lang = "de en"
							GUICtrlSetData($Combo_langs, $combos, $lang)
						EndIf
					EndIf
				Else
					If StringInStr($combos, "|" & $lang & "|") < 1 Then
						$combos = $combos & $lang & "|"
						IniWrite($inifle, "Update Languages", "combined", $combos)
						GUICtrlSetData($Combo_langs, "", "")
						GUICtrlSetData($Combo_langs, $combos, $lang)
					EndIf
				EndIf
			Else
				$val = GUICtrlRead($Combo_lang)
				$long = StringLen($val)
				If $long = 2 Then
					$lang = $val
					If _IsPressed("11") Then
						If $lang <> "en" Then
							If StringInStr($langs, "|" & $lang & "|") > 0 Then
								$langs = StringReplace($langs, "|" & $lang & "|", "|")
								IniWrite($inifle, "Update Languages", "singles", $langs)
								GUICtrlSetData($Combo_lang, "", "")
								$lang = "en"
								GUICtrlSetData($Combo_lang, $langs, $lang)
							EndIf
						EndIf
					Else
						If StringInStr($langs, "|" & $lang & "|") < 1 Then
							$langs = $langs & $lang & "|"
							IniWrite($inifle, "Update Languages", "singles", $langs)
							GUICtrlSetData($Combo_lang, "", "")
							GUICtrlSetData($Combo_lang, $langs, $lang)
						EndIf
					EndIf
				Else
					MsgBox(262208, "Program Advice", "To remove a language or combined language entry," _
						& @LF & "hold down CTRL while clicking the plus button.", 0, $SetupGUI)
				EndIf
			EndIf
			IniWrite($inifle, "Update Options", "language", $lang)
		Case $msg = $Combo_OS
			; OS to update files for
			$OSget = GUICtrlRead($Combo_OS)
			IniWrite($inifle, "Update Options", "OS", $OSget)
		Case $msg = $Combo_langs
			; Multiple languages
			$val = GUICtrlRead($Combo_langs)
			If $val = "" Then
				_GUICtrlComboBox_SetCurSel($Combo_lang, 1)
				$lang = GUICtrlRead($Combo_lang)
			Else
				_GUICtrlComboBox_SetCurSel($Combo_lang, 0)
				$lang = $val
			EndIf
			IniWrite($inifle, "Update Options", "language", $lang)
		Case $msg = $Combo_lang
			; User language
			$val = GUICtrlRead($Combo_lang)
			If $val = "" Then
				_GUICtrlComboBox_SetCurSel($Combo_langs, 1)
				$lang = GUICtrlRead($Combo_langs)
			Else
				_GUICtrlComboBox_SetCurSel($Combo_langs, 0)
				$lang = $val
			EndIf
			IniWrite($inifle, "Update Options", "language", $lang)
		Case Else
			;;;
		EndSelect
	WEnd
EndFunc ;=> SetupGUI


Func AddFileToCombo($add, $filepth)
	GUICtrlSetData($Combo_file, "", "")
	If $add = 1 Then
		If $files = "" Then
			$found = ""
			$files = $filepth
		Else
			$files = $files & "|" & $filepth
		EndIf
		GUICtrlSetData($Combo_file, $files, $filepth)
		If $found = "" Then
			$srcfle = $srcfld & $filepth
			DetermineFindText()
			If StringRight($filepth, 4) = ".exe" Then $found = 1
		EndIf
	Else
		GUICtrlSetData($Combo_file, $filepth, $filepth)
		$srcfle = $srcfld & $filepth
		IniWrite($inifle, "Last File", "path", $srcfle)
		DetermineFindText()
	EndIf
	GUICtrlSetData($Input_name, "")
	If GUICtrlRead($Label_status) <> "Waiting" Then
		GUICtrlSetData($Label_status, "Waiting")
		GUICtrlSetBkColor($Label_status, $COLOR_BLUE)
		GUICtrlSetColor($Label_status, $COLOR_WHITE)
		GUICtrlSetFont($Label_status, 9, 600)
	EndIf
EndFunc ;=> AddFileToCombo

Func DetermineFindText()
	$property = _GetExtProperty($srcfle, 34)
	If $property = "" Then
		$file = StringSplit($srcfle, "\", 1)
		$file = $file[$file[0]]
		$file = StringSplit($file, "_", 1)
		$find = $file[1]
		If $find = "gog" Or $find = "setup" Or $find = "patch" Then
			$find = $file[2]
			If $find = "the" Or $find = "a" Then
				$find = $find & " " & $file[3]
			EndIf
		ElseIf $find = "the" Or $find = "a" Then
			$find = $find & " " & $file[2]
		EndIf
	Else
		$find = StringReplace($property, " setup", "")
	EndIf
	GUICtrlSetData($Input_title, $find)
EndFunc ;=> DetermineFindText

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

Func GetTheSize($size)
	If $size < 1024 Then
		$size = $size & " bytes"
	ElseIf $size < 1048576 Then
		$size = $size / 1024
		$size =  Round($size) & " Kb"
	ElseIf $size < 1073741824 Then
		$size = $size / 1048576
		$size =  Round($size) & " Mb"
	ElseIf $size < 1099511627776 Then
		$size = $size / 1073741824
		$size = Round($size, 2) & " Gb"
	Else
		$size = $size / 1099511627776
		$size = Round($size, 3) & " Tb"
	EndIf
	Return $size
EndFunc ;=> GetTheSize

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

Func SetControlsState($state)
	GUICtrlSetState($Combo_file, $state)
	GUICtrlSetState($List_games, $state)
	GUICtrlSetState($Input_name, $state)
	GUICtrlSetState($Input_title, $state)
	GUICtrlSetState($Button_find, $state)
	GUICtrlSetState($Checkbox_exact, $state)
	GUICtrlSetState($Button_fold, $state)
	GUICtrlSetState($Button_get, $state)
	GUICtrlSetState($Button_verify, $state)
	GUICtrlSetState($Button_log, $state)
	GUICtrlSetState($Checkbox_update, $state)
	GUICtrlSetState($Button_setup, $state)
	GUICtrlSetState($Button_info, $state)
	GUICtrlSetState($Button_exit, $state)
EndFunc ;=> SetControlsState


; Provided by Lazycat, June 23, 2006 in AutoIt Example Scripts (Drop multiple files on any control)
Func WM_DROPFILES_FUNC($hWnd, $msgID, $wParam, $lParam)
    Local $nSize, $pFileName, $i
    Local $nAmt = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", 0xFFFFFFFF, "ptr", 0, "int", 255)
    For $i = 0 To $nAmt[0] - 1
        $nSize = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", 0, "int", 0)
        $nSize = $nSize[0] + 1
        $pFileName = DllStructCreate("char[" & $nSize & "]")
        DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", DllStructGetPtr($pFileName), "int", $nSize)
        ReDim $gaDropFiles[$i+1]
        $gaDropFiles[$i] = DllStructGetData($pFileName, 1)
        $pFileName = 0
    Next
	If IsArray($gaDropFiles) Then
		_ArraySort($gaDropFiles, 0, 0)
	EndIf
EndFunc ;=> WM_DROPFILES_FUNC
