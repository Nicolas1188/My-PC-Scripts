@echo off

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
< Your code here >
