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
; MainGUI(), QueueGUI(), SetupGUI()
; FillTheGamesList(), ParseTheManifest()

#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <ListBoxConstants.au3>
#include <StaticConstants.au3>
#include <GuiListBox.au3>
#include <GuiComboBox.au3>
#include <Misc.au3>
#include <File.au3>
#include <Date.au3>
#include <Array.au3>

_Singleton("gog-repo-gui-timboli")

Global $Group_games, $List_games

Global $a, $ans, $array, $bigpic, $blackjpg, $c, $check, $chunk, $chunks, $cookies, $date, $extras, $file, $game
Global $games, $gamesfle, $gogrepo, $GOGRepoGUI, $icoD, $icoF, $icoI, $icoX, $image, $imgfle, $infofle, $inifle
Global $line, $lines, $logfle, $manifest, $name, $open, $OS, $read, $res, $segment, $shell, $split, $text
Global $textdump, $title, $titlist, $user, $version

$bigpic = @ScriptDir & "\Big.jpg"
$blackjpg = @ScriptDir & "\Black.jpg"
$cookies = @ScriptDir & "\gog-cookies.dat"
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
	Local $Button_dest, $Button_down, $Button_exit, $Button_fold, $Button_info, $Button_log, $Button_more
	Local $Button_pic, $Button_queue, $Button_setup, $Button_update, $Checkbox_all, $Checkbox_alpha, $Checkbox_cover
	Local $Checkbox_every, $Checkbox_extra, $Checkbox_linux, $Checkbox_show, $Checkbox_test, $Checkbox_verify, $Checkbox_win
	Local $Combo_OS, $Group_cover, $Group_dest, $Input_extra, $Input_name, $Input_OS, $Label_cover, $Label_extra
	Local $Label_OS, $Label_title, $Pic_cover
	;
	Local $all, $alpha, $cover, $dll, $every, $exstyle, $extras, $gamefold, $gamepic, $gamesfold
	Local $height, $lang, $langs, $left, $let, $mpos, $OSes, $OSget
	Local $pid, $pth, $show, $style, $top, $val, $validate, $verify, $width, $xpos, $ypos
	;
	$width = 590
	$height = 405
	$left = IniRead($inifle, "Program Window", "left", @DesktopWidth - $width - 25)
	$top = IniRead($inifle, "Program Window", "top", @DesktopHeight - $height - 30)
	$style = $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU + $WS_VISIBLE + $WS_CLIPSIBLINGS + $WS_MINIMIZEBOX
	$exstyle = $WS_EX_TOPMOST
	$GOGRepoGUI = GuiCreate("GOGRepo GUI", $width, $height, $left, $top, $style, $exstyle)
	GUISetBkColor($COLOR_SKYBLUE, $GOGRepoGUI)
	; CONTROLS
	$Group_games = GuiCtrlCreateGroup("Games", 10, 10, 370, 323)
	$List_games = GuiCtrlCreateList("", 20, 30, 350, 220)
	GUICtrlSetTip($List_games, "List of games!")
	$Input_name = GUICtrlCreateInput("", 20, 250, 350, 20)
	GUICtrlSetTip($Input_name, "Game Name!")
	$Label_title = GuiCtrlCreateLabel("Title", 20, 275, 40, 20, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_title, $COLOR_BLUE)
	GUICtrlSetColor($Label_title, $COLOR_WHITE)
	GUICtrlSetFont($Label_title, 7, 600, 0, "Small Fonts")
	$Input_title = GUICtrlCreateInput("", 60, 275, 310, 20) ;, $ES_READONLY
	GUICtrlSetTip($Input_title, "Game Title!")
	$Label_OS = GuiCtrlCreateLabel("OS", 20, 300, 30, 20, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_OS, $COLOR_BLACK)
	GUICtrlSetColor($Label_OS, $COLOR_WHITE)
	GUICtrlSetFont($Label_OS, 7, 600, 0, "Small Fonts")
	$Input_OS = GUICtrlCreateInput("", 50, 300, 130, 20, $ES_READONLY)
	GUICtrlSetTip($Input_OS, "OS files available!")
	$Label_extra = GuiCtrlCreateLabel("Extras", 190, 300, 50, 20, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_extra, $COLOR_MAROON)
	GUICtrlSetColor($Label_extra, $COLOR_WHITE)
	GUICtrlSetFont($Label_extra, 7, 600, 0, "Small Fonts")
	$Input_extra = GUICtrlCreateInput("", 240, 300, 70, 20, $ES_READONLY)
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
	$Group_down = GuiCtrlCreateGroup("", 450, 175, 65, 51)
	$Button_down = GuiCtrlCreateButton("Down" & @LF & "One", 390, 180, 67, 48, $BS_MULTILINE)
	GUICtrlSetFont($Button_down, 9, 600)
	GUICtrlSetTip($Button_down, "Download the selected game!")
	$Checkbox_verify = GUICtrlCreateCheckbox("Verify", 462, 186, 45, 18)
	GUICtrlSetFont($Checkbox_verify, 8, 400)
	GUICtrlSetTip($Checkbox_verify, "Enable verifying one or all games!")
	$Checkbox_all = GUICtrlCreateCheckbox("ALL", 462, 204, 35, 18)
	GUICtrlSetFont($Checkbox_all, 8, 400)
	GUICtrlSetTip($Checkbox_all, "Process one or ALL games!")
	;
	$Button_queue = GuiCtrlCreateButton("VIEW" & @LF & "QUEUE", 522, 180, 58, 48, $BS_MULTILINE)
	GUICtrlSetFont($Button_queue, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_queue, "View the download queue!")
	;
	$Group_opts = GuiCtrlCreateGroup("Download Options", 390, 232, 190, 66)
	$Combo_OS = GUICtrlCreateCombo("", 400, 248, 110, 21)
	GUICtrlSetTip($Combo_OS, "OS to download files for!")
	$Checkbox_extra = GUICtrlCreateCheckbox("Extras", 521, 248, 55, 21)
	GUICtrlSetTip($Checkbox_extra, "Download game extras files!")
	$Checkbox_test = GUICtrlCreateCheckbox("Verify", 400, 272, 45, 20)
	GUICtrlSetTip($Checkbox_test, "Verify integrity of downloaded files!")
	$Checkbox_cover = GUICtrlCreateCheckbox("Download the cover", 455, 272, 115, 20)
	GUICtrlSetTip($Checkbox_cover, "Download the cover image files!")
	;
	$Button_setup = GuiCtrlCreateButton("SETUP", $width - 200, $height - 100, 60, 30)
	GUICtrlSetFont($Button_setup, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_setup, "Setup username and password!")
	;
	;$Button_update = GuiCtrlCreateButton("UPDATE MANIFEST", $width - 130, $height - 100, 120, 30)
	$Button_update = GuiCtrlCreateButton("Update", $width - 130, $height - 100, 77, 30)
	GUICtrlSetFont($Button_update, 9, 600)
	GUICtrlSetTip($Button_update, "Update the manifest!")
	$Checkbox_every = GUICtrlCreateCheckbox("ALL", $width - 48, $height - 95, 35, 20)
	GUICtrlSetTip($Checkbox_every, "Update one or ALL games!")
	;
	$Group_dest = GuiCtrlCreateGroup("Download Destination - Games Folder", 10, $height - 63, 336, 52)
	$Input_dest = GUICtrlCreateInput("", 20, $height - 43, 240, 20)
	GUICtrlSetTip($Input_dest, "Destination path (main parent folder for games)!")
	$Button_dest = GuiCtrlCreateButton("B", 265, $height - 43, 20, 20, $BS_ICON)
	GUICtrlSetTip($Button_dest, "Browse to set the destination folder!")
	$Checkbox_alpha = GUICtrlCreateCheckbox("Alpha", 291, $height - 43, 45, 20)
	GUICtrlSetTip($Checkbox_alpha, "Create alphanumeric sub-folder!")
	;
	$Button_fold = GuiCtrlCreateButton("Open", $width - 234, $height - 60, 50, 50, $BS_ICON)
	GUICtrlSetTip($Button_fold, "Open the selected destination folder!")
	;
	$Button_log = GuiCtrlCreateButton("LOG", $width - 176, $height - 60, 50, 50)
	GUICtrlSetFont($Button_log, 7, 600, 0, "Small Fonts")
	GUICtrlSetTip($Button_log, "View the record log file!")
	;
	$Button_info = GuiCtrlCreateButton("Info", $width - 118, $height - 60, 50, 50, $BS_ICON)
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
	$icoX = -4
	GUICtrlSetImage($Button_dest, $shell, $icoF, 0)
	GUICtrlSetImage($Button_fold, $shell, $icoD, 1)
	GUICtrlSetImage($Button_info, $user, $icoI, 1)
	GUICtrlSetImage($Button_exit, $user, $icoX, 1)
	;
	; SETTINGS
	GuiSetState(@SW_DISABLE, $GOGRepoGUI)
	;
	If Not FileExists($cookies) Then
		GUICtrlSetState($Button_down, $GUI_DISABLE)
		GUICtrlSetState($Button_update, $GUI_DISABLE)
	EndIf
	If Not FileExists($manifest) Then
		GUICtrlSetState($Button_more, $GUI_DISABLE)
		GUICtrlSetState($Button_pic, $GUI_DISABLE)
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
		;$langs = IniRead($inifle, "Download Options", "languages", "")
		;If $langs = "" Then
		;	$langs = "de|en|fr"
		;	IniWrite($inifle, "Download Options", "languages", $langs)
		;EndIf
	EndIf
	;
	FillTheGamesList()
	;
	$all = 4
	$every = 4
	$verify = 4


	GuiSetState(@SW_ENABLE, $GOGRepoGUI)
	While 1
		$msg = GuiGetMsg()
		Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Button_exit
			; Exit / Close / Quit the program
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
			;
			GUIDelete($GOGRepoGUI)
			ExitLoop
		Case $msg = $Button_update
			; Update the manifest
			If FileExists($gogrepo) Then
				GUISetState(@SW_DISABLE, $GOGRepoGUI)
				$OSget = GUICtrlRead($Combo_OS)
				$OS = StringReplace($OSget, " + ", " ")
				$OS = StringLower($OS)
				FileChangeDir(@ScriptDir)
				If $every = 1 Then
					$pid = RunWait(@ComSpec & ' /k gogrepo.py update -os ' & $OS & ' -lang ' & $lang, @ScriptDir)
					_FileWriteLog($logfle, "Updated manifest for all games.")
				Else
					$title = GUICtrlRead($Input_title)
					If $title <> "" Then
						$pid = RunWait(@ComSpec & ' /k gogrepo.py update -os ' & $OS & ' -lang ' & $lang & ' -id ' & $title, @ScriptDir)
						_FileWriteLog($logfle, "Updated manifest for - " & $title & ".")
					Else
						MsgBox(262192, "Game Error", "Title is not selected!", 0, $GOGRepoGUI)
						ContinueLoop
					EndIf
				EndIf
				GUICtrlSetData($List_games, "")
				GUICtrlSetData($Input_name, "")
				GUICtrlSetData($Input_title, "")
				GUICtrlSetData($Input_OS, "")
				GUICtrlSetData($Input_extra, "")
				_FileCreate($titlist)
				ParseTheManifest()
				FillTheGamesList()
				GUISetState(@SW_ENABLE, $GOGRepoGUI)
			EndIf
		Case $msg = $Button_setup
			; Setup username and password
			SetupGUI()
		Case $msg = $Button_queue
			; View the download queue
			QueueGUI()
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
								;MsgBox(262208, "Game Information From Manifest - " & $title, $chunk, 0, $GOGRepoGUI)
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
				"© June 2020 - GOGRepo GUI created by Timboli.", 0, $GOGRepoGUI)
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
		Case $msg = $Button_down
			; Download the selected game
			If FileExists($gogrepo) Then
				$title = GUICtrlRead($Input_title)
				If $title <> "" Or $all = 1 Then
					$gamefold = $gamesfold
					If $all = 4 Then
						;MsgBox(262192, "Got Here 1", $title & @LF & $gamefold, 0, $GOGRepoGUI)
						If $alpha = 1 Then
							$let = StringUpper(StringLeft($title, 1))
							$gamefold = $gamefold & "\" & $let
							;MsgBox(262192, "Got Here 2", $title & @LF & $gamefold, 0, $GOGRepoGUI)
						EndIf
					EndIf
					If Not FileExists($gamefold) And $verify = 4 Then
						DirCreate($gamefold)
					EndIf
					If FileExists($gamefold) Then
						;MsgBox(262192, "Game Folder", $title & @LF & $gamefold, 0, $GOGRepoGUI)
						GUISetState(@SW_DISABLE, $GOGRepoGUI)
						FileChangeDir(@ScriptDir)
						If $verify = 1 Then
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
													"folder games?", 0, $GOGRepoGUI)
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
						Else
							If $all = 1 Then
								$pid = RunWait(@ComSpec & ' /c gogrepo.py download "' & $gamefold & '"', @ScriptDir)
								If $validate = 1 Then $pid = RunWait(@ComSpec & ' /k gogrepo.py verify "' & $gamefold & '"', @ScriptDir)
								_FileWriteLog($logfle, "Downloaded all games.")
							Else
								$pid = RunWait(@ComSpec & ' /c gogrepo.py download -id ' & $title & ' "' & $gamefold & '"', @ScriptDir)
								If $validate = 1 Then $pid = RunWait(@ComSpec & ' /k gogrepo.py verify -id ' & $title & ' "' & $gamefold & '"', @ScriptDir)
								_FileWriteLog($logfle, "Downloaded - " & $title & ".")
								If $cover = 1 Then
									$name = GUICtrlRead($Input_name)
									If $name <> "" Then
										$image = IniRead($gamesfle, $name, "image", "")
										If $image <> "" Then
											SplashTextOn("", "Saving!", 200, 120, Default, Default, 33)
											$gamepic = $gamefold & "\" & $title & "\Folder.jpg"
											InetGet($image, $gamepic, 1, 0)
											SplashOff()
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
						GUISetState(@SW_ENABLE, $GOGRepoGUI)
					Else
						MsgBox(262192, "Path Error", "Game folder not found!", 0, $GOGRepoGUI)
					EndIf
				Else
					MsgBox(262192, "Game Error", "Title is not selected!", 0, $GOGRepoGUI)
				EndIf
			Else
				MsgBox(262192, "Program Error", "Required gogrepo.py not found!", 0, $GOGRepoGUI)
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
			Else
				$verify = 4
				If $all = 1 Then
					$buttitle = "Down" & @LF & "ALL"
					GUICtrlSetTip($Button_down, "Download ALL games!")
				Else
					$buttitle = "Down" & @LF & "One"
					GUICtrlSetTip($Button_down, "Download the selected game!")
				EndIf
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
		Case $msg = $Checkbox_extra
			; Download game extras files
			If GUICtrlRead($Checkbox_extra) = $GUI_CHECKED Then
				$extras = 1
			Else
				$extras = 4
			EndIf
			IniWrite($inifle, "Download Options", "extras", $extras)
		Case $msg = $Checkbox_every
			; Update one or ALL games
			If GUICtrlRead($Checkbox_every) = $GUI_CHECKED Then
				$every = 1
			Else
				$every = 4
			EndIf
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
				Else
					$buttitle = "Down" & @LF & "ALL"
					GUICtrlSetTip($Button_down, "Download ALL games!")
				EndIf
			Else
				$all = 4
				If $verify = 1 Then
					$buttitle = "Verify" & @LF & "One"
					GUICtrlSetTip($Button_down, "Verify the selected game!")
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
			; Open the selected Calibre Library folder
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

