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
; DownloadAllGUI(), DownloadGUI(), MainGUI(), QueueGUI(), SetupGUI(), UpdateGUI(), VerifyGUI()
;
; BackupManifestEtc(), CheckForConnection(), CheckIfPythonRunning(), CheckOnGameDownload(), CheckOnShutdown()
; ClearDisableEnableRestore(), CreateListOfGames($for, $file), DisableQueueButtons(), EnableDisableControls($state)
; FillTheGamesList(), GetAllowedName(), GetAuthorAndVersion(), GetTheSize(), GetWindowPosition()
; ParseTheManifest(), RemoveListEntry($num), ReplaceForeignCharacters($text), ShowCorrectImage()

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
#include <Inet.au3>
#include <File.au3>
#include <Date.au3>
#include <Array.au3>

_Singleton("gog-repo-gui-timboli")

Global $Button_add, $Button_dest, $Button_detail, $Button_down, $Button_exit, $Button_find, $Button_fix, $Button_fold
Global $Button_info, $Button_last, $Button_log, $Button_more, $Button_move, $Button_movedown, $Button_moveup
Global $Button_pic, $Button_queue, $Button_removall, $Button_remove, $Button_setup, $Button_start, $Button_stop
Global $Checkbox_all, $Checkbox_alpha, $Checkbox_check, $Checkbox_cover, $Checkbox_extra, $Checkbox_files
Global $Checkbox_game, $Checkbox_image, $Checkbox_linux, $Checkbox_other, $Checkbox_show, $Checkbox_test
Global $Checkbox_update, $Checkbox_verify, $Checkbox_win, $Combo_dest, $Combo_OS, $Combo_shutdown, $Group_done
Global $Group_download, $Group_games, $Group_waiting, $Input_dest, $Input_destination, $Input_download
Global $Input_extra, $Input_lang, $Input_langs, $Input_name, $Input_OP, $Input_OS, $Input_title, $Label_added
Global $Label_cover, $List_done, $List_games, $List_waiting, $Pic_cover, $Progress_bar
;
Global $Menu_games, $Menu_linux, $Menu_list, $Menu_mac, $Menu_windows, $Item_allsort, $Item_allunsort
Global $Item_content, $Item_forum, $Item_library, $Item_linsort, $Item_linunsort, $Item_macsort, $Item_macunsort
Global $Item_store, $Item_winsort, $Item_winunsort
;
Global $Control_1, $Control_2, $Control_3, $Control_4, $Control_5
;
Global $a, $addlist, $alf, $all, $alpha, $ans, $array, $auth, $auto, $backups, $bargui, $bigpic, $blackjpg, $c
Global $check, $chunk, $chunks, $cnt, $connection, $cookies, $cover, $date, $delay, $delete, $dest, $done, $down
Global $downall, $downlist, $DownloadAllGUI, $DownloadGUI, $downlog, $drv, $extras, $fdate, $file, $files, $finished
Global $flag, $for, $forum, $galaxy, $game, $gamefold, $gamepic, $games, $gamesfle, $gamesfold, $gogrepo, $GOGRepoGUI
Global $height, $icoD, $icoF, $icoI, $icoS, $icoT, $icoX, $image, $imgfle, $ind, $infofle, $inifle, $lang, $langskip
Global $last, $latest, $left, $line, $lines, $locations, $logfle, $manifest, $md5, $minimize, $name, $num, $open, $OS
Global $OSextras, $OSget, $osskip, $path, $percent, $pid, $progbar, $progress, $QueueGUI, $read, $res, $script, $segment
Global $SetupGUI, $shared, $shell, $shutdown, $size, $sizecheck, $skiplang, $skipos, $split, $standalone, $started
Global $state, $stop, $store, $style, $t, $text, $textdump, $threads, $title, $titles, $titlist, $top, $tot, $total
Global $type, $update, $updated, $UpdateGUI, $updating, $user, $val, $validate, $validation, $verify, $VerifyGUI
Global $verifying, $vers, $version, $wait, $width, $window, $winpos, $xpos, $ypos, $zipcheck

$addlist = @ScriptDir & "\Added.txt"
$backups = @ScriptDir & "\Backups"
$bigpic = @ScriptDir & "\Big.jpg"
$blackjpg = @ScriptDir & "\Black.jpg"
$cookies = @ScriptDir & "\gog-cookies.dat"
$downlist = @ScriptDir & "\Downloads.ini"
$finished = @ScriptDir & "\Finished.txt"
$gamesfle = @ScriptDir & "\Games.ini"
$gogrepo = @ScriptDir & "\gogrepo.py"
$imgfle = @ScriptDir & "\Image.jpg"
$infofle = @ScriptDir & "\Game Info.html"
$inifle = @ScriptDir & "\Settings.ini"
$locations = @ScriptDir & "\Locations.ini"
$logfle = @ScriptDir & "\Record.log"
$manifest = @ScriptDir & "\gog-manifest.dat"
$progbar = @ScriptDir & "\Reporun.exe"
$titlist = @ScriptDir & "\Titles.txt"
$version = "v1.0"

If Not FileExists($titlist) Then _FileCreate($titlist)

$bargui = IniRead($inifle, "Floating Progress Bar GUI", "use", "")
If FileExists($progbar) Then
	If $bargui = "" Then
		$bargui = 4
		IniWrite($inifle, "Floating Progress Bar GUI", "use", $bargui)
	EndIf
Else
	If $bargui = 1 Or $bargui = "" Then
		$bargui = 4
		IniWrite($inifle, "Floating Progress Bar GUI", "use", $bargui)
	EndIf
EndIf

If FileExists($titlist) Then
	$updated = IniRead($inifle, "Program", "updated", "")
	$lines = _FileCountLines($titlist)
	If $lines = 0 Or $updated <> 1 Then
		ParseTheManifest()
		$updated = 1
		IniWrite($inifle, "Program", "updated", $updated)
	EndIf
	MainGUI()
Else
	MsgBox(262192, "Program Error", "Titles.txt file could not be created!", 0)
EndIf

Exit

Func MainGUI()
	Local $Group_added, $Group_cover, $Group_dest, $Group_down, $Group_update, $Label_extra, $Label_OS, $Label_title
	;
	Local $add, $content, $dll, $exist, $find, $fold, $mpos, $OSes, $pth, $show
	;
	$width = 590
	$height = 405
	$left = IniRead($inifle, "Program Window", "left", @DesktopWidth - $width - 25)
	$top = IniRead($inifle, "Program Window", "top", @DesktopHeight - $height - 30)
	$style = $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU + $WS_CLIPSIBLINGS + $WS_MINIMIZEBOX ; + $WS_VISIBLE
	$GOGRepoGUI = GuiCreate("GOGRepo GUI", $width, $height, $left, $top, $style, $WS_EX_TOPMOST)
	GUISetBkColor($COLOR_SKYBLUE, $GOGRepoGUI)
	;GuiSetState(@SW_DISABLE, $GOGRepoGUI)
	; CONTROLS
	$Group_games = GuiCtrlCreateGroup("Games", 10, 10, 370, 323)
	$List_games = GuiCtrlCreateList("", 20, 30, 350, 220)
	GUICtrlSetBkColor($List_games, 0xBBFFBB)
	GUICtrlSetTip($List_games, "List of games!")
	$Input_name = GUICtrlCreateInput("", 20, 250, 305, 20)
	GUICtrlSetBkColor($Input_name, 0xFFFFB0)
	GUICtrlSetTip($Input_name, "Game Name!")
	$Button_last = GuiCtrlCreateButton("Last", 330, 249, 40, 22)
	GUICtrlSetFont($Button_last, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_last, "Find the latest added game(s)!")
	$Label_title = GuiCtrlCreateLabel("Title", 20, 275, 38, 20, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN + $SS_NOTIFY)
	GUICtrlSetBkColor($Label_title, $COLOR_BLUE)
	GUICtrlSetColor($Label_title, $COLOR_WHITE)
	GUICtrlSetFont($Label_title, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Label_title, "Click to restore last search text to Title input field!")
	$Input_title = GUICtrlCreateInput("", 58, 275, 250, 20) ;, $ES_READONLY
	GUICtrlSetBkColor($Input_title, 0xBBFFBB)
	GUICtrlSetTip($Input_title, "Game Title!")
	$Button_find = GuiCtrlCreateButton("?", 311, 274, 22, 22, $BS_ICON)
	;GUICtrlSetFont($Button_find, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_find, "Find the specified game title on list!")
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
	$Button_detail = GuiCtrlCreateButton("INFO", 320, 299, 50, 22)
	GUICtrlSetFont($Button_detail, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_detail, "View the information from manifest!")
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
	$Checkbox_extra = GUICtrlCreateCheckbox("Extras", 466, 273, 45, 21)
	GUICtrlSetFont($Checkbox_extra, 7, 400, 0, "Small Fonts")
	GUICtrlSetTip($Checkbox_extra, "Download game extras files!")
	$Checkbox_cover = GUICtrlCreateCheckbox("Download the cover", 400, 293, 115, 20)
	GUICtrlSetFont($Checkbox_cover, 8, 400)
	GUICtrlSetTip($Checkbox_cover, "Download the cover image files!")
