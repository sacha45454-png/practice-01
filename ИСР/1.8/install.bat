@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
set "LOG=%~dp0install.log"

echo ==== Старт %date% %time% ==== > "%LOG%"

net session >nul 2>&1 || (echo [ERR] Нужны админ‑права >>"%LOG%" & echo Запустите от имени администратора & pause & exit /b 1)
winget -v   >nul 2>&1 || (echo [ERR] Нет winget/App Installer >>"%LOG%" & echo Установите App Installer из Microsoft Store & pause & exit /b 1)

set PACKAGES=Microsoft.VisualStudioCode 7zip.7zip TheDocumentFoundation.LibreOffice Git.Git

for %%P in (%PACKAGES%) do (
  echo --- Установка %%P --- | tee
  echo --- Установка %%P --- >> "%LOG%"
  winget install -e --id %%P -h --accept-source-agreements --accept-package-agreements >> "%LOG%" 2>&1
)

echo Обновление пакетов... >> "%LOG%"
winget upgrade --all -h --accept-source-agreements --accept-package-agreements >> "%LOG%" 2>&1

echo Проверка версий... >> "%LOG%"
where code >nul 2>&1 && (code --version >> "%LOG%" 2>&1)
where git  >nul 2>&1 && (git --version  >> "%LOG%" 2>&1)
if exist "C:\Program Files\7-Zip\7z.exe" ( "C:\Program Files\7-Zip\7z.exe" | find "7-Zip" >> "%LOG%" 2>&1 )
if exist "%ProgramFiles%\LibreOffice\program\soffice.bin" ( "%ProgramFiles%\LibreOffice\program\soffice.bin" --version >> "%LOG%" 2>&1 )

echo ==== Готово %date% %time% ==== >> "%LOG%"
echo Установка завершена. Лог: %LOG%
pause
endlocal