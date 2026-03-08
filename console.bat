@echo off
chcp 65001
setlocal enabledelayedexpansion
title WinSoft

if exist logs.txt (
    echo. >> logs.txt
    goto admin
) else (
    echo # Логи WinSoft >> logs.txt
    echo Файл создан - %DATE% %TIME% >> logs.txt
    echo Copyright (c) 2026 MurCoda LCC >> logs.txt
    echo. >> logs.txt

    echo [%DATE% %TIME%] Начинаю процесс: "Создание ярлыка". >> logs.txt
    
    set "TARGET_BAT=C:\Program Files\WinSoft\console.bat"
    set "SHORTCUT_NAME=WinSoft"
    set "COMMENT=WinSoft v0.0.0.0"
    set "ICON_PATH=C:\Program Files\WinSoft\icon.ico"

    powershell -Command ^
        "$ws = New-Object -ComObject WScript.Shell;" ^
        "$shortcut = $ws.CreateShortcut('$env:USERPROFILE\Desktop\%SHORTCUT_NAME%.lnk');" ^
        "$shortcut.TargetPath = 'cmd';" ^
        "$shortcut.Arguments = '/c start \"\" /max \"%TARGET_BAT%\"';" ^
        "$shortcut.Description = '%COMMENT%';" ^
        "$shortcut.WorkingDirectory = '%~dp0';" ^
        "$shortcut.WindowStyle = 3;" ^
        "$shortcut.IconLocation = '%ICON_PATH%';" ^
        "$shortcut.Save()"
    echo [%DATE% %TIME%] Процесс "Создание ярлыка" завершён. >> logs.txt
)

:admin
echo [%DATE% %TIME%] Начинаю процесс: "Проверка прав администратора". >> logs.txt
if "%1"=="admin" (
    echo [%DATE% %TIME%] Запущено с правами администратора! >> logs.txt
) else (
    echo [%DATE% %TIME%] Запущено без прав администратора! >> logs.txt
    echo [%DATE% %TIME%] Запрос прав администратора... >> logs.txt
    echo [%DATE% %TIME%] [!] Предупреждение: если на следующей строке не будет указано что процесс успешно выпонен - вы не дали права администратора программе.>> logs.txt
    powershell -NoProfile -Command "Start-Process 'cmd.exe' -ArgumentList '/c \"\"%~f0\" admin\"' -Verb RunAs"
    exit
)

echo [%DATE% %TIME%] Права администратора получены! >> logs.txt
echo [%DATE% %TIME%] Процесс "Проверка прав администратора" завершён. >> logs.txt

:update

echo [%DATE% %TIME%] Начинаю процесс: "Проверка обновлений". >> logs.txt

chcp 437 > nul
cls

echo [%DATE% %TIME%] Установка переменный и powershell. >> logs.txt

set "git1=https://raw.githubusercontent.com/murcodallc/winsoft/main/.service/version.txt"
set "git2=https://github.com/murcodallc/winsoft/releases/tag/"

for /f "delims=" %%A in ('powershell -NoProfile -Command "(Invoke-WebRequest -Uri \"%git1%\" -Headers @{\"Cache-Control\"=\"no-cache\"} -UseBasicParsing -TimeoutSec 5).Content.Trim()" 2^>nul') do set "git4=%%A"

if not defined git4 (
    echo [%DATE% %TIME%] [!] Предупреждение: не удалось загрузить последнюю версию. Это предупреждение не влияет на работу программы. >> logs.txt
)

if "0.0.0.0"=="%git4%" (
    echo [%DATE% %TIME%] У вас последняя версия: %git4% >> logs.txt
    echo [%DATE% %TIME%] Процесс "Проверка обновлений завершён". >> logs.txt
) else (
    echo [%DATE% %TIME%] Доступна новая версия: %git4% >> logs.txt
    echo [%DATE% %TIME%] Страница релиза: %git2%%git4% >> logs.txt
    echo [%DATE% %TIME%] Процесс "Проверка обновлений завершён". >> logs.txt
    chcp 65001 > nul
    clx
    call :PrintYellow "Доступна новая версия: %git4%"
    call :PrintRed "[!] Пожайлуста, установите последнюю версию. Чтобы установить - нажмите любую клавишу. Программа будет работать только на новой версии!"
    pause > nul
    set "git3=https://github.com/murcodallc/winsoft/releases/download/%git4%/winsoft.bat"
    start "" "%git3%"
    exit
)

:menu
chcp 65001 > nul
cls
set "choice=null"

echo [%DATE% %TIME%] Запущено главное меню. >> logs.txt

echo  ----------------------
echo     WINSOFT V0.0.0.0
echo  ----------------------
echo       ГЛАВНОЕ МЕНЮ     
echo  ----------------------
echo  1. Настройки Windows
echo  2. DPI [%DPISTATUS%]
echo  3. Программы
echo  4. Хакерский терминал
echo  5. О программе
echo  ----------------------
echo  0. Выход
echo  ----------------------
echo.
set /p choice=" Ваш выбор: "

echo [%DATE% %TIME%] Ответ: %choice% >> logs.txt

if "%choice%"=="0" goto exit
if "%choice%"=="1" goto settingswindows
if "%choice%"=="2" goto dpi
if "%choice%"=="3" goto apps
if "%choice%"=="4" goto terminal
if "%choice%"=="5" goto info
goto menu

###

:exit
echo [%DATE% %TIME%] Выход из программы. >> logs.txt
exit

:PrintGreen
echo [%DATE% %TIME%] Написано на Green: %~1 >> logs.txt
powershell -NoProfile -Command "Write-Host \"%~1\" -ForegroundColor Green"
exit /b

:PrintRed
echo [%DATE% %TIME%] Написано на Red: %~1 >> logs.txt
powershell -NoProfile -Command "Write-Host \"%~1\" -ForegroundColor Red"
exit /b

:PrintYellow
echo [%DATE% %TIME%] Написано на Yellow: %~1 >> logs.txt
powershell -NoProfile -Command "Write-Host \"%~1\" -ForegroundColor Yellow"
exit /b