;~ 	$Checkbox_game = GUICtrlCreateCheckbox("Game Files", 400, 313, 67, 20)
;~ 	GUICtrlSetFont($Checkbox_game, 7, 400, 0, "Small Fonts")
;~ 	GUICtrlSetTip($Checkbox_game, "Download the game files!")
	;$Input_langs = GUICtrlCreateInput("", 475, 313, 35, 18, $ES_READONLY)
	$Input_langs = GUICtrlCreateInput("", 472, 313, 38, 18, $ES_READONLY)
	GUICtrlSetBkColor($Input_langs, 0xFFD5FF)
	GUICtrlSetFont($Input_langs, 9, 400, 0, "MS Serif")
	GUICtrlSetTip($Input_langs, "Download language(s)!")
	;
	$Group_added = GuiCtrlCreateGroup("Added", 530, 233, 50, 45)
	GUICtrlSetFont($Group_added, 7, 400, 0, "Small Fonts")
	$Label_added = GuiCtrlCreateLabel("0", 536, 246, 38, 26, $SS_CENTER + $SS_CENTERIMAGE)
	GUICtrlSetFont($Label_added, 8.5, 600)
	GUICtrlSetBkColor($Label_added, $COLOR_BLACK)
	GUICtrlSetColor($Label_added, $COLOR_WHITE)
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
	$Button_setup = GuiCtrlCreateButton("SETUP", $width - 129, $height - 55, 60, 22)
	GUICtrlSetFont($Button_setup, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_setup, "Setup username and password!")
	;
	$Button_log = GuiCtrlCreateButton("LOG", $width - 129, $height - 30, 60, 20)
	GUICtrlSetFont($Button_log, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_log, "View the record log file!")
	;
	$Button_info = GuiCtrlCreateButton("Info", $width - 60, $height - 118, 50, 50, $BS_ICON)
	GUICtrlSetTip($Button_info, "Program Information!")
	;
	$Button_exit = GuiCtrlCreateButton("EXIT", $width - 60, $height - 60, 50, 50, $BS_ICON)
	GUICtrlSetTip($Button_exit, "Exit / Close / Quit the program!")
	;
	; CONTEXT MENU
	$Menu_list = GUICtrlCreateContextMenu($List_games)
	$Item_store = GUICtrlCreateMenuItem("Go to Store page", $Menu_list)
	GUICtrlCreateMenuItem("", $Menu_list)
	$Item_forum = GUICtrlCreateMenuItem("Go to Forum page", $Menu_list)
	GUICtrlCreateMenuItem("", $Menu_list)
	$Item_library = GUICtrlCreateMenuItem("Go to Library page", $Menu_list)
	GUICtrlCreateMenuItem("", $Menu_list)
	GUICtrlCreateMenuItem("", $Menu_list)
	$Item_content = GUICtrlCreateMenuItem("Folder Content", $Menu_list)
	GUICtrlCreateMenuItem("", $Menu_list)
	GUICtrlCreateMenuItem("", $Menu_list)
	$Menu_games = GUICtrlCreateMenu("ALL Games", $Menu_list)
	$Item_allsort = GUICtrlCreateMenuItem("Sorted List", $Menu_games)
	$Item_allunsort = GUICtrlCreateMenuItem("Unsorted List", $Menu_games)
	GUICtrlCreateMenuItem("", $Menu_list)
	$Menu_linux = GUICtrlCreateMenu("Linux Games", $Menu_list)
	$Item_linsort = GUICtrlCreateMenuItem("Sorted List", $Menu_linux)
	$Item_linunsort = GUICtrlCreateMenuItem("Unsorted List", $Menu_linux)
	GUICtrlCreateMenuItem("", $Menu_list)
	$Menu_mac = GUICtrlCreateMenu("MAC Games", $Menu_list)
	$Item_macsort = GUICtrlCreateMenuItem("Sorted List", $Menu_mac)
	$Item_macunsort = GUICtrlCreateMenuItem("Unsorted List", $Menu_mac)
	GUICtrlCreateMenuItem("", $Menu_list)
	$Menu_windows = GUICtrlCreateMenu("Windows Games (only)", $Menu_list)
	$Item_winsort = GUICtrlCreateMenuItem("Sorted List", $Menu_windows)
	$Item_winunsort = GUICtrlCreateMenuItem("Unsorted List", $Menu_windows)
	;
	; OS SETTINGS
	$user = @SystemDir & "\user32.dll"
	$shell = @SystemDir & "\shell32.dll"
	$icoD = -4
	$icoF = -85
	$icoI = -5
	$icoS = -23
	$icoT = -71
	$icoX = -4
	GUICtrlSetImage($Button_find, $shell, $icoS, 0)
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
		GUICtrlSetState($Button_detail, $GUI_DISABLE)
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
;~ 	$files = IniRead($inifle, "Download Options", "files", "")
;~ 	If $files = "" Then
;~ 		$files = 1
;~ 		IniWrite($inifle, "Download Options", "files", $files)
;~ 	EndIf
;~ 	GUICtrlSetState($Checkbox_game, $files)
	;
	$dests = "Default|Specific"
	GUICtrlSetData($Combo_dest, $dests, "Default")
	$dest = IniRead($inifle, "Main Games Folder", "path", "")
	If $dest = "" Then
		$dest = @ScriptDir & "\GAMES"
		IniWrite($inifle, "Main Games Folder", "path", $dest)
		If Not FileExists($dest) Then DirCreate($dest)
	EndIf
	GUICtrlSetData($Input_dest, $dest)
	$gamesfold = $dest
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
		$auth = IniRead($inifle, "gogrepo.py", "author", "")
		$vers = IniRead($inifle, "gogrepo.py", "version", "")
		$fdate = IniRead($inifle, "gogrepo.py", "file_date", "")
		If $fdate = "" Then
			GetAuthorAndVersion()
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
				GetAuthorAndVersion()
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
				If $auth = "" Or $vers = "" Then GetAuthorAndVersion()
				$threads = IniRead($inifle, "Downloading", "threads", "")
				If $threads = "" Then
					$threads = "X"
					IniWrite($inifle, "Downloading", "threads", $threads)
				EndIf
			EndIf
		EndIf
	Else
		GUICtrlSetState($Button_down, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_update, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_verify, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_all, $GUI_DISABLE)
		GUICtrlSetState($Button_queue, $GUI_DISABLE)
		GUICtrlSetState($Button_setup, $GUI_DISABLE)
	EndIf
	If $auth = "eddie3" Or $auth <> "eddie3,kalynr" Then
		;eddie3-0.3a
		$script = "default"
	ElseIf $auth = "eddie3,kalynr" Then
		;eddie3,kalynr-k0.3a
		$script = "fork"
	EndIf
	If $script = "default" Then
		$Checkbox_game = GUICtrlCreateCheckbox("Game Files", 400, 313, 67, 20)
		GUICtrlSetFont($Checkbox_game, 7, 400, 0, "Small Fonts")
		GUICtrlSetTip($Checkbox_game, "Download the game files!")
		$files = IniRead($inifle, "Download Options", "files", "")
		If $files = "" Then
			$files = 1
			IniWrite($inifle, "Download Options", "files", $files)
		EndIf
		GUICtrlSetState($Checkbox_game, $files)
	Else
		$Button_more = GUICtrlCreateButton("MORE", 400, 313, 62, 20)
		GUICtrlSetFont($Button_more, 7, 600, 0, "Small Fonts")
		GUICtrlSetTip($Button_more, "More download options!")
		;
		$downlog = IniRead($inifle, "Download", "log", "")
		If $downlog = "" Then
			$downlog = 1
			IniWrite($inifle, "Download", "log", $downlog)
		EndIf
		$standalone = IniRead($inifle, "Download", "standalone", "")
		If $standalone = "" Then
			$standalone = 1
			IniWrite($inifle, "Download", "standalone", $standalone)
		EndIf
		$shared = IniRead($inifle, "Download", "shared", "")
		If $shared = "" Then
			$shared = 1
			IniWrite($inifle, "Download", "shared", $shared)
		EndIf
		$galaxy = IniRead($inifle, "Download", "galaxy", "")
		If $galaxy = "" Then
			$galaxy = 4
			IniWrite($inifle, "Download", "galaxy", $galaxy)
		EndIf
		;
		$skipos = IniRead($inifle, "Skip Files", "OS", "")
		If $skipos = "" Then
			$skipos = 4
			IniWrite($inifle, "Skip Files", "OS", $skipos)
		EndIf
		$osskip = IniRead($inifle, "Skip Files", "OSes", "")
		;
		$skiplang = IniRead($inifle, "Skip Files", "language", "")
		If $skiplang = "" Then
			$skiplang = 4
			IniWrite($inifle, "Skip Files", "language", $skiplang)
		EndIf
		$langskip = IniRead($inifle, "Skip Files", "languages", "")
	EndIf
	;
	FillTheGamesList()
	;
	$sizecheck = IniRead($inifle, "Verify", "size", "")
	If $sizecheck = "" Then
		$sizecheck = 1
		IniWrite($inifle, "Verify", "size", $sizecheck)
	EndIf
	;
	$zipcheck = IniRead($inifle, "Verify", "zips", "")
	If $zipcheck = "" Then
		$zipcheck = 1
		IniWrite($inifle, "Verify", "zips", $zipcheck)
	EndIf
	;
	$md5 = IniRead($inifle, "Verify", "md5", "")
	If $md5 = "" Then
		$md5 = 1
		IniWrite($inifle, "Verify", "md5", $md5)
	EndIf
	;
	$delete = IniRead($inifle, "Verify Failure", "delete", "")
	If $delete = "" Then
		$delete = 4
		IniWrite($inifle, "Verify Failure", "delete", $delete)
	EndIf
	;
	$downall = IniRead($inifle, "Download ALL", "activated", "")
	If $downall = "" Then
		$downall = 4
		IniWrite($inifle, "Download ALL", "activated", $downall)
	EndIf
	If $downall = 1 Then
		GUICtrlSetState($Checkbox_all, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_update, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_verify, $GUI_DISABLE)
	EndIf
	;
	$all = 4
	$connection = ""
	$done = 0
	$down = ""
	$find = ""
	$last = ""
	$percent = 0
	$started = 4
	;$total = 0
	$update = 4
	$verify = 4
	$wait = 0
	;
	$minimize = 4
	IniWrite($inifle, "Progress Bar Or Console", "minimize", $minimize)
	;
	$pid = ""
	$tot = IniRead($downlist, "Downloads", "total", 0)
	If $tot > 0 Then
		$tot = IniReadSectionNames($downlist)
		$tot = $tot[0] - 1
		If $tot = 0 Then
			IniWrite($downlist, "Downloads", "total", $tot)
		EndIf
	EndIf
	$title = IniRead($inifle, "Current Download", "title", "")
	If $title <> "" Then
		$ans = MsgBox(262177 + 256, "Restore Query", _
			"It appears that the last download did not complete." & @LF & @LF & _
			$title & @LF & @LF & _
			"Do you want to restore it to the download list?" & @LF & @LF & _
			"OK = Restore & Disable any 'Auto' start." & @LF & _
			"CANCEL = Ignore & Remove the record.", 0, $GOGRepoGUI)
		If $ans = 1 Then
			$tot = $tot + 1
			IniWrite($downlist, "Downloads", "total", $tot)
			IniWrite($downlist, $title, "rank", $tot)
			$val = IniRead($inifle, "Current Download", "destination", "")
			IniWrite($downlist, $title, "destination", $val)
			If $script = "default" Then
				$val = IniRead($inifle, "Current Download", "files", "")
				IniWrite($downlist, $title, "files", $val)
			Else
				$val = IniRead($inifle, "Current Download", "standalone", "")
				IniWrite($downlist, $title, "standalone", $val)
				$val = IniRead($inifle, "Current Download", "galaxy", "")
				IniWrite($downlist, $title, "galaxy", $val)
				$val = IniRead($inifle, "Current Download", "shared", "")
				IniWrite($downlist, $title, "shared", $val)
				$val = IniRead($inifle, "Current Download", "log", "")
				IniWrite($downlist, $title, "log", $val)
				;
				$val = IniRead($inifle, "Current Download", "language", "")
				IniWrite($downlist, $title, "language", $val)
				$val = IniRead($inifle, "Current Download", "languages", "")
				IniWrite($downlist, $title, "languages", $val)
				$val = IniRead($inifle, "Current Download", "OS", "")
				IniWrite($downlist, $title, "OS", $val)
				$val = IniRead($inifle, "Current Download", "OSes", "")
				IniWrite($downlist, $title, "OSes", $val)
			EndIf
			$val = IniRead($inifle, "Current Download", "extras", "")
			IniWrite($downlist, $title, "extras", $val)
			$val = IniRead($inifle, "Current Download", "cover", "")
			IniWrite($downlist, $title, "cover", $val)
			$val = IniRead($inifle, "Current Download", "image", "")
			IniWrite($downlist, $title, "image", $val)
			$val = IniRead($inifle, "Current Download", "verify", "")
			IniWrite($downlist, $title, "verify", $val)
			$val = IniRead($inifle, "Current Download", "md5", "")
			IniWrite($downlist, $title, "md5", $val)
			$val = IniRead($inifle, "Current Download", "size", "")
			IniWrite($downlist, $title, "size", $val)
			$val = IniRead($inifle, "Current Download", "zips", "")
			IniWrite($downlist, $title, "zips", $val)
			$val = IniRead($inifle, "Current Download", "delete", "")
			IniWrite($downlist, $title, "delete", $val)
			If $auto = 1 Then
				$auto = 4
				IniWrite($inifle, "Start Downloading", "auto", $auto)
			EndIf
		EndIf
		IniDelete($inifle, "Current Download")
	EndIf
	$total = $tot
	If $total > 0 Then
		GUICtrlSetData($Label_added, $total)
		GUICtrlSetBkColor($Label_added, $COLOR_GREEN)
	EndIf
	;
	$window = $GOGRepoGUI

	;GuiSetState(@SW_ENABLE, $GOGRepoGUI)
	GuiSetState(@SW_SHOWNORMAL, $GOGRepoGUI)
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
			GuiSetState(@SW_DISABLE, $GOGRepoGUI)
			SetupGUI()
			GuiSetState(@SW_ENABLE, $GOGRepoGUI)
			$window = $GOGRepoGUI
		Case $msg = $Button_queue
			; View the download queue
			GetWindowPosition()
			GuiSetState(@SW_HIDE, $GOGRepoGUI)
			QueueGUI()
			$window = $GOGRepoGUI
			GuiSetState(@SW_SHOW, $GOGRepoGUI)
			; And $total = 0
			If $downall = 4 And $started = 4 And ($pid = "" Or $pid = 0) Then
				GUICtrlSetState($Checkbox_all, $GUI_ENABLE)
				GUICtrlSetState($Checkbox_update, $GUI_ENABLE)
				GUICtrlSetState($Checkbox_verify, $GUI_ENABLE)
			EndIf
		Case $msg = $Button_pic
			; Download the selected image
			$name = GUICtrlRead($Input_name)
			If $name <> "" Then
				$image = IniRead($gamesfle, $name, "image", "")
				If $image <> "" Then
					$delay = $wait * 2
					$ans = MsgBox(262177 + 256, "Save Query", _
						"Save cover image to game folder?" & @LF & @LF & _
						"CANCEL = Save to program folder.", $delay, $GOGRepoGUI)
					SplashTextOn("", "Saving!", 200, 120, Default, Default, 33)
					If $ans = 1 Then
						$gamepic = ""
						$title = GUICtrlRead($Input_title)
						If $title <> "" Then
							$gamesfold = GUICtrlRead($Input_dest)
							$gamefold = $gamesfold & "\" & $title
							If $alpha = 1 Then
								$alf = StringUpper(StringLeft($title, 1))
								$gamefold = $gamefold & "\" & $alf
							EndIf
							If FileExists($gamefold) Then
								$gamepic = $gamefold & "\Folder.jpg"
							Else
								MsgBox(262192, "Save Error", "Game folder not found!", 2, $GOGRepoGUI)
							EndIf
						Else
							MsgBox(262192, "Title Error", "A game is not selected!", 2, $GOGRepoGUI)
						EndIf
					Else
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
					EndIf
					If $gamepic <> "" Then
						InetGet($image, $gamepic, 1, 0)
						If Not FileExists($gamepic) Then
							InetGet($image, $gamepic, 0, 0)
							If Not FileExists($gamepic) Then
								InetGet($image, $gamepic, 0, 1)
							EndIf
						EndIf
					EndIf
					SplashOff()
				Else
					MsgBox(262192, "Save Error", "Cover image URL not found!", 2, $GOGRepoGUI)
				EndIf
			Else
				MsgBox(262192, "Title Error", "A game is not selected!", $wait, $GOGRepoGUI)
			EndIf
		Case $msg = $Button_move
			; Relocate game files
			MsgBox(262192, "Program Advice", "This feature not yet enabled!", 2, $GOGRepoGUI)
		Case $msg = $Button_more And $script = "fork"
			; More download options
			GuiSetState(@SW_DISABLE, $GOGRepoGUI)
			DownloadGUI()
			GuiSetState(@SW_ENABLE, $GOGRepoGUI)
			$window = $GOGRepoGUI
		Case $msg = $Button_log
			; View the record log file
			If FileExists($logfle) Then ShellExecute($logfle)
		Case $msg = $Button_last
			; Find the latest added game(s)
			If _IsPressed("11") Then $last = ""
			If FileExists($addlist) Then
				$res = _FileReadToArray($addlist, $latest)
				If $res = 1 Then
					If $last = "" Then
						$last = $latest[0]
						$name = $latest[$last]
					Else
						If $last > 1 Then
							$last = $last - 1
						Else
							$last = $latest[0]
						EndIf
						$name = $latest[$last]
					EndIf
					;GUICtrlSetData($Input_name, $name)
					$ind = _GUICtrlListBox_SelectString($List_games, $name, -1)
					If $ind > -1 Then
						_GUICtrlListBox_SetCurSel($List_games, $ind)
						_GUICtrlListBox_ClickItem($List_games, $ind)
					EndIf
				Else
					MsgBox(262192, "Read Error", "Added.txt file not read!", $wait, $GOGRepoGUI)
				EndIf
			Else
				MsgBox(262192, "File Error", "Added.txt file not found!", $wait, $GOGRepoGUI)
			EndIf
		Case $msg = $Button_info
			; Program Information
			$delay = $wait * 5
			$ans = MsgBox(262209, "Program Information", _
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
				"© June 2020 - GOGRepo GUI created by Timboli (aka TheSaint)." & @LF & @LF & _
				"OK = More Information.", $delay, $GOGRepoGUI)
			If $ans = 1 Then
				MsgBox(262208, "Program Information (cont.)", _
					"The FIND button has two search methods." & @LF & _
					"(1) Look for an entry starting with the specified text." & @LF & _
					"(2) Look for an entry that contains it (use with CTRL key)." & @LF & @LF & _
					"The LAST button will start over if used with the CTRL key." & @LF & @LF & _
					"Some of what is available for downloading, is determined" & @LF & _
					"by what is stored in the mainfest file after any Update, so" & @LF &  _
					"be sure to set the OSes and Languages before any Update." & @LF & _
					"However extras and game files are also determined by the" & @LF & _
					"Download options set. WARNING - OSes not specified for" & @LF & _
					"an Update, will be removed from the manifest during that" & @LF & _
					"Update, if they already exist." & @LF & @LF & _
					"Update and Download will require an Internet connection," & @LF & _
					"but Verify doesn't." & @LF & @LF & _
					"The 'Games' list has some right-click options." & @LF & @LF & _
					"The program becomes disabled during some processes," & @LF & _
					"or some options (controls) are disabled (unavailable)." & @LF & @LF & _
					"Seek help for both 'gogrepo.py' and GOGRepo GUI at the" & @LF & _
					"GOG Forum.  I AM NOT responsible for 'gogrepo.py' and" & @LF & _
					"you use my frontend GUI for it at your own risk. Enjoy!", $delay, $GOGRepoGUI)
			EndIf
		Case $msg = $Button_fold
			; Open the selected Game folder
			If FileExists($gamesfold) Then
				GUISetState(@SW_MINIMIZE, $GOGRepoGUI)
				$title = GUICtrlRead($Input_title)
				If $title <> "" Then
					$gamefold = $gamesfold
					If $alpha = 1 Then
						$alf = StringUpper(StringLeft($title, 1))
						$gamefold = $gamefold & "\" & $alf
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
		Case $msg = $Button_fix
			; Click to convert text in input field
			$title = GUICtrlRead($Input_title)
			If $title <> "" Then
				$find = $title
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
		Case $msg = $Button_find
			; Find the specified game title on list
			$title = GUICtrlRead($Input_title)
			If $title <> "" Then
				$find = $title
				$ind = _GUICtrlListBox_GetCurSel($List_games)
				If _IsPressed("11") Then
					$ind = _GUICtrlListBox_FindInText($List_games, $title, $ind, True)
				Else
					$ind = _GUICtrlListBox_SelectString($List_games, $title, $ind)
				EndIf
				If $ind > -1 Then
					_GUICtrlListBox_SetCurSel($List_games, $ind)
					_GUICtrlListBox_ClickItem($List_games, $ind)
				EndIf
			EndIf
		Case $msg = $Button_down
			; Download the selected game
			If FileExists($gogrepo) Then
				$ans = ""
				CheckIfPythonRunning()
				If $ans = 2 Then ContinueLoop
				;
				$title = GUICtrlRead($Input_title)
				$name = GUICtrlRead($List_games)
				If $name = GUICtrlRead($Input_name) Then
					If ($title <> "" And $name <> "") Or $all = 1 Then
						$gamesfold = $dest
						If $update = 4 And $gamesfold <> "" Then
							If $all = 1 Then
								$gamefold = $gamesfold
							Else
								;$path = IniRead($gamesfle, $name, "path", "")
								$path = IniRead($locations, $name, "path", "")
								If $path <> "" Then
									$gamesfold = $path
								EndIf
								$gamefold = $gamesfold
								If $alpha = 1 Then
									$alf = StringUpper(StringLeft($title, 1))
									$gamefold = $gamefold & "\" & $alf
									;MsgBox(262192, "Got Here 2", $title & @LF & $gamefold, $wait, $GOGRepoGUI)
								EndIf
							EndIf
							$drv = StringLeft($gamefold, 3)
							If FileExists($drv) Then
								If Not FileExists($gamefold) And $verify = 4 Then
									DirCreate($gamefold)
								EndIf
							EndIf
						EndIf
						If FileExists($gamefold) Or $update = 1 Then
							If $verify = 1 Then
								; Verify one or more games
								EnableDisableControls($GUI_DISABLE)
								VerifyGUI()
								$window = $GOGRepoGUI
								EnableDisableControls($GUI_ENABLE)
							ElseIf $update = 1 Then
								; Update the manifest
								;$find = $title
								EnableDisableControls($GUI_DISABLE)
								$OSget = GUICtrlRead($Combo_OS)
								$OS = StringReplace($OSget, " + ", " ")
								$OS = StringLower($OS)
								$title = GUICtrlRead($Input_title)
								UpdateGUI()
								$window = $GOGRepoGUI
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
									DownloadAllGUI()
									_GUICtrlListBox_SetCurSel($List_games, -1)
									GUICtrlSetData($Input_name, "")
									GUICtrlSetData($Input_title, "")
									GUICtrlSetData($Input_OS, "")
									GUICtrlSetData($Input_extra, "")
									If $downall = 1 Then
										$all = 4
										GUICtrlSetState($Checkbox_all, $all)
										GUICtrlSetState($Checkbox_all, $GUI_DISABLE)
										$buttitle = "Down" & @LF & "One"
										GUICtrlSetTip($Button_down, "Download the selected game!")
										GUICtrlSetData($Button_down, $buttitle)
										GUICtrlSetState($Checkbox_update, $GUI_DISABLE)
										GUICtrlSetState($Checkbox_verify, $GUI_DISABLE)
										GetWindowPosition()
										GuiSetState(@SW_HIDE, $GOGRepoGUI)
										QueueGUI()
										$window = $GOGRepoGUI
										GuiSetState(@SW_SHOW, $GOGRepoGUI)
										If $downall = 4 Then
											GUICtrlSetState($Checkbox_all, $GUI_ENABLE)
											GUICtrlSetState($Checkbox_update, $GUI_ENABLE)
											GUICtrlSetState($Checkbox_verify, $GUI_ENABLE)
										EndIf
									Else
										$window = $GOGRepoGUI
									EndIf
								Else
									$tot = IniRead($downlist, "Downloads", "total", 0)
									While 1
										If $tot = 0 And $started = 4 And $total = 0 Then
											;$tot = 1
											$total = 1
											;AddGameToDownloadList()
											If $auto = 1 Then
												CheckForConnection()
												If $connection = 1 Then
													$started = 1
													$done = 0
													_FileCreate($finished)
													GUICtrlSetState($Button_move, $GUI_DISABLE)
													GUICtrlSetState($Button_log, $GUI_DISABLE)
													$wait = 3
													$verifying = ""
													IniWrite($downlist, "Downloads", "total", $tot)
													_FileWriteLog($logfle, "Downloaded - " & $title & ".")
													IniWrite($inifle, "Current Download", "title", $title)
													IniWrite($inifle, "Current Download", "destination", $gamefold)
													If $script = "default" Then
														IniWrite($inifle, "Current Download", "files", $files)
													Else
														IniWrite($inifle, "Current Download", "standalone", $standalone)
														IniWrite($inifle, "Current Download", "galaxy", $galaxy)
														IniWrite($inifle, "Current Download", "shared", $shared)
														IniWrite($inifle, "Current Download", "log", $downlog)
														IniWrite($inifle, "Current Download", "language", $skiplang)
														IniWrite($inifle, "Current Download", "languages", $langskip)
														IniWrite($inifle, "Current Download", "OS", $skipos)
														$val = StringReplace($osskip, "+", "")
														$val = StringStripWS($val, 7)
														IniWrite($inifle, "Current Download", "OSes", $val)
													EndIf
													IniWrite($inifle, "Current Download", "extras", $extras)
													;IniWrite($inifle, "Current Download", "language", $lang)
													IniWrite($inifle, "Current Download", "cover", $cover)
													;If $cover = 1 Then
														$image = IniRead($gamesfle, $name, "image", "")
														IniWrite($inifle, "Current Download", "image", $image)
													;EndIf
													IniWrite($inifle, "Current Download", "verify", $validate)
													If ($files = 1 And $script = "default") Or _
														($script = "fork" And ($standalone = 1 Or $galaxy = 1 Or $shared = 1)) Then
														IniWrite($inifle, "Current Download", "md5", $md5)
													Else
														; No need to verify game files if not downloading, and a waste of time if they exist.
														IniWrite($inifle, "Current Download", "md5", 4)
													EndIf
													IniWrite($inifle, "Current Download", "size", $sizecheck)
													If $extras = 1 Then
														IniWrite($inifle, "Current Download", "zips", $zipcheck)
													Else
														; No need to verify extra files if not downloading, and a waste of time if they exist.
														IniWrite($inifle, "Current Download", "zips", 4)
													EndIf
													IniWrite($inifle, "Current Download", "delete", $delete)
													CheckOnShutdown()
													If $minimize = 1 Then
														$flag = @SW_MINIMIZE
													Else
														;$flag = @SW_RESTORE
														$flag = @SW_SHOW
													EndIf
													If $bargui = 1 And FileExists($progbar) Then
														$pid = ShellExecute($progbar, "Download", @ScriptDir, "open", $flag)
													Else
														If $script = "default" Then
															Local $params = " -skipextras -skipgames"
															If $files = 1 Then $params = StringReplace($params, " -skipgames", "")
														Else
															Local $params = " -skipextras -skipgalaxy -skipstandalone -skipshared -nolog"
															If $galaxy = 1 Then $params = StringReplace($params, " -skipgalaxy", "")
															If $standalone = 1 Then $params = StringReplace($params, " -skipstandalone", "")
															If $shared = 1 Then $params = StringReplace($params, " -skipshared", "")
															If $downlog = 1 Then $params = StringReplace($params, " -nolog", "")
															If $skiplang = 1 Then
																If $langskip <> "" Then $params = $params & " -skiplang " & $langskip
															EndIf
															If $skipos = 1 Then
																If $osskip <> "" Then
																	$val = StringReplace($osskip, "+", "")
																	$val = StringStripWS($val, 7)
																	$params = $params & " -skipos " & $val
																EndIf
															EndIf
														EndIf
														If $extras = 1 Then $params = StringReplace($params, " -skipextras", "")
														$pid = Run(@ComSpec & ' /c gogrepo.py download' & $params & ' -id ' & $title & ' "' & $gamefold & '"', @ScriptDir, $flag)
													EndIf
													AdlibRegister("CheckOnGameDownload", 3000)
												Else
													MsgBox(262192, "Auto Start Error", "Due to no web connection, you will need to de-select the" _
														& @LF & "Auto 'Start' option on the Queue window, if you wish to" _
														& @LF & "add game titles to the download list.", 0, $GOGRepoGUI)
												EndIf
											Else
												$tot = 1
												AddGameToDownloadList()
											EndIf
											ExitLoop
										ElseIf $tot = 0 And $total = 1 And $started = 4 And $auto = 1 Then
											IniDelete($inifle, "Current Download")
											$sects = IniReadSectionNames($downlist)
											If @error Then
												$tot = 0
											Else
												$tot = $sects[0] - 1
												If $tot < 1 Then $tot = 0
											EndIf
											IniWrite($downlist, "Downloads", "total", $tot)
											MsgBox(262192, "Auto Start Error", "You will need to de-select the Auto 'Start' option" _
												& @LF & "on the 'Queue' window, if you wish to add more" _
												& @LF & "game titles to the download list.", 0, $GOGRepoGUI)
											ExitLoop
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
												;If $started = 1 Then
												;	$total = $total + $tot
												;Else
													$total = $total + 1
												;EndIf
											EndIf
											If $add = 1 Then
												AddGameToDownloadList()
											EndIf
											ExitLoop
										EndIf
									WEnd
									;If $tot > 0 Then
									If $total > 0 Then
										;GUICtrlSetBkColor($Label_added, $COLOR_BLACK)
										;GUICtrlSetColor($Label_added, $COLOR_WHITE)
										GUICtrlSetData($Label_added, $total)
										If $total = 1 Then
											If $started = 1 Then
												GUICtrlSetBkColor($Label_added, $COLOR_RED)
											Else
												GUICtrlSetBkColor($Label_added, $COLOR_GREEN)
											EndIf
											GUICtrlSetState($Checkbox_update, $GUI_DISABLE)
											GUICtrlSetState($Checkbox_verify, $GUI_DISABLE)
											GUICtrlSetState($Checkbox_all, $GUI_DISABLE)
											;GUICtrlSetState($Button_setup, $GUI_DISABLE)
										EndIf
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
					MsgBox(262192, "Selection Error", "Please re-select the Title!", $wait, $GOGRepoGUI)
				EndIf
			Else
				MsgBox(262192, "Program Error", "Required file 'gogrepo.py' not found!", $wait, $GOGRepoGUI)
			EndIf
		Case $msg = $Button_detail
			; View the information from manifest
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
								;
								$segment = StringSplit($chunk, "'size': ", 1)
								If $segment[0] > 1 Then
									For $s = 1 To $segment[0]
										$number = $segment[$s]
										$number = StringSplit($number, ",", 1)
										$number = $number[1]
										If StringIsDigit($number) Then
											$size = $number
											GetTheSize()
											$chunk = StringReplace($chunk, "'size': " & $number, "'size': " & $size)
										EndIf
									Next
								EndIf
								;
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
					Else
						MsgBox(262192, "Game Error", "A title is not selected!", $wait, $GOGRepoGUI)
					EndIf
				Else
					MsgBox(262192, "Title Error", "A game is not selected!", $wait, $GOGRepoGUI)
				EndIf
			EndIf
		Case $msg = $Button_dest
			; Browse to set the destination folder  $gamesfle
			$type = GUICtrlRead($Combo_dest)
			$title = GUICtrlRead($Input_title)
			;MsgBox(262192, "Got Here 1", $type, 0, $GOGRepoGUI)
			If $title = "" And $type = "Default" Then
				;MsgBox(262192, "Got Here 2", $type, 0, $GOGRepoGUI)
				If $dest = "" Then
					$fold = @ScriptDir
				Else
					$fold = $dest
				EndIf
				$pth = FileSelectFolder("Browse to set the main games folder.", $fold, 7, $dest, $GOGRepoGUI)
				If Not @error And StringMid($pth, 2, 2) = ":\" Then
					$dest = $pth
					IniWrite($inifle, "Main Games Folder", "path", $dest)
					GUICtrlSetData($Input_dest, $dest)
					$gamesfold = $dest
				EndIf
			ElseIf $title = "" Then
				MsgBox(262192, "Game Error", "Title is not selected, and type of location is 'Specific'.", $wait, $GOGRepoGUI)
			ElseIf $type = "Specific" Then
				$name = GUICtrlRead($Input_name)
				If $name = "" Then
					MsgBox(262192, "Game Error", "Name not found for 'Specific'.", $wait, $GOGRepoGUI)
				Else
					;$path = IniRead($gamesfle, $name, "path", "")
					$path = IniRead($locations, $name, "path", "")
					If $path = "" Then
						$pth = $dest
					Else
						$pth = $path
					EndIf
					$pth = FileSelectFolder("Browse to set a specific game folder.", @ScriptDir, 7, $pth, $GOGRepoGUI)
					If Not @error And StringMid($pth, 2, 2) = ":\" Then
						;IniWrite($gamesfle, $name, "path", $pth)
						IniWrite($locations, $name, "path", $pth)
						GUICtrlSetData($Input_dest, $pth)
						;IniWrite($locations, $name, "type", "Specific")
						$gamesfold = $pth
						$val = IniRead($downlist, $title, , "destination", "")
						If $val <> "" And $val <> $gamesfold Then
							$gamefold = $gamesfold
							If $alpha = 1 Then
								$alf = StringUpper(StringLeft($title, 1))
								$gamefold = $gamefold & "\" & $alf
								;MsgBox(262192, "Got Here 2", $title & @LF & $gamefold, $wait, $GOGRepoGUI)
							EndIf
							IniWrite($downlist, $title, "destination", $gamefold)
						EndIf
					EndIf
				EndIf
			ElseIf $type = "Default" Then
				$name = GUICtrlRead($Input_name)
				If $name = "" Then
					MsgBox(262192, "Game Error", "Name not found for 'Default'.", $wait, $GOGRepoGUI)
				Else
					;$path = IniRead($gamesfle, $name, "path", "")
					$path = IniRead($locations, $name, "path", "")
					If $path = "" Or $path = $dest Then
						MsgBox(262192, "Browse Report", "Nothing to do, game is already set to use 'Default'.", $wait, $GOGRepoGUI)
					Else
						$delay = $wait * 3
						$ans = MsgBox(262177, "Change Query", _
							"Game download location is not 'Default'." & @LF & @LF & _
							"Do you want to restore to 'Default'?", $delay, $GOGRepoGUI)
						If $ans = 1 Then
							;IniDelete($gamesfle, $name, "path")
							IniDelete($locations, $name, "path")
							;IniDelete($locations, $name, "type")
							$gamesfold = $dest
							$val = IniRead($downlist, $title, , "destination", "")
							If $val <> "" And $val <> $gamesfold Then
								$gamefold = $gamesfold
								If $alpha = 1 Then
									$alf = StringUpper(StringLeft($title, 1))
									$gamefold = $gamefold & "\" & $alf
									;MsgBox(262192, "Got Here 2", $title & @LF & $gamefold, $wait, $GOGRepoGUI)
								EndIf
								IniWrite($downlist, $title, "destination", $gamefold)
							EndIf
						EndIf
					EndIf
				EndIf
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
				ShowCorrectImage()
			Else
				$show = 4
				GUICtrlSetImage($Pic_cover, $blackjpg)
			EndIf
			IniWrite($inifle, "Cover Image", "show", $show)
		Case $msg = $Checkbox_game And $script = "default"
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
		Case $msg = $Item_winunsort
			; Windows Games - Unsorted List
			CreateListOfGames("Windows", $addlist)
		Case $msg = $Item_winsort
			; Windows Games - Sorted List
			CreateListOfGames("Windows", $titlist)
		Case $msg = $Item_store
			; Go to Store page
			$name = GUICtrlRead($List_games)
			If $name <> "" Then
				$store = IniRead($gamesfle, $name, "store", "")
				If $store = "" Then
					MsgBox(262192, "Go To Error", "Store URL not found!", $wait, $GOGRepoGUI)
				Else
					$link = "https://www.gog.com" & $store
					ShellExecute($link)
				EndIf
			Else
				MsgBox(262192, "Title Error", "A game is not selected!", $wait, $GOGRepoGUI)
			EndIf
		Case $msg = $Item_macunsort
			; MAC Games - Unsorted List
			CreateListOfGames("Mac", $addlist)
		Case $msg = $Item_macsort
			; MAC Games - Sorted List
			CreateListOfGames("Mac", $titlist)
		Case $msg = $Item_linunsort
			; Linux Games - Unsorted List
			CreateListOfGames("Linux", $addlist)
		Case $msg = $Item_linsort
			; Linux Games - Sorted List
			CreateListOfGames("Linux", $titlist)
		Case $msg = $Item_library
			; Go to Library page
			ShellExecute("https://www.gog.com/account")
		Case $msg = $Item_forum
			; Go to Forum page$Item_library
			$name = GUICtrlRead($List_games)
			If $name <> "" Then
				$forum = IniRead($gamesfle, $name, "forum", "")
				If $forum = "" Then
					MsgBox(262192, "Go To Error", "Forum URL not found!", $wait, $GOGRepoGUI)
				Else
					ShellExecute($forum)
				EndIf
			Else
				MsgBox(262192, "Title Error", "A game is not selected!", $wait, $GOGRepoGUI)
			EndIf
		Case $msg = $Item_content
			; Folder Content - Game
			$name = GUICtrlRead($List_games)
			$title = GUICtrlRead($Input_title)
			If $name <> "" And $title <> "" Then
				$gamesfold = GUICtrlRead($Input_dest)
				$gamefold = $gamesfold & "\" & $title
				If $alpha = 1 Then
					$alf = StringUpper(StringLeft($title, 1))
					$gamefold = $gamefold & "\" & $alf
				EndIf
				If FileExists($gamefold) Then
					$size = DirGetSize($gamefold)
					GetTheSize()
					$content = _FileListToArray($gamefold, "*", 1, False)
					If IsArray($content) Then
						$content = "Contains " & $content[0] & " files." & @LF & @LF & _ArrayToString($content, @LF, 1) & @LF & @LF & $size
					Else
						$content = "Nothing Found!"
					EndIf
				Else
					$content = "No such folder!"
				EndIf
				MsgBox(262208, "Game Folder Content", $gamefold & @LF & $content, $wait, $GOGRepoGUI)
			Else
				MsgBox(262192, "Title Error", "A game is not selected!", $wait, $GOGRepoGUI)
			EndIf
		Case $msg = $Item_allunsort
			; ALL Games - Unsorted List
			CreateListOfGames("ALL", $addlist)
		Case $msg = $Item_allsort
			; ALL Games - Sorted List
			CreateListOfGames("ALL", $titlist)
		Case $msg = $Label_title
			; Click to restore last search text to Title input field
			GUICtrlSetData($Input_title, $find)
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
			;
			;$path = IniRead($gamesfle, $name, "path", "")
			$path = IniRead($locations, $name, "path", "")
			If $path = "" Then
				GUICtrlSetData($Combo_dest, "Default")
				$path = $dest
			Else
				GUICtrlSetData($Combo_dest, "Specific")
			EndIf
			$gamesfold = $path
			GUICtrlSetData($Input_dest, $gamesfold)
			;
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
				ShowCorrectImage()
			EndIf
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

