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
; DownloadAllGUI(), DownloadGUI(), FileCheckerGUI(), FileSelectorGUI(), MainGUI(), QueueGUI(), SetupGUI()
; UpdateGUI(), VerifyGUI()
;
; BackupManifestEtc(), CheckForConnection(), CheckIfPythonRunning(), CheckOnGameDownload(), CheckOnShutdown()
; ClearDisableEnableRestore(), CreateListOfGames($for, $file), DisableQueueButtons(), EnableDisableControls($state)
; EnableDisableCtrls($state), FillTheGamesList(), FullComparisonCheck(), GetAllowedName(), GetAuthorAndVersion()
; GetTheSize(), GetWindowPosition(), ParseTheManifest($show), RemoveListEntry($num), ReplaceForeignCharacters($text)
; ShowCorrectImage()

#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <ListBoxConstants.au3>
#include <ListViewConstants.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <StringConstants.au3>
#include <GuiListBox.au3>
#include <GuiListView.au3>
#include <GuiComboBox.au3>
#include <Misc.au3>
#include <Inet.au3>
#include <File.au3>
#include <Date.au3>
#include <Array.au3>
#include <ScreenCapture.au3>
#include <GDIPlus.au3>
#include <WinAPI.au3>

_Singleton("gog-repo-gui-timboli")

Global $Button_add, $Button_dest, $Button_detail, $Button_down, $Button_exit, $Button_find, $Button_fix
Global $Button_fold, $Button_info, $Button_last, $Button_log, $Button_more, $Button_movedown, $Button_moveup
Global $Button_pic, $Button_queue, $Button_removall, $Button_remove, $Button_setup, $Button_start, $Button_stop
Global $Checkbox_all, $Checkbox_alpha, $Checkbox_check, $Checkbox_cover, $Checkbox_extra, $Checkbox_files
Global $Checkbox_game, $Checkbox_image, $Checkbox_linux, $Checkbox_log, $Checkbox_other, $Checkbox_show
Global $Checkbox_test, $Checkbox_update, $Checkbox_verify, $Checkbox_win, $Combo_dest, $Combo_OS, $Combo_shutdown
Global $Group_done, $Group_download, $Group_games, $Group_waiting, $Input_dest, $Input_destination, $Input_download
Global $Input_extra, $Input_lang, $Input_langs, $Input_name, $Input_OP, $Input_OS, $Input_title, $Label_action
Global $Label_added, $Label_cover, $Label_num, $List_done, $List_games, $List_waiting, $Pic_cover, $Progress_bar
;, $Button_move
Global $Menu_games, $Menu_linux, $Menu_list, $Menu_mac, $Menu_windows, $Item_allsort, $Item_allunsort, $Item_check
Global $Item_content, $Item_delete, $Item_download, $Item_forum, $Item_info, $Item_library, $Item_linsort
Global $Item_linunsort, $Item_macsort, $Item_macunsort, $Item_remove, $Item_store, $Item_winsort, $Item_winunsort
;
Global $Control_1, $Control_2, $Control_3, $Control_4, $Control_5
;
Global $Ctrl_1, $Ctrl_2, $Ctrl_3, $Ctrl_4, $Ctrl_5, $Ctrl_6, $Ctrl_7, $Ctrl_8, $Ctrl_9, $Ctrl_10, $Ctrl_11, $Ctrl_12
Global $Ctrl_13, $Ctrl_14, $Ctrl_15, $Ctrl_16, $Ctrl_17, $Ctrl_18, $Ctrl_19, $Ctrl_20, $Ctrl_21, $Ctrl_22
;
Global $a, $addlist, $alf, $all, $alpha, $ans, $array, $auth, $auto, $backups, $bargui, $bigpic, $blackjpg, $c
Global $changed, $check, $chunk, $chunks, $cnt, $compfold, $connection, $cookies, $cover, $date, $delay, $delete
Global $dest, $done, $down, $downall, $downlist, $DownloadAllGUI, $DownloadGUI, $downlog, $drv, $extras, $fdate
Global $file, $files, $finished, $flag, $for, $forum, $galaxy, $game, $gamefold, $gamepic, $games, $gamesfle
Global $gamesfold, $gogrepo, $GOGRepoGUI, $height, $icoD, $icoF, $icoI, $icoS, $icoT, $icoX, $image, $imgfle
Global $ind, $infofle, $inifle, $lang, $langskip, $last, $latest, $left, $line, $lines, $locations, $logfle
Global $manifest, $md5, $message, $minimize, $name, $newfile, $num, $open, $OS, $OSextras, $OSget, $osskip
Global $path, $percent, $pid, $progbar, $progress, $QueueGUI, $read, $repolog, $res, $s, $script, $segment, $SetupGUI
Global $shared, $shell, $show, $shutdown, $SimpleGUI, $size, $sizecheck, $skiplang, $skipos, $splash, $split
Global $stagesfix, $standalone, $started, $state, $stop, $store, $style, $t, $text, $textdump, $threads, $titfile
Global $title, $titles, $titlist, $top, $tot, $total, $type, $update, $updated, $UpdateGUI, $updating, $user, $val
Global $validate, $validation, $verify, $VerifyGUI, $verifying, $vers, $version, $veryalone, $veryextra, $verygalaxy
Global $verygames, $verylog, $veryshare, $wait, $warning, $width, $window, $winpos, $xpos, $ypos, $zipcheck

$addlist = @ScriptDir & "\Added.txt"
$backups = @ScriptDir & "\Backups"
$bigpic = @ScriptDir & "\Big.jpg"
$blackjpg = @ScriptDir & "\Black.jpg"
$changed = @ScriptDir & "\Changed.txt"
$compfold = @ScriptDir & "\Comparisons"
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
$repolog = @ScriptDir & "\gogrepo.log"
$splash = @ScriptDir & "\Splash.jpg"
$titlist = @ScriptDir & "\Titles.txt"
$version = "v1.1"

$SimpleGUI = @ScriptDir & "\GOGRepo Simple GUI.au3"
If FileExists($SimpleGUI) Then
	$warning = 1
Else
	$SimpleGUI = @ScriptDir & "\GOGRepo Simple GUI.exe"
	If FileExists($SimpleGUI) Then
		$warning = 1
	EndIf
EndIf
If $warning = 1 Then
	MsgBox(262192, "Program Warning", "This program cannot exist and run in the same folder" _
		& @LF & "as my GOGRepo Simple GUI program. It will now exit.", 0)
	Exit
EndIf

If FileExists($splash) Then SplashImageOn("", $splash, 350, 300, Default, Default, 1)

If Not FileExists($titlist) Then _FileCreate($titlist)
If Not FileExists($changed) Then _FileCreate($changed)

If Not FileExists($compfold) Then DirCreate($compfold)

If Not FileExists($blackjpg) Then
	Local $hBitmap, $hGraphic, $hImage
	_GDIPlus_Startup()
	$hBitmap = _ScreenCapture_Capture("", 0, 0, 100, 100, False)
	$hImage = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap)
	$hGraphic = _GDIPlus_ImageGetGraphicsContext($hImage)
	_GDIPlus_GraphicsClear($hGraphic, 0xFF000000)
	_GDIPlus_ImageSaveToFile($hImage, $blackjpg)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_ImageDispose($hImage)
	_WinAPI_DeleteObject($hBitmap)
	_GDIPlus_ShutDown()
	If Not FileExists($blackjpg) Then
		If FileExists($splash) Then SplashOff()
		MsgBox(262192, "Program Error", "This program requires an image file named" _
			& @LF & "'Black.jpg' for the default cover image file." _
			& @LF & "It needs to be in the main program folder." _
			& @LF & @LF & "This program will now exit.", 0)
		Exit
	EndIf
EndIf

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

;~ ;SplashTextOn("Updating", @LF & "Starting!", 180, 110, Default, Default, 18, "", 12, 400)
;~ SplashTextOn("", "Updating!", 180, 110, Default, Default, 33, "", 12, 400)
;~ Sleep(1000)
;~ $loop = 1
;~ $blocks = 3
;~ $id = 44
;~ $message = "Block " & $loop & " of " & $blocks & @LF & "(" & $id & " games)"
;~ ;ControlSetText("Updating", "", "Static1", $message, 1)
;~ SplashTextOn("", $message, 180, 110, Default, Default, 35, "", 12, 400)
;~ Sleep(9000)
;~ SplashOff()

If FileExists($titlist) Then
	$updated = IniRead($inifle, "Program", "updated", "")
	$lines = _FileCountLines($titlist)
	If $lines = 0 Or $updated <> 1 Then
		If FileExists($splash) Then
			ParseTheManifest(0)
		Else
			ParseTheManifest(1)
		EndIf
		$updated = 1
		IniWrite($inifle, "Program", "updated", $updated)
	EndIf
	MainGUI()
Else
	If FileExists($splash) Then SplashOff()
	MsgBox(262192, "Program Error", "Titles.txt file could not be created!", 0)
EndIf

Exit

