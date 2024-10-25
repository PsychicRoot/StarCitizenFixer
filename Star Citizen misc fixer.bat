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
rem This is a custom batch script for fixing multiple Star Citizen issues.

echo Welcome to the Star Citizen Shader Fixer by PsyChicRoot!
echo Version 1.0.1
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

rem Locate the user folder with the exact path "\\LIVE\\user"
for /f "delims=" %%i in ('dir "C:\" /s /b /ad ^| findstr /i "\\LIVE\\user$" 2^>nul') do (
    set "USER_FOLDER=%%i"
    goto :found
)

:found
if defined %USER_FOLDER% (
    echo User folder found at: %USER_FOLDER%

    rem Define the backup location in the system temp folder
    set BACKUP_FOLDER="%temp%\StarCitizenBackup"
    mkdir %BACKUP_FOLDER%
    
    rem Define subfolder variables based on USER_FOLDER
    set CUSTOMCHARACTERS_FOLDER=%USER_FOLDER%\client\0\customcharacters
    set CONTROLS_FOLDER=%USER_FOLDER%\client\0\controls

    rem Ask to back up customcharacters folder
    if exist "%CUSTOMCHARACTERS_FOLDER%" (
        choice /C YN /M "Do you want to backup the customcharacters folder?"
        if %errorlevel% equ 1 (
            echo Backing up customcharacters folder...
            xcopy "%CUSTOMCHARACTERS_FOLDER%" "%BACKUP_FOLDER%\customcharacters" /E /I
        ) else (
            echo Skipping backup of customcharacters folder.
        )
    )

    rem Ask to back up controls folder
    if exist "%CONTROLS_FOLDER%" (
        choice /C YN /M "Do you want to backup the controls folder?"
        if %errorlevel% equ 1 (
            echo Backing up controls folder...
            xcopy "%CONTROLS_FOLDER%" "%BACKUP_FOLDER%\controls" /E /I
        ) else (
            echo Skipping backup of controls folder.
        )
    )

    rem Delete all contents within the user folder itself but keep the folder
    echo Deleting all contents within the user folder...
    for /D %%d in ("%USER_FOLDER%\*") do rd /s /q "%%d"
    del /q "%USER_FOLDER%\*.*"
    echo User folder contents deleted successfully.

    rem Restore customcharacters and controls folders after deletion
    if exist "%BACKUP_FOLDER%\customcharacters" (
        echo Restoring customcharacters folder from backup...
        mkdir "%CUSTOMCHARACTERS_FOLDER%"
        xcopy "%BACKUP_FOLDER%\customcharacters" "%CUSTOMCHARACTERS_FOLDER%" /E /I
        echo customcharacters folder restored successfully.
    )

    if exist "%BACKUP_FOLDER%\controls" (
        echo Restoring controls folder from backup...
        mkdir "%CONTROLS_FOLDER%"
        xcopy "%BACKUP_FOLDER%\controls" "%CONTROLS_FOLDER%" /E /I
        echo controls folder restored successfully.
    )

) else (
    echo Operation Completed enjoy!
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