Func DownloadAllGUI()
	; Query which DOWNLOAD ALL method to use.
	Local $Button_close, $Button_inf, $Button_one, $Button_two, $Button_veryopts, $Group_one, $Group_two, $Label_one, $Label_two
	Local $params, $pos
	;
	$DownloadAllGUI = GuiCreate("Download ALL", 230, 400, Default, Default, $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU _
														+ $WS_VISIBLE + $WS_CLIPSIBLINGS, $WS_EX_TOPMOST, $GOGRepoGUI)
	GUISetBkColor(0xCECEFF, $DownloadAllGUI)
	GuiSetState(@SW_DISABLE, $DownloadAllGUI)
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
	$Group_two = GuiCtrlCreateGroup("Recommended", 10, 175, 210, 150)
	$Button_two = GuiCtrlCreateButton("METHOD TWO", 20, 195, 190, 40)
	GUICtrlSetFont($Button_two, 9, 600)
	GUICtrlSetTip($Button_two, "Download ALL Games using Method 2!")
	$Label_two = GuiCtrlCreateLabel("This method uses both gogrepo.py and" _
		& @LF & "a queuing system you can interact with" _
		& @LF & "to download all your games and extras." _
		& @LF & "You can also have greater control over" _
		& @LF & "the download location, individually.", 20, 245, 190, 70)
	;
	$Button_veryopts = GuiCtrlCreateButton("Verify" & @LF & "Options", 10, 340, 75, 50, $BS_MULTILINE)
	GUICtrlSetFont($Button_veryopts, 9, 600)
	GUICtrlSetTip($Button_veryopts, "Set the Verify options for downloading!")
	;
	$Button_inf = GuiCtrlCreateButton("Info", 95, 340, 55, 50, $BS_ICON)
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
	$window = $DownloadAllGUI


	GuiSetState(@SW_ENABLE, $DownloadAllGUI)
	While 1
		$msg = GuiGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Button_close
			; Exit / Close / Quit the window
			GUIDelete($DownloadAllGUI)
			ExitLoop
		Case $msg = $Button_veryopts
			; Set the Verify options for downloading
			$down = 1
			VerifyGUI()
			$window = $DownloadAllGUI
			$down = ""
		Case $msg = $Button_two
			; Download ALL Games using Method 2
			; METHOD 2 - Copy all titles (& their details) to Downloads list, providing interaction & control.
			SplashTextOn("", "Please Wait!" & @LF & "(List Building)", 200, 120, Default, Default, 33)
			IniWrite($inifle, "Download ALL List", "begin", _Now())
			;Sleep(3000)
			If FileExists($titlist) Then
				$res = _FileReadToArray($titlist, $array)
				If $res = 1 Then
					$tot = 0
					$textdump = ""
					;$lines = "OS=" & $OSget
					;$lines = $lines & @CRLF & "files=" & $files
					$lines = "files=" & $files
					$lines = $lines & @CRLF & "extras=" & $extras
					$lines = $lines & @CRLF & "language=" & $lang
					$lines = $lines & @CRLF & "cover=" & $cover
					$validation = "md5=" & $md5
					$validation = $validation & @CRLF & "size=" & $sizecheck
					$validation = $validation & @CRLF & "zips=" & $zipcheck
					$validation = $validation & @CRLF & "delete=" & $delete
					For $a = 1 To $array[0]
						$line = $array[$a]
						If $line <> "" Then
							$line = StringSplit($line, " | ", 1)
							If $line[0] = 2 Then
								$name = $line[1]
								If $name <> "" Then
									$line = $line[2]
									If $line <> "" Then
										$pos = StringInStr($line, ") - ", 0, -1)
										If $pos > 0 Then
											$image = StringMid($line, $pos + 4)
											$image = StringStripWS($image, 8)
											If StringLeft($image, 4) <> "http" Then $image = ""
											$line = StringLeft($line, $pos - 1)
											$pos = StringInStr($line, " (", 0, -1)
											If $pos > 0 Then
												$title = StringLeft($line, $pos - 1)
												$title = StringStripWS($title, 8)
												If $title <> "" Then
													$tot = $tot + 1
													$params = "rank=" & $tot
													;$path = IniRead($gamesfle, $name, "path", "")
													$path = IniRead($locations, $name, "path", "")
													If $path = "" Then
														$gamesfold = $dest
													Else
														$gamesfold = $path
													EndIf
													$gamefold = $gamesfold
													If $alpha = 1 Then
														$alf = StringUpper(StringLeft($title, 1))
														$gamefold = $gamefold & "\" & $alf
														;MsgBox(262192, "Got Here 2", $title & @LF & $gamefold, $wait, $GOGRepoGUI)
													EndIf
													$params = $params & @CRLF & "destination=" & $gamefold
													;
													$OS = IniRead($gamesfle, $name, "osextra", "")
													$params = $params & @CRLF & "osextra=" & $OS
													;
													$params = $params & @CRLF & $lines
													If $image <> "" Then
														$params = $params & @CRLF & "image=" & $image
													EndIf
													$params = $params & @CRLF & "verify=" & $validate
													$params = $params & @CRLF & $validation
												EndIf
											Else
												$title = ""
											EndIf
										Else
											$title = ""
										EndIf
										If $title <> "" Then
											$title = "[" & $title & "]" & @CRLF
											If $textdump = "" Then
												$textdump = $title & $params
											Else
												$textdump = $textdump & @CRLF & $title & $params
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					Next
					$total = $tot
					If $textdump <> "" Then
						$textdump = "[Downloads]" & @CRLF & "total=" & $tot & @CRLF & $textdump
						$file = FileOpen($downlist, 2)
						If $file = -1 Then
							MsgBox(262192, "Program Error", "Downloads list file could not be written to!", 0, $DownloadAllGUI)
						Else
							FileWrite($file, $textdump)
						EndIf
						FileClose($file)
						$downall = 1
						IniWrite($inifle, "Download ALL", "activated", $downall)
						$auto = 4
						IniWrite($inifle, "Start Downloading", "auto", $auto)
					EndIf
				Else
					MsgBox(262192, "Program Error", "Titles.txt file is empty!", 0, $DownloadAllGUI)
				EndIf
			Else
				MsgBox(262192, "Program Error", "Titles.txt file is missing!", 0, $DownloadAllGUI)
			EndIf
			IniWrite($inifle, "Download ALL List", "finish", _Now())
			SplashOff()
			GUIDelete($DownloadAllGUI)
			ExitLoop
		Case $msg = $Button_one
			; Download ALL Games using Method 1
			; METHOD 1 - Hand the reigns fully to 'gogrepo.py', and GUI remains disabled for duration.
			EnableDisableControls($GUI_DISABLE)
			If $script = "default" Then
				Local $params = " -skipextras -skipgames"
				If $files = 1 Then $params = StringReplace($params, " -skipgames", "")
			Else
				Local $params = " -skipextras -skipgalaxy -skipstandalone -skipshared -nolog"
				If $galaxy = 1 Then $params = StringReplace($params, " -skipgalaxy", "")
				If $standalone = 1 Then $params = StringReplace($params, " -skipstandalone", "")
				If $shared = 1 Then $params = StringReplace($params, " -skipshared", "")
				If $downlog = 1 Then $params = StringReplace($params, " -nolog", "")
				If $skiplang = 1 Then
					If $langskip <> "" Then $params = $params & " -skiplang " & $langskip
				EndIf
				If $skipos = 1 Then
					If $osskip <> "" Then
						$val = StringReplace($osskip, "+", "")
						$val = StringStripWS($val, 7)
						$params = $params & " -skipos " & $val
					EndIf
				EndIf
			EndIf
			If $extras = 1 Then $params = StringReplace($params, " -skipextras", "")
			;$pid = RunWait(@ComSpec & ' /c gogrepo.py download "' & $gamefold & '"', @ScriptDir)
			$pid = RunWait(@ComSpec & ' /c gogrepo.py download' & $params & ' "' & $gamefold & '"', @ScriptDir)
			If $validate = 1 Then
				$params = " -skipmd5 -skipsize -skipzip -delete"
				If $md5 = 1 Then $params = StringReplace($params, " -skipmd5", "")
				If $sizecheck = 1 Then $params = StringReplace($params, " -skipsize", "")
				If $zipcheck = 1 Then $params = StringReplace($params, " -skipzip", "")
				If $delete = 4 Then $params = StringReplace($params, " -delete", "")
				$pid = RunWait(@ComSpec & ' /c gogrepo.py verify' & $params & ' "' & $gamefold & '" &&pause', @ScriptDir)
			EndIf
			_FileWriteLog($logfle, "Downloaded all games.")
			EnableDisableControls($GUI_ENABLE)
		Case $msg = $Button_inf
			; Download ALL Information
			$delay = $wait * 3
			MsgBox(262208, "Download ALL Information", _
				"Alphanumeric folders are not supported by Method One." & @LF & @LF & _
				"Method Two is recommended for DOWNLOAD ALL, so" & @LF & _
				"you have far more control over the processes, as well as" & @LF & _
				"the download location(s). It also means you can do your" & @LF & _
				"downloading in stages if you have a large GOG library. A" & @LF & _
				"'Shutdown' option is also available.", $delay, $DownloadAllGUI)
		Case Else
			;;;
		EndSelect
	WEnd