Func QueueGUI()
EndFunc ;=> QueueGUI

Func SetupGUI()
	; Script generated by GUIBuilder Prototype 0.9
	Local $Button_close, $Button_cookie, $Button_install, $Input_pass, $Input_user, $Label_info, $Label_pass, $Label_user
	;
	Local $password, $SetupGUI, $username
	;
	$SetupGUI = GuiCreate("Python & Cookie Setup", 230, 355, Default, Default, $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU _
											+ $WS_VISIBLE + $WS_CLIPSIBLINGS, $WS_EX_TOPMOST, $GOGRepoGUI)
	;
	; CONTROLS
	$Label_info = GuiCtrlCreateLabel("Before using gogrepo.py to download your" _
		& @LF & "games, update etc, you need a cookie file." & @LF _
		& @LF & "You also need html5lib installed in Python." & @LF _
		& @LF & "Both require an active web connection." & @LF _
		& @LF & "Please supply your username (or email) and" _
		& @LF & "password, to have it create a cookie file to" _
		& @LF & "use with GOG." & @LF _
		& @LF & "GOGRepo GUI does not store that detail.", 13, 10, 210, 155)
	;
	$Button_install = GuiCtrlCreateButton("INSTALL html5lib && html2text", 10, 175, 210, 50)
	GUICtrlSetFont($Button_install, 9, 600)
	GUICtrlSetTip($Button_install, "Install html5lib & html2text in Python!")
	;
	$Label_user = GuiCtrlCreateLabel("User or Email", 10, 235, 75, 20, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_user, $COLOR_BLACK)
	GUICtrlSetColor($Label_user, $COLOR_WHITE)
	$Input_user = GuiCtrlCreateInput("", 85, 235, 135, 20)
	GUICtrlSetTip($Input_user, "Username or Email to access your GOG game library!")
	;
	$Label_pass = GuiCtrlCreateLabel("Password", 10, 265, 60, 20, $SS_CENTER + $SS_CENTERIMAGE + $SS_SUNKEN)
	GUICtrlSetBkColor($Label_pass, $COLOR_BLACK)
	GUICtrlSetColor($Label_pass, $COLOR_WHITE)
	$Input_pass = GuiCtrlCreateInput("", 70, 265, 150, 20)
	GUICtrlSetTip($Input_pass, "Password to access your GOG game library!")
	;
	$Button_cookie = GuiCtrlCreateButton("CREATE COOKIE", 10, 295, 140, 50)
	GUICtrlSetFont($Button_cookie, 9, 600)
	GUICtrlSetTip($Button_cookie, "Create or Update the cookie file!")
	;
	$Button_close = GuiCtrlCreateButton("EXIT", 160, 295, 60, 50, $BS_ICON)
	GUICtrlSetTip($Button_close, "Exit / Close / Quit the window!")
	;
	; SETTINGS
	GUICtrlSetImage($Button_close, $user, $icoX, 1)


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
			$pid = RunWait(@ComSpec & ' /k pip install html5lib html2text', "")
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
							$pid = RunWait(@ComSpec & ' /k gogrepo.py login ' & $username & ' ' & $password, @ScriptDir)
							$username = ""
							$password = ""
						Else
							MsgBox(262192, "Cookie Error", "Password field is blank!", 0, $SetupGUI)
						EndIf
					Else
						MsgBox(262192, "Cookie Error", "User or Email field is blank!", 0, $SetupGUI)
					EndIf
				EndIf
			Else
				MsgBox(262192, "Program Error", "Required gogrepo.py not found!", 0, $SetupGUI)
			EndIf
		Case Else
			;;;
		EndSelect
	WEnd
EndFunc ;=> SetupGUI


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

