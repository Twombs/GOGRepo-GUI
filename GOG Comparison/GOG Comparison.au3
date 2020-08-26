#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include <File.au3>
#include <Array.au3>

Local $a, $array, $b, $chunk, $cnt, $downchunk, $extrachunk, $f, $file, $file_1, $file_2
Local $filelist, $last, $line, $lines, $res, $skipped

;$file_1 = @ScriptDir & "\60_parsecs.txt"
;$file_2 = @ScriptDir & "\60_parsecs_new.txt"
;$file_1 = @ScriptDir & "\aer.txt"
;$file_2 = @ScriptDir & "\aer_new.txt"
$filelist = _FileListToArray(@ScriptDir, "*_new.txt", 1, True)
If @error = 0 Then
	For $f = 1 To $filelist[0]
		$file_2 = $filelist[$f]
		$file_1 = StringReplace($file_2, "_new.txt", ".txt")
		$downchunk = ""
		$extrachunk = ""
		$skipped = ""
		$res = _FileReadToArray($file_1, $array)
		If $res = 1 Then
			SplashTextOn("", "Comparing Files!", 200, 100, Default, Default, 33)
			For $a = 1 To $array[0]
				$line = $array[$a]
				$start = StringLeft($line, 5)
				If StringInStr($line, "'forum_url':") > 0 Then $skipped = 1
				;If $downchunk = "" Or $extrachunk = "" Or ($downchunk <> "" And $start <> "     ") Or ($extrachunk <> "" And $start <> "     ") Then
				If $downchunk = "" Or ($extrachunk = "" And $downchunk = "") Or  ($start <> "     " And ($downchunk <> "" Or $extrachunk <> "")) Or $skipped = 1 Then
					If StringInStr($line, "'downloads':") > 0 Then
						$downchunk = $line
					ElseIf StringInStr($line, "'extras':") > 0 Then
						$extrachunk = $line
					Else
						$res = _ReplaceStringInFile($file_2, $line, "", 0, 0)
						If $res = 0 Then
							If StringInStr($line, "'title':") > 0 Then
								$last = StringReplace($line, "'}", "'},")
								$res = _ReplaceStringInFile($file_2, $last, "", 0, 0)
								If $res = 0 Then
									$last = StringReplace($line, "'},", "'}")
									$res = _ReplaceStringInFile($file_2, $last, "", 0, 0)
								EndIf
							EndIf
						EndIf
					EndIf
				ElseIf $downchunk <> "" And $extrachunk = "" Then
					$downchunk = $downchunk & @LF & $line
				ElseIf $extrachunk <> "" Then
					$extrachunk = $extrachunk & @LF & $line
				EndIf
			Next
			If $downchunk <> "" Then
				;MsgBox(262144, "Downloads", $downchunk)
				$res = _ReplaceStringInFile($file_2, $downchunk, "", 0, 0)
				If $res = 0 Then
					$chunk = StringSplit($downchunk, "{'", 1)
					For $a = 2 To $chunk[0]
						$lines = "{'" & $chunk[$a]
						$res = _ReplaceStringInFile($file_2, $lines, "", 0, 0)
						If $res = 0 Then
							$lines = StringStripWS($lines, 3)
							$lines = StringReplace($lines, "'},", "'}],")
							$res = _ReplaceStringInFile($file_2, $lines, "", 0, 0)
							If $res = 0 Then
								$lines = StringReplace($lines, "'}],", "'},")
								$res = _ReplaceStringInFile($file_2, $lines, "", 0, 0)
								If $res = 0 Then
									$lines = StringReplace($lines, "},", "}],")
									$res = _ReplaceStringInFile($file_2, $lines, "", 0, 0)
									If $res = 0 Then
										$lines = StringReplace($lines, "}],", "},")
										_ReplaceStringInFile($file_2, $lines, "", 0, 0)
									EndIf
								EndIf
							EndIf
						EndIf
					Next
				EndIf
			EndIf
			If $extrachunk <> "" Then
				;MsgBox(262144, "Extras", $extrachunk)
				$res = _ReplaceStringInFile($file_2, $extrachunk, "", 0, 0)
				If $res = 0 Then
					$chunk = StringSplit($extrachunk, "{'", 1)
					For $a = 2 To $chunk[0]
						$lines = "{'" & $chunk[$a]
						$res = _ReplaceStringInFile($file_2, $lines, "", 0, 0)
						If $res = 0 Then
							$lines = StringStripWS($lines, 3)
							$lines = StringReplace($lines, "'},", "'}],")
							$res = _ReplaceStringInFile($file_2, $lines, "", 0, 0)
							If $res = 0 Then
								$lines = StringReplace($lines, "'}],", "'},")
								$res = _ReplaceStringInFile($file_2, $lines, "", 0, 0)
								If $res = 0 Then
									$lines = StringReplace($lines, "},", "}],")
									$res = _ReplaceStringInFile($file_2, $lines, "", 0, 0)
									If $res = 0 Then
										$lines = StringReplace($lines, "}],", "},")
										_ReplaceStringInFile($file_2, $lines, "", 0, 0)
									EndIf
								EndIf
							EndIf
						EndIf
					Next
				EndIf
			EndIf
			$cnt = _FileCountLines($file_2)
			If $cnt > 0 Then
				$res = _FileReadToArray($file_2, $array)
				If $res = 1 Then
					For $a = 1 To $array[0]
						$line = $array[$a]
						If StringInStr($line, "'rating':") > 0 Or StringInStr($line, "'forum_url':") > 0 _
							Or StringInStr($line, "'has_updates': False") > 0 Then
							$res = _ReplaceStringInFile($file_2, $line, "", 0, 0)
						EndIf
					Next
					$res = _FileReadToArray($file_2, $array)
					If $res = 1 Then
						$lines = ""
						For $a = 1 To $array[0]
							$line = $array[$a]
							If $line <> "" Then
								If $lines = "" Then
									$lines = $line
								Else
									$lines = $lines & @LF & $line
								EndIf
							EndIf
						Next
						$file = FileOpen($file_2, 2)
						FileWrite($file, $lines)
						FileClose($file)
						$cnt = _FileCountLines($file_2)
						If $cnt < 1 Then
							FileDelete($file_1)
							FileDelete($file_2)
						ElseIf $cnt = 1 Then
							_ReplaceStringInFile($file_2, "  'downloads': [", "", 0, 0)
							_ReplaceStringInFile($file_2, "{'", "", 0, 1)
							$cnt = _FileCountLines($file_2)
							If $cnt < 1 Then
								FileDelete($file_1)
								FileDelete($file_2)
							EndIf
						EndIf
					EndIf
				EndIf
			Else
				FileDelete($file_1)
				FileDelete($file_2)
			EndIf
			SplashOff()
		EndIf
	Next
EndIf

Exit
