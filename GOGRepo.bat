@echo off

goto INSTALL

:INSTALL
rem Installs required HTML5 library and optional text improvement.
pip install html5lib html2text
goto END

:LOGIN
rem Creates a cookie file.
gogrepo.py login email password
goto END

:UPDATEALL
rem Creates a manifest of all files for Windows and Linux.
gogrepo.py update -os windows linux -lang en
goto END

:UPDATEWIN
rem Creates a manifest of all files for Windows only.
gogrepo.py update -os windows -lang en
goto END

:UPDATELIN
rem Creates a manifest of all files for Linux only.
gogrepo.py update -os linux -lang en
goto END

:UPDATEONE
rem Creates or Updates the manifest of all files for Windows and Linux for one game (aer) only.
gogrepo.py update -os windows linux -lang en -id aer
goto END

:DOWNALL
rem Downloads all games listed in the manifest to a parent folder called GAMES.
gogrepo.py download GAMES
rem Verifies with checksums (if they exist) all downloads in the GAMES folder.
gogrepo.py verify "D:/Projects/GOGRepo GUI/GAMES/"
goto END

:DOWNONE
rem Download one game (aer) listed in the manifest to a parent folder called GAMES.
gogrepo.py download -id aer GAMES
rem Verifies with checksums (if they exist) that one (aer) game download.
gogrepo.py verify -id aer "D:/Projects/GOGRepo GUI/GAMES/"
goto END

:VERIFYONE
rem Verifies with checksums (if they exist) the one (aer) game download.
gogrepo.py verify -id aer "D:/Projects/GOGRepo GUI/GAMES/"
goto END

:HELP
gogrepo.py -h
goto END

:END
pause
cls
exit
