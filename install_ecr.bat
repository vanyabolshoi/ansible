@echo off
chcp 65001 >nul

echo ===============================
echo   ECR ActiveX Silent Install
echo ===============================

:: запуск от админа
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

echo.
echo [1/2] Удаление старой версии...

wmic product where "Name like 'ECR ActiveX%%'" call uninstall /nointeractive >nul 2>&1

echo.
echo [2/2] Установка БЕЗ UI...

start /wait "" "C:\temp\ECR_ActiveX_Library_x64_v.1.10.6.2.exe" /verysilent /norestart

echo.
echo ===============================
echo        ГОТОВО
echo ===============================
pause
