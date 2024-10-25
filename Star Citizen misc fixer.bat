color a
@ECHO OFF
REM BFCPEOPTIONSTART
REM BFCPEICONINDEX=-1
REM BFCPEEMBEDDISPLAY=0
REM BFCPEEMBEDDELETE=1
REM BFCPEADMINEXE=1
REM BFCPEINVISEXE=0
REM BFCPEVERINCLUDE=1
REM BFCPEVERPRODUCT=SCSCC
REM BFCPEWINDOWCENTER=1
REM BFCPEDISABLEQE=0
REM BFCPEWINDOWHEIGHT=30
REM BFCPEWINDOWWIDTH=120
REM BFCPEWTITLE=Star Citizen Fixer
REM BFCPEOPTIONEND
@echo off
rem This is a custom batch script for fixing multiple star citizen issues.

echo Welcome to the Star Citizen Shader Fixer by PsyChicRoot!
echo Version 1.0.0
echo.
echo.

rem Display the contents of the Star Citizen Shader Cache folder.
set SC_DIR=%localappdata%\Star Citizen
echo The contents of the Star Citizen Shader Cache folder (%localappdata%\Star Citizen):
dir /b "%SC_DIR%"
echo ------
set SC_FILES=%localappdata%\Star Citizen
@for /f %%a in ('2^>nul dir "%SC_FILES%" /a-d/b/-o/-p/s^|find /v /c ""') do set n=%%a
@echo Total files: %n%!
echo.

echo Do you want to delete all files within the Star Citizen Shader Cache folder?
choice /C YN /M "Please enter your choice:"
if %errorlevel% equ 1 (
    rem Count the number of files before deletion.
    for /f %%a in ('dir /a-d /b "%SC_DIR%" 2^>nul ^| find /c /v ""') do set NUM_FILES=%%a
    @echo off
    for /D %%d in ("%SC_DIR%\*") do rd /s /q "%%d"
    rem Delete all files within the folder.
    del /q  "%SC_DIR%\*"
    
    echo %NUM_FILES% files were deleted successfully.
)

rem Search for the "LIVE\user" folder on the entire C: drive
echo Searching for the "LIVE\user" folder...
set "USER_FOLDER="
for /f "delims=" %%i in ('dir "C:\" /s /b /ad ^| findstr /i "\\LIVE\\user$" 2^>nul') do (
    set "USER_FOLDER=%%i"
    goto :found
)

:found
if defined USER_FOLDER (
    echo User folder found at: %USER_FOLDER%
    choice /C YN /M "Do you want to delete this folder?"
    if %errorlevel% equ 1 (
        rd /s /q "%USER_FOLDER%"
        echo User folder deleted successfully.
    ) else (
        echo User folder not deleted.
    )
) else (
    echo "LIVE\user" folder not found.
)

echo.
echo Do you want to upgrade all installed applications using winget?
choice /C YN /M "Please enter your choice:"
if %errorlevel% equ 1 (
    echo Upgrading all installed applications...
    winget upgrade --all
)

echo.
echo Press any key to close the script.
pause >nul
exit
