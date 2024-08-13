@echo off
chcp 65001
cls
:start
echo Hi there!
echo This script is used to disable or manage Windows Updates.
echo We all know windows has quite a reputation for forcing updates onto us.
echo:
echo Be aware that I haven't tested this script fully so you're at your
echo own risk, I will not be held responsable for any damage that happens
echo to your PC.
pause > nul
echo Press any key to go to the main menu...
cls
:menu
echo ██████████████████████████████████████████████████████████▓▒░
echo Windows Update Control Menu
echo =============================================================
echo 1. Stop and Disable Windows Update Service [Not Recomended]
echo 2. Set Windows Update to Manual
echo 3. Pause Windows Updates for 7 Days
echo 4. Configure Windows Update to Notify Before Downloading
echo 5. Re-enable Windows Update Service
echo 6. Exit
echo ██████████████████████████████████████████████████████████▓▒░
choice /c 123456 /m "Select an option:"
set choice=%errorlevel%

if %choice%==1 goto disable
if %choice%==2 goto manual
if %choice%==3 goto pause
if %choice%==4 goto notify
if %choice%==5 goto enable
if %choice%==6 goto end

:disable
echo Stopping and disabling Windows Update service...
net stop wuauserv
sc config wuauserv start= disabled
echo Windows Update service stopped and disabled.
goto end

:manual
echo Stopping Windows Update service...
net stop wuauserv
echo Setting Windows Update service to manual...
sc config wuauserv start= demand
echo Windows Update service stopped and set to manual.
goto end

:pause
echo Pausing Windows Updates for 7 days...
powershell -command "Start-Service wuauserv; Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'PauseUpdatesStartTime' -Value ([datetime]::Now); Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'PauseUpdatesExpiryTime' -Value ([datetime]::Now.AddDays(7))"
echo Windows Updates paused.
goto end

:notify
echo Configuring Windows Update to notify before downloading...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 2 /f
echo Windows Update configured to notify before downloading.
goto end

:enable
echo Enabling Windows Update service...
sc config wuauserv start= auto
net start wuauserv
echo Windows Update service enabled and started.
goto end

:end
echo ████████████████████████████████████████████████████████████████▓▒░
echo Done. Press any key to return to the menu or close the window
echo:
pause >nul
goto menu