@echo off
setlocal enabledelayedexpansion

REM FTP Server details
set SERVER=http://mario.bplaced.net/
set USER=mario
set PASSWORD=%FTP_PASSWORD%
set REMOTE_DIR=/www/test
set LOCAL_DIR=C:\Users\mtraub\Desktop\Repositorys\M239\Projekt\Optimierung

REM Check if the FTP_PASSWORD environment variable is set
if "%PASSWORD%"=="" (
    echo Error: FTP_PASSWORD environment variable is not set.
    exit /b 1
)

REM Create a temporary FTP script file
set FTP_SCRIPT=ftp_script.txt

REM Function to recursively upload files and directories
:upload
set LOCAL_PATH=%1
set REMOTE_PATH=%REMOTE_DIR%!LOCAL_PATH:%LOCAL_DIR%=!
echo cd %REMOTE_PATH% >> %FTP_SCRIPT%
if exist %LOCAL_PATH%\* (
    for /d %%D in (%LOCAL_PATH%\*) do (
         if /i "%%~nxD" neq "node_modules" (
                    echo mkdir %REMOTE_PATH%\%%~nxD >> %FTP_SCRIPT%
                    call :upload "%%D"
                )
    )
    for %%F in (%LOCAL_PATH%\*) do (
        if exist "%%F" (
            echo put "%%F" "%REMOTE_PATH%\%%~nxF" >> %FTP_SCRIPT%
        )
    )
) else (
    echo put "%LOCAL_PATH%" "%REMOTE_PATH%\%~nx1" >> %FTP_SCRIPT%
)
exit /b

REM Initialize the FTP script file
echo open %SERVER% > %FTP_SCRIPT%
echo %USER% >> %FTP_SCRIPT%
echo %PASSWORD% >> %FTP_SCRIPT%

REM Start the upload process
call :upload %LOCAL_DIR%

REM Finish the FTP script
echo bye >> %FTP_SCRIPT%

REM Run the FTP script
ftp -n -s:%FTP_SCRIPT%

REM Clean up
del %FTP_SCRIPT%

echo Upload completed!
endlocal
