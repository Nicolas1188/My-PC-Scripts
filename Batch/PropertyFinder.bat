@echo off
cls
echo.
echo Property Finder Started

@REM Apache License, version 2

@REM Copyright 2020 Nicolas1188

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
choice /c SF /n /m "Summarized (S) or Fully Detailed (F) >"
If %errorlevel% == 1 goto summarized
If %errorlevel% == 2 goto completelist

:summarized
cls
echo.
echo Motherboard Details:
wmic baseboard list full | findstr /b "Manufacturer"
wmic baseboard list full | findstr /b "Product"
echo.
echo BIOS Details:
wmic bios list full | findstr /b "Manufacturer"
wmic bios list full | findstr /b "SMBIOSBIOSVersion"
echo.
echo CPU Details:
wmic cpu list full | findstr /b "Name"
wmic cpu list full | findstr /b "AddressWidth"
wmic cpu list full | findstr /b "MaxClockSpeed"
echo.
echo RAM Details:
wmic memorychip list full | findstr /b "BankLabel"
echo.
wmic memorychip list full | findstr /b "Capacity"
echo.
wmic memorychip list full | findstr /b "Speed"
echo.
wmic memorychip list full | findstr /b "FormFactor"
pause >nul
goto ending

:completelist
cls
echo.
echo Motherboard Properties:
wmic baseboard list full
echo =================================
echo.
echo CPU Properties:
wmic cpu list full
echo =================================
echo.
echo RAM Properties:
wmic memorychip list full
echo =================================
echo.
echo BIOS Properties:
wmic bios list full
pause >nul
goto ending

:ending
cls
choice /c RE /n /m "Restart the program (R) or End it (E) >"
If %errorlevel% == 1 cls && goto start
If %errorlevel% == 2 goto end

:end
cls
exit /b