EndFunc ;=> DownloadAllGUI

Func DownloadGUI()
	Local $Button_close, $Button_inf, $Checkbox_alone, $Checkbox_downlog, $Checkbox_galaxy, $Checkbox_shared
	Local $Checkbox_skiplang, $Checkbox_skipOS, $Combo_language, $Combo_OSes, $Group_files
	Local $langs
	;
	$DownloadGUI = GuiCreate("Download Options", 270, 145, Default, Default, $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU _
															+ $WS_VISIBLE + $WS_CLIPSIBLINGS, $WS_EX_TOPMOST, $GOGRepoGUI)
	GUISetBkColor(0x80FFFF, $DownloadGUI)
	;
	; CONTROLS
	$Group_files = GuiCtrlCreateGroup("", 10, 5, 180, 70)
	$Checkbox_downlog = GUICtrlCreateCheckbox("Log File", 20, 20, 55, 20)
	GUICtrlSetTip($Checkbox_downlog, "Save a Log file for download!")
	;
	$Checkbox_alone = GUICtrlCreateCheckbox("Standalone Files", 85, 20, 95, 20)
	GUICtrlSetTip($Checkbox_alone, "Download Standalone installer files!")
	;
	$Checkbox_galaxy = GUICtrlCreateCheckbox("Galaxy Files", 20, 45, 80, 20)
	GUICtrlSetTip($Checkbox_galaxy, "Download Galaxy installer files!")
	;
	$Checkbox_shared = GUICtrlCreateCheckbox("Shared Files", 105, 45, 75, 20)
	GUICtrlSetTip($Checkbox_shared, "Download Shared installer files!")
	;
	$Checkbox_skiplang = GUICtrlCreateCheckbox("Skip Language", 10, 85, 90, 21)
	GUICtrlSetTip($Checkbox_skiplang, "Skip the specified language(s)!")
	$Combo_language = GUICtrlCreateCombo("", 105, 85, 85, 21)
	GUICtrlSetTip($Combo_language, "Language files to skip!")
	;
	$Checkbox_skipOS = GUICtrlCreateCheckbox("Skip OS", 10, 115, 60, 21)
	GUICtrlSetTip($Checkbox_skipOS, "Skip the specified OSes!")
	$Combo_OSes = GUICtrlCreateCombo("", 72, 115, 118, 21)
	GUICtrlSetTip($Combo_OSes, "OS files to skip!")
	;
	$Button_inf = GuiCtrlCreateButton("Info", 200, 10, 60, 58, $BS_ICON)
	GUICtrlSetTip($Button_inf, "Download Options Information!")
	;
	$Button_close = GuiCtrlCreateButton("EXIT", 200, 78, 60, 58, $BS_ICON)
	GUICtrlSetTip($Button_close, "Exit / Close / Quit the window!")
	;
	; SETTINGS
	GUICtrlSetImage($Button_inf, $user, $icoI, 1)
	GUICtrlSetImage($Button_close, $user, $icoX, 1)
	;
	GUICtrlSetState($Checkbox_alone, $standalone)
	GUICtrlSetState($Checkbox_galaxy, $galaxy)
	GUICtrlSetState($Checkbox_shared, $shared)
	GUICtrlSetState($Checkbox_downlog, $downlog)
	GUICtrlSetState($Checkbox_skiplang, $skiplang)
	GUICtrlSetState($Checkbox_skipOS, $skipos)
	;$langs = "||" & StringReplace($lang, " ", "|")
	$langs = "||" & $lang
	If StringInStr($lang, " ") > 0 Then
		$langs = $langs & "|" & StringReplace($lang, " ", "|")
	EndIf
	GUICtrlSetData($Combo_language, $langs, $langskip)
	If $skiplang = 4 Then GUICtrlSetState($Combo_language, $GUI_DISABLE)
	GUICtrlSetData($Combo_OSes, "||linux|mac|windows|linux + mac|linux + windows|mac + windows", $osskip)
	If $skipos = 4 Then GUICtrlSetState($Combo_OSes, $GUI_DISABLE)
	;
	$window = $DownloadGUI


	GuiSetState()
	While 1
		$msg = GuiGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Button_close
			; Exit / Close / Quit the window
			GUIDelete($DownloadGUI)
			ExitLoop
		Case $msg = $Checkbox_skipOS
			; Skip the specified OSes
			If GUICtrlRead($Checkbox_skipOS) = $GUI_CHECKED Then
				$skipos = 1
				GUICtrlSetState($Combo_OSes, $GUI_ENABLE)
			Else
				$skipos = 4
				GUICtrlSetState($Combo_OSes, $GUI_DISABLE)
			EndIf
			IniWrite($inifle, "Skip Files", "OS", $skipos)
		Case $msg = $Checkbox_skiplang
			; Skip the specified language(s)
			If GUICtrlRead($Checkbox_skiplang) = $GUI_CHECKED Then
				$skiplang = 1
				GUICtrlSetState($Combo_language, $GUI_ENABLE)
			Else
				$skiplang = 4
				GUICtrlSetState($Combo_language, $GUI_DISABLE)
			EndIf
			IniWrite($inifle, "Skip Files", "language", $skiplang)
		Case $msg = $Checkbox_shared
			; Download Shared installer files
			If GUICtrlRead($Checkbox_shared) = $GUI_CHECKED Then
				$shared = 1
			Else
				$shared = 4
			EndIf
			IniWrite($inifle, "Download", "shared", $shared)
		Case $msg = $Checkbox_galaxy
			; Download Galaxy installer files
			If GUICtrlRead($Checkbox_galaxy) = $GUI_CHECKED Then
				$galaxy = 1
			Else
				$galaxy = 4
			EndIf
			IniWrite($inifle, "Download", "galaxy", $galaxy)
		Case $msg = $Checkbox_downlog
			; Save a Log file for download
			If GUICtrlRead($Checkbox_downlog) = $GUI_CHECKED Then
				$downlog = 1
			Else
				$downlog = 4
			EndIf
			IniWrite($inifle, "Download", "log", $downlog)
		Case $msg = $Checkbox_alone
			; Download Standalone installer files
			If GUICtrlRead($Checkbox_alone) = $GUI_CHECKED Then
				$standalone = 1
			Else
				$standalone = 4
			EndIf
			IniWrite($inifle, "Download", "standalone", $standalone)
		Case $msg = $Combo_OSes
			; OS files to skip
			$osskip =  GUICtrlRead($Combo_OSes)
			IniWrite($inifle, "Skip Files", "OSes", $osskip)
		Case $msg = $Combo_language
			; Language files to skip
			$langskip =  GUICtrlRead($Combo_language)
			IniWrite($inifle, "Skip Files", "languages", $langskip)
		Case Else
			;;;
		EndSelect
	WEnd
EndFunc ;=> DownloadGUI

