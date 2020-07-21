;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                                       ;;
;;  AutoIt Version: 3.3.14.2                                                             ;;
;;                                                                                       ;;
;;  Template AutoIt script.                                                              ;;
;;                                                                                       ;;
;;  AUTHOR:  Timboli                                                                     ;;
;;                                                                                       ;;
;;  SCRIPT FUNCTION:  A limited GUI frontend for gogrepo.py                              ;;
;;                                                                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; FUNCTIONS
; DownloadGUI(), MainGUI(), QueueGUI(), SetupGUI(), UpdateGUI(), VerifyGUI()
; CheckIfPythonRunning(), CheckOnGameDownload(), CheckOnShutdown(), ClearDisableEnableRestore()
; DisableQueueButtons(), EnableDisableControls($state), FillTheGamesList(), GetWindowPosition()
; ParseTheManifest(), RemoveListEntry($num)

#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <ListBoxConstants.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <GuiListBox.au3>
#include <GuiComboBox.au3>
#include <Misc.au3>
#include <File.au3>
#include <Date.au3>
#include <Array.au3>

_Singleton("gog-repo-gui-timboli")

Global $Button_add, $Button_dest, $Button_down, $Button_edit, $Button_exit, $Button_fix, $Button_fold, $Button_info
Global $Button_log, $Button_more, $Button_move, $Button_movedown, $Button_moveup, $Button_pic, $Button_queue
Global $Button_removall, $Button_remove, $Button_setup, $Button_start, $Button_stop, $Checkbox_all, $Checkbox_alpha
Global $Checkbox_check, $Checkbox_cover, $Checkbox_extra, $Checkbox_files, $Checkbox_game, $Checkbox_image
Global $Checkbox_linux, $Checkbox_other, $Checkbox_show, $Checkbox_test, $Checkbox_update, $Checkbox_verify
Global $Checkbox_win, $Combo_dest, $Combo_OS, $Combo_shutdown, $Group_done, $Group_download, $Group_games
Global $Group_waiting, $Input_dest, $Input_destination, $Input_download, $Input_extra, $Input_lang, $Input_langs
Global $Input_name, $Input_OP, $Input_OS, $Input_title, $List_done, $List_games, $List_waiting, $Pic_cover, $Progress_bar
;
Global $a, $all, $alpha, $ans, $array, $auto, $bigpic, $blackjpg, $c, $check, $chunk, $chunks, $cookies, $cover
Global $date, $delay, $downlist, $DownloadGUI, $extras, $fdate, $file, $files, $flag, $game, $gamefold, $gamepic
Global $games, $gamesfle, $gogrepo, $GOGRepoGUI, $height, $icoD, $icoF, $icoI, $icoT, $icoX, $image, $imgfle, $ind
Global $infofle, $inifle, $lang, $left, $let, $line, $lines, $logfle, $manifest, $minimize, $name, $num, $open
Global $OS, $OSget, $pid, $QueueGUI, $read, $res, $segment, $SetupGUI, $shell, $shutdown, $split, $started, $state
Global $stop, $style, $t, $text, $textdump, $threads, $title, $titles, $titlist, $top, $tot, $UpdateGUI, $updating
Global $user, $val, $validate, $VerifyGUI, $verifying, $version, $wait, $width, $window, $winpos, $xpos, $ypos

$bigpic = @ScriptDir & "\Big.jpg"
$blackjpg = @ScriptDir & "\Black.jpg"
$cookies = @ScriptDir & "\gog-cookies.dat"
$downlist = @ScriptDir & "\Downloads.ini"
$gamesfle = @ScriptDir & "\Games.ini"
$gogrepo = @ScriptDir & "\gogrepo.py"
$imgfle = @ScriptDir & "\Image.jpg"
$infofle = @ScriptDir & "\Game Info.html"
$inifle = @ScriptDir & "\Settings.ini"
$logfle = @ScriptDir & "\Record.log"
$manifest = @ScriptDir & "\gog-manifest.dat"
$titlist = @ScriptDir & "\Titles.txt"
$version = "v1.0"

If Not FileExists($titlist) Then _FileCreate($titlist)

If FileExists($titlist) Then
	$lines = _FileCountLines($titlist)
	If $lines = 0 Then
		ParseTheManifest()
	EndIf
	MainGUI()
Else
	;
EndIf

Exit

