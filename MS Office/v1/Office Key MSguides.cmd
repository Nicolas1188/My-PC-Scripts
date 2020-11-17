@echo off
title MSGuides Office Activator
color 04
pushd %~dp0

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

:start
cd /d %systemDrive%\Program Files\Microsoft Office\Office16

echo =================================================================================
echo Attempting to activate Office...
echo =================================================================================
echo.
echo.

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
cscript ospp.vbs /unpkey:6MWKP >nul
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
If errorlevel 0 (
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