Func QueueGUI()
	Local $Button_inf, $Button_quit, $Button_record, $Checkbox_delete, $Checkbox_dos, $Checkbox_md5
	Local $Checkbox_size, $Checkbox_start, $Checkbox_stop, $Checkbox_zip, $Group_auto, $Group_info
	Local $Group_lang, $Group_progress, $Group_shutdown, $Group_stop
	;
	Local $count, $current, $params, $process, $restart, $section, $shutopts, $swap, $templog
	;
	$QueueGUI = GuiCreate("QUEUE & Options", $width, $height, $left, $top, $style + $WS_VISIBLE, $WS_EX_TOPMOST)
	GUISetBkColor(0xFFD5FF, $QueueGUI)
	; CONTROLS
	$Group_download = GuiCtrlCreateGroup("Current Download", 10, 10, 370, 55)
	$Input_download = GUICtrlCreateInput("", 20, 32, 350, 20)
	GUICtrlSetBkColor($Input_download, 0xBBFFBB)
	GUICtrlSetTip($Input_download, "Game Name!")
	;
	$Group_waiting = GuiCtrlCreateGroup("Games To Download", 10, 75, 370, 180)
	$List_waiting = GuiCtrlCreateList("", 20, 95, 350, 100, $WS_BORDER + $WS_VSCROLL)
	GUICtrlSetBkColor($List_waiting, 0xB9FFFF)
	GUICtrlSetTip($List_waiting, "List of games waiting to download!")
	$Input_destination = GUICtrlCreateInput("", 20, 200, 295, 20)
	GUICtrlSetBkColor($Input_destination, 0xBBFFBB)
	GUICtrlSetTip($Input_destination, "Destination path!")
	$Checkbox_check = GUICtrlCreateCheckbox("Verify", 325, 200, 45, 20)
	GUICtrlSetTip($Checkbox_check, "Verify the download!")
	$Checkbox_md5 = GUICtrlCreateCheckbox("MD5 Check", 20, 225, 80, 20)
	GUICtrlSetTip($Checkbox_md5, "Enable MD5 checksum verification!")
	$Checkbox_size = GUICtrlCreateCheckbox("File Size", 110, 225, 60, 20)
	GUICtrlSetTip($Checkbox_size, "Enable file size verification!")
	$Checkbox_zip = GUICtrlCreateCheckbox("Zip Files", 180, 225, 60, 20)
	GUICtrlSetTip($Checkbox_zip, "Enable zip file verification!")
	$Checkbox_delete = GUICtrlCreateCheckbox("Delete File On Failure", 250, 225, 125, 20)
	GUICtrlSetTip($Checkbox_delete, "Delete if a file fails integrity check!")
	;
	$Group_done = GuiCtrlCreateGroup("Downloads Finished", 10, 264, 370, 131)
	$List_done = GuiCtrlCreateList("", 20, 284, 350, 100, $WS_BORDER + $WS_VSCROLL)
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
	$Group_stop = GuiCtrlCreateGroup("Stop After", 390, 75, 122, 51)
	$Checkbox_stop = GUICtrlCreateCheckbox("Current Download", 400, 95, 102, 20)
	GUICtrlSetTip($Checkbox_stop, "Stop after current download!")
	;
	$Button_add = GuiCtrlCreateButton("ADD" & @LF & "STOP", 522, 80, 58, 46, $BS_MULTILINE)
	GUICtrlSetFont($Button_add, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_add, "Add a stop before selected entry!")
	;
	$Button_moveup = GuiCtrlCreateButton("UP", 390, 138, 50, 51, $BS_ICON)
	GUICtrlSetTip($Button_moveup, "Move selected entry up the list!")
	;
	$Button_movedown = GuiCtrlCreateButton("DOWN", 390, 199, 50, 51, $BS_ICON)
	GUICtrlSetTip($Button_movedown, "Move selected entry down the list!")
	;
	$Button_removall = GuiCtrlCreateButton("Remove ALL", 450, 138, 80, 24)
	GUICtrlSetFont($Button_removall, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_removall, "Remove all downloads from the list!")
	;
	$Button_remove = GuiCtrlCreateButton("REMOVE" & @LF & "Selected", 450, 167, 80, 39, $BS_MULTILINE)
	GUICtrlSetFont($Button_remove, 8, 600)
	GUICtrlSetTip($Button_remove, "Remove selected entry from the list!")
	;
	$Group_lang = GuiCtrlCreateGroup("", 450, 208, 80, 42)
	$Input_lang = GUICtrlCreateInput("", 460, 222, 60, 20, $ES_CENTER + $ES_READONLY)
	GUICtrlSetBkColor($Input_lang, 0xD7D700)
	GUICtrlSetTip($Input_lang, "Language for selected entry!")
	;
	$Group_progress = GuiCtrlCreateGroup("", 540, 133, 40, 117)
	$Progress_bar = GUICtrlCreateProgress(550, 148, 20, 92, $PBS_SMOOTH + $PBS_VERTICAL)
	GUICtrlSetData($Progress_bar, 0)
	;
	$Group_info = GuiCtrlCreateGroup("Download Entry Options", 390, 258, 190, 75)
	$Input_OP = GUICtrlCreateInput("", 400, 278, 170, 20, $ES_CENTER + $ES_READONLY)
	GUICtrlSetBkColor($Input_OP, 0xD7D700)
	GUICtrlSetTip($Input_OP, "OS to download!")
	$Checkbox_files = GUICtrlCreateCheckbox("Game", 402, 303, 50, 20)
	GUICtrlSetTip($Checkbox_files, "Download game files!")
	$Checkbox_other = GUICtrlCreateCheckbox("Extras", 463, 303, 50, 20)
	GUICtrlSetTip($Checkbox_other, "Download extras files!")
	$Checkbox_image = GUICtrlCreateCheckbox("Cover", 524, 303, 45, 20)
	GUICtrlSetTip($Checkbox_image, "Download cover file!")
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
	GUICtrlSetTip($Button_inf, "Queue Information!")
	;
	$Button_quit = GuiCtrlCreateButton("EXIT", $width - 55, $height - 60, 45, 50, $BS_ICON)
	GUICtrlSetTip($Button_quit, "Exit / Close / Quit the window!")
	;
	; SETTINGS
	GuiSetState(@SW_DISABLE, $QueueGUI)
	;
	$Control_1 = $Checkbox_md5
	$Control_2 = $Checkbox_size
	$Control_3 = $Checkbox_zip
	$Control_4 = $Checkbox_delete
	$Control_5 = $Checkbox_start
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
	$templog = @ScriptDir & "\Temp.log"
	;
	$shutopts = "none|Hibernate|Logoff|Powerdown|Reboot|Shutdown|Standby"
	GUICtrlSetData($Combo_shutdown, $shutopts, $shutdown)
	If $shutdown <> "none" Then
		WinSetTitle($QueueGUI, "", "QUEUE & Options - " & $shutdown & " is ENABLED")
	EndIf
	;
	;If $auto = 1 And $started = 1 Then
	If $started = 1 Then
		$title = IniRead($inifle, "Current Download", "title", "")
		$current = $title
		GUICtrlSetData($Input_download, $current)
	EndIf
	If $downall = 1 Then
		GUICtrlSetState($Checkbox_start, $GUI_DISABLE)
	EndIf
	;
	$cnt = 0
	If FileExists($finished) Then
		_FileReadToArray($finished, $array, 1)
		If IsArray($array) Then
			For $a = 1 To $array[0]
				$game = $array[$a]
				$game = StringSplit($game, " : ", 1)
				If $game[0] = 2 Then
					$game = $game[2]
					_GUICtrlListBox_AddString($List_done, $game)
					$cnt = $cnt + 1
				EndIf
			Next
			If $cnt > 0 Then
				GUICtrlSetData($Group_done, "Downloads Finished  (" & $cnt & ")")
			EndIf
		EndIf
	EndIf
	;
	If FileExists($downlist) Then
		$titles = IniReadSectionNames($downlist)
		If Not @error Then
			If $titles[0] > 1 Then
				$tot = 0
				For $t = 2 To $titles[0]
					$title = $titles[$t]
					$current = $title
					If $current <> "" Then
						$tot = $tot + 1
						_GUICtrlListBox_AddString($List_waiting, $current)
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
	GUICtrlSetState($Checkbox_md5, $GUI_DISABLE)
	GUICtrlSetState($Checkbox_size, $GUI_DISABLE)
	GUICtrlSetState($Checkbox_zip, $GUI_DISABLE)
	GUICtrlSetState($Checkbox_delete, $GUI_DISABLE)
	;
	;;$done = 1
	;;$tots = 194
	;$progress = $done + $tot
	;$percent = (($done * 100) + $done) / ($progress + ($progress * 100))
	;$percent = $percent * 100
	;;$percent = Round($percent)
	If $percent > 0 Then
		$progress = $total
		$percent = (($done * 100) + $done) / ($progress + ($progress * 100))
		$percent = $percent * 100
		GUICtrlSetData($Progress_bar, $percent)
		GUICtrlSetTip($Progress_bar, Round($percent, 1) & "%")
	EndIf
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
				"This will kill the current gogrepo.py" & @LF & _
				"process, which may result in a partial" & @LF & _
				"download or an unverified one." & @LF & @LF & _
				"Do you really want to do this?", $delay, $QueueGUI)
			If $ans = 1 Then
				$started = 4
				$wait = 0
				AdlibUnRegister("CheckOnGameDownload")
				SplashTextOn("", "Please Wait!", 200, 120, Default, Default, 33)
				If $pid <> 0 Then
					If ProcessExists($pid) Then
						ProcessClose($pid)
						ProcessWaitClose($pid, 10)
					Else
						$pid = 0
					EndIf
				EndIf
				If $bargui = 1 Then
					$pid = IniRead($inifle, "Current Download", "pid", "")
					If $pid <> "" Then
						If $pid <> 0 Then
							If ProcessExists($pid) Then
								ProcessClose($pid)
								ProcessWaitClose($pid, 10)
							Else
								$pid = 0
							EndIf
						EndIf
					EndIf
				EndIf
				SplashOff()
				; Need to be careful doing these. Perhaps query & check for number of instances.
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
				;
				; Add some code to restore game title to downloads list, after querying user.
				; NOTE - If input field is not cleared, there is potential to restart title.
				;
				If ProcessExists($pid) = 0 Then
					$pid = ""
					GUICtrlSetState($Button_start, $GUI_ENABLE)
					GUICtrlSetState($Button_stop, $GUI_DISABLE)
					GUISwitch($GOGRepoGUI)
					GUICtrlSetState($Button_move, $GUI_ENABLE)
					GUICtrlSetState($Button_log, $GUI_ENABLE)
					GUICtrlSetBkColor($Label_added, $COLOR_GREEN)
					GUISwitch($QueueGUI)
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
			CheckForConnection()
			If $connection = 1 Then
				$started = 1
				$done = 0
				_FileCreate($finished)
				GUICtrlSetData($List_done, "")
				GUICtrlSetData($Progress_bar, 0)
				GUICtrlSetTip($Progress_bar, "0%")
				GUISwitch($GOGRepoGUI)
				GUICtrlSetState($Checkbox_all, $GUI_DISABLE)
				GUICtrlSetState($Checkbox_update, $GUI_DISABLE)
				GUICtrlSetState($Checkbox_verify, $GUI_DISABLE)
				GUICtrlSetState($Button_move, $GUI_DISABLE)
				GUICtrlSetState($Button_log, $GUI_DISABLE)
				GUICtrlSetBkColor($Label_added, $COLOR_RED)
				GUISwitch($QueueGUI)
				$wait = 3
				GUICtrlSetState($Button_start, $GUI_DISABLE)
				GUICtrlSetState($Button_stop, $GUI_ENABLE)
				$title = GUICtrlRead($Input_download)
				$current = $title
				If $current <> "" Then
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
						$current = $title
						GUICtrlSetData($Input_download, $current)
						_FileWriteLog($logfle, "Downloaded - " & $current & ".")
						IniWrite($inifle, "Current Download", "title", $current)
						$gamefold = IniRead($downlist, $current, "destination", "")
						IniWrite($inifle, "Current Download", "destination", $gamefold)
						;
						If $script = "default" Then
							$params = " -skipextras -skipgames"
							$val = IniRead($downlist, $current, "files", "")
							IniWrite($inifle, "Current Download", "files", $val)
							If $val = 1 Then $params = StringReplace($params, " -skipgames", "")
						Else
							$val = IniRead($downlist, $title, "standalone", "")
							IniWrite($inifle, "Current Download", "standalone", $val)
							If $val = 1 Then $params = StringReplace($params, " -skipstandalone", "")
							$val = IniRead($downlist, $title, "galaxy", "")
							IniWrite($inifle, "Current Download", "galaxy", $val)
							If $val = 1 Then $params = StringReplace($params, " -skipgalaxy", "")
							$val = IniRead($downlist, $title, "shared", "")
							IniWrite($inifle, "Current Download", "shared", $val)
							If $val = 1 Then $params = StringReplace($params, " -skipshared", "")
							$val = IniRead($downlist, $title, "log", "")
							IniWrite($inifle, "Current Download", "log", $val)
							If $val = 1 Then $params = StringReplace($params, " -nolog", "")
							;
							$val = IniRead($downlist, $title, "language", "")
							IniWrite($inifle, "Current Download", "language", $val)
							If $val = 1 Then
								$val = IniRead($downlist, $title, "languages", "")
								If $val <> "" Then $params = $params & " -skiplang " & $val
							Else
								$val = ""
							EndIf
							IniWrite($inifle, "Current Download", "languages", $val)
							;
							$val = IniRead($downlist, $title, "OS", "")
							IniWrite($inifle, "Current Download", "OS", $val)
							If $val = 1 Then
								$val = IniRead($downlist, $title, "OSes", "")
								If $val <> "" Then $params = $params & " -skipos " & $val
							Else
								$val = ""
							EndIf
							IniWrite($inifle, "Current Download", "OSes", $val)
						EndIf
						$val = IniRead($downlist, $current, "extras", "")
						IniWrite($inifle, "Current Download", "extras", $val)
						If $val = 1 Then $params = StringReplace($params, " -skipextras", "")
						;
						$val = IniRead($downlist, $current, "cover", "")
						IniWrite($inifle, "Current Download", "cover", $val)
						If $val = 1 Then
							$image = IniRead($downlist, $current, "image", "")
							IniWrite($inifle, "Current Download", "image", $image)
						EndIf
						$val = IniRead($downlist, $current, "verify", "")
						IniWrite($inifle, "Current Download", "verify", $val)
						$val = IniRead($downlist, $current, "md5", "")
						IniWrite($inifle, "Current Download", "md5", $val)
						$val = IniRead($downlist, $current, "size", "")
						IniWrite($inifle, "Current Download", "size", $val)
						$val = IniRead($downlist, $current, "zips", "")
						IniWrite($inifle, "Current Download", "zips", $val)
						$val = IniRead($downlist, $current, "delete", "")
						IniWrite($inifle, "Current Download", "delete", $val)
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
					If $bargui = 1 And FileExists($progbar) Then
						$pid = ShellExecute($progbar, "Download", @ScriptDir, "open", $flag)
					Else
						$pid = Run(@ComSpec & ' /c gogrepo.py download' & $params & ' -id ' & $current & ' "' & $gamefold & '"', @ScriptDir, $flag)
					EndIf
					AdlibRegister("CheckOnGameDownload", 3000)
				EndIf
			EndIf
		Case $msg = $Button_remove
			; Remove selected entry from the list
			$title = GUICtrlRead($List_waiting)
			$current = $title
			If $current <> "" Then
				$ind = _GUICtrlListBox_GetCurSel($List_waiting)
				If $current = "+++ STOP HERE +++" Then
					_GUICtrlListBox_DeleteString($List_waiting, $ind)
					IniDelete($downlist, "Downloads", "stop")
				Else
					$val = _GUICtrlListBox_GetText($List_waiting, $ind)
					If $current = $val Then
						RemoveListEntry($ind)
						$total = $total - 1
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
				$total = 0
				ClearDisableEnableRestore()
				$downall = 4
				IniWrite($inifle, "Download ALL", "activated", $downall)
				GUICtrlSetState($Checkbox_start, $GUI_ENABLE)
				If $percent > 0 Then
					$percent = 0
					GUICtrlSetData($Progress_bar, $percent)
					GUICtrlSetTip($Progress_bar, $percent & "%")
				EndIf
			EndIf
		Case $msg = $Button_record
			; Log Record
			If FileExists($logfle) Then
				FileCopy($logfle, $templog, 1)
				If FileExists($templog) Then ShellExecute($templog)
			EndIf
		Case $msg = $Button_moveup
			; Move selected entry up the list
			$title = GUICtrlRead($List_waiting)
			$current = $title
			If $current <> "" Then
				GUICtrlSetState($Button_moveup, $GUI_DISABLE)
				$ind = _GUICtrlListBox_GetCurSel($List_waiting)
				$val = _GUICtrlListBox_GetText($List_waiting, $ind)
				$swap = _GUICtrlListBox_GetText($List_waiting, $ind - 1)
				If $current = $val And $val <> "+++ STOP HERE +++" And $swap <> "+++ STOP HERE +++" Then
					SplashTextOn("", "Please Wait!", 200, 120, Default, Default, 33)
					$tot = IniRead($downlist, $current, "rank", "")
					IniWrite($downlist, $current, "rank", $tot - 1)
					; Read original section entries.
					$section = IniReadSection($downlist, $current)
					; Temporarily rename original.
					_ReplaceStringInFile($downlist, "[" & $current & "]", "[###temporary###]")
					; Swap list entries.
					_GUICtrlListBox_SwapString($List_waiting, $ind, $ind - 1)
					; Original index should now be for swap item instead.
					; Get swap item title.
					$val = _GUICtrlListBox_GetText($List_waiting, $ind)
					; If original title doesn't match swap title continue.
					If $current <> $val Then
						$tot = IniRead($downlist, $val, "rank", "")
						IniWrite($downlist, $val, "rank", $tot + 1)
						; Read swap section entries.
						$swap = IniReadSection($downlist, $val)
						; Rename swap section title to original title.
						_ReplaceStringInFile($downlist, "[" & $val & "]", "[" & $current & "]")
						; Write original section entries to new (originally swap) section.
						IniWriteSection($downlist, $current, $section)
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
			$current = $title
			If $current <> "" Then
				GUICtrlSetState($Button_movedown, $GUI_DISABLE)
				$ind = _GUICtrlListBox_GetCurSel($List_waiting)
				$val = _GUICtrlListBox_GetText($List_waiting, $ind)
				$swap = _GUICtrlListBox_GetText($List_waiting, $ind + 1)
				If $current = $val And $val <> "+++ STOP HERE +++" And $swap <> "+++ STOP HERE +++" Then
					SplashTextOn("", "Please Wait!", 200, 120, Default, Default, 33)
					$tot = IniRead($downlist, $current, "rank", "")
					IniWrite($downlist, $current, "rank", $tot + 1)
					$section = IniReadSection($downlist, $current)
					_ReplaceStringInFile($downlist, "[" & $current & "]", "[###temporary###]")
					_GUICtrlListBox_SwapString($List_waiting, $ind, $ind + 1)
					$val = _GUICtrlListBox_GetText($List_waiting, $ind)
					If $current <> $val Then
						$tot = IniRead($downlist, $val, "rank", "")
						IniWrite($downlist, $val, "rank", $tot - 1)
						$swap = IniReadSection($downlist, $val)
						_ReplaceStringInFile($downlist, "[" & $val & "]", "[" & $current & "]")
						IniWriteSection($downlist, $current, $section)
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
		Case $msg = $Button_inf
			; Queue Information
			$delay = $wait * 4
			MsgBox(262208, "Queue Information", _
				"The Auto 'Start' option only applies to first game added, and is" & @LF & _
				"unavailable during a DOWNLOAD ALL process usage or setup." & @LF & @LF & _
				"More game titles can be added to the list during downloading." & @LF & @LF & _
				"Downloading occurs in the order displayed on the list, but the" & @LF & _
				"position on the list for each game can be changed, by using" & @LF & _
				"the UP or DOWN arrow buttons." & @LF & @LF & _
				"A STOP entry can be inserted at the selected list location, or if" & @LF & _
				"enabled, downloading can stop after the current download." & @LF & @LF & _
				"The STOP button will close the current 'gogrepo.py' process." & @LF & @LF & _
				"The checkboxes for 'Verify' options and 'Download' options," & @LF & _
				"don't yet currently change those stored settings." & @LF & @LF & _
				"If you don't want the (normally) black DOS style console or" & @LF & _
				"window to keep popping up, enable the 'Minimize' option." & @LF & _
				"That console however, is the only real-time feedback shown." & @LF & @LF & _
				"The progress bar shows the precentage of games completed." & @LF & @LF & _
				"The 'Shutdown' method gives a 99 second warning to abort," & @LF & _
				"and will also work with (at) an inserted STOP entry.", $delay, $GOGRepoGUI)
		Case $msg = $Button_add
			; Add a stop before selected entry
			$title = GUICtrlRead($List_waiting)
			$current = $title
			If $current <> "" Then
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
			IniWrite($inifle, "Progress Bar Or Console", "minimize", $minimize)
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
				$count = _GUICtrlListBox_GetCount($List_waiting)
				If $ind < $count - 1 Then
					GUICtrlSetState($Button_movedown, $GUI_ENABLE)
				Else
					GUICtrlSetState($Button_movedown, $GUI_DISABLE)
				EndIf
				$val = IniRead($downlist, $title, "osextra", "")
				GUICtrlSetData($Input_OP, $val)
				$val = IniRead($downlist, $title, "files", "")
				GUICtrlSetState($Checkbox_files, $val)
				$val = IniRead($downlist, $title, "extras", "")
				GUICtrlSetState($Checkbox_other, $val)
				$val = IniRead($downlist, $title, "language", "")
				GUICtrlSetData($Input_lang, $val)
				$val = IniRead($downlist, $title, "cover", "")
				GUICtrlSetState($Checkbox_image, $val)
				$val = IniRead($downlist, $title, "destination", "")
				GUICtrlSetData($Input_destination, $val)
				$val = IniRead($downlist, $title, "verify", "")
				GUICtrlSetState($Checkbox_check, $val)
				If $val = 1 Then
					GUICtrlSetState($Checkbox_md5, $GUI_ENABLE)
					GUICtrlSetState($Checkbox_size, $GUI_ENABLE)
					GUICtrlSetState($Checkbox_zip, $GUI_ENABLE)
					GUICtrlSetState($Checkbox_delete, $GUI_ENABLE)
					$val = IniRead($downlist, $title, "md5", "")
					GUICtrlSetState($Checkbox_md5, $val)
					$val = IniRead($downlist, $title, "size", "")
					GUICtrlSetState($Checkbox_size, $val)
					$val = IniRead($downlist, $title, "zips", "")
					GUICtrlSetState($Checkbox_zip, $val)
					$val = IniRead($downlist, $title, "delete", "")
					GUICtrlSetState($Checkbox_delete, $val)
				Else
					GUICtrlSetState($Checkbox_md5, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox_size, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox_zip, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox_delete, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox_md5, $GUI_DISABLE)
					GUICtrlSetState($Checkbox_size, $GUI_DISABLE)
					GUICtrlSetState($Checkbox_zip, $GUI_DISABLE)
					GUICtrlSetState($Checkbox_delete, $GUI_DISABLE)
				EndIf
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
	Local $Updown_threads, $Checkbox_progress
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
	If $auth = "eddie3" Then
		$Button_install = GuiCtrlCreateButton("INSTALL html5lib && html2text", 10, 150, 210, 40)
		GUICtrlSetTip($Button_install, "Install html5lib & html2text in Python!")
	Else
		$Button_install = GuiCtrlCreateButton("INSTALL Required Libraries", 10, 150, 210, 40)
		GUICtrlSetTip($Button_install, "Install html5lib, requests, pyopenssl & html2text in Python!")
	EndIf
	GUICtrlSetFont($Button_install, 9, 600)
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
	;$Label_threads = GuiCtrlCreateLabel("Downloading Threads", 20, 275, 152, 21, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	$Label_threads = GuiCtrlCreateLabel("Download Threads", 20, 275, 130, 21, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_threads, $COLOR_MONEYGREEN)
	GUICtrlSetColor($Label_threads, $COLOR_BLACK)
	GUICtrlSetFont($Label_threads, 8, 600)
	$Input_threads = GuiCtrlCreateInput("", 150, 275, 37, 20)
	GUICtrlSetTip($Input_threads, "Number of threads (files) to download with!")
	$Updown_threads = GUICtrlCreateUpdown($Input_threads)
	GUICtrlSetLimit($Updown_threads, 4, 1)
	GUICtrlSetTip($Updown_threads, "Adjust the number of threads to download with!")
	;
	$Checkbox_progress = GUICtrlCreateCheckbox("", 195, 275, 20, 20)
	GUICtrlSetTip($Checkbox_progress, "Enable use of floating Progress Bar GUI!")
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
	;If $tot > 0 Then
	If $total > 0 Then
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
	If $threads = 1 Then
		If Not FileExists($progbar) Then GUICtrlSetState($Checkbox_progress, $GUI_DISABLE)
	Else
		GUICtrlSetState($Checkbox_progress, $GUI_DISABLE)
	EndIf
	GUICtrlSetState($Checkbox_progress, $bargui)
	;
	$window = $SetupGUI


	GuiSetState(@SW_SHOW, $SetupGUI)
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
			If $auth = "eddie3" Then
				$pid = RunWait(@ComSpec & ' /c pip install html5lib html2text &&pause', "")
			Else
				$pid = RunWait(@ComSpec & ' /c pip install html5lib html2text requests pyopenssl &&pause', "")
			EndIf
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
							$pid = RunWait(@ComSpec & ' /c gogrepo.py login ' & $username & ' ' & $password & ' &&pause', @ScriptDir)
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
			;If $script = "default" Then
				GUISwitch($GOGRepoGUI)
				GUICtrlSetData($Input_langs, $lang)
				GUISwitch($SetupGUI)
			;EndIf
		Case $msg = $Checkbox_progress
			; Enable use of floating Progress Bar GUI
			If GUICtrlRead($Checkbox_progress) = $GUI_CHECKED Then
				$bargui = 1
			Else
				$bargui = 4
			EndIf
			IniWrite($inifle, "Floating Progress Bar GUI", "use", $bargui)
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
			;If $script = "default" Then
				GUISwitch($GOGRepoGUI)
				GUICtrlSetData($Input_langs, $lang)
				GUISwitch($SetupGUI)
			;EndIf
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
			;If $script = "default" Then
				GUISwitch($GOGRepoGUI)
				GUICtrlSetData($Input_langs, $lang)
				GUISwitch($SetupGUI)
			;EndIf
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
				If $threads = 1 And FileExists($progbar) Then
					GUICtrlSetState($Checkbox_progress, $GUI_ENABLE)
				Else
					GUICtrlSetState($Checkbox_progress, $GUI_DISABLE)
					If $bargui = 1 Then
						$bargui = 4
						IniWrite($inifle, "Floating Progress Bar GUI", "use", $bargui)
						GUICtrlSetState($Checkbox_progress, $bargui)
					EndIf
				EndIf
			EndIf
		Case Else
			;;;
		EndSelect
	WEnd
EndFunc ;=> SetupGUI

Func UpdateGUI()
	Local $Button_close, $Button_upnow, $Checkbox_every, $Checkbox_new, $Checkbox_resume, $Checkbox_tag, $Checkbox_uplog
	Local $Combo_install, $Input_language, $Input_OSes, $Label_install, $Label_lang
	Local $installer, $installers, $newgames, $installers, $params, $resume, $skiphid, $tagged, $uplog
	;
	$UpdateGUI = GuiCreate("Update The Manifest", 230, 210, Default, Default, $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU _
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
	$Checkbox_skip = GUICtrlCreateCheckbox("Skip Hidden Games  (set in GOG Library)", 10, 70, 210, 20)
	GUICtrlSetTip($Checkbox_skip, "Skip updating the manifest for hidden games!")
	;
	$Checkbox_uplog = GUICtrlCreateCheckbox("Log File", 10, 95, 55, 20)
	GUICtrlSetTip($Checkbox_uplog, "Save a Log file for update!")
	;
	$Label_install = GuiCtrlCreateLabel("Installers", 75, 95, 65, 21, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_install, $COLOR_BLACK)
	GUICtrlSetColor($Label_install, $COLOR_WHITE)
	GUICtrlSetFont($Label_install, 7, 600, 0, "Small Fonts")
	$Combo_install = GUICtrlCreateCombo("", 140, 95, 80, 21)
	GUICtrlSetTip($Combo_install, "Installers to update for!")
	;
	$Checkbox_new = GUICtrlCreateCheckbox("New Games Only", 10, 121, 100, 20)
	GUICtrlSetTip($Checkbox_new, "Add new games only to the manifest!")
	;
	$Checkbox_tag = GUICtrlCreateCheckbox("Use Update Tag", 124, 121, 95, 20)
	GUICtrlSetTip($Checkbox_tag, "Update games with Update Tag!")
	;
	$Button_upnow = GuiCtrlCreateButton("UPDATE NOW", 10, 150, 140, 50)
	GUICtrlSetFont($Button_upnow, 9, 600)
	GUICtrlSetTip($Button_upnow, "Update the Manifest for specified!")
	;
	$Button_close = GuiCtrlCreateButton("EXIT", 160, 150, 60, 50, $BS_ICON)
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
	If $script = "default" Then
		$resume = 4
		GUICtrlSetState($Checkbox_resume, $GUI_DISABLE)
		$uplog = 4
		GUICtrlSetState($Checkbox_uplog, $GUI_DISABLE)
		$installer = ""
		GUICtrlSetState($Combo_install, $GUI_DISABLE)
	Else
		$resume = IniRead($inifle, "Updating", "resume", "")
		If $resume = "" Then
			$resume = 4
			IniWrite($inifle, "Updating", "resume", $resume)
		EndIf
		GUICtrlSetState($Checkbox_resume, $resume)
		;
		$uplog = IniRead($inifle, "Updating", "log", "")
		If $uplog = "" Then
			$uplog = 1
			IniWrite($inifle, "Updating", "log", $uplog)
		EndIf
		GUICtrlSetState($Checkbox_uplog, $uplog)
		;
		$installers = "Galaxy|Standalone|Both"
		$installer = IniRead($inifle, "Updating", "installers", "")
		If $installer = "" Then
			$installer = "Standalone"
			IniWrite($inifle, "Updating", "installers", $installer)
		EndIf
		GUICtrlSetData($Combo_install, $installers, $installer)
	EndIf
	;
	If $all = 1 Then
		If $script = "default" Then
			$skiphid = 4
			GUICtrlSetState($Checkbox_skip, $GUI_DISABLE)
		Else
			$skiphid = IniRead($inifle, "Hidden Games", "skip", "")
			If $skiphid = "" Then
				$skiphid = 4
				IniWrite($inifle, "Hidden Games", "skip", $skiphid)
			EndIf
			GUICtrlSetState($Checkbox_skip, $skiphid)
		EndIf
		;
		$newgames = IniRead($inifle, "New Games Only", "add", "")
		If $newgames = "" Then
			$newgames = 4
			IniWrite($inifle, "New Games Only", "add", $newgames)
		EndIf
		GUICtrlSetState($Checkbox_new, $newgames)
		;
		$tagged = IniRead($inifle, "Update Tag", "use", "")
		If $tagged = "" Then
			$tagged = 4
			IniWrite($inifle, "Update Tag", "use", $tagged)
		EndIf
		GUICtrlSetState($Checkbox_tag, $tagged)
	Else
		$skiphid = 4
		GUICtrlSetState($Checkbox_skip, $skiphid)
		GUICtrlSetState($Checkbox_skip, $GUI_DISABLE)
		$newgames = 4
		GUICtrlSetState($Checkbox_new, $newgames)
		GUICtrlSetState($Checkbox_new, $GUI_DISABLE)
		$tagged = 4
		GUICtrlSetState($Checkbox_tag, $tagged)
		GUICtrlSetState($Checkbox_tag, $GUI_DISABLE)
	EndIf
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
			CheckForConnection()
			If $connection = 1 Then
				GuiSetState(@SW_HIDE, $UpdateGUI)
				BackupManifestEtc()
				$params = " -skipknown -updateonly -resumemode resume -skiphidden"
				If $newgames = 4 Then $params = StringReplace($params, " -skipknown", "")
				If $tagged = 4 Then $params = StringReplace($params, " -updateonly", "")
				If $resume = 4 Then $params = StringReplace($params, " -resumemode resume", "")
				If $skiphid = 4 Then $params = StringReplace($params, " -skiphidden", "")
				FileChangeDir(@ScriptDir)
				If $all = 1 Then
					$updating = 1
					_FileWriteLog($logfle, "Updated manifest for all games.")
					$pid = RunWait(@ComSpec & ' /c gogrepo.py update -os ' & $OS & ' -lang ' & $lang & $params & ' &&pause', @ScriptDir)
					_FileWriteLog($logfle, "Updated finished.")
				Else
					If $title <> "" Then
						$updating = 1
						_FileWriteLog($logfle, "Updated manifest for - " & $title & ".")
						$pid = RunWait(@ComSpec & ' /c gogrepo.py update -os ' & $OS & ' -lang ' & $lang & $params & ' -id ' & $title & ' &&pause', @ScriptDir)
						_FileWriteLog($logfle, "Updated finished.")
					Else
						MsgBox(262192, "Game Error", "Title is not selected!", $wait, $UpdateGUI)
						ContinueLoop
					EndIf
				EndIf
				GUIDelete($UpdateGUI)
				ExitLoop
			EndIf
		Case $msg = $Checkbox_tag
			; Update games with Update Tag
			If GUICtrlRead($Checkbox_tag) = $GUI_CHECKED Then
				$tagged = 1
			Else
				$tagged = 4
			EndIf
			IniWrite($inifle, "Update Tag", "use", $tagged)
		Case $msg = $Checkbox_skip
			; Skip updating the manifest for hidden games
			If GUICtrlRead($Checkbox_skip) = $GUI_CHECKED Then
				$skiphid = 1
			Else
				$skiphid = 4
			EndIf
			IniWrite($inifle, "Hidden Games", "skip", $skiphid)
		Case $msg = $Checkbox_resume
			; Enable resume mode for updating
			If GUICtrlRead($Checkbox_resume) = $GUI_CHECKED Then
				$resume = 1
			Else
				$resume = 4
			EndIf
			IniWrite($inifle, "Updating", "resume", $resume)
		Case $msg = $Checkbox_new
			; Add new games only to the manifest
			If GUICtrlRead($Checkbox_new) = $GUI_CHECKED Then
				$newgames = 1
			Else
				$newgames = 4
			EndIf
			IniWrite($inifle, "New Games Only", "add", $newgames)
		Case Else
			;;;
		EndSelect
	WEnd
EndFunc ;=> UpdateGUI

Func VerifyGUI()
	Local $Button_close, $Button_verify, $Checkbox_delete, $Checkbox_every, $Checkbox_md5, $Checkbox_size, $Checkbox_zip
	Local $params
	;
	$VerifyGUI = GuiCreate("Verify Game Files", 230, 140, Default, Default, $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU _
															+ $WS_VISIBLE + $WS_CLIPSIBLINGS, $WS_EX_TOPMOST, $window)
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
	GUICtrlSetState($Checkbox_size, $sizecheck)
	GUICtrlSetState($Checkbox_zip, $zipcheck)
	GUICtrlSetState($Checkbox_md5, $md5)
	GUICtrlSetState($Checkbox_delete, $delete)
	;
	If $down = 1 Then GUICtrlSetState($Button_verify, $GUI_DISABLE)
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
			GuiSetState(@SW_HIDE, $VerifyGUI)
			$params = " -skipmd5 -skipsize -skipzip -delete"
			If $md5 = 1 Then $params = StringReplace($params, " -skipmd5", "")
			If $sizecheck = 1 Then $params = StringReplace($params, " -skipsize", "")
			If $zipcheck = 1 Then $params = StringReplace($params, " -skipzip", "")
			If $delete = 4 Then $params = StringReplace($params, " -delete", "")
			FileChangeDir(@ScriptDir)
			If $all = 1 Then
				If $alpha = 1 Then
					For $a = 48 To 90
						If $a < 58 Or $a > 64 Then
							$alf = Chr($a)
							$pid = RunWait(@ComSpec & ' /c gogrepo.py verify' & $params & ' "' & $gamefold & "\" & $alf & '" &&pause', @ScriptDir)
							_FileWriteLog($logfle, "Verified all games in " & $alf & ".")
							If $a < 90 Then
								$ans = MsgBox(262177, "Verify Query", _
									"The games in alphanumeric folder " & $alf & " have just been processed." & @LF & @LF & _
									"Do you want to continue checking the remaining alphanumeric" & @LF & _
									"folder games?", 0, $VerifyGUI)
								If $ans = 2 Then
									ExitLoop
								EndIf
							EndIf
						EndIf
					Next
				Else
					$pid = RunWait(@ComSpec & ' /c gogrepo.py verify' & $params & ' "' & $gamefold & '" &&pause', @ScriptDir)
					_FileWriteLog($logfle, "Verified all games.")
				EndIf
			Else
				;$pid = RunWait(@ComSpec & ' /k gogrepo.py verify' & $params & ' -id ' & $title & ' "' & $gamefold & '"', @ScriptDir)
				$pid = RunWait(@ComSpec & ' /c gogrepo.py verify' & $params & ' -id ' & $title & ' "' & $gamefold & '" &&pause', @ScriptDir)
				_FileWriteLog($logfle, "Verified - " & $title & ".")
			EndIf
			GUIDelete($VerifyGUI)
			ExitLoop
		Case $msg = $Checkbox_zip
			; Enable zip file verification
			If GUICtrlRead($Checkbox_zip) = $GUI_CHECKED Then
				$zipcheck = 1
			Else
				$zipcheck = 4
			EndIf
			IniWrite($inifle, "Verify", "zips", $zipcheck)
		Case $msg = $Checkbox_size
			; Enable file size verification
			If GUICtrlRead($Checkbox_size) = $GUI_CHECKED Then
				$sizecheck = 1
			Else
				$sizecheck = 4
			EndIf
			IniWrite($inifle, "Verify", "size", $sizecheck)
		Case $msg = $Checkbox_md5
			; Enable MD5 checksum verification
			If GUICtrlRead($Checkbox_md5) = $GUI_CHECKED Then
				$md5 = 1
			Else
				$md5 = 4
			EndIf
			IniWrite($inifle, "Verify", "md5", $md5)
		Case $msg = $Checkbox_delete
			; Delete if a file fails integrity check
			If GUICtrlRead($Checkbox_delete) = $GUI_CHECKED Then
				$delete = 1
			Else
				$delete = 4
			EndIf
			IniWrite($inifle, "Verify Failure", "delete", $delete)
		Case Else
			;;;
		EndSelect
	WEnd
EndFunc ;=> VerifyGUI


Func AddGameToDownloadList()
	IniWrite($downlist, "Downloads", "total", $tot)
	IniWrite($downlist, $title, "rank", $tot)
	IniWrite($downlist, $title, "destination", $gamefold)
	;IniWrite($downlist, $title, "OS", $OSget)
	$OS = IniRead($gamesfle, $name, "osextra", "")
	IniWrite($downlist, $title, "osextra", $OS)
	If $script = "default" Then
		IniWrite($downlist, $title, "files", $files)
	Else
		IniWrite($downlist, $title, "standalone", $standalone)
		IniWrite($downlist, $title, "galaxy", $galaxy)
		IniWrite($downlist, $title, "shared", $shared)
		IniWrite($downlist, $title, "log", $downlog)
		IniWrite($downlist, $title, "language", $skiplang)
		IniWrite($downlist, $title, "languages", $langskip)
		IniWrite($downlist, $title, "OS", $skipos)
		$val = StringReplace($osskip, "+", "")
		$val = StringStripWS($val, 7)
		IniWrite($downlist, $title, "OSes", $val)
	EndIf
	IniWrite($downlist, $title, "extras", $extras)
	IniWrite($downlist, $title, "language", $lang)
	IniWrite($downlist, $title, "cover", $cover)
	;If $cover = 1 Then
		$image = IniRead($gamesfle, $name, "image", "")
		IniWrite($downlist, $title, "image", $image)
	;EndIf
	IniWrite($downlist, $title, "verify", $validate)
	;If $files = 1 Then
	If ($files = 1 And $script = "default") Or ($script = "fork" And ($standalone = 1 Or $galaxy = 1 Or $shared = 1)) Then
		IniWrite($downlist, $title, "md5", $md5)
	Else
		; No need to verify game files if not downloading, and a waste of time if they exist.
		IniWrite($downlist, $title, "md5", 4)
	EndIf
	IniWrite($downlist, $title, "size", $sizecheck)
	If $extras = 1 Then
		IniWrite($downlist, $title, "zips", $zipcheck)
	Else
		; No need to verify extra files if not downloading, and a waste of time if they exist.
		IniWrite($downlist, $title, "zips", 4)
	EndIf
	IniWrite($downlist, $title, "delete", $delete)
EndFunc ;=> AddGameToDownloadList

Func BackupManifestEtc()
	Local $addbak, $bdate, $endadd, $endgam, $endloc, $endman, $endtit, $gambak, $locbak, $manbak, $nmb, $ndate, $titbak
	If FileExists($manifest) Then
		If Not FileExists($backups) Then
			; Create Backup folder and backup Manifest file etc for the first time.
			DirCreate($backups)
			FileCopy($manifest, $backups & "\gog-manifest.dat_1.bak")
			FileCopy($titlist, $backups & "\Titles.txt_1.bak")
			FileCopy($gamesfle, $backups & "\Games.ini_1.bak")
			FileCopy($locations, $backups & "\Locations.ini_1.bak")
			FileCopy($addlist, $backups & "\Added.txt_1.bak")
		Else
			; Backup the Manifest file etc.
			$ndate = FileGetTime($manifest, 0, 1)
			$endman = $backups & "\gog-manifest.dat_5.bak"
			If FileExists($endman) Then
				; Shuffle backups along and replace oldest, plus add current Manifest file as newest backup.
				$bdate = FileGetTime($endman, 0, 1)
				If $bdate <> $ndate Then
					; NOTE - Oldest backup is always "_1.bak"
					$manbak = $backups & "\gog-manifest.dat"
					$endman = $manbak & "_5.bak"
					$titbak = $backups & "\Titles.txt"
					$endtit = $titbak & "_5.bak"
					$gambak = $backups & "\Games.ini"
					$endgam = $gambak & "_5.bak"
					$locbak = $backups & "\Locations.ini"
					$endloc = $locbak & "_5.bak"
					$addbak = $backups & "\Added.txt"
					$endadd = $addbak & "_5.bak"
					For $nmb = 1 To 4
						FileMove($manbak & "_" & ($nmb + 1) & ".bak", $manbak & "_" & $nmb & ".bak", 1)
						FileMove($titbak & "_" & ($nmb + 1) & ".bak", $titbak & "_" & $nmb & ".bak", 1)
						FileMove($gambak & "_" & ($nmb + 1) & ".bak", $gambak & "_" & $nmb & ".bak", 1)
						FileMove($locbak & "_" & ($nmb + 1) & ".bak", $locbak & "_" & $nmb & ".bak", 1)
						FileMove($addbak & "_" & ($nmb + 1) & ".bak", $addbak & "_" & $nmb & ".bak", 1)
					Next
					FileCopy($manifest, $endman, 1)
					FileCopy($titlist, $endtit, 1)
					FileCopy($gamesfle, $endgam, 1)
					FileCopy($locations, $endloc, 1)
					FileCopy($addlist, $endadd, 1)
				EndIf
			Else
				; Add current Manifest file as newest backup in an empty slot.
				For $nmb = 1 To 5
					$manbak = $backups & "\gog-manifest.dat_" & $nmb & ".bak"
					$titbak = $backups & "\Titles.txt_" & $nmb & ".bak"
					$gambak = $backups & "\Games.ini_" & $nmb & ".bak"
					$locbak = $backups & "\Locations.ini_" & $nmb & ".bak"
					$addbak = $backups & "\Added.txt_" & $nmb & ".bak"
					If Not FileExists($manbak) Then
						If $nmb = 1 Then
							FileCopy($manifest, $manbak)
							FileCopy($titlist, $titbak, 1)
							FileCopy($gamesfle, $gambak, 1)
							FileCopy($locations, $locbak, 1)
							FileCopy($addlist, $addbak, 1)
						Else
							$bdate = FileGetTime($endman, 0, 1)
							If $bdate <> $ndate Then
								FileCopy($manifest, $manbak)
								FileCopy($titlist, $titbak, 1)
								FileCopy($gamesfle, $gambak, 1)
								FileCopy($locations, $locbak, 1)
								FileCopy($addlist, $addbak, 1)
							EndIf
						EndIf
						ExitLoop
					EndIf
					$endman = $manbak
				Next
			EndIf
		EndIf
	EndIf
EndFunc ;=> BackupManifestEtc

Func CheckForConnection()
	Local $IP, $pingerr, $pingmsg, $rndtrip, $server, $timeout
	;
	$server = IniRead($inifle, "Web", "server", "")
	If $server = "" Then
		; "www.amazon.com" always time out
		; "www.google.com"
		$server = "www.gog.com"
		IniWrite($inifle, "Web", "server", $server)
	EndIf
	;
	$timeout = IniRead($inifle, "Ping", "timeout", "")
	If $timeout = "" Then
		; AutoIt default is 4000 milliseconds (4 seconds)
		$timeout = 4000
		IniWrite($inifle, "Ping", "timeout", $timeout)
	EndIf
	;
	$rndtrip = Ping($server, $timeout)
	If $rndtrip > 0 Then
		$connection = 1
	Else
		$pingerr = @error
		IniWrite($inifle, "Ping", "error", $pingerr)
		$connection = ""
		$IP = _GetIP()
		If (@error = 1 Or $IP = -1 Or @extended = 1) Then
			MsgBox(262192, "Connect Error", "No connection detected!", 0, $window)
		Else
			If $pingerr = 1 Then
				$pingerr = "Host is offline."
			ElseIf $pingerr = 2 Then
				$pingerr = "Host is unreachable."
			ElseIf $pingerr = 3 Then
				$pingerr = "Bad destination."
			ElseIf $pingerr = 4 Then
				$pingerr = "Other errors"
			EndIf
			Local $pingmsg = "Server Address could not be found." & @LF & @LF & _
				"Error = " & $pingerr & @LF & @LF & _
				"Timeout may need to be increased." & @LF & @LF & _
				"NOTE = If this continues to occur over" & @LF & _
				"a long length of time, then advise you" & @LF & _
				"manually check (browse) and perhaps" & @LF & _
				"change the server address in program" & @LF & _
				"settings. Or it may be a VPN issue."
			If $pingerr = "Other errors" Then
				$ans = MsgBox(262449, "Server Error", _
					$pingmsg & @LF & @LF & _
					"OK = Still proceed with connecting." & @LF & _
					"CANCEL = Abort.", 0, $window)
				If $ans = 1 Then $connection = 1
			Else
				MsgBox(262192, "Server Error", $pingmsg, 0, $window)
			EndIf
		EndIf
	EndIf
	IniWrite($inifle, "Ping", "roundtrip", $rndtrip & " milliseconds")
EndFunc ;=> CheckForConnection

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
	Local $current, $params
	If FileExists($downlist) Then
		If ProcessExists($pid) Then
			Return
		Else
			$pid = 0
			$title = IniRead($inifle, "Current Download", "title", "")
			$current = $title
			$val = IniRead($inifle, "Current Download", "verify", "")
			If $val = 1 And $verifying = "" Then
				$verifying = 1
				$params = " -skipmd5 -skipsize -skipzip -delete"
				$val = IniRead($inifle, "Current Download", "md5", "")
				If $val = 1 Then $params = StringReplace($params, " -skipmd5", "")
				$val = IniRead($inifle, "Current Download", "size", "")
				If $val = 1 Then $params = StringReplace($params, " -skipsize", "")
				$val = IniRead($inifle, "Current Download", "zips", "")
				If $val = 1 Then $params = StringReplace($params, " -skipzip", "")
				$val = IniRead($inifle, "Current Download", "delete", "")
				If $val = 4 Then $params = StringReplace($params, " -delete", "")
				;
				$val = IniRead($inifle, "Current Download", "destination", "")
				If $minimize = 1 Then
					$flag = @SW_MINIMIZE
				Else
					;$flag = @SW_RESTORE
					$flag = @SW_SHOW
				EndIf
				_FileWriteLog($logfle, "Verified - " & $current & ".")
				$pid = Run(@ComSpec & ' /c gogrepo.py verify' & $params & ' -id ' & $current & ' "' & $val & '"', @ScriptDir, $flag)
				Return
			Else
				$verifying = ""
				If $cover = 1 Then
					$image = IniRead($inifle, "Current Download", "image", "")
					If $image <> "" Then
						SplashTextOn("", "Saving Cover!", 200, 120, Default, Default, 33)
						$gamepic = $gamefold & "\" & $current & "\Folder.jpg"
						InetGet($image, $gamepic, 1, 0)
						If Not FileExists($gamepic) Then
							InetGet($image, $gamepic, 0, 0)
							If Not FileExists($gamepic) Then
								InetGet($image, $gamepic, 0, 1)
							EndIf
						EndIf
						SplashOff()
					EndIf
				EndIf
				_FileWriteLog($finished, $current)
				_FileWriteLog($logfle, "Download finished.")
				If $window = $QueueGUI Then
					GUICtrlSetData($Input_download, "")
					_GUICtrlListBox_AddString($List_done, $current)
					$cnt = $cnt + 1
					GUICtrlSetData($Group_done, "Downloads Finished  (" & $cnt & ")")
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
						$done = $done + 1
						$titles = IniReadSectionNames($downlist)
						If Not @error Then
							If $titles[0] > 1 Then
								CheckForConnection()
								If $connection = 1 Then
									$title = $titles[2]
									$current = $title
									_FileWriteLog($logfle, "Downloaded - " & $current & ".")
									IniWrite($inifle, "Current Download", "title", $current)
									$gamefold = IniRead($downlist, $current, "destination", "")
									IniWrite($inifle, "Current Download", "destination", $gamefold)
									;
									If $script = "default" Then
										$params = " -skipextras -skipgames"
										$val = IniRead($downlist, $current, "files", "")
										IniWrite($inifle, "Current Download", "files", $val)
										If $val = 1 Then $params = StringReplace($params, " -skipgames", "")
									Else
										$val = IniRead($downlist, $title, "standalone", "")
										IniWrite($inifle, "Current Download", "standalone", $val)
										If $val = 1 Then $params = StringReplace($params, " -skipstandalone", "")
										$val = IniRead($downlist, $title, "galaxy", "")
										IniWrite($inifle, "Current Download", "galaxy", $val)
										If $val = 1 Then $params = StringReplace($params, " -skipgalaxy", "")
										$val = IniRead($downlist, $title, "shared", "")
										IniWrite($inifle, "Current Download", "shared", $val)
										If $val = 1 Then $params = StringReplace($params, " -skipshared", "")
										$val = IniRead($downlist, $title, "log", "")
										IniWrite($inifle, "Current Download", "log", $val)
										If $val = 1 Then $params = StringReplace($params, " -nolog", "")
										;
										$val = IniRead($downlist, $title, "language", "")
										IniWrite($inifle, "Current Download", "language", $val)
										If $val = 1 Then
											$val = IniRead($downlist, $title, "languages", "")
											If $val <> "" Then $params = $params & " -skiplang " & $val
										Else
											$val = ""
										EndIf
										IniWrite($inifle, "Current Download", "languages", $val)
										;
										$val = IniRead($downlist, $title, "OS", "")
										IniWrite($inifle, "Current Download", "OS", $val)
										If $val = 1 Then
											$val = IniRead($downlist, $title, "OSes", "")
											If $val <> "" Then $params = $params & " -skipos " & $val
										Else
											$val = ""
										EndIf
										IniWrite($inifle, "Current Download", "OSes", $val)
									EndIf
									$val = IniRead($downlist, $current, "extras", "")
									IniWrite($inifle, "Current Download", "extras", $val)
									If $val = 1 Then $params = StringReplace($params, " -skipextras", "")
									;
									$val = IniRead($downlist, $current, "cover", "")
									IniWrite($inifle, "Current Download", "cover", $val)
									If $val = 1 Then
										$image = IniRead($downlist, $current, "image", "")
										IniWrite($inifle, "Current Download", "image", $image)
									EndIf
									$val = IniRead($downlist, $current, "verify", "")
									IniWrite($inifle, "Current Download", "verify", $val)
									$val = IniRead($downlist, $current, "md5", "")
									IniWrite($inifle, "Current Download", "md5", $val)
									$val = IniRead($downlist, $current, "size", "")
									IniWrite($inifle, "Current Download", "size", $val)
									$val = IniRead($downlist, $current, "zips", "")
									IniWrite($inifle, "Current Download", "zips", $val)
									$val = IniRead($downlist, $current, "delete", "")
									IniWrite($inifle, "Current Download", "delete", $val)
									If $minimize = 1 Then
										$flag = @SW_MINIMIZE
									Else
										;$flag = @SW_RESTORE
										$flag = @SW_SHOW
									EndIf
									If $bargui = 1 And FileExists($progbar) Then
										$pid = ShellExecute($progbar, "Download", @ScriptDir, "open", $flag)
									Else
										$pid = Run(@ComSpec & ' /c gogrepo.py download' & $params & ' -id ' & $current & ' "' & $gamefold & '"', @ScriptDir, $flag)
									EndIf
									;$progress = $done + $tot
									$progress = $total
									$percent = (($done * 100) + $done) / ($progress + ($progress * 100))
									$percent = $percent * 100
									;$percent = Round($percent)
									If $window = $QueueGUI Then
										GUICtrlSetData($Input_download, $current)
										GUICtrlSetData($Progress_bar, $percent)
										GUICtrlSetTip($Progress_bar, Round($percent, 1) & "%")
										RemoveListEntry(0)
									Else
										$val = $current
										IniDelete($downlist, $current)
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
								Else
									AdlibUnRegister("CheckOnGameDownload")
								EndIf
							Else
								AdlibUnRegister("CheckOnGameDownload")
							EndIf
						Else
							AdlibUnRegister("CheckOnGameDownload")
						EndIf
						Return
					Else
						$started = 4
						$pid = ""
						$wait = 0
						AdlibUnRegister("CheckOnGameDownload")
						IniDelete($inifle, "Current Download")
						$done = $done + 1
						If $window = $QueueGUI Then
							GUICtrlSetState($Button_stop, $GUI_DISABLE)
							$percent = 100
							GUICtrlSetData($Progress_bar, $percent)
							GUICtrlSetTip($Progress_bar, $percent & "%")
						EndIf
						$total = 0
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
	GUICtrlSetState($Button_move, $GUI_ENABLE)
	GUICtrlSetState($Button_log, $GUI_ENABLE)
	GUICtrlSetData($Label_added, $total)
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
	GUICtrlSetData($Group_waiting, "Games To Download")
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
	GUICtrlSetState($Control_1, $GUI_UNCHECKED)
	GUICtrlSetState($Control_2, $GUI_UNCHECKED)
	GUICtrlSetState($Control_3, $GUI_UNCHECKED)
	GUICtrlSetState($Control_4, $GUI_UNCHECKED)
	GUICtrlSetState($Control_1, $GUI_DISABLE)
	GUICtrlSetState($Control_2, $GUI_DISABLE)
	GUICtrlSetState($Control_3, $GUI_DISABLE)
	GUICtrlSetState($Control_4, $GUI_DISABLE)
	GUICtrlSetState($Control_5, $GUI_ENABLE)
	DisableQueueButtons()
	;
	GUISwitch($GOGRepoGUI)
	GUICtrlSetState($Checkbox_update, $GUI_ENABLE)
	GUICtrlSetState($Checkbox_verify, $GUI_ENABLE)
	GUICtrlSetState($Checkbox_all, $GUI_ENABLE)
	GUICtrlSetBkColor($Label_added, $COLOR_GREEN)
	GUICtrlSetData($Label_added, $total)
	;GUICtrlSetState($Button_setup, $GUI_ENABLE)
	GUISwitch($QueueGUI)
EndFunc ;=> ClearDisableEnableRestore

Func CreateListOfGames($for, $file)
	Local $i, $item, $items, $listtxt, $names, $sorted, $sum
	$names = ""
	$sum = 0
	If $file = $titlist Then
		$sorted = "Sorted"
		If FileExists($titlist) Then
			SplashTextOn("", "Please Wait!", 200, 120, Default, Default, 33)
			$items = _GUICtrlListBox_GetCount($List_games)
			For $i = 0 To ($items - 1)
				$item = _GUICtrlListBox_GetText($List_games, $i)
				If $item <> "" Then
					$val = IniRead($gamesfle, $item, "osextra", "")
					If ($for = "ALL" And $val <> "") Or StringInStr($val, $for) > 0 Then
						If $for = "Windows" Then
							If StringInStr($val, "Linux") > 0 Or StringInStr($val, "MAC") > 0 Then ContinueLoop
						EndIf
						$sum = $sum + 1
						If $names = "" Then
							$names = $item
						Else
							$names = $names & @CRLF & $item
						EndIf
					EndIf
				EndIf
			Next
			SplashOff()
		EndIf
	ElseIf $file = $addlist Then
		$sorted = "Unsorted"
		If FileExists($addlist) Then
			SplashTextOn("", "Please Wait!", 200, 120, Default, Default, 33)
			$res = _FileReadToArray($addlist, $array)
			If $res = 1 Then
				For $a = 1 To $array[0]
					$item = $array[$a]
					If $item <> "" Then
						$val = IniRead($gamesfle, $item, "osextra", "")
						If ($for = "ALL" And $val <> "") Or StringInStr($val, $for) > 0 Then
							If $for = "Windows" Then
								If StringInStr($val, "Linux") > 0 Or StringInStr($val, "MAC") > 0 Then ContinueLoop
							EndIf
							$val = IniRead($gamesfle, $item, "title", "")
							$item = "(" & $val & ") " & $item
							$sum = $sum + 1
							If $names = "" Then
								$names = $item
							Else
								$names = $names & @CRLF & $item
							EndIf
						EndIf
					EndIf
				Next
			EndIf
			SplashOff()
		EndIf
	EndIf
	If $names = "" Then
		MsgBox(262192, "List Result", "No games found for the specified OS!", $wait, $GOGRepoGUI)
	Else
		$listtxt = @ScriptDir & "\" & $for & " Games " & $sorted & ".txt"
		_FileCreate($listtxt)
		If $for = "Windows" Then $for = "Windows Only"
		FileWrite($listtxt, "(" & $sum & " - " & $for & " Games)" & @CRLF & @CRLF & $names)
		GUISetState(@SW_MINIMIZE, $GOGRepoGUI)
		ShellExecute($listtxt)
	EndIf
EndFunc ;=> CreateListOfGames

Func DisableQueueButtons()
	If $started = 4 Then GUICtrlSetState($Button_stop, $GUI_DISABLE)
	GUICtrlSetState($Button_start, $GUI_DISABLE)
	GUICtrlSetState($Button_add, $GUI_DISABLE)
	GUICtrlSetState($Button_removall, $GUI_DISABLE)
	GUICtrlSetState($Button_remove, $GUI_DISABLE)
EndFunc ;=> DisableQueueButtons

Func EnableDisableControls($state)
	GUICtrlSetState($List_games, $state)
	GUICtrlSetState($Input_name, $state)
	GUICtrlSetState($Button_last, $state)
	GUICtrlSetState($Input_title, $state)
	GUICtrlSetState($Button_find, $state)
	GUICtrlSetState($Button_fix, $state)
	;GUICtrlSetState($Input_OS, $state)
	;GUICtrlSetState($Input_extra, $state)
	GUICtrlSetState($Button_detail, $state)
	;
	GUICtrlSetState($Pic_cover, $state)
	GUICtrlSetState($Button_pic, $state)
	GUICtrlSetState($Checkbox_show, $state)
	;
	GUICtrlSetState($Button_down, $state)
	If $verify = 4 Then GUICtrlSetState($Checkbox_update, $state)
	If $update = 4 Then GUICtrlSetState($Checkbox_verify, $state)
	GUICtrlSetState($Checkbox_all, $state)
	GUICtrlSetState($Button_queue, $state)
	;
	GUICtrlSetState($Combo_OS, $state)
	GUICtrlSetState($Checkbox_extra, $state)
	GUICtrlSetState($Checkbox_test, $state)
	GUICtrlSetState($Checkbox_cover, $state)
	If $script = "default" Then
		GUICtrlSetState($Checkbox_game, $state)
	ElseIf $script = "fork" Then
		GUICtrlSetState($Button_more, $state)
	EndIf
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
					If $line[0] = 2 Then
						$name = $line[1]
						GUICtrlSetData($List_games, $name)
						$games = $games + 1
					EndIf
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

Func GetAuthorAndVersion()
	Local $author, $change, $gogvers
	$res = _FileReadToArray($gogrepo, $array)
	If $res = 1 Then
		$author = ""
		$gogvers = ""
		$change = ""
		For $a = 1 To $array[0]
			$line = $array[$a]
			If StringInStr($line, "__author__") > 0 Then
				$line = StringSplit($line, "__author__", 1)
				$val = $line[2]
				$val = StringReplace($val, "=", "")
				$val = StringReplace($val, "'", "")
				$author = StringStripWS($val, 7)
				If $auth = "" Or $author <> $auth Then
					If $auth <> "" Then $change &= "Author"
					$auth = $author
					IniWrite($inifle, "gogrepo.py", "author", $auth)
				EndIf
			ElseIf StringInStr($line, "__version__") > 0 Then
				$line = StringSplit($line, "__version__", 1)
				$val = $line[2]
				$val = StringReplace($val, "=", "")
				$val = StringReplace($val, "'", "")
				$gogvers = StringStripWS($val, 7)
				If $vers = "" Or $gogvers <> $vers Then
					If $vers <> "" Then $change &= "Version"
					$vers = $gogvers
					IniWrite($inifle, "gogrepo.py", "version", $vers)
				EndIf
			EndIf
			If $author <> "" And $gogvers <> "" Then ExitLoop
		Next
		If $author = "" Or $gogvers = "" Then
			MsgBox(262192, "Extract Error", "Could not determine Author &/or Version of 'gogrepo.py'.", 0, $GOGRepoGUI)
		Else
			If $change <> "" Then
				$change = StringReplace($change, "AuthorVersion", "Author & Version")
				$change = StringReplace($change, "VersionAuthor", "Author & Version")
				MsgBox(262192, "Script Change", $change & " haa changed for 'gogrepo.py'." _
					& @LF & @LF & "NOTE - This may mean that different options are now" _
					& @LF & "available  for (or removed from) use in GOGRepo GUI.", 0, $GOGRepoGUI)
			EndIf
		EndIf
	Else
		MsgBox(262192, "Read Error", "Could not get Author & Version of 'gogrepo.py'.", 0, $GOGRepoGUI)
	EndIf
	;MsgBox(262192, "Got Here", "Author & Version of 'gogrepo.py'.", 0, $GOGRepoGUI)
EndFunc ;=> GetAuthorAndVersion

Func GetTheSize()
	If $size < 1024 Then
		$size = $size & " bytes"
	ElseIf $size < 1048576 Then
		$size = $size / 1024
		$size =  Round($size) & " Kb"
	ElseIf $size < 1073741824 Then
		$size = $size / 1048576
		$size =  Round($size, 1) & " Mb"
	ElseIf $size < 1099511627776 Then
		$size = $size / 1073741824
		$size = Round($size, 2) & " Gb"
	Else
		$size = $size / 1099511627776
		$size = Round($size, 3) & " Tb"
	EndIf
EndFunc ;=> GetTheSize

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
			$latest = ""
			$lines = ""
			$textdump = ""
			For $c = 2 To $chunks
				$game = $chunk[$c]
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
					$OSextras = ""
					$forum = ""
					$image = ""
					$name = ""
					$OS = ""
					$store = ""
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
					If $OS <> "" Then $OSextras = " " & $OS
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
						GetAllowedName()
					Else
						; Cover rarer scenario of double quotes instead of single ones.
						$check = StringSplit($segment, "'long_title': ", 1)
						If $check[0] > 1 Then
							$name = $check[2]
							$check = StringSplit($name, '",', 1)
							$name = StringReplace($check[1], '"', '')
							GetAllowedName()
						EndIf
					EndIf
					$check = StringSplit($segment, "'store_url': '", 1)
					If $check[0] > 1 Then
						$store = $check[2]
						$check = StringSplit($store, "',", 1)
						$store = $check[1]
					EndIf
					$check = StringSplit($segment, "'forum_url': '", 1)
					If $check[0] > 1 Then
						$forum = $check[2]
						$check = StringSplit($forum, "',", 1)
						$forum = $check[1]
					EndIf
					;
					$line = $name & " | " & $title & $OSextras & $image
					If $lines = "" Then
						$lines = $line
					Else
						$lines = $lines & @CRLF & $line
					EndIf
					;
					If $latest = "" Then
						$latest = $name
					Else
						$latest = $latest & @CRLF & $name
					EndIf
					;
					$text = "[" & $name & "]" & @CRLF
					$text = $text & "title=" & $title & @CRLF
					$text = $text & "name=" & $name & @CRLF
					$OS = StringReplace($OS, "(", "")
					$OS = StringReplace($OS, ")", "")
					$text = $text & "osextra=" & $OS & @CRLF
					$image = StringTrimLeft($image, 3)
					$text = $text & "image=" & $image & @CRLF
					$text = $text & "store=" & $store & @CRLF
					$text = $text & "forum=" & $forum & @CRLF
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
				$textdump = ""
			EndIf
			If $latest <> "" Then
				$open = FileOpen($addlist, 2)
				FileWriteLine($open, $latest)
				FileClose($open)
				$latest = ""
			EndIf
			If $lines <> "" Then
				$lines = StringSplit($lines, @CRLF, 1)
				_ArraySort($lines, 0, 1)
				$lines = _ArrayToString($lines, @CRLF, 1)
				FileWrite($file, $lines & @CRLF)
				$lines = ""
			EndIf
		EndIf
		$date = _NowCalc()
		$date = StringReplace($date, "/", "-")
		FileWriteLine($file, "List Completed on " & $date)
		FileClose($file)
		$read = ""
		;$textdump = ""
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
		If ($pid = "" Or $pid = 0) And $started = 4 Then ClearDisableEnableRestore()
		;$total = 0
		$downall = 4
		IniWrite($inifle, "Download ALL", "activated", $downall)
	EndIf
	IniWrite($downlist, "Downloads", "total", $tot)
EndFunc ;=> RemoveListEntry

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

Func ShowCorrectImage()
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
		GUICtrlSetData($Label_cover, "")
	Else
		GUICtrlSetImage($Pic_cover, $blackjpg)
	EndIf
EndFunc ;=> ShowCorrectImage
