@echo off
cls
echo.
echo Property Finder Started

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