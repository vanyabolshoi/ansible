@echo off
chcp 65001 >nul

echo ===============================
echo   ECR ActiveX Clean Install
echo ===============================

:: --- админ проверка ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0'"
    exit
)

echo.
echo [1/3] Удаление старой версии...

wmic product where "Name like 'ECR ActiveX%%'" call uninstall /nointeractive >nul 2>&1

:: убиваем зависшие процессы
taskkill /f /im ECR*.exe >nul 2>&1

echo.
echo [2/3] Установка новой версии...

start "" /wait "C:\temp\ECR_ActiveX_Library_x64_v.1.10.6.2.exe"

:: fallback на случай зависания
timeout /t 5 >nul

echo.
echo [3/3] Проверка результата...

reg query HKCR\CLSID /s | findstr /i "ECR"

echo.
echo ===============================
echo        ГОТОВО
echo ===============================
pause
