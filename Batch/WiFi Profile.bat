@echo off
cls
color 02
echo Program Started

@REM Apache License, version 2

@REM Copyright 2021 nico-castell

@REM Licensed under the Apache License, Version 2.0 (the "License");
@REM you may not use this file except in compliance with the License.
@REM You may obtain a copy of the License at

@REM    http://www.apache.org/licenses/LICENSE-2.0

@REM Unless required by applicable law or agreed to in writing, software
@REM distributed under the License is distributed on an "AS IS" BASIS,
@REM WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@REM See the License for the specific language governing permissions and
@REM limitations under the License.

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
