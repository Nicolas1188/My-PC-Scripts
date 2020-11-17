@echo off
title Office Key Manager
color 03
cd "%systemDrive%\Program Files\Microsoft Office\Office16"

net session > nul 2>&1
If %errorlevel% == 0 (
	goto start
) else (
	echo Requesting administrative privileges...
	echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
	echo UAC.ShellExecute "cmd.exe", "/c %~s0 %~1", "", "runas", 1 >> "%temp%\getadmin.vbs"
	"%temp%\getadmin.vbs"
	del "%temp%\getadmin.vbs"
	exit /b
)

REM ==============================================================================================
REM Start Process

:start
cls
echo Program Started
echo.
:startMenu
echo What of the following tasks to do you want to do?
echo Activate Office (A) / Install a key (I) / Uninstall keys (U) / MSGuides Installation (M) / View Installed Keys (V)

choice /n /c AIUMV /m ">"
If %errorlevel% == 1 goto activate
If %errorlevel% == 2 goto install
If %errorlevel% == 3 goto uninstall
If %errorlevel% == 4 goto MSGuidesInstall
If %errorlevel% == 5 cscript ospp.vbs /dstatus | findstr /C:"Last 5 characters" & echo. & goto startMenu

REM ==============================================================================================
REM Activation Process

:activate
cls
choice /c YN /n /m "Are you sure you want to activate? (Y/N) >"
If %errorlevel% == 2 goto start

echo.
echo Attempting activation...
echo.
cscript ospp.vbs /act >nul

cscript ospp.vbs /dstatus | findstr /C:"REMAINING GRACE" >nul
If %errorlevel% == 0 (
	echo Activation Successful
) else (
	echo Activation failed
)

pause >nul
goto ending

REM ==============================================================================================
REM Installation Process

:install
cls
echo Please write your product key below with the dashes "-"
set /p OfficeKey=">"
echo.

echo Installing your license...
cscript ospp.vbs /inpkey:%OfficeKey% >nul | findstr "successful" >nul
If %errorlevel% == 0 echo Installation successful
echo.

choice /n /c YN /m "Do you wish to activate the license now? (Y/N) >"
If %errorlevel% == 1 goto activate
If %errorlevel% == 2 goto ending

pause >nul
goto ending

REM ==============================================================================================
REM Unistallation Process

:uninstall
cls
echo Please wait...
echo.

cscript ospp.vbs /dstatus | findstr /C:"Last 5 characters"
echo.

set /p UninstallKey="Which key do you want to uninstall? >"
echo.
echo Uninstalling...
echo.
cscript ospp.vbs /unpkey:%UninstallKey% | findstr "successful" >nul
If %errorlevel% == 0 echo Uninstall successful
echo.

choice /n /c IU /m "Do you want to install another license now? Or do you want to keep uninstalling? (I/U) >"
If %errorlevel% == 1 goto afterUninstall
If %errorlevel% == 2 goto uninstall

pause >nul
goto ending

:afterUninstall
cls
choice /n /c IM /m "Do you want to Install your key or make an MSGuides install? (I/M) >"
If %errorlevel% == 1 goto install
If %errorlevel% == 2 goto MSGuidesInstall

REM ==============================================================================================
REM MSGuides Installation Process

:MSGuidesInstall
cls
color 04
choice /n /c YN /m "Are you sure you want to make an MSGuides Install? (Y/N) >"
If %errorlevel% == 1 echo. & goto confirmedMSGuidesInstall
If %errorlevel% == 2 cls & color 03 & goto startMenu

:confirmedMSGuidesInstall
echo ==================================== Phase 1 ====================================
echo.
echo Preparing licenses...
for /f %%x in ('dir /b ..\root\Licenses16\ProPlus2019VL*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x"
echo.
echo =================================================================================
echo.
echo.
echo ==================================== Phase 2 ====================================
echo.

echo Setting new Port
cscript ospp.vbs /setprt:1688
echo.
echo Unninstalling key...
cscript ospp.vbs /unpkey:6MWKP
echo.
echo Installing new key (NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP)
cscript ospp.vbs /inpkey:NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP
echo.
echo Setting host to kms8.msguides.com
cscript ospp.vbs /sethst:kms8.msguides.com
echo.
echo Attempting activation...
cscript ospp.vbs /act

echo.
echo =================================================================================

cscript ospp.vbs /dstatus | findstr /C:"REMAINING GRACE" >nul
If %errorlevel% == 0 (
	set NewStatus=Activation Completed Succesfully
) else (
	set NewStatus=Activation failed
)
echo.
echo.
echo =================================================================================
echo Program has finished Running
echo %NewStatus%
echo =================================================================================
pause >nul
cls & color 03
choice /n /c SE /m "Do you want to go back to the Start menu or End the program? (S/E) >"
If %errorlevel% == 1 cls & goto startMenu
If %errorlevel% == 2 cls & goto ending

REM ==============================================================================================
REM Ending Process

:ending
color
cd %userprofile%
exit /b
