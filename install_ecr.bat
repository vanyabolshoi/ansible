@echo off
chcp 65001 >nul

echo ===============================
echo   ECR ActiveX Clean Install
echo ===============================

:: --- запуск от админа ---
net session >nul 2>&1
if %errorLevel% neq 0 (
powershell -Command "Start-Process '%~f0' -Verb RunAs"
exit
)

echo.
echo [1/3] Поиск старой версии...

:: ищем uninstall строку в реестре
for /f "tokens=2*" %%A in ('reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall /s ^| findstr /i "ECR ActiveX"') do (
set KEY=%%A %%B
)

echo.
echo [2/3] Попытка удаления...

:: универсальный способ через wmic (fallback)
wmic product where "Name like 'ECR ActiveX%%'" call uninstall /nointeractive >nul 2>&1

echo.
echo [3/3] Установка новой версии...

start /wait "" "C:\temp\ECR_ActiveX_Library_x64_v.1.10.6.2.exe" /verysilent /norestart

echo.
echo ===============================
echo        ГОТОВО
echo ===============================
pause