Func MainGUI()
	Local $Group_added, $Group_cover, $Group_dest, $Group_down, $Group_update
	Local $Label_extra, $Label_OS, $Label_title
	;
	Local $add, $content, $display, $dll, $exist, $find, $fold, $mpos, $OSes, $pth
	;
	$width = 590
	$height = 405
	$left = IniRead($inifle, "Program Window", "left", @DesktopWidth - $width - 25)
	$top = IniRead($inifle, "Program Window", "top", @DesktopHeight - $height - 30)
	$style = $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU + $WS_CLIPSIBLINGS + $WS_MINIMIZEBOX ; + $WS_VISIBLE
	$GOGRepoGUI = GuiCreate("GOGRepo GUI " & $version, $width, $height, $left, $top, $style, $WS_EX_TOPMOST)
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
	$Group_cover = GuiCtrlCreateGroup("Cover or Status", 390, 10, 190, 160)
	$Pic_cover = GUICtrlCreatePic($blackjpg, 400, 30, 170, 100, $SS_NOTIFY)
	GUICtrlSetTip($Pic_cover, "Game cover image (click to enlarge)!")
	$Label_action = GuiCtrlCreateLabel("", 405, 40, 160, 20, $SS_CENTER + $SS_CENTERIMAGE)
	GUICtrlSetFont($Label_action, 8, 600)
	GUICtrlSetBkColor($Label_action, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor($Label_action, $COLOR_WHITE)
	$Label_cover = GuiCtrlCreateLabel("", 405, 70, 160, 20, $SS_CENTER + $SS_CENTERIMAGE)
	GUICtrlSetBkColor($Label_cover, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor($Label_cover, $COLOR_WHITE)
	$Label_num = GuiCtrlCreateLabel("", 405, 100, 160, 20, $SS_CENTER + $SS_CENTERIMAGE)
	GUICtrlSetFont($Label_num, 9, 600)
	GUICtrlSetBkColor($Label_num, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor($Label_num, $COLOR_WHITE)
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
	$Input_dest = GUICtrlCreateInput("", 88, $height - 43, 179, 21)
	;GUICtrlSetBkColor($Input_dest, 0xFFFFB0)
	GUICtrlSetTip($Input_dest, "Destination path (main parent folder for games)!")
	$Button_dest = GuiCtrlCreateButton("B", 272, $height - 43, 20, 21, $BS_ICON)
	GUICtrlSetTip($Button_dest, "Browse to set the destination folder!")
	$Checkbox_alpha = GUICtrlCreateCheckbox("Alpha", 297, $height - 43, 45, 21)
	GUICtrlSetTip($Checkbox_alpha, "Create alphanumeric sub-folder!")
	$Button_fold = GuiCtrlCreateButton("Open", 347, $height - 44, 23, 22, $BS_ICON)
	GUICtrlSetTip($Button_fold, "Open the selected destination folder!")
	;$Button_move = GuiCtrlCreateButton("Move", 321, $height - 44, 49, 22)
	;GUICtrlSetFont($Button_move, 7, 600, 0, "Small Fonts")
	;GUICtrlSetTip($Button_move, "Relocate game files!")
	;
	$Button_queue = GuiCtrlCreateButton("VIEW" & @LF & "QUEUE", $width - 200, $height - 55, 62, 45, $BS_MULTILINE)
	GUICtrlSetFont($Button_queue, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_queue, "View the download queue!")
	;
	$Button_setup = GuiCtrlCreateButton("SETUP", $width - 129, $height - 55, 60, 22)
	GUICtrlSetFont($Button_setup, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_setup, "Setup username and password!")
	;
;~ 	$Button_log = GuiCtrlCreateButton("LOG", $width - 129, $height - 30, 43, 20)
;~ 	GUICtrlSetFont($Button_log, 7, 600, 0, "Small Fonts")
;~ 	GUICtrlSetTip($Button_log, "View the record log file!")
;~ 	$Checkbox_log = GUICtrlCreateCheckbox("", $width - 83, $height - 30, 16, 20)
;~ 	GUICtrlSetTip($Checkbox_log, "Enable viewing 'gogrepo.log' file!")
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
	$Item_content = GUICtrlCreateMenuItem("View Folder Content", $Menu_list)
	GUICtrlCreateMenuItem("", $Menu_list)
	$Item_info = GUICtrlCreateMenuItem("View Game Details (INFO)", $Menu_list)
	GUICtrlCreateMenuItem("", $Menu_list)
	GUICtrlCreateMenuItem("", $Menu_list)
	$Item_check = GUICtrlCreateMenuItem("CHECKER for Game files", $Menu_list)
	GUICtrlCreateMenuItem("", $Menu_list)
	GUICtrlCreateMenuItem("", $Menu_list)
	;$Item_download = GUICtrlCreateMenuItem("DOWNLOAD selected Game file(s)", $Menu_list)
	$Item_download = GUICtrlCreateMenuItem("DOWNLOAD Files Selector", $Menu_list)
	GUICtrlCreateMenuItem("", $Menu_list)
	GUICtrlCreateMenuItem("", $Menu_list)
	$Item_remove = GUICtrlCreateMenuItem("Remove Selected Game", $Menu_list)
	GUICtrlCreateMenuItem("", $Menu_list)
	GUICtrlCreateMenuItem("", $Menu_list)
	$Item_delete = GUICtrlCreateMenuItem("Delete Manifest", $Menu_list)
	GUICtrlCreateMenuItem("", $Menu_list)
	GUICtrlCreateMenuItem("", $Menu_list)
	$Menu_games = GUICtrlCreateMenu("ALL Games", $Menu_list)
	$Item_allsort = GUICtrlCreateMenuItem("Save Sorted List", $Menu_games)
	$Item_allunsort = GUICtrlCreateMenuItem("Save Unsorted List", $Menu_games)
	GUICtrlCreateMenuItem("", $Menu_list)
	$Menu_linux = GUICtrlCreateMenu("Linux Games", $Menu_list)
	$Item_linsort = GUICtrlCreateMenuItem("Save Sorted List", $Menu_linux)
	$Item_linunsort = GUICtrlCreateMenuItem("Save Unsorted List", $Menu_linux)
	GUICtrlCreateMenuItem("", $Menu_list)
	$Menu_mac = GUICtrlCreateMenu("MAC Games", $Menu_list)
	$Item_macsort = GUICtrlCreateMenuItem("Save Sorted List", $Menu_mac)
	$Item_macunsort = GUICtrlCreateMenuItem("Save Unsorted List", $Menu_mac)
	GUICtrlCreateMenuItem("", $Menu_list)
	$Menu_windows = GUICtrlCreateMenu("Windows Games (only)", $Menu_list)
	$Item_winsort = GUICtrlCreateMenuItem("Save Sorted List", $Menu_windows)
	$Item_winunsort = GUICtrlCreateMenuItem("Save Unsorted List", $Menu_windows)
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
		GUICtrlSetState($Item_info, $GUI_DISABLE)
		GUICtrlSetState($Button_pic, $GUI_DISABLE)
	Else
		$open = FileOpen($manifest, 0)
		$read = FileRead($open)
		FileClose($open)
		If StringInStr($read, @CRLF) > 0 Then
			$res = _ReplaceStringInFile($manifest, @CRLF, @LF)
			MsgBox(262192, "Manifest Fix", $res & " carriage returns were found and replaced with line feeds.", 0, $GOGRepoGUI)
		EndIf
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
	$display = IniRead($inifle, "Cover Image", "show", "")
	If $display = "" Then
		$display = 1
		IniWrite($inifle, "Cover Image", "show", $display)
	EndIf
	GUICtrlSetState($Checkbox_show, $display)
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
			If Not FileExists($splash) Then SplashTextOn("", "Please Wait!", 200, 120, Default, Default, 33)
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
			If Not FileExists($splash) Then SplashOff()
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
				If Not FileExists($splash) Then SplashTextOn("", "Please Wait!", 200, 120, Default, Default, 33)
				GetAuthorAndVersion()
				; NOTE - Threads are automatically checked and updated to previous choice.
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
				If Not FileExists($splash) Then SplashOff()
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
		; gogrepo.py is missing
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
		;
		; Check if any existing manifest is original compatible
		If FileExists($manifest) Then
			$res = _FileReadToArray($manifest, $array)
			If $res = 1 Then
				$ind = _ArraySearch($array, "'galaxyDownloads':", 1, 0, 0, 1)
				;MsgBox(262192, "Line Search", $ind, 0, $GOGRepoGUI)
				;If $ind = -1 Then
				If $ind <> -1 Then
					$ans = MsgBox(262433, "Manifest Query", _
						"The existing manifest format appears to be newer than" & @LF & _
						"the current version of 'gogrepo.py', that you are using." & @LF & @LF & _
						"This means there will likely be compatibility issues." & @LF & @LF & _
						"OK = Backup & Continue with no manifest." & @LF & _
						"CANCEL = Abort & Exit with no changes." & @LF & @LF & _
						"WARNING - To continue means you will need to start" & @LF & _
						"again, recreating your manifest file from scratch. The" & @LF & _
						"existing manifest & related files will be copied to the" & @LF & _
						"'Backups\Forked' folder.", 0, $GOGRepoGUI)
					If $ans = 1 Then
						Local $forked = $backups & "\Forked"
						If Not FileExists($forked) Then DirCreate($forked)
						$forked = $forked & "\"
						$res = FileMove($manifest, $forked, 0)
						If $res = 1 Then
							FileMove($addlist, $forked, 0)
							FileMove($gamesfle, $forked, 0)
							FileMove($logfle, $forked, 0)
							FileMove($titlist, $forked, 0)
							FileCopy($inifle, $forked, 0)
							FileMove($backups & "\*.bak", $forked, 0)
						Else
							MsgBox(262192, "Backup Error", "Manifest file could not be relocated!" _
								& @LF & @LF & "Check for existing backups in - " _
								& @LF & $forked & @LF _
								& @LF & "You may need to delete, rename or relocate any" _
								& @LF & "previous backups manually, before trying again." & @LF _
								& @LF & "Folder will open and program will now exit.", 0, $GOGRepoGUI)
							If FileExists($forked) Then ShellExecute($forked)
							If FileExists($splash) Then SplashOff()
							Exit
						EndIf
					Else
						If FileExists($splash) Then SplashOff()
						Exit
					EndIf
				EndIf
			EndIf
		EndIf
		;
		$res = _FileReadToArray($gogrepo, $array)
		If $res = 1 Then
			$ind = _ArraySearch($array, "TITLES_FILENAME = r'gog-titles.dat'", 0)
			;MsgBox(262192, "Line Search", $ind, 0, $GOGRepoGUI)
			If $ind = -1 Then
				$stagesfix = 4
				$exist = "MANIFEST_FILENAME = r'gog-manifest.dat'"
				$chunk = "MANIFEST_FILENAME = r'gog-manifest.dat'" & @CRLF & "TITLES_FILENAME = r'gog-titles.dat'"
				$res = _ReplaceStringInFile($gogrepo, $exist, $chunk)
				If $res = 1 Then
					$exist = "    # fetch item details"
					$chunk = "    # save item titles" & @CRLF & "    titlesdb = sorted(items, key=lambda item: item.title)" & @CRLF _
						& "    save_titles(titlesdb)" & @CRLF & @CRLF & "    # fetch item details"
					$res = _ReplaceStringInFile($gogrepo, $exist, $chunk)
					If $res = 1 Then
						$exist = "    gamesdb = load_manifest()"
						$chunk = "    gamesdb = load_manifest()" & @CRLF & @CRLF & "    try:" & @CRLF & "        titlesdb = load_titles()" & @CRLF _
							& "    except:" & @CRLF & "	    titlesdb = None"
						$res = _ReplaceStringInFile($gogrepo, $exist, $chunk, 0, 0)
						If $res = 1 Then
							$exist = "def save_manifest(items):" & @CRLF & "    info('saving manifest...')" & @CRLF _
								& "    with codecs.open(MANIFEST_FILENAME, 'w', 'utf-8') as w:" & @CRLF _
								& "        print('# {} games'.format(len(items)), file=w)" & @CRLF _
								& "        pprint.pprint(items, width=123, stream=w)"
							$chunk = "def save_manifest(items):" & @CRLF & "    info('saving manifest...')" & @CRLF _
								& "    with codecs.open(MANIFEST_FILENAME, 'w', 'utf-8') as w:" & @CRLF _
								& "        print('# {} games'.format(len(items)), file=w)" & @CRLF _
								& "        pprint.pprint(items, width=123, stream=w)" & @CRLF & @CRLF & @CRLF _
								& "def load_titles(filepath=TITLES_FILENAME):" & @CRLF & "    info('loading local titles...')" & @CRLF _
								& "    try:" & @CRLF & "        with codecs.open(TITLES_FILENAME, 'rU', 'utf-8') as r:" & @CRLF _
								& "            ad = r.read().replace('{', 'AttrDict(**{').replace('}', '})')" & @CRLF & "        return eval(ad)" & @CRLF _
								& "    except IOError:" & @CRLF & "        return []" & @CRLF & @CRLF & @CRLF _
								& "def save_titles(items):" & @CRLF & "    info('saving titles...')" & @CRLF _
								& "    with codecs.open(TITLES_FILENAME, 'w', 'utf-8') as w:" & @CRLF _
								& "        print('# {} games'.format(len(items)), file=w)" & @CRLF _
								& "        pprint.pprint(items, width=123, stream=w)" & @CRLF _
								& "    info('saved titles')"
							$res = _ReplaceStringInFile($gogrepo, $exist, $chunk)
							If $res = 1 Then
								$stagesfix = 1
							EndIf
						EndIf
					EndIf
				EndIf
				IniWrite($inifle, "Stages Support", "fix", $stagesfix)
			Else
				$stagesfix = IniRead($inifle, "Stages Support", "fix", "")
			EndIf
		Else
			$stagesfix = 4
			IniWrite($inifle, "Stages Support", "fix", $stagesfix)
		EndIf
	ElseIf $auth = "eddie3,kalynr" Then
		;eddie3,kalynr-k0.3a
		$script = "fork"
		;
		; Check if any existing manifest is fork compatible
		If FileExists($manifest) Then
			$res = _FileReadToArray($manifest, $array)
			If $res = 1 Then
				;$ind = _ArraySearch($array, "'galaxyDownloads':", 0)
				$ind = _ArraySearch($array, "'galaxyDownloads':", 1, 0, 0, 1)
				;MsgBox(262192, "Line Search", $ind, 0, $GOGRepoGUI)
				If $ind = -1 Then
					$ans = MsgBox(262433, "Manifest Query", _
						"The existing manifest format appears to pre-date the" & @LF & _
						"current version of 'gogrepo.py', that you are using." & @LF & @LF & _
						"This means there will likely be compatibility issues." & @LF & @LF & _
						"OK = Backup & Continue with no manifest." & @LF & _
						"CANCEL = Abort & Exit with no changes." & @LF & @LF & _
						"WARNING - To continue means you will need to start" & @LF & _
						"again, recreating your manifest file from scratch. The" & @LF & _
						"existing manifest & related files will be copied to the" & @LF & _
						"'Backups\Original' folder.", 0, $GOGRepoGUI)
					If $ans = 1 Then
						Local $original = $backups & "\Original"
						If Not FileExists($original) Then DirCreate($original)
						$original = $original & "\"
						$res = FileMove($manifest, $original, 0)
						If $res = 1 Then
							FileMove($addlist, $original, 0)
							FileMove($gamesfle, $original, 0)
							FileMove($logfle, $original, 0)
							FileMove($titlist, $original, 0)
							FileCopy($inifle, $original, 0)
							FileMove($backups & "\*.bak", $original, 0)
						Else
							MsgBox(262192, "Backup Error", "Manifest file could not be relocated!" _
								& @LF & @LF & "Check for existing backups in - " _
								& @LF & $original & @LF _
								& @LF & "You may need to delete, rename or relocate any" _
								& @LF & "previous backups manually, before trying again." & @LF _
								& @LF & "Folder will open and program will now exit.", 0, $GOGRepoGUI)
							If FileExists($original) Then ShellExecute($original)
							If FileExists($splash) Then SplashOff()
							Exit
						EndIf
					Else
						If FileExists($splash) Then SplashOff()
						Exit
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	If $script = "default" Then
		$Checkbox_game = GUICtrlCreateCheckbox("Game Files", 400, 313, 67, 20)
		GUICtrlSetFont($Checkbox_game, 7, 400, 0, "Small Fonts")
		GUICtrlSetTip($Checkbox_game, "Download the game files!")
		;
		$Button_log = GuiCtrlCreateButton("LOG", $width - 129, $height - 30, 60, 20)
		GUICtrlSetFont($Button_log, 7, 600, 0, "Small Fonts")
		GUICtrlSetTip($Button_log, "View the record log file!")
		;
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
		$Button_log = GuiCtrlCreateButton("LOG", $width - 129, $height - 30, 43, 20)
		GUICtrlSetFont($Button_log, 7, 600, 0, "Small Fonts")
		GUICtrlSetTip($Button_log, "View the record log file!")
		$Checkbox_log = GUICtrlCreateCheckbox("", $width - 83, $height - 30, 16, 20)
		GUICtrlSetTip($Checkbox_log, "Enable viewing 'gogrepo.log' file!")
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
		;
		$verylog = IniRead($inifle, "Verifying", "log", "")
		If $verylog = "" Then
			$verylog = 1
			IniWrite($inifle, "Verifying", "log", $verylog)
		EndIf
		;
		$veryextra = IniRead($inifle, "Verifying", "extras", "")
		If $veryextra = "" Then
			$veryextra = 1
			IniWrite($inifle, "Verifying", "extras", $veryextra)
		EndIf
		;
		$verygames = IniRead($inifle, "Verifying", "games", "")
		If $verygames = "" Then
			$verygames = 1
			IniWrite($inifle, "Verifying", "games", $verygames)
		EndIf
		;
		$veryalone = IniRead($inifle, "Verifying", "standalone", "")
		If $veryalone = "" Then
			$veryalone = 1
			IniWrite($inifle, "Verifying", "standalone", $veryalone)
		EndIf
		;
		$veryshare = IniRead($inifle, "Verifying", "shared", "")
		If $veryshare = "" Then
			$veryshare = 1
			IniWrite($inifle, "Verifying", "shared", $veryshare)
		EndIf
		;
		$verygalaxy = IniRead($inifle, "Verifying", "galaxy", "")
		If $verygalaxy = "" Then
			$verygalaxy = 4
			IniWrite($inifle, "Verifying", "galaxy", $verygalaxy)
		EndIf
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
		GUICtrlSetState($Item_check, $GUI_DISABLE)
		GUICtrlSetState($Item_remove, $GUI_DISABLE)
		GUICtrlSetState($Item_delete, $GUI_DISABLE)
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
				$val = IniRead($inifle, "Current Download", "OS", "")
				IniWrite($downlist, $title, "OS", $val)
				$val = IniRead($inifle, "Current Download", "language", "")
				IniWrite($downlist, $title, "language", $val)
				$val = IniRead($inifle, "Current Download", "standalone", "")
				IniWrite($downlist, $title, "standalone", $val)
				$val = IniRead($inifle, "Current Download", "galaxy", "")
				IniWrite($downlist, $title, "galaxy", $val)
				$val = IniRead($inifle, "Current Download", "shared", "")
				IniWrite($downlist, $title, "shared", $val)
				$val = IniRead($inifle, "Current Download", "log", "")
				IniWrite($downlist, $title, "log", $val)
				;
				$val = IniRead($inifle, "Current Download", "skiplang", "")
				IniWrite($downlist, $title, "skiplang", $val)
				$val = IniRead($inifle, "Current Download", "langskip", "")
				IniWrite($downlist, $title, "languages", $val)
				$val = IniRead($inifle, "Current Download", "skipOS", "")
				IniWrite($downlist, $title, "skipOS", $val)
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

	If FileExists($splash) Then SplashOff()

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
				GUICtrlSetState($Item_check, $GUI_ENABLE)
				GUICtrlSetState($Item_remove, $GUI_ENABLE)
				GUICtrlSetState($Item_delete, $GUI_ENABLE)
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
		;Case $msg = $Button_move
			; Relocate game files
		;	MsgBox(262192, "Program Advice", "This feature not yet enabled!", 2, $GOGRepoGUI)
		Case $msg = $Button_more And $script = "fork"
			; More download options
			GuiSetState(@SW_DISABLE, $GOGRepoGUI)
			DownloadGUI()
			GuiSetState(@SW_ENABLE, $GOGRepoGUI)
			$window = $GOGRepoGUI
		Case $msg = $Button_log
			; View the record log file
			If $script = "default" Then
				If FileExists($logfle) Then ShellExecute($logfle)
			ElseIf GUICtrlRead($Checkbox_log) = $GUI_CHECKED Then
				If FileExists($repolog) Then ShellExecute($repolog)
			Else
				If FileExists($logfle) Then ShellExecute($logfle)
			EndIf
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
				If ($name = GUICtrlRead($Input_name)) Or $update = 1 Then
					If ($title <> "" And ($name <> "" Or $update = 1)) Or $all = 1 Then
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
								GUISetState(@SW_SHOWNORMAL, $GOGRepoGUI)
								GUICtrlSetState($Button_down, $GUI_FOCUS)
							ElseIf $update = 1 Then
								; Update the manifest
								;$find = $title
								EnableDisableControls($GUI_DISABLE)
								$OSget = GUICtrlRead($Combo_OS)
								$OS = StringReplace($OSget, " + ", " ")
								$OS = StringLower($OS)
								;$title = GUICtrlRead($Input_title)
								$games = _GUICtrlListBox_GetCount($List_games)
								UpdateGUI()
								$window = $GOGRepoGUI
								If $updating = 1 Then
									GUICtrlSetData($List_games, "")
									GUICtrlSetData($Input_name, "")
									GUICtrlSetData($Input_title, "")
									GUICtrlSetData($Input_OS, "")
									GUICtrlSetData($Input_extra, "")
									_FileCreate($titlist)
									ParseTheManifest(1)
									FillTheGamesList()
								EndIf
								EnableDisableControls($GUI_ENABLE)
								GUISetState(@SW_SHOWNORMAL, $GOGRepoGUI)
								GUICtrlSetState($Button_down, $GUI_FOCUS)
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
										GUICtrlSetState($Item_check, $GUI_DISABLE)
										GUICtrlSetState($Item_remove, $GUI_DISABLE)
										GUICtrlSetState($Item_delete, $GUI_DISABLE)
										GetWindowPosition()
										GuiSetState(@SW_HIDE, $GOGRepoGUI)
										QueueGUI()
										$window = $GOGRepoGUI
										GuiSetState(@SW_SHOW, $GOGRepoGUI)
										; On return
										If $downall = 4 Then
											GUICtrlSetState($Checkbox_all, $GUI_ENABLE)
											GUICtrlSetState($Checkbox_update, $GUI_ENABLE)
											GUICtrlSetState($Checkbox_verify, $GUI_ENABLE)
											GUICtrlSetState($Item_check, $GUI_ENABLE)
											GUICtrlSetState($Item_remove, $GUI_ENABLE)
											GUICtrlSetState($Item_delete, $GUI_ENABLE)
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
													;GUICtrlSetState($Button_move, $GUI_DISABLE)
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
														$OS = GUICtrlRead($Combo_OS)
														$OS = StringReplace($OS, "+", "")
														$OS = StringStripWS($OS, 7)
														$OS = StringLower($OS)
														IniWrite($inifle, "Current Download", "OS", $OS)
														IniWrite($inifle, "Current Download", "language", $lang)
														IniWrite($inifle, "Current Download", "standalone", $standalone)
														IniWrite($inifle, "Current Download", "galaxy", $galaxy)
														IniWrite($inifle, "Current Download", "shared", $shared)
														IniWrite($inifle, "Current Download", "log", $downlog)
														IniWrite($inifle, "Current Download", "skiplang", $skiplang)
														IniWrite($inifle, "Current Download", "langskip", $langskip)
														IniWrite($inifle, "Current Download", "skipOS", $skipos)
														$val = StringReplace($osskip, "+", "")
														$val = StringStripWS($val, 7)
														IniWrite($inifle, "Current Download", "OSes", $val)
													EndIf
													IniWrite($inifle, "Current Download", "extras", $extras)
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
													If $script = "fork" Then
														IniWrite($inifle, "Current Download", "verylog", $verylog)
														IniWrite($inifle, "Current Download", "veryextra", $veryextra)
														IniWrite($inifle, "Current Download", "verygames", $verygames)
														IniWrite($inifle, "Current Download", "veryalone", $veryalone)
														IniWrite($inifle, "Current Download", "veryshare", $veryshare)
														IniWrite($inifle, "Current Download", "verygalaxy", $verygalaxy)
													EndIf
													;
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
															Local $params = " -os " & $OS & " -lang " & $lang & " -skipextras -skipgalaxy -skipstandalone -skipshared -nolog"
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
														;MsgBox(262192, "Parameters", $params, 0, $GOGRepoGUI)
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
											GUICtrlSetState($Item_check, $GUI_DISABLE)
											GUICtrlSetState($Item_remove, $GUI_DISABLE)
											GUICtrlSetState($Item_delete, $GUI_DISABLE)
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
		Case $msg = $Button_detail Or $msg = $Item_info
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
								$html = "<html>" & @CRLF & "<head>" & @CRLF & "<title>" & $title & "</title>"
								If FileExists($blackjpg) Then
									$html = $html & @CRLF & "<script>" & @CRLF & "<!--" & @CRLF & "function defaultImage(img) {" _
										& @CRLF & "img.src = '" & StringReplace($blackjpg, "\", "/") & "';" _
										& @CRLF & "img.setAttribute('width', '25%');" & @CRLF & "}" & @CRLF & "//-->" & @CRLF & "</script>"
									; NOTE - If the Black.jpg didn't exist and I had failed to use the check for it, I could have used the
									; following, which was provided by TheDcoder. In fact he provided lots of help with my function anyway.
									; function defaultImage(img) {
									; if (defaultImage.ran) return;
									; defaultImage.ran = img.src = 'D:\Projects\GOGRepo GUI\Black.jpg';
									; }
								EndIf
								$html = $html & @CRLF & "</head>" & @CRLF & "<body>"
								$image = IniRead($gamesfle, $name, "image", "")
								If $image <> "" Then
									If FileExists($blackjpg) Then
										$html = $html & @CRLF & "<img src='" & $image & "' width='100%' onerror='defaultImage(this)'>"
									Else
										$html = $html & @CRLF & "<img src='" & $image & "' alt='Missing Image' width='100%'>"
									EndIf
								ElseIf FileExists($blackjpg) Then
									$html = $html & @CRLF & "<img src='" & StringReplace($blackjpg, "\", "/") & "' width='25%'>"
								EndIf
								$chunk = $name & " (" & $title & ")" & @CRLF &  @CRLF & "'bg_url':" & $segment[$segment[0]]
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
			Else
				MsgBox(262192, "Program Error", "Manifest file does not exist!", $wait, $GOGRepoGUI)
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
				GUICtrlSetState($Item_download, $GUI_DISABLE)
			Else
				$verify = 4
				If $all = 1 Then
					$buttitle = "Down" & @LF & "ALL"
					GUICtrlSetTip($Button_down, "Download ALL games!")
				Else
					$buttitle = "Down" & @LF & "One"
					GUICtrlSetTip($Button_down, "Download the selected game!")
					GUICtrlSetState($Item_download, $GUI_ENABLE)
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
				GUICtrlSetState($Item_download, $GUI_DISABLE)
			Else
				$update = 4
				If $all = 1 Then
					$buttitle = "Down" & @LF & "ALL"
					GUICtrlSetTip($Button_down, "Download ALL games!")
				Else
					$buttitle = "Down" & @LF & "One"
					GUICtrlSetTip($Button_down, "Download the selected game!")
					GUICtrlSetState($Item_download, $GUI_ENABLE)
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
				$display = 1
				ShowCorrectImage()
			Else
				$display = 4
				GUICtrlSetImage($Pic_cover, $blackjpg)
			EndIf
			IniWrite($inifle, "Cover Image", "show", $display)
		Case $msg = $Checkbox_log And $script = "fork"
			; Enable viewing 'gogrepo.log' file
			If GUICtrlRead($Checkbox_log) = $GUI_CHECKED Then
				GUICtrlSetTip($Button_log, "View the 'gogrepo.log' log file!")
			Else
				GUICtrlSetTip($Button_log, "View the record log file!")
			EndIf
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
				GUICtrlSetState($Item_download, $GUI_DISABLE)
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
					GUICtrlSetState($Item_download, $GUI_ENABLE)
				EndIf
			EndIf
			GUICtrlSetData($Button_down, $buttitle)
		Case $msg = $Combo_OS
			; OS to download files for
			$OSget = GUICtrlRead($Combo_OS)
			$ans = MsgBox(262433, "Change Query", _
				"Do you want to make this a permanent change?" & @LF & @LF & _
				"OK = Make it Permanent." & @LF & _
				"CANCEL = Make it Temporary." & @LF & @LF & _
				"NOTE - Temporary only lasts as long as the" & @LF & _
				"program remains running.", $wait, $GOGRepoGUI)
			If $ans = 1 Then
				IniWrite($inifle, "Download Options", "OS", $OSget)
			EndIf
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
		Case $msg = $Item_remove
			; Remove Selected Game
			If FileExists($manifest) Then
				$name = GUICtrlRead($List_games)
				$title = GUICtrlRead($Input_title)
				If $name <> "" And $title <> "" Then
					If $name = GUICtrlRead($Input_name) Then
						$ans = MsgBox(262435, "Remove Game Query", _
							"This removes the selected game from the manifest." & @LF & @LF & _
							"Do you also want to remove from the List?" & @LF & @LF & _
							"YES = Remove from both." & @LF & _
							"NO = Only the manifest" & @LF & _
							"CANCEL = Abort any removal." & @LF & @LF & _
							"NOTE - Even if NO is chosen, the next UPDATE will" & @LF & _
							"recreate and refresh the List entries anyway." & @LF & @LF & _
							"NO GAME FILES OR EXTRAS ARE REMOVED!", $wait, $GOGRepoGUI)
						If $ans <> 2 Then
							SplashTextOn("", "Please Wait!", 200, 120, Default, Default, 33)
							$res = _FileReadToArray($manifest, $array)
							If $res = 1 Then
								$games = $array[1]
							Else
								$games = ""
							EndIf
							$res = 0
							$open = FileOpen($manifest, 0)
							$read = FileRead($open)
							FileClose($open)
							$segment = StringSplit($read, "'title': '" & $title & "'}", 1)
							If $segment[0] = 2 Then
								$segment = $segment[1]
								$segment = StringSplit($segment, "{'bg_url':", 1)
								If $segment[0] > 1 Then
									$segment = "{'bg_url':" & $segment[$segment[0]]
									$segment = $segment & "'title': '" & $title & "'},"
									;MsgBox(262192, "Game Segment", $games & @LF & $segment, $wait, $GOGRepoGUI)
									; Attempt to remove as a middle entry.
									$res = _ReplaceStringInFile($manifest, " " & $segment & @LF, "")
									If @error = 0 Then
										If $res = 0 Then
											; Failed, so attempt to remove as a last entry.
											$segment = StringTrimRight($segment, 1)
											$res = _ReplaceStringInFile($manifest, " " & $segment, "")
											If $res = 0 Then
												; Failed, so attempt to remove as a first entry.
												$segment = $segment & ","
												$res = _ReplaceStringInFile($manifest, $segment & @LF, "")
												If @error = 0 Then
													If $res = 0 Then
														; Failed, so attempt to remove the only entry.
														$segment = StringTrimRight($segment, 1)
														$res = _ReplaceStringInFile($manifest, $segment, "")
													Else
														_ReplaceStringInFile($manifest, "[ {", "[{")
													EndIf
												EndIf
											Else
												_ReplaceStringInFile($manifest, "," & @LF & "]", "]")
											EndIf
										Else
											;_ReplaceStringInFile($manifest, "[ {", "[{")
										EndIf
										If $res = 1 And $games <> "" Then
											$number = StringSplit($games, " ", 1)
											If $number[0] > 1 Then
												$number = $number[2]
												If StringIsDigit($number) Then
													$number = $number - 1
													$number = "# " & $number & " games"
													_ReplaceStringInFile($manifest, $games, $number)
													$games = $number
												EndIf
											EndIf
										Else
											MsgBox(262192, "Removal Error (2)", "Could not remove entry from manifest!", $wait, $GOGRepoGUI)
										EndIf
									Else
										MsgBox(262192, "Removal Error (1)", "Could not remove entry from manifest!", $wait, $GOGRepoGUI)
									EndIf
								Else
									MsgBox(262192, "Removal Error", "Could not divide on url entry!", $wait, $GOGRepoGUI)
								EndIf
							Else
								MsgBox(262192, "Removal Error", "Could not divide on title entry!", $wait, $GOGRepoGUI)
							EndIf
							;
							;$open = FileOpen($manifest, 0)
							;$read = FileRead($open)
							;FileClose($open)
							;If StringInStr($read, @CRLF) > 0 Then
							;	$res = _ReplaceStringInFile($manifest, @CRLF, @LF)
							;	MsgBox(262192, "Manifest Fix", $res & " carriage returns were found and replaced with line feeds.", 0, $GOGRepoGUI)
							;EndIf
							;
							If $ans = 6 And $res = 1 Then
								$ind = _GUICtrlListBox_GetCurSel($List_games)
								If $name = _GUICtrlListBox_GetText($List_games, $ind) Then
									$games = _GUICtrlListBox_DeleteString($List_games, $ind)
									If $games > 0 Then
										GUICtrlSetData($Group_games, "Games  (" & $games & ")")
									Else
										GUICtrlSetData($Group_games, "Games")
									EndIf
									EnableDisableControls($GUI_DISABLE)
									Sleep(1000)
									GUICtrlSetData($List_games, "")
									GUICtrlSetData($Input_name, "")
									GUICtrlSetData($Input_title, "")
									GUICtrlSetData($Input_OS, "")
									GUICtrlSetData($Input_extra, "")
									_FileCreate($titlist)
									ParseTheManifest(1)
									FillTheGamesList()
									EnableDisableControls($GUI_ENABLE)
								Else
									$games = _GUICtrlListBox_GetCount($List_games)
									MsgBox(262192, "Removal Error", "Selection mismatch!", $wait, $GOGRepoGUI)
								EndIf
							Else
								$games = _GUICtrlListBox_GetCount($List_games)
							EndIf
							SplashOff()
						EndIf
					Else
						MsgBox(262192, "Name Error", "Game is not selected properly!", $wait, $GOGRepoGUI)
					EndIf
				Else
					MsgBox(262192, "Title Error", "A game is not selected!", $wait, $GOGRepoGUI)
				EndIf
			Else
				MsgBox(262192, "Program Error", "Manifest file does not exist!", $wait, $GOGRepoGUI)
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
			; Go to Forum page
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
		Case $msg = $Item_download
			; DOWNLOAD Files Selector
			If FileExists($manifest) Then
				$name = GUICtrlRead($Input_name)
				If $name <> "" Then
					$title = GUICtrlRead($Input_title)
					If $title <> "" Then
						SplashTextOn("", "Please Wait!", 200, 120, Default, Default, 33)
						$open = FileOpen($manifest, 0)
						$read = FileRead($open)
						FileClose($open)
						$chunk = ""
						$segment = StringSplit($read, "'title': '" & $title & "'}", 1)
						If $segment[0] = 2 Then
							$segment = $segment[1]
							$segment = StringSplit($segment, "{'bg_url':", 1)
							If $segment[0] > 1 Then
								$chunk = "# 1 games" & @LF & "[{'bg_url':" & $segment[$segment[0]] & "'title': '" & $title & "'}]" & @LF
							EndIf
						EndIf
						SplashOff()
						If $chunk <> "" Then
							$OS = GUICtrlRead($Combo_OS)
							$OS = StringReplace($OS, "+", "")
							$OS = StringStripWS($OS, 7)
							$OS = StringLower($OS)
							EnableDisableControls($GUI_DISABLE)
							FileSelectorGUI()
							EnableDisableControls($GUI_ENABLE)
							GUISetState(@SW_RESTORE, $GOGRepoGUI)
							GUICtrlSetState($Button_down, $GUI_FOCUS)
						EndIf
					Else
						MsgBox(262192, "Game Error", "A title is not selected!", $wait, $GOGRepoGUI)
					EndIf
				Else
					MsgBox(262192, "Title Error", "A game is not selected!", $wait, $GOGRepoGUI)
				EndIf
			Else
				MsgBox(262192, "Program Error", "Manifest file does not exist!", $wait, $GOGRepoGUI)
			EndIf
		Case $msg = $Item_delete
			; Delete Manifest
			If FileExists($manifest) Then
				$ans = MsgBox(262433, "Removal Query", _
					"Are you sure you want to delete the manifest file?" & @LF & @LF & _
					"OK = Delete the manifest." & @LF & _
					"CANCEL = Abort deletion." & @LF & @LF & _
					"NOTE - This is permanent, and means you will need" & @LF & _
					"to recreate (Full UPDATE) your manifest again from" & @LF & _
					"scratch, to access your GOG library for downloading" & @LF & _
					"and verifying etc.", $wait, $GOGRepoGUI)
				If $ans = 1 Then
					FileDelete($manifest)
					_FileCreate($titlist)
					GUICtrlSetData($List_games, "")
					GUICtrlSetData($Input_name, "")
					GUICtrlSetData($Input_title, "")
					GUICtrlSetData($Input_OS, "")
					GUICtrlSetData($Input_extra, "")
				EndIf
			Else
				MsgBox(262192, "Program Error", "Manifest file does not exist!", $wait, $GOGRepoGUI)
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
		Case $msg = $Item_check
			; Check for Game files
			EnableDisableControls($GUI_DISABLE)
			FileCheckerGUI()
			EnableDisableControls($GUI_ENABLE)
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
			If $display = 1 Then
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
	Local $above, $high, $params, $pos, $side, $wide
	;
	$wide = 230
	$high = 400
	$side = IniRead($inifle, "Download ALL Window", "left", $left)
	$above = IniRead($inifle, "Download ALL Window", "top", $top)
	$DownloadAllGUI = GuiCreate("Download ALL", $wide, $high, $side, $above, $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU _
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
			$winpos = WinGetPos($DownloadAllGUI, "")
			$side = $winpos[0]
			If $side < 0 Then
				$side = 2
			ElseIf $side > @DesktopWidth - $wide Then
				$side = @DesktopWidth - $wide - 25
			EndIf
			IniWrite($inifle, "Download ALL Window", "left", $side)
			$above = $winpos[1]
			If $above < 0 Then
				$above = 2
			ElseIf $above > @DesktopHeight - $high Then
				$above = @DesktopHeight - $high - 30
			EndIf
			IniWrite($inifle, "Download ALL Window", "top", $above)
			;
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
				If $script = "default" Then
					$params = " -skipmd5 -skipsize -skipzip -delete"
				Else
					$params = " -skipmd5 -skipsize -skipzip -delete -nolog -skipextras -skipgames -skipstandalone -skipshared -skipgalaxy"
					If $verylog = 1 Then $params = StringReplace($params, " -nolog", "")
					If $veryextra = 1 Then $params = StringReplace($params, " -skipextras", "")
					If $verygames = 4 Then
						$params = StringReplace($params, " -skipstandalone -skipshared -skipgalaxy", "")
					Else
						$params = StringReplace($params, " -skipgames", "")
						If $veryalone = 1 Then $params = StringReplace($params, " -skipstandalone", "")
						If $veryshare = 1 Then $params = StringReplace($params, " -skipshared", "")
						If $verygalaxy = 1 Then $params = StringReplace($params, " -skipgalaxy", "")
					EndIf
				EndIf
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
	Local $above, $high, $langs, $side, $wide
	;
	$wide = 270
	$high = 145
	$side = IniRead($inifle, "Download Window", "left", $left)
	$above = IniRead($inifle, "Download Window", "top", $top)
	$DownloadGUI = GuiCreate("Download Options", $wide, $high, $side, $above, $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU _
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
	GUICtrlSetState($Checkbox_skiplang, $GUI_DISABLE)
	GUICtrlSetState($Checkbox_skipOS, $skipos)
	GUICtrlSetState($Checkbox_skipOS, $GUI_DISABLE)
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
			$winpos = WinGetPos($DownloadGUI, "")
			$side = $winpos[0]
			If $side < 0 Then
				$side = 2
			ElseIf $side > @DesktopWidth - $wide Then
				$side = @DesktopWidth - $wide - 25
			EndIf
			IniWrite($inifle, "Download Window", "left", $side)
			$above = $winpos[1]
			If $above < 0 Then
				$above = 2
			ElseIf $above > @DesktopHeight - $high Then
				$above = @DesktopHeight - $high - 30
			EndIf
			IniWrite($inifle, "Download Window", "top", $above)
			;
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

Func FileCheckerGUI()
	Local $Button_check, $Button_compare, $Button_delete, $Button_espy, $Button_get, $Button_inf, $Button_list
	Local $Button_load, $Button_quit, $Button_save, $Button_saveto, $Button_view, $Checkbox_enable, $Checkbox_first
	Local $Checkbox_in, $Checkbox_md5, $Checkbox_second, $Checkbox_size, $Combo_entry, $Combo_filter, $Combo_title
	Local $Group_check, $Group_filter, $Group_missed, $Input_entry, $Label_title, $List_check, $List_missed
	;
	Local $caption, $CheckerGUI, $checklist, $compsize, $count, $dir, $enable, $entries, $entry, $fext, $filefld
	Local $filter, $find, $fnam, $fsum, $fsumfld, $Group, $hash, $item, $len, $List, $match, $md5check, $md5val
	Local $pth, $resfle, $savlist, $segments, $storage, $titget, $types
	;
	$CheckerGUI = GuiCreate("Game Files Checker", $width, $height, $left, $top, $style + $WS_VISIBLE, $WS_EX_TOPMOST)
	GUISetBkColor(0xBBFFBB, $CheckerGUI)
	; CONTROLS
	$Group_check = GuiCtrlCreateGroup("Files To Check For", 10, 10, $width - 20, 166)
	$Checkbox_first = GUICtrlCreateCheckbox("Active", $width - 70, 7,  50, 20)
	GUICtrlSetTip($Checkbox_first, "Files To Check For status!")
	$List_check = GuiCtrlCreateList("", 20, 30, $width - 40, 140, $LBS_SORT + $WS_BORDER + $WS_VSCROLL)
	GUICtrlSetBkColor($List_check, 0xB9FFFF)
	GUICtrlSetTip($List_check, "List of game files to check for!")
	;
	$Input_entry = GUICtrlCreateInput("", 10, 185, $width - 95, 19)
	GUICtrlSetBkColor($Input_entry, 0xFFFFB0)
	GUICtrlSetFont($Input_entry, 8, 400)
	GUICtrlSetTip($Input_entry, "Selected entry!")
	$Combo_entry = GUICtrlCreateCombo("Title", $width - 80, 184, 45, 21)
	GUICtrlSetTip($Combo_entry, "Reduce entry to specified!")
	$Button_espy = GuiCtrlCreateButton("?", $width - 32, 183, 22, 22, $BS_ICON)
	GUICtrlSetTip($Button_espy, "Find an entry with the specified text!")
	;
	$Group_missed = GuiCtrlCreateGroup("Unmatched Files", 10, 213, $width - 20, 90)
	$Checkbox_second = GUICtrlCreateCheckbox("Active", $width - 70, 210,  50, 20)
	GUICtrlSetTip($Checkbox_second, "Unmatched Files status!")
	$List_missed = GuiCtrlCreateList("", 20, 233, $width - 40, 70, $LBS_SORT + $WS_BORDER + $WS_VSCROLL)
	GUICtrlSetBkColor($List_missed, 0xFFD5FF)
	GUICtrlSetTip($List_missed, "List of unmatched game files after check!")
	;
	$Label_title = GuiCtrlCreateLabel("Title", 10, 313, 37, 21, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_title, $COLOR_BLUE)
	GUICtrlSetColor($Label_title, $COLOR_WHITE)
	GUICtrlSetFont($Label_title, 7, 600, 0, "Small Fonts")
	$Combo_title = GUICtrlCreateCombo("", 47, 313, 70, 21)
	GUICtrlSetTip($Combo_title, "Title format to use for Get!")
	;
	$Button_saveto = GuiCtrlCreateButton("SAVE To CHECKLIST", 127, 312, 133, 23)
	GUICtrlSetFont($Button_saveto, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_saveto, "SAVE selected list entry to checklist file!")
	;
	$Checkbox_size = GUICtrlCreateCheckbox("Compare Size", 270, 313,  80, 21)
	GUICtrlSetTip($Checkbox_size, "Also check file size!")
	;
	$Checkbox_md5 = GUICtrlCreateCheckbox("Check MD5", 361, 313,  75, 21)
	GUICtrlSetTip($Checkbox_md5, "Check MD5 with the Compare button!")
	;
	$Button_compare = GuiCtrlCreateButton("COMPARE", 445, 312, 80, 23)
	GUICtrlSetFont($Button_compare, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_compare, "Compare list entries!")
	$Checkbox_enable = GUICtrlCreateCheckbox("Enable", 530, 313,  50, 21)
	GUICtrlSetTip($Checkbox_enable, "Enable the Compare button!")
	;
	$Button_get = GuiCtrlCreateButton("Get File" & @LF & "Names", 10, $height - 60, 79, 50, $BS_MULTILINE)
	GUICtrlSetFont($Button_get, 9, 600)
	GUICtrlSetTip($Button_get, "Get file names from manifest!")
	;
	$Button_save = GuiCtrlCreateButton("SAVE", 97, $height - 60, 53, 22)
	GUICtrlSetFont($Button_save, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_save, "Save the current list of game files!")
	;
	$Button_load = GuiCtrlCreateButton("LOAD", 97, $height - 32, 53, 22)
	GUICtrlSetFont($Button_load, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_load, "Load the saved list of game files!")
	;
	$Button_check = GuiCtrlCreateButton("CHECK" & @LF & "Files", 158, $height - 60, 73, 50, $BS_MULTILINE)
	GUICtrlSetFont($Button_check, 9, 600)
	GUICtrlSetTip($Button_check, "Check for game files!")
	;
	$Button_list = GuiCtrlCreateButton("VIEW The CHECKLIST", 239, $height - 60, 138, 22)
	GUICtrlSetFont($Button_list, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_list, "View the saved checklist!")
	;
	$Button_view = GuiCtrlCreateButton("VIEW", 239, $height - 32, 50, 22)
	GUICtrlSetFont($Button_view, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_view, "View the selected load list of game files!")
	;
	$Button_delete = GuiCtrlCreateButton("REMOVE", 299, $height - 32, 78, 22)
	GUICtrlSetFont($Button_delete, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_delete, "Remove a selected entry!")
	;
	$Group_filter = GuiCtrlCreateGroup("Filter OUT", 385, $height - 60, 86, 50)
	$Combo_filter = GUICtrlCreateCombo("", 395, $height - 40, 48, 21)
	GUICtrlSetTip($Combo_filter, "Filter out the selected file type from the list!")
	$Checkbox_in = GUICtrlCreateCheckbox("", 447, $height - 40,  15, 21)
	GUICtrlSetTip($Checkbox_in, "Enable Filter In!")
	;
	$Button_inf = GuiCtrlCreateButton("Info", $width - 109, $height - 60, 45, 50, $BS_ICON)
	GUICtrlSetTip($Button_inf, "Checker Information!")
	;
	$Button_quit = GuiCtrlCreateButton("EXIT", $width - 55, $height - 60, 45, 50, $BS_ICON)
	GUICtrlSetTip($Button_quit, "Exit / Close / Quit the window!")
	;
	$Ctrl_1 = $Checkbox_first
	$Ctrl_2 = $List_check
	$Ctrl_3 = $Combo_entry
	$Ctrl_4 = $Button_espy
	$Ctrl_5 = $Checkbox_second
	$Ctrl_6 = $List_missed
	$Ctrl_7 = $Combo_title
	$Ctrl_8 = $Button_saveto
	$Ctrl_9 = $Checkbox_size
	$Ctrl_10 = $Checkbox_md5
	$Ctrl_11 = $Checkbox_enable
	$Ctrl_12 = $Button_get
	$Ctrl_13 = $Button_save
	$Ctrl_14 = $Button_load
	$Ctrl_15 = $Button_check
	$Ctrl_16 = $Button_list
	$Ctrl_17 = $Button_view
	$Ctrl_18 = $Button_delete
	$Ctrl_19 = $Combo_filter
	$Ctrl_20 = $Checkbox_in
	$Ctrl_21 = $Button_inf
	$Ctrl_22 = $Button_quit
	;
	; SETTINGS
	GUICtrlSetImage($Button_espy, $shell, $icoS, 0)
	GUICtrlSetImage($Button_inf, $user, $icoI, 1)
	GUICtrlSetImage($Button_quit, $user, $icoX, 1)
	;
	GUICtrlSetData($Combo_entry, "||File|Title", "")
	;
	$titget = "Long Title"
	GUICtrlSetData($Combo_title, "Title|Long Title", $titget)
	;
	$compsize = 4
	$md5check = 4
	;
	GUICtrlSetState($Button_compare, $GUI_DISABLE)
	$enable = 4
	;
	GUICtrlSetData($Combo_filter, "||BIN|DMG|EXE|GZ|MP4|PDF|PNG|RAR|SH|ZIP", "")
	$filter = "out"
	;
	$fsum = @ScriptDir & "\FSUM\fsum.exe"
	$fsumfld = @ScriptDir & "\FSUM"
	$resfle = @ScriptDir & "\Results.txt"
	;
	$checklist = @ScriptDir & "\Checklist.txt"
	If Not FileExists($checklist) Then
		$open = FileOpen($checklist, 2)
		FileWrite($open, "USE THIS CHECKLIST FOR GETTING MISSING UPDATED GAME FILES" & @CRLF & @CRLF)
		FileClose($open)
	EndIf
	;
	$List = $List_check
	$Group = $Group_check
	$caption = "Files To Check For"
	$savlist = @ScriptDir & "\Saved.txt"
	GUICtrlSetState($Checkbox_first, $GUI_CHECKED)

	GuiSetState()
	While 1
		$msg = GuiGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Button_quit
			; Exit / Close / Quit the window
			GUIDelete($CheckerGUI)
			ExitLoop
		Case $msg = $Button_view
			; View the selected load list of game files
			If FileExists($savlist) Then ShellExecute($savlist)
		Case $msg = $Button_saveto
			; SAVE selected list entry to checklist file
			$ind = _GUICtrlListBox_GetCurSel($List_check)
			If $ind > -1 Then
				$entry = _GUICtrlListBox_GetText($List_check, $ind)
				$file = StringSplit($entry, " \ ", 1)
				$title = $file[1]
				$file = $file[2]
				$entry = $title & " - " & $file
				FileWriteLine($checklist, $entry)
			Else
				MsgBox(262192, "Save Error", "List one election issue.", 0, $CheckerGUI)
			EndIf
		Case $msg = $Button_save
			; Save the current list of game files
			EnableDisableCtrls($GUI_DISABLE)
			If $enable = 1 Then GUICtrlSetState($Button_compare, $GUI_DISABLE)
			;
			SplashTextOn("", "Please Wait!", 200, 120, Default, Default, 33)
			$entries = ""
			$count = _GUICtrlListBox_GetCount($List)
			For $a = 0 To $count - 1
				$entry = _GUICtrlListBox_GetText($List, $a)
				If $entries = "" Then
					$entries = $entry
				Else
					$entries = $entries & @CRLF & $entry
				EndIf
			Next
			$open = FileOpen($savlist, 2)
			FileWrite($open, $entries)
			FileClose($open)
			SplashOff()
			;
			EnableDisableCtrls($GUI_ENABLE)
			If $enable = 1 Then GUICtrlSetState($Button_compare, $GUI_ENABLE)
		Case $msg = $Button_load
			; Load the saved list of game files
			EnableDisableCtrls($GUI_DISABLE)
			If $enable = 1 Then GUICtrlSetState($Button_compare, $GUI_DISABLE)
			;
			SplashTextOn("", "Please Wait!", 200, 120, Default, Default, 33)
			GUICtrlSetData($List, "")
			_GUICtrlComboBox_SetCurSel($Combo_filter, 0)
			$open = FileOpen($savlist, 0)
			$read = FileRead($open)
			FileClose($open)
			$entries = StringReplace($read, @CRLF, "|")
			GUICtrlSetData($List, $entries)
			$count = _GUICtrlListBox_GetCount($List)
			If $count > 0 Then
				GUICtrlSetData($Group, $caption & " (" & $count & ")")
			Else
				GUICtrlSetData($Group, $caption)
			EndIf
			SplashOff()
			;
			EnableDisableCtrls($GUI_ENABLE)
			If $enable = 1 Then GUICtrlSetState($Button_compare, $GUI_ENABLE)
		Case $msg = $Button_list
			; View the saved list of game files
			If FileExists($checklist) Then ShellExecute($checklist)
		Case $msg = $Button_inf
			; Checker Information
			MsgBox(262208, "Checker Information", _
				"This program feature is something useful perhaps, for those who" & @LF & _
				"started using the gogrepo.py script, after they had already begun" & @LF & _
				"building their GOG game library. It can be used to check for any" & @LF & _
				"previously missed updates. This is particularly the case where a" & @LF & _
				"strict adherence to folder naming & folder structure, as used by" & @LF & _
				"gogrepo.py, has not been followed." & @LF & @LF & _
				"Usage is as follows." & @LF & _
				"(1) Click the 'Get File Names' button. This extracts all the files" & @LF & _
				"listed in the manifest (name, size, MD5) along with game title." & @LF & _
				"(2) If a large list, it is recommended to click the SAVE button." & @LF & _
				"(3) Clicking the 'CHECK FILES' button, opens a folder browser" & @LF & _
				"that you use to select the main location of your game files. It" & @LF & _
				"will automatically then compare the contained file content to" & @LF & _
				"that returned from the manifest. Matches found are removed" & @LF & _
				"from both itself and the manifest list. Any unmatched entries" & @LF & _
				"will populate the lower list field, which can then be compared" & @LF & _
				"manually afterward. Unmatched entries remain on top list too." & @LF & _
				"(4) The lower list result can also be saved, by either selecting" & @LF & _
				"an entry on that list or by enabling its 'Active' checkbox, then" & @LF & _
				"clicking the SAVE button. Usage is similar to LOAD either list." & @LF & _
				"(5) To manually compare the unmatched items, enable that" & @LF & _
				"button, then select an entry on the top list, and then look for" & @LF & _
				"a close enough match on the lower list, using the FIND button" & @LF & _
				"or visually while scrolling. Then click the 'COMPARE' button to" & @LF & _
				"see if file names are a match. In addition to that, you can also" & @LF & _
				"compare 'file size' and or 'MD5 checksum' by enabling those" & @LF & _
				"options. NOTE - Not all files have a listed checksum, usually" & @LF & _
				"EXE or BIN and SH (Linux) files will, but not something like a" & @LF & _
				"ZIP file. Depending on the compare result, removal from lists" & @LF & _
				"will occur automatically, or via query prompt showing results." & @LF & _
				"(6) If an entry cannot be matched, then likely it is a missing" & @LF & _
				"update candidate. Select that top list entry and then click on" & @LF & _
				"the 'SAVE To CHECKLIST' button, to add it to the Checklist" & @LF & _
				"to investigate further for possible downloading from GOG." & @LF & @LF & _
				"IMPORTANT - All of the above can be improved, by selecting" & @LF & _
				"the correct options to maximize automatic matching. Correct" & @LF & _
				"game title format (as used by you) is the most important of" & @LF & _
				"these options, and may need setting first before step (1). It is" & @LF & _
				"also recommended you have 'Compare Size' option enabled" & @LF & _
				"to make false matches (based on file name alone) less likely." & @LF & _
				"Another helpful first option, is the Filter one, which can either" & @LF & _
				"filter IN or OUT. If the IN checkbox is enabled beforehand, it" & @LF & _
				"alters what results are returned on both lists, which can then" & @LF & _
				"be useful if you wish to process possible candidates in stages.", 0, $CheckerGUI)
		Case $msg = $Button_get
			; Get file names from manifest
			If FileExists($manifest) Then
				EnableDisableCtrls($GUI_DISABLE)
				If $enable = 1 Then GUICtrlSetState($Button_compare, $GUI_DISABLE)
				;
				SplashTextOn("", "Please Wait!", 200, 120, Default, Default, 33)
				GUICtrlSetData($Group_check, "Files To Check For")
				GUICtrlSetData($List_check, "")
				GUICtrlSetData($Input_entry, "")
				_FileWriteLog($logfle, "Getting game files for checklist.")
				$open = FileOpen($manifest, 0)
				$read = FileRead($open)
				FileClose($open)
				$segments = StringSplit($read, "'bg_url':", 1)
				If $segments[0] > 1 Then
					$count = 0
					If $filter = "in" Then
						$fext = GUICtrlRead($Combo_filter)
						$len = StringLen($fext)
					Else
						_GUICtrlComboBox_SetCurSel($Combo_filter, 0)
					EndIf
					For $s = 2 To $segments[0]
						$segment = $segments[$s]
						$array = StringSplit($segment, @LF, 1)
						If $titget = "Long Title" Then
							$ind = _ArraySearch($array, "'long_title':", 1, 0, 0, 1)
							If $ind > -1 Then
								$title = $array[$ind]
								$title = StringSplit($title, "'long_title': '", 1)
								If $title[0] = 2 Then
									$title = $title[2]
									$title = StringSplit($title, "',", 1)
									$title = $title[1]
								Else
									$title = $title[1]
									$title = StringSplit($title, "'long_title': " & '"', 1)
									$title = $title[2]
									$title = StringSplit($title, '",', 1)
									$title = $title[1]
								EndIf
								$title = ReplaceOtherCharacters($title)
								$title = StringReplace($title, ": ", " - ")
							EndIf
						ElseIf $titget = "Title" Then
							$ind = _ArraySearch($array, "'title':", 1, 0, 0, 1)
							If $ind > -1 Then
								$title = $array[$ind]
								$title = StringSplit($title, "'title': '", 1)
								If $title[0] = 2 Then
									$title = $title[2]
									$title = StringSplit($title, "'},", 1)
									$title = $title[1]
								Else
									$title = $title[1]
									$title = StringSplit($title, "'title': " & '"', 1)
									$title = $title[2]
									$title = StringSplit($title, '"},', 1)
									$title = $title[1]
								EndIf
								$title = StringReplace($title, "'}]", "")
							EndIf
						EndIf
						$title = StringStripWS($title, 7)
						If $title <> "" Then
							$entry = ""
							$hash = ""
							For $a = 1 To $array[0]
								$line = $array[$a]
								If StringInStr($line, "'md5': ") > 0 Then
									$hash = StringSplit($line, "'md5': ", 1)
									$hash = $hash[2]
									$hash = StringSplit($hash, ",", 1)
									$hash = $hash[1]
									$hash = StringReplace($hash, "'", "")
								EndIf
								If StringInStr($line, "'name': '") > 0 Then
									$entry = StringSplit($line, "'name': '", 1)
									$entry = $entry[2]
									$entry = StringSplit($entry, "',", 1)
									$entry = $entry[1]
									If $filter = "out" Or $fext = "" Then
										$entry = $title & " \ " & $entry
									ElseIf $filter = "in" Then
										If StringRight($entry, $len) = $fext Then
											$entry = $title & " \ " & $entry
										Else
											$entry = ""
										EndIf
									EndIf
								ElseIf StringInStr($line, "'name': " & '"') > 0 Then
									$entry = StringSplit($line, "'name': " & '"', 1)
									$entry = $entry[2]
									$entry = StringSplit($entry, '",', 1)
									$entry = $entry[1]
									If $filter = "out" Or $fext = "" Then
										$entry = $title & " \ " & $entry
									ElseIf $filter = "in" Then
										If StringRight($entry, $len) = $fext Then
											$entry = $title & " \ " & $entry
										Else
											$entry = ""
										EndIf
									EndIf
								EndIf
								If StringInStr($line, "'size': ") > 0 And $entry <> "" Then
									$line = StringSplit($line, "'size': ", 1)
									$line = $line[2]
									$line = StringSplit($line, ",", 1)
									$entry = $entry & " \ " & $line[1] & " \ " & $hash
									GUICtrlSetData($List_check, $entry)
									$count = $count + 1
								EndIf
							Next
						EndIf
					Next
					If $count > 0 Then
						If $count <> _GUICtrlListBox_GetCount($List_check) Then
							MsgBox(262192, "Get Error", "Count mismatch.", 0, $CheckerGUI)
							$count = _GUICtrlListBox_GetCount($List_check)
						EndIf
						GUICtrlSetData($Group_check, "Files To Check For  (" & $count & ")")
					EndIf
				EndIf
				_FileWriteLog($logfle, "Checklist finished.")
				SplashOff()
				;
				EnableDisableCtrls($GUI_ENABLE)
				If $enable = 1 Then GUICtrlSetState($Button_compare, $GUI_ENABLE)
			EndIf
		Case $msg = $Button_espy
			; Find an entry with the specified text
			$entry = GUICtrlRead($Input_entry)
			If $entry <> "" Then
				If $List = $List_check Then
					$find = $List_missed
				ElseIf $List = $List_missed Then
					$find = $List_check
				EndIf
				$ind = _GUICtrlListBox_GetCurSel($find)
				If $ind < 0 Then $ind = -1
				;$ind = _GUICtrlListBox_SelectString($find, $entry, -1)
				$ind = _GUICtrlListBox_FindInText($find, $entry, $ind, True)
				If $ind > -1 Then
					_GUICtrlListBox_SetCurSel($find, $ind)
					;_GUICtrlListBox_ClickItem($find, $ind)
				EndIf
			EndIf
		Case $msg = $Button_delete
			; Remove a selected entry
			$ind = _GUICtrlListBox_GetCurSel($List)
			If $ind > -1 Then
				$count = _GUICtrlListBox_DeleteString($List, $ind)
				If $count > 0 Then
					GUICtrlSetData($Group, $caption & "  (" & $count & ")")
					If $ind >= $count Then
						$ind = $ind - 1
					EndIf
					_GUICtrlListBox_SetCurSel($List, $ind)
					$entry = _GUICtrlListBox_GetText($List, $ind)
					GUICtrlSetData($Input_entry, $entry)
				Else
					GUICtrlSetData($Group, $caption)
					GUICtrlSetData($Input_entry, "")
				EndIf
			EndIf
		Case $msg = $Button_compare
			; Compare list entries
			$ind = _GUICtrlListBox_GetCurSel($List_check)
			If $ind > -1 Then
				SplashTextOn("", "Please Wait!", 200, 120, Default, Default, 33)
				$entry = GUICtrlRead($List_check)
				$file = StringSplit($entry, " \ ", 1)
				$title = $file[1]
				$size = $file[3]
				$md5val = $file[4]
				$file = $file[2]
				$segment = GUICtrlRead($List_missed)
				If $segment <> "" Then
					$storage = IniRead($inifle, "Games Storage Folder", "path", "")
					$pth = $storage & "\" & $segment
					If FileExists($pth) Then
						$segment = StringSplit($segment, "\", 1)
						If $segment[$segment[0]] = $file Then
							If $segment[1] = $title Then
								If $compsize = 1 Then
									If $size = FileGetSize($pth) Then
										$segment = "query"
										$title = "File names are the same." & @LF & @LF & "Size is the same for both entries." & @LF & @LF & "Game Titles match."
									Else
										$segment = "skip"
										MsgBox(262192, "Compare Error", "File sizes mismatch.", 0, $CheckerGUI)
									EndIf
								EndIf
							Else
								If $compsize = 1 Then
									If $size = FileGetSize($pth) Then
										$segment = "query"
										$title = "File names are the same." & @LF & @LF & "Size is the same for both entries." & @LF & @LF & "Game Titles DON'T match."
									Else
										$segment = "skip"
										MsgBox(262192, "Compare Error", "File sizes mismatch.", 0, $CheckerGUI)
									EndIf
								EndIf
							EndIf
							If $segment <> "query" And $segment <> "skip" Then
								$segment = "query"
								$title = "Size and MD5 not checked." & @LF & @LF & "File names match."
							EndIf
							If $md5check = 1 And $md5val <> "none" And $md5val <> "" And $segment <> "skip" Then
								If FileExists($fsum) Then
									EnableDisableCtrls($GUI_DISABLE)
									If $enable = 1 Then GUICtrlSetState($Button_compare, $GUI_DISABLE)
									FileChangeDir(@ScriptDir & "\FSUM")
									_PathSplit($pth, $drv, $dir, $fnam, $fext)
									$filefld = StringTrimRight($drv & $dir, 1)
									RunWait(@ComSpec & ' /c fsum.exe -jnc -md5 -d"' & $filefld & '" ' & $file & ' >"'  & $resfle & '"')
									$res = _FileReadToArray($resfle, $array, 1)
									If $res = 1 Then
										$match = $array[1]
										$match = StringSplit($match, " ", 1)
										$match = $match[1]
										If $match = $md5val Then
											$segment = "remove"
										Else
											MsgBox(262192, "Compare Error", "The fsum.exe check failed.", 0, $CheckerGUI)
										EndIf
									Else
										MsgBox(262192, "Compare Error", "An fsum.exe results issue.", 0, $CheckerGUI)
									EndIf
									EnableDisableCtrls($GUI_ENABLE)
									If $enable = 1 Then GUICtrlSetState($Button_compare, $GUI_ENABLE)
								Else
									MsgBox(262192, "Compare Error", "The fsum.exe program is missing.", 0, $CheckerGUI)
								EndIf
							EndIf
						Else
							MsgBox(262192, "Compare Error", "File names mismatch.", 0, $CheckerGUI)
						EndIf
						If $segment = "query" Then
							$ans = MsgBox(262177, "Remove Query", _
								$title & @LF & @LF & _
								"Do you want to remove them?", 0, $CheckerGUI)
							If $ans = 1 Then
								$segment = "remove"
							EndIf
						EndIf
						If $segment = "remove" Then
							$count = _GUICtrlListBox_DeleteString($List_check, $ind)
							If $count > 0 Then
								GUICtrlSetData($Group_check, "Files To Check For  (" & $count & ")")
								If $count <= $ind Then $ind = $ind - 1
								_GUICtrlListBox_SetCurSel($List_check, $ind)
								$entry = _GUICtrlListBox_GetText($List_check, $ind)
								GUICtrlSetData($Input_entry, $entry)
							Else
								GUICtrlSetData($Group_check, "Files To Check For")
							EndIf
							$ind = _GUICtrlListBox_GetCurSel($List_missed)
							If $ind > -1 Then
								$count = _GUICtrlListBox_DeleteString($List_missed, $ind)
								If $count > 0 Then
									GUICtrlSetData($Group_missed, "Unmatched Files (" & $count & ")")
									If $count <= $ind Then $ind = $ind - 1
									_GUICtrlListBox_SetCurSel($List_missed, $ind)
								Else
									GUICtrlSetData($Group_check, "Unmatched Files")
								EndIf
							EndIf
						EndIf
					Else
						MsgBox(262192, "Compare Error", "Path doesn't exist." & @LF & @LF & $pth, 0, $CheckerGUI)
					EndIf
				Else
					MsgBox(262192, "Compare Error", "List two election issue.", 0, $CheckerGUI)
				EndIf
				$entry = ""
				$segment = ""
				SplashOff()
			Else
				MsgBox(262192, "Compare Error", "List one election issue.", 0, $CheckerGUI)
			EndIf
		Case $msg = $Button_check
			; Check for game files
			EnableDisableCtrls($GUI_DISABLE)
			If $enable = 1 Then GUICtrlSetState($Button_compare, $GUI_DISABLE)
			;
			$storage = IniRead($inifle, "Games Storage Folder", "path", "")
			$pth = FileSelectFolder("Browse to select your games storage folder.", $gamesfold, 0, $storage, $CheckerGUI)
			If Not @error And StringMid($pth, 2, 2) = ":\" Then
				$storage = $pth
				IniWrite($inifle, "Games Storage Folder", "path", $storage)
				SplashTextOn("", "Please Wait!", 200, 120, Default, Default, 33)
				_FileWriteLog($logfle, "Checking files with checklist.")
				GUICtrlSetData($List_missed, "")
				$entries = ""
				$count = _GUICtrlListBox_GetCount($List_check)
				For $s = 0 To $count - 1
					$entry = _GUICtrlListBox_GetText($List_check, $s)
					If $entries = "" Then
						$entries = $entry
					Else
						$entries = $entries & "|" & $entry
					EndIf
				Next
				;$md5val = 0
				$entries = StringReplace($entries, " \ ", "\")
				$entries = StringSplit($entries, "|", 1)
				$fext = GUICtrlRead($Combo_filter)
				If $filter = "out" Or $fext = "" Then
					$types = "*.bin;*.dmg;*.exe;*.gz;*.mp4;*.pdf;*.png;*.rar;*.sh;*.zip"
				Else
					$types = "*." & StringLower($fext)
				EndIf
				$array = _FileListToArrayRec($storage, $types, $FLTAR_FILES, $FLTAR_RECUR, $FLTAR_SORT, $FLTAR_RELPATH)
				;_ArrayDisplay($array)
				For $a = 1 To $array[0]
					$item = $array[$a]
					$ind = _ArraySearch($entries, $item, 1, 0, 0, 1)
					If $ind > -1 Then
						$entry = $entries[$ind]
						$file = StringSplit($entry, "\", 1)
						$title = $file[1]
						$size = $file[3]
						;$md5val = $file[4]
						$file = $file[2]
						$entry = StringReplace($entry, "\", " \ ")
						$ind = _GUICtrlListBox_FindString($List_check, $entry, True)
						If $ind > -1 Then
							;$md5val = $md5val + 1
							$pth = $storage & "\" & $item
							If $compsize = 1 Then
								If FileExists($pth) Then
									$segment = StringSplit($item, "\", 1)
									If $segment[1] = $title And $segment[2] = $file Then
										If $size = FileGetSize($pth) Then
											$count = _GUICtrlListBox_DeleteString($List_check, $ind)
										Else
											$ind = -1
										EndIf
									Else
										$ind = -1
									EndIf
								Else
									$ind = -1
								EndIf
							Else
								$count = _GUICtrlListBox_DeleteString($List_check, $ind)
							EndIf
						EndIf
					Else
						$ind = -1
					EndIf
					If $ind = -1 Then
						GUICtrlSetData($List_missed, $item)
					EndIf
				Next
				If $count > 0 Then
					GUICtrlSetData($Group_check, "Files To Check For  (" & $count & ")")
				Else
					GUICtrlSetData($Group_check, "Files To Check For")
				EndIf
				$count = _GUICtrlListBox_GetCount($List_missed)
				If $count > 0 Then
					GUICtrlSetData($Group_missed, "Unmatched Files (" & $count & ")")
				Else
					GUICtrlSetData($Group_missed, "Unmatched Files")
				EndIf
				_FileWriteLog($logfle, "Checking finished.")
				SplashOff()
				;MsgBox(262192, "$md5val", $md5val, 0, $CheckerGUI)
			EndIf
			;
			EnableDisableCtrls($GUI_ENABLE)
			If $enable = 1 Then GUICtrlSetState($Button_compare, $GUI_ENABLE)
		Case $msg = $Checkbox_size
			; Compare Size - Also check file size
			If GUICtrlRead($Checkbox_size) = $GUI_CHECKED Then
				$compsize = 1
			Else
				$compsize = 4
			EndIf
		Case $msg = $Checkbox_second
			; Filter out the selected file type from the list
			If GUICtrlRead($Checkbox_second) = $GUI_CHECKED Then
				$List = $List_missed
				$Group = $Group_missed
				$caption = "Unmatched Files"
				$savlist = @ScriptDir & "\Unmatched.txt"
				If $enable = 4 Then _GUICtrlListBox_SetCurSel($List_check, -1)
				GUICtrlSetState($Checkbox_first, $GUI_UNCHECKED)
			Else
				$List = $List_check
				$Group = $Group_check
				$caption = "Files To Check For"
				$savlist = @ScriptDir & "\Saved.txt"
				If $enable = 4 Then _GUICtrlListBox_SetCurSel($List_missed, -1)
				GUICtrlSetState($Checkbox_first, $GUI_CHECKED)
			EndIf
		Case $msg = $Checkbox_md5
			; Check MD5 - Check MD5 with the Compare button
			If GUICtrlRead($Checkbox_md5) = $GUI_CHECKED Then
				$md5check = 1
			Else
				$md5check = 4
			EndIf
		Case $msg = $Checkbox_in
			; Enable Filter In
			If GUICtrlRead($Checkbox_in) = $GUI_CHECKED Then
				$filter = "in"
				GUICtrlSetData($Group_filter, "Filter IN")
			Else
				$filter = "out"
				GUICtrlSetData($Group_filter, "Filter OUT")
			EndIf
		Case $msg = $Checkbox_first
			; Filter out the selected file type from the list
			If GUICtrlRead($Checkbox_first) = $GUI_CHECKED Then
				$List = $List_check
				$Group = $Group_check
				$caption = "Files To Check For"
				$savlist = @ScriptDir & "\Saved.txt"
				If $enable = 4 Then _GUICtrlListBox_SetCurSel($List_missed, -1)
				GUICtrlSetState($Checkbox_second, $GUI_UNCHECKED)
			Else
				$List = $List_missed
				$Group = $Group_missed
				$caption = "Unmatched Files"
				$savlist = @ScriptDir & "\Unmatched.txt"
				If $enable = 4 Then _GUICtrlListBox_SetCurSel($List_check, -1)
				GUICtrlSetState($Checkbox_second, $GUI_CHECKED)
			EndIf
		Case $msg = $Checkbox_enable
			; Enable Compare
			If GUICtrlRead($Checkbox_enable) = $GUI_CHECKED Then
				$enable = 1
				GUICtrlSetState($Button_compare, $GUI_ENABLE)
			Else
				$enable = 4
				GUICtrlSetState($Button_compare, $GUI_DISABLE)
			EndIf
		Case $msg = $Combo_title
			; Title format to use for Get
			$titget = GUICtrlRead($Combo_title)
		Case $msg = $Combo_filter
			; Filter out the selected file type from the list
			$fext = GUICtrlRead($Combo_filter)
			If $fext <> "" Then
				$count = _GUICtrlListBox_GetCount($List_check)
				If $count > 0 Then
					$fext = "." & $fext
					$len = StringLen($fext)
					EnableDisableCtrls($GUI_DISABLE)
					If $enable = 1 Then GUICtrlSetState($Button_compare, $GUI_DISABLE)
					;
					SplashTextOn("", "Please Wait!" & @LF & "(filter " & $filter & ")", 200, 120, Default, Default, 33)
					$entries = ""
					For $a = 0 To $count - 1
						$entry = _GUICtrlListBox_GetText($List_check, $a)
						$file = StringSplit($entry, " \ ", 1)
						$file = $file[2]
						If $filter = "out" Then
							If StringRight($file, $len) <> $fext Then
								If $entries = "" Then
									$entries = $entry
								Else
									$entries = $entries & "|" & $entry
								EndIf
							EndIf
						ElseIf $filter = "in" Then
							If StringRight($file, $len) = $fext Then
								If $entries = "" Then
									$entries = $entry
								Else
									$entries = $entries & "|" & $entry
								EndIf
							EndIf
						EndIf
					Next
					GUICtrlSetData($List_check, "")
					GUICtrlSetData($List_check, $entries)
					$count = _GUICtrlListBox_GetCount($List_check)
					If $count > 0 Then
						GUICtrlSetData($Group_check, "Files To Check For  (" & $count & ")")
					Else
						GUICtrlSetData($Group_check, "Files To Check For")
					EndIf
					SplashOff()
					;
					EnableDisableCtrls($GUI_ENABLE)
					If $enable = 1 Then GUICtrlSetState($Button_compare, $GUI_ENABLE)
				EndIf
			EndIf
		Case $msg = $Combo_entry
			; Reduce entry to specified
			$val = GUICtrlRead($Combo_entry)
			$entry = GUICtrlRead($Input_entry)
			$entry = StringSplit($entry, "\", 1)
			If $entry[0] > 1 Then
				If $val = "Title" Then
					$entry = $entry[1]
				ElseIf $val = "File" Then
					$entry = $entry[2]
				Else
					$entry = GUICtrlRead($List)
				EndIf
				$entry = StringStripWS($entry, 3)
				GUICtrlSetData($Input_entry, $entry)
			EndIf
		Case $msg = $List_missed
			; List of unmatched game files after check
			$entry = GUICtrlRead($List_missed)
			GUICtrlSetData($Input_entry, $entry)
			;
			$List = $List_missed
			$Group = $Group_missed
			$caption = "Unmatched Files"
			$savlist = @ScriptDir & "\Unmatched.txt"
			If $enable = 4 Then
				_GUICtrlListBox_SetCurSel($List_check, -1)
			Else
				$ind = _GUICtrlListBox_FindString($List_check, $entry, False)
				If $ind > -1 Then _GUICtrlListBox_SetCurSel($List_check, $ind)
			EndIf
			GUICtrlSetState($Checkbox_second, $GUI_CHECKED)
			GUICtrlSetState($Checkbox_first, $GUI_UNCHECKED)
		Case $msg = $List_check
			; List of game files to check for
			$entry = GUICtrlRead($List_check)
			GUICtrlSetData($Input_entry, $entry)
			;
			$List = $List_check
			$Group = $Group_check
			$caption = "Files To Check For"
			$savlist = @ScriptDir & "\Saved.txt"
			If $enable = 4 Then _GUICtrlListBox_SetCurSel($List_missed, -1)
			GUICtrlSetState($Checkbox_first, $GUI_CHECKED)
			GUICtrlSetState($Checkbox_second, $GUI_UNCHECKED)
		Case Else
			;;;
		EndSelect
	WEnd
EndFunc ;=> FileCheckerGUI

Func FileSelectorGUI()
	Local $Button_download, $Button_quit, $Button_uncheck, $Combo_OSfle, $Group_files, $Group_OS, $Label_warn, $ListView_files
	Local $Radio_selall, $Radio_selext, $Radio_selgame, $Radio_selpat, $Radio_selset
	Local $checked, $col1, $col2, $col3, $col4, $downloads, $ents, $fext, $final, $first, $osfle, $p, $portion, $portions, $tmpman, $wide
	;
	$SelectorGUI = GuiCreate("DOWNLOAD Files Selector", $width, $height, $left, $top, $style + $WS_SIZEBOX + $WS_VISIBLE, $WS_EX_TOPMOST)
	GUISetBkColor(0xBBFFBB, $SelectorGUI)
	; CONTROLS
	$Group_files = GuiCtrlCreateGroup("Game Files To Download", 10, 10, $width - 20, 302)
	GUICtrlSetResizing($Group_files, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
	$ListView_files = GUICtrlCreateListView("||||", 20, 30, $width - 40, 270, $LVS_SHOWSELALWAYS + $LVS_SINGLESEL + $LVS_REPORT + $LVS_NOCOLUMNHEADER, _
													$LVS_EX_FULLROWSELECT + $LVS_EX_GRIDLINES + $LVS_EX_CHECKBOXES) ;
	GUICtrlSetBkColor($ListView_files, 0xB9FFFF)
	GUICtrlSetResizing($ListView_files, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
	;
	$Label_warn = GuiCtrlCreateLabel("", 10, 318, $width - 20, 20, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_warn, $COLOR_RED)
	GUICtrlSetColor($Label_warn, $COLOR_YELLOW)
	GUICtrlSetFont($Label_warn, 9, 600)
	GUICtrlSetResizing($Label_warn, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
	;
	$Group_select = GuiCtrlCreateGroup("Select Files", 10, $height - 65, 300, 55)
	GUICtrlSetResizing($Group_select, $GUI_DOCKLEFT + $GUI_DOCKALL + $GUI_DOCKSIZE)
	$Radio_selall = GUICtrlCreateRadio("ALL", 20, $height - 44,  50, 20)
	GUICtrlSetResizing($Radio_selall, $GUI_DOCKLEFT + $GUI_DOCKALL + $GUI_DOCKSIZE)
	GUICtrlSetTip($Radio_selall, "Select ALL file entries!")
	$Radio_selgame = GUICtrlCreateRadio("GAME", 70, $height - 44,  60, 20)
	GUICtrlSetResizing($Radio_selgame, $GUI_DOCKLEFT + $GUI_DOCKALL + $GUI_DOCKSIZE)
	GUICtrlSetTip($Radio_selgame, "Select GAME file entries!")
	$Radio_selext = GUICtrlCreateRadio("EXTRA", 130, $height - 44,  65, 20)
	GUICtrlSetResizing($Radio_selext, $GUI_DOCKLEFT + $GUI_DOCKALL + $GUI_DOCKSIZE)
	GUICtrlSetTip($Radio_selext, "Select EXTRA file entries!")
	$Radio_selset = GUICtrlCreateRadio("setup", 195, $height - 44,  55, 20)
	GUICtrlSetResizing($Radio_selset, $GUI_DOCKLEFT + $GUI_DOCKALL + $GUI_DOCKSIZE)
	GUICtrlSetTip($Radio_selset, "Select SETUP file entries!")
	$Radio_selpat = GUICtrlCreateRadio("patch", 250, $height - 44,  50, 20)
	GUICtrlSetResizing($Radio_selpat, $GUI_DOCKLEFT + $GUI_DOCKALL + $GUI_DOCKSIZE)
	GUICtrlSetTip($Radio_selpat, "Select PATCH file entries!")
	GUICtrlSetBkColor($Radio_selall, 0xFFD5FF)
	GUICtrlSetBkColor($Radio_selgame, 0xFFD5FF)
	GUICtrlSetBkColor($Radio_selext, 0xFFD5FF)
	GUICtrlSetBkColor($Radio_selset, 0xFFD5FF)
	GUICtrlSetBkColor($Radio_selpat, 0xFFD5FF)
	;
	$Group_OS = GuiCtrlCreateGroup("OS", $width - 270, $height - 65, 90, 55)
	GUICtrlSetResizing($Group_OS, $GUI_DOCKLEFT + $GUI_DOCKALL + $GUI_DOCKSIZE)
	$Combo_OSfle = GUICtrlCreateCombo("", $width - 260, $height - 45, 70, 21)
	GUICtrlSetResizing($Combo_OSfle, $GUI_DOCKLEFT + $GUI_DOCKALL + $GUI_DOCKSIZE)
	GUICtrlSetTip($Combo_OSfle, "OS for files!")
	;
	$Button_download = GuiCtrlCreateButton("DOWNLOAD", $width - 170, $height - 60, 105, 28)
	GUICtrlSetFont($Button_download, 8, 600)
	GUICtrlSetResizing($Button_download, $GUI_DOCKLEFT + $GUI_DOCKALL + $GUI_DOCKSIZE)
	GUICtrlSetTip($Button_download, "Download selected files!")
	;
	$Button_uncheck = GuiCtrlCreateButton("De-Select ALL", $width - 170, $height - 28, 105, 18)
	GUICtrlSetFont($Button_uncheck, 7, 600, 0, "Small Fonts")
	GUICtrlSetResizing($Button_uncheck, $GUI_DOCKLEFT + $GUI_DOCKALL + $GUI_DOCKSIZE)
	GUICtrlSetTip($Button_uncheck, "Deselect ALL files!")
	;
	$Button_quit = GuiCtrlCreateButton("EXIT", $width - 55, $height - 60, 45, 50, $BS_ICON)
	GUICtrlSetResizing($Button_quit, $GUI_DOCKLEFT + $GUI_DOCKALL + $GUI_DOCKSIZE)
	GUICtrlSetTip($Button_quit, "Exit / Close / Quit the window!")
	;
	; SETTINGS
	GUICtrlSetImage($Button_quit, $user, $icoX, 1)
	;
	GUICtrlSetData($Label_warn, "Ensure desired download settings have been set on main program window etc.")
	;
	$osfle = IniRead($inifle, "Selector", "OS", "")
	If $osfle = "" Then
		$osfle = "Both"
		IniWrite($inifle, "Selector", "OS", $osfle)
	EndIf
	GUICtrlSetData($Combo_OSfle, "Both|Windows|Linux", $osfle)
	;
	$tmpman = @ScriptDir & "\Temp.dat"
	$open = FileOpen($tmpman, 2)
	FileWrite($open, $chunk)
	FileClose($open)
	;
	$lines = ""
	$first = ""
	$next = ""
	$final = ""
	$col1 = 0
	$col2 = ""
	$col3 = ""
	$col4 = ""
	$array = StringSplit($chunk, @LF, 1)
	For $a = 1 To $array[0]
		$line = $array[$a]
		If StringInStr($line, "'downloads':") > 0 Then
			$col2 = "GAME"
			$tmpman = @ScriptDir & "\Game_1.dat"
			$open = FileOpen($tmpman, 2)
			FileWrite($open, $lines)
			FileClose($open)
			$line = StringReplace($line, "'downloads': [", "")
			$lines = "<DOWNLOAD>" & @LF & $line
			$next = 1
		ElseIf StringInStr($line, "'extras':") > 0 Then
			$col2 = "EXTRA"
			$tmpman = @ScriptDir & "\Game_2.dat"
			$open = FileOpen($tmpman, 2)
			FileWrite($open, $lines)
			FileClose($open)
			$line = StringReplace($line, "'extras': [", "")
			$lines = "<EXTRA>" & @LF & $line
			$next = 2
		ElseIf StringInStr($line, "'name':") > 0 Then
			$lines = $lines & @LF & $line
			$col3 = $line
			$col3 = StringSplit($col3, "'name':", 1)
			$col3 = $col3[2]
			If StringInStr($col3, "None,") > 0 Then
				$col3 = "None"
			Else
				$col3 = StringSplit($col3, "'", 1)
				If $col3[0] > 1 Then
					$col3 = $col3[2]
				Else
					$col3 = $col3[1]
				EndIf
			EndIf
		ElseIf StringInStr($line, "'size':") > 0 Then
			$lines = $lines & @LF & $line
			$col4 = $line
			$col4 = StringSplit($col4, "'size':", 1)
			$col4 = $col4[2]
			$col4 = StringSplit($col4, ",", 1)
			$col4 = $col4[1]
			$col4 = StringStripWS($col4, 8)
			If StringIsDigit($col4) Then
				$size = $col4
				GetTheSize()
				$col4 = $size
			Else
				$col4 = "0 bytes"
			EndIf
		ElseIf StringInStr($line, "'forum_url':") > 0 Then
			$tmpman = @ScriptDir & "\Game_3.dat"
			$open = FileOpen($tmpman, 2)
			FileWrite($open, $lines)
			FileClose($open)
			$lines = $line
			$col2 = ""
		Else
			If $col2 = "" Then
				If $lines = "" Then
					$lines = $line
				Else
					$lines = $lines & @LF & $line
				EndIf
			ElseIf $lines <> "" Then
				If StringInStr($line, "'desc':") > 0 Then
					If $col2 = "GAME" Then
						$lines = $lines & @LF & "<DOWNLOAD>" & @LF & $line
					ElseIf $col2 = "EXTRA" Then
						$lines = $lines & @LF & "<EXTRA>" & @LF & $line
					EndIf
				Else
					$lines = $lines & @LF & $line
				EndIf
			EndIf
		EndIf
		If $col4 <> "" Then
			$col1 = $col1 + 1
			$entry = $col1 & "|" & $col2 & "|" & $col3 & "|" & $col4
			;MsgBox(262208, "Entry Information", $entry, 0, $SelectorGUI)
			GUICtrlCreateListViewItem($entry, $ListView_files)
			$col3 = ""
			$col4 = ""
		EndIf
	Next
	If $lines <> "" Then
		If $final = "" Then
			$final = 1
			$tmpman = @ScriptDir & "\Game_4.dat"
			$open = FileOpen($tmpman, 2)
			FileWrite($open, $lines)
			FileClose($open)
			$lines = ""
		EndIf
	EndIf
	_GUICtrlListView_JustifyColumn($ListView_files, 0, 0)
	_GUICtrlListView_JustifyColumn($ListView_files, 1, 2)
	_GUICtrlListView_JustifyColumn($ListView_files, 2, 0)
	_GUICtrlListView_JustifyColumn($ListView_files, 3, 2)
	_GUICtrlListView_SetColumnWidth($ListView_files, 0, 45)
	_GUICtrlListView_SetColumnWidth($ListView_files, 1, 55)
	_GUICtrlListView_SetColumnWidth($ListView_files, 2, $LVSCW_AUTOSIZE)
	_GUICtrlListView_SetColumnWidth($ListView_files, 3, 70)
	;
	$ents = _GUICtrlListView_GetItemCount($ListView_files)
	GUICtrlSetData($Group_files, "Game Files To Download (" & $ents & ")")

	GuiSetState()
	While 1
		$msg = GuiGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Button_quit
			; Exit / Close / Quit the window
			GUIDelete($SelectorGUI)
			ExitLoop
		Case $msg = $GUI_EVENT_MINIMIZE
			GUISetState(@SW_MINIMIZE, $GOGRepoGUI)
		Case $msg = $GUI_EVENT_RESIZED
			$winpos = WinGetPos($SelectorGUI, "")
			$wide = $winpos[2]
			WinMove($SelectorGUI, "", $left, $top, $wide, $height + 38)
		Case $msg = $Button_uncheck
			; Deselect ALL files
			_GUICtrlListView_SetItemChecked($ListView_files, -1, False)
			If $ents > 0 Then
				GUICtrlSetData($Group_files, "Game Files To Download (" & $ents & ")")
			Else
				GUICtrlSetData($Group_files, "Game Files To Download")
			EndIf
		Case $msg = $Button_download
			; Download selected files
			GUICtrlSetState($Button_download, $GUI_DISABLE)
			GUICtrlSetState($ListView_files, $GUI_DISABLE)
			GUICtrlSetState($Radio_selall, $GUI_DISABLE)
			GUICtrlSetState($Radio_selgame, $GUI_DISABLE)
			GUICtrlSetState($Radio_selext, $GUI_DISABLE)
			GUICtrlSetState($Radio_selset, $GUI_DISABLE)
			GUICtrlSetState($Radio_selpat, $GUI_DISABLE)
			GUICtrlSetState($Combo_OSfle, $GUI_DISABLE)
			GUICtrlSetState($Button_uncheck, $GUI_DISABLE)
			GUICtrlSetState($Button_quit, $GUI_DISABLE)
			$downloads = ""
			For $a = 0 To $ents - 1
				If _GUICtrlListView_GetItemChecked($ListView_files, $a) = True Then
					$entry = _GUICtrlListView_GetItemText($ListView_files, $a, 1)
					$entry = $entry & ":" & _GUICtrlListView_GetItemText($ListView_files, $a, 2)
					If $downloads = "" Then
						$downloads = $entry
					Else
						$downloads = $downloads & "|" & $entry
					EndIf
				EndIf
			Next
			If $downloads <> "" Then
				;MsgBox(262208, "Downloads Information", $downloads, 0, $SelectorGUI)
				$bypass = 0
				$tmpman = @ScriptDir & "\Game_1.dat"
				If FileExists($tmpman) Then
					;$chunk =  _FileReadToArray($tmpman)
					$open = FileOpen($tmpman, 0)
					$read = FileRead($open)
					FileClose($open)
					$chunk = $read
					If StringInStr($downloads, "GAME:") > 0 Then
						$tmpman = @ScriptDir & "\Game_2.dat"
						If FileExists($tmpman) Then
							$open = FileOpen($tmpman, 0)
							$read = FileRead($open)
							FileClose($open)
							$lines = ""
							$entries = StringSplit($downloads, "|", 1)
							For $e = 1 To $entries[0]
								$entry = $entries[$e]
								$entry = StringSplit($entry, ":", 1)
								$entry = $entry[2]
								;MsgBox(262208, "$entry", "|" & $entry, 0, $SelectorGUI)
								$portions = StringSplit($read, "<DOWNLOAD>" & @LF, 1)
								For $p = 1 To $portions[0]
									$portion = $portions[$p]
									If StringInStr($portion, $entry) > 0 Then
										If StringInStr($portion, "'desc':") > 0 Then
											$portion = StringReplace($portion, "}],", "},")
											If $lines = "" Then
												$portion = StringStripWS($portion, 1)
												$lines = "  'downloads': [" & $portion
												;MsgBox(262208, "$lines", "|" & $lines, 0, $SelectorGUI)
											Else
												$lines = $lines & $portion
											EndIf
										EndIf
										ExitLoop
									EndIf
								Next
							Next
							$lines = StringReplace($lines, "},", "}],", -1)
							$chunk = $chunk & @LF & $lines
						Else
							MsgBox(262192, "Build Error", "File not found (Game_2.dat)!", 0, $SelectorGUI)
						EndIf
					Else
						$bypass = 1
						$lines = "  'downloads': [],"
						$chunk = $chunk & @LF & $lines
					EndIf
					If StringInStr($downloads, "EXTRA:") > 0 Then
						$tmpman = @ScriptDir & "\Game_3.dat"
						If FileExists($tmpman) Then
							$open = FileOpen($tmpman, 0)
							$read = FileRead($open)
							FileClose($open)
							$lines = ""
							$entries = StringSplit($downloads, "|", 1)
							For $e = 1 To $entries[0]
								$entry = $entries[$e]
								$entry = StringSplit($entry, ":", 1)
								$entry = $entry[2]
								$portions = StringSplit($read, "<EXTRA>" & @LF, 1)
								For $p = 1 To $portions[0]
									$portion = $portions[$p]
									If StringInStr($portion, $entry) > 0 Then
										If StringInStr($portion, "'desc':") > 0 Then
											$portion = StringReplace($portion, "}],", "},")
											If $lines = "" Then
												$portion = StringStripWS($portion, 1)
												$lines = "  'extras': [" & $portion
											Else
												$lines = $lines & $portion
											EndIf
										EndIf
										ExitLoop
									EndIf
								Next
							Next
							$chunk = StringStripWS($chunk, 2)
							$lines = StringReplace($lines, "},", "}],", -1)
							$chunk = $chunk & @LF & $lines
						Else
							MsgBox(262192, "Build Error", "File not found (Game_3.dat)!", 0, $SelectorGUI)
						EndIf
					Else
						$bypass = 2
						$lines = "  'extras': [],"
						$chunk = $chunk & @LF & $lines
					EndIf
					$tmpman = @ScriptDir & "\Game_4.dat"
					If FileExists($tmpman) Then
						$open = FileOpen($tmpman, 0)
						$read = FileRead($open)
						FileClose($open)
						$chunk = StringStripWS($chunk, 2)
						$chunk = $chunk & @LF & $read
						$gamefle = @ScriptDir & "\Game.dat"
						$open = FileOpen($gamefle, 2)
						FileWrite($open, $chunk)
						FileClose($open)
						If FileExists($gamefle) Then
							;$title = GUICtrlRead($Input_title)
							;$name = GUICtrlRead($List_games)
							If FileExists($gogrepo) Then
								$ans = ""
								CheckIfPythonRunning()
								If $ans = 2 Then ContinueLoop
								;
								$gamesfold = $dest
								If $gamesfold <> "" Then
									$path = IniRead($locations, $name, "path", "")
									If $path <> "" Then
										$gamesfold = $path
									EndIf
									$gamefold = $gamesfold
									If $alpha = 1 Then
										$alf = StringUpper(StringLeft($title, 1))
										$gamefold = $gamefold & "\" & $alf
										;MsgBox(262192, "Got Here 2", $title & @LF & $gamefold, $wait, $SelectorGUI)
									EndIf
									$drv = StringLeft($gamefold, 3)
									If FileExists($drv) Then
										If Not FileExists($gamefold) Then
											DirCreate($gamefold)
										EndIf
									EndIf
									If FileExists($gamefold) Then
										; Download one or more game files
										FileChangeDir(@ScriptDir)
										CheckForConnection()
										If $connection = 1 Then
											$tmpman = $manifest & ".tmp"
											$res = FileMove($manifest, $tmpman, 1)
											If $res = 1 And FileExists($tmpman) Then
												;_FileCreate($finished)
												_FileWriteLog($logfle, "Downloading (files) - " & $title & ".")
												;IniWrite($inifle, "Current Download", "title", $title)
												;IniWrite($inifle, "Current Download", "destination", $gamefold)
												$res = FileMove($gamefle, $manifest, 0)
												If $res = 1 And FileExists($manifest) Then
													;GUISetState(@SW_MINIMIZE, $SelectorGUI)
													;GUISetState(@SW_MINIMIZE, $GOGRepoGUI)
													;
													CheckOnShutdown()
													If $minimize = 1 Then
														$flag = @SW_MINIMIZE
													Else
														;$flag = @SW_RESTORE
														$flag = @SW_SHOW
													EndIf
													;If $bargui = 1 And FileExists($progbar) Then
													;	$pid = ShellExecute($progbar, "Download", @ScriptDir, "open", $flag)
													;Else
														If $script = "default" Then
															Local $params = " -skipextras -skipgames"
															If $bypass <> 1 Then
																; Game Files required
																;If $files = 1 Then $params = StringReplace($params, " -skipgames", "")
																$params = StringReplace($params, " -skipgames", "")
															EndIf
														Else
															Local $params = " -os " & $OS & " -lang " & $lang & " -skipextras -skipgalaxy -skipstandalone -skipshared -nolog"
															If $bypass <> 1 Then
																; Game Files required, according to settings
																If $galaxy = 1 Then $params = StringReplace($params, " -skipgalaxy", "")
																If $standalone = 1 Then $params = StringReplace($params, " -skipstandalone", "")
																If $shared = 1 Then $params = StringReplace($params, " -skipshared", "")
															EndIf
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
														If $bypass <> 2 Then
															; Extras required
															;If $extras = 1 Then $params = StringReplace($params, " -skipextras", "")
															$params = StringReplace($params, " -skipextras", "")
														EndIf
														;MsgBox(262192, "Parameters", $params, 0, $GOGRepoGUI)
														$pid = RunWait(@ComSpec & ' /c gogrepo.py download' & $params & ' -id ' & $title & ' "' & $gamefold & '" &&pause', @ScriptDir, $flag)
													;EndIf
													If $cover = 1 Then
														$image = IniRead($gamesfle, $name, "image", "")
														If $image <> "" Then
															SplashTextOn("", "Saving Cover!", 200, 120, Default, Default, 33)
															$gamepic = $gamefold & "\" & $title
															If Not FileExists($gamepic) Then
																DirCreate($gamepic)
															EndIf
															$gamepic = $gamepic & "\Folder.jpg"
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
													;_FileWriteLog($finished, $current)
													_FileWriteLog($logfle, "Download finished.")
													;MsgBox(262208, "Checking", $tmpman, 0, $SelectorGUI)
													If FileExists($manifest) Then
														$res = FileMove($manifest, $gamefle, 0)
														If $res = 1 And FileExists($gamefle) Then
															$res = FileMove($tmpman, $manifest, 0)
															If $res = 1 And FileExists($manifest) Then
																; Original Manifest Restored
															Else
																MsgBox(262192, "Program Error", "Original manifest file could not be restored!", 0, $SelectorGUI)
															EndIf
														Else
															MsgBox(262192, "Program Error", "Temporary manifest file could not be renamed!", 0, $SelectorGUI)
														EndIf
													Else
														$res = 0
														MsgBox(262192, "Unusual Error", "Temporary manifest file not found!", 0, $SelectorGUI)
														If FileExists($tmpman) Then
															$res = FileMove($tmpman, $manifest, 0)
															If $res = 1 And FileExists($manifest) Then
																; Original Manifest Restored
															Else
																MsgBox(262192, "Program Error", "Original manifest file could not be restored!", 0, $SelectorGUI)
															EndIf
														EndIf
													EndIf
													If $res = 0 Then
														MsgBox(262192, "Restore Error", "You will need to manually rename the manifest based file(s) to restore " _
															& "them to their original file names. If 'manifest.dat.tmp' file exists, it will need renaming to " _
															& "'manifest.dat', but you might first need to rename any already existing 'manifest.dat' file to " _
															& "'Game.dat'." & @LF & @LF _
															& " IT IS IMPORTANT TO DO this before any further use of this program.", 0, $SelectorGUI)
													EndIf
													If $shutdown <> "none" And $res = 1 Then
														Local $code
														$ans = MsgBox(262193, "Shutdown Query", _
															"PC is set to shutdown in 99 seconds." & @LF & @LF & _
															"OK = Shutdown." & @LF & _
															"CANCEL = Abort shutdown.", 99, $SelectorGUI)
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
													;GUISetState(@SW_RESTORE, $SelectorGUI)
													;GUISetState(@SW_RESTORE, $GOGRepoGUI)
												Else
													MsgBox(262192, "Program Error", "Temporary manifest file could not be renamed!", 0, $SelectorGUI)
												EndIf
											Else
												MsgBox(262192, "Program Error", "Original manifest file could not be renamed!", 0, $SelectorGUI)
											EndIf
										Else
											MsgBox(262192, "Download Error", "No web connection.", 0, $SelectorGUI)
										EndIf
									Else
										MsgBox(262192, "Path Error", "Game folder not found!", 0, $SelectorGUI)
									EndIf
								Else
									MsgBox(262192, "Path Error", "Destination not set!", 0, $SelectorGUI)
								EndIf
							Else
								MsgBox(262192, "Program Error", "Required file 'gogrepo.py' not found!", 0, $SelectorGUI)
							EndIf
						Else
							MsgBox(262192, "Build Error", "File not found (Game.dat)!", 0, $SelectorGUI)
						EndIf
					Else
						MsgBox(262192, "Build Error", "File not found (Game_4.dat)!", 0, $SelectorGUI)
					EndIf
				Else
					MsgBox(262192, "Build Error", "File not found (Game_1.dat)!", 0, $SelectorGUI)
				EndIf
			Else
				MsgBox(262192, "Program Error", "Nothing to download!", 0, $SelectorGUI)
			EndIf
			GUICtrlSetState($Button_download, $GUI_ENABLE)
			GUICtrlSetState($ListView_files, $GUI_ENABLE)
			GUICtrlSetState($Radio_selall, $GUI_ENABLE)
			GUICtrlSetState($Radio_selgame, $GUI_ENABLE)
			GUICtrlSetState($Radio_selext, $GUI_ENABLE)
			GUICtrlSetState($Radio_selset, $GUI_ENABLE)
			GUICtrlSetState($Radio_selpat, $GUI_ENABLE)
			GUICtrlSetState($Combo_OSfle, $GUI_ENABLE)
			GUICtrlSetState($Button_uncheck, $GUI_ENABLE)
			GUICtrlSetState($Button_quit, $GUI_ENABLE)
		Case $msg = $Combo_OSfle
			; OS for files
			$osfle = GUICtrlRead($Combo_OSfle)
			IniWrite($inifle, "Selector", "OS", $osfle)
		Case $msg = $ListView_files Or $msg > $Button_quit
			; Game Files To Download
			$checked = 0
			For $a = 0 To $ents - 1
				If _GUICtrlListView_GetItemChecked($ListView_files, $a) = True Then
					$checked = $checked + 1
				EndIf
			Next
			If $checked = 0 Then
				If $ents > 0 Then
					GUICtrlSetData($Group_files, "Game Files To Download (" & $ents & ")")
				Else
					GUICtrlSetData($Group_files, "Game Files To Download")
				EndIf
			Else
				GUICtrlSetData($Group_files, "Game Files To Download (" & $ents & ")  Selected  (" & $checked & ")")
			EndIf
		Case $msg = $Radio_selset
			; Select SETUP file entries
			$checked = 0
			For $a = 0 To $ents - 1
				$entry = _GUICtrlListView_GetItemText($ListView_files, $a, 2)
				If $osfle = "Both" Then
					If StringInStr($entry, "setup_") > 0 Then
						_GUICtrlListView_SetItemChecked($ListView_files, $a, True)
						$checked = $checked + 1
					ElseIf StringInStr($entry, "patch_") < 1 Then
						$entry = _GUICtrlListView_GetItemText($ListView_files, $a, 1)
						If $entry = "GAME" Then
							_GUICtrlListView_SetItemChecked($ListView_files, $a, True)
							$checked = $checked + 1
						Else
							_GUICtrlListView_SetItemChecked($ListView_files, $a, False)
						EndIf
					Else
						_GUICtrlListView_SetItemChecked($ListView_files, $a, False)
					EndIf
				ElseIf StringInStr($entry, "patch_") < 1 Then
					$fext = StringRight($entry, 4)
					$entry = _GUICtrlListView_GetItemText($ListView_files, $a, 1)
					If $entry = "GAME" Then
						If $osfle = "Windows" Then
							If $fext = ".exe" Or $fext = ".bin" Then
								_GUICtrlListView_SetItemChecked($ListView_files, $a, True)
								$checked = $checked + 1
							Else
								_GUICtrlListView_SetItemChecked($ListView_files, $a, False)
							EndIf
						ElseIf $fext <> ".exe" And $fext <> ".bin" Then
							_GUICtrlListView_SetItemChecked($ListView_files, $a, True)
							$checked = $checked + 1
						Else
							_GUICtrlListView_SetItemChecked($ListView_files, $a, False)
						EndIf
					Else
						_GUICtrlListView_SetItemChecked($ListView_files, $a, False)
					EndIf
				Else
					_GUICtrlListView_SetItemChecked($ListView_files, $a, False)
				EndIf
			Next
			If $checked = 0 Then
				If $ents > 0 Then
					GUICtrlSetData($Group_files, "Game Files To Download (" & $ents & ")")
				Else
					GUICtrlSetData($Group_files, "Game Files To Download")
				EndIf
			Else
				GUICtrlSetData($Group_files, "Game Files To Download (" & $ents & ")  Selected  (" & $checked & ")")
			EndIf
		Case $msg = $Radio_selpat
			; Select PATCH file entries
			$checked = 0
			For $a = 0 To $ents - 1
				$entry = _GUICtrlListView_GetItemText($ListView_files, $a, 2)
				$fext = StringRight($entry, 4)
				If StringInStr($entry, "patch_") > 0 Then
					If $osfle = "Both" Then
						_GUICtrlListView_SetItemChecked($ListView_files, $a, True)
						$checked = $checked + 1
					Else
						If $osfle = "Windows" Then
							If $fext = ".exe" Or $fext = ".bin" Then
								_GUICtrlListView_SetItemChecked($ListView_files, $a, True)
								$checked = $checked + 1
							Else
								_GUICtrlListView_SetItemChecked($ListView_files, $a, False)
							EndIf
						ElseIf $fext <> ".exe" And $fext <> ".bin" Then
							_GUICtrlListView_SetItemChecked($ListView_files, $a, True)
							$checked = $checked + 1
						Else
							_GUICtrlListView_SetItemChecked($ListView_files, $a, False)
						EndIf
					EndIf
				Else
					_GUICtrlListView_SetItemChecked($ListView_files, $a, False)
				EndIf
			Next
			If $checked = 0 Then
				If $ents > 0 Then
					GUICtrlSetData($Group_files, "Game Files To Download (" & $ents & ")")
				Else
					GUICtrlSetData($Group_files, "Game Files To Download")
				EndIf
			Else
				GUICtrlSetData($Group_files, "Game Files To Download (" & $ents & ")  Selected  (" & $checked & ")")
			EndIf
		Case $msg = $Radio_selgame
			; Select GAME file entries
			$checked = 0
			For $a = 0 To $ents - 1
				$entry = _GUICtrlListView_GetItemText($ListView_files, $a, 1)
				If $entry = "GAME" Then
					If $osfle = "Both" Then
						_GUICtrlListView_SetItemChecked($ListView_files, $a, True)
						$checked = $checked + 1
					Else
						$entry = _GUICtrlListView_GetItemText($ListView_files, $a, 2)
						$fext = StringRight($entry, 4)
						If $osfle = "Windows" Then
							If $fext = ".exe" Or $fext = ".bin" Then
								_GUICtrlListView_SetItemChecked($ListView_files, $a, True)
								$checked = $checked + 1
							Else
								_GUICtrlListView_SetItemChecked($ListView_files, $a, False)
							EndIf
						ElseIf $fext <> ".exe" And $fext <> ".bin" Then
							_GUICtrlListView_SetItemChecked($ListView_files, $a, True)
							$checked = $checked + 1
						Else
							_GUICtrlListView_SetItemChecked($ListView_files, $a, False)
						EndIf
					EndIf
				Else
					_GUICtrlListView_SetItemChecked($ListView_files, $a, False)
				EndIf
			Next
			If $checked = 0 Then
				If $ents > 0 Then
					GUICtrlSetData($Group_files, "Game Files To Download (" & $ents & ")")
				Else
					GUICtrlSetData($Group_files, "Game Files To Download")
				EndIf
			Else
				GUICtrlSetData($Group_files, "Game Files To Download (" & $ents & ")  Selected  (" & $checked & ")")
			EndIf
		Case $msg = $Radio_selext
			; Select EXTRA file entries
			$checked = 0
			For $a = 0 To $ents - 1
				$entry = _GUICtrlListView_GetItemText($ListView_files, $a, 1)
				If $entry = "EXTRA" Then
					_GUICtrlListView_SetItemChecked($ListView_files, $a, True)
					$checked = $checked + 1
				Else
					_GUICtrlListView_SetItemChecked($ListView_files, $a, False)
				EndIf
			Next
			If $checked = 0 Then
				If $ents > 0 Then
					GUICtrlSetData($Group_files, "Game Files To Download (" & $ents & ")")
				Else
					GUICtrlSetData($Group_files, "Game Files To Download")
				EndIf
			Else
				GUICtrlSetData($Group_files, "Game Files To Download (" & $ents & ")  Selected  (" & $checked & ")")
			EndIf
		Case $msg = $Radio_selall
			; Select ALL file entries
			If $osfle = "Both" Then
				_GUICtrlListView_SetItemChecked($ListView_files, -1, True)
			Else
				For $a = 0 To $ents - 1
					$entry = _GUICtrlListView_GetItemText($ListView_files, $a, 1)
					If $entry = "EXTRA" Then
						_GUICtrlListView_SetItemChecked($ListView_files, $a, True)
					Else
						$entry = _GUICtrlListView_GetItemText($ListView_files, $a, 2)
						$fext = StringRight($entry, 4)
						If $osfle = "Windows" Then
							If $fext = ".exe" Or $fext = ".bin" Then
								_GUICtrlListView_SetItemChecked($ListView_files, $a, True)
								$checked = $checked + 1
							Else
								_GUICtrlListView_SetItemChecked($ListView_files, $a, False)
							EndIf
						ElseIf $fext <> ".exe" And $fext <> ".bin" Then
							_GUICtrlListView_SetItemChecked($ListView_files, $a, True)
						Else
							_GUICtrlListView_SetItemChecked($ListView_files, $a, False)
						EndIf
					EndIf
				Next
			EndIf
			If $ents > 0 Then
				GUICtrlSetData($Group_files, "Game Files To Download (" & $ents & ")  Selected  (" & $ents & ")")
			Else
				GUICtrlSetData($Group_files, "Game Files To Download")
			EndIf
		Case Else
			;;;
		EndSelect
	WEnd
EndFunc ;=> FileSelectorGUI

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
					;GUICtrlSetState($Button_move, $GUI_ENABLE)
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
				GUICtrlSetState($Item_check, $GUI_DISABLE)
				GUICtrlSetState($Item_remove, $GUI_DISABLE)
				GUICtrlSetState($Item_delete, $GUI_DISABLE)
				;GUICtrlSetState($Button_move, $GUI_DISABLE)
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
							$OS = IniRead($downlist, $title, "OS", "")
							IniWrite($inifle, "Current Download", "OS", $OS)
							$lang = IniRead($downlist, $title, "language", "")
							IniWrite($inifle, "Current Download", "language", $lang)
							$params = " -os " & $OS & " -lang " & $lang & " -skipextras -skipgalaxy -skipstandalone -skipshared -nolog"
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
							$val = IniRead($downlist, $title, "skiplang", "")
							IniWrite($inifle, "Current Download", "skiplang", $val)
							If $val = 1 Then
								$val = IniRead($downlist, $title, "languages", "")
								If $val <> "" Then $params = $params & " -skiplang " & $val
							Else
								$val = ""
							EndIf
							IniWrite($inifle, "Current Download", "langskip", $val)
							;
							$val = IniRead($downlist, $title, "skipOS", "")
							IniWrite($inifle, "Current Download", "skipOS", $val)
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
						If $script = "fork" Then
							$val = IniRead($downlist, $title, "verylog", "")
							IniWrite($inifle, "Current Download", "verylog", $val)
							$val = IniRead($downlist, $title, "veryextra", "")
							IniWrite($inifle, "Current Download", "veryextra", $val)
							$val = IniRead($downlist, $title, "verygames", "")
							IniWrite($inifle, "Current Download", "verygames", $val)
							$val = IniRead($downlist, $title, "veryalone", "")
							IniWrite($inifle, "Current Download", "veryalone", $val)
							$val = IniRead($downlist, $title, "veryshare", "")
							IniWrite($inifle, "Current Download", "veryshare", $val)
							$val = IniRead($downlist, $title, "verygalaxy", "")
							IniWrite($inifle, "Current Download", "verygalaxy", $val)
						EndIf
						;
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
				If $started = 4 Then IniDelete($inifle, "Current Download")
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
				$val = IniRead($downlist, $title, "skiplang", "")
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
	Local $above, $combos, $high, $langs, $long, $password, $side, $username, $wide
	;
	$wide = 230
	$high = 430
	$side = IniRead($inifle, "Setup Window", "left", $left)
	$above = IniRead($inifle, "Setup Window", "top", $top)
	$SetupGUI = GuiCreate("Setup - Python & Cookie etc", $wide, $high, $side, $above, $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU _
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
	Local $Button_backups, $Button_begin, $Button_changed, $Button_changes, $Button_close, $Button_continue, $Button_inf
	Local $Button_program, $Button_upnow, $Checkbox_clean, $Checkbox_console, $Checkbox_every, $Checkbox_new, $Checkbox_replace
	Local $Checkbox_resume, $Checkbox_skip, $Checkbox_stages, $Checkbox_tag, $Checkbox_uplog, $Checkbox_window, $Combo_games
	Local $Combo_install, $Group_complete, $Group_folders, $Group_stages, $Group_windows, $Input_blocks, $Input_language
	Local $Input_OSes, $Label_blocks, $Label_done, $Label_games, $Label_install, $Label_lang, $Label_OS, $Updown_blocks
	;
	Local $above, $block, $blocks, $clean, $cleaned, $cleanup, $completed, $entry, $err, $erred, $errors, $found, $high
	Local $i, $id, $ids, $installer, $installers, $loop, $names, $newgames, $out, $params, $pass, $remain, $replace, $results
	Local $resume, $resumeman, $ret, $side, $skiphid, $stage, $stagefile, $stages, $start, $sum, $tagged, $uplog, $wide
	;
	$wide = 250
	$high = 405
	$side = IniRead($inifle, "Update Window", "left", $left)
	$above = IniRead($inifle, "Update Window", "top", $top)
	$UpdateGUI = GuiCreate("Update The Manifest", $wide, $high, $side, $above, $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU _
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
	$Input_language = GUICtrlCreateInput("", 160, 10, 80, 20)
	GUICtrlSetTip($Input_language, "Selected language(s)!")
	;
	$Label_OS = GuiCtrlCreateLabel("OS", 10, 38, 35, 20, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_OS, $COLOR_BLUE)
	GUICtrlSetColor($Label_OS, $COLOR_WHITE)
	GUICtrlSetFont($Label_OS, 7, 600, 0, "Small Fonts")
	$Input_OSes = GUICtrlCreateInput("", 45, 38, 125, 20)
	GUICtrlSetTip($Input_OSes, "Selected OS!")
	;
	$Checkbox_resume = GUICtrlCreateCheckbox("Resume", 183, 38, 55, 20, $BS_AUTO3STATE)
	GUICtrlSetTip($Checkbox_resume, "Enable resume modes for updating!")
	;
	$Checkbox_skip = GUICtrlCreateCheckbox("Skip Hidden Games  (set in the GOG Library)", 10, 65, 230, 20)
	GUICtrlSetTip($Checkbox_skip, "Skip updating the manifest for hidden games!")
	;
	$Checkbox_uplog = GUICtrlCreateCheckbox("Log File", 10, 90, 55, 20)
	GUICtrlSetTip($Checkbox_uplog, "Save a Log file for update!")
	;
	$Label_install = GuiCtrlCreateLabel("Installers", 75, 90, 65, 21, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_install, $COLOR_BLACK)
	GUICtrlSetColor($Label_install, $COLOR_WHITE)
	GUICtrlSetFont($Label_install, 7, 600, 0, "Small Fonts")
	$Combo_install = GUICtrlCreateCombo("", 140, 90, 100, 21)
	GUICtrlSetTip($Combo_install, "Installers to update for!")
	;
	$Checkbox_new = GUICtrlCreateCheckbox("New Games Only", 10, 116, 100, 20)
	GUICtrlSetTip($Checkbox_new, "Add new games only to the manifest!")
	;
	$Checkbox_tag = GUICtrlCreateCheckbox("Use the Update Tag", 124, 116, 115, 20)
	GUICtrlSetTip($Checkbox_tag, "Update games with Update Tag!")
	;
	$Group_stages = GUICtrlCreateGroup("Update ALL In Stages", 10, 140, 230, 88)
	$Button_begin = GuiCtrlCreateButton("BEGIN", 20, 158, 77, 32)
	GUICtrlSetFont($Button_begin, 9, 600)
	GUICtrlSetTip($Button_begin, "Begin Updating in Stages!")
	$Button_continue = GuiCtrlCreateButton("CONTINUE", 107, 158, 103, 32)
	GUICtrlSetFont($Button_continue, 9, 600)
	GUICtrlSetTip($Button_continue, "Continue Updating in Stages!")
	$Checkbox_clean = GUICtrlCreateCheckbox("", 215, 164, 15, 20, $BS_AUTO3STATE)
	GUICtrlSetTip($Checkbox_clean, "Enable cleanup only!")
	$Checkbox_stages = GUICtrlCreateCheckbox("Stages", 20, 197, 45, 21)
	GUICtrlSetFont($Checkbox_stages, 7, 400, 0, "Small Fonts")
	GUICtrlSetTip($Checkbox_stages, "Enable updating in stages!")
	$Label_blocks = GuiCtrlCreateLabel("Blocks", 70, 197, 45, 21, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_blocks, $COLOR_BLUE)
	GUICtrlSetColor($Label_blocks, $COLOR_WHITE)
	GUICtrlSetFont($Label_blocks, 6, 600, 0, "Small Fonts")
	$Input_blocks = GUICtrlCreateInput("", 115, 197, 32, 21)
	GUICtrlSetTip($Input_blocks, "Number of blocks to process!")
	$Updown_blocks = GUICtrlCreateUpdown($Input_blocks)
	GUICtrlSetTip($Updown_blocks, "Adjust the number of blocks!")
	GUICtrlSetLimit($Updown_blocks, 9, 1)
	$Label_games = GuiCtrlCreateLabel("Titles", 150, 197, 40, 21, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_games, $COLOR_BLUE)
	GUICtrlSetColor($Label_games, $COLOR_WHITE)
	GUICtrlSetFont($Label_games, 6, 600, 0, "Small Fonts")
	$Combo_games = GUICtrlCreateCombo("", 190, 197, 38, 21)
	GUICtrlSetTip($Combo_games, "Games in a block!")
	;
	$Group_folders = GUICtrlCreateGroup("Folders", 10, 236, 230, 47)
	$Button_backups = GuiCtrlCreateButton("Backups", 20, 253, 69, 20)
	GUICtrlSetFont($Button_backups, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_backups, "Open the Backups folder!")
	$Button_changes = GuiCtrlCreateButton("Update Changes", 94, 253, 106, 20)
	GUICtrlSetFont($Button_changes, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_changes, "Open the Update Changes folder!")
	$Button_program = GuiCtrlCreateButton("P", 205, 253, 25, 20, $BS_ICON)
	GUICtrlSetTip($Button_program, "Open the Program folder!")
	;
	$Group_windows = GUICtrlCreateGroup("Minimize Windows", 10, 291, 165, 42)
	$Checkbox_console = GUICtrlCreateCheckbox("DOS Console", 20, 308, 85, 18)
	GUICtrlSetTip($Checkbox_console, "Run the DOS Console minimized!")
	$Checkbox_window = GUICtrlCreateCheckbox("Update", 113, 308, 55, 18)
	GUICtrlSetTip($Checkbox_window, "Set the Update window to minimized!")
	;
	$Group_complete = GUICtrlCreateGroup("Done", 185, 291, 55, 42)
	$Label_done = GuiCtrlCreateLabel("0", 193, 307, 39, 19, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetFont($Label_done, 7, 600, 0, "Small Fonts")
	GUICtrlSetBkColor($Label_done, $COLOR_GREEN)
	GUICtrlSetColor($Label_done, $COLOR_WHITE)
	GUICtrlSetTip($Label_done, "0 remaining!")
	;
	;$Button_upnow = GuiCtrlCreateButton("UPDATE NOW", 10, 250, 120, 32)
	$Button_upnow = GuiCtrlCreateButton("UPDATE", 10, 345, 85, 32)
	GUICtrlSetFont($Button_upnow, 9, 600)
	GUICtrlSetTip($Button_upnow, "Update the Manifest for specified!")
	$Button_changed = GuiCtrlCreateButton("Log", 100, 345, 30, 32, $BS_ICON)
	GUICtrlSetTip($Button_changed, "View the Changed.txt file!")
	$Checkbox_replace = GUICtrlCreateCheckbox("Replace && Compare", 20, 379, 100, 18)
	GUICtrlSetFont($Checkbox_replace, 7, 400, 0, "Small Fonts")
	GUICtrlSetTip($Checkbox_replace, "Replace and Compare selected title in manifest!")
	;
	$Button_inf = GuiCtrlCreateButton("Info", 140, 345, 45, 50, $BS_ICON)
	GUICtrlSetTip($Button_inf, "Update Information!")
	;
	$Button_close = GuiCtrlCreateButton("EXIT", 192, 345, 48, 50, $BS_ICON)
	GUICtrlSetTip($Button_close, "Exit / Close / Quit the window!")
	;
	; SETTINGS
	GUICtrlSetImage($Button_program, $shell, $icoD, 0)
	GUICtrlSetImage($Button_changed, $shell, $icoT, 0)
	GUICtrlSetImage($Button_inf, $user, $icoI, 1)
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
		$installers = "galaxy|standalone|both"
		$installer = IniRead($inifle, "Updating", "installers", "")
		If $installer = "" Then
			$installer = "standalone"
			IniWrite($inifle, "Updating", "installers", $installer)
		EndIf
		GUICtrlSetData($Combo_install, $installers, $installer)
	EndIf
	;
	If $all = 1 Then
		GUICtrlSetState($Checkbox_replace, $GUI_DISABLE)
		If $script = "default" Then
			$skiphid = 4
			GUICtrlSetState($Checkbox_skip, $GUI_DISABLE)
			If $stagesfix = 4 Then GUICtrlSetState($Checkbox_stages, $GUI_DISABLE)
			;
			$resumeman = @ScriptDir & "\gog-titles.dat"
		Else
			$skiphid = IniRead($inifle, "Hidden Games", "skip", "")
			If $skiphid = "" Then
				$skiphid = 4
				IniWrite($inifle, "Hidden Games", "skip", $skiphid)
			EndIf
			GUICtrlSetState($Checkbox_skip, $skiphid)
			;
			$resumeman = @ScriptDir & "\gog-resume-manifest.dat"
		EndIf
		$stagefile = @ScriptDir & "\Stagelist.txt"
		;
		$blocks = IniRead($inifle, "Updating", "blocks", "")
		If $blocks = "" Then
			$blocks = 3
			IniWrite($inifle, "Updating", "blocks", $blocks)
		EndIf
		GUICtrlSetData($Input_blocks, $blocks)
		$block = IniRead($inifle, "Updating", "block", "")
		If $block = "" Then
			$block = 20
			IniWrite($inifle, "Updating", "block", $block)
		EndIf
		GUICtrlSetData($Combo_games, "1|2|5|10|15|20|25|30", $block)
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
		;
		GUICtrlSetState($Checkbox_stages, $GUI_DISABLE)
	EndIf
	;
	$found = $games
	$stage = IniRead($inifle, "Updating", "stage", "")
	If $stage = 1 Or $stage = 2 And $all = 1 Then
		GUICtrlSetState($Button_begin, $GUI_DISABLE)
		$stages = 1
		GUICtrlSetState($Checkbox_stages, $stages)
		;
		GUICtrlSetState($Checkbox_resume, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_new, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_tag, $GUI_DISABLE)
		GUICtrlSetState($Button_upnow, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_replace, $GUI_DISABLE)
		;
		If FileExists($stagefile) Then
			$remain = _FileCountLines($stagefile)
			If $stage = 1 Then
				$completed = $found
				$found = $found + $remain
			ElseIf $stage = 2 Then
				$completed = $found - $remain
			EndIf
			GUICtrlSetData($Label_done, $completed)
			GUICtrlSetTip($Label_done, $remain & " remaining!")
		EndIf
	Else
		GUICtrlSetState($Button_begin, $GUI_DISABLE)
		GUICtrlSetState($Button_continue, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_clean, $GUI_DISABLE)
		GUICtrlSetState($Input_blocks, $GUI_DISABLE)
		GUICtrlSetState($Updown_blocks, $GUI_DISABLE)
		GUICtrlSetState($Combo_games, $GUI_DISABLE)
	EndIf
	;
	$clean = 4
	$replace = 4
	$updating = ""
	;
	$window = $UpdateGUI


	GuiSetState()
	While 1
		$msg = GuiGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Button_close
			; Exit / Close / Quit the window
			$winpos = WinGetPos($UpdateGUI, "")
			$side = $winpos[0]
			If $side < 0 Then
				$side = 2
			ElseIf $side > @DesktopWidth - $wide Then
				$side = @DesktopWidth - $wide - 25
			EndIf
			IniWrite($inifle, "Update Window", "left", $side)
			$above = $winpos[1]
			If $above < 0 Then
				$above = 2
			ElseIf $above > @DesktopHeight - $high Then
				$above = @DesktopHeight - $high - 30
			EndIf
			IniWrite($inifle, "Update Window", "top", $above)
			;
			GUIDelete($UpdateGUI)
			ExitLoop
		Case $msg = $Button_upnow
			; Update the Manifest for specified
			CheckForConnection()
			If $connection = 1 Then
				GuiSetState(@SW_HIDE, $UpdateGUI)
				BackupManifestEtc()
				If $script = "default" Then
					$params = " -skipknown -updateonly"
				Else
					$params = " -skipknown -updateonly -resumemode resume -skiphidden -nolog -installers " & $installer
					If $resume = 4 Then
						$params = StringReplace($params, " resume", " noresume")
					ElseIf $resume = 2 Then
						$params = StringReplace($params, " resume", " onlyresume")
					EndIf
					If $skiphid = 4 Then $params = StringReplace($params, " -skiphidden", "")
					If $uplog = 1 Then $params = StringReplace($params, " -nolog", "")
				EndIf
				If $newgames = 4 Then $params = StringReplace($params, " -skipknown", "")
				If $tagged = 4 Then $params = StringReplace($params, " -updateonly", "")
				FileChangeDir(@ScriptDir)
				If $all = 1 Then
					$updating = 1
					_FileWriteLog($logfle, "Updated manifest for all games.")
					$pid = RunWait(@ComSpec & ' /c gogrepo.py update -os ' & $OS & ' -lang ' & $lang & $params & ' &&pause', @ScriptDir)
					_FileWriteLog($logfle, "Updated finished.")
				Else
					If $title <> "" Then
						$updating = 1
						GUISwitch($GOGRepoGUI)
						GUICtrlSetImage($Pic_cover, $blackjpg)
						GUICtrlSetFont($Label_cover, 8, 600)
						_FileWriteLog($logfle, "Updated manifest for - " & $title & ".")
						If $replace = 1 Then
							_FileWriteLog($logfle, "Updating using replace & compare.")
							GUICtrlSetData($Label_cover, "Replacing!")
							$res = 0
							$open = FileOpen($manifest, 0)
							$read = FileRead($open)
							FileClose($open)
							$titfile = $compfold & "\" & $title & ".txt"
							_FileCreate($titfile)
							; Read section of title in manifest.
							$segment = StringSplit($read, "'title': '" & $title & "'}", 1)
							If $segment[0] = 2 Then
								$segment = $segment[1]
								$segment = StringSplit($segment, "{'bg_url':", 1)
								If $segment[0] > 1 Then
									$segment = "{'bg_url':" & $segment[$segment[0]]
									$segment = $segment & "'title': '" & $title & "'},"
									;MsgBox(262192, "Game Segment", $games & @LF & $segment, $wait, $UpdateGUI)
									; Delete section from manifest.
									; Attempt to remove as a middle entry.
									$res = _ReplaceStringInFile($manifest, " " & $segment & @LF, "")
									If @error = 0 Then
										If $res = 0 Then
											; Failed, so attempt to remove as a last entry.
											$segment = StringTrimRight($segment, 1)
											$res = _ReplaceStringInFile($manifest, " " & $segment, "")
											If @error = 0 Then
												If $res = 0 Then
													; Failed, so attempt to remove as a first entry.
													$segment = $segment & ","
													$res = _ReplaceStringInFile($manifest, $segment & @LF, "")
													If @error = 0 Then
														If $res = 0 Then
															; Failed, so attempt to remove the only entry.
															$segment = StringTrimRight($segment, 1)
															$res = _ReplaceStringInFile($manifest, $segment, "")
															If $res > 0 Then
																; Success
																; Save to file for later comparison.
																FileWrite($titfile, $segment)
															EndIf
														Else
															; Success
															_ReplaceStringInFile($manifest, "[ {", "[{")
															; Save to file for later comparison.
															FileWrite($titfile, $segment)
														EndIf
													EndIf
												Else
													; Success
													_ReplaceStringInFile($manifest, "," & @LF & "]", "]")
													; Save to file for later comparison.
													FileWrite($titfile, $segment)
												EndIf
											EndIf
										Else
											; Success
											; Save to file for later comparison.
											FileWrite($titfile, $segment)
										EndIf
									Else
										MsgBox(262192, "Removal Error (1)", "Could not remove entry from manifest!", 0, $UpdateGUI)
									EndIf
								Else
									MsgBox(262192, "Removal Error", "Could not divide on url entry!", 0, $UpdateGUI)
								EndIf
							Else
								MsgBox(262192, "Removal Error", "Could not divide on title entry!", 0, $UpdateGUI)
							EndIf
						EndIf
						GUICtrlSetData($Label_cover, "Updating!")
						$pid = RunWait(@ComSpec & ' /c gogrepo.py update -os ' & $OS & ' -lang ' & $lang & $params & ' -id ' & $title & ' &&pause', @ScriptDir)
						If $replace = 1 Then
							If $res > 0 Then
								GUICtrlSetData($Label_action, "Comparing")
								GUICtrlSetFont($Label_num, 7, 600, 0, "Small Fonts")
								$open = FileOpen($manifest, 0)
								$read = FileRead($open)
								FileClose($open)
								$segment = StringSplit($read, "'title': '" & $title & "'}", 1)
								If $segment[0] = 2 Then
									$segment = $segment[1]
									$segment = StringSplit($segment, "{'bg_url':", 1)
									If $segment[0] > 1 Then
										$segment = "{'bg_url':" & $segment[$segment[0]]
										$segment = $segment & "'title': '" & $title & "'}"
										;MsgBox(262192, "Game Segment", $segment, $wait, $UpdateGUI)
										; Compare with original
										$res = _ReplaceStringInFile($titfile, $segment, "")
										If $res > 0 Then
											; No differences delete the $titfile.
											FileDelete($titfile)
											GUICtrlSetData($Label_num, "Success, no changes!")
										Else
											; Differences found, do an intensive check
											$newfile = $compfold & "\" & $title & "_new.txt"
											FileWrite($newfile, $segment)
											$res = FullComparisonCheck()
											If $res = "pass" Then
												GUICtrlSetData($Label_num, "No Changes!")
											ElseIf $res = "fail" Then
												; Differences found, add to the $changed file.
												GUICtrlSetData($Label_num, "Changes Detected!)")
												FileWriteLine($changed, $title)
											EndIf
										EndIf
										Sleep(1500)
									EndIf
								EndIf
								GUICtrlSetData($Label_action, "")
								GUICtrlSetData($Label_num, "")
								GUICtrlSetFont($Label_num, 9, 600)
							Else
								MsgBox(262192, "Removal Error (2)", "Could not remove entry from manifest!", 0, $UpdateGUI)
							EndIf
						EndIf
						GUICtrlSetData($Label_cover, "")
						GUICtrlSetFont($Label_cover, 8.5, 400, 0, "")
						GUISwitch($UpdateGUI)
						_FileWriteLog($logfle, "Updated finished.")
					Else
						MsgBox(262192, "Game Error", "Title is not selected!", $wait, $UpdateGUI)
						ContinueLoop
					EndIf
				EndIf
				;
				$open = FileOpen($manifest, 0)
				$read = FileRead($open)
				FileClose($open)
				If StringInStr($read, @CRLF) > 0 Then
					$res = _ReplaceStringInFile($manifest, @CRLF, @LF)
					MsgBox(262192, "Manifest Fix", $res & " carriage returns were found and replaced with line feeds.", 0, $GOGRepoGUI)
				EndIf
				;
				GUIDelete($UpdateGUI)
				ExitLoop
			EndIf
		Case $msg = $Button_program
			; Open the Program folder
			ShellExecute(@ScriptDir)
		Case $msg = $Button_inf
			; Update Information
			MsgBox(262208, "Update Information", _
				"When using the 'Update In Stages' option, additions to" & @LF & _
				"the main program window list don't appear until after" & @LF & _
				"the Update window has been closed, and the manifest" & @LF & _
				"then gets parsed." & @LF & @LF & _
				"Please ensure all desired options have been set before" & @LF & _
				"doing any Updating (i.e. OS, Language, Hidden, etc)," & @LF & _
				"especially when doing an UPDATE ALL and in stages." & @LF & @LF & _
				"The 'Update In Stages' process is started by clicking on" & @LF & _
				"the BEGIN button once, then followed with clicking on" & @LF & _
				"the CONTINUE button as many times as needed, which" & @LF & _
				"is governed by the number of games listed in your GOG" & @LF & _
				"library and the 'blocks' and 'Titles' settings values. The" & @LF & _
				"enabled state of the CONTINUE button will persist after" & @LF & _
				"window and program closure, until all games are done." & @LF & @LF & _
				"When the BEGIN button is disabled, it can be re-enabled" & @LF & _
				"at need, by toggling the 'Stages' checkbox." & @LF & @LF & _
				"CONTINUE button can be enabled for CLEANUP, which" & @LF & _
				"can check for and remove missed entries on the Stages" & @LF & _
				"list, that have already been added to the manifest. This" & @LF & _
				"might be due to a manual cancellation, crash, etc. The" & @LF & _
				"program does automatically attempt to do this as well." & @LF & _
				"CLEANUP only applies to Stage 1, for Stage 2 it is a very" & @LF & _
				"different FIXUP process instead, and is never automatic." & @LF & _
				"The FIXUP check attempts to restore missing entries to" & @LF & _
				"the manifest (after crash etc), and skips any Continue." & @LF & _
				"That said, the Continue process should be able to deal" & @LF & _
				"with missing entries anyway, just skipping removal." & @LF & @LF & _
				"If you need or desire to clear the setting for 'Update In" & @LF & _
				"Stages', hold down CTRL while unchecking 'Stages'. It" & @LF & _
				"will however mean CONTINUE is no longer available.", 0, $UpdateGUI)
		Case $msg = $Button_continue
			; Continue Updating in Stages
			CheckForConnection()
			If $connection = 1 Then
				$cleaned = 0
				$cleanup = ""
				If $stage = 1 Then
					$updating = 1
					If FileExists($manifest) Then
						GUICtrlSetState($Button_continue, $GUI_DISABLE)
						If $script = "fork" Then
							GUICtrlSetState($Checkbox_skip, $GUI_DISABLE)
							GUICtrlSetState($Checkbox_uplog, $GUI_DISABLE)
							GUICtrlSetState($Combo_install, $GUI_DISABLE)
						EndIf
						GUICtrlSetState($Checkbox_clean, $GUI_DISABLE)
						GUICtrlSetState($Checkbox_stages, $GUI_DISABLE)
						GUICtrlSetState($Updown_blocks, $GUI_DISABLE)
						GUICtrlSetState($Combo_games, $GUI_DISABLE)
						GUICtrlSetState($Button_backups, $GUI_DISABLE)
						GUICtrlSetState($Button_changes, $GUI_DISABLE)
						GUICtrlSetState($Button_program, $GUI_DISABLE)
						GUICtrlSetState($Button_changed, $GUI_DISABLE)
						GUICtrlSetState($Button_inf, $GUI_DISABLE)
						GUICtrlSetState($Button_close, $GUI_DISABLE)
						GuiSetState(@SW_MINIMIZE, $UpdateGUI)
						BackupManifestEtc()
						GUISwitch($GOGRepoGUI)
						GUICtrlSetImage($Pic_cover, $blackjpg)
						GUICtrlSetFont($Label_cover, 8, 600)
						GUICtrlSetData($Label_cover, "Checking!")
						FileChangeDir(@ScriptDir)
						$open = FileOpen($manifest, 0)
						$read = FileRead($open)
						FileClose($open)
						If FileExists($stagefile) Then
							$err = 0
							If $clean <> 2 Then
								; NOTE - The following removal only works if the BEGIN process had been cancelled or interrupted.
								; Remove any titles from list file that now exist in the manifest
								_FileWriteLog($logfle, "Removing missed updated titles.")
								$res = _FileReadToArray($stagefile, $array, 1)
								$err = @error
								If $res = 1 Then
									$blocks = IniRead($inifle, "Updating", "loops", "")
									$block = IniRead($inifle, "Updating", "games", "")
									$loop = 1
									$start = 1
									GUICtrlSetData($Label_action, "Checking")
									While 1
										GUICtrlSetData($Label_cover, $loop & " of " & $blocks)
										$ids = ""
										$id = 0
										For $a = $start To $array[0]
											$title = $array[$a]
											If $title <> "" Then
												$id = $id + 1
												$entry = StringReplace($title, "title=", "")
												$entry = "'title': '" & $entry & "'}"
												If StringInStr($read, $entry) > 0 Then
													$res = _ReplaceStringInFile($stagefile, $title & @CRLF, "")
													If $res > 0 Then $cleaned = $cleaned + 1
												EndIf
												If $a = $array[0] Then
													$cleanup = 1
													ExitLoop
												EndIf
												If $id = $block Then ExitLoop
											EndIf
										Next
										If $loop = $blocks Then
											ExitLoop
										Else
											$loop = $loop + 1
											$start = $start + $block
										EndIf
										If GUICtrlRead($Checkbox_window) = $GUI_CHECKED Then
											GUICtrlSetState($Checkbox_window, $GUI_UNCHECKED)
											GuiSetState(@SW_MINIMIZE, $UpdateGUI)
										EndIf
									WEnd
									GUICtrlSetData($Label_cover, "Cleanup = " & $cleaned)
									Sleep(1500)
								Else
									If $err = 2 Then
										$lines = _FileCountLines($stagefile)
										If $lines = 0 Then
											$cleanup = 1
										Else
											$err = 5
										EndIf
									EndIf
									If $err <> 2 Then MsgBox(262192, "Read Error", "Could not get titles!", 0, $UpdateGUI)
								EndIf
							EndIf
							If $clean <> 1 And $err = 0 Then
								GUICtrlSetData($Label_action, "")
								GUICtrlSetData($Label_cover, "Updating!")
								; Continue and Update (add) the next block(s) of titles.
								$blocks = IniRead($inifle, "Updating", "blocks", "")
								$block = IniRead($inifle, "Updating", "block", "")
								IniWrite($inifle, "Updating", "loops", $blocks)
								IniWrite($inifle, "Updating", "games", $block)
								If $script = "default" Then
									$params = ""
								Else
									$params = " -resumemode noresume -skiphidden -nolog -installers " & $installer
									If $skiphid = 4 Then $params = StringReplace($params, " -skiphidden", "")
									If $uplog = 1 Then $params = StringReplace($params, " -nolog", "")
								EndIf
								$res = _FileReadToArray($stagefile, $array, 1)
								$err = @error
								If $res = 1 Then
									$loop = 1
									$start = 1
									While 1
										_FileWriteLog($logfle, "Adding next block of games.")
										$ids = ""
										$id = 0
										For $a = $start To $array[0]
											$title = $array[$a]
											$title = StringReplace($title, "title=", "")
											If $title <> "" Then
												$id = $id + 1
												If $ids = "" Then
													$ids = $title
												Else
													$ids = $ids & " " & $title
												EndIf
												If $a = $array[0] Then
													$cleanup = 1
													ExitLoop
												EndIf
												If $id = $block Then ExitLoop
											EndIf
										Next
										$message = "Block " & $loop & " of " & $blocks & " = " & $id & " games"
										GUICtrlSetData($Label_cover, $message)
										GUICtrlSetData($Label_action, "Updating")
										_FileWriteLog($logfle, $ids)
										If $ids <> "" Then
											If $script = "default" Then
												$ids = StringSplit($ids, " ", 1)
												For $i = 1 To $ids[0]
													$title = $ids[$i]
													If $title <> "" Then
														GUICtrlSetData($Label_num, $i)
														If GUICtrlRead($Checkbox_console) = $GUI_CHECKED Then
															$flag = @SW_MINIMIZE
														Else
															$flag = @SW_SHOW
														EndIf
														$pid = RunWait(@ComSpec & ' /c gogrepo.py update -os ' & $OS & ' -lang ' & $lang & $params & ' -id ' & $title, @ScriptDir, $flag)
														If GUICtrlRead($Checkbox_window) = $GUI_CHECKED Then
															GUICtrlSetState($Checkbox_window, $GUI_UNCHECKED)
															GuiSetState(@SW_MINIMIZE, $UpdateGUI)
														EndIf
													EndIf
												Next
											Else
												If GUICtrlRead($Checkbox_console) = $GUI_CHECKED Then
													$flag = @SW_MINIMIZE
												Else
													$flag = @SW_SHOW
												EndIf
												$pid = RunWait(@ComSpec & ' /c gogrepo.py update -os ' & $OS & ' -lang ' & $lang & $params & ' -ids ' & $ids, @ScriptDir, $flag)
												If GUICtrlRead($Checkbox_window) = $GUI_CHECKED Then
													GUICtrlSetState($Checkbox_window, $GUI_UNCHECKED)
													GuiSetState(@SW_MINIMIZE, $UpdateGUI)
												EndIf
											EndIf
										Else
											$cleanup = 1
											ExitLoop
										EndIf
										If $loop = $blocks Then
											ExitLoop
										Else
											$loop = $loop + 1
											$start = $start + $block
										EndIf
									WEnd
								Else
									If $err = 2 Then
										$lines = _FileCountLines($stagefile)
										If $lines = 0 Then
											$cleanup = 1
										Else
											$err = 5
										EndIf
									EndIf
									If $err <> 2 Then MsgBox(262192, "Read Error", "Could not get titles!", 0, $UpdateGUI)
								EndIf
								If $err = 0 Then
									GUICtrlSetData($Label_action, "")
									GUICtrlSetData($Label_cover, "Checking!")
									GUICtrlSetData($Label_num, "")
									Sleep(1000)
									; Remove any titles from list file that now exist in the manifest
									_FileWriteLog($logfle, "Removing updated titles.")
									$open = FileOpen($manifest, 0)
									$read = FileRead($open)
									FileClose($open)
									$blocks = IniRead($inifle, "Updating", "loops", "")
									$block = IniRead($inifle, "Updating", "games", "")
									$res = _FileReadToArray($stagefile, $array, 1)
									If $res = 1 Then
										$cleaned = 0
										$loop = 1
										$start = 1
										GUICtrlSetData($Label_action, "Checking")
										While 1
											GUICtrlSetData($Label_cover, $loop & " of " & $blocks)
											$ids = ""
											$id = 0
											For $a = $start To $array[0]
												$title = $array[$a]
												If $title <> "" Then
													$id = $id + 1
													$entry = StringReplace($title, "title=", "")
													$entry = "'title': '" & $entry & "'}"
													If StringInStr($read, $entry) > 0 Then
														$res = _ReplaceStringInFile($stagefile, $title & @CRLF, "")
														If $res > 0 Then $cleaned = $cleaned + 1
													EndIf
													If $a = $array[0] Then
														$cleanup = 1
														ExitLoop
													EndIf
													If $id = $block Then ExitLoop
												EndIf
											Next
											If $loop = $blocks Then
												ExitLoop
											Else
												$loop = $loop + 1
												$start = $start + $block
											EndIf
											If GUICtrlRead($Checkbox_window) = $GUI_CHECKED Then
												GUICtrlSetState($Checkbox_window, $GUI_UNCHECKED)
												GuiSetState(@SW_MINIMIZE, $UpdateGUI)
											EndIf
										WEnd
									Else
										MsgBox(262192, "Read Error", "Could not get titles!", 0, $UpdateGUI)
									EndIf
									GUICtrlSetData($Label_cover, "Cleanup = " & $cleaned)
									Sleep(1500)
									_FileWriteLog($logfle, "Next Part of Stage 1 completed.")
								EndIf
							EndIf
							$blocks = IniRead($inifle, "Updating", "blocks", "")
							$block = IniRead($inifle, "Updating", "block", "")
							If FileExists($stagefile) Then
								$remain = _FileCountLines($stagefile)
								$completed = $found - $remain
								GUICtrlSetData($Label_done, $completed)
								GUICtrlSetTip($Label_done, $remain & " remaining!")
							EndIf
						Else
							MsgBox(262192, "Update Error", "Could not find title list file!", 0, $UpdateGUI)
						EndIf
						If $cleanup = 1 Then
							$stage = ""
							IniWrite($inifle, "Updating", "stage", $stage)
							IniWrite($inifle, "Updating", "loops", "")
							IniWrite($inifle, "Updating", "games", "")
							GUICtrlSetState($Checkbox_stages, $GUI_UNCHECKED)
							MsgBox(262208, "Result", "'Update In Stages' appears to be complete!", 0, $UpdateGUI)
						EndIf
						;
						$open = FileOpen($manifest, 0)
						$read = FileRead($open)
						FileClose($open)
						If StringInStr($read, @CRLF) > 0 Then
							$res = _ReplaceStringInFile($manifest, @CRLF, @LF)
							MsgBox(262192, "Manifest Fix", $res & " carriage returns were found and replaced with line feeds.", 0, $GOGRepoGUI)
						EndIf
						;
						GUICtrlSetData($Label_action, "")
						GUICtrlSetData($Label_num, "")
						GUICtrlSetData($Label_cover, "")
						GUICtrlSetFont($Label_cover, 8.5, 400, 0, "")
						GUISwitch($UpdateGUI)
						If $stage <> "" Then GUICtrlSetState($Button_continue, $GUI_ENABLE)
						If $script = "fork" Then
							GUICtrlSetState($Checkbox_skip, $GUI_ENABLE)
							GUICtrlSetState($Checkbox_uplog, $GUI_ENABLE)
							GUICtrlSetState($Combo_install, $GUI_ENABLE)
						EndIf
						GUICtrlSetState($Checkbox_clean, $GUI_ENABLE)
						GUICtrlSetState($Checkbox_stages, $GUI_ENABLE)
						GUICtrlSetState($Updown_blocks, $GUI_ENABLE)
						GUICtrlSetState($Combo_games, $GUI_ENABLE)
						GUICtrlSetState($Button_backups, $GUI_ENABLE)
						GUICtrlSetState($Button_changes, $GUI_ENABLE)
						GUICtrlSetState($Button_program, $GUI_ENABLE)
						GUICtrlSetState($Button_changed, $GUI_ENABLE)
						GUICtrlSetState($Button_inf, $GUI_ENABLE)
						GUICtrlSetState($Button_close, $GUI_ENABLE)
						GuiSetState(@SW_RESTORE, $GOGRepoGUI)
						GuiSetState(@SW_RESTORE, $UpdateGUI)
					Else
						MsgBox(262192, "Continue Error", "Manifest file does not exist!", 0, $UpdateGUI)
					EndIf
				ElseIf $stage = 2 Then
					Local $boob
					$updating = 1
					If FileExists($manifest) Then
						GUICtrlSetState($Button_continue, $GUI_DISABLE)
						If $script = "fork" Then
							GUICtrlSetState($Checkbox_skip, $GUI_DISABLE)
							GUICtrlSetState($Checkbox_uplog, $GUI_DISABLE)
							GUICtrlSetState($Combo_install, $GUI_DISABLE)
						EndIf
						GUICtrlSetState($Checkbox_clean, $GUI_DISABLE)
						GUICtrlSetState($Checkbox_stages, $GUI_DISABLE)
						GUICtrlSetState($Updown_blocks, $GUI_DISABLE)
						GUICtrlSetState($Combo_games, $GUI_DISABLE)
						GUICtrlSetState($Button_backups, $GUI_DISABLE)
						GUICtrlSetState($Button_changes, $GUI_DISABLE)
						GUICtrlSetState($Button_program, $GUI_DISABLE)
						GUICtrlSetState($Button_changed, $GUI_DISABLE)
						GUICtrlSetState($Button_inf, $GUI_DISABLE)
						GUICtrlSetState($Button_close, $GUI_DISABLE)
						GuiSetState(@SW_MINIMIZE, $UpdateGUI)
						BackupManifestEtc()
						GUISwitch($GOGRepoGUI)
						GUICtrlSetImage($Pic_cover, $blackjpg)
						GUICtrlSetFont($Label_cover, 8, 600)
						GUICtrlSetData($Label_cover, "Checking!")
						GUICtrlSetData($Input_name, "")
						GUICtrlSetData($Input_title, "")
						GUICtrlSetData($Input_OS, "")
						GUICtrlSetData($Input_extra, "")
						FileChangeDir(@ScriptDir)
						$open = FileOpen($manifest, 0)
						$read = FileRead($open)
						FileClose($open)
						If FileExists($stagefile) Then
							$err = 0
							$errors = 0
							$names = ""
							If $clean = 1 Then
								; NOTE - Unlike with Stage 1, this is not an auto check, so must be selected and nothing else occurs.
								; The following restore only works if the BEGIN process had been cancelled or interrupted.
								; Restore any titles on list file that now don't exist in the manifest
								_FileWriteLog($logfle, "Restoring missing titles to manifest.")
								$res = _FileReadToArray($stagefile, $array, 1)
								$err = @error
								If $res = 1 Then
									$blocks = IniRead($inifle, "Updating", "loops", "")
									$block = IniRead($inifle, "Updating", "games", "")
									$loop = 1
									$start = 1
									GUICtrlSetData($Label_action, "Checking")
									While 1
										GUICtrlSetData($Label_cover, $loop & " of " & $blocks)
										$ids = ""
										$id = 0
										For $a = $start To $array[0]
											$title = $array[$a]
											If $title <> "" Then
												$id = $id + 1
												$entry = StringReplace($title, "title=", "")
												$titfile = $compfold & "\" & $entry & ".txt"
												$entry = "'title': '" & $entry & "'}"
												If StringInStr($read, $entry) < 1 Then
													; Expected game title is missing
													If FileExists($titfile) Then
														; Restore file found
														$segment = FileRead($titfile)
														If $segment <> "" Then
															; Restore file contains data, fix manifest ending for restoring data at end
															$res = _ReplaceStringInFile($manifest, "}]" & @LF, "}," & @LF)
															If $res > 0 Then $cleaned = $cleaned + 1
															; Add restore data with fixed ending
															$segment = " " & $segment & "]" & @LF
															FileWrite($manifest, $segment)
														EndIf
													EndIf
												EndIf
												If $a = $array[0] Then
													$cleanup = 1
													ExitLoop
												EndIf
												If $id = $block Then ExitLoop
											EndIf
										Next
										If $loop = $blocks Then
											ExitLoop
										Else
											$loop = $loop + 1
											$start = $start + $block
										EndIf
										If GUICtrlRead($Checkbox_window) = $GUI_CHECKED Then
											GUICtrlSetState($Checkbox_window, $GUI_UNCHECKED)
											GuiSetState(@SW_MINIMIZE, $UpdateGUI)
										EndIf
									WEnd
									GUICtrlSetData($Label_cover, "Fixup = " & $cleaned)
									Sleep(1500)
								Else
									If $err = 2 Then
										$lines = _FileCountLines($stagefile)
										If $lines = 0 Then
											$cleanup = 1
										Else
											$err = 5
										EndIf
									EndIf
									If $err <> 2 Then MsgBox(262192, "Read Error", "Could not get titles!", 0, $UpdateGUI)
								EndIf
							EndIf
							If $clean <> 1 And $err = 0 Then
								; Get number line for games in manifest.
								GUICtrlSetData($Label_action, "Checking")
								$res = _FileReadToArray($manifest, $array)
								If $res = 1 Then
									$games = $array[1]
									$id = StringReplace($games, "#", "")
									$id = StringReplace($id, "games", "")
									$id = StringStripWS($id, 7)
									If StringIsDigit($id) Then
										GUICtrlSetData($Label_cover, $id & " Game Titles remaining!")
										Sleep(1500)
									EndIf
								Else
									$games = ""
								EndIf
								; Continue and Update (add) the next block(s) of titles.GUICtrlSetData($Label_cover, $loop & " of " & $blocks & " blocks")
								$blocks = IniRead($inifle, "Updating", "blocks", "")
								$block = IniRead($inifle, "Updating", "block", "")
								IniWrite($inifle, "Updating", "loops", $blocks)
								IniWrite($inifle, "Updating", "games", $block)
								$sum = $blocks * $block
								GUICtrlSetFont($Label_num, 7, 600, 0, "Small Fonts")
								GUICtrlSetData($Label_num, $sum & " Game Titles to process!")
								; Read titles list into an array.
								$res = _FileReadToArray($stagefile, $array, 1)
								$err = @error
								If $res = 1 Then
									_FileWriteLog($logfle, "Processing next block of games.")
									$res = 0
									If $script = "default" Then
										$params = ""
									Else
										$params = " -resumemode noresume -skiphidden -nolog -installers " & $installer
										If $skiphid = 4 Then $params = StringReplace($params, " -skiphidden", "")
										If $uplog = 1 Then $params = StringReplace($params, " -nolog", "")
									EndIf
									$loop = 1
									$start = 1
									While 1
										$ids = ""
										$id = 0
										For $a = $start To $array[0]
											$title = $array[$a]
											$title = StringReplace($title, "title=", "")
											If $title <> "" Then
												$titfile = $compfold & "\" & $title & ".txt"
												_FileCreate($titfile)
												$res = 0
												$erred = ""
												$pass = ""
												$id = $id + 1
												GUICtrlSetData($Label_cover, "Checking To Remove = " & $id)
												; Read section of title in manifest.
												$segment = StringSplit($read, "'title': '" & $title & "'}", 1)
												If $segment[0] = 2 Then
													$segment = $segment[1]
													$segment = StringSplit($segment, "{'bg_url':", 1)
													If $segment[0] > 1 Then
														$segment = "{'bg_url':" & $segment[$segment[0]]
														$segment = $segment & "'title': '" & $title & "'},"
														;MsgBox(262192, "Game Segment", $games & @LF & $segment, $wait, $UpdateGUI)
														; Delete section from manifest.
														; Attempt to remove as a middle entry.
														$res = _ReplaceStringInFile($manifest, " " & $segment & @LF, "")
														$erred = @error
														If $erred = 0 Then
															If $res = 0 Then
																; Failed, so attempt to remove as a last entry.
																$segment = StringTrimRight($segment, 1)
																$res = _ReplaceStringInFile($manifest, " " & $segment, "")
																$erred = @error
																If $erred = 0 Then
																	If $res = 0 Then
																		; Failed, so attempt to remove as a first entry.
																		$segment = $segment & ","
																		$res = _ReplaceStringInFile($manifest, $segment & @LF, "")
																		$erred = @error
																		If $erred = 0 Then
																			If $res = 0 Then
																				; Failed, so attempt to remove the only entry.
																				$segment = StringTrimRight($segment, 1)
																				$res = _ReplaceStringInFile($manifest, $segment, "")
																				$erred = @error
																				If $res > 0 Then
																					; Success
																					; Save to file for later comparison.
																					FileWrite($titfile, $segment)
																				EndIf
																			Else
																				; Success
																				_ReplaceStringInFile($manifest, "[ {", "[{")
																				; Save to file for later comparison.
																				FileWrite($titfile, $segment)
																			EndIf
																		EndIf
																	Else
																		; Success
																		_ReplaceStringInFile($manifest, "," & @LF & "]", "]")
																		; Save to file for later comparison.
																		FileWrite($titfile, $segment)
																	EndIf
																EndIf
															Else
																; Success
																; Save to file for later comparison.
																FileWrite($titfile, $segment)
															EndIf
														Else
															_FileWriteLog($logfle, "(REMOVAL ERROR) - " & $title)
															$pass = 1
															$names &= $names & @LF & $title
															$errors = $errors + 1
															MsgBox(262192, "Removal Error (1)", "Could not remove entry from manifest!" & @LF _
																& "Error = " & $erred & @LF & $title, 10, $UpdateGUI)
														EndIf
													Else
														MsgBox(262192, "Removal Error", "Could not divide on url entry!", 0, $UpdateGUI)
													EndIf
												Else
													MsgBox(262192, "Removal Error", "Could not divide on title entry!", 0, $UpdateGUI)
												EndIf
												If $res > 0 And $games <> "" Then
													GUICtrlSetData($Label_cover, "Removed = " & $a & " of " & $sum)
													Sleep(500)
													; Update number line for games in manifest.
													$number = StringSplit($games, " ", 1)
													If $number[0] > 1 Then
														$number = $number[2]
														If StringIsDigit($number) Then
															$number = $number - 1
															$number = "# " & $number & " games"
															_ReplaceStringInFile($manifest, $games, $number)
															$games = $number
														EndIf
													EndIf
												ElseIf $pass = "" Then
													_FileWriteLog($logfle, "(REMOVAL ERROR) - " & $title)
													$names &= $names & @LF & $title
													$errors = $errors + 1
													MsgBox(262192, "Removal Error (2)", "Could not remove entry from manifest!" & @LF _
														& "Error = " & $erred & @LF & $title, 10, $UpdateGUI)
												EndIf
												;
												If $ids = "" Then
													$ids = $title
												Else
													$ids = $ids & " " & $title
												EndIf
												If $a = $array[0] Then
													$cleanup = 1
													ExitLoop
												EndIf
												If $id = $block Then ExitLoop
											EndIf
											If GUICtrlRead($Checkbox_window) = $GUI_CHECKED Then
												GUICtrlSetState($Checkbox_window, $GUI_UNCHECKED)
												GuiSetState(@SW_MINIMIZE, $UpdateGUI)
											EndIf
										Next
										GUICtrlSetData($Label_num, "")
										GUICtrlSetFont($Label_num, 9, 600)
										GUICtrlSetData($Label_cover, "Updating!")
										Sleep(750)
										GUICtrlSetData($Label_action, "Updating")
										$message = "Block " & $loop & " of " & $blocks & " = " & $id & " games"
										GUICtrlSetData($Label_cover, $message)
										_FileWriteLog($logfle, $ids)
										If $ids <> "" Then
											If $script = "default" Then
												$ids = StringSplit($ids, " ", 1)
												For $i = 1 To $ids[0]
													$title = $ids[$i]
													If $title <> "" Then
														GUICtrlSetData($Label_num, $i)
														If GUICtrlRead($Checkbox_console) = $GUI_CHECKED Then
															$flag = @SW_MINIMIZE
														Else
															$flag = @SW_SHOW
														EndIf
														$pid = RunWait(@ComSpec & ' /c gogrepo.py update -os ' & $OS & ' -lang ' & $lang & $params & ' -id ' & $title, @ScriptDir, $flag)
														If GUICtrlRead($Checkbox_window) = $GUI_CHECKED Then
															GUICtrlSetState($Checkbox_window, $GUI_UNCHECKED)
															GuiSetState(@SW_MINIMIZE, $UpdateGUI)
														EndIf
													EndIf
												Next
											Else
												If GUICtrlRead($Checkbox_console) = $GUI_CHECKED Then
													$flag = @SW_MINIMIZE
												Else
													$flag = @SW_SHOW
												EndIf
												$pid = RunWait(@ComSpec & ' /c gogrepo.py update -os ' & $OS & ' -lang ' & $lang & $params & ' -ids ' & $ids, @ScriptDir, $flag)
												If GUICtrlRead($Checkbox_window) = $GUI_CHECKED Then
													GUICtrlSetState($Checkbox_window, $GUI_UNCHECKED)
													GuiSetState(@SW_MINIMIZE, $UpdateGUI)
												EndIf
											EndIf
										Else
											$cleanup = 1
											ExitLoop
										EndIf
										If $loop = $blocks Then
											ExitLoop
										Else
											$loop = $loop + 1
											$start = $start + $block
										EndIf
									WEnd
									GUICtrlSetData($Label_action, "")
									GUICtrlSetData($Label_num, "")
									GUICtrlSetFont($Label_num, 7, 600, 0, "Small Fonts")
									GUICtrlSetData($Label_cover, "Checking!")
									Sleep(500)
									; Remove any titles from list file that now exist in the manifest
									_FileWriteLog($logfle, "Removing updated titles.")
									$open = FileOpen($manifest, 0)
									$read = FileRead($open)
									FileClose($open)
									$res = _FileReadToArray($stagefile, $array, 1)
									If $res = 1 Then
										$blocks = IniRead($inifle, "Updating", "loops", "")
										$block = IniRead($inifle, "Updating", "games", "")
										$cleaned = 0
										$loop = 1
										$start = 1
										GUICtrlSetData($Label_action, "Checking")
										While 1
											GUICtrlSetData($Label_cover, $loop & " of " & $blocks & " blocks")
											Sleep(500)
											$ids = ""
											$id = 0
											For $a = $start To $array[0]
												$title = $array[$a]
												If $title <> "" Then
													$id = $id + 1
													$entry = StringReplace($title, "title=", "")
													$entry = "'title': '" & $entry & "'}"
													If StringInStr($read, $entry) > 0 Then
														$res = _ReplaceStringInFile($stagefile, $title & @CRLF, "")
														If $res > 0 Then $cleaned = $cleaned + 1
														;
														; Read section of title in manifest, for comparison.
														GUICtrlSetData($Label_num, "Comparing = " & $a & " of " & $sum)
														Sleep(500)
														$title = StringReplace($title, "title=", "")
														$titfile = $compfold & "\" & $title & ".txt"
														If FileExists($titfile) Then
															$segment = StringSplit($read, "'title': '" & $title & "'}", 1)
															If $segment[0] = 2 Then
																$segment = $segment[1]
																$segment = StringSplit($segment, "{'bg_url':", 1)
																If $segment[0] > 1 Then
																	$segment = "{'bg_url':" & $segment[$segment[0]]
																	$segment = $segment & "'title': '" & $title & "'}"
																	;MsgBox(262192, "Game Segment", $games & @LF & $segment, $wait, $UpdateGUI)
																	; Compare with original
																	$res = _ReplaceStringInFile($titfile, $segment, "")
																	If $res > 0 Then
																		; No differences delete the $titfile.
																		FileDelete($titfile)
																		GUICtrlSetData($Label_num, "No Changes (" & $a & ")")
																	Else
																		; Differences found, do an intensive check
																		$newfile = $compfold & "\" & $title & "_new.txt"
																		FileWrite($newfile, $segment)
																		$res = FullComparisonCheck()
																		If $res = "pass" Then
																			GUICtrlSetData($Label_num, "No Changes (" & $a & ")")
																		ElseIf $res = "fail" Then
																			; Differences found, add to the $changed file.
																			GUICtrlSetData($Label_num, "Changes Detected (" & $a & ")")
																			FileWriteLine($changed, $title)
																		EndIf
																	EndIf
																	Sleep(1500)
																EndIf
															EndIf
														EndIf
													Else
														; Entry not found in manifest - restore original
														GUICtrlSetData($Label_num, "Restoring = " & $a & " of " & $sum)
														Sleep(500)
														$res = 0
														$title = StringReplace($title, "title=", "")
														_FileWriteLog($logfle, "(RESTORING ORIGINAL) " & $title)
														_FileReadToArray($manifest, $lines, 1)
														$line = $lines[0]
														$segment = $lines[$line]
														If StringInStr($segment, "'title':") < 1 Then $segment = ""
														While $segment = ""
															$line = $line - 1
															$segment = $lines[$line]
															If StringInStr($segment, "'title':") > 0 Then
																ExitLoop
															Else
																$segment = ""
															EndIf
															If ($lines[0] - $line > 3) Or ($line < 1) Then ExitLoop
														WEnd
														If $segment = "" Then
															_FileWriteLog($logfle, "(RESTORE FAILED) " & $title)
															$boob = 1
														Else
															If StringRight($segment, 2) = "}]" Then
																$titfile = $compfold & "\" & $title & ".txt"
																If FileExists($titfile) Then
																	$open = FileOpen($titfile, 0)
																	$read = FileRead($open)
																	FileClose($open)
																	If $read = "" Then
																		_FileWriteLog($logfle, "(RESTORE FAILED) " & $title)
																		$boob = 2
																	Else
																		If StringInStr($read, @CRLF) > 0 Then
																			$read = StringReplace($read, @CRLF, @LF)
																		EndIf
																		If StringInStr($read, @CR) > 0 Then
																			$read = StringReplace($read, @CR, @LF)
																		EndIf
																		$read =  " " & $read
																		If StringRight($read, 1) = "," Then
																			$read = StringTrimRight($read, 1) & "]"
																		Else
																			$read = $read & "]"
																		EndIf
																		$read = StringReplace($segment, "}]", "}," & @LF & $read)
																		$res = _ReplaceStringInFile($manifest, $segment, $read)
																		If $res < 1 Then
																			_FileWriteLog($logfle, "(RESTORE FAILED) " & $title)
																			$boob = 3
																		Else
																			GUICtrlSetData($Label_num, "Restored = " & $a & " of " & $sum)
																			FileDelete($titfile)
																			$number = StringSplit($games, " ", 1)
																			If $number[0] > 1 Then
																				$number = $number[2]
																				If StringIsDigit($number) Then
																					$number = $number + 1
																					$number = "# " & $number & " games"
																					_ReplaceStringInFile($manifest, $games, $number)
																					$games = $number
																				EndIf
																			EndIf
																			Sleep(500)
																		EndIf
																	EndIf
																Else
																	_FileWriteLog($logfle, "(RESTORE FAILED) " & $title)
																	$boob = 4
																EndIf
															Else
																_FileWriteLog($logfle, "(RESTORE FAILED) " & $title)
																$boob = 5
															EndIf
														EndIf
														If $res < 1 Then
															MsgBox(262192, "Restore Error - " & $boob, "A manifest entry could not be replaced, " _
																& "so an attempt was made to restore the original, but that failed." _
																& @LF & @LF & $title, 10, $UpdateGUI)
														EndIf
													EndIf
													If $a = $array[0] Then
														$cleanup = 1
														ExitLoop
													EndIf
													If $id = $block Then ExitLoop
												EndIf
												If GUICtrlRead($Checkbox_window) = $GUI_CHECKED Then
													GUICtrlSetState($Checkbox_window, $GUI_UNCHECKED)
													GuiSetState(@SW_MINIMIZE, $UpdateGUI)
												EndIf
											Next
											If $loop = $blocks Then
												ExitLoop
											Else
												$loop = $loop + 1
												$start = $start + $block
											EndIf
										WEnd
									Else
										MsgBox(262192, "Read Error", "Could not get titles!", 0, $UpdateGUI)
									EndIf
									GUICtrlSetData($Label_num, "")
									GUICtrlSetFont($Label_num, 9, 600)
									GUICtrlSetData($Label_cover, "Cleanup = " & $cleaned)
									Sleep(1500)
									_FileWriteLog($logfle, "Next part of Stage 2 completed.")
								Else
									If $err = 2 Then
										$lines = _FileCountLines($stagefile)
										If $lines = 0 Then
											$cleanup = 1
										Else
											$err = 5
										EndIf
									EndIf
									If $err <> 2 Then MsgBox(262192, "Read Error", "Could not get titles!", 0, $UpdateGUI)
								EndIf
								If $cleanup = 1 Then
									$stage = ""
									IniWrite($inifle, "Updating", "stage", $stage)
									IniWrite($inifle, "Updating", "loops", "")
									IniWrite($inifle, "Updating", "games", "")
									GUICtrlSetState($Checkbox_stages, $GUI_UNCHECKED)
									MsgBox(262208, "Result", "'Update In Stages' appears to be complete!", 0, $UpdateGUI)
								EndIf
								$blocks = IniRead($inifle, "Updating", "blocks", "")
								$block = IniRead($inifle, "Updating", "block", "")
								If FileExists($stagefile) Then
									$remain = _FileCountLines($stagefile)
									$completed = $found - $remain
									GUICtrlSetData($Label_done, $completed)
									GUICtrlSetTip($Label_done, $remain & " remaining!")
								EndIf
							Else
								MsgBox(262192, "List Error", "Could not find any titles!", 0, $UpdateGUI)
							EndIf
							If $errors > 0 Then
								MsgBox(262192, "Removal Error(s)", "One or more titles could not be removed from the manifest!" & @LF _
									& $names, 0, $UpdateGUI)
							EndIf
						Else
							MsgBox(262192, "Read Error", "Could not get titles!", 0, $UpdateGUI)
						EndIf
						;
						$open = FileOpen($manifest, 0)
						$read = FileRead($open)
						FileClose($open)
						If StringInStr($read, @CRLF) > 0 Then
							$res = _ReplaceStringInFile($manifest, @CRLF, @LF)
							MsgBox(262192, "Manifest Fix", $res & " carriage returns were found and replaced with line feeds.", 0, $GOGRepoGUI)
						EndIf
						;
						GUICtrlSetData($Label_action, "")
						GUICtrlSetData($Label_num, "")
						GUICtrlSetData($Label_cover, "")
						GUICtrlSetFont($Label_cover, 8.5, 400, 0, "")
						GUISwitch($UpdateGUI)
						If $stage <> "" Then GUICtrlSetState($Button_continue, $GUI_ENABLE)
						If $script = "fork" Then
							GUICtrlSetState($Checkbox_skip, $GUI_ENABLE)
							GUICtrlSetState($Checkbox_uplog, $GUI_ENABLE)
							GUICtrlSetState($Combo_install, $GUI_ENABLE)
						EndIf
						GUICtrlSetState($Checkbox_clean, $GUI_ENABLE)
						GUICtrlSetState($Checkbox_stages, $GUI_ENABLE)
						GUICtrlSetState($Updown_blocks, $GUI_ENABLE)
						GUICtrlSetState($Combo_games, $GUI_ENABLE)
						GUICtrlSetState($Button_backups, $GUI_ENABLE)
						GUICtrlSetState($Button_changes, $GUI_ENABLE)
						GUICtrlSetState($Button_program, $GUI_ENABLE)
						GUICtrlSetState($Button_changed, $GUI_ENABLE)
						GUICtrlSetState($Button_inf, $GUI_ENABLE)
						GUICtrlSetState($Button_close, $GUI_ENABLE)
						GuiSetState(@SW_RESTORE, $GOGRepoGUI)
						GuiSetState(@SW_RESTORE, $UpdateGUI)
					Else
						MsgBox(262192, "Update Error", "Could not find the manifest file!", 0, $UpdateGUI)
					EndIf
				EndIf
			EndIf
		Case $msg = $Button_changes
			; Open the Update Changes folder
			If FileExists($compfold) Then ShellExecute($compfold)
		Case $msg = $Button_changed
			; View the Changed.txt file
			If FileExists($changed) Then ShellExecute($changed)
		Case $msg = $Button_begin
			; Begin Updating in Stages
			CheckForConnection()
			If $connection = 1 Then
				$ans = MsgBox(262691, "Update In Stages Query", _
					"This resets any previous stages use (starts over)." & @LF & @LF & _
					"Do you want to do a fresh (new) manifest?" & @LF & @LF & _
					"YES = Start from scratch (wipe any existing)." & @LF & _
					"NO = Use the existing manifest game titles." & @LF & _
					"CANCEL = Abort any updating in stages." & @LF & @LF & _
					"NOTE - With the NO option, the specified number" & @LF & _
					"of games, as indicated by the 'Blocks' and 'Titles'," & @LF & _
					"is removed from the manifest then replaced. The" & @LF & _
					"YES option gets a fresh list of games from GOG." & @LF & _
					"Both of the options work through the full listing" & @LF & _
					"of game titles, using the CONTINUE button and" & @LF & _
					"the 'Blocks' and 'Titles' values." & @LF & @LF & _
					"The program keeps tabs on what titles have been" & @LF & _
					"processed and which ones haven't." & @LF & @LF & _
					"NO GAME FILES OR EXTRAS ARE REMOVED!", 0, $UpdateGUI)
				If $ans <> 2 Then
					GUICtrlSetState($Button_begin, $GUI_DISABLE)
					GUICtrlSetState($Button_continue, $GUI_DISABLE)
					If $script = "fork" Then
						GUICtrlSetState($Checkbox_skip, $GUI_DISABLE)
						GUICtrlSetState($Checkbox_uplog, $GUI_DISABLE)
						GUICtrlSetState($Combo_install, $GUI_DISABLE)
					EndIf
					GUICtrlSetState($Checkbox_clean, $GUI_DISABLE)
					GUICtrlSetState($Checkbox_stages, $GUI_DISABLE)
					GUICtrlSetState($Updown_blocks, $GUI_DISABLE)
					GUICtrlSetState($Combo_games, $GUI_DISABLE)
					GUICtrlSetState($Button_backups, $GUI_DISABLE)
					GUICtrlSetState($Button_changes, $GUI_DISABLE)
					GUICtrlSetState($Button_program, $GUI_DISABLE)
					GUICtrlSetState($Button_changed, $GUI_DISABLE)
					GUICtrlSetState($Button_inf, $GUI_DISABLE)
					GUICtrlSetState($Button_close, $GUI_DISABLE)
					GuiSetState(@SW_MINIMIZE, $UpdateGUI)
					GUISwitch($GOGRepoGUI)
					GUICtrlSetImage($Pic_cover, $blackjpg)
					GUICtrlSetFont($Label_cover, 7, 600, 0, "Small Fonts")
					GUICtrlSetData($Label_cover, "Please Wait!")
					BackupManifestEtc()
					FileChangeDir(@ScriptDir)
					$updating = 1
					$cleaned = 0
					$cleanup = ""
					If $ans = 6 Then
						$stage = 1
					ElseIf $ans = 7 Then
						$stage = 2
					EndIf
					IniWrite($inifle, "Updating", "stage", $stage)
					IniWrite($inifle, "Updating", "loops", $blocks)
					IniWrite($inifle, "Updating", "games", $block)
					If $stage = 1 Then
						Local $cmdpid, $handle, $w, $wins, $wintit
						; Create a fresh start.
						If FileExists($manifest) Then
							FileDelete($manifest)
							GUICtrlSetData($List_games, "")
							GUICtrlSetData($Input_name, "")
							GUICtrlSetData($Input_title, "")
							GUICtrlSetData($Input_OS, "")
							GUICtrlSetData($Input_extra, "")
						EndIf
						If FileExists($resumeman) Then FileDelete($resumeman)
						_FileCreate($titlist)
						_FileCreate($stagefile)
						; Create a list of all titles in the resume manifest.
						_FileWriteLog($logfle, "Updating manifest in Stages 1 mode.")
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
									If $script = "default" Then
										$text = "saved titles"
									Else
										$text = "saved resume manifest"
									EndIf
									If StringInStr($results, $text) > 0 Then
										$wintit = @SystemDir & "\cmd.exe"
										$wins = WinList($wintit, "")
										For $w = 1 To $wins[0][0]
											$handle = $wins[$w][1]
											$cmdpid = WinGetProcess($handle, "")
											If $cmdpid = $pid Then
												WinClose($handle, "")
												GUICtrlSetData($Label_cover, "Bingo!")
												Sleep(500)
												;SplashOff()
											;Else
											;	SplashTextOn("", $cmdpid & @LF & $pid, 200, 120, Default, Default, 33)
											;	Sleep(500)
											EndIf
										Next
										If ProcessExists($pid) Then ProcessClose($pid)
										ExitLoop
									EndIf
								EndIf
							EndIf
							If ProcessExists($pid) = 0 Then ExitLoop
						WEnd
						If GUICtrlRead($Checkbox_window) = $GUI_CHECKED Then
							GUICtrlSetState($Checkbox_window, $GUI_UNCHECKED)
							GuiSetState(@SW_MINIMIZE, $UpdateGUI)
						EndIf
						; Create a list of all titles.
						GUICtrlSetData($Label_cover, "Getting Titles!")
						If FileExists($resumeman) Then
							$res = _FileReadToArray($resumeman, $array, 1)
							If $res = 1 Then
								$found = 0
								$file = FileOpen($stagefile, 2)
								For $a = 2 To $array[0]
									$line = $array[$a]
									If $line <> "" Then
										If StringInStr($line, "'title': '") > 0 Then
											$line = StringSplit($line, "'title': '", 1)
											$line = $line[2]
											$line = StringSplit($line, "'}", 1)
											$line = $line[1]
											$line = StringStripWS($line, 8)
											FileWriteLine($file, "title=" & $line)
											$found = $found + 1
										EndIf
									EndIf
								Next
								FileClose($file)
								GUICtrlSetData($Label_action, $found & " Games")
								Sleep(1500)
							Else
								MsgBox(262192, "Extract Error", "Could not get titles!", 0, $UpdateGUI)
							EndIf
						Else
							MsgBox(262192, "Update Error", "Could not find the resume manifest file!", 0, $UpdateGUI)
						EndIf
						_FileWriteLog($logfle, "Initial stage has finished.")
						If GUICtrlRead($Checkbox_window) = $GUI_CHECKED Then
							GUICtrlSetState($Checkbox_window, $GUI_UNCHECKED)
							GuiSetState(@SW_MINIMIZE, $UpdateGUI)
						EndIf
						; Update (add) the specified number of game titles to the manifest.
						GUICtrlSetData($Label_cover, "Updating!")
						If FileExists($stagefile) Then
							$res = _FileReadToArray($stagefile, $array, 1)
							$err = @error
							If $res = 1 Then
								_FileWriteLog($logfle, "Adding first block of games.")
								If $script = "default" Then
									$params = ""
								Else
									$params = " -resumemode noresume -skiphidden -nolog -installers " & $installer
									If $skiphid = 4 Then $params = StringReplace($params, " -skiphidden", "")
									If $uplog = 1 Then $params = StringReplace($params, " -nolog", "")
								EndIf
								$loop = 1
								$start = 1
								While 1
									$ids = ""
									$id = 0
									GUICtrlSetData($Label_action, "Updating")
									If $script = "default" Then
										$message = "Block " & $loop & " of " & $blocks & " = " & $block & " games"
										GUICtrlSetData($Label_cover, $message)
										For $a = $start To $array[0]
											$title = $array[$a]
											$title = StringReplace($title, "title=", "")
											If $title <> "" Then
												$id = $id + 1
												If $ids = "" Then
													$ids = $title
												Else
													$ids = $ids & " " & $title
												EndIf
												GUICtrlSetData($Label_num, $id)
												If GUICtrlRead($Checkbox_console) = $GUI_CHECKED Then
													$flag = @SW_MINIMIZE
												Else
													$flag = @SW_SHOW
												EndIf
												$pid = RunWait(@ComSpec & ' /c gogrepo.py update -os ' & $OS & ' -lang ' & $lang & $params & ' -id ' & $title, @ScriptDir, $flag)
												If $a = $array[0] Then
													$cleanup = 1
													ExitLoop
												EndIf
												If $id = $block Then ExitLoop
												If GUICtrlRead($Checkbox_window) = $GUI_CHECKED Then
													GUICtrlSetState($Checkbox_window, $GUI_UNCHECKED)
													GuiSetState(@SW_MINIMIZE, $UpdateGUI)
												EndIf
											EndIf
										Next
										_FileWriteLog($logfle, $ids)
									Else
										For $a = $start To $array[0]
											$title = $array[$a]
											$title = StringReplace($title, "title=", "")
											If $title <> "" Then
												$id = $id + 1
												If $ids = "" Then
													$ids = $title
												Else
													$ids = $ids & " " & $title
												EndIf
												If $a = $array[0] Then
													$cleanup = 1
													ExitLoop
												EndIf
												If $id = $block Then ExitLoop
											EndIf
										Next
										$message = "Block " & $loop & " of " & $blocks & " = " & $id & " games"
										GUICtrlSetData($Label_cover, $message)
										_FileWriteLog($logfle, $ids)
										If $ids <> "" Then
											If GUICtrlRead($Checkbox_console) = $GUI_CHECKED Then
												$flag = @SW_MINIMIZE
											Else
												$flag = @SW_SHOW
											EndIf
											$pid = RunWait(@ComSpec & ' /c gogrepo.py update -os ' & $OS & ' -lang ' & $lang & $params & ' -ids ' & $ids, @ScriptDir, $flag)
											If GUICtrlRead($Checkbox_window) = $GUI_CHECKED Then
												GUICtrlSetState($Checkbox_window, $GUI_UNCHECKED)
												GuiSetState(@SW_MINIMIZE, $UpdateGUI)
											EndIf
										Else
											$cleanup = 1
											ExitLoop
										EndIf
									EndIf
									If $loop = $blocks Then
										ExitLoop
									Else
										$loop = $loop + 1
										$start = $start + $block
									EndIf
								WEnd
								GUICtrlSetData($Label_action, "")
								GUICtrlSetData($Label_num, "")
								GUICtrlSetData($Label_cover, "Checking!")
								Sleep(1000)
								; Remove any titles from list file that now exist in the manifest
								_FileWriteLog($logfle, "Removing updated titles.")
								$open = FileOpen($manifest, 0)
								$read = FileRead($open)
								FileClose($open)
								$res = _FileReadToArray($stagefile, $array, 1)
								If $res = 1 Then
									$blocks = IniRead($inifle, "Updating", "loops", "")
									$block = IniRead($inifle, "Updating", "games", "")
									$cleaned = 0
									$loop = 1
									$start = 1
									GUICtrlSetData($Label_action, "Checking")
									While 1
										GUICtrlSetData($Label_cover, $loop & " of " & $blocks)
										$ids = ""
										$id = 0
										For $a = $start To $array[0]
											$title = $array[$a]
											If $title <> "" Then
												$id = $id + 1
												$entry = StringReplace($title, "title=", "")
												$entry = "'title': '" & $entry & "'}"
												If StringInStr($read, $entry) > 0 Then
													$res = _ReplaceStringInFile($stagefile, $title & @CRLF, "")
													If $res > 0 Then $cleaned = $cleaned + 1
												EndIf
												If $a = $array[0] Then
													$cleanup = 1
													ExitLoop
												EndIf
												If $id = $block Then ExitLoop
											EndIf
										Next
										If $loop = $blocks Then
											ExitLoop
										Else
											$loop = $loop + 1
											$start = $start + $block
										EndIf
										If GUICtrlRead($Checkbox_window) = $GUI_CHECKED Then
											GUICtrlSetState($Checkbox_window, $GUI_UNCHECKED)
											GuiSetState(@SW_MINIMIZE, $UpdateGUI)
										EndIf
									WEnd
								Else
									MsgBox(262192, "Read Error", "Could not get titles!", 0, $UpdateGUI)
								EndIf
								GUICtrlSetData($Label_cover, "Cleanup = " & $cleaned)
								Sleep(1500)
								_FileWriteLog($logfle, "Part 1 of Stage 1 completed.")
							Else
								If $err = 2 Then
									$lines = _FileCountLines($stagefile)
									If $lines = 0 Then
										$cleanup = 1
									Else
										$err = 5
									EndIf
								EndIf
								If $err <> 2 Then MsgBox(262192, "Read Error", "Could not get titles!", 0, $UpdateGUI)
							EndIf
							If $cleanup = 1 Then
								$stage = ""
								IniWrite($inifle, "Updating", "stage", $stage)
								IniWrite($inifle, "Updating", "loops", "")
								IniWrite($inifle, "Updating", "games", "")
								GUICtrlSetState($Checkbox_stages, $GUI_UNCHECKED)
								MsgBox(262208, "Result", "'Update In Stages' appears to be complete!", 0, $UpdateGUI)
							EndIf
							$blocks = IniRead($inifle, "Updating", "blocks", "")
							$block = IniRead($inifle, "Updating", "block", "")
							;
							$remain = _FileCountLines($stagefile)
							$completed = $found - $remain
							GUICtrlSetData($Label_done, $completed)
							GUICtrlSetTip($Label_done, $remain & " remaining!")
						Else
							MsgBox(262192, "Update Error", "Could not find title list file!", 0, $UpdateGUI)
						EndIf
					ElseIf $stage = 2 Then
						If FileExists($manifest) Then
							GUICtrlSetData($Input_name, "")
							GUICtrlSetData($Input_title, "")
							GUICtrlSetData($Input_OS, "")
							GUICtrlSetData($Input_extra, "")
							If FileExists($resumeman) Then FileDelete($resumeman)
							_FileCreate($stagefile)
							$sum = $blocks * $block
							; Perhaps wipe (clear) the $compfold folder.
							$res = _FileReadToArray($titlist, $array, 1)
							If $res = 1 Then
								_FileWriteLog($logfle, "Updating manifest in Stages 2 mode.")
								$file = FileOpen($stagefile, 2)
								$read = FileRead($file)
								GUICtrlSetData($Label_cover, "Getting Titles!")
								$id = 0
								For $a = 2 To ($array[0] - 1)
									$line = $array[$a]
									If $line <> "" Then
										$line = StringSplit($line, " | ", 1)
										If $line[0] = 2 Then
											$line = $line[2]
											$line = StringSplit($line, " (", 1)
											If $line[0] = 2 Then
												$line = $line[1]
												FileWriteLine($file, "title=" & $line)
												$id = $id + 1
											EndIf
										EndIf
									EndIf
								Next
								FileClose($file)
								_FileWriteLog($logfle, $id & " Game Titles found.")
								If GUICtrlRead($Checkbox_window) = $GUI_CHECKED Then
									GUICtrlSetState($Checkbox_window, $GUI_UNCHECKED)
									GuiSetState(@SW_MINIMIZE, $UpdateGUI)
								EndIf
								;
								If $id > 0 Then
									GUICtrlSetData($Label_cover, $id & " Game Titles found!")
									Sleep(1500)
									; Get number line for games in manifest.
									$res = _FileReadToArray($manifest, $array)
									If $res = 1 Then
										$games = $array[1]
									Else
										$games = ""
									EndIf
									; Read titles list into an array.
									$res = _FileReadToArray($stagefile, $array, 1)
									$err = @error
									If $res = 1 Then
										_FileWriteLog($logfle, "Processing first block of games.")
										$res = 0
										$open = FileOpen($manifest, 0)
										$read = FileRead($open)
										FileClose($open)
										If $script = "default" Then
											$params = ""
										Else
											$params = " -resumemode noresume -skiphidden -nolog -installers " & $installer
											If $skiphid = 4 Then $params = StringReplace($params, " -skiphidden", "")
											If $uplog = 1 Then $params = StringReplace($params, " -nolog", "")
										EndIf
										$loop = 1
										$start = 1
										While 1
											$ids = ""
											$id = 0
											For $a = $start To $array[0]
												$title = $array[$a]
												$title = StringReplace($title, "title=", "")
												If $title <> "" Then
													$titfile = $compfold & "\" & $title & ".txt"
													_FileCreate($titfile)
													$res = 0
													$id = $id + 1
													GUICtrlSetData($Label_cover, "Checking To Remove = " & $id)
													; Read section of title in manifest.
													$segment = StringSplit($read, "'title': '" & $title & "'}", 1)
													If $segment[0] = 2 Then
														$segment = $segment[1]
														$segment = StringSplit($segment, "{'bg_url':", 1)
														If $segment[0] > 1 Then
															$segment = "{'bg_url':" & $segment[$segment[0]]
															$segment = $segment & "'title': '" & $title & "'},"
															;MsgBox(262192, "Game Segment", $games & @LF & $segment, $wait, $UpdateGUI)
															; Delete section from manifest.
															; Attempt to remove as a middle entry.
															$res = _ReplaceStringInFile($manifest, " " & $segment & @LF, "")
															If @error = 0 Then
																If $res = 0 Then
																	; Failed, so attempt to remove as a last entry.
																	$segment = StringTrimRight($segment, 1)
																	$res = _ReplaceStringInFile($manifest, " " & $segment, "")
																	If @error = 0 Then
																		If $res = 0 Then
																			; Failed, so attempt to remove as a first entry.
																			$segment = $segment & ","
																			$res = _ReplaceStringInFile($manifest, $segment & @LF, "")
																			If @error = 0 Then
																				If $res = 0 Then
																					; Failed, so attempt to remove the only entry.
																					$segment = StringTrimRight($segment, 1)
																					$res = _ReplaceStringInFile($manifest, $segment, "")
																					If $res > 0 Then
																						; Success
																						; Save to file for later comparison.
																						FileWrite($titfile, $segment)
																					EndIf
																				Else
																					; Success
																					_ReplaceStringInFile($manifest, "[ {", "[{")
																					; Save to file for later comparison.
																					FileWrite($titfile, $segment)
																				EndIf
																			EndIf
																		Else
																			; Success
																			_ReplaceStringInFile($manifest, "," & @LF & "]", "]")
																			; Save to file for later comparison.
																			FileWrite($titfile, $segment)
																		EndIf
																	EndIf
																Else
																	; Success
																	; Save to file for later comparison.
																	FileWrite($titfile, $segment)
																EndIf
															Else
																MsgBox(262192, "Removal Error (1)", "Could not remove entry from manifest!", 0, $UpdateGUI)
															EndIf
														Else
															MsgBox(262192, "Removal Error", "Could not divide on url entry!", 0, $UpdateGUI)
														EndIf
													Else
														MsgBox(262192, "Removal Error", "Could not divide on title entry!", 0, $UpdateGUI)
													EndIf
													If $res > 0 And $games <> "" Then
														GUICtrlSetData($Label_cover, "Removed = " & $a & " of " & $sum)
														Sleep(500)
														; Update number line for games in manifest.
														$number = StringSplit($games, " ", 1)
														If $number[0] > 1 Then
															$number = $number[2]
															If StringIsDigit($number) Then
																$number = $number - 1
																$number = "# " & $number & " games"
																_ReplaceStringInFile($manifest, $games, $number)
																$games = $number
															EndIf
														EndIf
													Else
														MsgBox(262192, "Removal Error (2)", "Could not remove entry from manifest!", 0, $UpdateGUI)
													EndIf
													;
													If $ids = "" Then
														$ids = $title
													Else
														$ids = $ids & " " & $title
													EndIf
													If $a = $array[0] Then
														$cleanup = 1
														ExitLoop
													EndIf
													If $id = $block Then ExitLoop
												EndIf
												If GUICtrlRead($Checkbox_window) = $GUI_CHECKED Then
													GUICtrlSetState($Checkbox_window, $GUI_UNCHECKED)
													GuiSetState(@SW_MINIMIZE, $UpdateGUI)
												EndIf
											Next
											GUICtrlSetData($Label_cover, "Updating!")
											Sleep(750)
											$message = "Block " & $loop & " of " & $blocks & " = " & $id & " games"
											GUICtrlSetData($Label_cover, $message)
											GUICtrlSetData($Label_action, "Updating")
											_FileWriteLog($logfle, $ids)
											If $ids <> "" Then
												If $script = "default" Then
													$ids = StringSplit($ids, " ", 1)
													For $i = 1 To $ids[0]
														$title = $ids[$i]
														If $title <> "" Then
															GUICtrlSetData($Label_num, $i)
															If GUICtrlRead($Checkbox_console) = $GUI_CHECKED Then
																$flag = @SW_MINIMIZE
															Else
																$flag = @SW_SHOW
															EndIf
															$pid = RunWait(@ComSpec & ' /c gogrepo.py update -os ' & $OS & ' -lang ' & $lang & $params & ' -id ' & $title, @ScriptDir, $flag)
															If GUICtrlRead($Checkbox_window) = $GUI_CHECKED Then
																GUICtrlSetState($Checkbox_window, $GUI_UNCHECKED)
																GuiSetState(@SW_MINIMIZE, $UpdateGUI)
															EndIf
														EndIf
													Next
												Else
													If GUICtrlRead($Checkbox_console) = $GUI_CHECKED Then
														$flag = @SW_MINIMIZE
													Else
														$flag = @SW_SHOW
													EndIf
													$pid = RunWait(@ComSpec & ' /c gogrepo.py update -os ' & $OS & ' -lang ' & $lang & $params & ' -ids ' & $ids, @ScriptDir, $flag)
													If GUICtrlRead($Checkbox_window) = $GUI_CHECKED Then
														GUICtrlSetState($Checkbox_window, $GUI_UNCHECKED)
														GuiSetState(@SW_MINIMIZE, $UpdateGUI)
													EndIf
												EndIf
											Else
												$cleanup = 1
												ExitLoop
											EndIf
											If $loop = $blocks Then
												ExitLoop
											Else
												$loop = $loop + 1
												$start = $start + $block
											EndIf
										WEnd
										GUICtrlSetData($Label_action, "")
										GUICtrlSetData($Label_num, "")
										GUICtrlSetFont($Label_num, 7, 600, 0, "Small Fonts")
										GUICtrlSetData($Label_cover, "Checking!")
										Sleep(500)
										; Remove any titles from list file that now exist in the manifest
										_FileWriteLog($logfle, "Removing updated titles.")
										$open = FileOpen($manifest, 0)
										$read = FileRead($open)
										FileClose($open)
										$res = _FileReadToArray($stagefile, $array, 1)
										If $res = 1 Then
											$blocks = IniRead($inifle, "Updating", "loops", "")
											$block = IniRead($inifle, "Updating", "games", "")
											$cleaned = 0
											$loop = 1
											$start = 1
											GUICtrlSetData($Label_action, "Checking")
											While 1
												GUICtrlSetData($Label_cover, $loop & " of " & $blocks & " blocks")
												Sleep(500)
												$ids = ""
												$id = 0
												For $a = $start To $array[0]
													$title = $array[$a]
													If $title <> "" Then
														$id = $id + 1
														$entry = StringReplace($title, "title=", "")
														$entry = "'title': '" & $entry & "'}"
														If StringInStr($read, $entry) > 0 Then
															$res = _ReplaceStringInFile($stagefile, $title & @CRLF, "")
															If $res > 0 Then $cleaned = $cleaned + 1
															;
															; Read section of title in manifest, for comparison.
															GUICtrlSetData($Label_num, "Comparing = " & $a & " of " & $sum)
															Sleep(500)
															$title = StringReplace($title, "title=", "")
															$titfile = $compfold & "\" & $title & ".txt"
															If FileExists($titfile) Then
																$segment = StringSplit($read, "'title': '" & $title & "'}", 1)
																If $segment[0] = 2 Then
																	$segment = $segment[1]
																	$segment = StringSplit($segment, "{'bg_url':", 1)
																	If $segment[0] > 1 Then
																		$segment = "{'bg_url':" & $segment[$segment[0]]
																		$segment = $segment & "'title': '" & $title & "'}"
																		;MsgBox(262192, "Game Segment", $games & @LF & $segment, $wait, $UpdateGUI)
																		; Compare with original
																		$res = _ReplaceStringInFile($titfile, $segment, "")
																		If $res > 0 Then
																			; No differences delete the $titfile.
																			FileDelete($titfile)
																			GUICtrlSetData($Label_num, "No Changes (" & $a & ")")
																		Else
																			; Differences found, do an intensive check
																			$newfile = $compfold & "\" & $title & "_new.txt"
																			FileWrite($newfile, $segment)
																			$res = FullComparisonCheck()
																			If $res = "pass" Then
																				GUICtrlSetData($Label_num, "No Changes (" & $a & ")")
																			ElseIf $res = "fail" Then
																				; Differences found, add to the $changed file.
																				GUICtrlSetData($Label_num, "Changes Detected (" & $a & ")")
																				FileWriteLine($changed, $title)
																			EndIf
																		EndIf
																		Sleep(1500)
																	EndIf
																EndIf
															EndIf
														EndIf
														If $a = $array[0] Then
															$cleanup = 1
															ExitLoop
														EndIf
														If $id = $block Then ExitLoop
													EndIf
													If GUICtrlRead($Checkbox_window) = $GUI_CHECKED Then
														GUICtrlSetState($Checkbox_window, $GUI_UNCHECKED)
														GuiSetState(@SW_MINIMIZE, $UpdateGUI)
													EndIf
												Next
												If $loop = $blocks Then
													ExitLoop
												Else
													$loop = $loop + 1
													$start = $start + $block
												EndIf
											WEnd
										Else
											MsgBox(262192, "Read Error", "Could not get titles!", 0, $UpdateGUI)
										EndIf
										GUICtrlSetData($Label_num, "")
										GUICtrlSetFont($Label_num, 9, 600)
										GUICtrlSetData($Label_cover, "Cleanup = " & $cleaned)
										Sleep(1500)
										_FileWriteLog($logfle, "Part 1 of Stage 2 completed.")
									Else
										If $err = 2 Then
											$lines = _FileCountLines($stagefile)
											If $lines = 0 Then
												$cleanup = 1
											Else
												$err = 5
											EndIf
										EndIf
										If $err <> 2 Then MsgBox(262192, "Read Error", "Could not get titles!", 0, $UpdateGUI)
									EndIf
									If $cleanup = 1 Then
										$stage = ""
										IniWrite($inifle, "Updating", "stage", $stage)
										IniWrite($inifle, "Updating", "loops", "")
										IniWrite($inifle, "Updating", "games", "")
										GUICtrlSetState($Checkbox_stages, $GUI_UNCHECKED)
										MsgBox(262208, "Result", "'Update In Stages' appears to be complete!", 0, $UpdateGUI)
									EndIf
									$blocks = IniRead($inifle, "Updating", "blocks", "")
									$block = IniRead($inifle, "Updating", "block", "")
									If FileExists($stagefile) Then
										$remain = _FileCountLines($stagefile)
										$completed = $found - $remain
										GUICtrlSetData($Label_done, $completed)
										GUICtrlSetTip($Label_done, $remain & " remaining!")
									EndIf
								Else
									MsgBox(262192, "List Error", "Could not find any titles!", 0, $UpdateGUI)
								EndIf
							Else
								MsgBox(262192, "Read Error", "Could not get titles!", 0, $UpdateGUI)
							EndIf
						Else
							MsgBox(262192, "Update Error", "Could not find the manifest file!", 0, $UpdateGUI)
						EndIf
					EndIf
					;
					$open = FileOpen($manifest, 0)
					$read = FileRead($open)
					FileClose($open)
					If StringInStr($read, @CRLF) > 0 Then
						$res = _ReplaceStringInFile($manifest, @CRLF, @LF)
						MsgBox(262192, "Manifest Fix", $res & " carriage returns were found and replaced with line feeds.", 0, $GOGRepoGUI)
					EndIf
					;
					GUICtrlSetData($Label_action, "")
					GUICtrlSetData($Label_num, "")
					GUICtrlSetData($Label_cover, "")
					GUICtrlSetFont($Label_cover, 8.5, 400, 0, "")
					GUISwitch($UpdateGUI)
					If $stage <> "" Then GUICtrlSetState($Button_continue, $GUI_ENABLE)
					If $script = "fork" Then
						GUICtrlSetState($Checkbox_skip, $GUI_ENABLE)
						GUICtrlSetState($Checkbox_uplog, $GUI_ENABLE)
						GUICtrlSetState($Combo_install, $GUI_ENABLE)
					EndIf
					GUICtrlSetState($Checkbox_clean, $GUI_ENABLE)
					GUICtrlSetState($Checkbox_stages, $GUI_ENABLE)
					GUICtrlSetState($Updown_blocks, $GUI_ENABLE)
					GUICtrlSetState($Combo_games, $GUI_ENABLE)
					GUICtrlSetState($Button_backups, $GUI_ENABLE)
					GUICtrlSetState($Button_changes, $GUI_ENABLE)
					GUICtrlSetState($Button_program, $GUI_ENABLE)
					GUICtrlSetState($Button_changed, $GUI_ENABLE)
					GUICtrlSetState($Button_inf, $GUI_ENABLE)
					GUICtrlSetState($Button_close, $GUI_ENABLE)
					GuiSetState(@SW_RESTORE, $GOGRepoGUI)
					GuiSetState(@SW_RESTORE, $UpdateGUI)
				EndIf
			EndIf
		Case $msg = $Button_backups
			; Open the Backups folder
			If FileExists($backups) Then ShellExecute($backups)
		Case $msg = $Checkbox_tag
			; Update games with Update Tag
			If GUICtrlRead($Checkbox_tag) = $GUI_CHECKED Then
				$tagged = 1
			Else
				$tagged = 4
			EndIf
			IniWrite($inifle, "Update Tag", "use", $tagged)
		Case $msg = $Checkbox_stages
			; Enable updating in stages
			If GUICtrlRead($Checkbox_stages) = $GUI_CHECKED Then
				$stages = 1
				GUICtrlSetState($Button_begin, $GUI_ENABLE)
				GUICtrlSetState($Button_continue, $GUI_ENABLE)
				GUICtrlSetState($Checkbox_clean, $GUI_ENABLE)
				GUICtrlSetState($Input_blocks, $GUI_ENABLE)
				GUICtrlSetState($Updown_blocks, $GUI_ENABLE)
				GUICtrlSetState($Combo_games, $GUI_ENABLE)
				;
				If $script = "fork" Then GUICtrlSetState($Checkbox_resume, $GUI_DISABLE)
				GUICtrlSetState($Checkbox_new, $GUI_DISABLE)
				GUICtrlSetState($Checkbox_tag, $GUI_DISABLE)
				GUICtrlSetState($Button_upnow, $GUI_DISABLE)
				GUICtrlSetState($Checkbox_replace, $GUI_DISABLE)
			Else
				$stages = 4
				GUICtrlSetState($Button_begin, $GUI_DISABLE)
				GUICtrlSetState($Button_continue, $GUI_DISABLE)
				GUICtrlSetState($Checkbox_clean, $GUI_DISABLE)
				GUICtrlSetState($Input_blocks, $GUI_DISABLE)
				GUICtrlSetState($Updown_blocks, $GUI_DISABLE)
				GUICtrlSetState($Combo_games, $GUI_DISABLE)
				;
				If $script = "fork" Then GUICtrlSetState($Checkbox_resume, $GUI_ENABLE)
				GUICtrlSetState($Checkbox_new, $GUI_ENABLE)
				GUICtrlSetState($Checkbox_tag, $GUI_ENABLE)
				GUICtrlSetState($Button_upnow, $GUI_ENABLE)
				If $all = 4 Then GUICtrlSetState($Checkbox_replace, $GUI_ENABLE)
				If _IsPressed("11") Then
					$stage = ""
					IniWrite($inifle, "Updating", "stage", $stage)
					IniWrite($inifle, "Updating", "loops", "")
					IniWrite($inifle, "Updating", "games", "")
					MsgBox(262208, "Result", "'Update In Stages' indicator cleared!", 3, $UpdateGUI)
				EndIf
			EndIf
		Case $msg = $Checkbox_skip
			; Skip updating the manifest for hidden games
			If GUICtrlRead($Checkbox_skip) = $GUI_CHECKED Then
				$skiphid = 1
			Else
				$skiphid = 4
			EndIf
			IniWrite($inifle, "Hidden Games", "skip", $skiphid)
		Case $msg = $Checkbox_resume
			; Enable resume modes for updating
			If GUICtrlRead($Checkbox_resume) = $GUI_CHECKED Then
				$resume = 1
			ElseIf GUICtrlRead($Checkbox_resume) = $GUI_UNCHECKED Then
				$resume = 4
			Else
				$resume = 2
			EndIf
			IniWrite($inifle, "Updating", "resume", $resume)
		Case $msg = $Checkbox_replace
			; Replace and Compare selected title in manifest
			If GUICtrlRead($Checkbox_replace) = $GUI_CHECKED Then
				$replace = 1
			Else
				$replace = 4
			EndIf
		Case $msg = $Checkbox_new
			; Add new games only to the manifest
			If GUICtrlRead($Checkbox_new) = $GUI_CHECKED Then
				$newgames = 1
			Else
				$newgames = 4
			EndIf
			IniWrite($inifle, "New Games Only", "add", $newgames)
		Case $msg = $Checkbox_clean
			; Enable cleanup only
			If GUICtrlRead($Checkbox_clean) = $GUI_CHECKED Then
				$clean = 1
				If $stage = 1 Then
					GUICtrlSetData($Button_continue, "CLEANUP")
				ElseIf $stage = 2 Then
					GUICtrlSetData($Button_continue, "FIXUP")
				Else
					$clean = 4
					GUICtrlSetState($Checkbox_clean, $clean)
					MsgBox(262192, "Not Available", "Nothing to clean or fix!", 2, $UpdateGUI)
				EndIf
			Else
				If GUICtrlRead($Checkbox_clean) = $GUI_UNCHECKED Then
					$clean = 4
				Else
					If $stage = 1 Then
						$clean = 2
					Else
						$clean = 4
						GUICtrlSetState($Checkbox_clean, $clean)
					EndIf
				EndIf
				GUICtrlSetData($Button_continue, "CONTINUE")
			EndIf
		Case $msg = $Combo_install
			; Installers to update for
			$installer = GUICtrlRead($Combo_install)
			IniWrite($inifle, "Updating", "installers", $installer)
		Case $msg = $Combo_games
			; Games in a block
			$block = GUICtrlRead($Combo_games)
			IniWrite($inifle, "Updating", "block", $block)
			$val = $block * $blocks
			SplashTextOn("", $val & " Games!", 140, 80, Default, Default, 33)
			Sleep(500)
			SplashOff()
		Case $msg = $Updown_blocks
			; Games in a block
			$blocks = GUICtrlRead($Input_blocks)
			IniWrite($inifle, "Updating", "blocks", $blocks)
			$val = $block * $blocks
			SplashTextOn("", $val & " Games!", 140, 80, Default, Default, 33)
			Sleep(500)
			SplashOff()
		Case Else
			;;;
		EndSelect
	WEnd
EndFunc ;=> UpdateGUI

Func VerifyGUI()
	Local $Button_close, $Button_verify, $Checkbox_alone, $Checkbox_delete, $Checkbox_every, $Checkbox_extras, $Checkbox_galaxy
	Local $Checkbox_games, $Checkbox_md5, $Checkbox_shared, $Checkbox_size, $Checkbox_verylog, $Checkbox_zip, $Group_files
	Local $above, $high, $params, $side, $wide
	;
	$wide = 230
	$high = 200
	$side = IniRead($inifle, "Verify Window", "left", $left)
	$above = IniRead($inifle, "Verify Window", "top", $top)
	$VerifyGUI = GuiCreate("Verify Game Files", $wide, $high, $side, $above, $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU _
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
	$Checkbox_verylog = GUICtrlCreateCheckbox("Log File", 10, 70, 55, 20)
	GUICtrlSetTip($Checkbox_verylog, "Save a Log file for verify!")
	;
	$Checkbox_extras = GUICtrlCreateCheckbox("Extra Files", 75, 70, 65, 20)
	GUICtrlSetTip($Checkbox_extras, "Verify all extra files!")
	;
	$Checkbox_games = GUICtrlCreateCheckbox("Game Files", 150, 70, 70, 20)
	GUICtrlSetTip($Checkbox_games, "Verify game files!")
	;
	$Group_files = GuiCtrlCreateGroup("", 10, 88, 210, 40)
	$Checkbox_alone = GUICtrlCreateCheckbox("Standalone", 20, 102, 80, 20)
	GUICtrlSetTip($Checkbox_alone, "Verify standalone installer files!")
	;
	$Checkbox_shared = GUICtrlCreateCheckbox("Shared", 100, 102, 50, 20)
	GUICtrlSetTip($Checkbox_shared, "Verify shared installer files!")
	;
	$Checkbox_galaxy = GUICtrlCreateCheckbox("Galaxy", 162, 102, 50, 20)
	GUICtrlSetTip($Checkbox_galaxy, "Verify galaxy installer files!")
	;
	$Button_verify = GuiCtrlCreateButton("VERIFY NOW", 10, 140, 140, 50)
	GUICtrlSetFont($Button_verify, 9, 600)
	GUICtrlSetTip($Button_verify, "Verify the specified games!")
	;
	$Button_close = GuiCtrlCreateButton("EXIT", 160, 140, 60, 50, $BS_ICON)
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
	If $script = "default" Then
		;$verylog = 4
		GUICtrlSetState($Checkbox_verylog, $GUI_DISABLE)
		;$veryextra = 4
		GUICtrlSetState($Checkbox_extras, $GUI_DISABLE)
		;$verygames = 4
		GUICtrlSetState($Checkbox_games, $GUI_DISABLE)
		;$veryalone = 4
		GUICtrlSetState($Checkbox_alone, $GUI_DISABLE)
		;$veryshare = 4
		GUICtrlSetState($Checkbox_shared, $GUI_DISABLE)
		;$verygalaxy = 4
		GUICtrlSetState($Checkbox_galaxy, $GUI_DISABLE)
	Else
		GUICtrlSetState($Checkbox_verylog, $verylog)
		GUICtrlSetState($Checkbox_extras, $veryextra)
		GUICtrlSetState($Checkbox_games, $verygames)
		GUICtrlSetState($Checkbox_alone, $veryalone)
		GUICtrlSetState($Checkbox_shared, $veryshare)
		GUICtrlSetState($Checkbox_galaxy, $verygalaxy)
		;
		If $verygames = 4 Then
			GUICtrlSetState($Checkbox_alone, $GUI_DISABLE)
			GUICtrlSetState($Checkbox_shared, $GUI_DISABLE)
			GUICtrlSetState($Checkbox_galaxy, $GUI_DISABLE)
		EndIf
	EndIf
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
			$winpos = WinGetPos($VerifyGUI, "")
			$side = $winpos[0]
			If $side < 0 Then
				$side = 2
			ElseIf $side > @DesktopWidth - $wide Then
				$side = @DesktopWidth - $wide - 25
			EndIf
			IniWrite($inifle, "Verify Window", "left", $side)
			$above = $winpos[1]
			If $above < 0 Then
				$above = 2
			ElseIf $above > @DesktopHeight - $high Then
				$above = @DesktopHeight - $high - 30
			EndIf
			IniWrite($inifle, "Verify Window", "top", $above)
			;
			GUIDelete($VerifyGUI)
			ExitLoop
		Case $msg = $Button_verify
			; Verify the specified games
			GuiSetState(@SW_HIDE, $VerifyGUI)
			If $script = "default" Then
				$params = " -skipmd5 -skipsize -skipzip -delete"
			Else
				$params = " -skipmd5 -skipsize -skipzip -delete -nolog -skipextras -skipgames -skipstandalone -skipshared -skipgalaxy"
				If $verylog = 1 Then $params = StringReplace($params, " -nolog", "")
				If $veryextra = 1 Then $params = StringReplace($params, " -skipextras", "")
				If $verygames = 4 Then
					$params = StringReplace($params, " -skipstandalone -skipshared -skipgalaxy", "")
				Else
					$params = StringReplace($params, " -skipgames", "")
					If $veryalone = 1 Then $params = StringReplace($params, " -skipstandalone", "")
					If $veryshare = 1 Then $params = StringReplace($params, " -skipshared", "")
					If $verygalaxy = 1 Then $params = StringReplace($params, " -skipgalaxy", "")
				EndIf
			EndIf
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
		Case $msg = $Checkbox_verylog
			; Save a Log file for verify
			If GUICtrlRead($Checkbox_verylog) = $GUI_CHECKED Then
				$verylog = 1
			Else
				$verylog = 4
			EndIf
			IniWrite($inifle, "Verifying", "log", $verylog)
		Case $msg = $Checkbox_size
			; Enable file size verification
			If GUICtrlRead($Checkbox_size) = $GUI_CHECKED Then
				$sizecheck = 1
			Else
				$sizecheck = 4
			EndIf
			IniWrite($inifle, "Verify", "size", $sizecheck)
		Case $msg = $Checkbox_shared
			; Verify Shared installer files
			If GUICtrlRead($Checkbox_shared) = $GUI_CHECKED Then
				$veryshare = 1
			Else
				$veryshare = 4
			EndIf
			IniWrite($inifle, "Verifying", "shared", $veryshare)
		Case $msg = $Checkbox_md5
			; Enable MD5 checksum verification
			If GUICtrlRead($Checkbox_md5) = $GUI_CHECKED Then
				$md5 = 1
			Else
				$md5 = 4
			EndIf
			IniWrite($inifle, "Verify", "md5", $md5)
		Case $msg = $Checkbox_games
			; Verify game files
			If GUICtrlRead($Checkbox_games) = $GUI_CHECKED Then
				$verygames = 1
				GUICtrlSetState($Checkbox_alone, $GUI_ENABLE)
				GUICtrlSetState($Checkbox_shared, $GUI_ENABLE)
				GUICtrlSetState($Checkbox_galaxy, $GUI_ENABLE)
			Else
				$verygames = 4
				GUICtrlSetState($Checkbox_alone, $GUI_DISABLE)
				GUICtrlSetState($Checkbox_shared, $GUI_DISABLE)
				GUICtrlSetState($Checkbox_galaxy, $GUI_DISABLE)
			EndIf
			IniWrite($inifle, "Verifying", "games", $verygames)
		Case $msg = $Checkbox_galaxy
			; Verify Galaxy installer files
			If GUICtrlRead($Checkbox_galaxy) = $GUI_CHECKED Then
				$verygalaxy = 1
			Else
				$verygalaxy = 4
			EndIf
			IniWrite($inifle, "Verifying", "galaxy", $verygalaxy)
		Case $msg = $Checkbox_extras
			; Verify all extra files
			If GUICtrlRead($Checkbox_extras) = $GUI_CHECKED Then
				$veryextra = 1
			Else
				$veryextra = 4
			EndIf
			IniWrite($inifle, "Verifying", "extras", $veryextra)
		Case $msg = $Checkbox_delete
			; Delete if a file fails integrity check
			If GUICtrlRead($Checkbox_delete) = $GUI_CHECKED Then
				$delete = 1
			Else
				$delete = 4
			EndIf
			IniWrite($inifle, "Verify Failure", "delete", $delete)
		Case $msg = $Checkbox_alone
			; Verify Standalone installer files
			If GUICtrlRead($Checkbox_alone) = $GUI_CHECKED Then
				$veryalone = 1
			Else
				$veryalone = 4
			EndIf
			IniWrite($inifle, "Verifying", "standalone", $veryalone)
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
		$OS = GUICtrlRead($Combo_OS)
		$OS = StringReplace($OS, "+", "")
		$OS = StringStripWS($OS, 7)
		IniWrite($downlist, $title, "OS", $OS)
		IniWrite($downlist, $title, "standalone", $standalone)
		IniWrite($downlist, $title, "galaxy", $galaxy)
		IniWrite($downlist, $title, "shared", $shared)
		IniWrite($downlist, $title, "log", $downlog)
		IniWrite($downlist, $title, "skiplang", $skiplang)
		IniWrite($downlist, $title, "languages", $langskip)
		IniWrite($downlist, $title, "skipOS", $skipos)
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
	If $script = "fork" Then
		IniWrite($downlist, $title, "verylog", $verylog)
		IniWrite($downlist, $title, "veryextra", $veryextra)
		IniWrite($downlist, $title, "verygames", $verygames)
		IniWrite($downlist, $title, "veryalone", $veryalone)
		IniWrite($downlist, $title, "veryshare", $veryshare)
		IniWrite($downlist, $title, "verygalaxy", $verygalaxy)
	EndIf
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
				If $script = "default" Then
					$params = " -skipmd5 -skipsize -skipzip -delete"
				Else
					$params = " -skipmd5 -skipsize -skipzip -delete -nolog -skipextras -skipgames -skipstandalone -skipshared -skipgalaxy"
					$val = IniRead($inifle, "Current Download", "verylog", "")
					If $val = 1 Then $params = StringReplace($params, " -nolog", "")
					$val = IniRead($inifle, "Current Download", "veryextra", "")
					If $val = 1 Then $params = StringReplace($params, " -skipextras", "")
					$val = IniRead($inifle, "Current Download", "verygames", "")
					If $val = 4 Then
						$params = StringReplace($params, " -skipstandalone -skipshared -skipgalaxy", "")
					Else
						$params = StringReplace($params, " -skipgames", "")
						$val = IniRead($inifle, "Current Download", "veryalone", "")
						If $val = 1 Then $params = StringReplace($params, " -skipstandalone", "")
						$val = IniRead($inifle, "Current Download", "veryshare", "")
						If $val = 1 Then $params = StringReplace($params, " -skipshared", "")
						$val = IniRead($inifle, "Current Download", "verygalaxy", "")
						If $val = 1 Then $params = StringReplace($params, " -skipgalaxy", "")
					EndIf
				EndIf
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
										$OS = IniRead($downlist, $title, "OS", "")
										IniWrite($inifle, "Current Download", "OS", $OS)
										$lang = IniRead($downlist, $title, "language", "")
										IniWrite($inifle, "Current Download", "language", $lang)
										$params = " -os " & $OS & " -lang " & $lang & " -skipextras -skipgalaxy -skipstandalone -skipshared -nolog"
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
										$val = IniRead($downlist, $title, "skiplang", "")
										IniWrite($inifle, "Current Download", "skiplang", $val)
										If $val = 1 Then
											$val = IniRead($downlist, $title, "languages", "")
											If $val <> "" Then $params = $params & " -skiplang " & $val
										Else
											$val = ""
										EndIf
										IniWrite($inifle, "Current Download", "langskip", $val)
										;
										$val = IniRead($downlist, $title, "skipOS", "")
										IniWrite($inifle, "Current Download", "skipOS", $val)
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
									If $script = "fork" Then
										$val = IniRead($downlist, $title, "verylog", "")
										IniWrite($inifle, "Current Download", "verylog", $val)
										$val = IniRead($downlist, $title, "veryextra", "")
										IniWrite($inifle, "Current Download", "veryextra", $val)
										$val = IniRead($downlist, $title, "verygames", "")
										IniWrite($inifle, "Current Download", "verygames", $val)
										$val = IniRead($downlist, $title, "veryalone", "")
										IniWrite($inifle, "Current Download", "veryalone", $val)
										$val = IniRead($downlist, $title, "veryshare", "")
										IniWrite($inifle, "Current Download", "veryshare", $val)
										$val = IniRead($downlist, $title, "verygalaxy", "")
										IniWrite($inifle, "Current Download", "verygalaxy", $val)
									EndIf
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
	GUICtrlSetState($Item_check, $GUI_ENABLE)
	GUICtrlSetState($Item_remove, $GUI_ENABLE)
	GUICtrlSetState($Item_delete, $GUI_ENABLE)
	;GUICtrlSetState($Button_setup, $GUI_ENABLE)
	;GUICtrlSetState($Button_move, $GUI_ENABLE)
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
	GUICtrlSetState($Item_check, $GUI_ENABLE)
	GUICtrlSetState($Item_remove, $GUI_ENABLE)
	GUICtrlSetState($Item_delete, $GUI_ENABLE)
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
	If $tot = 0 And $total = 0 Then GUICtrlSetState($Button_removall, $GUI_DISABLE)
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
	If $script = "default" Then GUICtrlSetState($Pic_cover, $state)
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
		GUICtrlSetState($Checkbox_log, $state)
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
	;GUICtrlSetState($Button_move, $state)
	;
	GUICtrlSetState($Button_log, $state)
	GUICtrlSetState($Button_info, $state)
	GUICtrlSetState($Button_exit, $state)
EndFunc ;=> EnableDisableControls

Func EnableDisableCtrls($state)
	GUICtrlSetState($Ctrl_1, $state)
	GUICtrlSetState($Ctrl_2, $state)
	GUICtrlSetState($Ctrl_3, $state)
	GUICtrlSetState($Ctrl_4, $state)
	GUICtrlSetState($Ctrl_5, $state)
	GUICtrlSetState($Ctrl_6, $state)
	GUICtrlSetState($Ctrl_7, $state)
	GUICtrlSetState($Ctrl_8, $state)
	GUICtrlSetState($Ctrl_9, $state)
	GUICtrlSetState($Ctrl_10, $state)
	GUICtrlSetState($Ctrl_11, $state)
	GUICtrlSetState($Ctrl_12, $state)
	GUICtrlSetState($Ctrl_13, $state)
	GUICtrlSetState($Ctrl_14, $state)
	GUICtrlSetState($Ctrl_15, $state)
	GUICtrlSetState($Ctrl_16, $state)
	GUICtrlSetState($Ctrl_17, $state)
	GUICtrlSetState($Ctrl_18, $state)
	GUICtrlSetState($Ctrl_19, $state)
	GUICtrlSetState($Ctrl_20, $state)
	GUICtrlSetState($Ctrl_21, $state)
	GUICtrlSetState($Ctrl_22, $state)
EndFunc ;=> EnableDisableCtrls

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

Func FullComparisonCheck()
	Local $downchunk, $e, $entries, $extrachunk, $lead, $row, $rows, $skipped, $tail
	;
	$downchunk = ""
	$extrachunk = ""
	$skipped = ""
	$val = "fail"
	$succ = _FileReadToArray($titfile, $entries)
	If $succ = 1 Then
		For $e = 1 To $entries[0]
			$row = $entries[$e]
			$lead = StringLeft($row, 5)
			If StringInStr($row, "'forum_url':") > 0 Then $skipped = 1
			If $downchunk = "" Or ($extrachunk = "" And $downchunk = "") Or  ($lead <> "     " And ($downchunk <> "" Or $extrachunk <> "")) Or $skipped = 1 Then
				If StringInStr($row, "'downloads':") > 0 Then
					$downchunk = $row
				ElseIf StringInStr($row, "'extras':") > 0 Then
					$extrachunk = $row
				Else
					$succ = _ReplaceStringInFile($newfile, $row, "", 0, 0)
					If $succ = 0 Then
						If StringInStr($row, "'title':") > 0 Then
							$tail = StringReplace($row, "'}", "'},")
							$succ = _ReplaceStringInFile($newfile, $tail, "", 0, 0)
							If $succ = 0 Then
								$tail = StringReplace($row, "'},", "'}")
								$succ = _ReplaceStringInFile($newfile, $tail, "", 0, 0)
							EndIf
						EndIf
					EndIf
				EndIf
			ElseIf $downchunk <> "" And $extrachunk = "" Then
				$downchunk = $downchunk & @LF & $row
			ElseIf $extrachunk <> "" Then
				$extrachunk = $extrachunk & @LF & $row
			EndIf
		Next
		If $downchunk <> "" Then
			;MsgBox(262144, "Downloads", $downchunk)
			$succ = _ReplaceStringInFile($newfile, $downchunk, "", 0, 0)
			If $succ = 0 Then
				$chunk = StringSplit($downchunk, "{'", 1)
				For $e = 2 To $chunk[0]
					$rows = "{'" & $chunk[$e]
					$succ = _ReplaceStringInFile($newfile, $rows, "", 0, 0)
					If $succ = 0 Then
						$rows = StringStripWS($rows, 3)
						$rows = StringReplace($rows, "'},", "'}],")
						$succ = _ReplaceStringInFile($newfile, $rows, "", 0, 0)
						If $succ = 0 Then
							$rows = StringReplace($rows, "'}],", "'},")
							$succ = _ReplaceStringInFile($newfile, $rows, "", 0, 0)
							If $succ = 0 Then
								$rows = StringReplace($rows, "},", "}],")
								$succ = _ReplaceStringInFile($newfile, $rows, "", 0, 0)
								If $succ = 0 Then
									$rows = StringReplace($rows, "}],", "},")
									_ReplaceStringInFile($newfile, $rows, "", 0, 0)
								EndIf
							EndIf
						EndIf
					EndIf
				Next
			EndIf
		EndIf
		If $extrachunk <> "" Then
			;MsgBox(262144, "Extras", $extrachunk)
			$succ = _ReplaceStringInFile($newfile, $extrachunk, "", 0, 0)
			If $succ = 0 Then
				$chunk = StringSplit($extrachunk, "{'", 1)
				For $e = 2 To $chunk[0]
					$rows = "{'" & $chunk[$e]
					$succ = _ReplaceStringInFile($newfile, $rows, "", 0, 0)
					If $succ = 0 Then
						$rows = StringStripWS($rows, 3)
						$rows = StringReplace($rows, "'},", "'}],")
						$succ = _ReplaceStringInFile($newfile, $rows, "", 0, 0)
						If $succ = 0 Then
							$rows = StringReplace($rows, "'}],", "'},")
							$succ = _ReplaceStringInFile($newfile, $rows, "", 0, 0)
							If $succ = 0 Then
								$rows = StringReplace($rows, "},", "}],")
								$succ = _ReplaceStringInFile($newfile, $rows, "", 0, 0)
								If $succ = 0 Then
									$rows = StringReplace($rows, "}],", "},")
									_ReplaceStringInFile($newfile, $rows, "", 0, 0)
								EndIf
							EndIf
						EndIf
					EndIf
				Next
			EndIf
		EndIf
		$lines = _FileCountLines($newfile)
		If $lines > 0 Then
			$succ = _FileReadToArray($newfile, $entries)
			If $succ = 1 Then
				For $e = 1 To $entries[0]
					$row = $entries[$e]
					If StringInStr($row, "'rating':") > 0 Or StringInStr($row, "'forum_url':") > 0 _
						Or StringInStr($row, "'has_updates': False") > 0 Then
						$succ = _ReplaceStringInFile($newfile, $row, "", 0, 0)
					EndIf
				Next
				$succ = _FileReadToArray($newfile, $entries)
				If $succ = 1 Then
					$rows = ""
					For $e = 1 To $entries[0]
						$row = $entries[$e]
						If $row <> "" Then
							If $rows = "" Then
								$rows = $row
							Else
								$rows = $rows & @LF & $row
							EndIf
						EndIf
					Next
					$file = FileOpen($newfile, 2)
					FileWrite($file, $rows)
					FileClose($file)
					$lines = _FileCountLines($newfile)
					If $lines < 1 Then
						FileDelete($titfile)
						FileDelete($newfile)
						$val = "pass"
					ElseIf $lines = 1 Then
						_ReplaceStringInFile($newfile, "  'downloads': [", "", 0, 0)
						_ReplaceStringInFile($newfile, "{'", "", 0, 1)
						$lines = _FileCountLines($newfile)
						If $lines < 1 Then
							FileDelete($titfile)
							FileDelete($newfile)
							$val = "pass"
						EndIf
					EndIf
				EndIf
			EndIf
		Else
			FileDelete($titfile)
			FileDelete($newfile)
			$val = "pass"
		EndIf
	EndIf
	Return $val
EndFunc ;=> FullComparisonCheck

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
				MsgBox(262192, "Script Change", $change & " has changed for 'gogrepo.py'." _
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

Func ParseTheManifest($show)
	If FileExists($manifest) Then
		If $show = 1 Then SplashTextOn("", "Please Wait!", 200, 120, Default, Default, 33)
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
		If $show = 1 Then SplashOff()
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