Func MainGUI()
	Local $Group_cover, $Group_dest, $Group_down, $Group_update, $Label_cover, $Label_extra, $Label_OS, $Label_title
	;
	Local $add, $dll, $exist, $gamesfold, $mpos, $OSes, $pth, $show, $update, $verify
	;
	$width = 590
	$height = 405
	$left = IniRead($inifle, "Program Window", "left", @DesktopWidth - $width - 25)
	$top = IniRead($inifle, "Program Window", "top", @DesktopHeight - $height - 30)
	$style = $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU + $WS_VISIBLE + $WS_CLIPSIBLINGS + $WS_MINIMIZEBOX
	$GOGRepoGUI = GuiCreate("GOGRepo GUI", $width, $height, $left, $top, $style, $WS_EX_TOPMOST)
	GUISetBkColor($COLOR_SKYBLUE, $GOGRepoGUI)
	GuiSetState(@SW_DISABLE, $GOGRepoGUI)
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
	GUICtrlSetTip($Label_title, "Click to convert text in input field!")
	$Input_title = GUICtrlCreateInput("", 58, 275, 275, 20) ;, $ES_READONLY
	GUICtrlSetBkColor($Input_title, 0xBBFFBB)
	GUICtrlSetTip($Input_title, "Game Title!")
	$Button_fix = GuiCtrlCreateButton("FIX", 335, 274, 35, 22)
	GUICtrlSetFont($Button_fix, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_fix, "Click to convert text in input field!")
	$Label_OS = GuiCtrlCreateLabel("OS", 20, 300, 30, 20, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_OS, $COLOR_BLACK)
	GUICtrlSetColor($Label_OS, $COLOR_WHITE)
	GUICtrlSetFont($Label_OS, 7, 600, 0, "Small Fonts")
	$Input_OS = GUICtrlCreateInput("", 50, 300, 130, 20, $ES_READONLY)
	GUICtrlSetBkColor($Input_OS, 0xBBFFBB)
	GUICtrlSetTip($Input_OS, "OS files available!")
	$Label_extra = GuiCtrlCreateLabel("Extras", 190, 300, 50, 20, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_extra, $COLOR_MAROON)
	GUICtrlSetColor($Label_extra, $COLOR_WHITE)
	GUICtrlSetFont($Label_extra, 7, 600, 0, "Small Fonts")
	$Input_extra = GUICtrlCreateInput("", 240, 300, 70, 20, $ES_READONLY)
	GUICtrlSetBkColor($Input_extra, 0xBBFFBB)
	GUICtrlSetTip($Input_extra, "Extra files available!")
	$Button_more = GuiCtrlCreateButton("More", 320, 299, 50, 22)
	GUICtrlSetFont($Button_more, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_more, "View more information from manifest!")
	;
	$Group_cover = GuiCtrlCreateGroup("Cover", 390, 10, 190, 160)
	$Pic_cover = GUICtrlCreatePic($blackjpg, 400, 30, 170, 100, $SS_NOTIFY)
	GUICtrlSetTip($Pic_cover, "Game cover image (click to enlarge)!")
	$Label_cover = GuiCtrlCreateLabel("", 410, 70, 150, 20, $SS_CENTER + $SS_CENTERIMAGE)
	GUICtrlSetBkColor($Label_cover, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor($Label_cover, $COLOR_WHITE)
	$Button_pic = GuiCtrlCreateButton("Download Cover", 400, 135, 120, 25)
	GUICtrlSetFont($Button_pic, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_pic, "Download the selected image!")
	$Checkbox_show = GUICtrlCreateCheckbox("Show", 525, 138, 45, 20)
	GUICtrlSetTip($Checkbox_show, "Show the cover image!")
	;
	$Group_down = GuiCtrlCreateGroup("", 450, 175, 70, 51)
	$Button_down = GuiCtrlCreateButton("Down" & @LF & "One", 390, 180, 67, 48, $BS_MULTILINE)
	GUICtrlSetFont($Button_down, 9, 600)
	GUICtrlSetTip($Button_down, "Download the selected game!")
	$Checkbox_update = GUICtrlCreateCheckbox("Update", 461, 186, 50, 18)
	GUICtrlSetFont($Checkbox_update, 8, 400)
	GUICtrlSetTip($Checkbox_update, "Enable updating one or all games!")
	$Checkbox_verify = GUICtrlCreateCheckbox("Verify", 461, 204, 45, 18)
	GUICtrlSetFont($Checkbox_verify, 8, 400)
	GUICtrlSetTip($Checkbox_verify, "Enable verifying one or all games!")
	;
	$Group_all = GuiCtrlCreateGroup("Games", 530, 180, 50, 46)
	GUICtrlSetFont($Group_all, 7, 400, 0, "Small Fonts")
	$Checkbox_all = GUICtrlCreateCheckbox("ALL", 538, 197, 32, 20)
	GUICtrlSetFont($Checkbox_all, 7, 400, 0, "Small Fonts")
	GUICtrlSetTip($Checkbox_all, "Process one or ALL games!")
	;
	$Group_opts = GuiCtrlCreateGroup("Download Options", 390, 233, 130, 107)
	$Combo_OS = GUICtrlCreateCombo("", 400, 249, 110, 21)
	GUICtrlSetBkColor($Combo_OS, 0xFFD5FF)
	GUICtrlSetTip($Combo_OS, "OS to download files for!")
	$Checkbox_test = GUICtrlCreateCheckbox("Validate", 400, 273, 55, 20)
	GUICtrlSetTip($Checkbox_test, "Verify integrity of downloaded files!")
	$Checkbox_extra = GUICtrlCreateCheckbox("Extras", 463, 273, 55, 21)
	GUICtrlSetTip($Checkbox_extra, "Download game extras files!")
	$Checkbox_cover = GUICtrlCreateCheckbox("Download the cover", 400, 293, 115, 20)
	GUICtrlSetFont($Checkbox_cover, 8, 400)
	GUICtrlSetTip($Checkbox_cover, "Download the cover image files!")
	$Checkbox_game = GUICtrlCreateCheckbox("Game Files", 400, 313, 70, 20)
	GUICtrlSetTip($Checkbox_game, "Download the game files!")
	$Input_langs = GUICtrlCreateInput("", 475, 313, 35, 18, $ES_READONLY)
	GUICtrlSetBkColor($Input_langs, 0xFFD5FF)
	GUICtrlSetFont($Input_langs, 9, 400, 0, "MS Serif")
	GUICtrlSetTip($Input_langs, "Download language(s)!")
	;
	$Group_dest = GuiCtrlCreateGroup("Download Destination - Games Folder", 10, $height - 63, 370, 52)
	$Combo_dest = GUICtrlCreateCombo("", 20, $height - 43, 63, 21)
	GUICtrlSetBkColor($Combo_dest, 0xFFFFB0)
	GUICtrlSetTip($Combo_dest, "Type of download location!")
	$Input_dest = GUICtrlCreateInput("", 88, $height - 43, 127, 21)
	;GUICtrlSetBkColor($Input_dest, 0xFFFFB0)
	GUICtrlSetTip($Input_dest, "Destination path (main parent folder for games)!")
	$Button_dest = GuiCtrlCreateButton("B", 220, $height - 43, 20, 21, $BS_ICON)
	GUICtrlSetTip($Button_dest, "Browse to set the destination folder!")
	$Checkbox_alpha = GUICtrlCreateCheckbox("Alpha", 245, $height - 43, 45, 21)
	GUICtrlSetTip($Checkbox_alpha, "Create alphanumeric sub-folder!")
	$Button_fold = GuiCtrlCreateButton("Open", 295, $height - 44, 23, 22, $BS_ICON)
	GUICtrlSetTip($Button_fold, "Open the selected destination folder!")
	$Button_move = GuiCtrlCreateButton("Move", 321, $height - 44, 49, 22)
	GUICtrlSetFont($Button_move, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_move, "Relocate game files!")
	;
	$Button_queue = GuiCtrlCreateButton("VIEW" & @LF & "QUEUE", $width - 200, $height - 55, 62, 45, $BS_MULTILINE)
	GUICtrlSetFont($Button_queue, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_queue, "View the download queue!")
	;
	$Button_setup = GuiCtrlCreateButton("SETUP", $width - 129, $height - 55, 60, 45)
	GUICtrlSetFont($Button_setup, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_setup, "Setup username and password!")
	;
	$Button_log = GuiCtrlCreateButton("LOG", $width - 60, $height - 169, 50, 43)
	GUICtrlSetFont($Button_log, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_log, "View the record log file!")
	;
	$Button_info = GuiCtrlCreateButton("Info", $width - 60, $height - 118, 50, 50, $BS_ICON)
	GUICtrlSetTip($Button_info, "Program Information!")
	;
	$Button_exit = GuiCtrlCreateButton("EXIT", $width - 60, $height - 60, 50, 50, $BS_ICON)
	GUICtrlSetTip($Button_exit, "Exit / Close / Quit the program!")
	;
	; OS SETTINGS
	$user = @SystemDir & "\user32.dll"
	$shell = @SystemDir & "\shell32.dll"
	$icoD = -4
	$icoF = -85
	$icoI = -5
	$icoT = -71
	$icoX = -4
	GUICtrlSetImage($Button_dest, $shell, $icoF, 0)
	GUICtrlSetImage($Button_fold, $shell, $icoD, 0)
	GUICtrlSetImage($Button_info, $user, $icoI, 1)
	GUICtrlSetImage($Button_exit, $user, $icoX, 1)
	;
	; SETTINGS
	If Not FileExists($cookies) Then
		GUICtrlSetState($Button_down, $GUI_DISABLE)
	EndIf
	If Not FileExists($manifest) Then
		GUICtrlSetState($Button_more, $GUI_DISABLE)
		GUICtrlSetState($Button_pic, $GUI_DISABLE)
	EndIf
	;
	$shutdown = IniRead($inifle, "Shutdown", "use", "")
	If $shutdown = "" Then
		$shutdown = "none"
		IniWrite($inifle, "Shutdown", "use", $shutdown)
	EndIf
	If $shutdown <> "none" Then
		WinSetTitle($GOGRepoGUI, "", "GOGRepo GUI - " & $shutdown & " is ENABLED")
	EndIf
	;
	$show = IniRead($inifle, "Cover Image", "show", "")
	If $show = "" Then
		$show = 1
		IniWrite($inifle, "Cover Image", "show", $show)
	EndIf
	GUICtrlSetState($Checkbox_show, $show)
	;
	$OSes = "Windows + Linux|Windows + Mac|Linux + Mac|Windows|Linux|Mac|Every OS"
	$OSget = IniRead($inifle, "Download Options", "OS", "")
	If $OSget = "" Then
		$OSget = "Windows + Linux"
		IniWrite($inifle, "Download Options", "OS", $OSget)
	EndIf
	GUICtrlSetData($Combo_OS, $OSes, $OSget)
	;
	$extras = IniRead($inifle, "Download Options", "extras", "")
	If $extras = "" Then
		$extras = 1
		IniWrite($inifle, "Download Options", "extras", $extras)
	EndIf
	GUICtrlSetState($Checkbox_extra, $extras)
	;
	$validate = IniRead($inifle, "Download Options", "verify", "")
	If $validate = "" Then
		$validate = 1
		IniWrite($inifle, "Download Options", "verify", $validate)
	EndIf
	GUICtrlSetState($Checkbox_test, $validate)
	;
	$cover = IniRead($inifle, "Download Options", "cover", "")
	If $cover = "" Then
		$cover = 1
		IniWrite($inifle, "Download Options", "cover", $cover)
	EndIf
	GUICtrlSetState($Checkbox_cover, $cover)
	;
	$files = IniRead($inifle, "Download Options", "files", "")
	If $files = "" Then
		$files = 1
		IniWrite($inifle, "Download Options", "files", $files)
	EndIf
	GUICtrlSetState($Checkbox_game, $files)
	;
	$dests = "Default|Specific"
	GUICtrlSetData($Combo_dest, $dests, "Default")
	$gamesfold = IniRead($inifle, "Main Games Folder", "path", "")
	If $gamesfold = "" Then
		$gamesfold = @ScriptDir & "\GAMES"
		IniWrite($inifle, "Main Games Folder", "path", $gamesfold)
		If Not FileExists($gamesfold) Then DirCreate($gamesfold)
	EndIf
	GUICtrlSetData($Input_dest, $gamesfold)
	$alpha = IniRead($inifle, "Alphanumerical Game Folders", "use", "")
	If $alpha = "" Then
		$alpha = 4
		IniWrite($inifle, "Alphanumerical Game Folders", "use", $alpha)
	EndIf
	GUICtrlSetState($Checkbox_alpha, $alpha)
	;
	$auto = IniRead($inifle, "Start Downloading", "auto", "")
	If $auto = "" Then
		$auto = 4
		IniWrite($inifle, "Start Downloading", "auto", $auto)
	EndIf
	;
	$lang = IniRead($inifle, "Download Options", "language", "")
	If $lang = "" Then
		$lang = "en"
		$val = InputBox("Language Query", "Please enter the two character" _
			& @LF & "code for your language ... plus" _
			& @LF & "any other languages you wish" _
			& @LF & "to download for, using a space" _
			& @LF & "as divider between." & @LF _
			& @LF & "i.e. de en fr", _
			$lang, "", 100, 205, Default, Default, 0, $GOGRepoGUI)
		If Not @error Then
			$lang = $val
		EndIf
		IniWrite($inifle, "Download Options", "language", $lang)
	EndIf
	GUICtrlSetData($Input_langs, $lang)
	;
	If FileExists($gogrepo) Then
		$fdate = IniRead($inifle, "gogrepo.py", "file_date", "")
		If $fdate = "" Then
			SplashTextOn("", "Please Wait!", 200, 120, Default, Default, 33)
			$file = FileOpen($gogrepo, 0)
			$read = FileRead($file)
			FileClose($file)
			$chunk = StringSplit($read, "HTTP_GAME_DOWNLOADER_THREADS = ", 1)
			If $chunk[0] > 1 Then
				$chunk = $chunk[2]
				;MsgBox(262192, "Threads Check", $chunk, 0, $GOGRepoGUI)
				$chunk = StringSplit($chunk, @LF, 1)
				$chunk = $chunk[1]
				$chunk = StringStripWS($chunk, 8)
				;MsgBox(262192, "Threads Check 1", $chunk, 0, $GOGRepoGUI)
				If StringIsDigit($chunk) Then
					$threads = $chunk
				Else
					$threads = ""
				EndIf
			EndIf
			SplashOff()
			;MsgBox(262192, "Threads Check 2", $threads, 0, $GOGRepoGUI)
			;Exit
			If $threads <> "" And $threads <> 1 Then
				$ans = MsgBox(262177, "Threads Query", _
					"By default, 'gogrepo.py' is set to use '" & $threads & "' threads." & @LF & @LF & _
					"Do you want to change it to '1' thread?" & @LF & @LF & _
					"NOTE -  This is the number of threads it uses for" & @LF & _
					"downloading, which in practice, means it will be" & @LF & _
					"downloading up to '" & $threads & "' files simultaneously." & @LF & @LF & _
					"ADVICE -  This could potentially result in those" & @LF & _
					"'" & $threads & "' downloads being incomplete, if cancelled or" & @LF & _
					"an issue occurs. Whatever your choice, you can" & @LF & _
					"later change it on the SETUP window.", 0, $GOGRepoGUI)
				If $ans = 1 Then
					$res = _ReplaceStringInFile($gogrepo, "HTTP_GAME_DOWNLOADER_THREADS = " & $threads, "HTTP_GAME_DOWNLOADER_THREADS = 1")
					If $res > 0 Then
						$threads = 1
					EndIf
				EndIf
			ElseIf $threads = "" Then
				$threads = "X"
			EndIf
			IniWrite($inifle, "Downloading", "threads", $threads)
			$fdate = FileGetTime($gogrepo, 0, 1)
			IniWrite($inifle, "gogrepo.py", "file_date", $fdate)
		Else
			If $fdate <> FileGetTime($gogrepo, 0, 1) Then
				SplashTextOn("", "Please Wait!", 200, 120, Default, Default, 33)
				$file = FileOpen($gogrepo, 0)
				$read = FileRead($file)
				FileClose($file)
				$chunk = StringSplit($read, "HTTP_GAME_DOWNLOADER_THREADS = ", 1)
				If $chunk[0] > 1 Then
					$chunk = $chunk[2]
					;MsgBox(262192, "Threads Check", $chunk, 0, $GOGRepoGUI)
					$chunk = StringSplit($chunk, @LF, 1)
					$chunk = $chunk[1]
					$chunk = StringStripWS($chunk, 8)
					;MsgBox(262192, "Threads Check 1", "'" & $chunk & "'", 0, $GOGRepoGUI)
					If StringIsDigit($chunk) = 0 Then
						$chunk = ""
					EndIf
				EndIf
				SplashOff()
				;MsgBox(262192, "Threads Check 2", $chunk, 0, $GOGRepoGUI)
				$threads = IniRead($inifle, "Downloading", "threads", "")
				If $threads <> $chunk And $chunk <> "" And $threads <> "X" Then
					$res = _ReplaceStringInFile($gogrepo, "HTTP_GAME_DOWNLOADER_THREADS = " & $chunk, "HTTP_GAME_DOWNLOADER_THREADS = " & $threads)
					If $res < 1 Then
						$threads = $chunk
						IniWrite($inifle, "Downloading", "threads", $threads)
					EndIf
				ElseIf $chunk = "" Then
					$threads = "X"
					IniWrite($inifle, "Downloading", "threads", $threads)
				ElseIf $threads = "X" Then
					$threads = $chunk
					IniWrite($inifle, "Downloading", "threads", $threads)
				EndIf
				$fdate = FileGetTime($gogrepo, 0, 1)
				IniWrite($inifle, "gogrepo.py", "file_date", $fdate)
			Else
				$threads = IniRead($inifle, "Downloading", "threads", "")
				If $threads = "" Then
					$threads = "X"
					IniWrite($inifle, "Downloading", "threads", $threads)
				EndIf
			EndIf
		EndIf
	EndIf
	;
	FillTheGamesList()
	;
	$all = 4
	$started = 4
	$update = 4
	$verify = 4
	$wait = 0
	;
	$pid = ""
	$tot = IniRead($downlist, "Downloads", "total", 0)
	;
	$window = $GOGRepoGUI


	GuiSetState(@SW_ENABLE, $GOGRepoGUI)
	While 1
		$msg = GuiGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Button_exit
			; Exit / Close / Quit the program
			If $started = 1 Then
				$ans = MsgBox(262177 + 256, "Exit Query", _
					"Game downloading is still currently occurring." & @LF & @LF & _
					"Do you really want to quit now?" & @LF & @LF & _
					"NOTE - This will means that only the current" & @LF & _
					"'gogrepo.py' process will run to completion," & @LF & _
					"and no other downloads will occur, and you" & @LF & _
					"will not get the final verification for the last" & @LF & _
					"download, unless it is the current process." & @LF & @LF & _
					"(this auto closes & aborts in 10 seconds)", 10, $GOGRepoGUI)
				If $ans = 2 Or $ans = -1 Then
					ContinueLoop
				EndIf
			EndIf
			GetWindowPosition()
			;
			GUIDelete($GOGRepoGUI)
			ExitLoop
		Case $msg = $Button_setup
			; Setup username and password
			SetupGUI()
			$window = $GOGRepoGUI
		Case $msg = $Button_queue
			; View the download queue
			GetWindowPosition()
			GuiSetState(@SW_HIDE, $GOGRepoGUI)
			QueueGUI()
			$window = $GOGRepoGUI
			GuiSetState(@SW_SHOW, $GOGRepoGUI)
		Case $msg = $Button_pic
			; Download the selected image
			$name = GUICtrlRead($Input_name)
			If $name <> "" Then
				$image = IniRead($gamesfle, $name, "image", "")
				If $image <> "" Then
					SplashTextOn("", "Saving!", 200, 120, Default, Default, 33)
					$gamepic = $name & ".jpg"
					$gamepic = StringReplace($gamepic, ": ", " - ")
					$gamepic = StringReplace($gamepic, "?", "")
					$gamepic = StringReplace($gamepic, "*", "")
					$gamepic = StringReplace($gamepic, "|", "")
					$gamepic = StringReplace($gamepic, "/", "")
					$gamepic = StringReplace($gamepic, "\", "")
					$gamepic = StringReplace($gamepic, "<", "")
					$gamepic = StringReplace($gamepic, ">", "")
					$gamepic = StringReplace($gamepic, '"', '')
					$gamepic = @ScriptDir & "\" & $gamepic
					InetGet($image, $gamepic, 1, 0)
					SplashOff()
				EndIf
			EndIf
		Case $msg = $Button_more
			; View more information from manifest
			If FileExists($manifest) Then
				$name = GUICtrlRead($Input_name)
				If $name <> "" Then
					$title = GUICtrlRead($Input_title)
					If $title <> "" Then
						SplashTextOn("", "Please Wait!", 200, 120, Default, Default, 33)
						$open = FileOpen($manifest, 0)
						$read = FileRead($open)
						FileClose($open)
						$segment = StringSplit($read, "'title': '" & $title & "'}", 1)
						If $segment[0] = 2 Then
							$segment = $segment[1]
							$segment = StringSplit($segment, "{'bg_url':", 1)
							If $segment[0] > 1 Then
								$html = "<html>" & @CRLF & "<header>" & @CRLF & "<title>" & $title & "</title>" & @CRLF & "</header>" & @CRLF & "<body>"
								$image = IniRead($gamesfle, $name, "image", "")
								If $image <> "" Then
									$html = $html & @CRLF & "<img src='" & $image & "' width='100%'>"
								EndIf
								$chunk = $title & @CRLF & "'bg_url':" & $segment[$segment[0]]
								$chunk = StringReplace($chunk, "\n", "")
								$chunk = StringReplace($chunk, "'<h4>", "<h4>")
								$chunk = StringReplace($chunk, "</h4>'", "</h4>")
								$chunk = StringReplace($chunk, "'<h5>", "<h5>")
								$chunk = StringReplace($chunk, "</h5>'", "</h5>")
								;$chunk = StringReplace($chunk, "               ", "")
								$chunk = StringReplace($chunk, @CRLF, "<br>")
								$chunk = StringReplace($chunk, @CR, "<br>")
								$chunk = StringReplace($chunk, @LF, "<br>")
								$chunk = StringReplace($chunk, "<br><h4>", "<h4>")
								$chunk = StringReplace($chunk, "<br><h5>", "<h5>")
								$chunk = StringReplace($chunk, "</h4><br>", "</h4>")
								$chunk = StringReplace($chunk, "</h5><br>", "</h5>")
								$chunk = StringReplace($chunk, "</li>'<br>'<li>", "</li><li>")
								$chunk = StringReplace($chunk, "</h5>'<ul>'<br>'<li>", "</h5><ul><li>")
								$chunk = StringReplace($chunk, "</li>'<br>'</ul>'<h5>", "</li></ul><h5>")
								$chunk = StringReplace($chunk, "<li>'<br>'<p>", "<li><p>")
								$chunk = StringReplace($chunk, "</p>'<br>'</li><li>'<br>'<p>", "</p></li><li><p>")
								$chunk = StringReplace($chunk, "</p>'<br>'</li>", "</p></li>")
								$chunk = StringReplace($chunk, "</li>'<br>'</ul>", "</li></ul>")
								$chunk = StringReplace($chunk, "</ul>',<br>", "</ul>")
								$chunk = StringReplace($chunk, "</h4>'<ul>'<br>'<li>", "</h4><ul><li>")
								$chunk = StringReplace($chunk, "</li>'<br>" & '"<li>', "</li><li>")
								$chunk = StringReplace($chunk, "</ul>'<br>'<hr />'<h4>", "</ul><hr /><h4>")
								$chunk = StringReplace($chunk, "</li>'<br>", "</li>")
								$chunk = StringReplace($chunk, "               '<li>", "<li>")
								$chunk = StringReplace($chunk, "               '</li>", "</li>")
								$chunk = StringReplace($chunk, '               "<li>', "<li>")
								$chunk = StringReplace($chunk, '               "</li>', "</li>")
								$chunk = StringReplace($chunk, "               '<ul>", "<ul>")
								$chunk = StringReplace($chunk, "               '</ul>", "</ul>")
								$chunk = StringReplace($chunk, "               '<hr />", "<hr />")
								$chunk = StringReplace($chunk, "               <h4>", "<h4>")
								$chunk = StringReplace($chunk, "               <h5>", "<h5>")
								$chunk = StringReplace($chunk, "               '<p>", "<p>")
								$chunk = StringReplace($chunk, '               "<p>', "<p>")
								$chunk = StringReplace($chunk, "               '</p>", "</p>")
								$chunk = StringReplace($chunk, "<ul>'<br>", "<ul>")
								$chunk = StringReplace($chunk, "</ul>'<br>", "</ul>")
								$chunk = StringReplace($chunk, "<hr />',<br>", "<hr />")
								$chunk = StringReplace($chunk, "<hr />'<br>", "<hr />")
								$chunk = StringReplace($chunk, "<li>'<br>", "<li>")
								$chunk = StringReplace($chunk, "</p>'<br>", "</p>")
								$chunk = StringReplace($chunk, '</p>"<br>', "</p>")
								$chunk = StringReplace($chunk, "<br></p>", "</p>")
								$chunk = $html & @CRLF & "<pre>" & $chunk & "</pre>" & @CRLF & "</body>" & @CRLF & "</html>"
								SplashOff()
								;MsgBox(262208, "Game Information From Manifest - " & $title, $chunk, $wait, $GOGRepoGUI)
								$file = FileOpen($infofle, 2)
								FileWriteLine($file, $chunk)
								FileClose($file)
								ShellExecute($infofle)
							EndIf
						Else
							SplashOff()
						EndIf
					EndIf
				EndIf
			EndIf
		Case $msg = $Button_log
			; View the record log file
			If FileExists($logfle) Then ShellExecute($logfle)
		Case $msg = $Button_info
			; Program Information
			$delay = $wait * 5
			MsgBox(262208, "Program Information", _
				"This program is a frontend GUI for 'gogrepo.py' (Python) program" & @LF & _
				"that can get a manifest of your GOG.com games library, as well as" & @LF & _
				"download your games, verify and update etc." & @LF & @LF & _
				"This GOGRepo GUI program is totally reliant on 'gogrepo.py', but" & @LF & _
				"has some handy abilities of its own - downloading cover images," & @LF & _
				"queuing downloads, viewing a list of your games, etc." & @LF & @LF & _
				"Before starting with GOGRepo GUI, you need a cookie file, which" & @LF & _
				"can be created, if you haven't yet got one, via the SETUP button." & @LF & @LF & _
				"REQUIREMENTS" & @LF & _
				"------------------" & @LF & _
				"Python needs to be installed on your PC." & @LF & _
				"Python needs to have the html5lib installed." & @LF & _
				"Python can also optionally have html2text installed (advised)." & @LF & _
				"gogrepo.py needs to be in the same folder as GOGRepo GUI." & @LF & @LF & _
				"BIG THANKS to those responsible for gogrepo.py." & @LF & _
				"(woolymethodman, Kalanyr, etc)" & @LF & @LF & _
				"© June 2020 - GOGRepo GUI created by Timboli.", $delay, $GOGRepoGUI)
		Case $msg = $Button_fold
			; Open the selected Game folder
			If FileExists($gamesfold) Then
				GUISetState(@SW_MINIMIZE, $GOGRepoGUI)
				$title = GUICtrlRead($Input_title)
				If $title <> "" Then
					$gamefold = $gamesfold
					If $alpha = 1 Then
						$let = StringUpper(StringLeft($title, 1))
						$gamefold = $gamefold & "\" & $let
					EndIf
					$gamefold = $gamefold & "\" & $title
					If FileExists($gamefold) Then
						Run(@WindowsDir & "\Explorer.exe " & $gamefold)
					Else
						Run(@WindowsDir & "\Explorer.exe " & $gamesfold)
					EndIf
				Else
					Run(@WindowsDir & "\Explorer.exe " & $gamesfold)
				EndIf
			EndIf
		Case $msg = $Button_fix Or $msg = $Label_title
			; Click to convert text in input field
			$title = GUICtrlRead($Input_title)
			If $title <> "" Then
				$title = StringReplace($title, ":", "")
				$title = StringReplace($title, ";", "")
				$title = StringReplace($title, "?", "")
				$title = StringReplace($title, "-", "")
				$title = StringReplace($title, ",", "")
				$title = StringLower($title)
				$title = StringReplace($title, "'", "_")
				$title = StringReplace($title, ".", "_")
				$title = StringStripWS($title, 7)
				$title = StringReplace($title, " ", "_")
				GUICtrlSetData($Input_title, $title)
			EndIf
		Case $msg = $Button_down
			; Download the selected game
			If FileExists($gogrepo) Then
				$ans = ""
				CheckIfPythonRunning()
				If $ans = 2 Then ContinueLoop
				;
				$title = GUICtrlRead($Input_title)
				If $title <> "" Or $all = 1 Then
					$gamefold = $gamesfold
					If $all = 4 Then
						;MsgBox(262192, "Got Here 1", $title & @LF & $gamefold, $wait, $GOGRepoGUI)
						If $alpha = 1 Then
							$let = StringUpper(StringLeft($title, 1))
							$gamefold = $gamefold & "\" & $let
							;MsgBox(262192, "Got Here 2", $title & @LF & $gamefold, $wait, $GOGRepoGUI)
						EndIf
					;Else
					EndIf
					If Not FileExists($gamefold) And $verify = 4 Then
						DirCreate($gamefold)
					EndIf
					If FileExists($gamefold) Then
						;MsgBox(262192, "Game Folder", $title & @LF & $gamefold, $wait, $GOGRepoGUI)
						If $verify = 1 Then
							; Verify one or more games
							EnableDisableControls($GUI_DISABLE)
							VerifyGUI()
							EnableDisableControls($GUI_ENABLE)
						ElseIf $update = 1 Then
							; Update the manifest
							EnableDisableControls($GUI_DISABLE)
							$OSget = GUICtrlRead($Combo_OS)
							$OS = StringReplace($OSget, " + ", " ")
							$OS = StringLower($OS)
							$title = GUICtrlRead($Input_title)
							UpdateGUI()
							If $updating = 1 Then
								GUICtrlSetData($List_games, "")
								GUICtrlSetData($Input_name, "")
								GUICtrlSetData($Input_title, "")
								GUICtrlSetData($Input_OS, "")
								GUICtrlSetData($Input_extra, "")
								_FileCreate($titlist)
								ParseTheManifest()
								FillTheGamesList()
							EndIf
							EnableDisableControls($GUI_ENABLE)
						Else
							; Download one or more games or add to queue
							FileChangeDir(@ScriptDir)
							If $all = 1 Then
								DownloadGUI()
							Else
								$tot = IniRead($downlist, "Downloads", "total", 0)
								While 1
									If $tot = 0 And $started = 4 Then
										$tot = 1
										;AddGameToDownloadList()
										If $auto = 1 Then
											$started = 1
											$wait = 3
											$verifying = ""
											IniWrite($downlist, "Downloads", "total", $tot)
											;_FileWriteLog($logfle, "Downloaded - " & $title & ".")
											IniWrite($inifle, "Current Download", "title", $title)
											IniWrite($inifle, "Current Download", "destination", $gamefold)
											IniWrite($inifle, "Current Download", "verify", $validate)
											IniWrite($inifle, "Current Download", "cover", $cover)
											If $cover = 1 Then
												$image = IniRead($gamesfle, $name, "image", "")
												IniWrite($inifle, "Current Download", "image", $image)
											EndIf
											CheckOnShutdown()
											If $minimize = 1 Then
												$flag = @SW_MINIMIZE
											Else
												;$flag = @SW_RESTORE
												$flag = @SW_SHOW
											EndIf
											;$pid = Run(@ComSpec & ' /c gogrepo.py download -id ' & $title & ' "' & $gamefold & '"', @ScriptDir, $flag)
											;AdlibRegister("CheckOnGameDownload", 3000)
										Else
											AddGameToDownloadList()
										EndIf
										ExitLoop
									ElseIf $tot = 1 And $started = 4 And $auto = 1 Then
										IniDelete($inifle, "Current Download")
										$tot = 0
										IniWrite($downlist, "Downloads", "total", $tot)
									Else
										$add = ""
										$exist = IniRead($downlist, $title, "rank", "")
										If $exist <> "" Then
											$delay = $wait * 3
											$ans = MsgBox(262177, "Replace Query", _
												"The game you are adding, already exists on the download list." & @LF & @LF & _
												"Do you want to replace (change) the options for it?" & @LF & @LF & _
												"NOTE - This does not change its downloading order.", $delay, $GOGRepoGUI)
											If $ans = 1 Then
												$add = 1
												$tot = $exist
											EndIf
										Else
											$add = 1
											$tot = $tot + 1
										EndIf
										If $add = 1 Then
											AddGameToDownloadList()
										EndIf
										ExitLoop
									EndIf
								WEnd
								If $tot > 0 Then
									GUICtrlSetState($Checkbox_update, $GUI_DISABLE)
									GUICtrlSetState($Checkbox_verify, $GUI_DISABLE)
									GUICtrlSetState($Checkbox_all, $GUI_DISABLE)
									;GUICtrlSetState($Button_setup, $GUI_DISABLE)
								EndIf
							EndIf
						EndIf
					Else
						MsgBox(262192, "Path Error", "Game folder not found!", $wait, $GOGRepoGUI)
					EndIf
				Else
					MsgBox(262192, "Game Error", "Title is not selected!", $wait, $GOGRepoGUI)
				EndIf
			Else
				MsgBox(262192, "Program Error", "Required file 'gogrepo.py' not found!", $wait, $GOGRepoGUI)
			EndIf
		Case $msg = $Button_dest
			; Browse to set the destination folder
			$pth = FileSelectFolder("Browse to set the main games folder.", @ScriptDir, 7, $gamesfold, $GOGRepoGUI)
			If Not @error And StringMid($pth, 2, 2) = ":\" Then
				 $gamesfold = $pth
				IniWrite($inifle, "Main Games Folder", "path", $gamesfold)
				GUICtrlSetData($Input_dest, $gamesfold)
			EndIf
		Case $msg = $Checkbox_verify
			; Enable verifying one or all games
			If GUICtrlRead($Checkbox_verify) = $GUI_CHECKED Then
				$verify = 1
				If $all = 1 Then
					$buttitle = "Verify" & @LF & "ALL"
					GUICtrlSetTip($Button_down, "Verify ALL games!")
				Else
					$buttitle = "Verify" & @LF & "One"
					GUICtrlSetTip($Button_down, "Verify the selected game!")
				EndIf
				GUICtrlSetState($Checkbox_update, $GUI_DISABLE)
			Else
				$verify = 4
				If $all = 1 Then
					$buttitle = "Down" & @LF & "ALL"
					GUICtrlSetTip($Button_down, "Download ALL games!")
				Else
					$buttitle = "Down" & @LF & "One"
					GUICtrlSetTip($Button_down, "Download the selected game!")
				EndIf
				GUICtrlSetState($Checkbox_update, $GUI_ENABLE)
			EndIf
			GUICtrlSetData($Button_down, $buttitle)
		Case $msg = $Checkbox_update
			; Enable updating one or all games
			If GUICtrlRead($Checkbox_update) = $GUI_CHECKED Then
				$update = 1
				If $all = 1 Then
					$buttitle = "Update" & @LF & "ALL"
					GUICtrlSetTip($Button_down, "Verify ALL games!")
				Else
					$buttitle = "Update" & @LF & "One"
					GUICtrlSetTip($Button_down, "Verify the selected game!")
				EndIf
				GUICtrlSetState($Checkbox_verify, $GUI_DISABLE)
			Else
				$update = 4
				If $all = 1 Then
					$buttitle = "Down" & @LF & "ALL"
					GUICtrlSetTip($Button_down, "Download ALL games!")
				Else
					$buttitle = "Down" & @LF & "One"
					GUICtrlSetTip($Button_down, "Download the selected game!")
				EndIf
				GUICtrlSetState($Checkbox_verify, $GUI_ENABLE)
			EndIf
			GUICtrlSetData($Button_down, $buttitle)
		Case $msg = $Checkbox_test
			; Verify integrity of downloaded files
			If GUICtrlRead($Checkbox_test) = $GUI_CHECKED Then
				$validate = 1
			Else
				$validate = 4
			EndIf
			IniWrite($inifle, "Download Options", "verify", $validate)
		Case $msg = $Checkbox_show
			; Show the cover image
			If GUICtrlRead($Checkbox_show) = $GUI_CHECKED Then
				$show = 1
			Else
				$show = 4
				GUICtrlSetImage($Pic_cover, $blackjpg)
			EndIf
			IniWrite($inifle, "Cover Image", "show", $show)
		Case $msg = $Checkbox_game
			; Download the game files
			If GUICtrlRead($Checkbox_game) = $GUI_CHECKED Then
				$files = 1
			Else
				$files = 4
			EndIf
			IniWrite($inifle, "Download Options", "files", $files)
		Case $msg = $Checkbox_extra
			; Download game extras files
			If GUICtrlRead($Checkbox_extra) = $GUI_CHECKED Then
				$extras = 1
			Else
				$extras = 4
			EndIf
			IniWrite($inifle, "Download Options", "extras", $extras)
		Case $msg = $Checkbox_cover
			; Download the cover image files
			If GUICtrlRead($Checkbox_cover) = $GUI_CHECKED Then
				$cover = 1
			Else
				$cover = 4
			EndIf
			IniWrite($inifle, "Download Options", "cover", $cover)
		Case $msg = $Checkbox_alpha
			; Create alphanumeric sub-folder
			If GUICtrlRead($Checkbox_alpha) = $GUI_CHECKED Then
				$alpha = 1
			Else
				$alpha = 4
			EndIf
			IniWrite($inifle, "Alphanumerical Game Folders", "use", $alpha)
		Case $msg = $Checkbox_all
			; Process one or ALL games
			If GUICtrlRead($Checkbox_all) = $GUI_CHECKED Then
				$all = 1
				If $verify = 1 Then
					$buttitle = "Verify" & @LF & "ALL"
					GUICtrlSetTip($Button_down, "Verify ALL games!")
				ElseIf $update = 1 Then
					$buttitle = "Update" & @LF & "ALL"
					GUICtrlSetTip($Button_down, "Update ALL games!")
				Else
					$buttitle = "Down" & @LF & "ALL"
					GUICtrlSetTip($Button_down, "Download ALL games!")
				EndIf
			Else
				$all = 4
				If $verify = 1 Then
					$buttitle = "Verify" & @LF & "One"
					GUICtrlSetTip($Button_down, "Verify the selected game!")
				ElseIf $update = 1 Then
					$buttitle = "Update" & @LF & "One"
					GUICtrlSetTip($Button_down, "Update the selected game!")
				Else
					$buttitle = "Down" & @LF & "One"
					GUICtrlSetTip($Button_down, "Download the selected game!")
				EndIf
			EndIf
			GUICtrlSetData($Button_down, $buttitle)
		Case $msg = $Combo_OS
			; OS to download files for
			$OSget = GUICtrlRead($Combo_OS)
			IniWrite($inifle, "Download Options", "OS", $OSget)
		Case $msg = $List_games
			; List of games
			$name = GUICtrlRead($List_games)
			;$name = StringReplace($name, Chr(150), " - ")
			;$name = StringReplace($name, Chr(151), " - ")
			;$name = StringReplace($name, Chr(175), " - ")
			;$name = StringReplace($name, "–", "-")
			GUICtrlSetData($Input_name, $name)
			$title = IniRead($gamesfle, $name, "title", "error")
			GUICtrlSetData($Input_title, $title)
			$OS = IniRead($gamesfle, $name, "osextra", "")
			If StringInStr($OS, "Extras") > 0 Then
				$OS = StringReplace($OS, " + Extras", "")
				$OS = StringReplace($OS, "Extras", "")
				GUICtrlSetData($Input_OS, $OS)
				GUICtrlSetData($Input_extra, "Extras")
			Else
				GUICtrlSetData($Input_OS, $OS)
				GUICtrlSetData($Input_extra, "")
			EndIf
			If $show = 1 Then
				$image = IniRead($gamesfle, $name, "image", "")
				If $image <> "" Then
					GUICtrlSetData($Label_cover, "Please Wait")
					$image = StringTrimRight($image, 4) & "_196.jpg"
					FileDelete($imgfle)
					InetGet($image, $imgfle, 1, 0)
					If FileExists($imgfle) Then
						GUICtrlSetImage($Pic_cover, $imgfle)
					Else
						GUICtrlSetImage($Pic_cover, $blackjpg)
					EndIf
				Else
					GUICtrlSetImage($Pic_cover, $blackjpg)
				EndIf
			EndIf
			GUICtrlSetData($Label_cover, "")
		Case $msg = $Pic_cover
			; Cover Image - Click For Large Preview
			If $imgfle <> "" Then
				$image = IniRead($gamesfle, $name, "image", "")
				If $image <> "" Then
					SplashTextOn("", "Please Wait!", 200, 120, Default, Default, 33)
					FileDelete($bigpic)
					InetGet($image, $bigpic, 1, 0)
					If FileExists($bigpic) Then
						GUICtrlSetState($Pic_cover, $GUI_DISABLE)
						SplashImageOn("", $bigpic, 900, 450, Default, Default, 17)
						Sleep(300)
						$mpos = MouseGetPos()
						$xpos = $mpos[0]
						$ypos = $mpos[1]
						Sleep(300)
						$dll = DllOpen("user32.dll")
						While 1
							$mpos = MouseGetPos()
							If $mpos[0] > $xpos + 40 Or $mpos[0] < $xpos - 40 Then ExitLoop
							If $mpos[1] > $ypos + 40 Or $mpos[1] < $ypos - 40 Then ExitLoop
							If _IsPressed("01", $dll) Then ExitLoop
							Sleep(300)
						WEnd
						DllClose($dll)
						SplashOff()
						GUICtrlSetState($Pic_cover, $GUI_ENABLE)
					Else
						SplashOff()
					EndIf
				EndIf
			EndIf
		Case Else
			;;;
		EndSelect
	WEnd
EndFunc ;=> MainGUI

Func DownloadGUI()
	; Query which DOWNLOAD ALL method to use.
	Local $Button_close, $Button_inf, $Button_one, $Button_two, $Group_one, $Group_two, $Label_extra, $Label_one, $Label_two
	;
	$DownloadGUI = GuiCreate("Download ALL", 230, 400, Default, Default, $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU _
														+ $WS_VISIBLE + $WS_CLIPSIBLINGS, $WS_EX_TOPMOST, $GOGRepoGUI)
	GUISetBkColor(0xCECEFF, $DownloadGUI)
	GuiSetState(@SW_DISABLE, $DownloadGUI)
	; CONTROLS
	$Group_one = GuiCtrlCreateGroup("", 10, 5, 210, 160)
	$Button_one = GuiCtrlCreateButton("METHOD ONE", 20, 25, 190, 40)
	GUICtrlSetFont($Button_one, 9, 600)
	GUICtrlSetTip($Button_one, "Download ALL Games using Method 1!")
	$Label_one = GuiCtrlCreateLabel("This method only uses 'gogrepo.py'  to" _
		& @LF & "download your games and extras. Any" _
		& @LF & "queuing involved is not available to be" _
		& @LF & "interacted with, plus the main program" _
		& @LF & "window is disabled for the full duration." _
		& @LF & "Download location is just a main one.", 23, 75, 187, 80)
	;
	$Group_two = GuiCtrlCreateGroup("", 10, 175, 210, 150)
	$Button_two = GuiCtrlCreateButton("METHOD TWO", 20, 195, 190, 40)
	GUICtrlSetFont($Button_two, 9, 600)
	GUICtrlSetTip($Button_two, "Download ALL Games using Method 2!")
	$Label_two = GuiCtrlCreateLabel("This method uses both gogrepo.py and" _
		& @LF & "a queuing system you can interact with" _
		& @LF & "to download all your games and extras." _
		& @LF & "You can also have greater control over" _
		& @LF & "the download location, individually.", 20, 245, 190, 70)
	;
	$Label_extra = GuiCtrlCreateLabel("Alphanumeric" _
		& @LF & "folders are not" _
		& @LF & "supported by" _
		& @LF & "Method One.", 13, 338, 70, 75)
	GUICtrlSetColor($Label_extra, $COLOR_RED)
	;
	$Button_inf = GuiCtrlCreateButton("Info", 90, 340, 60, 50, $BS_ICON)
	GUICtrlSetTip($Button_inf, "Download ALL Information!")
	;
	$Button_close = GuiCtrlCreateButton("EXIT", 160, 340, 60, 50, $BS_ICON)
	GUICtrlSetTip($Button_close, "Exit / Close / Quit the window!")
	;
	; SETTINGS
	GUICtrlSetImage($Button_close, $user, $icoX, 1)
	GUICtrlSetImage($Button_inf, $user, $icoI, 1)
	;
	If $alpha = 1 Then GUICtrlSetState($Button_one, $GUI_DISABLE)
	;
	$window = $DownloadGUI


	GuiSetState(@SW_ENABLE, $DownloadGUI)
	While 1
		$msg = GuiGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Button_close
			; Exit / Close / Quit the window
			GUIDelete($DownloadGUI)
			ExitLoop
		Case $msg = $Button_two
			; Download ALL Games using Method 2
		Case $msg = $Button_one
			; Download ALL Games using Method 1
			; METHOD 1 - Copy all titles (& their details) to Downloads list, providing interaction & control.
			EnableDisableControls($GUI_DISABLE)
			$pid = RunWait(@ComSpec & ' /c gogrepo.py download "' & $gamefold & '"', @ScriptDir)
			If $validate = 1 Then $pid = RunWait(@ComSpec & ' /k gogrepo.py verify "' & $gamefold & '"', @ScriptDir)
			_FileWriteLog($logfle, "Downloaded all games.")
			EnableDisableControls($GUI_ENABLE)
		Case $msg = $Button_inf
			; Download ALL Information
		Case Else
			;;;
		EndSelect
	WEnd
	;
	; METHOD 2 - Hand reins fully to 'gogrepo.py', and GUI remains disabled for duration.
EndFunc ;=> DownloadGUI

Func QueueGUI()
	Local $Button_inf, $Button_quit, $Button_record, $Checkbox_dos, $Checkbox_start, $Checkbox_stop
	Local $Group_auto, $Group_info, $Group_progress, $Group_shutdown, $Group_stop
	;
	Local $restart, $section, $shutopts, $swap
	;
	$QueueGUI = GuiCreate("QUEUE & Options", $width, $height, $left, $top, $style, $WS_EX_TOPMOST)
	GUISetBkColor(0xFFD5FF, $QueueGUI)
	; CONTROLS
	$Group_download = GuiCtrlCreateGroup("Current Download", 10, 10, 370, 55)
	$Input_download = GUICtrlCreateInput("", 20, 32, 350, 20)
	GUICtrlSetBkColor($Input_download, 0xBBFFBB)
	GUICtrlSetTip($Input_download, "Game Name!")
	;
	$Group_waiting = GuiCtrlCreateGroup("Games To Download", 10, 75, 370, 167)
	$List_waiting = GuiCtrlCreateList("", 20, 95, 350, 110, $WS_BORDER + $WS_VSCROLL)
	GUICtrlSetBkColor($List_waiting, 0xB9FFFF)
	GUICtrlSetTip($List_waiting, "List of games waiting to download!")
	$Input_destination = GUICtrlCreateInput("", 20, 210, 295, 20)
	GUICtrlSetBkColor($Input_destination, 0xBBFFBB)
	GUICtrlSetTip($Input_destination, "Destination path!")
	$Checkbox_check = GUICtrlCreateCheckbox("Verify", 325, 210, 45, 20)
	GUICtrlSetTip($Checkbox_check, "Verify the download!")
	;
	$Group_done = GuiCtrlCreateGroup("Downloads Finished", 10, 252, 370, 143)
	$List_done = GuiCtrlCreateList("", 20, 272, 350, 110, $WS_BORDER + $WS_VSCROLL)
	GUICtrlSetBkColor($List_done, 0xFFFFCA)
	GUICtrlSetTip($List_done, "List of games that have finished downloading!")
	;
	$Group_auto = GuiCtrlCreateGroup("Auto", 390, 10, 60, 55)
	$Checkbox_start = GUICtrlCreateCheckbox("Start", 400, 31, 40, 20)
	GUICtrlSetTip($Checkbox_start, "Automatically start downloading!")
	;
	$Button_start = GuiCtrlCreateButton("START", 460, 15, 60, 30)
	GUICtrlSetFont($Button_start, 8, 600)
	GUICtrlSetTip($Button_start, "Start downloading!")
	;
	$Button_stop = GuiCtrlCreateButton("STOP", 530, 15, 50, 30)
	GUICtrlSetFont($Button_stop, 8, 600)
	GUICtrlSetTip($Button_stop, "Stop downloading!")
	;
	$Checkbox_dos = GUICtrlCreateCheckbox("Minimize DOS Console", 462, 49, 120, 20)
	GUICtrlSetFont($Checkbox_dos, 7, 400, 0, "Small Fonts")
	GUICtrlSetTip($Checkbox_dos, "Minimize the gogrepo.py DOS Console when it starts!")
	;
	$Group_stop = GuiCtrlCreateGroup("Stop After", 390, 75, 122, 55)
	$Checkbox_stop = GUICtrlCreateCheckbox("Current Download", 400, 95, 102, 20)
	GUICtrlSetTip($Checkbox_stop, "Stop after current download!")
	;
	$Button_add = GuiCtrlCreateButton("ADD" & @LF & "STOP", 522, 80, 58, 50, $BS_MULTILINE)
	GUICtrlSetFont($Button_add, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_add, "Add a stop before selected entry!")
	;
	$Button_moveup = GuiCtrlCreateButton("UP", 390, 140, 50, 50, $BS_ICON)
	GUICtrlSetTip($Button_moveup, "Move selected entry up the list!")
	;
	$Button_movedown = GuiCtrlCreateButton("DOWN", 390, 200, 50, 50, $BS_ICON)
	GUICtrlSetTip($Button_movedown, "Move selected entry down the list!")
	;
	$Button_removall = GuiCtrlCreateButton("Remove ALL", 450, 140, 80, 22)
	GUICtrlSetFont($Button_removall, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_removall, "Remove all downloads from the list!")
	;
	$Button_remove = GuiCtrlCreateButton("REMOVE" & @LF & "Selected", 450, 167, 80, 39, $BS_MULTILINE)
	GUICtrlSetFont($Button_remove, 8, 600)
	GUICtrlSetTip($Button_remove, "Remove selected entry from the list!")
	;
	$Button_edit = GuiCtrlCreateButton("UPDATE" & @LF & "Selected", 450, 211, 80, 39, $BS_MULTILINE)
	GUICtrlSetFont($Button_edit, 8, 600)
	GUICtrlSetTip($Button_edit, "Update download options for selected entry!")
	;
	$Group_progress = GuiCtrlCreateGroup("", 540, 135, 40, 115)
	$Progress_bar = GUICtrlCreateProgress(550, 150, 20, 90, $PBS_SMOOTH + $PBS_VERTICAL)
	GUICtrlSetData($Progress_bar, 0)
	;
	$Group_info = GuiCtrlCreateGroup("Download Entry Information", 390, 258, 190, 75)
	$Input_OP = GUICtrlCreateInput("", 400, 278, 90, 20)
	GUICtrlSetBkColor($Input_OP, 0xBBFFBB)
	GUICtrlSetTip($Input_OP, "OS to download!")
	$Checkbox_files = GUICtrlCreateCheckbox("Game Files", 500, 278, 70, 20)
	GUICtrlSetTip($Checkbox_files, "Download game files!")
	$Checkbox_other = GUICtrlCreateCheckbox("Extras", 400, 303, 50, 20)
	GUICtrlSetTip($Checkbox_other, "Download extras files!")
	$Checkbox_image = GUICtrlCreateCheckbox("Cover", 460, 303, 45, 20)
	GUICtrlSetTip($Checkbox_image, "Download cover file!")
	$Input_lang = GUICtrlCreateInput("", 515, 303, 55, 20)
	GUICtrlSetBkColor($Input_lang, 0xBBFFBB)
	GUICtrlSetTip($Input_lang, "Language for selected entry!")
	;
	$Group_shutdown = GuiCtrlCreateGroup("Shutdown", $width - 198, $height - 65, 101, 55)
	$Combo_shutdown = GUICtrlCreateCombo("", $width - 188, $height - 45, 81, 21)
	GUICtrlSetBkColor($Combo_shutdown, 0xB9FFFF)
	GUICtrlSetTip($Combo_shutdown, "Shutdown options!")
	;
	$Button_record = GuiCtrlCreateButton("Log", $width - 88, $height - 60, 25, 23, $BS_ICON)
	GUICtrlSetTip($Button_record, "Log Record!")
	;
	$Button_inf = GuiCtrlCreateButton("Info", $width - 88, $height - 33, 25, 23, $BS_ICON)
	GUICtrlSetTip($Button_inf, "Program Information!")
	;
	$Button_quit = GuiCtrlCreateButton("EXIT", $width - 55, $height - 60, 45, 50, $BS_ICON)
	GUICtrlSetTip($Button_quit, "Exit / Close / Quit the window!")
	;
	; SETTINGS
	GuiSetState(@SW_DISABLE, $QueueGUI)
	;
	GUICtrlSetImage($Button_moveup, $shell, -247, 1)
	GUICtrlSetImage($Button_movedown, $shell, -248, 1)
	GUICtrlSetImage($Button_record, $shell, $icoT, 0)
	GUICtrlSetImage($Button_inf, $user, $icoI, 0)
	GUICtrlSetImage($Button_quit, $user, $icoX, 1)
	;
	GUICtrlSetState($Checkbox_start, $auto)
	GUICtrlSetState($Checkbox_dos, $minimize)
	GUICtrlSetState($Checkbox_stop, $stop)
	;
	$shutopts = "none|Hibernate|Logoff|Powerdown|Reboot|Shutdown|Standby"
	GUICtrlSetData($Combo_shutdown, $shutopts, $shutdown)
	If $shutdown <> "none" Then
		WinSetTitle($QueueGUI, "", "QUEUE & Options - " & $shutdown & " is ENABLED")
	EndIf
	;
	If $auto = 1 And $started = 1 Then
		$title = IniRead($inifle, "Current Download", "title", "")
		GUICtrlSetData($Input_download, $title)
	EndIf
	;
	If FileExists($downlist) Then
		$titles = IniReadSectionNames($downlist)
		If Not @error Then
			If $titles[0] > 1 Then
				$tot = 0
				For $t = 2 To $titles[0]
					$title = $titles[$t]
					If $title <> "" Then
						$tot = $tot + 1
						_GUICtrlListBox_AddString($List_waiting, $title)
					EndIf
				Next
				If $tot > 0 Then
					GUICtrlSetData($Group_waiting, "Games To Download  (" & $tot & ")")
					If $started = 1 Then
						GUICtrlSetState($Button_start, $GUI_DISABLE)
					Else
						GUICtrlSetState($Button_stop, $GUI_DISABLE)
					EndIf
					$ind = IniRead($downlist, "Downloads", "stop", -1)
					$ind = Number($ind)
					If $ind > -1 And $ind < $tot Then
						_GUICtrlListBox_InsertString($List_waiting, "+++ STOP HERE +++", $ind)
					EndIf
				Else
					DisableQueueButtons()
				EndIf
			Else
				DisableQueueButtons()
			EndIf
		Else
			DisableQueueButtons()
		EndIf
	Else
		DisableQueueButtons()
	EndIf
	GUICtrlSetState($Button_moveup, $GUI_DISABLE)
	GUICtrlSetState($Button_movedown, $GUI_DISABLE)
	;
	$restart = ""
	$window = $QueueGUI


	GuiSetState(@SW_ENABLE, $QueueGUI)
	While 1
		$msg = GuiGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Button_quit
			; Exit / Close / Quit the window
			GUIDelete($QueueGUI)
			ExitLoop
		Case $msg = $Button_stop
			; Stop downloading
			$delay = $wait * 4
			$ans = MsgBox(262177, "STOP NOW Query", _
				"This will kill the current gogrepo.py" & @LF &_
				"process, which may result in a partial" & @LF &_
				"download or an unverified one." & @LF & @LF & _
				"Do you really want to do this?", $delay, $QueueGUI)
			If $ans = 1 Then
				$started = 4
				$wait = 0
				AdlibUnRegister("CheckOnGameDownload")
				If ProcessExists($pid) Then ProcessClose($pid)
				;
				; Add some code to restore game title to downloads list, after querying user.
				; NOTE - If input field is not cleared, there is potential to restart title.
				;
				ProcessWaitClose($pid, 10)
				If ProcessExists($pid) = 0 Then
					GUICtrlSetState($Button_start, $GUI_ENABLE)
					GUICtrlSetState($Button_stop, $GUI_DISABLE)
				Else
					GUISwitch($GOGRepoGUI)
					GUICtrlSetState($Button_down, $GUI_DISABLE)
					GUISwitch($QueueGUI)
					MsgBox(262192, "STOP Error", "The 'gogrepo.py' process could not be stopped." & @LF & @LF _
						& "You will need to close the process manually." & @LF _
						& "To do that, click the 'X' button on the DOS" & @LF _
						& "console window at top right.", 5, $QueueGUI)
				EndIf
			EndIf
		Case $msg = $Button_start
			; Start downloading
			$started = 1
			$wait = 3
			GUICtrlSetState($Button_start, $GUI_DISABLE)
			GUICtrlSetState($Button_stop, $GUI_ENABLE)
			$title = GUICtrlRead($Input_download)
			If $title <> "" Then
				;  Query restart of existing title.
				$restart = 1
				$gamefold = IniRead($inifle, "Current Download", "destination", "")
			EndIf
			$val = _GUICtrlListBox_GetText($List_waiting, 0)
			If $val = "+++ STOP HERE +++" And $restart = "" Then
				; Notify need for removal of STOP entry
				ContinueLoop
			EndIf
			If IniRead($downlist, $val, "rank", "") = 1 Or $restart = 1 Then
				If $restart = 1 Then
					$restart = ""
				Else
					$title = $val
					GUICtrlSetData($Input_download, $title)
					_FileWriteLog($logfle, "Downloaded - " & $title & ".")
					IniWrite($inifle, "Current Download", "title", $title)
					$gamefold = IniRead($downlist, $title, "destination", "")
					IniWrite($inifle, "Current Download", "destination", $gamefold)
					$validate = IniRead($downlist, $title, "verify", "")
					IniWrite($inifle, "Current Download", "verify", $validate)
					$cover = IniRead($downlist, $title, "cover", "")
					IniWrite($inifle, "Current Download", "cover", $cover)
					If $cover = 1 Then
						$image = IniRead($downlist, $title, "image", "")
						IniWrite($inifle, "Current Download", "image", $image)
					EndIf
					RemoveListEntry(0)
				EndIf
				CheckOnShutdown()
				;
				If $minimize = 1 Then
					$flag = @SW_MINIMIZE
				Else
					;$flag = @SW_RESTORE
					$flag = @SW_SHOW
				EndIf
				;$pid = Run(@ComSpec & ' /c gogrepo.py download -id ' & $title & ' "' & $gamefold & '"', @ScriptDir, $flag)
				;AdlibRegister("CheckOnGameDownload", 3000)
			EndIf
		Case $msg = $Button_remove
			; Remove selected entry from the list
			$title = GUICtrlRead($List_waiting)
			If $title <> "" Then
				$ind = _GUICtrlListBox_GetCurSel($List_waiting)
				If $title = "+++ STOP HERE +++" Then
					_GUICtrlListBox_DeleteString($List_waiting, $ind)
					IniDelete($downlist, "Downloads", "stop")
				Else
					$val = _GUICtrlListBox_GetText($List_waiting, $ind)
					If $title = $val Then
						RemoveListEntry($ind)
					EndIf
				EndIf
			EndIf
		Case $msg = $Button_removall
			; Remove all downloads from the list
			$ans = MsgBox(262177, "Remove ALL Query", _
				"This will clear the download list entries." & @LF & @LF & _
				"Do you want to continue?", $wait, $QueueGUI)
			If $ans = 1 Then
				FileDelete($downlist)
				$tot = 0
				ClearDisableEnableRestore()
			EndIf
		Case $msg = $Button_moveup
			; Move selected entry up the list
			$title = GUICtrlRead($List_waiting)
			If $title <> "" Then
				GUICtrlSetState($Button_moveup, $GUI_DISABLE)
				$ind = _GUICtrlListBox_GetCurSel($List_waiting)
				$val = _GUICtrlListBox_GetText($List_waiting, $ind)
				$swap = _GUICtrlListBox_GetText($List_waiting, $ind - 1)
				If $title = $val And $val <> "+++ STOP HERE +++" And $swap <> "+++ STOP HERE +++" Then
					SplashTextOn("", "Please Wait!", 200, 120, Default, Default, 33)
					$tot = IniRead($downlist, $title, "rank", "")
					IniWrite($downlist, $title, "rank", $tot - 1)
					; Read original section entries.
					$section = IniReadSection($downlist, $title)
					; Temporarily rename original.
					_ReplaceStringInFile($downlist, "[" & $title & "]", "[###temporary###]")
					; Swap list entries.
					_GUICtrlListBox_SwapString($List_waiting, $ind, $ind - 1)
					; Original index should now be for swap item instead.
					; Get swap item title.
					$val = _GUICtrlListBox_GetText($List_waiting, $ind)
					; If original title doesn't match swap title continue.
					If $title <> $val Then
						$tot = IniRead($downlist, $val, "rank", "")
						IniWrite($downlist, $val, "rank", $tot + 1)
						; Read swap section entries.
						$swap = IniReadSection($downlist, $val)
						; Rename swap section title to original title.
						_ReplaceStringInFile($downlist, "[" & $val & "]", "[" & $title & "]")
						; Write original section entries to new (originally swap) section.
						IniWriteSection($downlist, $title, $section)
						; Rename temporary (original) section title to swap title.
						_ReplaceStringInFile($downlist, "[###temporary###]", "[" & $val & "]")
						; Write swap section entries to temporary (original) section.
						IniWriteSection($downlist, $val, $swap)
					EndIf
					SplashOff()
					$ind = $ind - 1
					_GUICtrlListBox_SetCurSel($List_waiting, $ind)
					_GUICtrlListBox_ClickItem($List_waiting, $ind)
				Else
					MsgBox(262192, "Move Error", "Not allowed! Remove if a STOP entry." & @LF & @LF _
						& "NOTE -  To remove a STOP entry, just" & @LF _
						& "reselect it and click ADD STOP, or use" & @LF _
						& "the REMOVE Selected button.", 5, $QueueGUI)
				EndIf
			EndIf
		Case $msg = $Button_movedown
			; Move selected entry down the list
			$title = GUICtrlRead($List_waiting)
			If $title <> "" Then
				GUICtrlSetState($Button_movedown, $GUI_DISABLE)
				$ind = _GUICtrlListBox_GetCurSel($List_waiting)
				$val = _GUICtrlListBox_GetText($List_waiting, $ind)
				$swap = _GUICtrlListBox_GetText($List_waiting, $ind + 1)
				If $title = $val And $val <> "+++ STOP HERE +++" And $swap <> "+++ STOP HERE +++" Then
					SplashTextOn("", "Please Wait!", 200, 120, Default, Default, 33)
					$tot = IniRead($downlist, $title, "rank", "")
					IniWrite($downlist, $title, "rank", $tot + 1)
					$section = IniReadSection($downlist, $title)
					_ReplaceStringInFile($downlist, "[" & $title & "]", "[###temporary###]")
					_GUICtrlListBox_SwapString($List_waiting, $ind, $ind + 1)
					$val = _GUICtrlListBox_GetText($List_waiting, $ind)
					If $title <> $val Then
						$tot = IniRead($downlist, $val, "rank", "")
						IniWrite($downlist, $val, "rank", $tot - 1)
						$swap = IniReadSection($downlist, $val)
						_ReplaceStringInFile($downlist, "[" & $val & "]", "[" & $title & "]")
						IniWriteSection($downlist, $title, $section)
						_ReplaceStringInFile($downlist, "[###temporary###]", "[" & $val & "]")
						IniWriteSection($downlist, $val, $swap)
					EndIf
					SplashOff()
					$ind = $ind + 1
					_GUICtrlListBox_SetCurSel($List_waiting, $ind)
					_GUICtrlListBox_ClickItem($List_waiting, $ind)
				Else
					MsgBox(262192, "Move Error", "Not allowed! Remove if a STOP entry." & @LF & @LF _
						& "NOTE -  To remove a STOP entry, just" & @LF _
						& "reselect it and click ADD STOP, or use" & @LF _
						& "the REMOVE Selected button.", 5, $QueueGUI)
				EndIf
			EndIf
		Case $msg = $Button_add
			; Add a stop before selected entry
			$title = GUICtrlRead($List_waiting)
			If $title <> "" Then
				$ind = _GUICtrlListBox_GetCurSel($List_waiting)
				$val = _GUICtrlListBox_GetText($List_waiting, $ind)
				If $title = $val Then
					If $title = "+++ STOP HERE +++" Then
						_GUICtrlListBox_DeleteString($List_waiting, $ind)
						IniDelete($downlist, "Downloads", "stop")
					Else
						_GUICtrlListBox_InsertString($List_waiting, "+++ STOP HERE +++", $ind)
						IniWrite($downlist, "Downloads", "stop", $ind)
					EndIf
				EndIf
			EndIf
		Case $msg = $Checkbox_stop
			; Stop after current download
			If GUICtrlRead($Checkbox_stop) = $GUI_CHECKED Then
				$stop = 1
			Else
				$stop = 4
			EndIf
		Case $msg = $Checkbox_start
			; Automatically start downloading
			If GUICtrlRead($Checkbox_start) = $GUI_CHECKED Then
				$auto = 1
			Else
				$auto = 4
			EndIf
			IniWrite($inifle, "Start Downloading", "auto", $auto)
		Case $msg = $Checkbox_dos
			; Minimize the gogrepo.py DOS Console when it starts
			If GUICtrlRead($Checkbox_dos) = $GUI_CHECKED Then
				$minimize = 1
			Else
				$minimize = 4
			EndIf
		Case $msg = $Combo_shutdown
			; Shutdown options
			$shutdown = GUICtrlRead($Combo_shutdown)
			If $shutdown = "none" Then
				WinSetTitle($QueueGUI, "", "QUEUE & Options")
				WinSetTitle($GOGRepoGUI, "", "GOGRepo GUI")
			Else
				WinSetTitle($QueueGUI, "", "QUEUE & Options - " & $shutdown & " is ENABLED")
				WinSetTitle($GOGRepoGUI, "", "GOGRepo GUI - " & $shutdown & " is ENABLED")
			EndIf
			IniWrite($inifle, "Shutdown", "use", $shutdown)
		Case $msg = $List_waiting
			; List of games waiting to download
			$title = GUICtrlRead($List_waiting)
			If $title <> "" Then
				$ind = _GUICtrlListBox_GetCurSel($List_waiting)
				If $ind = 0 Then
					GUICtrlSetState($Button_moveup, $GUI_DISABLE)
				Else
					GUICtrlSetState($Button_moveup, $GUI_ENABLE)
				EndIf
				$cnt = _GUICtrlListBox_GetCount($List_waiting)
				If $ind < $cnt - 1 Then
					GUICtrlSetState($Button_movedown, $GUI_ENABLE)
				Else
					GUICtrlSetState($Button_movedown, $GUI_DISABLE)
				EndIf
				$val = IniRead($downlist, $title, "OS", "")
				GUICtrlSetData($Input_OP, $val)
				$val = IniRead($downlist, $title, "files", "")
				GUICtrlSetState($Checkbox_files, $val)
				$val = IniRead($downlist, $title, "extras", "")
				GUICtrlSetState($Checkbox_other, $val)
				$val = IniRead($downlist, $title, "language", "")
				GUICtrlSetData($Input_lang, $val)
				$val = IniRead($downlist, $title, "cover", "")
				GUICtrlSetState($Checkbox_image, $val)
				$val = IniRead($downlist, $title, "verify", "")
				GUICtrlSetState($Checkbox_check, $val)
				$val = IniRead($downlist, $title, "destination", "")
				GUICtrlSetData($Input_destination, $val)
			EndIf
		Case Else
			;;;
		EndSelect
	WEnd
EndFunc ;=> QueueGUI

Func SetupGUI()
	; Script generated by GUIBuilder Prototype 0.9
	Local $Button_attach, $Button_close, $Button_cookie, $Button_install, $Combo_lang, $Combo_langs, $Group_lang, $Group_threads
	Local $Input_pass, $Input_threads, $Input_user, $Label_info, $Label_lang, $Label_langs, $Label_pass, $Label_threads, $Label_user
	Local $Updown_threads
	;
	Local $combos, $langs, $long, $password, $username
	;
	$SetupGUI = GuiCreate("Setup - Python & Cookie etc", 230, 430, Default, Default, $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU _
											+ $WS_VISIBLE + $WS_CLIPSIBLINGS, $WS_EX_TOPMOST, $GOGRepoGUI)
	GUISetBkColor(0xFFFFB0, $SetupGUI)
	;
	; CONTROLS
	$Label_info = GuiCtrlCreateLabel("Before using gogrepo.py to download your" _
		& @LF & "games, update etc, you need a cookie file." _
		& @LF & "You also need html5lib installed in Python." _
		& @LF & "Both require an active web connection." & @LF _
		& @LF & "Please supply your GOG username (or email)" _
		& @LF & "and password, to have it create a cookie file" _
		& @LF & "to use with GOG." & @LF _
		& @LF & "GOGRepo GUI does not store that detail.", 11, 10, 210, 130)
	;
	$Button_install = GuiCtrlCreateButton("INSTALL html5lib && html2text", 10, 150, 210, 40)
	GUICtrlSetFont($Button_install, 9, 600)
	GUICtrlSetTip($Button_install, "Install html5lib & html2text in Python!")
	;
	$Group_lang = GuiCtrlCreateGroup("Language(s) - Select One Option", 10, 200, 210, 53)
	$Label_lang = GuiCtrlCreateLabel("User", 20, 220, 37, 21, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_lang, $COLOR_BLUE)
	GUICtrlSetColor($Label_lang, $COLOR_WHITE)
	GUICtrlSetFont($Label_lang, 7, 600, 0, "Small Fonts")
	$Combo_lang = GUICtrlCreateCombo("", 57, 220, 34, 21)
	GUICtrlSetTip($Combo_lang, "User language!")
	$Label_langs = GuiCtrlCreateLabel("Multi", 96, 220, 39, 21, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_langs, $COLOR_BLUE)
	GUICtrlSetColor($Label_langs, $COLOR_WHITE)
	GUICtrlSetFont($Label_langs, 7, 600, 0, "Small Fonts")
	$Combo_langs = GUICtrlCreateCombo("", 135, 220, 50, 21)
	GUICtrlSetTip($Combo_langs, "Multiple languages!")
	$Button_attach = GuiCtrlCreateButton("+", 190, 220, 20, 20)
	GUICtrlSetFont($Button_attach, 9, 600)
	GUICtrlSetTip($Button_attach, "Add a single language or combination (with CTRL to remove)!")
	;
	$Group_threads = GuiCtrlCreateGroup("", 10, 261, 210, 43)
	$Label_threads = GuiCtrlCreateLabel("Downloading Threads", 20, 275, 152, 21, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_threads, $COLOR_MONEYGREEN)
	GUICtrlSetColor($Label_threads, $COLOR_BLACK)
	GUICtrlSetFont($Label_threads, 8, 600)
	$Input_threads = GuiCtrlCreateInput("", 172, 275, 37, 20)
	GUICtrlSetTip($Input_threads, "Number of threads (files) to download with!")
	$Updown_threads = GUICtrlCreateUpdown($Input_threads)
	GUICtrlSetLimit($Updown_threads, 4, 1)
	GUICtrlSetTip($Updown_threads, "Adjust the number of threads to download with!")
	;
	$Label_user = GuiCtrlCreateLabel("User or Email", 10, 315, 80, 20, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_user, $COLOR_BLACK)
	GUICtrlSetColor($Label_user, $COLOR_WHITE)
	GUICtrlSetFont($Label_user, 7, 600, 0, "Small Fonts")
	$Input_user = GuiCtrlCreateInput("", 90, 315, 130, 20)
	GUICtrlSetTip($Input_user, "Username or Email to access your GOG game library!")
	;
	$Label_pass = GuiCtrlCreateLabel("Password", 10, 340, 63, 20, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_pass, $COLOR_BLACK)
	GUICtrlSetColor($Label_pass, $COLOR_WHITE)
	GUICtrlSetFont($Label_pass, 7, 600, 0, "Small Fonts")
	$Input_pass = GuiCtrlCreateInput("", 73, 340, 147, 20)
	GUICtrlSetTip($Input_pass, "Password to access your GOG game library!")
	;
	$Button_cookie = GuiCtrlCreateButton("CREATE COOKIE", 10, 370, 140, 50)
	GUICtrlSetFont($Button_cookie, 9, 600)
	GUICtrlSetTip($Button_cookie, "Create or Update the cookie file!")
	;
	$Button_close = GuiCtrlCreateButton("EXIT", 160, 370, 60, 50, $BS_ICON)
	GUICtrlSetTip($Button_close, "Exit / Close / Quit the window!")
	;
	; SETTINGS
	GUICtrlSetImage($Button_close, $user, $icoX, 1)
	;
	$langs = IniRead($inifle, "Download Languages", "singles", "")
	If $langs = "" Then
		$langs = "||de|en|fr|"
		IniWrite($inifle, "Download Languages", "singles", $langs)
	EndIf
	$combos = IniRead($inifle, "Download Languages", "combined", "")
	If $combos = "" Then
		$combos = "||de en|de fr|fr en|"
		IniWrite($inifle, "Download Languages", "combined", $combos)
	EndIf
	$long = StringLen($lang)
	If $long = 2 Then
		GUICtrlSetData($Combo_lang, $langs, $lang)
		GUICtrlSetData($Combo_langs, $combos, "")
	Else
		GUICtrlSetData($Combo_lang, $langs, "")
		GUICtrlSetData($Combo_langs, $combos, $lang)
	EndIf
	If $tot > 0 Then
		GUICtrlSetState($Button_install, $GUI_DISABLE)
		If $started = 1 Then GUICtrlSetState($Button_cookie, $GUI_DISABLE)
	EndIf
	;
	If $threads = "X" Then
		GUICtrlSetState($Input_threads, $GUI_DISABLE)
		GUICtrlSetState($Updown_threads, $GUI_DISABLE)
	Else
		GUICtrlSetData($Input_threads, $threads)
	EndIf
	;
	$window = $SetupGUI


	GuiSetState()
	While 1
		$msg = GuiGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Button_close
			; Exit / Close / Quit the window
			GUIDelete($SetupGUI)
			ExitLoop
		Case $msg = $Button_install
			; Install html5lib & html2text in Python
			GuiSetState(@SW_DISABLE, $SetupGUI)
			$pid = RunWait(@ComSpec & ' /k pip install html5lib html2text', "")
			GuiSetState(@SW_ENABLE, $SetupGUI)
		Case $msg = $Button_cookie
			; Create or Update the cookie file
			If FileExists($gogrepo) Then
				If FileExists($cookies) Then
					$ans = MsgBox(262177, "Update Query", _
						"An existing cookie file was found." & @LF & @LF & _
						"Do you want to update (overwrite)?", $wait, $SetupGUI)
				Else
					$ans = 1
				EndIf
				If $ans = 1 Then
					$username = GUICtrlRead($Input_user)
					If $username <> "" Then
						$password = GUICtrlRead($Input_pass)
						If $password <> "" Then
							GuiSetState(@SW_DISABLE, $SetupGUI)
							$pid = RunWait(@ComSpec & ' /k gogrepo.py login ' & $username & ' ' & $password, @ScriptDir)
							$username = ""
							$password = ""
							GuiSetState(@SW_ENABLE, $SetupGUI)
						Else
							MsgBox(262192, "Cookie Error", "Password field is blank!", $wait, $SetupGUI)
						EndIf
					Else
						MsgBox(262192, "Cookie Error", "User or Email field is blank!", $wait, $SetupGUI)
					EndIf
				EndIf
			Else
				MsgBox(262192, "Program Error", "Required file 'gogrepo.py' not found!", $wait, $SetupGUI)
			EndIf
		Case $msg = $Button_attach
			; Add a single language or combination
			$val = GUICtrlRead($Combo_langs)
			If $val <> "" And GUICtrlRead($Combo_lang) <> "" Then
				$delay = $wait * 4
				MsgBox(262192, "Add Error", _
					"When adding a new language or combined language entry," & @LF & _
					"the other field should be blank, and you should have typed" & @LF & _
					"over the entry in the field you want to add to." & @LF & @LF & _
					"Try Again!", $delay, $SetupGUI)
				ContinueLoop
			EndIf
			$long = StringLen($val)
			If $long > 3 Then
				$lang = $val
				If _IsPressed("11") Then
					If $lang <> "de en" Then
						If StringInStr($combos, "|" & $lang & "|") > 0 Then
							$combos = StringReplace($combos, "|" & $lang & "|", "|")
							IniWrite($inifle, "Download Languages", "combined", $combos)
							GUICtrlSetData($Combo_langs, "", "")
							$lang = "de en"
							GUICtrlSetData($Combo_langs, $combos, $lang)
						EndIf
					EndIf
				Else
					If StringInStr($combos, "|" & $lang & "|") < 1 Then
						$combos = $combos & $lang & "|"
						IniWrite($inifle, "Download Languages", "combined", $combos)
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
								IniWrite($inifle, "Download Languages", "singles", $langs)
								GUICtrlSetData($Combo_lang, "", "")
								$lang = "en"
								GUICtrlSetData($Combo_lang, $langs, $lang)
							EndIf
						EndIf
					Else
						If StringInStr($langs, "|" & $lang & "|") < 1 Then
							$langs = $langs & $lang & "|"
							IniWrite($inifle, "Download Languages", "singles", $langs)
							GUICtrlSetData($Combo_lang, "", "")
							GUICtrlSetData($Combo_lang, $langs, $lang)
						EndIf
					EndIf
				Else
					$delay = $wait * 2
					MsgBox(262208, "Program Advice", "To remove a language or combined language entry," _
						& @LF & "hold down CTRL while clicking the plus button.", $delay, $SetupGUI)
				EndIf
			EndIf
			IniWrite($inifle, "Download Options", "language", $lang)
			GUISwitch($GOGRepoGUI)
			GUICtrlSetData($Input_langs, $lang)
			GUISwitch($SetupGUI)
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
			IniWrite($inifle, "Download Options", "language", $lang)
			GUISwitch($GOGRepoGUI)
			GUICtrlSetData($Input_langs, $lang)
			GUISwitch($SetupGUI)
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
			IniWrite($inifle, "Download Options", "language", $lang)
			GUISwitch($GOGRepoGUI)
			GUICtrlSetData($Input_langs, $lang)
			GUISwitch($SetupGUI)
		Case $msg = $Updown_threads
			; Adjust the number of threads to download with
			$val = GUICtrlRead($Input_threads)
			If FileExists($gogrepo) Then
				$res = _ReplaceStringInFile($gogrepo, "HTTP_GAME_DOWNLOADER_THREADS = " & $threads, "HTTP_GAME_DOWNLOADER_THREADS = " & $val)
				If $res > 0 Then
					$threads = $val
					IniWrite($inifle, "Downloading", "threads", $threads)
				Else
					GUICtrlSetData($Input_threads, $threads)
				EndIf
				$fdate = FileGetTime($gogrepo, 0, 1)
				IniWrite($inifle, "gogrepo.py", "file_date", $fdate)
			EndIf
		Case Else
			;;;
		EndSelect
	WEnd
EndFunc ;=> SetupGUI

Func UpdateGUI()
	Local $Button_close, $Button_upnow, $Checkbox_every, $Checkbox_new, $Checkbox_resume, $Checkbox_tag, $Input_language
	Local $Input_OSes, $Label_lang
	Local $newgames, $resume, $tagged
	;
	$UpdateGUI = GuiCreate("Update The Manifest", 230, 185, Default, Default, $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU _
															+ $WS_VISIBLE + $WS_CLIPSIBLINGS, $WS_EX_TOPMOST, $GOGRepoGUI)
	GUISetBkColor(0xFFCE9D, $UpdateGUI)
	;
	; CONTROLS
	$Checkbox_every = GUICtrlCreateCheckbox("ALL Games", 10, 10, 75, 20)
	;
	$Label_lang = GuiCtrlCreateLabel("Language", 95, 10, 65, 20, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_lang, $COLOR_BLUE)
	GUICtrlSetColor($Label_lang, $COLOR_WHITE)
	GUICtrlSetFont($Label_lang, 7, 600, 0, "Small Fonts")
	$Input_language = GUICtrlCreateInput("", 160, 10, 60, 20)
	GUICtrlSetTip($Input_language, "Selected language(s)!")
	;
	$Label_OS = GuiCtrlCreateLabel("OS", 10, 40, 35, 20, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_OS, $COLOR_BLUE)
	GUICtrlSetColor($Label_OS, $COLOR_WHITE)
	GUICtrlSetFont($Label_OS, 7, 600, 0, "Small Fonts")
	$Input_OSes = GUICtrlCreateInput("", 45, 40, 105, 20)
	GUICtrlSetTip($Input_OSes, "Selected OS!")
	;
	$Checkbox_resume = GUICtrlCreateCheckbox("Resume", 162, 40, 55, 20)
	GUICtrlSetTip($Checkbox_resume, "Enable resume mode for updating!")
	;
	$Checkbox_new = GUICtrlCreateCheckbox("Add New Games", 10, 70, 100, 20)
	GUICtrlSetTip($Checkbox_new, "Add new games only to the manifest!")
	;
	$Checkbox_tag = GUICtrlCreateCheckbox("Use Update Tag", 124, 70, 95, 20)
	GUICtrlSetTip($Checkbox_tag, "Update games with Update Tag!")
	;
	$Checkbox_skip = GUICtrlCreateCheckbox("Skip Hidden Games  (set in GOG Library)", 10, 95, 210, 20)
	GUICtrlSetTip($Checkbox_skip, "Skip updating the manifest for hidden games!")
	;
	$Button_upnow = GuiCtrlCreateButton("UPDATE NOW", 10, 125, 140, 50)
	GUICtrlSetFont($Button_upnow, 9, 600)
	GUICtrlSetTip($Button_upnow, "Update the Manifest for specified!")
	;
	$Button_close = GuiCtrlCreateButton("EXIT", 160, 125, 60, 50, $BS_ICON)
	GUICtrlSetTip($Button_close, "Exit / Close / Quit the window!")
	;
	; SETTINGS
	GUICtrlSetImage($Button_close, $user, $icoX, 1)
	;
	If $all = 1 Then
		GUICtrlSetState($Checkbox_every, $all)
	EndIf
	GUICtrlSetState($Checkbox_every, $GUI_DISABLE)
	;
	GUICtrlSetData($Input_language, $lang)
	GUICtrlSetState($Input_language, $GUI_DISABLE)
	;
	GUICtrlSetData($Input_OSes, $OSget)
	GUICtrlSetState($Input_OSes, $GUI_DISABLE)
	;
	$resume = IniRead($inifle, "Updating", "resume", "")
	If $resume = "" Then
		$resume = 4
		IniWrite($inifle, "Updating", "resume", $resume)
	EndIf
	GUICtrlSetState($Checkbox_resume, $resume)
	;
	$newgames = IniRead($inifle, "Add New Games Only", "update", "")
	If $newgames = "" Then
		$newgames = 4
		IniWrite($inifle, "Add New Games Only", "update", $newgames)
	EndIf
	GUICtrlSetState($Checkbox_new, $newgames)
	;
	$tagged = IniRead($inifle, "Update Tag", "use", "")
	If $tagged = "" Then
		$tagged = 4
		IniWrite($inifle, "Update Tag", "use", $tagged)
	EndIf
	GUICtrlSetState($Checkbox_tag, $tagged)
	;
	$updating = ""
	;
	$window = $UpdateGUI


	GuiSetState()
	While 1
		$msg = GuiGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Button_close
			; Exit / Close / Quit the window
			GUIDelete($UpdateGUI)
			ExitLoop
		Case $msg = $Button_upnow
			; Update the Manifest for specified
			FileChangeDir(@ScriptDir)
			If $all = 1 Then
				$updating = 1
				$pid = RunWait(@ComSpec & ' /k gogrepo.py update -os ' & $OS & ' -lang ' & $lang, @ScriptDir)
				_FileWriteLog($logfle, "Updated manifest for all games.")
			Else
				If $title <> "" Then
					$updating = 1
					$pid = RunWait(@ComSpec & ' /k gogrepo.py update -os ' & $OS & ' -lang ' & $lang & ' -id ' & $title, @ScriptDir)
					_FileWriteLog($logfle, "Updated manifest for - " & $title & ".")
				Else
					MsgBox(262192, "Game Error", "Title is not selected!", $wait, $UpdateGUI)
					ContinueLoop
				EndIf
			EndIf
			GUIDelete($UpdateGUI)
			ExitLoop
		Case Else
			;;;
		EndSelect
	WEnd
EndFunc ;=> UpdateGUI

Func VerifyGUI()
	Local $Button_close, $Button_verify, $Checkbox_delete, $Checkbox_every, $Checkbox_md5, $Checkbox_size, $Checkbox_zip
	;
	$VerifyGUI = GuiCreate("Verify Game Files", 230, 140, Default, Default, $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU _
														+ $WS_VISIBLE + $WS_CLIPSIBLINGS, $WS_EX_TOPMOST, $GOGRepoGUI)
	GUISetBkColor(0xD7D700, $VerifyGUI)
	;
	; CONTROLS
	$Checkbox_every = GUICtrlCreateCheckbox("ALL Games", 10, 10, 75, 20)
	;
	$Checkbox_size = GUICtrlCreateCheckbox("File Size", 95, 10, 60, 20)
	GUICtrlSetTip($Checkbox_size, "Enable file size verification!")
	;
	$Checkbox_zip = GUICtrlCreateCheckbox("Zip Files", 164, 10, 60, 20)
	GUICtrlSetTip($Checkbox_zip, "Enable zip file verification!")
	;
	$Checkbox_md5 = GUICtrlCreateCheckbox("MD5", 10, 40, 45, 20)
	GUICtrlSetTip($Checkbox_md5, "Enable MD5 checksum verification!")
	;
	$Checkbox_delete = GUICtrlCreateCheckbox("Delete File On Integrity Failure", 62, 40, 165, 20)
	GUICtrlSetTip($Checkbox_delete, "Delete if a file fails integrity check!")
	;
	$Button_verify = GuiCtrlCreateButton("VERIFY NOW", 10, 75, 140, 50)
	GUICtrlSetFont($Button_verify, 9, 600)
	GUICtrlSetTip($Button_verify, "Verify the specified games!")
	;
	$Button_close = GuiCtrlCreateButton("EXIT", 160, 75, 60, 50, $BS_ICON)
	GUICtrlSetTip($Button_close, "Exit / Close / Quit the window!")
	;
	; SETTINGS
	GUICtrlSetImage($Button_close, $user, $icoX, 1)
	;
	If $all = 1 Then
		GUICtrlSetState($Checkbox_every, $all)
	EndIf
	GUICtrlSetState($Checkbox_every, $GUI_DISABLE)
	;
	;
	$window = $VerifyGUI


	GuiSetState()
	While 1
		$msg = GuiGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Button_close
			; Exit / Close / Quit the window
			GUIDelete($VerifyGUI)
			ExitLoop
		Case $msg = $Button_verify
			; Verify the specified games
			FileChangeDir(@ScriptDir)
			If $all = 1 Then
				If $alpha = 1 Then
					For $a = 48 To 90
						If $a < 58 Or $a > 64 Then
							$let = Chr($a)
							$pid = RunWait(@ComSpec & ' /k gogrepo.py verify "' & $gamefold & "\" & $let & '"', @ScriptDir)
							_FileWriteLog($logfle, "Verified all games in " & $let & ".")
							If $a < 90 Then
								$ans = MsgBox(262177, "Verify Query", _
									"The games in alphanumeric folder " & $let & " have just been processed." & @LF & @LF & _
									"Do you want to continue checking the remaining alphanumeric" & @LF & _
									"folder games?", 0, $VerifyGUI)
								If $ans = 2 Then
									ExitLoop
								EndIf
							EndIf
						EndIf
					Next
				Else
					$pid = RunWait(@ComSpec & ' /k gogrepo.py verify "' & $gamefold & '"', @ScriptDir)
					_FileWriteLog($logfle, "Verified all games.")
				EndIf
			Else
				$pid = RunWait(@ComSpec & ' /k gogrepo.py verify -id ' & $title & ' "' & $gamefold & '"', @ScriptDir)
				_FileWriteLog($logfle, "Verified - " & $title & ".")
			EndIf
		Case Else
			;;;
		EndSelect
	WEnd
EndFunc ;=> VerifyGUI


Func AddGameToDownloadList()
	IniWrite($downlist, "Downloads", "total", $tot)
	IniWrite($downlist, $title, "rank", $tot)
	IniWrite($downlist, $title, "destination", $gamefold)
	IniWrite($downlist, $title, "OS", $OSget)
	IniWrite($downlist, $title, "files", $files)
	IniWrite($downlist, $title, "extras", $extras)
	IniWrite($downlist, $title, "language", $lang)
	IniWrite($downlist, $title, "cover", $cover)
	If $cover = 1 Then
		$image = IniRead($gamesfle, $name, "image", "")
		IniWrite($downlist, $title, "image", $image)
	EndIf
	IniWrite($downlist, $title, "verify", $validate)
EndFunc ;=> AddGameToDownloadList

Func CheckIfPythonRunning()
	If $pid = "" Then
		; Checking to see if Python (thus possibly 'gogrepo.py') is already running.
		If ProcessExists("py.exe") Or ProcessExists("python.exe") Then
			$ans = MsgBox(262177, "Potential Issue", _
				"Python is currently running, and it wasn't initiated" & @LF & _
				"by this program in the current session. If Python is" & @LF & _
				"running the same 'gogrepo.py' file as this program" & @LF & _
				"uses, we have a possible potential problem. In that" & @LF & _
				"scenario it is recommended that you wait until that" & @LF & _
				"process has finished or manually stop it yourself." & @LF & @LF & _
				"Do you want to continue?", 0, $GOGRepoGUI)
		EndIf
	EndIf
EndFunc ;=> CheckIfPythonRunning

Func CheckOnGameDownload()
	If FileExists($downlist) Then
		If Not ProcessExists($pid) Then
			$title = IniRead($inifle, "Current Download", "title", "")
			$val = IniRead($inifle, "Current Download", "verify", "")
			If $val = 1 And $verifying = "" Then
				$verifying = 1
				$val = IniRead($inifle, "Current Download", "destination", "")
				If $minimize = 1 Then
					$flag = @SW_MINIMIZE
				Else
					;$flag = @SW_RESTORE
					$flag = @SW_SHOW
				EndIf
				$pid = Run(@ComSpec & ' /k gogrepo.py verify -id ' & $title & ' "' & $val & '"', @ScriptDir, $flag)
				Return
			Else
				$verifying = ""
				If $cover = 1 Then
					$image = IniRead($inifle, "Current Download", "image", "")
					If $image <> "" Then
						SplashTextOn("", "Saving!", 200, 120, Default, Default, 33)
						$gamepic = $gamefold & "\" & $title & "\Folder.jpg"
						InetGet($image, $gamepic, 1, 0)
						SplashOff()
					EndIf
				EndIf
				If $window = $QueueGUI Then
					GUICtrlSetData($Input_download, "")
				EndIf
				If $stop = 1 Then
					$ans = MsgBox(262177, "Stop Query", "STOP has been enabled for downloads." & @LF & @LF & _
						"Do you really want to stop now?" & @LF & @LF & _
						"(continuing with STOP in 9 seconds)", 9, $window)
					If $ans = 2 Then
						$stop = 4
						If $window = $QueueGUI Then GUICtrlSetState($Checkbox_stop, $stop)
						Return
					EndIf
					AdlibUnRegister("CheckOnGameDownload")
				Else
					; Need to check the download list, and if empty unregister.
					$tot = IniRead($downlist, "Downloads", "total", "")
					If $tot > 0 Then
						; DOWNLOAD next game.
						$titles = IniReadSectionNames($downlist)
						If Not @error Then
							If $titles[0] > 1 Then
								$title = $titles[2]
								$val = $title
								_FileWriteLog($logfle, "Downloaded - " & $title & ".")
								IniWrite($inifle, "Current Download", "title", $title)
								$gamefold = IniRead($downlist, $title, "destination", "")
								IniWrite($inifle, "Current Download", "destination", $gamefold)
								$validate = IniRead($downlist, $title, "verify", "")
								IniWrite($inifle, "Current Download", "verify", $validate)
								$cover = IniRead($downlist, $title, "cover", "")
								IniWrite($inifle, "Current Download", "cover", $cover)
								If $cover = 1 Then
									$image = IniRead($downlist, $title, "image", "")
									IniWrite($inifle, "Current Download", "image", $image)
								EndIf
								If $window = $QueueGUI Then
									GUICtrlSetData($Input_download, $title)
									RemoveListEntry(0)
								Else
									IniDelete($downlist, $title)
									$titles = IniReadSectionNames($downlist)
									If Not @error Then
										If $titles[0] > 1 Then
											$tot = 0
											For $t = 2 To $titles[0]
												$title = $titles[$t]
												If $title <> "" Then
													$tot = $tot + 1
													IniWrite($downlist, $title, "rank", $tot)
												EndIf
											Next
										EndIf
									EndIf
									IniWrite($downlist, "Downloads", "total", $tot)
									$title = $val
								EndIf
								Return
							Else
								AdlibUnRegister("CheckOnGameDownload")
							EndIf
						Else
							AdlibUnRegister("CheckOnGameDownload")
						EndIf
					Else
						AdlibUnRegister("CheckOnGameDownload")
					EndIf
				EndIf
			EndIf
			If $shutdown <> "none" Then
				Local $code
				$ans = MsgBox(262193, "Shutdown Query", _
					"PC is set to shutdown in 99 seconds." & @LF & @LF & _
					"OK = Shutdown." & @LF & _
					"CANCEL = Abort shutdown.", 99, $window)
				If $ans = 1 Or $ans = -1 Then
					If $shutdown = "Shutdown" Then
						; Shutdown
						$code = 1 + 4 + 16
					ElseIf $shutdown = "Hibernate" Then
						; Hibernate
						$code = 64
					ElseIf $shutdown = "Standby" Then
						; Standby
						$code = 32
					ElseIf $shutdown = "Powerdown" Then
						; Powerdown
						$code = 8 + 4 + 16
					ElseIf $shutdown = "Logoff" Then
						; Logoff
						$code = 0 + 4 + 16
					ElseIf $shutdown = "Reboot" Then
						; Reboot
						$code = 2 + 4 + 16
					EndIf
					Shutdown($code)
					Exit
				EndIf
			EndIf
		EndIf
	Else
		AdlibUnRegister("CheckOnGameDownload")
		MsgBox(262192, "Program Error", "Huston we have a problem! No 'Downloads.ini' file.", 0, $window)
	EndIf
	If $window <> $GOGRepoGUI Then GUISwitch($GOGRepoGUI)
	GUICtrlSetState($Checkbox_update, $GUI_ENABLE)
	GUICtrlSetState($Checkbox_verify, $GUI_ENABLE)
	GUICtrlSetState($Checkbox_all, $GUI_ENABLE)
	;GUICtrlSetState($Button_setup, $GUI_ENABLE)
	If $window = $QueueGUI Then
		GUISwitch($QueueGUI)
	ElseIf $window = $SetupGUI Then
		GUISwitch($SetupGUI)
	EndIf
EndFunc ;=> CheckOnGameDownload

Func CheckOnShutdown()
	If $shutdown <> "none" Then
		$ans = MsgBox(262452, "Shutdown Alert", _
			"A shutdown option is currently enabled." & @LF & @LF & _
			"YES = Continue." & @LF & _
			"NO = Disable shutdown.", 0, $window)
		If $ans = 7 Then
			$shutdown = "none"
			IniWrite($inifle, "Shutdown", "use", $shutdown)
			If $window = $QueueGUI Then
				WinSetTitle($QueueGUI, "", "QUEUE & Options")
				GUICtrlSetData($Combo_shutdown, $shutdown)
				GUISwitch($GOGRepoGUI)
				WinSetTitle($GOGRepoGUI, "", "GOGRepo GUI")
				GUISwitch($QueueGUI)
			ElseIf $window = $GOGRepoGUI Then
				WinSetTitle($GOGRepoGUI, "", "GOGRepo GUI")
			Else
				GUISwitch($GOGRepoGUI)
				WinSetTitle($GOGRepoGUI, "", "GOGRepo GUI")
				GUISwitch($window)
			EndIf
		EndIf
	EndIf
EndFunc ;=> CheckOnShutdown

Func ClearDisableEnableRestore()
	GUICtrlSetData($List_waiting, "")
	GUICtrlSetData($Input_OP, "")
	GUICtrlSetData($Input_lang, "")
	GUICtrlSetData($Input_destination, "")
	GUICtrlSetState($Checkbox_files, $GUI_UNCHECKED)
	GUICtrlSetState($Checkbox_other, $GUI_UNCHECKED)
	GUICtrlSetState($Checkbox_image, $GUI_UNCHECKED)
	GUICtrlSetState($Checkbox_check, $GUI_UNCHECKED)
	GUICtrlSetState($Button_moveup, $GUI_DISABLE)
	GUICtrlSetState($Button_movedown, $GUI_DISABLE)
	DisableQueueButtons()
	;
	GUISwitch($GOGRepoGUI)
	GUICtrlSetState($Checkbox_update, $GUI_ENABLE)
	GUICtrlSetState($Checkbox_verify, $GUI_ENABLE)
	GUICtrlSetState($Checkbox_all, $GUI_ENABLE)
	;GUICtrlSetState($Button_setup, $GUI_ENABLE)
	GUISwitch($QueueGUI)
EndFunc ;=> ClearDisableEnableRestore

Func DisableQueueButtons()
	If $started = 4 Then GUICtrlSetState($Button_stop, $GUI_DISABLE)
	GUICtrlSetState($Button_start, $GUI_DISABLE)
	GUICtrlSetState($Button_add, $GUI_DISABLE)
	GUICtrlSetState($Button_removall, $GUI_DISABLE)
	GUICtrlSetState($Button_remove, $GUI_DISABLE)
	GUICtrlSetState($Button_edit, $GUI_DISABLE)
EndFunc ;=> DisableQueueButtons

Func EnableDisableControls($state)
	GUICtrlSetState($List_games, $state)
	GUICtrlSetState($Input_name, $state)
	GUICtrlSetState($Input_title, $state)
	GUICtrlSetState($Button_fix, $state)
	;GUICtrlSetState($Input_OS, $state)
	;GUICtrlSetState($Input_extra, $state)
	GUICtrlSetState($Button_more, $state)
	;
	GUICtrlSetState($Pic_cover, $state)
	GUICtrlSetState($Button_pic, $state)
	GUICtrlSetState($Checkbox_show, $state)
	;
	GUICtrlSetState($Button_down, $state)
	GUICtrlSetState($Checkbox_update, $state)
	GUICtrlSetState($Checkbox_verify, $state)
	GUICtrlSetState($Checkbox_all, $state)
	GUICtrlSetState($Button_queue, $state)
	;
	GUICtrlSetState($Combo_OS, $state)
	GUICtrlSetState($Checkbox_extra, $state)
	GUICtrlSetState($Checkbox_test, $state)
	GUICtrlSetState($Checkbox_cover, $state)
	GUICtrlSetState($Checkbox_game, $state)
	;GUICtrlSetState($Input_langs, $state)
	;
	GUICtrlSetState($Button_setup, $state)
	;
	GUICtrlSetState($Combo_dest, $state)
	GUICtrlSetState($Input_dest, $state)
	GUICtrlSetState($Button_dest, $state)
	GUICtrlSetState($Checkbox_alpha, $state)
	GUICtrlSetState($Button_fold, $state)
	GUICtrlSetState($Button_move, $state)
	;
	GUICtrlSetState($Button_log, $state)
	GUICtrlSetState($Button_info, $state)
	GUICtrlSetState($Button_exit, $state)
EndFunc ;=> EnableDisableControls

Func FillTheGamesList()
	If FileExists($titlist) Then
		$res = _FileReadToArray($titlist, $array)
		If $res = 1 Then
			$games = 0
			For $a = 1 To $array[0]
				$line = $array[$a]
				If $line <> "" Then
					$line = StringSplit($line, " | ", 1)
					$name = $line[1]
					GUICtrlSetData($List_games, $name)
					$games = $games + 1
				EndIf
			Next
			If $games > 0 Then GUICtrlSetData($Group_games, "Games  (" & $games & ")")
		EndIf
	EndIf
EndFunc ;=> FillTheGamesList

Func GetWindowPosition()
	$winpos = WinGetPos($GOGRepoGUI, "")
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
EndFunc ;=> GetWindowPosition

Func ParseTheManifest()
	If FileExists($manifest) Then
		SplashTextOn("", "Please Wait!", 200, 120, Default, Default, 33)
		$file = FileOpen($titlist, 2)
		$date = _NowCalc()
		$date = StringReplace($date, "/", "-")
		FileWriteLine($file, "List Created on " & $date)
		$open = FileOpen($manifest, 0)
		$read = FileRead($open)
		FileClose($open)
		$split = "{'bg_url':"
		$chunk = StringSplit($read, $split, 1)
		$chunks = $chunk[0]
		If $chunks > 1 Then
			$textdump = ""
			For $c = 2 To $chunks
				$game = $chunk[$c]
				;$lines = StringSplit($game, @CRLF, 1)
				$segment = StringSplit($game, "'title': '", 1)
				If $segment[0] = 2 Then
					$title = $segment[2]
					$segment = $segment[1]
					If $c = $chunks Then
						$title = StringSplit($title, "'}]", 1)
					Else
						$title = StringSplit($title, "'},", 1)
					EndIf
					$title = $title[1]
					$extras = ""
					$image = ""
					$name = ""
					$OS = ""
					$check = StringSplit($segment, "'os_type': 'linux'", 1)
					If $check[0] > 1 Then $OS = "Linux"
					$check = StringSplit($segment, "'os_type': 'windows'", 1)
					If $check[0] > 1 Then
						If $OS = "" Then
							$OS = "(Windows"
						Else
							$OS = "(Windows + " & $OS
						EndIf
					Else
						If $OS = "" Then
							$OS = " "
						Else
							$OS = "(" & $OS
						EndIf
					EndIf
					$check = StringSplit($segment, "'extras': [],", 1)
					If $check[0] > 1 Then
						If $OS = " " Then
							$OS = ""
						ElseIf $OS <> "" Then
							$OS = $OS & ")"
						EndIf
					Else
						If $OS = "" Or $OS = " " Then
							$OS = "(Extras)"
						Else
							$OS = $OS & " + Extras)"
						EndIf
					EndIf
					If $OS <> "" Then $extras = " " & $OS
					$check = StringSplit($segment, "'image_url': '", 1)
					If $check[0] > 1 Then
						$image = $check[2]
						$check = StringSplit($image, "',", 1)
						$image = $check[1]
						If $image <> "" Then
							$image = " - https:" & $image & ".jpg"
						EndIf
					EndIf
					$check = StringSplit($segment, "'long_title': '", 1)
					If $check[0] > 1 Then
						$name = $check[2]
						$check = StringSplit($name, "',", 1)
						$name = $check[1]
						$name = StringReplace($name, Chr(150), "-")
						$name = StringReplace($name, Chr(151), "-")
						$name = StringReplace($name, Chr(175), "-")
						$name = StringReplace($name, "–", "-")
					Else
						; Cover rarer scenario of double quotes instead of single ones.
						$check = StringSplit($segment, "'long_title': ", 1)
						If $check[0] > 1 Then
							$name = $check[2]
							$check = StringSplit($name, '",', 1)
							$name = StringReplace($check[1], '"', '')
							$name = StringReplace($name, Chr(150), "-")
							$name = StringReplace($name, Chr(151), "-")
							$name = StringReplace($name, Chr(175), "-")
							$name = StringReplace($name, "–", "-")
						EndIf
					EndIf
					FileWriteLine($file, $name & " | " & $title & $extras & $image)
					;IniWrite($gamesfle, $title, "title", $title)
					;IniWrite($gamesfle, $title, "name", $name)
					;IniWrite($gamesfle, $title, "osextra", $OS)
					;IniWrite($gamesfle, $title, "image", $image)
					$text = "[" & $name & "]" & @CRLF
					$text = $text & "title=" & $title & @CRLF
					$text = $text & "name=" & $name & @CRLF
					$OS = StringReplace($OS, "(", "")
					$OS = StringReplace($OS, ")", "")
					$text = $text & "osextra=" & $OS & @CRLF
					$image = StringTrimLeft($image, 3)
					$text = $text & "image=" & $image & @CRLF
					If $textdump = "" Then
						$textdump = $text
					Else
						$textdump = $textdump & $text
					EndIf
				EndIf
				;If $c = 15 Then ExitLoop
			Next
			If $textdump <> "" Then
				$open = FileOpen($gamesfle, 2)
				FileWriteLine($open, $textdump)
				FileClose($open)
			EndIf
		EndIf
		$date = _NowCalc()
		$date = StringReplace($date, "/", "-")
		FileWriteLine($file, "List Completed on " & $date)
		FileClose($file)
		$read = ""
		$textdump = ""
		SplashOff()
	EndIf
EndFunc ;=> ParseTheManifest

Func RemoveListEntry($num)
	IniDelete($downlist, $title)
	$titles = IniReadSectionNames($downlist)
	If Not @error Then
		If $titles[0] > 1 Then
			$tot = 0
			For $t = 2 To $titles[0]
				$title = $titles[$t]
				If $title <> "" Then
					$tot = $tot + 1
					IniWrite($downlist, $title, "rank", $tot)
				EndIf
			Next
		EndIf
	EndIf
	$tot = _GUICtrlListBox_DeleteString($List_waiting, $num)
	If $tot > 0 Then
		GUICtrlSetData($Group_waiting, "Games To Download  (" & $tot & ")")
		If $ind > 0 Then
		$ind = $ind - 1
			_GUICtrlListBox_SetCurSel($List_waiting, $ind)
			_GUICtrlListBox_ClickItem($List_waiting, $ind)
		EndIf
	Else
		GUICtrlSetData($Group_waiting, "Games To Download")
		;
		ClearDisableEnableRestore()
	EndIf
	IniWrite($downlist, "Downloads", "total", $tot)
EndFunc ;=> RemoveListEntry

