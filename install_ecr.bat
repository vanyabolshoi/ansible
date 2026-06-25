@echo off
chcp 65001 >nul

echo ===============================
echo   ECR ActiveX Auto Installer
echo ===============================

:: --- проверка админа ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

:: --- путь к установщику ---
set SETUP=C:\temp\ECR_ActiveX_Library_x64_v.1.10.6.2.exe

echo.
echo [1/2] Установка новой версии...

start /wait "" "%SETUP%" /verysilent /norestart

if %errorLevel% neq 0 (
    start /wait "" "%SETUP%" /silent /norestart
)

echo.
echo [2/2] Проверка установки...

reg query HKCR\CLSID /s | findstr /i "ECR"

echo.
echo ===============================
echo        ГОТОВО
echo ===============================
pause
