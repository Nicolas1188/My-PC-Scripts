@echo off

shutdown /s /t 300 && color 04 && echo Shutdown is programmed || cls && shutdown /a && color 02 && echo Shutdown cancelled

timeout /t 1 >nul
color
exit /b
