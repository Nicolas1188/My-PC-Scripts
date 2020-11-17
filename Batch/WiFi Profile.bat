@echo off
cls
color 02
echo Program Started

@REM MIT License

@REM Copyright (c) 2020 Nicolas1188

@REM Permission is hereby granted, free of charge, to any person obtaining a copy
@REM of this software and associated documentation files (the "Software"), to deal
@REM in the Software without restriction, including without limitation the rights
@REM to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
@REM copies of the Software, and to permit persons to whom the Software is
@REM furnished to do so, subject to the following conditions:

@REM The above copyright notice and this permission notice shall be included in all
@REM copies or substantial portions of the Software.

@REM THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
@REM IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
@REM FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
@REM AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
@REM LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
@REM OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
@REM SOFTWARE.

:start
echo What do you wish to do?
echo "View profiles (V) / Export profile (E) / Add Profile (A) / Remove profile (R)"
choice /c VEAR /n /m ">"
If %errorlevel% == 1 cls && set chapter=viewProfile
If %errorlevel% == 2 cls && set chapter=exportProfile
If %errorlevel% == 3 cls && goto addProfile
If %errorlevel% == 4 cls && set chapter=removeProfile
cls

:chooseProfile
netsh wlan show profiles
echo.
echo ================================================================
echo ================================================================
echo.
set /p prof="Choose Profile: "
cls

goto %chapter%

:viewProfile
netsh wlan show profile name="%prof%" key=clear
echo.
pause
cls
echo Do you wish to see another one? (Y/N)
choice /c YN /n /m "> "
If %errorlevel% == 1 goto chooseProfile
If %errorlevel% == 3 goto ending

:exportProfile
echo Export a single profile (S) / Export all profiles (A)
choice /c SA /n /m ">"
If %errorlevel% == 1 goto oneProfile
If %errorlevel% == 2 goto allProfiles

	:oneProfile
	netsh wlan export profile name="%prof%" folder=%userprofile%\Documents key=clear
	echo.
	pause
	cls
	echo Do you wish to export another one? (Y/N)
	choice /c YN /n /m "> "
	If %errorlevel% == 1 goto chooseProfile
	If %errorlevel% == 2 goto ending

	:allProfiles
	netsh wlan export profile folder=%userprofile%\Documents key=clear
	echo.
	pause
	goto ending

:addProfile
echo Type the directory and .xml file or drag the file here
set /P fileName="> "
echo "All users (A) / Current user (C)"
choice /c AC /n /m ">"
If %errorlevel% == 1 netsh wlan add profile filename=%fileName%
If %errorlevel% == 2 netsh wlan add profile filename=%fileName% user=current

echo.
pause
cls
echo Do you wish to add another one? (Y/N)
choice /c YN /n /m "> "
If %errorlevel% == 1 goto addProfile
If %errorlevel% == 2 goto ending

:removeProfile
netsh wlan delete profile name="%prof%"
echo.
pause
cls
echo Do you wish to remove another one? (Y/N)
choice /c YN /n /m "> "
If %errorlevel% == 1 goto chooseProfile
If %errorlevel% == 2 goto ending

:ending
cls
echo Do you wish to restart the program?
choice /c YN /n /m "(Y/N)> "
If %errorlevel% == 1 cls && goto start
If %errorlevel% == 2 cls && color && exit /b
