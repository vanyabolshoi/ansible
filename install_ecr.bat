@echo off
chcp 65001 >nul

echo ===============================
echo   ECR ActiveX Auto Installer
echo ===============================

:: --- Проверка прав администратора ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Запуск от администратора...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

:: --- Путь к установщику ---
set SETUP=C:\temp\ECR_ActiveX_Library_x64_v.1.10.6.2.exe

echo.
echo [1/3] Удаление старой версии (если есть)...

wmic product where "Name like 'ECR ActiveX%%'" call uninstall /nointeractive >nul 2>&1

echo.
echo [2/3] Запуск установщика...

start "" "%SETUP%"

:: даём окну появиться
timeout /t 3 >nul

echo [3/3] Авто-нажатие YES (если появилось окно)...

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Add-Type -AssemblyName System.Windows.Forms; ^
Start-Sleep -Seconds 2; ^
for ($i=0; $i -lt 10; $i++) { ^
    Start-Sleep -Milliseconds 500; ^
    [System.Windows.Forms.SendKeys]::SendWait('{ENTER}') ^
}"

echo.
echo ===============================
echo        ГОТОВО
echo ===============================

pause