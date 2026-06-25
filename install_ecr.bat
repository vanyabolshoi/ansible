@echo off
chcp 65001 >nul

echo ===============================
echo   ECR ActiveX Auto Installer
echo ===============================

set SETUP=C:\Temp\ECR_ActiveX_Library_x64_v.1.10.6.2.exe

if not exist "%SETUP%" (
    echo ERROR: Installer not found
    exit /b 1
)

echo [1/2] Installing...

:: ВАЖНО: без start /wait
"%SETUP%" /verysilent /norestart

set ERR=%errorlevel%

echo Exit code: %ERR%

if not "%ERR%"=="0" (
    echo Fallback silent mode...
    "%SETUP%" /silent /norestart
    set ERR=%errorlevel%
    echo Exit code fallback: %ERR%
)

echo [2/2] Registry check...
reg query HKCR\CLSID /s | findstr /i "ECR"

echo DONE
exit /b %ERR%
