@echo off
chcp 65001 >nul

set SETUP=C:\Temp\ECR_ActiveX_Library_x64_v.1.10.6.2.exe

if not exist "%SETUP%" (
    echo ERROR: installer not found
    exit /b 1
)

echo Installing ECR...

"%SETUP%" /verysilent /norestart

set ERR=%errorlevel%

echo Exit code: %ERR%

if not "%ERR%"=="0" (
    echo Trying fallback silent mode...
    "%SETUP%" /silent /norestart
    set ERR=%errorlevel%
)

echo Checking registry...
reg query HKCR\CLSID /s | findstr /i "ECR"

exit /b %ERR%
