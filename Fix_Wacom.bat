@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

title Wacom Tablet Driver Restart
echo A little batch file for restarting Wacom Tablet driver to fix various problems with Wacom pen tablet on Windows.
pause
cls
echo Please close any programs you need to use with your tablet before continue. (eg. Photoshop, PaintTool SAI, CLIP STUDIO PAINT)
echo.
echo **DON'T INTERUPT THIS PROCESS BY PRESSING ANY KEY BEFORE IT FINSHED!!**
echo.
pause
cls
echo **Stopping Wacom Tablet Service.**
echo.
sc stop WTabletServicePro
echo.
echo **Trying to kill processes, if any still running.**
echo.
taskkill /f /im Professional_CPL.exe
taskkill /f /im Wacom_Tablet.exe
taskkill /f /im Wacom_TabletUser.exe
taskkill /f /im Wacom_TouchUser.exe
taskkill /f /im WacomHost.exe
taskkill /f /im WTabletServicePro.exe
taskkill /f /im FHUtil.exe
taskkill /f /im WacomDesktopCenter.exe
echo.
echo **Starting Wacom Tablet Service.**
echo.
sc start WTabletServicePro
echo.
echo **FINISHED!**
pause