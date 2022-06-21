@echo off
setlocal enabledelayedexpansion
mode con lines=20 cols=125
chcp 65001 >nul 2>&1
cd /d "%~dp0"
title Post Tweaks

set "VERSION=2.2.3"
set "VERSION_INFO=21/06/2022"

call:SETCONSTANTS >nul 2>&1

ver | find "10." >nul 2>&1
if !ERRORLEVEL! neq 0 (
    echo ERROR: Your current Windows version is not supported
    echo.
    echo Press any key to exit . . .
    pause >nul && exit
)

cscript | findstr /c:"Windows Script Host" >nul 2>&1
if !ERRORLEVEL! neq 0 (
    echo Windows Script Host is unavaliable.
    echo This batch cannot do it's job without WSH!
    echo.
    echo Press any key to exit . . .
    pause >nul && exit
)

openfiles >nul 2>&1
if !ERRORLEVEL! neq 0 (
    echo !S_GRAY!You are not running as !RED!Administrator!S_GRAY!...
    echo This batch cannot do it's job without elevation!
    echo.
    echo Right-click and select !S_GREEN!^'Run as Administrator^' !S_GRAY!and try again...
    echo.
    echo Press any key to exit . . .
    pause >nul && exit
)

ping -n 1 "google.com" >nul 2>&1
if !ERRORLEVEL! neq 0 (
    echo !RED!ERROR: !S_GRAY!No internet connection found
    echo.
    echo Please make sure you are connected to the internet and try again . . .
    pause >nul && exit
)

call:CURL "1" "https://raw.githubusercontent.com/ArtanisInc/Post-Tweaks/main/version" "version"
if !ERRORLEVEL! equ 0 (
    for /f "tokens=1 delims= " %%i in (version) do set "LATEST_VERSION=%%i"
    for /f "tokens=1,2 delims= " %%i in (version) do set "LATEST_VERSION_INFO=%%j"
)
del /f /q "version" >nul 2>&1

if /i !VERSION! lss !LATEST_VERSION! (
    cls
    echo.
    echo    !S_GRAY!A new version of Post Tweaks is available.
    echo.
    echo    Current version:   !S_GREEN!!VERSION!!S_GRAY! - !S_GREEN!!VERSION_INFO!!S_GRAY!
    echo    Latest version:    !S_GREEN!!LATEST_VERSION!!S_GRAY! - !S_GREEN!!LATEST_VERSION_INFO!!S_GRAY!
    echo.
    echo    Update to the latest version now ? [!S_GREEN!Yes!S_GRAY!^/!S_GREEN!No!S_GRAY!]!S_GREEN!
    choice /c yn /n /m "" /t 25 /d y
    if !ERRORLEVEL! equ 1 (
        cls
        echo.
        echo Updating to the latest version, please wait...
        echo.
        call:CURL "0" "https://github.com/ArtanisInc/Post-Tweaks/archive/main.zip" "main.zip"
        call:UNZIP "main.zip" "%~dp0" >nul 2>&1
        del /f /q "main.zip" >nul 2>&1
        rd /s /q "modules" >nul 2>&1
        rd /s /q "resources" >nul 2>&1
        move "Post-Tweaks-main\modules" "modules" >nul 2>&1
        move "Post-Tweaks-main\resources" "resources" >nul 2>&1
        move "Post-Tweaks-main\PostTweaks.bat" "PostTweaks.bat" >nul 2>&1
        rd /s /q "Post-Tweaks-main" >nul 2>&1
        del /f /q "version.txt" >nul 2>&1
        call:RunAsTI "%~dpnx0" & exit
    )
    cls
)

set "NEEDEDFILES=resources/choicebox.exe resources/smartctl.exe resources/install_wim_tweak.exe resources/procexp.exe resources/SetTimerResolutionService.exe resources/nvidiaProfileInspector.exe resources/BaseProfile.nip"
for %%i in (!NEEDEDFILES!) do (
    if not exist %%i (
        set "MISSINGFILES=True"
        echo !RED!ERROR: !S_GREEN!%%i !S_GRAY!is missing
    )
)
if "!MISSINGFILES!"=="True" echo. & echo Downloading missing files please wait...!S_GREEN!
for %%i in (!NEEDEDFILES!) do if not exist %%i call:CURL "0" "https://raw.githubusercontent.com/ArtanisInc/Post-Tweaks/main/%%i" "%%i"

whoami /user | find /i "S-1-5-18" >nul 2>&1
if !ERRORLEVEL! neq 0 call:RunAsTI "%~dpnx0" & exit

:MAIN_MENU
mode con lines=26 cols=125
echo.
echo.
echo                   !RED!██████!S_GRAY!╗  !RED!██████!S_GRAY!╗ !RED!███████!S_GRAY!╗!RED!████████!S_GRAY!╗    !RED!████████!S_GRAY!╗!RED!██!S_GRAY!╗    !RED!██!S_GRAY!╗!RED!███████!S_GRAY!╗ !RED!█████!S_GRAY!╗ !RED!██!S_GRAY!╗  !RED!██!S_GRAY!╗!RED!███████!S_GRAY!╗
echo                   !RED!██!S_GRAY!╔══!RED!██!S_GRAY!╗!RED!██!S_GRAY!╔═══!RED!██!S_GRAY!╗!RED!██!S_GRAY!╔════╝╚══!RED!██!S_GRAY!╔══╝    ╚══!RED!██!S_GRAY!╔══╝!RED!██!S_GRAY!║    !RED!██!S_GRAY!║!RED!██!S_GRAY!╔════╝!RED!██!S_GRAY!╔══!RED!██!S_GRAY!╗!RED!██!S_GRAY!║ !RED!██!S_GRAY!╔╝!RED!██!S_GRAY!╔════╝
echo                   !RED!██████!S_GRAY!╔╝!RED!██!S_GRAY!║   !RED!██!S_GRAY!║!RED!███████!S_GRAY!╗   !RED!██!S_GRAY!║          !RED!██!S_GRAY!║   !RED!██!S_GRAY!║ !RED!█!S_GRAY!╗ !RED!██!S_GRAY!║!RED!█████!S_GRAY!╗  !RED!███████!S_GRAY!║!RED!█████!S_GRAY!╔╝ !RED!███████!S_GRAY!╗
echo                   !RED!██!S_GRAY!╔═══╝ !RED!██!S_GRAY!║   !RED!██!S_GRAY!║╚════!RED!██!S_GRAY!║   !RED!██!S_GRAY!║          !RED!██!S_GRAY!║   !RED!██!S_GRAY!║!RED!███!S_GRAY!╗!RED!██!S_GRAY!║!RED!██!S_GRAY!╔══╝  !RED!██!S_GRAY!╔══!RED!██!S_GRAY!║!RED!██!S_GRAY!╔═!RED!██!S_GRAY!╗ !S_GRAY!╚════!RED!██!S_GRAY!║
echo                   !RED!██!S_GRAY!║     ╚!RED!██████!S_GRAY!╔╝!RED!███████!S_GRAY!║   !RED!██!S_GRAY!║          !RED!██!S_GRAY!║   ╚!RED!███!S_GRAY!╔!RED!███!S_GRAY!╔╝!RED!███████!S_GRAY!╗!RED!██!S_GRAY!║  !RED!██!S_GRAY!║!RED!██!S_GRAY!║  !RED!██!S_GRAY!╗!RED!███████!S_GRAY!║
echo                   !S_GRAY!╚═╝      ╚═════╝ ╚══════╝   ╚═╝          ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
echo.
echo                    !S_MAGENTA!╔═════════════════════════════════════════════════════════════════════════════════════╗
echo                                    !UNDERLINE!!S_RED!v!version!!_UNDERLINE!               !RED!█!B_YELLOW! MAIN MENU !B_BLACK!!RED!█        !UNDERLINE!!S_RED!Welcome %username%!S_MAGENTA!!_UNDERLINE!
echo                    ╚═════════════════════════════════════════════════════════════════════════════════════╝
echo.
echo                            [ !S_GREEN!1!S_MAGENTA! ] !S_WHITE!SYSTEM TWEAKS!S_MAGENTA!                            [ !S_GREEN!2!S_MAGENTA! ] !S_WHITE!SOFTWARE INSTALLER!S_MAGENTA!
echo.
echo                                                         [ !S_GREEN!3!S_MAGENTA! ] !S_WHITE!TOOLS!S_MAGENTA!
echo.
echo                    ╔══════════════════════════════════════════╦══════════════════════════════════════════╗
echo                    ║     !S_GREEN!C!S_MAGENTA!  ^>  !S_WHITE!Credits!S_MAGENTA!                        ║              !S_GREEN!G!S_MAGENTA!  ^>  !UNDERLINE!!S_RED!Github repository!S_MAGENTA!!_UNDERLINE!     ║
echo                    ╚══════════════════════════════════════════╩══════════════════════════════════════════╝
echo.
echo                                       !S_GRAY!Make your choices OR "!S_GREEN!HELP!S_GRAY!" AND press !S_GREEN!{ENTER}!S_GRAY!
echo.
set choice=
set /p "choice=!S_GREEN!                                                              "
if "!choice!"=="1" goto SYSTWEAKS
if "!choice!"=="2" goto APPS_MENU_CLEAR
if "!choice!"=="3" goto TOOLS_MENU_CLEAR
if /i "!choice!"=="c" goto CREDITS
if /i "!choice!"=="g" start "" "https://github.com/ArtanisInc/Post-Tweaks" && goto MAIN_MENU
if /i "!choice!"=="h" goto HELP
if /i "!choice!"=="help" goto HELP
echo                                            !RED!ERROR: !S_GREEN!"!choice!"!S_GRAY! is not a valid choice...
timeout /t 3 /nobreak >nul 2>&1
goto MAIN_MENU

:SYSTWEAKS
if not exist "logs" mkdir "logs"

call:MSGBOX "Do you want to create a registry backup and restore point ?" vbYesNo+vbQuestion "System Restore"
if !ERRORLEVEL! equ 6 (
    call:ECHOX Creating a registry backup and restore point
    call:POWERSHELL "Checkpoint-Computer -Description \"Post Tweaks\" -RestorePointType \"MODIFY_SETTINGS\""
    if not exist "%UserProfile%\desktop\Registry Backup" md "%UserProfile%\desktop\Registry Backup" & for %%i in (HKLM HKCU HKCR HKU HKCC) do reg export "%%i" "%UserProfile%\desktop\Registry Backup\%%i.reg" >nul 2>&1
)

reg query "HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5" /ve >nul 2>&1
if !ERRORLEVEL! neq 0 call:CHOCO dotnet3.5 & DISM /online /Enable-Feature /FeatureName:"NetFx3" /All /NoRestart >nul 2>&1

call:ECHOX Disabling Windows settings synchronization
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /t REG_DWORD /d "5" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSyncOnPaidNetwork" /t REG_DWORD /d "1" /f >nul 2>&1

if "!PC_TYPE!"=="LAPTOP/TABLET" (
    call:MSGBOX "Would you like to disable power saving features ?\n\nDisabling power saving will decrease battery life, but performance will be improved." vbYesNo+vbQuestion "Power saving"
    if !ERRORLEVEL! equ 6 set "POWER_SAVING=OFF"
) else set "POWER_SAVING=OFF"

call "resources\choicebox.exe" "Disable User Access Control (UAC);Disable SmartScreen;Remove Windows Defender;Disable Windows firewall;Disable automatic maintenance;Disable blocking downloads;Disable Data Execution Prevention (DEP);Disable DMA remapping;Disable Fault Tolerant Heap (FTH);Disable Meltdown and Spectre;Disable system mitigations" "Security features can have a negative effect on performance. Use at your own risk." "Security" /C:2 >"%TMP%\security.txt"
findstr /c:"Disable User Access Control (UAC)" "%TMP%\security.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling UAC
    for %%i in (EnableLUA ConsentPromptBehaviorAdmin PromptOnSecureDesktop FilterAdministratorToken) do reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "%%i" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\luafv" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
)
findstr /c:"Disable SmartScreen" "%TMP%\security.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling SmartScreen
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Remove Windows Defender" "%TMP%\security.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Removing Windows Defender
    for %%i in ("Microsoft-Windows-SecurityCenter" "Windows-Defender" "Microsoft-Windows-HVSI" "Microsoft-Windows-SecureStartup"
    "Microsoft-Windows-Killbits" "Microsoft-Windows-SenseClient" "Microsoft-Windows-DeviceGuard" "Microsoft-OneCore-VirtualizationBasedSecurity") do call "resources/install_wim_tweak.exe" /o /c %%~i /r >nul 2>&1

    for %%i in ("HKLM\SOFTWARE\Microsoft\Windows Defender" "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender"
    "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center" "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows Defender Security Center"
    "HKLM\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows Defender" "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WindowsDefenderSecurityCenter"
    "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Defender" "HKLM\SOFTWARE\Policies\Microsoft\Microsoft Antimalware" "HKCR\Folder\shell\WindowsDefender"
    "HKCR\DesktopBackground\Shell\WindowsSecurity" "HKLM\SOFTWARE\Microsoft\Security Center" "HKLM\SYSTEM\CurrentControlSet\Services\wscsvc" "HKLM\SYSTEM\CurrentControlSet\Services\SecurityHealthService") do reg delete %%i /f >nul 2>&1
    reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SecurityHealth" /f >nul 2>&1
)
findstr /c:"Disable Windows firewall" "%TMP%\security.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling Windows firewall
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\mpssvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\BFE" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
)
findstr /c:"Disable automatic maintenance" "%TMP%\security.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling automatic maintenance
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\ScheduledDiagnostics" /v "EnabledExecution" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\ScheduledDiagnostics" /v "EnabledExecution" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Disable blocking downloads" "%TMP%\security.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling blocking downloads
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v "SaveZoneInformation" /t REG_DWORD /d "1" /f >nul 2>&1
)
findstr /c:"Disable Data Execution Prevention (DEP)" "%TMP%\security.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling DEP
    bcdedit /set nx AlwaysOff >nul 2>&1
)
findstr /c:"Disable DMA remapping" "%TMP%\security.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling DMA remapping
    reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\DmaGuard\DeviceEnumerationPolicy" /v "value" /t REG_DWORD /d "2" /f >nul 2>&1
    for /f "tokens=1" %%i in ('driverquery') do reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%i\Parameters" /v "DmaRemappingCompatible" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Disable Fault Tolerant Heap (FTH)" "%TMP%\security.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling FTH
    reg add "HKLM\SOFTWARE\Microsoft\FTH" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg delete "HKLM\SOFTWARE\Microsoft\FTH\State" /f >nul 2>&1
)
findstr /c:"Disable Meltdown and Spectre" "%TMP%\security.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling Meltdown and Spectre
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f >nul 2>&1
    del /f /q "%WinDir%\System32\mcupdate_GenuineIntel.dll" >nul 2>&1
    del /f /q "%WinDir%\System32\mcupdate_AuthenticAMD.dll" >nul 2>&1
)
findstr /c:"Disable system mitigations" "%TMP%\security.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling system mitigations
    call:POWERSHELL "Set-ProcessMitigation -System -Disable CFG"
    for /f "tokens=3 skip=2" %%i in ('reg query "HKLM\System\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationAuditOptions"') do set mitigation_mask=%%i
    for /l %%i in (0,1,9) do set mitigation_mask=!mitigation_mask:%%i=2!
    reg add "HKLM\System\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationOptions" /t REG_BINARY /d "!mitigation_mask!" /f >nul 2>&1
    reg add "HKLM\System\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationAuditOptions" /t REG_BINARY /d "!mitigation_mask!" /f >nul 2>&1
)
del /f /q "%TMP%\security.txt" >nul 2>&1

call:ECHOX Speed up start time
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DelayedDesktopSwitchTimeout" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d "0" /f >nul 2>&1

call:ECHOX Decrease shutdown time
reg add "HKU\!USER_SID!\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKU\!USER_SID!\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "1000" /f >nul 2>&1
reg add "HKU\!USER_SID!\Control Panel\Desktop" /v "WaitToKillServiceTimeout" /t REG_SZ /d "2000" /f >nul 2>&1

call:ECHOX Sound communications do nothing
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d "3" /f >nul 2>&1

call:ECHOX Disabling startup sound
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation" /v "DisableStartupSound" /t REG_DWORD /d "1" /f >nul 2>&1

call:ECHOX Enabling num Lock at startup
reg add "HKU\!USER_SID!\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /t REG_DWORD /d "2" /f >nul 2>&1

call:ECHOX Disabling mouse acceleration
reg add "HKU\!USER_SID!\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10" /f >nul 2>&1
reg add "HKU\!USER_SID!\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKU\!USER_SID!\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKU\!USER_SID!\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >nul 2>&1

call:ECHOX Disabling fast startup
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

call:ECHOX Importing power plan
powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 !POWER_GUID! >nul 2>&1
powercfg /changename !POWER_GUID! "Post tweaks" "Promotes high performance at the expense of power consumption." >nul 2>&1
powercfg /setactive !POWER_GUID! >nul 2>&1
powercfg /hibernate off >nul 2>&1
powercfg /setacvalueindex !POWER_GUID! 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0 >nul 2>&1
powercfg /setacvalueindex !POWER_GUID! 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 0 >nul 2>&1
powercfg /setacvalueindex !POWER_GUID! 238c9fa8-0aad-41ed-83f4-97be242c8f20 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 0 >nul 2>&1
powercfg /setacvalueindex !POWER_GUID! 238c9fa8-0aad-41ed-83f4-97be242c8f20 abfc2519-3608-4c2a-94ea-171b0ed546ab 0 >nul 2>&1
powercfg /setacvalueindex !POWER_GUID! 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
powercfg /setacvalueindex !POWER_GUID! 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0 >nul 2>&1
powercfg /setacvalueindex !POWER_GUID! 2e601130-5351-4d9d-8e04-252966bad054 d502f7ee-1dc7-4efd-a55d-f04b6f5c0545 0 >nul 2>&1
powercfg /setacvalueindex !POWER_GUID! 54533251-82be-4824-96c1-47b60b740d00 06cadf0e-64ed-448a-8927-ce7bf90eb35d 10 >nul 2>&1
powercfg /setacvalueindex !POWER_GUID! 54533251-82be-4824-96c1-47b60b740d00 3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb 0 >nul 2>&1
powercfg /setacvalueindex !POWER_GUID! 54533251-82be-4824-96c1-47b60b740d00 4b92d758-5a24-4851-a470-815d78aee119 100 >nul 2>&1
powercfg /setacvalueindex !POWER_GUID! 54533251-82be-4824-96c1-47b60b740d00 619b7505-003b-4e82-b7a6-4dd29c300971 100 >nul 2>&1
powercfg /setacvalueindex !POWER_GUID! 54533251-82be-4824-96c1-47b60b740d00 7b224883-b3cc-4d79-819f-8374152cbe7c 100 >nul 2>&1
powercfg /setacvalueindex !POWER_GUID! 54533251-82be-4824-96c1-47b60b740d00 c7be0679-2817-4d69-9d02-519a537ed0c6 2 >nul 2>&1
powercfg /setacvalueindex !POWER_GUID! 54533251-82be-4824-96c1-47b60b740d00 12a0ab44-fe28-4fa9-b3bd-4b64f44960a6 5 >nul 2>&1
powercfg /setacvalueindex !POWER_GUID! 54533251-82be-4824-96c1-47b60b740d00 12a0ab44-fe28-4fa9-b3bd-4b64f44960a7 10 >nul 2>&1
powercfg /setacvalueindex !POWER_GUID! 7516b95f-f776-4464-8c53-06167f40cc99 17aaa29b-8b43-4b94-aafe-35f64daaf1ee 0 >nul 2>&1
powercfg /setacvalueindex !POWER_GUID! 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0 >nul 2>&1
powercfg /setacvalueindex !POWER_GUID! e73a048d-bf27-4f12-9731-8b2076e8891f 637ea02f-bbcb-4015-8e2c-a1c7b9c0b546 1 >nul 2>&1
powercfg /setdcvalueindex !POWER_GUID! fea3413e-7e05-4911-9a71-700331f1c294 68afb2d9-ee95-47a8-8f50-4115088073b1 1 >nul 2>&1
powercfg /setdcvalueindex !POWER_GUID! 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 300 >nul 2>&1
powercfg /setdcvalueindex !POWER_GUID! 0012ee47-9041-4b5d-9b77-535fba8b1442 fc95af4d-40e7-4b6d-835a-56d131dbc80e 200 >nul 2>&1
powercfg /setdcvalueindex !POWER_GUID! 54533251-82be-4824-96c1-47b60b740d00 6c2993b0-8f48-481f-bcc6-00dd2742aa06 1 >nul 2>&1
powercfg /setdcvalueindex !POWER_GUID! 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ed 75 >nul 2>&1
powercfg /setdcvalueindex !POWER_GUID! 5fb4938d-1ee8-4b0f-9a3c-5036b0ab995c dd848b2a-8a5d-4451-9ae2-39cd41658f6c 1 >nul 2>&1
powercfg /setdcvalueindex !POWER_GUID! 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 34c7b99f-9a6d-4b3c-8dc7-b6693b78cef4 2 >nul 2>&1
powercfg /setdcvalueindex !POWER_GUID! e73a048d-bf27-4f12-9731-8b2076e8891f 637ea02f-bbcb-4015-8e2c-a1c7b9c0b546 1 >nul 2>&1
powercfg /setactive scheme_current >nul 2>&1

if "!POWER_SAVING!"=="OFF" (
    call:ECHOX Disabling power throttling
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f >nul 2>&1

    call:ECHOX Disabling hibernation
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

    call:ECHOX Disabling timer coalescing
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1

    if "!HT_SMT!"=="OFF" (
        call:MSGBOX "Would you like to disable CPU idle state ?\n\nDisabling the CPU idle state reduces latency but increases the CPU temperature." vbYesNo+vbQuestion "Power settings"
        if !ERRORLEVEL! equ 6 (
            call:ECHOX Disabling CPU idle state
            powercfg /setacvalueindex scheme_current sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 1 >nul 2>&1
            powercfg /setactive scheme_current >nul 2>&1
        )
    )

    call:ECHOX Disabling disk power savings
    for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "StorPort"^| findstr "StorPort"') do reg add "%%i" /v "EnableIdlePowerManagement" /t REG_DWORD /d "0" /f >nul 2>&1
    for %%i in (EnableHIPM EnableDIPM EnableHDDParking) do for /f %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f "%%i" ^| findstr "HKEY"') do reg add "%%a" /v "%%i" /t REG_DWORD /d "0" /f >nul 2>&1
    for /f %%i in ('call "resources\smartctl.exe" --scan') do (
        call "resources\smartctl.exe" -s apm,off %%i
        call "resources\smartctl.exe" -s aam,off %%i
    ) >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Storage" /v "StorageD3InModernStandby" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters\Device" /v "IdlePowerMode" /t REG_DWORD /d "0" /f >nul 2>&1

    call:ECHOX Disabling USB power savings
    for %%i in (EnhancedPowerManagementEnabled AllowIdleIrpInD3 EnableSelectiveSuspend DeviceSelectiveSuspended
        SelectiveSuspendEnabled SelectiveSuspendOn EnumerationRetryCount ExtPropDescSemaphore WaitWakeEnabled
        D3ColdSupported WdfDirectedPowerTransitionEnable EnableIdlePowerManagement IdleInWorkingState) do for /f %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "%%i"^| findstr "HKEY"') do reg add "%%a" /v "%%i" /t REG_DWORD /d "0" /f >nul 2>&1

    call:ECHOX Disabling devices power saving
    call:POWERSHELL "$devices = Get-WmiObject Win32_PnPEntity; $powerMgmt = Get-WmiObject MSPower_DeviceEnable -Namespace root\wmi; foreach ($p in $powerMgmt){$IN = $p.InstanceName.ToUpper(); foreach ($h in $devices){$PNPDI = $h.PNPDeviceID; if ($IN -like \"*$PNPDI*\"){$p.enable = $False; $p.psbase.put()}}}"
)

call:ECHOX Disabling background apps
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\bam" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dam" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1

call:ECHOX Organize services into associated host groups
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "!SVCHOST!" /f >nul 2>&1

call:ECHOX Process scheduling
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "38" /f >nul 2>&1

call:ECHOX Multimedia class scheduler
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "10" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "10" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "LazyModeTimeout" /t REG_DWORD /d "150000" /f >nul 2>&1

call:ECHOX Disabling 8dot3 name creation for all volumes on the system
fsutil behavior set disable8dot3 1 >nul 2>&1

call:ECHOX Disabling NTS last-access timestamp and NTS log
fsutil behavior set disablelastaccess 1 >nul 2>&1

call:ECHOX Disabling file system compression
fsutil behavior set disablecompression 1 >nul 2>&1

call:ECHOX Disabling virtual memory page file encryption
fsutil behavior set encryptpagingfile 0 >nul 2>&1

call:ECHOX Increasing file system memory cache size
call:ECHOX Increasing the space reserved for the MFT
if !TOTAL_MEMORY! LSS 8000000 (
	fsutil behavior set memoryusage 1
	fsutil behavior set mftzone 1
) >nul 2>&1 else if !TOTAL_MEMORY! LSS 16000000 (
	fsutil behavior set memoryusage 1
	fsutil behavior set mftzone 2
) >nul 2>&1 else (
	fsutil behavior set memoryusage 2
	fsutil behavior set mftzone 2
) >nul 2>&1

call:ECHOX Disabling memory compression and page combining
call:POWERSHELL "Disable-MMAgent -MemoryCompression"
call:POWERSHELL "Disable-MMAgent -PageCombining"

call:ECHOX Disabling random drivers verification
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\memory management" /v "DontVerifyRandomDrivers" /t REG_DWORD /d "1" /f >nul 2>&1

if "!STORAGE_TYPE!"=="SSD/NVMe" (
    call:ECHOX Applying SSD/NVMe tweaks
    fsutil behavior set disabledeletenotify 0 >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\memory management\prefetchparameters" /v "EnableBoottrace" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\memory management\prefetchparameters" /v "EnablePrefetcher" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\memory management\prefetchparameters" /v "EnableSuperfetch" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction" /v "Enable" /t REG_SZ /d "N" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OptimalLayout" /v "EnableAutoLayout" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SysMain" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\FontCache" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t REG_MULTI_SZ /d "" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\rdyboost" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    call:POWERSHELL "Optimize-Volume -DriveLetter C -ReTrim"
)

call:MSGBOX "Would you like to enable Fullscreen Exclusive and disable GameBar ?\n\nBy default Windows use fullscreen optimization. It overrides the fullscreen mode in games and forces it to a borderless hybrid mode which comes with high latency and lower performance." vbYesNo+vbQuestion "Fullscreen Exclusive"
if !ERRORLEVEL! equ 6 (
    call:ECHOX Enabling FSE and disabling GameBar
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\GameBar" /v "GamePanelStartupTipIndex" /t REG_DWORD /d "3" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\System\GameConfigStore" /v "GameDVR_DSEBehavior" /t REG_DWORD /d "2" /f >nul 2>&1
    reg add "HKU\!USER_SID!\System\GameConfigStore" /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d "2" /f >nul 2>&1
    reg add "HKU\!USER_SID!\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "2" /f >nul 2>&1
    reg add "HKU\!USER_SID!\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR" /v "value" /t REG_DWORD /d "0" /f >nul 2>&1
    reg delete "HKU\!USER_SID!\System\GameConfigStore\Children" /f >nul 2>&1
    reg delete "HKU\!USER_SID!\System\GameConfigStore\Parents" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter" /v "ActivationType" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "__COMPAT_LAYER" /t REG_SZ /d "~ DISABLEDXMAXIMIZEDWINDOWEDMODE" /f >nul 2>&1
)

call:MSGBOX "Would you like to set system processes that use cycles to low priority ?" vbYesNo+vbQuestion "Process priority"
if !ERRORLEVEL! equ 6 (
    call:ECHOX Setting system processes priority to low priority
    copy /y "%windir%\System32\svchost.exe" "%windir%\System32\audiosvchost.exe" >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Audiosrv" /v "ImagePath" /t REG_EXPAND_SZ /d "%windir%\System32\audiosvchost.exe -k LocalServiceNetworkRestricted -p" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\AudioEndpointBuilder" /v "ImagePath" /t REG_EXPAND_SZ /d "%windir%\System32\audiosvchost.exe -k LocalSystemNetworkRestricted -p" /f >nul 2>&1
    for /f "tokens=*" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options"') do reg delete "%%i" /f >nul 2>&1
    for %%i in (fontdrvhost lsass svchost spoolsv sppsvc WmiPrvSE) do (
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>&1
    )
)

call:ECHOX Setting CSRSS priority to high
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>&1

call:ECHOX Removing IRQ priorities
for /f %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /f "irq"^| findstr "IRQ"') do reg delete "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "%%i" /f >nul 2>&1

call:ECHOX Enabling MSI mode for PCI devices
REM for /f %%i in ('wmic path Win32_IDEController get PNPDeviceID^| findstr /l "PCI\VEN_"') do reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f >nul 2>&1
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID^| findstr /l "PCI\VEN_"') do reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f >nul 2>&1
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /l "PCI\VEN_"') do reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f >nul 2>&1
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /l "PCI\VEN_"') do reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f >nul 2>&1

call:ECHOX Removing devices priority
for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "Affinity Policy"^| findstr /l "PCI\VEN_"') do reg delete "%%i" /v "DevicePriority" /f >nul 2>&1

call:ECHOX Enabling hardware accelerated GPU scheduling in the DirectX Graphics kernel
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d "2" /f >nul 2>&1

call:ECHOX Force contiguous memory allocation in the DirectX Graphics kernel
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DpiMapIommuContiguous" /t REG_DWORD /d "1" /f >nul 2>&1

call:MSGBOX "Would you like to disable GPU preemption ?\n\nGPU preemption is responsible for interrupting active GPU task and replacing it with another task.\n\nDisabling preemption may improve performance as it promotes GPU throughput." vbYesNo+vbQuestion "GPU"
if !ERRORLEVEL! equ 6 (
    call:ECHOX Disabling GPU preemption
    reg add "HKLM\SYSTEM\ControlSet001\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /t REG_DWORD /d "0" /f >nul 2>&1
    if "!GPU!"=="NVIDIA" (
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisablePreemption" /t Reg_DWORD /d "1" /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisableCudaContextPreemption" /t Reg_DWORD /d "1" /f
    ) >nul 2>&1
    for /f %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" /s /v "DriverDesc"^| findstr "HKEY AMD ATI"') do if /i "%%i" neq "DriverDesc" (set "REGPATH_AMD=%%i") else reg add "!REGPATH_AMD!" /v "KMD_EnableComputePreemption" /t REG_DWORD /d "0" /f >nul 2>&1
)

if "!GPU!"=="NVIDIA" (
    call:ECHOX Applying Nvidia GPU tweaks
    for /f %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" /s /v "DriverDesc"^| findstr "HKEY NVIDIA"') do if /i "%%i" neq "DriverDesc" (set "REGPATH_NVIDIA=%%i") else (
        if "!POWER_SAVING!"=="OFF" (
            reg add "!REGPATH_NVIDIA!" /v "PerfLevelSrc" /t REG_DWORD /d "8738" /f
            reg add "!REGPATH_NVIDIA!" /v "powermizerenable" /t REG_DWORD /d "1" /f
            reg add "!REGPATH_NVIDIA!" /v "powermizerlevel" /t REG_DWORD /d "1" /f
            reg add "!REGPATH_NVIDIA!" /v "powermizerlevelac" /t REG_DWORD /d "1" /f
        )
        reg add "!REGPATH_NVIDIA!" /v "PreferSystemMemoryContiguous" /t REG_DWORD /d "1" /f
    ) >nul 2>&1

    call:ECHOX Disabling Nvidia telemetry
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\NvTelemetryContainer" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\NVIDIA Corporation\NVControlPanel2\Client" /v "OptInOrOutPreference" /t REG_DWORD /d "0" /f >nul 2>&1
    for %%i in (NvTmMon NvTmRep NvProfile) do for /f "tokens=1 delims=," %%a in ('schtasks /query /fo csv^| findstr /v "TaskName"^| findstr "%%~i"') do schtasks /change /tn "%%a" /disable >nul 2>&1

    call:ECHOX Importing Nvidia profile
    taskkill /f /im "nvcplui.exe" >nul 2>&1
    start "" "resources\nvidiaProfileInspector.exe" "resources\BaseProfile.nip" -silentImport
)

if "!GPU!"=="AMD" (
    call:ECHOX Applying AMD GPU tweaks
    for /f %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" /s /v "DriverDesc"^| findstr "HKEY AMD ATI"') do if /i "%%i" neq "DriverDesc" (set "REGPATH_AMD=%%i") else (
        if "!POWER_SAVING!"=="OFF" (
            reg add "!REGPATH_AMD!" /v "AsicOnLowPower" /t REG_DWORD /d "0" /f
            reg add "!REGPATH_AMD!" /v "EnableUlps" /t REG_DWORD /d "0" /f
            reg add "!REGPATH_AMD!" /v "GCOOPTION_DisableGPIOPowerSaveMode" /t REG_DWORD /d "1" /f
            reg add "!REGPATH_AMD!" /v "PP_GPUPowerDownEnabled" /t REG_DWORD /d "0" /f
            reg add "!REGPATH_AMD!" /v "PP_SclkDeepSleepDisable" /t REG_DWORD /d "1" /f
            reg add "!REGPATH_AMD!" /v "PP_ThermalAutoThrottlingEnable" /t REG_DWORD /d "0" /f
            reg add "!REGPATH_AMD!" /v "PP_DisableSQRamping" /t REG_DWORD /d "1" /f
            reg add "!REGPATH_AMD!" /v "PP_DisablePowerContainment" /t REG_DWORD /d "1" /f
            reg add "!REGPATH_AMD!" /v "KMD_EnableContextBasedPowerManagement" /t REG_DWORD /d "0" /f
            reg add "!REGPATH_AMD!" /v "KMD_ChillEnabled" /t REG_DWORD /d "0" /f
            reg add "!REGPATH_AMD!" /v "DisableDrmdmaPowerGating" /t REG_DWORD /d "1" /f
            reg add "!REGPATH_AMD!" /v "DisableUVDPowerGating" /t REG_DWORD /d "1" /f
            reg add "!REGPATH_AMD!" /v "DisableUVDPowerGatingDynamic" /t REG_DWORD /d "1" /f
            reg add "!REGPATH_AMD!" /v "DisableVCEPowerGating" /t REG_DWORD /d "1" /f
            reg add "!REGPATH_AMD!" /v "DisableSAMUPowerGating" /t REG_DWORD /d "1" /f
            reg add "!REGPATH_AMD!" /v "DisablePowerGating" /t REG_DWORD /d "1" /f
            reg add "!REGPATH_AMD!" /v "EnableUvdClockGating" /t REG_DWORD /d "0" /f
            reg add "!REGPATH_AMD!" /v "EnableVceSwClockGating" /t REG_DWORD /d "0" /f
            reg add "!REGPATH_AMD!" /v "DisableAllClockGating" /t REG_DWORD /d "1" /f
            reg add "!REGPATH_AMD!" /v "PP_ForceHighDPMLevel" /t REG_DWORD /d "1" /f
        )
        reg add "!REGPATH_AMD!" /v "StutterMode" /t REG_DWORD /d "0" /f
        reg add "!REGPATH_AMD!" /v "PP_Force3DPerformanceMode" /t REG_DWORD /d "1" /f
        reg add "!REGPATH_AMD!" /v "DisableDMACopy" /t REG_DWORD /d "1" /f
        reg add "!REGPATH_AMD!" /v "DisableBlockWrite" /t REG_DWORD /d "0" /f
        reg add "!REGPATH_AMD!\UMD" /v "Main3D_DEF" /t REG_SZ /d "1" /f
        reg add "!REGPATH_AMD!\UMD" /v "Main3D" /t REG_BINARY /d "3100" /f
        reg add "!REGPATH_AMD!\UMD" /v "FlipQueueSize" /t REG_BINARY /d "3100" /f
        reg add "!REGPATH_AMD!\UMD" /v "ShaderCache" /t REG_BINARY /d "3200" /f
        reg add "!REGPATH_AMD!\UMD" /v "Tessellation_OPTION" /t REG_BINARY /d "3200" /f
        reg add "!REGPATH_AMD!\UMD" /v "Tessellation" /t REG_BINARY /d "3100" /f
        reg add "!REGPATH_AMD!\UMD" /v "VSyncControl" /t REG_BINARY /d "3000" /f
        reg add "!REGPATH_AMD!\UMD" /v "TFQ" /t REG_BINARY /d "3200" /f
    ) >nul 2>&1

    call:ECHOX Disabling AMD logging service
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\amdlog" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
)

if "!GPU!"=="INTEL" (
    call:ECHOX Applying Intel iGPU tweaks
    for /f %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" /s /v "DriverDesc"^| findstr "HKEY Intel"') do if /i "%%i" neq "DriverDesc" (set "REGPATH_INTEL=%%i") else (
        if "!POWER_SAVING!"=="OFF" reg add "!REGPATH_INTEL!" /v "AllowDeepCStates" /t REG_DWORD /d "0" /f
        reg add "!REGPATH_INTEL!" /v "Disable_OverlayDSQualityEnhancement" /t REG_DWORD /d "1" /f
        reg add "!REGPATH_INTEL!" /v "IncreaseFixedSegment" /t REG_DWORD /d "1" /f
        reg add "!REGPATH_INTEL!" /v "AdaptiveVsyncEnable" /t REG_DWORD /d "0" /f
        reg add "!REGPATH_INTEL!" /v "DisablePFonDP" /t REG_DWORD /d "1" /f
        reg add "!REGPATH_INTEL!" /v "EnableCompensationForDVI" /t REG_DWORD /d "1" /f
        reg add "!REGPATH_INTEL!" /v "NoFastLinkTrainingForeDP" /t REG_DWORD /d "0" /f
        reg add "!REGPATH_INTEL!" /v "ACPowerPolicyVersion" /t REG_DWORD /d "16898" /f
        reg add "!REGPATH_INTEL!" /v "DCPowerPolicyVersion" /t REG_DWORD /d "16642" /f
    ) >nul 2>&1
)

call "resources\choicebox.exe" "Remove OneDrive;Remove Xbox apps;Disable Windows Search;Disable themes management;Disable push notifications and action center;Disable Task Scheduler;Disable diagnostics;Disable Windows Update;Disable Wi-Fi support;Disable bluetooth support;Disable printer support;Disable VPN and PPPoE support;Disable Bitlocker support;Disable QoS support;Disable IPv6 support;Disable files and printers share support" "Here you can configure Windows services based on your computer usage" "Services" /C:2 >"%TMP%\services.txt"
findstr /c:"Remove OneDrive" "%TMP%\services.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Remove OneDrive
    taskkill /f /im "OneDrive.exe" >nul 2>&1
    if exist "%WinDir%\System32\OneDriveSetup.exe" start /wait "%WinDir%\System32\OneDriveSetup.exe" /uninstall >nul 2>&1
    if exist "%WinDir%\SysWOW64\OneDriveSetup.exe" start /wait "%WinDir%\SysWOW64\OneDriveSetup.exe" /uninstall >nul 2>&1
    rd /s /q "%UserProfile%\OneDrive" >nul 2>&1
    rd /s /q "%SystemDrive%\OneDriveTemp">nul 2>&1
    rd /s /q "%LocalAppData%\Microsoft\OneDrive" >nul 2>&1
    rd /s /q "%ProgramData%\Microsoft OneDrive" >nul 2>&1
    reg delete "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f >nul 2>&1
    reg delete "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f >nul 2>&1
    call "resources/install_wim_tweak.exe" /o /c Microsoft-Windows-OneDrive-Setup-Package /r >nul 2>&1
    call "resources/install_wim_tweak.exe" /o /c Microsoft-Windows-OneDrive-Setup-WOW64-Package /r >nul 2>&1
)
findstr /c:"Remove Xbox apps" "%TMP%\services.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Removing Xbox apps
    for %%i in (XblGameSave XblAuthManager XboxNetApiSvc XboxGipSvc xbgm) do (
        reg query "HKLM\SYSTEM\CurrentControlSet\Services\%%~i" /ve
        if !ERRORLEVEL! equ 0 reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%~i" /v "Start" /t REG_DWORD /d "4" /f
    ) >nul 2>&1
    call:POWERSHELL "$AppxPackages = @(\"Microsoft.XboxIdentityProvider\",\"Microsoft.XboxApp\",\"Microsoft.Xbox.TCUI\",\"Microsoft.XboxSpeechToTextOverlay\",\"Microsoft.XboxGamingOverlay\",\"Microsoft.XboxGameOverlay\",\"Microsoft.GamingApp\",\"Microsoft.GamingServices\");foreach ($AppxPackage in $AppxPackages){Get-AppxPackage -Name $AppxPackage -AllUsers | Remove-AppxPackage -AllUsers}"
)
findstr /c:"Disable Windows Search" "%TMP%\services.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling Windows Search
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\wsearch" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "CTFMon" /t REG_SZ /d "%WinDir%\System32\ctfmon.exe" /f >nul 2>&1
    if exist "%WinDir%\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy" (
        taskkill /f /im "SearchApp.exe"
        move "%WinDir%\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy" "%WinDir%\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy.backup"
    ) >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Disable themes management" "%TMP%\services.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling themes management
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Themes" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
)
findstr /c:"Disable push notifications and action center" "%TMP%\services.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling push notifications and action center
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WpnUserService" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "1" /f >nul 2>&1
)
findstr /c:"Disable Task Scheduler" "%TMP%\services.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling task scheduler
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Schedule" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\TimeBrokerSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
)
findstr /c:"Disable diagnostics" "%TMP%\services.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling diagnostics
    for %%i in (diagsvc DPS WdiServiceHost WdiSystemHost) do (
        reg query "HKLM\SYSTEM\CurrentControlSet\Services\%%~i" /ve
        if !ERRORLEVEL! equ 0 reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%~i" /v "Start" /t REG_DWORD /d "4" /f
    ) >nul 2>&1
)
findstr /c:"Disable Windows Update" "%TMP%\services.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling Windows Update
    for %%i in (wuauserv WaaSMedicSvc PeerDistSvc UsoSvc BITS CryptSvc) do (
        reg query "HKLM\SYSTEM\CurrentControlSet\Services\%%~i" /ve
        if !ERRORLEVEL! equ 0 reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%~i" /v "Start" /t REG_DWORD /d "4" /f
    ) >nul 2>&1
) else set "WIN_UPDATE=ENABLED"
findstr /c:"Disable Wi-Fi support" "%TMP%\services.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling Wi-Fi support
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WlanSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\vwififlt" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
)
findstr /c:"Disable bluetooth support" "%TMP%\services.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling bluetooth support
    for %%i in (BTAGService bthserv BthAvctpSvc NaturalAuthentication BluetoothUserService CDPUserSvc) do (
        reg query "HKLM\SYSTEM\CurrentControlSet\Services\%%~i" /ve
        if !ERRORLEVEL! equ 0 reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%~i" /v "Start" /t REG_DWORD /d "4" /f
    ) >nul 2>&1
)
findstr /c:"Disable printer support" "%TMP%\services.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling printer support
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Spooler" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
)
findstr /c:"Disable VPN and PPPoE support" "%TMP%\services.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling VPN and PPPoE support
    for %%i in (PptpMiniport RasAgileVpn Rasl2tp RasSstp RasPppoe RasMan) do (
        reg query "HKLM\SYSTEM\CurrentControlSet\Services\%%~i" /ve
        if !ERRORLEVEL! equ 0 reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%~i" /v "Start" /t REG_DWORD /d "4" /f
    ) >nul 2>&1
)
findstr /c:"Disable Bitlocker support" "%TMP%\services.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling Bitlocker support
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t REG_MULTI_SZ /d "" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\fvevol" /v "ErrorControl" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\fvevol" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\BDESVC" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
)
findstr /c:"Disable QoS support" "%TMP%\services.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling QoS support
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Psched" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    call:POWERSHELL "Disable-NetAdapterBinding -Name * -ComponentID ms_pacer"
)
findstr /c:"Disable IPv6 support" "%TMP%\services.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling IPv6
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\iphlpsvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    call:POWERSHELL "Disable-NetAdapterBinding -Name * -ComponentID ms_tcpip6"
)
findstr /c:"Disable files and printers share support" "%TMP%\services.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling files and printers share support
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    call:POWERSHELL "Disable-NetAdapterBinding -Name * -ComponentID ms_server"
    call:POWERSHELL "Disable-NetAdapterBinding -Name * -ComponentID ms_msclient"
    DISM /online /Disable-Feature /FeatureName:"SmbDirect" /All /NoRestart >nul 2>&1
)
del /f /q "%TMP%\services.txt" >nul 2>&1

call:MSGBOX "Would you like to disable extra services ?\n\nList of services that will be disabled:\ntdx, Beep, Telemetry, GpuEnergyDrv, tcpipreg, Ndu, edgeupdate, edgeupdatem\n\nDisabling these services may cause compatibility issues (depending on your system usage)." vbYesNo+vbQuestion "Services"
if !ERRORLEVEL! equ 6 (
    call:ECHOX Disabling extra services
    reg query "HKLM\SYSTEM\CurrentControlSet\Services\Dhcp" /f "NSI\0Tdx\0Afd" >nul 2>&1
    if !ERRORLEVEL! equ 0 (
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dhcp" /v "DependOnService" /t REG_MULTI_SZ /d "NSI\0Afd" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache" /v "DependOnService" /t REG_MULTI_SZ /d "nsi" /f >nul 2>&1
    ) else reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetBT" /v "DependOnService" /t REG_MULTI_SZ /d "tcpip" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\tdx" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Beep" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Telemetry" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\tcpipreg" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Ndu" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\System\CurrentControlSet\Services\edgeupdate" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\System\CurrentControlSet\Services\edgeupdatem" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
)

if "!WIN_UPDATE!"=="ENABLED" (
    call "resources\choicebox.exe" "Disable Windows auto update;Disable Windows update auto restart;Disable automatic driver updates;Prevent malicious software removal tool from installing" "Here you can configure Windows Update" "Windows Update" /C:1 >"%TMP%\update.txt"
    findstr /c:"Disable Windows auto update" "%TMP%\update.txt" >nul 2>&1
    if !ERRORLEVEL! equ 0 (
        call:ECHOX Disabling Windows auto update
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f >nul 2>&1
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "2" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\wuauserv" /v "Start" /t REG_DWORD /d "3" /f >nul 2>&1
        for %%i in ("UpdateOrchestrator\Reboot" "UpdateOrchestrator\Refresh Settings" "UpdateOrchestrator\USO_UxBroker_Display"
            "UpdateOrchestrator\USO_UxBroker_ReadyToReboot" "WindowsUpdate\sih" "WindowsUpdate\sihboot") do schtasks /change /tn "Microsoft\Windows\%%~i" /disable >nul 2>&1
        schtasks /delete /tn "Microsoft\Windows\UpdateOrchestrator\Schedule Scan" /f >nul 2>&1
        schtasks /delete /tn "Microsoft\Windows\WindowsUpdate\Scheduled Start" /f >nul 2>&1
    )
    findstr /c:"Disable Windows update auto restart" "%TMP%\update.txt" >nul 2>&1
    if !ERRORLEVEL! equ 0 (
        call:ECHOX Disabling Windows update auto restart
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoRebootWithLoggedOnUsers" /t REG_DWORD /d "1" /f >nul 2>&1
        reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AlwaysAutoRebootAtScheduledTime" /t REG_DWORD /d "0" /f >nul 2>&1
    )
    findstr /c:"Disable automatic driver updates" "%TMP%\update.txt" >nul 2>&1
    if !ERRORLEVEL! equ 0 (
        call:ECHOX Disabling automatic driver updates
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f >nul 2>&1
    )
    findstr /c:"Prevent malicious software removal tool from installing" "%TMP%\update.txt" >nul 2>&1
    if !ERRORLEVEL! equ 0 (
        call:ECHOX Preventing malicious software removal tool from installing
        reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d "1" /f >nul 2>&1
    )
    del /f /q "%TMP%\update.txt" >nul 2>&1
)

call:ECHOX Cleaning non-present devices
call:POWERSHELL "$Devices = Get-PnpDevice | ? Status -eq Unknown;foreach ($Device in $Devices) { &\"pnputil\" /remove-device $Device.InstanceId }"

call:ECHOX Disabling HPET
bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /set disabledynamictick Yes >nul 2>&1
call:POWERSHELL "Get-PnpDevice | Where-Object { $_.InstanceId -like 'ACPI\PNP0103\2&daba3ff&*' } | Disable-PnpDevice -Confirm:$false"

call:ECHOX Disabling synthetic timer
bcdedit /set useplatformtick Yes >nul 2>&1

call:MSGBOX "Would you like to install Timer Resolution Service ?\n\nChange your Windows timer resolution to 0.5ms to improve performance and responsiveness for games and peripherals." vbYesNo+vbQuestion "Timer Resolution"
if !ERRORLEVEL! equ 6 (
    if "!VC!"=="NOT_INSTALLED" call:CHOCO vcredist-all
    call:ECHOX Installing Timer Resolution Service
    if not exist "%WinDir%\SetTimerResolutionService.exe" copy "resources\SetTimerResolutionService.exe" "%WinDir%" >nul 2>&1
    call "%WinDir%\SetTimerResolutionService.exe" -Install >nul 2>&1
)

call:MSGBOX "Would you like to remove all non-essential Microsoft Store apps ?" vbYesNo+vbQuestion "Bloatware"
if !ERRORLEVEL! equ 6 (
    call:ECHOX Removing Microsoft Store bloatware
    call:POWERSHELL "$ExcludedAppxPackages = @(\"Microsoft.DesktopAppInstaller\",\"Microsoft.WindowsStore\",\"Microsoft.StorePurchaseApp\",\"Microsoft.WindowsNotepad\",\"Microsoft.WindowsTerminal\",\"Microsoft.WindowsTerminalPreview\",\"Microsoft.WebMediaExtensions\",\"Microsoft.WindowsCamera\",\"Microsoft.WindowsCalculator\",\"Microsoft.Windows.Photos\",\"Microsoft.Photos.MediaEngineDLC\",\"Microsoft.HEVCVideoExtension\",\"Microsoft.ScreenSketch\",\"Microsoft.Windows.CapturePicker\",\"Microsoft.Paint\",\"Microsoft.XboxIdentityProvider\",\"Microsoft.XboxApp\",\"Microsoft.Xbox.TCUI\",\"Microsoft.XboxSpeechToTextOverlay\",\"Microsoft.XboxGamingOverlay\",\"Microsoft.XboxGameOverlay\",\"Microsoft.GamingApp\",\"Microsoft.GamingServices\",\"AppUp.IntelGraphicsControlPanel\",\"AppUp.IntelGraphicsExperience\",\"NVIDIACorp.NVIDIAControlPanel\",\"AdvancedMicroDevicesInc-2.AMDRadeonSoftware\",\"RealtekSemiconductorCorp.RealtekAudioControl\");$AppxPackages = (Get-AppxPackage -PackageTypeFilter Bundle -AllUsers).Name | Select-String $ExcludedAppxPackages -NotMatch;foreach ($AppxPackage in $AppxPackages){Get-AppxPackage -PackageTypeFilter Bundle -AllUsers | Where-Object -FilterScript {$_.Name -cmatch $AppxPackage} | Remove-AppxPackage -AllUsers}"
)

call:MSGBOX "Would you like to apply network tweaks ?\n\nEssentially based on speedguide.net" vbYesNo+vbQuestion "Network"
if !ERRORLEVEL! equ 6 (
    call:ECHOX Applying network tweaks
    if "!NIC_TYPE!"=="WIFI" (netsh int tcp set supplemental internet congestionprovider=newreno >nul 2>&1) else netsh int tcp set supplemental internet congestionprovider=CUBIC >nul 2>&1
    call:MSGBOX "Would you like to disable network autotuning ?\n\nCan reduce bufferbloat, but it can significantly decrease your network speed." vbYesNo+vbQuestion "Network"
    if !ERRORLEVEL! equ 6 (
        call:ECHOX Disabling network Autotuning
        netsh int tcp set global autotuninglevel=disabled >nul 2>&1
    ) else netsh int tcp set global autotuninglevel=normal >nul 2>&1
    netsh int tcp set global ecncapability=disabled >nul 2>&1
    netsh int tcp set global dca=enabled >nul 2>&1
    netsh int tcp set global netdma=enabled >nul 2>&1
    netsh int tcp set global rsc=disabled >nul 2>&1
    netsh int tcp set global rss=enabled >nul 2>&1
    netsh int tcp set global timestamps=disabled >nul 2>&1
    netsh int tcp set global initialRto=2000 >nul 2>&1
    netsh int tcp set global nonsackrttresiliency=disabled >nul 2>&1
    netsh int tcp set global maxsynretransmissions=2 >nul 2>&1
    netsh int tcp set security mpp=disabled >nul 2>&1
    netsh int tcp set security profiles=disabled >nul 2>&1
    netsh int tcp set heuristics disabled >nul 2>&1
    netsh int ip set global neighborcachelimit=4096 >nul 2>&1
    call:POWERSHELL "Set-NetTCPSetting -SettingName InternetCustom -MinRto 300"
    call:POWERSHELL "Set-NetTCPSetting -SettingName InternetCustom -InitialCongestionWindow 10"
    call:POWERSHELL "Set-NetOffloadGlobalSetting -Chimney Disabled"
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d "64" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDupAcks" /t REG_DWORD /d "2" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SackOpts" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d "65534" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d "30" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock" /v "UseDelayedAcceptance" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock" /v "MaxSockAddrLength" /t REG_DWORD /d "16" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock" /v "MinSockAddrLength" /t REG_DWORD /d "16" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t REG_DWORD /d "5" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t REG_DWORD /d "6" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t REG_DWORD /d "7" /f >nul 2>&1
    call:MSGBOX "Would you like to disable Nagle's Algorithm ?\n\nDisabling nagling can reduce latency/ping in some games.\nKeep in mind that disabling Nagle's algorithm may also have some negative effect on file transfers." vbYesNo+vbQuestion "Network"
    if !ERRORLEVEL! equ 6 (
        call:ECHOX Disabling Nagle's Algorithm
        for /f %%i in ('wmic path win32_networkadapter get GUID^| findstr "{"') do (
            reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f
            reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TcpDelAckTicks" /t REG_DWORD /d "0" /f
            reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TCPNoDelay" /t REG_DWORD /d "1" /f
        ) >nul 2>&1
    )
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "EnableAutoDoh" /t REG_DWORD /d "2" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "DoNotHoldNicBuffers" /t REG_DWORD /d "1" /f >nul 2>&1

    call:MSGBOX "Would you like to optimize your NIC's ?\n\nWill set best settings to ensure maximum performance (throughput and latency stability)" vbYesNo+vbQuestion "Network"
    if !ERRORLEVEL! equ 6 (
        call:ECHOX Applying NIC's settings
        if "!POWER_SAVING!"=="OFF" (
            call:NIC_SETTINGS "PnPCapabilities" "24"
            call:NIC_SETTINGS "PowerDownPll" "0"
            call:NIC_SETTINGS "*DeviceSleepOnDisconnect" "0"
            call:NIC_SETTINGS "AutoPowerSaveModeEnabled" "0"
            call:NIC_SETTINGS "EEELinkAdvertisement" "0"
            call:NIC_SETTINGS "EnableSavePowerNow" "0"
            call:NIC_SETTINGS "EnablePowerManagement" "0"
            call:NIC_SETTINGS "EnablePME" "0"
            call:NIC_SETTINGS "EnableDynamicPowerGating" "0"
            call:NIC_SETTINGS "EnableConnectedPowerGating" "0"
            call:NIC_SETTINGS "*EnableDynamicPowerGating" "0"
            call:NIC_SETTINGS "*NicAutoPowerSaver" "0"
            call:NIC_SETTINGS "*EEE" "0"
            call:NIC_SETTINGS "EEE" "0"
            call:NIC_SETTINGS "AdvancedEEE" "0"
            call:NIC_SETTINGS "AutoDisableGigabit" "0"
            call:NIC_SETTINGS "EnableGreenEthernet" "0"
            call:NIC_SETTINGS "GigaLite" "0"
            call:NIC_SETTINGS "DisableDelayedPowerUp" "1"
            call:NIC_SETTINGS "PowerSavingMode" "0"
            call:NIC_SETTINGS "EeeCtrlMode" "2"
            call:NIC_SETTINGS "EeePhyEnable" "0"
            call:NIC_SETTINGS "GphyGreenMode" "4"
            call:NIC_SETTINGS "MasterSlave" "0"
            call:NIC_SETTINGS "ULPMode" "0"
            call:NIC_SETTINGS "ReduceSpeedOnPowerDown" "0"
            call:NIC_SETTINGS "SavePowerNowEnabled" "0"
            call:NIC_SETTINGS "SipsEnabled" "0"
            call:NIC_SETTINGS "MIMOPowerSaveMode" "3"
            call:NIC_SETTINGS "MPC" "0"
            call:NIC_SETTINGS "PwrOut" "100"
            call:NIC_SETTINGS "PowerSaveMode" "0"
            call:NIC_SETTINGS "ApCompatMode" "0"
            call:NIC_SETTINGS "bLeisurePs" "0"
            call:NIC_SETTINGS "bLowPowerEnable" "0"
            call:NIC_SETTINGS "bAdvancedLPs" "0"
            call:NIC_SETTINGS "InactivePs" "0"
            call:NIC_SETTINGS "Enable9KJFTpt" "0"
            call:NIC_SETTINGS "DMACoalescing" "0"
            call:NIC_SETTINGS "*PMWiFiRekeyOffload" "0"
            call:NIC_SETTINGS "uAPSDSupport" "0"
            call:NIC_SETTINGS "*PacketCoalescing" "0"
            call:NIC_SETTINGS "*PMARPOffload" "0"
            call:NIC_SETTINGS "*PMNSOffload" "0"
            call:NIC_SETTINGS "NSOffloadEnable" "0"
            call:NIC_SETTINGS "ARPOffloadEnable" "0"
            call:NIC_SETTINGS "GTKOffloadEnable" "0"
            call:NIC_SETTINGS "WoWLANLPSLevel" "0"
            call:NIC_SETTINGS "WakeOnLink" "0"
            call:NIC_SETTINGS "WakeOnSlot" "0"
            call:NIC_SETTINGS "*ModernStandbyWoLMagicPacket" "0"
            call:NIC_SETTINGS "*WakeOnMagicPacket" "0"
            call:NIC_SETTINGS "*WakeOnPattern" "0"
            call:NIC_SETTINGS "WakeUpModeCap" "0"
            call:NIC_SETTINGS "S5WakeOnLan" "0"
            call:NIC_SETTINGS "WolShutdownLinkSpeed" "2"
            call:NIC_SETTINGS "WakeOnDisconnect" "0"
            call:NIC_SETTINGS "WoWLANS5Support" "0"
            call:NIC_SETTINGS "EnableWakeOnLan" "0"
        )
        call:NIC_SETTINGS "*FlowControl" "0"
        call:NIC_SETTINGS "FlowControlCap" "0"
        call:NIC_SETTINGS "*InterruptModeration" "1"
        call:NIC_SETTINGS "ITR" "65535"
        call:NIC_SETTINGS "*JumboPacket" "1514"
        call:NIC_SETTINGS "LargeSendOffloadJumboCombo" "0"
        call:NIC_SETTINGS "*LsoV1IPv4" "0"
        call:NIC_SETTINGS "*LsoV2IPv4" "0"
        call:NIC_SETTINGS "*LsoV2IPv6" "0"
        call:NIC_SETTINGS "LargeSendOffload" "0"
        call:NIC_SETTINGS "*RSS" "1"
        call:NIC_SETTINGS "*RSSProfile" "3"
        call:NIC_SETTINGS "*RssBaseProcNumber" "1"
        call:NIC_SETTINGS "AlternateSemaphoreDelay" "0"
        call:NIC_SETTINGS "TxIntDelay" "1"
        call:NIC_SETTINGS "*PacketDirect" "1"
        call:POWERSHELL "$NetAdapters = Get-NetAdapterHardwareInfo | Get-NetAdapter;foreach ($NetAdapter in $NetAdapters) {$MaxNumRssQueues = [int](($NetAdapter | Get-NetAdapterAdvancedProperty -RegistryKeyword '*NumRssQueues').ValidRegistryValues | Measure-Object -Maximum).Maximum;$NetAdapter | Set-NetAdapterAdvancedProperty -RegistryKeyword '*NumRssQueues' -RegistryValue $MaxNumRssQueues}"
        call:POWERSHELL "$NetAdapters = Get-NetAdapterHardwareInfo | Get-NetAdapter;foreach ($NetAdapter in $NetAdapters) {$iReceiveBuffers = [int]($NetAdapter | Get-NetAdapterAdvancedProperty -RegistryKeyword '*ReceiveBuffers').NumericParameterMaxValue;$iTransmitBuffers = [int]($NetAdapter | Get-NetAdapterAdvancedProperty -RegistryKeyword '*TransmitBuffers').NumericParameterMaxValue;$NetAdapter | Set-NetAdapterAdvancedProperty -RegistryKeyword '*ReceiveBuffers' -RegistryValue $iReceiveBuffers;$NetAdapter | Set-NetAdapterAdvancedProperty -RegistryKeyword '*TransmitBuffers' -RegistryValue $iTransmitBuffers}"
        if !CORES! gtr 6 (
            call:NIC_SETTINGS "*IPChecksumOffloadIPv4" "0"
            call:NIC_SETTINGS "*TCPChecksumOffloadIPv4" "0"
            call:NIC_SETTINGS "*TCPChecksumOffloadIPv6" "0"
            call:NIC_SETTINGS "*UDPChecksumOffloadIPv4" "0"
            call:NIC_SETTINGS "*UDPChecksumOffloadIPv6" "0"
            call:NIC_SETTINGS "TaskOffloadCap" "0"
        )
        call:NIC_SETTINGS "WirelessMode" "34"
        call:NIC_SETTINGS "CtsToItself" "1"
        call:NIC_SETTINGS "FatChannelIntolerant" "0"
        call:NIC_SETTINGS "b40Intolerant" "0"
        call:NIC_SETTINGS "ProtectionMode" "1"
        call:NIC_SETTINGS "RTD3Enable" "0"
        call:NIC_SETTINGS "IbssQosEnabled" "0"
        call:NIC_SETTINGS "IbssTxPower" "100"
        call:NIC_SETTINGS "ThroughputBoosterEnabled" "1"
        call:NIC_SETTINGS "PropPacketBurstEnabled" "1"
        call:NIC_SETTINGS "TxPwrLevel" "0"
        call:NIC_SETTINGS "Afterburner" "1"
        call:NIC_SETTINGS "FrameBursting" "1"
        if "!NIC_TYPE!"=="WIFI" (
            call:MSGBOX "Would you like to disable Wi-Fi background scanning ?\n\nDisabling the Wi-Fi background scanning can improves latency.\nIt's not recommended if you have a very bad Wi-Fi signal strength ! " vbYesNo+vbQuestion "Network"
            if !ERRORLEVEL! equ 6 (
                call:ECHOX Disabling Wi-Fi background scanning
                call:NIC_SETTINGS "RegROAMSensitiveLevel" "127"
                call:NIC_SETTINGS "RoamAggressiveness" "0"
                call:NIC_SETTINGS "RoamTrigger" "1"
                call:NIC_SETTINGS "RoamDelta" "0"
                call:NIC_SETTINGS "BgScanGlobalBlocking" "2"
                for /f "tokens=1,2*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}" /s /v "*IfType"^| findstr /i "HKEY 0x47"') do if /i "%%i" neq "*IfType" (set "REGPATH_WIFI=%%i") else (
                    reg add "!REGPATH_WIFI!" /v "ScanWhenAssociated" /t REG_DWORD /d "0" /f
                    reg add "!REGPATH_WIFI!" /v "ScanDisableOnLowTraffic" /t REG_DWORD /d "1" /f
                    reg add "!REGPATH_WIFI!" /v "ScanDisableOnMediumTraffic" /t REG_DWORD /d "1" /f
                    reg add "!REGPATH_WIFI!" /v "ScanDisableOnHighOrMulticast" /t REG_DWORD /d "1" /f
                    reg add "!REGPATH_WIFI!" /v "ScanDisableOnLowLatencyOrQos" /t REG_DWORD /d "1" /f
                ) >nul 2>&1
            )
        )
    )
)

call "resources\choicebox.exe" "Disable privacy settings experience at sign-in;Disable app launch tracking;Disabling Windows feedback;Disable pen feedback;Disable PenWorkspace ads;Disable Bluetooth ads;Disable tailored experiences with diagnostic data;Disable shared experiences;Disable Windows Spotlight;Disable automatic apps installation;Disable welcome exeriences;Disable tips, tricks and suggestions;Disable metadata tracking;Disable storage sense;Disable WiFi sense;Disable error reporting;Disable advertising ID;Disable data collection;Disable Windows keylogger;Disable application compatibility telemetry;Disable license checking;Disable inking and typing data collection;Disable Windows Defender reporting;Disable timeline activity history;Disable Cortana;Disable Windows customer experience improvement program;Disable autoLogger;Disable unnecessary scheduled tasks" "Here you can configure Windows telemetry" "Privacy" /C:2 >"%TMP%\privacy.txt"
findstr /c:"Disable privacy settings experience at sign-in" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling privacy settings experience at sign-in
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OOBE" /v "DisablePrivacyExperience" /t REG_DWORD /d "1" /f >nul 2>&1
)
findstr /c:"Disable app launch tracking" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling app launch tracking
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Disabling Windows feedback" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling Windows feedback
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
)
findstr /c:"Disable pen feedback" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling pen feedback
    reg add "HKLM\SOFTWARE\Policies\Microsoft\TabletPC" /v "TurnOffPenFeedback" /t REG_DWORD /d "1" /f >nul 2>&1
)
findstr /c:"Disable PenWorkspace ads" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling PenWorkspace ads
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\PenWorkspace" /v "PenWorkspaceAppSuggestionsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Disable Bluetooth ads" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling Bluetooth ads
    reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Bluetooth" /v "AllowAdvertising" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Disable tailored experiences with diagnostic data" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling tailored experiences with diagnostic data
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Disable shared experiences" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling shared experiences
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" /v "RomeSdkChannelUserAuthzPolicy" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Disable Windows Spotlight" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling Windows Spotlight
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightFeatures" /t REG_DWORD /d "1" /f >nul 2>&1
)
findstr /c:"Disable automatic apps installation" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling automatic apps installation
    for %%i in (ContentDeliveryAllowed OemPreInstalledAppsEnabled PreInstalledAppsEnabled PreInstalledAppsEverEnabled SilentInstalledAppsEnabled) do reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "%%i" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Disable welcome experiences" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling welcome experiences
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Disable tips, tricks and suggestions" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling tips, tricks and suggestions
    for %%i in (SubscribedContent-314559Enabled SubscribedContent-338387Enabled SubscribedContent-338388Enabled SubscribedContent-338389Enabled
        SubscribedContent-338393Enabled SubscribedContent-353694Enabled SubscribedContent-353696Enabled SubscribedContent-314563Enabled
        SubscribedContent-353698Enabled SystemPaneSuggestionsEnabled SoftLandingEnabled FeatureManagementEnabled) do reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "%%i" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableSoftLanding" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Disable metadata tracking" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Removing metadata tracking
    reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /f >nul 2>&1
)
findstr /c:"Disable storage sense" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Removing storage sense
    reg delete "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense" /f >nul 2>&1
)
findstr /c:"Disable WiFi sense" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling WiFi sense
    reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v "value" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v "value" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" /v "AutoConnectAllowedOEM" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Disable error reporting" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling error reporting
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WerSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\wercplsupport" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" /v "DoReport" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
)
findstr /c:"Disable advertising ID" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling advertising ID
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f >nul 2>&1
)
findstr /c:"Disable data collection" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling data collection
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\diagnosticshub.standardcollector.service" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
)
findstr /c:"Disable Windows keylogger" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling Windows keylogger
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
)
findstr /c:"Disable application compatibility telemetry" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling application compatibility telemetry
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d "1" /f >nul 2>&1
)
findstr /c:"Disable license checking" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling license checking
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "AllowWindowsEntitlementReactivation" /t REG_DWORD /d "1" /f >nul 2>&1
)
findstr /c:"Disable inking and typing data collection" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling inking and typing data collection
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f >nul 2>&1
)
findstr /c:"Disable Windows Defender reporting" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling Windows Defender reporting
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "DisableGenericRePorts" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "LocalSettingOverrideSpynetReporting" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpynetReporting" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "2" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "1" /f >nul 2>&1
)
findstr /c:"Disable timeline activity history" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling timeline activity history
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Disable Cortana" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling Cortana
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCortanaButton" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Disable Windows customer experience improvement program" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling Windows customer experience improvement program
    reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient" /v "CorporateSQMURL" /t REG_SZ /d "0.0.0.0" /f >nul 2>&1
)
findstr /c:"Disable autoLogger" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling autoLogger
    for /f %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger" /s /f "start"^| findstr "HKEY"') do reg add "%%i" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Disable unnecessary scheduled tasks" "%TMP%\privacy.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling unnecessary scheduled tasks
    for %%i in ("Application Experience\Microsoft Compatibility Appraiser" "Application Experience\ProgramDataUpdater"
        "Application Experience\StartupAppTask" "Customer Experience Improvement Program\Consolidator"
        "Customer Experience Improvement Program\KernelCeipTask" "Customer Experience Improvement Program\UsbCeip"
        "Customer Experience Improvement Program\Uploader" "Autochk\Proxy" "CloudExperienceHost\CreateObjectTask"
        "DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" "DiskFootprint\Diagnostics") do schtasks /change /tn "Microsoft\Windows\%%~i" /disable >nul 2>&1
)
del /f /q "%TMP%\privacy.txt" >nul 2>&1

call "resources\choicebox.exe" "Disable autoplay and autorun;Disable NetBIOS;Disable remote assistance;Disable remote access;Disable LLMNR;Disable Windows browser protocol;Disable WPAD;Disable WDigest;Disable Windows Scripting Host;Harden SMB;Block untrusted fonts" "Here you can secure your system against threats" "hardening" /C:2 >"%TMP%\hardening.txt"
findstr /c:"Disable autoplay and autorun" "%TMP%\hardening.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling autoplay and autorun
    reg add "HKLM\SOFTWARE\Microsoft\Internet Explorer\Main" /v "Autorun" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutorun" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutoplayfornonVolume" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d "255" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DontSetAutoplayCheckbox" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v "DisableAutoplay" /t REG_DWORD /d "1" /f >nul 2>&1
)
findstr /c:"Disable NetBIOS" "%TMP%\hardening.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling NetBIOS
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetBT" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetBIOS" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\lmhosts" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    for /f %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces" /s /f "NetbiosOptions"^| findstr "HKEY"') do reg add "%%i" /v "NetbiosOptions" /t REG_DWORD /d "2" /f >nul 2>&1
)
findstr /c:"Disable remote assistance" "%TMP%\hardening.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling remote assistance
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowFullControl" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v "fAllowToGetHelp" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v "fAllowFullControl" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Disable remote access" "%TMP%\hardening.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling remote access
    for %%i in (RasAuto SessionEnv TermService UmRdpService RpcLocator) do (
        reg query "HKLM\SYSTEM\CurrentControlSet\Services\%%~i" /ve
        if !ERRORLEVEL! equ 0 reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%~i" /v "Start" /t REG_DWORD /d "4" /f
    ) >nul 2>&1
)
findstr /c:"Disable LLMNR" "%TMP%\hardening.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling LLMNR
    reg add "HKLM\SOFTWARE\policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Disable Windows browser protocol" "%TMP%\hardening.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling Windows browser protocol
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Browser" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
)
findstr /c:"Disable WPAD" "%TMP%\hardening.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling WPAD
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Wpad" /v "WpadOverride" /t REG_DWORD /d "1" /f >nul 2>&1
)
findstr /c:"Disable WDigest" "%TMP%\hardening.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling WDigest
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\Wdigest" /v "UseLogonCredential" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Disable Windows Scripting Host" "%TMP%\hardening.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling WSH
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "WSH" /t REG_SZ /d "cmd.exe /c reg add \"HKLM\SOFTWARE\Microsoft\Windows Script Host\Settings\" /v \"Enabled\" /t REG_DWORD /d \"0\" /f" >nul 2>&1
)
findstr /c:"Harden SMB" "%TMP%\hardening.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Hardening SMB
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RestrictAnonymous" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RestrictAnonymousSAM" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "EveryoneIncludesAnonymous" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "NoLMHash" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "LMCompatibilityLevel" /t REG_DWORD /d "5" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RunAsPPL" /t REG_DWORD /d "1" /f >nul 2>&1
    call:POWERSHELL "Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol"
    call:POWERSHELL "Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol-Client"
    call:POWERSHELL "Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol-Server"
    call:POWERSHELL "Set-SmbClientConfiguration -RequireSecuritySignature $True -Force"
    call:POWERSHELL "Set-SmbClientConfiguration -EnableSecuritySignature $True -Force"
    call:POWERSHELL "Set-SmbServerConfiguration -EncryptData $True -Force"
    call:POWERSHELL "Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force"
)
findstr /c:"Block untrusted fonts" "%TMP%\hardening.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Blocking untrusted fonts
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\MitigationOptions" /v "MitigationOptions_FontBocking" /t REG_QWORD /d "1000000000000" /f >nul 2>&1
)
del /f /q "%TMP%\hardening.txt" >nul 2>&1

call:ECHOX Disabling Bing from Windows search
reg add "HKU\!USER_SID!\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

call:ECHOX Show BSOD details instead of the sad smiley
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "DisplayParameters" /t REG_DWORD /d "1" /f >nul 2>&1

call:ECHOX Disabling first sign-in animation
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableFirstLogonAnimation" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "EnableFirstLogonAnimation" /t REG_DWORD /d "0" /f >nul 2>&1

call:ECHOX Display highly detailed status messages
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "VerboseStatus" /t REG_DWORD /d "1" /f >nul 2>&1

call:ECHOX Disabling balloon tips
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "EnableBalloonTips" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StartButtonBalloonTip" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "FolderContentsInfoTip" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowInfoTip" /t REG_DWORD /d "0" /f >nul 2>&1

call:ECHOX Control panel view always small icons
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel" /v "AllItemsIconView" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel" /v "StartupPage" /t REG_DWORD /d "1" /f >nul 2>&1

call:ECHOX Improving the quality of the imported desktop Wallpaper
reg add "HKU\!USER_SID!\Control Panel\Desktop" /v "JPEGImportQuality" /t REG_DWORD /d "100" /f >nul 2>&1

call:ECHOX Open file explorer to ^'This PC^'
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d "1" /f >nul 2>&1

call:ECHOX Reducing menu show delay time
reg add "HKU\!USER_SID!\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul 2>&1

call:ECHOX Disabling low disk space alerts
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoLowDiskSpaceChecks" /t REG_DWORD /d "1" /f >nul 2>&1

call:ECHOX Explorer shortcuts
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "LinkResolveIgnoreLinkInfo" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveSearch" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveTrack" /t REG_DWORD /d "1" /f >nul 2>&1

call:ECHOX Disabling online content in Explorer
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AllowOnlineTips" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInternetOpenWith" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoOnlinePrintsWizard" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoPublishingWizard" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoWebServices" /t REG_DWORD /d "1" /f >nul 2>&1

call:ECHOX Disabling recent items and frequent places in explorer
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /d "1" /t REG_DWORD /f >nul 2>&1
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ClearRecentDocsOnExit" /d "1" /t REG_DWORD /f >nul 2>&1

call:ECHOX Hiding recently and frequently used folders in quick access
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d "0" /f >nul 2>&1

call:ECHOX Static scroll bars
reg add "HKU\!USER_SID!\Control Panel\Accessibility" /v "DynamicScrollbars" /t REG_DWORD /d "0" /f >nul 2>&1

call:ECHOX Disabling user tracking (recent run)
reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInstrumentation" /d "1" /t REG_DWORD /f >nul 2>&1

call "resources\choicebox.exe" "Remove 3D Objects from file explorer;Remove Library from file explorer;Remove Favorites from file explorer;Remove Family Group from file explorer;Remove Network from file explorer;Remove OneDrive from file explorer;Remove Quick Access from file explorer;Remove all folders in 'This PC' from file explorer;Hide Search box from taskbar;Hide Task view from taskbar;Hide People from taskbar;Hide Windows Ink Workspace from taskbar;Hide Meet Now from taskbar;Hide News and Interests from taskbar;Hide Windows Defender from taskbar;Hide Cortana from taskbar;Enable small icons in taskbar;Show all tray icons on taskbar;Show seconds on taskbar clock;Hide recently added apps in start menu;Hide most used apps in start menu;Unpin all start menu tiles;Increase taskbar transparency level;Disable transparency effect theme;Enable dark mode theme;Set desktop background to solid color;Remove mouse scheme;Adjust visual effects to best performance;Disable lock screen;Reduce size of buttons close minimize maximize;Disable delete confirmation box for recycle Bin;Show file extensions;Show hidden folders;Disable shortcut name extension;Add Take Ownership to context menu;Add classic personalize to context menu;Restore classic windows photo viewer;Enable classic volume control;Enable classic alt tab;Enable Windows 8 network flayout;Disable Boot graphics;Enable F8 Boot menu" "Here you can configure Windows visual settings" "Interfaces" /C:2 >"%TMP%\interface.txt"
findstr /c:"Remove 3D Objects from file explorer" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Removing 3D Objects from file explorer
    reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f >nul 2>&1
    reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f >nul 2>&1
)
findstr /c:"Remove Library from file explorer" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Removing Library from file explorer
    reg add "HKCR\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}\ShellFolder" /v "Attributes" /t REG_DWORD /d "2962227469" /f >nul 2>&1
    reg add "HKCR\WOW6432Node\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}\ShellFolder" /v "Attributes" /t REG_DWORD /d "2962227469" /f >nul 2>&1
)
findstr /c:"Remove Favorites from file explorer" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Removing Favorites from file explorer
    reg add "HKCR\CLSID\{323CA680-C24D-4099-B94D-446DD2D7249E}\ShellFolder" /v "Attributes" /t REG_DWORD /d "2696937728" /f >nul 2>&1
    reg add "HKCR\WOW6432Node\CLSID\{323CA680-C24D-4099-B94D-446DD2D7249E}\ShellFolder" /v "Attributes" /t REG_DWORD /d "2696937728" /f >nul 2>&1
)
findstr /c:"Remove Family Group from file explorer" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Removing Family Group from file explorer
    reg add "HKCR\CLSID\{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}\ShellFolder" /v "Attributes" /t REG_DWORD /d "2962489612" /f >nul 2>&1
    reg add "HKCR\WOW6432Node\CLSID\{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}\ShellFolder" /v "Attributes" /t REG_DWORD /d "2962489612" /f >nul 2>&1
)
findstr /c:"Remove Network from file explorer" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Removing Network from file explorer
    reg add "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" /v "Attributes" /t REG_DWORD /d "2954100836" /f >nul 2>&1
    reg add "HKCR\WOW6432Node\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" /v "Attributes" /t REG_DWORD /d "2954100836" /f >nul 2>&1
)
findstr /c:"Remove OneDrive from file explorer" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Removing OneDrive from file explorer
    reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /v "Attributes" /t REG_DWORD /d "4035969101" /f >nul 2>&1
    reg add "HKCR\WOW6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /v "Attributes" /t REG_DWORD /d "4035969101" /f >nul 2>&1
)
findstr /c:"Remove Quick Access from file explorer" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Removing Quick Access from file explorer
    reg add "HKCR\CLSID\{679f85cb-0220-4080-b29b-5540cc05aab6}\ShellFolder" /v "Attributes" /t REG_DWORD /d "2689597440" /f >nul 2>&1
    reg add "HKCR\WOW6432Node\CLSID\{679f85cb-0220-4080-b29b-5540cc05aab6}\ShellFolder" /v "Attributes" /t REG_DWORD /d "2689597440" /f >nul 2>&1
)
findstr /c:"Remove all folders in 'This PC' from file explorer" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Removing all folders in ^'This PC^' from file explorer
    for %%i in (088e3905-0323-4b02-9826-5d99428e115f 1CF1260C-4DD0-4ebb-811F-33C572699FDE 24ad3ad4-a569-4530-98e1-ab02f9417aa8 374DE290-123F-4565-9164-39C4925E467B
        3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA 3dfdf296-dbec-4fb4-81d1-6a3438bcf4de A0953C92-50DC-43bf-BE83-3742FED03C9C A8CDFF1C-4878-43be-B5FD-F8091C1C60D0
        B4BFCC3A-DB2C-424C-B029-7FE99A87C641 d3162b92-9365-467a-956b-92703aca08af f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a 0DB7E03F-FC29-4DC6-9020-FF41B59E513A) do reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{%%i}" /f >nul 2>&1
)
findstr /c:"Hide Search box from taskbar" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Hiding Search box from taskbar
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Hide Task view from taskbar" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Hiding Task view from taskbar
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Hide People from taskbar" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Hiding People from taskbar
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /v "PeopleBand" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Hide Windows Ink Workspace from taskbar" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Hiding Windows Ink Workspace from taskbar
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\PenWorkspace" /v "PenWorkspaceButtonDesiredVisibility" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Hide Meet Now from taskbar" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Hiding Meet Now from taskbar
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Hide News and Interests from taskbar" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Hiding News and Interests from taskbar
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v "EnableFeeds" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Hide Windows Defender from taskbar" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Hiding Windows Defender from taskbar
    reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SecurityHealth" /f >nul 2>&1
)
findstr /c:"Hide Cortana from taskbar" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Hiding Cortana from taskbar
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCortanaButton" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Enable small icons in taskbar" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Enabling small icons in taskbar
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSmallIcons" /t REG_DWORD /d "1" /f >nul 2>&1
)
findstr /c:"Show all tray icons on taskbar" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Show all tray icons on taskbar
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "EnableAutoTray" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Show seconds on taskbar clock" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Show seconds on taskbar clock
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSecondsInSystemClock" /t REG_DWORD /d "1" /f >nul 2>&1
)
findstr /c:"Hide recently added apps in start menu" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Hiding recently added apps in start menu
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "HideRecentlyAddedApps" /t REG_DWORD /d "1" /f >nul 2>&1
)
findstr /c:"Hide most used apps in start menu" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Hiding most used apps in start menu
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoStartMenuMFUprogramsList" /t REG_DWORD /d "1" /f >nul 2>&1
)
findstr /c:"Unpin all start menu tiles" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Unpinning all start menu tiles
    for /f "tokens=*" %%i in ('reg query "HKU\!USER_SID!\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount" /s /f "start.tilegrid"^| findstr "start.tilegrid"') do reg delete "%%i" /f >nul 2>&1
)
findstr /c:"Increase taskbar transparency level" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Increasing taskbar transparency level
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "UseOLEDTaskbarTransparency" /t REG_DWORD /d "1" /f >nul 2>&1
)
findstr /c:"Disable transparency effect theme" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling transparency effect theme
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableBlurBehind" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows" /v "DisableAcrylicBackgroundOnLogon" /t REG_DWORD /d "1" /f >nul 2>&1
)
findstr /c:"Enable dark mode theme" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Enabling dark mode theme
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Set desktop background to solid color" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Setting desktop background to solid color
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers" /v "BackgroundType" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\Control Panel\Desktop" /v "Wallpaper" /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKU\!USER_SID!\Control Panel\Colors" /v "Background" /t REG_SZ /d "9 17 26" /f >nul 2>&1
)
findstr /c:"Disable Timeline" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling Timeline
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Remove mouse scheme" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Removing mouse scheme
    reg add "HKU\!USER_SID!\Control Panel\Cursors" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKU\!USER_SID!\Control Panel\Cursors" /v "ContactVisualization" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\Control Panel\Cursors" /v "GestureVisualization" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\Control Panel\Cursors" /v "CursorBaseSize" /t REG_DWORD /d "32" /f >nul 2>&1
    reg add "HKU\!USER_SID!\Control Panel\Cursors" /v "Scheme Source" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\Control Panel\Cursors" /v "Crosshair" /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKU\!USER_SID!\Control Panel\Cursors" /v "IBeam" /t REG_SZ /d "" /f >nul 2>&1
    for %%i in (AppStarting Arrow Hand Help No NWPen SizeAll SizeNESW SizeNS SizeNWSE SizeWE UpArrow Wait Person Pin) do reg add "HKU\!USER_SID!\Control Panel\Cursors" /v "%%i" /t REG_SZ /d "" /f >nul 2>&1
)
findstr /c:"Adjust visual effects to best performance" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Setting Visual effects to performance
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f >nul 2>&1
    reg add "HKU\!USER_SID!\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9012038010000000" /f >nul 2>&1
    reg add "HKU\!USER_SID!\Control Panel\Desktop" /v "FontSmoothing" /t REG_SZ /d "2" /f >nul 2>&1
    reg add "HKU\!USER_SID!\Control Panel\Desktop" /v "DragFullWindows" /t REG_SZ /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "IconsOnly" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewAlphaSelect" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewShadow" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SnapAssist" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisallowShaking" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "ColorPrevalence" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\DWM" /v "ColorPrevalence" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\DWM" /v "AlwaysHibernateThumbnails" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "TurnOffSPIAnimations" /t REG_DWORD /d "1" /f >nul 2>&1
)
findstr /c:"Disable lock screen" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling lock screen
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "DisableLogonBackgroundImage" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\SessionData" /v "AllowLockScreen" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreen" /t REG_DWORD /d "1" /f >nul 2>&1
)
findstr /c:"Reduce size of buttons close minimize maximize" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Reducing size of buttons close minimize maximize
    reg add "HKU\!USER_SID!\Control Panel\Desktop\WindowMetrics" /v "CaptionWidth" /t REG_SZ /d "-270" /f >nul 2>&1
    reg add "HKU\!USER_SID!\Control Panel\Desktop\WindowMetrics" /v "CaptionHeight" /t REG_SZ /d "-270" /f >nul 2>&1
)
findstr /c:"Disable delete confirmation box for recycle Bin" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling delete confirmation box for recycle Bin
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ConfirmFileDelete" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Show file extensions" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Show file extensions
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Show hidden folders" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Show hidden folders
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d "1" /f >nul 2>&1
)
findstr /c:"Disable shortcut name extension" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling shortcut name extension
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "link" /t REG_BINARY /d "0" /f >nul 2>&1
)
findstr /c:"Add Take Ownership to context menu" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Adding Take Ownership to context menu
    reg add "HKCR\*\shell\runas" /ve /t REG_SZ /d "Take ownership" /f >nul 2>&1
    reg add "HKCR\*\shell\runas" /v "HasLUAShield" /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKCR\*\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKCR\*\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f >nul 2>&1
    reg add "HKCR\*\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f >nul 2>&1
    reg add "HKCR\Directory\shell\runas" /ve /t REG_SZ /d "Take ownership" /f >nul 2>&1
    reg add "HKCR\Directory\shell\runas" /v "HasLUAShield" /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKCR\Directory\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKCR\Directory\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F" /f >nul 2>&1
    reg add "HKCR\Directory\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F" /f >nul 2>&1
)
findstr /c:"Add classic personalize to context menu" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Adding classic personalize to context menu
    reg delete "HKCR\DesktopBackground\Shell\Personalize" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization" /v "Icon" /t REG_SZ /d "themecpl.dll" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization" /v "MUIVerb" /t REG_SZ /d "Personalize" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization" /v "Position" /t REG_SZ /d "Bottom" /f >nul 2>&1
    reg delete "HKCR\DesktopBackground\Shell\Personalization" /v "Extended" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization" /v "SubCommands" /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\001flyout" /v "MUIVerb" /t REG_SZ /d "Theme Settings" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\001flyout" /v "ControlPanelName" /t REG_SZ /d "Microsoft.Personalization" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\001flyout" /v "Icon" /t REG_SZ /d "themecpl.dll" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\001flyout\command" /ve /t REG_SZ /d "explorer shell:::{ED834ED6-4B5A-4bfe-8F11-A626DCB6A921}" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\002flyout" /v "Icon" /t REG_SZ /d "imageres.dll,-110" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\002flyout" /v "MUIVerb" /t REG_SZ /d "Desktop Background" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\002flyout" /v "CommandFlags" /t REG_DWORD /d "32" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\002flyout\command" /ve /t REG_SZ /d "explorer shell:::{ED834ED6-4B5A-4bfe-8F11-A626DCB6A921} -Microsoft.Personalization\pageWallpaper" /f >nul 2>&1
    reg delete "HKCR\DesktopBackground\Shell\Personalization\shell\003flyout" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\004flyout" /v "Icon" /t REG_SZ /d "themecpl.dll" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\004flyout" /v "MUIVerb" /t REG_SZ /d "Color and Appearance" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\004flyout\command" /ve /t REG_SZ /d "explorer shell:::{ED834ED6-4B5A-4bfe-8F11-A626DCB6A921} -Microsoft.Personalization\pageColorization" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\005flyout" /v "Icon" /t REG_SZ /d "SndVol.exe,-101" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\005flyout" /v "MUIVerb" /t REG_SZ /d "Sounds" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\005flyout\command" /ve /t REG_SZ /d "rundll32.exe shell32.dll,Control_RunDLL mmsys.cpl,,2" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\006flyout" /v "Icon" /t REG_SZ /d "PhotoScreensaver.scr" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\006flyout" /v "MUIVerb" /t REG_SZ /d "Screen Saver Settings" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\006flyout\command" /ve /t REG_SZ /d "rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,1" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\007flyout" /v "Icon" /t REG_SZ /d "desk.cpl" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\007flyout" /v "MUIVerb" /t REG_SZ /d "Desktop Icon Settings" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\007flyout" /v "CommandFlags" /t REG_DWORD /d "32" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\007flyout\command" /ve /t REG_SZ /d "rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,0" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\008flyout" /v "Icon" /t REG_SZ /d "main.cpl" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\008flyout" /v "MUIVerb" /t REG_SZ /d "Mouse Pointers" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\008flyout\command" /ve /t REG_SZ /d "rundll32.exe shell32.dll,Control_RunDLL main.cpl,,1" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\009flyout" /v "Icon" /t REG_SZ /d "taskbarcpl.dll,-1" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\009flyout" /v "MUIVerb" /t REG_SZ /d "Notification Area Icons" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\009flyout" /v "CommandFlags" /t REG_DWORD /d "32" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\009flyout\command" /ve /t REG_SZ /d "explorer shell:::{05d7b0f4-2121-4eff-bf6b-ed3f69b894d9}" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\010flyout" /v "Icon" /t REG_SZ /d "taskbarcpl.dll,-1" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\010flyout" /v "MUIVerb" /t REG_SZ /d "System Icons" /f >nul 2>&1
    reg add "HKCR\DesktopBackground\Shell\Personalization\shell\010flyout\command" /ve /t REG_SZ /d "explorer shell:::{05d7b0f4-2121-4eff-bf6b-ed3f69b894d9} \SystemIcons,,0" /f >nul 2>&1
)
findstr /c:"Restore classic windows photo viewer" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Restoring classic windows photo viewer
    for %%i in (tif tiff bmp dib gif jfif jpe jpeg jpg jxr png) do (
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".%%~i" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f
    ) >nul 2>&1
)
findstr /c:"Enable classic volume control" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Enabling classic volume control
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" /v "EnableMtcUvc" /t REG_DWORD /d "0" /f >nul 2>&1
)
findstr /c:"Enable classic alt tab" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Enabling classic alt tab
    reg add "HKU\!USER_SID!\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "AltTabSettings" /t REG_DWORD /d "1" /f >nul 2>&1
)
findstr /c:"Enable Windows 8 network flayout" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Enabling Windows 8 network flayout
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\Settings\Network" /v "ReplaceVan" /t REG_DWORD /d "2" /f >nul 2>&1
)
findstr /c:"Disable Boot graphics" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Disabling Boot graphics
    bcdedit /set quietboot On >nul 2>&1
    bcdedit /set bootuxdisabled On >nul 2>&1
    bcdedit /set {globalsettings} custom:16000067 true >nul 2>&1
    bcdedit /set {globalsettings} custom:16000068 true >nul 2>&1
    bcdedit /set {globalsettings} custom:16000069 true >nul 2>&1
)
findstr /c:"Enable F8 Boot menu" "%TMP%\interface.txt" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    call:ECHOX Enabling F8 Boot menu
    bcdedit /set bootmenupolicy Legacy >nul 2>&1
)
del /f /q "%TMP%\interface.txt" >nul 2>&1

call:MSGBOX "Replace Task Manager with Process Explorer ?" vbYesNo+vbQuestion "Task Manager"
if !ERRORLEVEL! equ 6 (
    call:ECHOX Installing Process Explorer
    taskkill /f /im "procexp.exe" >nul 2>&1
    if not exist "%WinDir%\procexp.exe" copy "resources\procexp.exe" "%WinDir%" >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\pcw" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskmgr.exe" /v "Debugger" /t REG_SZ /d "%WinDir%\procexp.exe" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "EulaAccepted" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "Windowplacement" /t REG_BINARY /d "2c00000000000000010000000083ffff0083fffffffffffffffffffff801000041000000b5050000c1030000" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "FindWindowplacement" /t REG_BINARY /d "2c00000000000000000000000000000000000000000000000000000096000000960000000000000000000000" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "SysinfoWindowplacement" /t REG_BINARY /d "2c00000000000000010000000000000000000000ffffffffffffffff28000000280000002b0300002b020000" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "PropWindowplacement" /t REG_BINARY /d "2c00000000000000010000000000000000000000ffffffffffffffff2800000028000000e70100009b020000" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "DllPropWindowplacement" /t REG_BINARY /d "2c00000000000000000000000000000000000000000000000000000028000000280000000000000000000000" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "UnicodeFont" /t REG_BINARY /d "080000000000000000000000000000009001000000000000000000004d00530020005300680065006c006c00200044006c00670000000000000000000000000000000000000000000000000000000000000000000000000000000000" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "Divider" /t REG_BINARY /d "000000000000f03f" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "SavedDivider" /t REG_BINARY /d "531f0e151662ea3f" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ProcessImageColumnWidth" /t REG_DWORD /d "261" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ShowUnnamedHandles" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ShowDllView" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "HandleSortColumn" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "HandleSortDirection" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "DllSortColumn" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "DllSortDirection" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ProcessSortColumn" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ProcessSortDirection" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightServices" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightOwnProcesses" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightRelocatedDlls" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightJobs" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightNewProc" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightDelProc" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightImmersive" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightProtected" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightPacked" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightNetProcess" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightSuspend" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightDuration" /t REG_DWORD /d "1000" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ShowCpuFractions" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ShowLowerpane" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ShowAllUsers" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ShowProcessTree" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "SymbolWarningShown" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "HideWhenMinimized" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "AlwaysOntop" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "OneInstance" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "NumColumnSets" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ConfirmKill" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "RefreshRate" /t REG_DWORD /d "1000" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "PrcessColumnCount" /t REG_DWORD /d "12" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "DllColumnCount" /t REG_DWORD /d "5" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "HandleColumnCount" /t REG_DWORD /d "2" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "DefaultProcPropPage" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "DefaultSysInfoPage" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "DefaultDllPropPage" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "SymbolPath" /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ColorPacked" /t REG_DWORD /d "16711808" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ColorImmersive" /t REG_DWORD /d "15395328" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ColorOwn" /t REG_DWORD /d "16765136" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ColorServices" /t REG_DWORD /d "13684991" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ColorRelocatedDlls" /t REG_DWORD /d "10551295" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ColorGraphBk" /t REG_DWORD /d "15790320" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ColorJobs" /t REG_DWORD /d "27856" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ColorDelProc" /t REG_DWORD /d "4605695" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ColorNewProc" /t REG_DWORD /d "4652870" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ColorNet" /t REG_DWORD /d "10551295" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ColorProtected" /t REG_DWORD /d "8388863" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ShowHeatmaps" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ColorSuspend" /t REG_DWORD /d "8421504" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "StatusBarColumns" /t REG_DWORD /d "13589" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ShowAllCpus" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ShowAllGpus" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "Opacity" /t REG_DWORD /d "100" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "GpuNodeUsageMask" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "GpuNodeUsageMask1" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "VerifySignatures" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "VirusTotalCheck" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "VirusTotalSubmitUnknown" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ToolbarBands" /t REG_BINARY /d "0601000000000000000000004b00000001000000000000004b00000002000000000000004b00000003000000000000004b0000000400000000000000400000000500000000000000500000000600000000000000930400000700000000000000" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "UseGoogle" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ShowNewProcesses" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "TrayCPUHistory" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ShowIoTray" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ShowNetTray" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ShowDiskTray" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ShowPhysTray" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ShowCommitTray" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ShowGpuTray" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "FormatIoBytes" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "StackWindowPlacement" /t REG_BINARY /d "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer" /v "ETWstandardUserWarning" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\DllColumnMap" /v "0" /t REG_DWORD /d "26" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\DllColumnMap" /v "1" /t REG_DWORD /d "42" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\DllColumnMap" /v "2" /t REG_DWORD /d "1033" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\DllColumnMap" /v "3" /t REG_DWORD /d "1111" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\DllColumnMap" /v "4" /t REG_DWORD /d "1670" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\DllColumns" /v "0" /t REG_DWORD /d "110" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\DllColumns" /v "1" /t REG_DWORD /d "180" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\DllColumns" /v "2" /t REG_DWORD /d "140" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\DllColumns" /v "3" /t REG_DWORD /d "300" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\DllColumns" /v "4" /t REG_DWORD /d "100" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\HandleColumnMap" /v "0" /t REG_DWORD /d "21" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\HandleColumnMap" /v "1" /t REG_DWORD /d "22" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\HandleColumns" /v "0" /t REG_DWORD /d "100" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\HandleColumns" /v "1" /t REG_DWORD /d "450" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "0" /t REG_DWORD /d "3" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "1" /t REG_DWORD /d "1055" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "2" /t REG_DWORD /d "1650" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "3" /t REG_DWORD /d "1060" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "4" /t REG_DWORD /d "1063" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "5" /t REG_DWORD /d "1069" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "6" /t REG_DWORD /d "1071" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "7" /t REG_DWORD /d "1065" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "8" /t REG_DWORD /d "5" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "9" /t REG_DWORD /d "1340" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "10" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "11" /t REG_DWORD /d "1670" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "12" /t REG_DWORD /d "1670" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "13" /t REG_DWORD /d "1670" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "14" /t REG_DWORD /d "1670" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "15" /t REG_DWORD /d "1670" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "16" /t REG_DWORD /d "1670" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "17" /t REG_DWORD /d "1653" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "18" /t REG_DWORD /d "1653" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "19" /t REG_DWORD /d "1653" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "0" /t REG_DWORD /d "261" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "1" /t REG_DWORD /d "35" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "2" /t REG_DWORD /d "37" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "3" /t REG_DWORD /d "70" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "4" /t REG_DWORD /d "70" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "5" /t REG_DWORD /d "100" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "6" /t REG_DWORD /d "100" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "7" /t REG_DWORD /d "52" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "8" /t REG_DWORD /d "43" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "9" /t REG_DWORD /d "63" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "10" /t REG_DWORD /d "31" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "11" /t REG_DWORD /d "60" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "12" /t REG_DWORD /d "31" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "13" /t REG_DWORD /d "60" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "14" /t REG_DWORD /d "70" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "15" /t REG_DWORD /d "70" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "16" /t REG_DWORD /d "44" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\Sysinternals\Process Explorer\VirusTotal" /v "VirusTotalTermsAccepted" /t REG_DWORD /d "1" /f >nul 2>&1
)

call:MSGBOX "Replace Start Menu with OpenShell ?" vbYesNo+vbQuestion "Start Menu"
if !ERRORLEVEL! equ 6 (
    call:ECHOX Installing Openshell
    call:CHOCO open-shell
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell" /t REG_SZ "" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\OpenShell" /t REG_SZ "" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\OpenShell\Settings" /t REG_SZ "" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\ClassicExplorer" /t REG_SZ "" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\ClassicExplorer" /v "ShowedToolbar" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\ClassicExplorer" /v "NewLine" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\ClassicExplorer\Settings" /t REG_SZ "" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\ClassicExplorer\Settings" /v "ShowStatusBar" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\StartMenu" /t REG_SZ "" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\StartMenu" /v "ShowedStyle2" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\StartMenu" /v "CSettingsDlg" /t REG_BINARY /d "c80100001a0100000000000000000000360d00000100000000000000" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\StartMenu" /v "OldItems" /t REG_BINARY "" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\StartMenu" /v "ItemRanks" /t REG_BINARY /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\StartMenu\Settings" /t REG_SZ "" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\StartMenu\Settings" /v "Version" /t REG_DWORD /d "04040098" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\StartMenu\Settings" /v "AllProgramsMetro" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\StartMenu\Settings" /v "RecentMetroApps" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\StartMenu\Settings" /v "StartScreenShortcut" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\StartMenu\Settings" /v "SearchInternet" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\StartMenu\Settings" /v "GlassOverride" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\StartMenu\Settings" /v "GlassColor" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\StartMenu\Settings" /v "SkinW7" /t REG_SZ /d "Midnight" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\StartMenu\Settings" /v "SkinVariationW7" /t REG_SZ "" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\StartMenu\Settings" /v "SkinOptionsW7" /t REG_MULTI_SZ /d "USER_IMAGE=1"\0"SMALL_ICONS=0"\0"LARGE_FONT=0"\0"DISABLE_MASK=0"\0"OPAQUE=0"\0"TRANSPARENT_LESS=0"\0"TRANSPARENT_MORE=1"\0"WHITE_SUBMENUS2=0" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\StartMenu\Settings" /v "SkipMetro" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKU\!USER_SID!\SOFTWARE\OpenShell\StartMenu\Settings" /v "MenuItems7" /t REG_MULTI_SZ /d "Item1.Command=user_files"\0"Item1.Settings=NOEXPAND"\0"Item2.Command=user_documents"\0"Item2.Settings=NOEXPAND"\0"Item3.Command=user_pictures"\0"Item3.Settings=NOEXPAND"\0"Item4.Command=user_music"\0"Item4.Settings=NOEXPAND"\0"Item5.Command=user_videos"\0"Item5.Settings=NOEXPAND"\0"Item6.Command=downloads"\0"Item6.Settings=NOEXPAND"\0"Item7.Command=homegroup"\0"Item7.Settings=ITEM_DISABLED"\0"Item8.Command=separator"\0"Item9.Command=games"\0"Item9.Settings=TRACK_RECENT|NOEXPAND|ITEM_DISABLED"\0"Item10.Command=favorites"\0"Item10.Settings=ITEM_DISABLED"\0"Item11.Command=recent_documents"\0"Item12.Command=computer"\0"Item12.Settings=NOEXPAND"\0"Item13.Command=network"\0"Item13.Settings=ITEM_DISABLED"\0"Item14.Command=network_connections"\0"Item14.Settings=ITEM_DISABLED"\0"Item15.Command=separator"\0"Item16.Command=control_panel"\0"Item16.Settings=TRACK_RECENT"\0"Item17.Command=pc_settings"\0"Item17.Settings=TRACK_RECENT"\0"Item18.Command=admin"\0"Item18.Settings=TRACK_RECENT|ITEM_DISABLED"\0"Item19.Command=devices"\0"Item19.Settings=ITEM_DISABLED"\0"Item20.Command=defaults"\0"Item20.Settings=ITEM_DISABLED"\0"Item21.Command=help"\0"Item21.Settings=ITEM_DISABLED"\0"Item22.Command=run"\0"Item23.Command=apps"\0"Item23.Settings=ITEM_DISABLED"\0"Item24.Command=windows_security"\0"Item24.Settings=ITEM_DISABLED" /f >nul 2>&1
)

taskkill /f /im "explorer.exe" >nul 2>&1
timeout /t 5 /nobreak >nul 2>&1
start "" "explorer.exe" >nul 2>&1

call:ECHOX System tweaks complete

call:MSGBOX "Some registry changes may require a reboot to take effect.\n\nWould you like to restart now ?" vbYesNo+vbExclamation "Shutdown Windows"
if !ERRORLEVEL! equ 6 shutdown -r -f -t 0
timeout /t 1 /nobreak >nul 2>&1
goto MAIN_MENU

:APPS_MENU_CLEAR
set APPS_MENU="Google Chrome" "Mozilla Firefox" "Brave" "Opera GX" "Microsoft Edge" "Vivaldi" "Deezer" "Spotify" "iTunes" "PotPlayer" "VLC media player" "Audacity" "OBS Studio" "ImageGlass" "ShareX" "GIMP" "Discord" "TeamSpeak" "Teams" "Zoom" "Slack" "Adobe Acrobat Reader" "Foxit Reader" "Microsoft Office" "Libre Office" "7zip" "Winrar" "Visual Studio Code" "Notepad++" "Github" "Git" "FileZilla" "WinSCP" "PuTTY" "Python 3" "Java Runtime Environment 8" "Node.JS" "Steam" "GOG Galaxy" "Epic Games" "Uplay" "Battle.net" "Origin" "VirtualBox" "VMware Workstation Pro" "VMware Workstation Player" "TeamViewer" "AnyDesk" "qBittorrent" "Bulk Crap Uninstaller" "Everything" "MSI Afterburner" "Visual C++ Redistributables" "DirectX" ".NET Framework 4.8"
for %%i in (!APPS_MENU!) do set "%%~i=!S_MAGENTA![ ]!S_WHITE! %%~i"

:APPS_MENU
cls
mode con lines=47 cols=143
echo !S_MAGENTA!
echo                             ╔═════════════════════════════════════════════════════════════════════════════════════╗
echo                             ║                                  !S_GREEN!SOFTWARE INSTALLER!S_MAGENTA!                                 ║
echo                             ╚═════════════════════════════════════════════════════════════════════════════════════╝
echo.
echo              !S_YELLOW!WEB BROWSERS                                 MEDIA                                        IMAGING
echo              ------------                                 -----                                        -------
echo               !S_GREEN!1 !Google Chrome!                          !S_GREEN!7 !Deezer!                                !S_GREEN!14 !ImageGlass!
echo               !S_GREEN!2 !Mozilla Firefox!                        !S_GREEN!8 !Spotify!                               !S_GREEN!15 !ShareX!
echo               !S_GREEN!3 !Brave!                                  !S_GREEN!9 !iTunes!                                !S_GREEN!16 !GIMP!
echo               !S_GREEN!4 !Opera GX!                              !S_GREEN!10 !PotPlayer!
echo               !S_GREEN!5 !Microsoft Edge!                        !S_GREEN!11 !VLC media player!
echo               !S_GREEN!6 !Vivaldi!                               !S_GREEN!12 !Audacity!
echo                                                           !S_GREEN!13 !OBS Studio!
echo.
echo              !S_YELLOW!MESSAGING                                    DOCUMENTS                                    COMPRESSION
echo              ---------                                    ---------                                    -----------
echo              !S_GREEN!17 !Discord!                               !S_GREEN!22 !Adobe Acrobat Reader!                  !S_GREEN!26 !7zip!
echo              !S_GREEN!18 !TeamSpeak!                             !S_GREEN!23 !Foxit Reader!                          !S_GREEN!27 !Winrar!
echo              !S_GREEN!19 !Teams!                                 !S_GREEN!24 !Microsoft Office!
echo              !S_GREEN!20 !Zoom!                                  !S_GREEN!25 !Libre Office!
echo              !S_GREEN!21 !Slack!
echo.
echo              !S_YELLOW!DEVELOPER TOOLS                              GAMES LAUNCHER                               OTHERS
echo              ---------------                              --------------                               ------
echo              !S_GREEN!28 !Visual Studio Code!                    !S_GREEN!38 !Steam!                                 !S_GREEN!44 !VirtualBox!
echo              !S_GREEN!29 !Notepad++!                             !S_GREEN!39 !GOG Galaxy!                            !S_GREEN!45 !VMware Workstation Pro!
echo              !S_GREEN!30 !Github!                                !S_GREEN!40 !Epic Games!                            !S_GREEN!46 !VMware Workstation Player!
echo              !S_GREEN!31 !Git!                                   !S_GREEN!41 !Uplay!                                 !S_GREEN!47 !TeamViewer!
echo              !S_GREEN!32 !FileZilla!                             !S_GREEN!42 !Battle.net!                            !S_GREEN!48 !AnyDesk!
echo              !S_GREEN!33 !WinSCP!                                !S_GREEN!43 !Origin!                                !S_GREEN!49 !qBittorrent!
echo              !S_GREEN!34 !PuTTY!                                                                              !S_GREEN!50 !Bulk Crap Uninstaller!
echo              !S_GREEN!35 !Python 3!                                                                           !S_GREEN!51 !Everything!
echo              !S_GREEN!36 !Java Runtime Environment 8!                                                         !S_GREEN!52 !MSI Afterburner!
echo              !S_GREEN!37 !Node.JS!
echo.
echo              !S_RED!Recommended to install
echo              ----------------------
echo              !S_GREEN!53 !Visual C++ Redistributables!
echo              !S_GREEN!54 !DirectX!
echo              !S_GREEN!55 !.NET Framework 4.8!
echo.
echo                                                  !S_GRAY!Make your choices OR "!S_GREEN!BACK!S_GRAY!" AND press !S_GREEN!{ENTER}!S_GRAY!
echo.
set choice=
set /p "choice=!S_GREEN!                                                                       "
REM WEB BROWSERS
if "!choice!"=="1" if "!Google Chrome!"=="!S_MAGENTA![ ]!S_WHITE! Google Chrome" (set "Google Chrome=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Google Chrome") else set "Google Chrome=!S_MAGENTA![ ]!S_WHITE! Google Chrome"
if "!choice!"=="2" if "!Mozilla Firefox!"=="!S_MAGENTA![ ]!S_WHITE! Mozilla Firefox" (set "Mozilla Firefox=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Mozilla Firefox") else set "Mozilla Firefox=!S_MAGENTA![ ]!S_WHITE! Mozilla Firefox"
if "!choice!"=="3" if "!Brave!"=="!S_MAGENTA![ ]!S_WHITE! Brave" (set "Brave=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Brave") else set "Brave=!S_MAGENTA![ ]!S_WHITE! Brave"
if "!choice!"=="4" if "!Opera GX!"=="!S_MAGENTA![ ]!S_WHITE! Opera GX" (set "Opera GX=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Opera GX") else set "Opera GX=!S_MAGENTA![ ]!S_WHITE! Opera GX"
if "!choice!"=="5" if "!Microsoft Edge!"=="!S_MAGENTA![ ]!S_WHITE! Microsoft Edge" (set "Microsoft Edge=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Microsoft Edge") else set "Microsoft Edge=!S_MAGENTA![ ]!S_WHITE! Microsoft Edge"
if "!choice!"=="6" if "!Vivaldi!"=="!S_MAGENTA![ ]!S_WHITE! Vivaldi" (set "Vivaldi=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Vivaldi") else set "Vivaldi=!S_MAGENTA![ ]!S_WHITE! Vivaldi"
REM MEDIA
if "!choice!"=="7" if "!Deezer!"=="!S_MAGENTA![ ]!S_WHITE! Deezer" (set "Deezer=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Deezer") else set "Deezer=!S_MAGENTA![ ]!S_WHITE! Deezer"
if "!choice!"=="8" if "!Spotify!"=="!S_MAGENTA![ ]!S_WHITE! Spotify" (set "Spotify=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Spotify") else set "Spotify=!S_MAGENTA![ ]!S_WHITE! Spotify"
if "!choice!"=="9" if "!iTunes!"=="!S_MAGENTA![ ]!S_WHITE! iTunes" (set "iTunes=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! iTunes") else set "iTunes=!S_MAGENTA![ ]!S_WHITE! iTunes"
if "!choice!"=="10" if "!PotPlayer!"=="!S_MAGENTA![ ]!S_WHITE! PotPlayer" (set "PotPlayer=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! PotPlayer") else set "PotPlayer=!S_MAGENTA![ ]!S_WHITE! PotPlayer"
if "!choice!"=="11" if "!VLC media player!"=="!S_MAGENTA![ ]!S_WHITE! VLC media player" (set "VLC media player=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! VLC media player") else set "VLC media player=!S_MAGENTA![ ]!S_WHITE! VLC media player"
if "!choice!"=="12" if "!Audacity!"=="!S_MAGENTA![ ]!S_WHITE! Audacity" (set "Audacity=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Audacity") else set "Audacity=!S_MAGENTA![ ]!S_WHITE! Audacity"
if "!choice!"=="13" if "!OBS Studio!"=="!S_MAGENTA![ ]!S_WHITE! OBS Studio" (set "OBS Studio=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! OBS Studio") else set "OBS Studio=!S_MAGENTA![ ]!S_WHITE! OBS Studio"
REM IMAGING
if "!choice!"=="14" if "!ImageGlass!"=="!S_MAGENTA![ ]!S_WHITE! ImageGlass" (set "ImageGlass=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! ImageGlass") else set "ImageGlass=!S_MAGENTA![ ]!S_WHITE! ImageGlass"
if "!choice!"=="15" if "!ShareX!"=="!S_MAGENTA![ ]!S_WHITE! ShareX" (set "ShareX=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! ShareX") else set "ShareX=!S_MAGENTA![ ]!S_WHITE! ShareX"
if "!choice!"=="16" if "!GIMP!"=="!S_MAGENTA![ ]!S_WHITE! GIMP" (set "GIMP=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! GIMP") else set "GIMP=!S_MAGENTA![ ]!S_WHITE! GIMP"
REM MESSAGING
if "!choice!"=="17" if "!Discord!"=="!S_MAGENTA![ ]!S_WHITE! Discord" (set "Discord=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Discord") else set "Discord=!S_MAGENTA![ ]!S_WHITE! Discord"
if "!choice!"=="18" if "!TeamSpeak!"=="!S_MAGENTA![ ]!S_WHITE! TeamSpeak" (set "TeamSpeak=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! TeamSpeak") else set "TeamSpeak=!S_MAGENTA![ ]!S_WHITE! TeamSpeak"
if "!choice!"=="19" if "!Teams!"=="!S_MAGENTA![ ]!S_WHITE! Teams" (set "Teams=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Teams") else set "Teams=!S_MAGENTA![ ]!S_WHITE! Teams"
if "!choice!"=="20" if "!Zoom!"=="!S_MAGENTA![ ]!S_WHITE! Zoom" (set "Zoom=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Zoom") else set "Zoom=!S_MAGENTA![ ]!S_WHITE! Zoom"
if "!choice!"=="21" if "!Slack!"=="!S_MAGENTA![ ]!S_WHITE! Slack" (set "Slack=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Slack") else set "Slack=!S_MAGENTA![ ]!S_WHITE! Slack"
REM DOCUMENTS
if "!choice!"=="22" if "!Adobe Acrobat Reader!"=="!S_MAGENTA![ ]!S_WHITE! Adobe Acrobat Reader" (set "Adobe Acrobat Reader=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Adobe Acrobat Reader") else set "Adobe Acrobat Reader=!S_MAGENTA![ ]!S_WHITE! Adobe Acrobat Reader"
if "!choice!"=="23" if "!Foxit Reader!"=="!S_MAGENTA![ ]!S_WHITE! Foxit Reader" (set "Foxit Reader=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Foxit Reader") else set "Foxit Reader=!S_MAGENTA![ ]!S_WHITE! Foxit Reader"
if "!choice!"=="24" if "!Microsoft Office!"=="!S_MAGENTA![ ]!S_WHITE! Microsoft Office" (set "Microsoft Office=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Microsoft Office") else set "Microsoft Office=!S_MAGENTA![ ]!S_WHITE! Microsoft Office"
if "!choice!"=="25" if "!Libre Office!"=="!S_MAGENTA![ ]!S_WHITE! Libre Office" (set "Libre Office=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Libre Office") else set "Libre Office=!S_MAGENTA![ ]!S_WHITE! Libre Office"
REM COMPRESSION
if "!choice!"=="26" if "!7zip!"=="!S_MAGENTA![ ]!S_WHITE! 7zip" (set "7zip=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! 7zip") else set "7zip=!S_MAGENTA![ ]!S_WHITE! 7zip"
if "!choice!"=="27" if "!Winrar!"=="!S_MAGENTA![ ]!S_WHITE! Winrar" (set "Winrar=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Winrar") else set "Winrar=!S_MAGENTA![ ]!S_WHITE! Winrar"
REM DEVELOPER TOOLS
if "!choice!"=="28" if "!Visual Studio Code!"=="!S_MAGENTA![ ]!S_WHITE! Visual Studio Code" (set "Visual Studio Code=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Visual Studio Code") else set "Visual Studio Code=!S_MAGENTA![ ]!S_WHITE! Visual Studio Code"
if "!choice!"=="29" if "!Notepad++!"=="!S_MAGENTA![ ]!S_WHITE! Notepad++" (set "Notepad++=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Notepad++") else set "Notepad++=!S_MAGENTA![ ]!S_WHITE! Notepad++"
if "!choice!"=="30" if "!Github!"=="!S_MAGENTA![ ]!S_WHITE! Github" (set "Github=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Github") else set "Github=!S_MAGENTA![ ]!S_WHITE! Github"
if "!choice!"=="31" if "!Git!"=="!S_MAGENTA![ ]!S_WHITE! Git" (set "Git=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Git") else set "Git=!S_MAGENTA![ ]!S_WHITE! Git"
if "!choice!"=="32" if "!FileZilla!"=="!S_MAGENTA![ ]!S_WHITE! FileZilla" (set "FileZilla=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! FileZilla") else set "FileZilla=!S_MAGENTA![ ]!S_WHITE! FileZilla"
if "!choice!"=="33" if "!WinSCP!"=="!S_MAGENTA![ ]!S_WHITE! WinSCP" (set "WinSCP=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! WinSCP") else set "WinSCP=!S_MAGENTA![ ]!S_WHITE! WinSCP"
if "!choice!"=="34" if "!PuTTY!"=="!S_MAGENTA![ ]!S_WHITE! PuTTY" (set "PuTTY=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! PuTTY") else set "PuTTY=!S_MAGENTA![ ]!S_WHITE! PuTTY"
if "!choice!"=="35" if "!Python 3!"=="!S_MAGENTA![ ]!S_WHITE! Python 3" (set "Python 3=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Python 3") else set "Python 3=!S_MAGENTA![ ]!S_WHITE! Python 3"
if "!choice!"=="36" if "!Java Runtime Environment 8!"=="!S_MAGENTA![ ]!S_WHITE! Java Runtime Environment 8" (set "Java Runtime Environment 8=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Java Runtime Environment 8") else set "Java Runtime Environment 8=!S_MAGENTA![ ]!S_WHITE! Java Runtime Environment 8"
if "!choice!"=="37" if "!Node.JS!"=="!S_MAGENTA![ ]!S_WHITE! Node.JS" (set "Node.JS=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Node.JS") else set "Node.JS=!S_MAGENTA![ ]!S_WHITE! Node.JS"
REM GAMES LAUNCHE
if "!choice!"=="38" if "!Steam!"=="!S_MAGENTA![ ]!S_WHITE! Steam" (set "Steam=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Steam") else set "Steam=!S_MAGENTA![ ]!S_WHITE! Steam"
if "!choice!"=="39" if "!GOG Galaxy!"=="!S_MAGENTA![ ]!S_WHITE! GOG Galaxy" (set "GOG Galaxy=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! GOG Galaxy") else set "GOG Galaxy=!S_MAGENTA![ ]!S_WHITE! GOG Galaxy"
if "!choice!"=="40" if "!Epic Games!"=="!S_MAGENTA![ ]!S_WHITE! Epic Games" (set "Epic Games=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Epic Games") else set "Epic Games=!S_MAGENTA![ ]!S_WHITE! Epic Games"
if "!choice!"=="41" if "!Uplay!"=="!S_MAGENTA![ ]!S_WHITE! Uplay" (set "Uplay=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Uplay") else set "Uplay=!S_MAGENTA![ ]!S_WHITE! Uplay"
if "!choice!"=="42" if "!Battle.net!"=="!S_MAGENTA![ ]!S_WHITE! Battle.net" (set "Battle.net=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Battle.net") else set "Battle.net=!S_MAGENTA![ ]!S_WHITE! Battle.net"
if "!choice!"=="43" if "!Origin!"=="!S_MAGENTA![ ]!S_WHITE! Origin" (set "Origin=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Origin") else set "Origin=!S_MAGENTA![ ]!S_WHITE! Origin"
REM OTHERS
if "!choice!"=="44" if "!VirtualBox!"=="!S_MAGENTA![ ]!S_WHITE! VirtualBox" (set "VirtualBox=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! VirtualBox") else set "VirtualBox=!S_MAGENTA![ ]!S_WHITE! VirtualBox"
if "!choice!"=="45" if "!VMware Workstation Pro!"=="!S_MAGENTA![ ]!S_WHITE! VMware Workstation Pro" (set "VMware Workstation Pro=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! VMware Workstation Pro") else set "VMware Workstation Pro=!S_MAGENTA![ ]!S_WHITE! VMware Workstation Pro"
if "!choice!"=="46" if "!VMware Workstation Player!"=="!S_MAGENTA![ ]!S_WHITE! VMware Workstation Player" (set "VMware Workstation Player=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! VMware Workstation Player") else set "VMware Workstation Player=!S_MAGENTA![ ]!S_WHITE! VMware Workstation Player"
if "!choice!"=="47" if "!TeamViewer!"=="!S_MAGENTA![ ]!S_WHITE! TeamViewer" (set "TeamViewer=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! TeamViewer") else set "TeamViewer=!S_MAGENTA![ ]!S_WHITE! TeamViewer"
if "!choice!"=="48" if "!AnyDesk!"=="!S_MAGENTA![ ]!S_WHITE! AnyDesk" (set "AnyDesk=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! AnyDesk") else set "AnyDesk=!S_MAGENTA![ ]!S_WHITE! AnyDesk"
if "!choice!"=="49" if "!qBittorrent!"=="!S_MAGENTA![ ]!S_WHITE! qBittorrent" (set "qBittorrent=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! qBittorrent") else set "qBittorrent=!S_MAGENTA![ ]!S_WHITE! qBittorrent"
if "!choice!"=="50" if "!Bulk Crap Uninstaller!"=="!S_MAGENTA![ ]!S_WHITE! Bulk Crap Uninstaller" (set "Bulk Crap Uninstaller=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Bulk Crap Uninstaller") else set "Bulk Crap Uninstaller=!S_MAGENTA![ ]!S_WHITE! Bulk Crap Uninstaller"
if "!choice!"=="51" if "!Everything!"=="!S_MAGENTA![ ]!S_WHITE! Everything" (set "Everything=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Everything") else set "Everything=!S_MAGENTA![ ]!S_WHITE! Everything"
if "!choice!"=="52" if "!MSI Afterburner!"=="!S_MAGENTA![ ]!S_WHITE! MSI Afterburner" (set "MSI Afterburner=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! MSI Afterburner") else set "MSI Afterburner=!S_MAGENTA![ ]!S_WHITE! MSI Afterburner"
REM Recommended to install
if "!choice!"=="53" if "!Visual C++ Redistributables!"=="!S_MAGENTA![ ]!S_WHITE! Visual C++ Redistributables" (set "Visual C++ Redistributables=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Visual C++ Redistributables") else set "Visual C++ Redistributables=!S_MAGENTA![ ]!S_WHITE! Visual C++ Redistributables"
if "!choice!"=="54" if "!DirectX!"=="!S_MAGENTA![ ]!S_WHITE! DirectX" (set "DirectX=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! DirectX") else set "DirectX=!S_MAGENTA![ ]!S_WHITE! DirectX"
if "!choice!"=="55" if "!.NET Framework 4.8!"=="!S_MAGENTA![ ]!S_WHITE! .NET Framework 4.8" (set ".NET Framework 4.8=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! .NET Framework 4.8") else set ".NET Framework 4.8=!S_MAGENTA![ ]!S_WHITE! .NET Framework 4.8"
for /l %%i in (1,1,55) do if "!choice!"=="%%i" goto APPS_MENU
if "!choice!"=="" (
    for %%i in (!APPS_MENU!) do if "!%%~i!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! %%~i" goto APPS_INSTALL
    echo                                                      !RED!ERROR: !S_GREEN!"!choice!"!S_GRAY! is not a valid choice...
    timeout /t 3 /nobreak >nul 2>&1
    goto APPS_MENU
)
if /i "!choice!"=="b" goto MAIN_MENU
if /i "!choice!"=="back" goto MAIN_MENU
echo                                                      !RED!ERROR: !S_GREEN!"!choice!"!S_GRAY! is not a valid choice...
timeout /t 3 /nobreak >nul 2>&1
goto APPS_MENU

:APPS_INSTALL
REM WEB BROWSERS
if "!Google Chrome!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Google Chrome" call:CHOCO googlechrome
if "!Mozilla Firefox!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Mozilla Firefox" call:CHOCO firefox
if "!Brave!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Brave" call:CHOCO brave
if "!Opera GX!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Opera GX" call:CHOCO opera-gx
if "!Microsoft Edge!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Microsoft Edge" call:CHOCO microsoft-edge
if "!Vivaldi!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Vivaldi" call:CHOCO vivaldi
REM MEDIA
if "!Deezer!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Deezer" call:CHOCO deezer
if "!Spotify!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Spotify" call:CHOCO spotify
if "!iTunes!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! iTunes" call:CHOCO itunes
if "!PotPlayer!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! PotPlayer" call:CHOCO potplayer
if "!VLC media player!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! VLC media player" call:CHOCO vlc
if "!Audacity!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Audacity" call:CHOCO audacity
if "!OBS Studio!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! OBS Studio" call:CHOCO obs-studio
REM IMAGING
if "!ImageGlass!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! ImageGlass" call:CHOCO imageglass
if "!ShareX!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! ShareX" call:CHOCO sharex
if "!GIMP!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! GIMP" call:CHOCO gimp
REM MESSAGING
if "!Discord!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Discord" call:CHOCO discord
if "!TeamSpeak!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! TeamSpeak" call:CHOCO teamspeak
if "!Teams!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Teams" call:CHOCO microsoft-teams
if "!Zoom!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Zoom" call:CHOCO zoom
if "!Slack!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Slack" call:CHOCO slack
REM DOCUMENTS
if "!Adobe Acrobat Reader!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Adobe Acrobat Reader" call:CHOCO adobereader
if "!Foxit Reader!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Foxit Reader" call:CHOCO foxitreader
if "!Microsoft Office!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Microsoft Office" call:CHOCO office-tool & call:SHORTCUT "Office Tool Plus" "%UserProfile%\desktop" "%LocalAppData%\office-tool\Office Tool\Office Tool Plus.exe" "%LocalAppData%\office-tool\Office Tool"
if "!Libre Office!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Libre Office" call:CHOCO libreoffice-fresh
REM COMPRESSION
if "!7zip!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! 7zip" call:CHOCO 7zip.install
if "!Winrar!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Winrar" call:CHOCO winrar
REM DEVELOPER TOOLS
if "!Visual Studio Code!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Visual Studio Code" call:CHOCO vscode
if "!Notepad++!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Notepad++" call:CHOCO notepadplusplus
if "!Github!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Github" call:CHOCO github-desktop
if "!Git!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Git" call:CHOCO git
if "!FileZilla!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! FileZilla" call:CHOCO filezilla
if "!WinSCP!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! WinSCP" call:CHOCO winscp
if "!PuTTY!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! PuTTY" call:CHOCO putty & call:SHORTCUT "PuTTY" "%UserProfile%\desktop" "%ProgramData%\chocolatey\bin\PUTTY.exe" "\ProgramData\chocolatey\bin"
if "!Python 3!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Python 3" call:CHOCO python
if "!Java Runtime Environment 8!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Java Runtime Environment 8" call:CHOCO jre8
if "!Node.JS!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Node.JS" call:CHOCO nodejs
REM GAMES LAUNCHER
if "!Steam!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Steam" call:CHOCO steam
if "!GOG Galaxy!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! GOG Galaxy" call:CHOCO goggalaxy
if "!Epic Games!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Epic Games" call:CHOCO epicgameslauncher
if "!Uplay!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Uplay" call:CHOCO uplay
if "!Battle.net!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Battle.net" call:CHOCO battle.net
if "!Origin!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Origin" call:CHOCO origin & call:SHORTCUT "Origin" "%UserProfile%\desktop" "\Program Files (x86)\Origin\Origin.exe" "\Program Files (x86)\Origin"
REM OTHERS
if "!VirtualBox!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! VirtualBox" call:CHOCO virtualbox
if "!VMware Workstation Pro!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! VMware Workstation Pro" call:CHOCO vmwareworkstation
if "!VMware Workstation Player!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! VMware Workstation Player" call:CHOCO vmware-workstation-player
if "!TeamViewer!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! TeamViewer" call:CHOCO teamviewer
if "!AnyDesk!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! AnyDesk" call:CHOCO anydesk
if "!qBittorrent!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! qBittorrent" call:CHOCO qbittorrent & call:SHORTCUT "qBittorrent" "%UserProfile%\desktop" "\Program Files\qBittorrent\qbittorrent.exe" "\Program Files\qBittorrent"
if "!Bulk Crap Uninstaller!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Bulk Crap Uninstaller" call:CHOCO bulk-crap-uninstaller
if "!Everything!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Everything" call:CHOCO everything
if "!MSI Afterburner!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! MSI Afterburner" call:CHOCO msiafterburner
REM Recommended to install
if "!Visual C++ Redistributables!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Visual C++ Redistributables" call:CHOCO vcredist-all
if "!DirectX!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! DirectX" call:CHOCO directx
if "!.NET Framework 4.8!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! .NET Framework 4.8" call:CHOCO dotnetfx
goto APPS_MENU_CLEAR

:TOOLS_MENU_CLEAR
set TOOLS="NSudo" "Autoruns" "ServiWin" "Device Cleanup" "Cleanmgr Plus" "Ventoy" "Rufus" "Registry Finder" "CPU-Z" "GPU-Z" "HWiNFO" "CrystalDiskInfo" "Snappy Driver Installer" "NVCleanstall" "Radeon Software Slimmer" "Display Driver Uninstaller" "DriverStore Explorer" "Unigine Superposition" "CINEBENCH" "AIDA64" "OCCT" "CapFrameX" "MouseTester" "GoInterruptPolicy" "AutoGpuAffinity" "TCP Optimizer" "WLAN Optimizer" "DNS Jumper" "Nvidia Profile Inspector" "RadeonMod" "GPU Pixel Clock Patcher" "Custom Resolution Utility" "SweetLow Mouse Rate Changer" "ThrottleStop" "Power Settings Explorer"
for %%i in (!TOOLS!) do set "%%~i=!S_MAGENTA![ ]!S_WHITE! %%~i"

:TOOLS_MENU
cls
mode con lines=30 cols=150
echo !S_MAGENTA!
echo                                ╔═════════════════════════════════════════════════════════════════════════════════════╗
echo                                ║                                        !S_GREEN!TOOLS!S_MAGENTA!                                        ║
echo                                ╚═════════════════════════════════════════════════════════════════════════════════════╝
echo.
echo              !S_YELLOW!UTILITIES                                    SYSTEM INFOS                                 DRIVERS
echo              ---------                                    ------------                                 -------
echo               !S_GREEN!1 !NSudo!                                  !S_GREEN!9 !CPU-Z!                                 !S_GREEN!13 !Snappy Driver Installer!
echo               !S_GREEN!2 !Autoruns!                              !S_GREEN!10 !GPU-Z!                                 !S_GREEN!14 !NVCleanstall!
echo               !S_GREEN!3 !ServiWin!                              !S_GREEN!11 !HWiNFO!                                !S_GREEN!15 !Radeon Software Slimmer!
echo               !S_GREEN!4 !Device Cleanup!                        !S_GREEN!12 !CrystalDiskInfo!                       !S_GREEN!16 !Display Driver Uninstaller!
echo               !S_GREEN!5 !Cleanmgr Plus!                                                                      !S_GREEN!17 !DriverStore Explorer!
echo               !S_GREEN!6 !Ventoy!
echo               !S_GREEN!7 !Rufus!
echo               !S_GREEN!8 !Registry Finder!
echo.
echo              !S_YELLOW!BENCHMARK ^& STRESS                           TWEAKS
echo              ------------------                           ------
echo              !S_GREEN!18 !Unigine Superposition!                 !S_GREEN!24 !GoInterruptPolicy!                     !S_GREEN!30 !GPU Pixel Clock Patcher!
echo              !S_GREEN!19 !CINEBENCH!                             !S_GREEN!25 !AutoGpuAffinity!                       !S_GREEN!31 !Custom Resolution Utility!
echo              !S_GREEN!20 !AIDA64!                                !S_GREEN!26 !TCP Optimizer!                         !S_GREEN!32 !SweetLow Mouse Rate Changer!
echo              !S_GREEN!21 !OCCT!                                  !S_GREEN!27 !DNS Jumper!                            !S_GREEN!33 !ThrottleStop!
echo              !S_GREEN!22 !CapFrameX!                             !S_GREEN!28 !Nvidia Profile Inspector!              !S_GREEN!34 !Power Settings Explorer!
echo              !S_GREEN!23 !MouseTester!                           !S_GREEN!29 !RadeonMod!
echo.
echo                                                     !S_GRAY!Make your choices OR "!S_GREEN!BACK!S_GRAY!" AND press !S_GREEN!{ENTER}!S_GRAY!
echo.
set choice=
set /p "choice=!S_GREEN!                                                                          "
REM UTILITIES
if "!choice!"=="1" if "!NSudo!"=="!S_MAGENTA![ ]!S_WHITE! NSudo" (set "NSudo=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! NSudo") else set "NSudo=!S_MAGENTA![ ]!S_WHITE! NSudo"
if "!choice!"=="2" if "!Autoruns!"=="!S_MAGENTA![ ]!S_WHITE! Autoruns" (set "Autoruns=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Autoruns") else set "Autoruns=!S_MAGENTA![ ]!S_WHITE! Autoruns"
if "!choice!"=="3" if "!ServiWin!"=="!S_MAGENTA![ ]!S_WHITE! ServiWin" (set "ServiWin=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! ServiWin") else set "ServiWin=!S_MAGENTA![ ]!S_WHITE! ServiWin"
if "!choice!"=="4" if "!Device Cleanup!"=="!S_MAGENTA![ ]!S_WHITE! Device Cleanup" (set "Device Cleanup=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Device Cleanup") else set "Device Cleanup=!S_MAGENTA![ ]!S_WHITE! Device Cleanup"
if "!choice!"=="5" if "!Cleanmgr Plus!"=="!S_MAGENTA![ ]!S_WHITE! Cleanmgr Plus" (set "Cleanmgr Plus=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Cleanmgr Plus") else set "Cleanmgr Plus=!S_MAGENTA![ ]!S_WHITE! Cleanmgr Plus"
if "!choice!"=="6" if "!Ventoy!"=="!S_MAGENTA![ ]!S_WHITE! Ventoy" (set "Ventoy=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Ventoy") else set "Ventoy=!S_MAGENTA![ ]!S_WHITE! Ventoy"
if "!choice!"=="7" if "!Rufus!"=="!S_MAGENTA![ ]!S_WHITE! Rufus" (set "Rufus=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Rufus") else set "Rufus=!S_MAGENTA![ ]!S_WHITE! Rufus"
if "!choice!"=="8" if "!Registry Finder!"=="!S_MAGENTA![ ]!S_WHITE! Registry Finder" (set "Registry Finder=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Registry Finder") else set "Registry Finder=!S_MAGENTA![ ]!S_WHITE! Registry Finder"
REM SYSTEM INFOS
if "!choice!"=="9" if "!CPU-Z!"=="!S_MAGENTA![ ]!S_WHITE! CPU-Z" (set "CPU-Z=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! CPU-Z") else set "CPU-Z=!S_MAGENTA![ ]!S_WHITE! CPU-Z"
if "!choice!"=="10" if "!GPU-Z!"=="!S_MAGENTA![ ]!S_WHITE! GPU-Z" (set "GPU-Z=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! GPU-Z") else set "GPU-Z=!S_MAGENTA![ ]!S_WHITE! GPU-Z"
if "!choice!"=="11" if "!HWiNFO!"=="!S_MAGENTA![ ]!S_WHITE! HWiNFO" (set "HWiNFO=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! HWiNFO") else set "HWiNFO=!S_MAGENTA![ ]!S_WHITE! HWiNFO"
if "!choice!"=="12" if "!CrystalDiskInfo!"=="!S_MAGENTA![ ]!S_WHITE! CrystalDiskInfo" (set "CrystalDiskInfo=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! CrystalDiskInfo") else set "CrystalDiskInfo=!S_MAGENTA![ ]!S_WHITE! CrystalDiskInfo"
REM DRIVERS
if "!choice!"=="13" if "!Snappy Driver Installer!"=="!S_MAGENTA![ ]!S_WHITE! Snappy Driver Installer" (set "Snappy Driver Installer=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Snappy Driver Installer") else set "Snappy Driver Installer=!S_MAGENTA![ ]!S_WHITE! Snappy Driver Installer"
if "!choice!"=="14" if "!NVCleanstall!"=="!S_MAGENTA![ ]!S_WHITE! NVCleanstall" (set "NVCleanstall=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! NVCleanstall") else set "NVCleanstall=!S_MAGENTA![ ]!S_WHITE! NVCleanstall"
if "!choice!"=="15" if "!Radeon Software Slimmer!"=="!S_MAGENTA![ ]!S_WHITE! Radeon Software Slimmer" (set "Radeon Software Slimmer=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Radeon Software Slimmer") else set "Radeon Software Slimmer=!S_MAGENTA![ ]!S_WHITE! Radeon Software Slimmer"
if "!choice!"=="16" if "!Display Driver Uninstaller!"=="!S_MAGENTA![ ]!S_WHITE! Display Driver Uninstaller" (set "Display Driver Uninstaller=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Display Driver Uninstaller") else set "Display Driver Uninstaller=!S_MAGENTA![ ]!S_WHITE! Display Driver Uninstaller"
if "!choice!"=="17" if "!DriverStore Explorer!"=="!S_MAGENTA![ ]!S_WHITE! DriverStore Explorer" (set "DriverStore Explorer=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! DriverStore Explorer") else set "DriverStore Explorer=!S_MAGENTA![ ]!S_WHITE! DriverStore Explorer"
REM BENCHMARK & STRESS
if "!choice!"=="18" if "!Unigine Superposition!"=="!S_MAGENTA![ ]!S_WHITE! Unigine Superposition" (set "Unigine Superposition=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Unigine Superposition") else set "Unigine Superposition=!S_MAGENTA![ ]!S_WHITE! Unigine Superposition"
if "!choice!"=="19" if "!CINEBENCH!"=="!S_MAGENTA![ ]!S_WHITE! CINEBENCH" (set "CINEBENCH=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! CINEBENCH") else set "CINEBENCH=!S_MAGENTA![ ]!S_WHITE! CINEBENCH"
if "!choice!"=="20" if "!AIDA64!"=="!S_MAGENTA![ ]!S_WHITE! AIDA64" (set "AIDA64=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! AIDA64") else set "AIDA64=!S_MAGENTA![ ]!S_WHITE! AIDA64"
if "!choice!"=="21" if "!OCCT!"=="!S_MAGENTA![ ]!S_WHITE! OCCT" (set "OCCT=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! OCCT") else set "OCCT=!S_MAGENTA![ ]!S_WHITE! OCCT"
if "!choice!"=="22" if "!CapFrameX!"=="!S_MAGENTA![ ]!S_WHITE! CapFrameX" (set "CapFrameX=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! CapFrameX") else set "CapFrameX=!S_MAGENTA![ ]!S_WHITE! CapFrameX"
if "!choice!"=="23" if "!MouseTester!"=="!S_MAGENTA![ ]!S_WHITE! MouseTester" (set "MouseTester=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! MouseTester") else set "MouseTester=!S_MAGENTA![ ]!S_WHITE! MouseTester"
REM TWEAKS
if "!choice!"=="24" if "!GoInterruptPolicy!"=="!S_MAGENTA![ ]!S_WHITE! GoInterruptPolicy" (set "GoInterruptPolicy=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! GoInterruptPolicy") else set "GoInterruptPolicy=!S_MAGENTA![ ]!S_WHITE! GoInterruptPolicy"
if "!choice!"=="25" if "!AutoGpuAffinity!"=="!S_MAGENTA![ ]!S_WHITE! AutoGpuAffinity" (set "AutoGpuAffinity=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! AutoGpuAffinity") else set "AutoGpuAffinity=!S_MAGENTA![ ]!S_WHITE! AutoGpuAffinity"
if "!choice!"=="26" if "!TCP Optimizer!"=="!S_MAGENTA![ ]!S_WHITE! TCP Optimizer" (set "TCP Optimizer=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! TCP Optimizer") else set "TCP Optimizer=!S_MAGENTA![ ]!S_WHITE! TCP Optimizer"
if "!choice!"=="27" if "!DNS Jumper!"=="!S_MAGENTA![ ]!S_WHITE! DNS Jumper" (set "DNS Jumper=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! DNS Jumper") else set "DNS Jumper=!S_MAGENTA![ ]!S_WHITE! DNS Jumper"
if "!choice!"=="28" if "!Nvidia Profile Inspector!"=="!S_MAGENTA![ ]!S_WHITE! Nvidia Profile Inspector" (set "Nvidia Profile Inspector=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Nvidia Profile Inspector") else set "Nvidia Profile Inspector=!S_MAGENTA![ ]!S_WHITE! Nvidia Profile Inspector"
if "!choice!"=="29" if "!RadeonMod!"=="!S_MAGENTA![ ]!S_WHITE! RadeonMod" (set "RadeonMod=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! RadeonMod") else set "RadeonMod=!S_MAGENTA![ ]!S_WHITE! RadeonMod"
if "!choice!"=="30" if "!GPU Pixel Clock Patcher!"=="!S_MAGENTA![ ]!S_WHITE! GPU Pixel Clock Patcher" (set "GPU Pixel Clock Patcher=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! GPU Pixel Clock Patcher") else set "GPU Pixel Clock Patcher=!S_MAGENTA![ ]!S_WHITE! GPU Pixel Clock Patcher"
if "!choice!"=="31" if "!Custom Resolution Utility!"=="!S_MAGENTA![ ]!S_WHITE! Custom Resolution Utility" (set "Custom Resolution Utility=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Custom Resolution Utility") else set "Custom Resolution Utility=!S_MAGENTA![ ]!S_WHITE! Custom Resolution Utility"
if "!choice!"=="32" if "!SweetLow Mouse Rate Changer!"=="!S_MAGENTA![ ]!S_WHITE! SweetLow Mouse Rate Changer" (set "SweetLow Mouse Rate Changer=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! SweetLow Mouse Rate Changer") else set "SweetLow Mouse Rate Changer=!S_MAGENTA![ ]!S_WHITE! SweetLow Mouse Rate Changer"
if "!choice!"=="33" if "!ThrottleStop!"=="!S_MAGENTA![ ]!S_WHITE! ThrottleStop" (set "ThrottleStop=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! ThrottleStop") else set "ThrottleStop=!S_MAGENTA![ ]!S_WHITE! ThrottleStop"
if "!choice!"=="34" if "!Power Settings Explorer!"=="!S_MAGENTA![ ]!S_WHITE! Power Settings Explorer" (set "Power Settings Explorer=!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Power Settings Explorer") else set "Power Settings Explorer=!S_MAGENTA![ ]!S_WHITE! Power Settings Explorer"
for /l %%i in (1,1,34) do if "!choice!"=="%%i" goto TOOLS_MENU
if "!choice!"=="" (
    for %%i in (!TOOLS!) do if "!%%~i!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! %%~i" goto TOOLS_INSTALL
    echo                                                         !RED!ERROR: !S_GREEN!"!choice!"!S_GRAY! is not a valid choice...
    timeout /t 3 /nobreak >nul 2>&1
    goto TOOLS_MENU
)
if /i "!choice!"=="b" goto MAIN_MENU
if /i "!choice!"=="back" goto MAIN_MENU
echo                                                         !RED!ERROR: !S_GREEN!"!choice!"!S_GRAY! is not a valid choice...
timeout /t 3 /nobreak >nul 2>&1
goto TOOLS_MENU

:TOOLS_INSTALL
REM UTILITIES
if "!NSudo!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! NSudo" (
    set "OPENTOOLS=True"
    call:CURL "0" "https://github.com/M2Team/NSudo/releases/download/8.2/NSudo_8.2_All_Components.zip" "%UserProfile%\Documents\_Tools\Utilities\NSudo\NSudo.zip"
    call:UNZIP "%UserProfile%\Documents\_Tools\Utilities\NSudo\NSudo.zip" "%UserProfile%\Documents\_Tools\Utilities\NSudo"
    move "%UserProfile%\Documents\_Tools\Utilities\NSudo\NSudo Launcher\x64\NSudoLG.exe" "%UserProfile%\Documents\_Tools\Utilities\NSudo.exe" >nul 2>&1
    rd /s /q "%UserProfile%\Documents\_Tools\Utilities\NSudo" >nul 2>&1
)
if "!Autoruns!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Autoruns" (
    set "OPENTOOLS=True"
    call:CURL "0" "https://download.sysinternals.com/files/Autoruns.zip" "%UserProfile%\Documents\_Tools\Utilities\Autoruns\Autoruns.zip"
    call:UNZIP "%UserProfile%\Documents\_Tools\Utilities\Autoruns\Autoruns.zip" "%UserProfile%\Documents\_Tools\Utilities\Autoruns"
    move "%UserProfile%\Documents\_Tools\Utilities\Autoruns\Autoruns.exe" "%UserProfile%\Documents\_Tools\Utilities\Autoruns.exe" >nul 2>&1
    rd /s /q "%UserProfile%\Documents\_Tools\Utilities\Autoruns" >nul 2>&1
)
if "!ServiWin!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! ServiWin" (
    set "OPENTOOLS=True"
    call:CURL "0" "https://www.nirsoft.net/utils/serviwin-x64.zip" "%UserProfile%\Documents\_Tools\Utilities\ServiWin\serviwin-x64.zip"
    call:UNZIP "%UserProfile%\Documents\_Tools\Utilities\ServiWin\serviwin-x64.zip" "%UserProfile%\Documents\_Tools\Utilities\ServiWin"
    del /f /q "%UserProfile%\Documents\_Tools\Utilities\ServiWin\serviwin-x64.zip" >nul 2>&1
)
if "!Device Cleanup!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Device Cleanup" (
    set "OPENTOOLS=True"
    call:CURL "0" "https://www.uwe-sieber.de/files/DeviceCleanup.zip" "%UserProfile%\Documents\_Tools\Utilities\DeviceCleanup\DeviceCleanup.zip"
    call:UNZIP "%UserProfile%\Documents\_Tools\Utilities\DeviceCleanup\DeviceCleanup.zip" "%UserProfile%\Documents\_Tools\Utilities\DeviceCleanup"
    del /f /q "%UserProfile%\Documents\_Tools\Utilities\DeviceCleanup\DeviceCleanup.zip" >nul 2>&1
)
if "!Cleanmgr Plus!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Cleanmgr Plus" (
    set "OPENTOOLS=True"
    call:CURL "0" "https://github.com/builtbybel/CleanmgrPlus/releases/download/1.50.1300/cleanmgrplus.zip" "%UserProfile%\Documents\_Tools\Utilities\Cleanmgr Plus\cleanmgr.zip"
    call:UNZIP "%UserProfile%\Documents\_Tools\Utilities\Cleanmgr Plus\cleanmgr.zip" "%UserProfile%\Documents\_Tools\Utilities\Cleanmgr Plus"
    del /f /q "%UserProfile%\Documents\_Tools\Utilities\Cleanmgr Plus\cleanmgr.zip" >nul 2>&1
)
if "!Ventoy!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Ventoy" (
    set "OPENTOOLS=True"
    call:CURL "0" "https://github.com/ventoy/Ventoy/releases/download/v1.0.71/ventoy-1.0.71-windows.zip" "%UserProfile%\Documents\_Tools\Utilities\ventoy.zip"
    call:UNZIP "%UserProfile%\Documents\_Tools\Utilities\ventoy.zip" "%UserProfile%\Documents\_Tools\Utilities"
    del /f /q "%UserProfile%\Documents\_Tools\Utilities\ventoy.zip" >nul 2>&1
)
if "!Rufus!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Rufus" (
    set "OPENTOOLS=True"
    call:CURL "0" "https://github.com/pbatard/rufus/releases/download/v3.18/rufus-3.18.exe" "%UserProfile%\Documents\_Tools\Utilities\rufus.exe"
)
if "!Registry Finder!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Registry Finder" (
    set "OPENTOOLS=True"
    call:CURL "0" "https://registry-finder.com/bin/2.53.0.0/RegistryFinder64.zip" "%UserProfile%\Documents\_Tools\Utilities\Registry Finder\RegistryFinder64.zip"
    call:UNZIP "%UserProfile%\Documents\_Tools\Utilities\Registry Finder\RegistryFinder64.zip" "%UserProfile%\Documents\_Tools\Utilities\Registry Finder"
    del /f /q "%UserProfile%\Documents\_Tools\Utilities\Registry Finder\RegistryFinder64.zip" >nul 2>&1
)
if "!Bloatware Removal Utility!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Bloatware Removal Utility" (
    set "OPENTOOLS=True"
    call:CURL "0" "https://github.com/arcadesdude/BRU/archive/master.zip" "%UserProfile%\Documents\_Tools\Utilities\bru.zip"
    call:UNZIP "%UserProfile%\Documents\_Tools\Utilities\bru.zip" "%UserProfile%\Documents\_Tools\Utilities"
    move "%UserProfile%\Documents\_Tools\Utilities\BRU-master" "%UserProfile%\Documents\_Tools\Utilities\BRU" >nul 2>&1
    del /f /q "%UserProfile%\Documents\_Tools\Utilities\bru.zip" >nul 2>&1
)
REM SYSTEM INFOS
if "!CPU-Z!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! CPU-Z" (
    set "OPENTOOLS=True"
    call:CURL "0" "https://download.cpuid.com/cpu-z/cpu-z_1.96-en.zip" "%UserProfile%\Documents\_Tools\System infos\CPU-Z\cpu.zip"
    call:UNZIP "%UserProfile%\Documents\_Tools\System infos\CPU-Z\cpu.zip" "%UserProfile%\Documents\_Tools\System infos\CPU-Z"
    del /f /q "%UserProfile%\Documents\_Tools\System infos\CPU-Z\cpu.zip" >nul 2>&1
)
if "!GPU-Z!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! GPU-Z" set "OPENTOOLS=True" & call:CURL "0" "https://raw.githubusercontent.com/ArtanisInc/Post-Tweaks-Tools/main/GPUZ.exe" "%UserProfile%\Documents\_Tools\System infos\GPU-Z.exe"
if "!HWiNFO!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! HWiNFO" (
    set "OPENTOOLS=True"
    call:CURL "0" "https://www.sac.sk/download/utildiag/hwi_706.zip" "%UserProfile%\Documents\_Tools\System infos\HWiNFO\hwi.zip"
    call:UNZIP "%UserProfile%\Documents\_Tools\System infos\HWiNFO\hwi.zip" "%UserProfile%\Documents\_Tools\System infos\HWiNFO"
    del /f /q "%UserProfile%\Documents\_Tools\System infos\HWiNFO\hwi.zip" >nul 2>&1
)
if "!CrystalDiskInfo!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! CrystalDiskInfo" (
    set "OPENTOOLS=True"
    call:CURL "0" "https://osdn.mirror.constant.com//crystaldiskinfo/75539/CrystalDiskInfo8_12_4.zip" "%UserProfile%\Documents\_Tools\System infos\CrystalDiskInfo\CrystalDiskInfo.zip"
    call:UNZIP "%UserProfile%\Documents\_Tools\System infos\CrystalDiskInfo\CrystalDiskInfo.zip" "%UserProfile%\Documents\_Tools\System infos\CrystalDiskInfo"
    del /f /q "%UserProfile%\Documents\_Tools\System infos\CrystalDiskInfo\CrystalDiskInfo.zip" >nul 2>&1
)
REM DRIVERS
if "!Snappy Driver Installer!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Snappy Driver Installer" (
    set "OPENTOOLS=True"
    call:CURL "0" "http://sdi-tool.org/releases/SDI_R2000.zip" "%UserProfile%\Documents\_Tools\Drivers\Snappy Driver Installer\SDI.zip"
    call:UNZIP "%UserProfile%\Documents\_Tools\Drivers\Snappy Driver Installer\SDI.zip" "%UserProfile%\Documents\_Tools\Drivers\Snappy Driver Installer"
    del /f /q "%UserProfile%\Documents\_Tools\Drivers\Snappy Driver Installer\SDI.zip" >nul 2>&1
)
if "!NVCleanstall!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! NVCleanstall" set "OPENTOOLS=True" & call:CURL "0" "https://raw.githubusercontent.com/ArtanisInc/Post-Tweaks-Tools/main/NVCleanstall.exe" "%UserProfile%\Documents\_Tools\Drivers\NVCleanstall.exe"
if "!Radeon Software Slimmer!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Radeon Software Slimmer" (
    set "OPENTOOLS=True"
    call:CURL "0" "https://github.com/GSDragoon/RadeonSoftwareSlimmer/releases/download/1.5.0/RadeonSoftwareSlimmer_1.5.0_net48.zip" "%UserProfile%\Documents\_Tools\Drivers\Radeon Software Slimmer\RadeonSoftwareSlimmer.zip"
    call:UNZIP "%UserProfile%\Documents\_Tools\Drivers\Radeon Software Slimmer\RadeonSoftwareSlimmer.zip" "%UserProfile%\Documents\_Tools\Drivers\Radeon Software Slimmer"
    del /f /q "%UserProfile%\Documents\_Tools\Drivers\Radeon Software Slimmer\RadeonSoftwareSlimmer.zip" >nul 2>&1
)
if "!Display Driver Uninstaller!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Display Driver Uninstaller" (
    set "OPENTOOLS=True"
    call:CURL "0" "https://raw.githubusercontent.com/ArtanisInc/Post-Tweaks-Tools/main/DDU.zip" "%UserProfile%\Documents\_Tools\Drivers\Display Driver Uninstaller\DDU.zip"
    call:UNZIP "%UserProfile%\Documents\_Tools\Drivers\Display Driver Uninstaller\DDU.zip" "%UserProfile%\Documents\_Tools\Drivers\Display Driver Uninstaller"
    del /f /q "%UserProfile%\Documents\_Tools\Drivers\Display Driver Uninstaller\DDU.zip" >nul 2>&1
)
if "!DriverStore Explorer!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! DriverStore Explorer" (
    set "OPENTOOLS=True"
    call:CURL "0" "https://github.com/lostindark/DriverStoreExplorer/releases/download/v0.11.72/DriverStoreExplorer.v0.11.72.zip" "%UserProfile%\Documents\_Tools\Drivers\DriverStore Explorer\DriverStoreExplorer.zip"
    call:UNZIP "%UserProfile%\Documents\_Tools\Drivers\DriverStore Explorer\DriverStoreExplorer.zip" "%UserProfile%\Documents\_Tools\Drivers\DriverStore Explorer"
    del /f /q "%UserProfile%\Documents\_Tools\Drivers\DriverStore Explorer\DriverStoreExplorer.zip" >nul 2>&1
)
REM BENCHMARK & STRESS
if "!Unigine Superposition!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Unigine Superposition" call:CHOCO superposition-benchmark
if "!CINEBENCH!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! CINEBENCH" (
    set "OPENTOOLS=True"
    call:CURL "0" "http://http.maxon.net/pub/cinebench/CinebenchR20.zip" "%UserProfile%\Documents\_Tools\Benchmark\Cinebench\CinebenchR20.zip"
    call:UNZIP "%UserProfile%\Documents\_Tools\Benchmark\Cinebench\CinebenchR20.zip" "%UserProfile%\Documents\_Tools\Benchmark\Cinebench"
    del /f /q "%UserProfile%\Documents\_Tools\Benchmark\Cinebench\CinebenchR20.zip" >nul 2>&1
)
if "!AIDA64!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! AIDA64" (
    set "OPENTOOLS=True"
    call:CURL "0" "https://dl.comptoir.co/finalwire/aida64extreme633.zip" "%UserProfile%\Documents\_Tools\Benchmark\AIDA64\aida64extreme.zip"
    call:UNZIP "%UserProfile%\Documents\_Tools\Benchmark\AIDA64\aida64extreme.zip" "%UserProfile%\Documents\_Tools\Benchmark\AIDA64"
    del /f /q "%UserProfile%\Documents\_Tools\Benchmark\AIDA64\aida64extreme.zip" >nul 2>&1
)
if "!OCCT!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! OCCT" set "OPENTOOLS=True" & call:CURL "0" "https://www.ocbase.com/download" "%UserProfile%\Documents\_Tools\Benchmark\OCCT.exe"
if "!CapFrameX!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! CapFrameX" (
    set "OPENTOOLS=True"
    call:CURL "0" "https://github.com/CXWorld/CapFrameX/releases/download/v1.6.7/CapFrameX_v1.6.7_Portable.zip" "%UserProfile%\Documents\_Tools\Benchmark\CapFrameX\CapFrameX.zip"
    call:UNZIP "%UserProfile%\Documents\_Tools\Benchmark\CapFrameX\CapFrameX.zip" "%UserProfile%\Documents\_Tools\Benchmark\CapFrameX"
    del /f /q "%UserProfile%\Documents\_Tools\Benchmark\CapFrameX\CapFrameX.zip" >nul 2>&1
)
if "!MouseTester!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! MouseTester" (
    set "OPENTOOLS=True"
    call:CURL "0" "https://github.com/microe1/MouseTester/releases/download/MouseTester_v1.4/Release_v1.4.zip" "%UserProfile%\Documents\_Tools\Benchmark\MouseTester\MouseTester.zip"
    call:UNZIP "%UserProfile%\Documents\_Tools\Benchmark\MouseTester\MouseTester.zip" "%UserProfile%\Documents\_Tools\Benchmark\MouseTester"
    del /f /q "%UserProfile%\Documents\_Tools\Benchmark\MouseTester\MouseTester.zip" >nul 2>&1
)
REM TWEAKS
if "!GoInterruptPolicy!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! GoInterruptPolicy" set "OPENTOOLS=True" & call:CURL "0" "https://github.com/spddl/GoInterruptPolicy/releases/download/v1.1.0/GoInterruptPolicy.exe" "%UserProfile%\Documents\_Tools\Tweaks\GoInterruptPolicy.exe"
if "!AutoGpuAffinity!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! AutoGpuAffinity" set "OPENTOOLS=True" & call:CURL "0" "https://github.com/spddl/AutoGpuAffinity/releases/download/v1.0.1/AutoGpuAffinity.exe" "%UserProfile%\Documents\_Tools\Tweaks\AutoGpuAffinity.exe"
if "!TCP Optimizer!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! TCP Optimizer" set "OPENTOOLS=True" & call:CURL "0" "https://www.speedguide.net/files/TCPOptimizer.exe" "%UserProfile%\Documents\_Tools\Tweaks\TCPOptimizer.exe"
if "!DNS Jumper!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! DNS Jumper" (
    set "OPENTOOLS=True"
    call:CURL "0" "https://www.sordum.org/files/download/dns-jumper/DnsJumper.zip" "%UserProfile%\Documents\_Tools\Tweaks\DnsJumper.zip"
    call:UNZIP "%UserProfile%\Documents\_Tools\Tweaks\DnsJumper.zip" "%UserProfile%\Documents\_Tools\Tweaks"
    del /f /q "%UserProfile%\Documents\_Tools\Tweaks\DnsJumper.zip" >nul 2>&1
)
if "!Nvidia Profile Inspector!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Nvidia Profile Inspector" (
    set "OPENTOOLS=True"
    call:CURL "0" "https://github.com/Orbmu2k/nvidiaProfileInspector/releases/download/2.3.0.13/nvidiaProfileInspector.zip" "%UserProfile%\Documents\_Tools\Tweaks\Nvidia Profile Inspector\nvidiaProfileInspector.zip"
    call:UNZIP "%UserProfile%\Documents\_Tools\Tweaks\Nvidia Profile Inspector\nvidiaProfileInspector.zip" "%UserProfile%\Documents\_Tools\Tweaks\Nvidia Profile Inspector"
    del /f /q "%UserProfile%\Documents\_Tools\Tweaks\Nvidia Profile Inspector\nvidiaProfileInspector.zip" >nul 2>&1
)
if "!RadeonMod!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! RadeonMod" set "OPENTOOLS=True" & call:CURL "0" "https://raw.githubusercontent.com/ArtanisInc/Post-Tweaks-Tools/main/RadeonMod.exe" "%UserProfile%\Documents\_Tools\Tweaks\RadeonMod.exe"
if "!GPU Pixel Clock Patcher!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! GPU Pixel Clock Patcher" (
    set "OPENTOOLS=True"
    call:CURL "0" "https://www.monitortests.com/download/nvlddmkm-patcher/nvlddmkm-patcher-1.4.13.zip" "%UserProfile%\Documents\_Tools\Tweaks\GPU Pixel Clock Patcher\Nvidia\nvlddmkm-patcher.zip"
    call:CURL "0" "https://www.monitortests.com/download/atikmdag-patcher/atikmdag-patcher-1.4.10.zip" "%UserProfile%\Documents\_Tools\Tweaks\GPU Pixel Clock Patcher\AMD\atikmdag-patcher.zip"
    call:UNZIP "%UserProfile%\Documents\_Tools\Tweaks\GPU Pixel Clock Patcher\Nvidia\nvlddmkm-patcher.zip" "%UserProfile%\Documents\_Tools\Tweaks\GPU Pixel Clock Patcher\Nvidia"
    call:UNZIP "%UserProfile%\Documents\_Tools\Tweaks\GPU Pixel Clock Patcher\AMD\atikmdag-patcher.zip" "%UserProfile%\Documents\_Tools\Tweaks\GPU Pixel Clock Patcher\AMD"
    del /f /q "%UserProfile%\Documents\_Tools\Tweaks\GPU Pixel Clock Patcher\Nvidia\nvlddmkm-patcher.zip" >nul 2>&1 & del /f /q "%UserProfile%\Documents\_Tools\Tweaks\GPU Pixel Clock Patcher\AMD\atikmdag-patcher.zip" >nul 2>&1
)
if "!Custom Resolution Utility!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Custom Resolution Utility" (
    set "OPENTOOLS=True"
    call:CURL "0" "https://www.monitortests.com/download/cru/cru-1.5.1.zip" "%UserProfile%\Documents\_Tools\Tweaks\Custom Resolution Utility\cru.zip"
    call:UNZIP "%UserProfile%\Documents\_Tools\Tweaks\Custom Resolution Utility\cru.zip" "%UserProfile%\Documents\_Tools\Tweaks\Custom Resolution Utility"
    del /f /q "%UserProfile%\Documents\_Tools\Tweaks\Custom Resolution Utility\cru.zip" >nul 2>&1
)
if "!SweetLow Mouse Rate Changer!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! SweetLow Mouse Rate Changer" (
    set "OPENTOOLS=True"
    call:CURL "0" "https://raw.githubusercontent.com/LordOfMice/hidusbf/master/hidusbf.zip" "%UserProfile%\Documents\_Tools\Tweaks\SweetLow Mouse Rate Changer\hidusbf.zip"
    call:UNZIP "%UserProfile%\Documents\_Tools\Tweaks\SweetLow Mouse Rate Changer\hidusbf.zip" "%UserProfile%\Documents\_Tools\Tweaks\SweetLow Mouse Rate Changer"
    del /f /q "%UserProfile%\Documents\_Tools\Tweaks\SweetLow Mouse Rate Changer\hidusbf.zip" >nul 2>&1
)
if "!ThrottleStop!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! ThrottleStop" set "OPENTOOLS=True" & call:CURL "0" "https://raw.githubusercontent.com/ArtanisInc/Post-Tweaks-Tools/main/ThrottleStop.exe" "%UserProfile%\Documents\_Tools\Tweaks\ThrottleStop.exe"
if "!Power Settings Explorer!"=="!S_MAGENTA![!S_GREEN!x!S_MAGENTA!]!S_WHITE! Power Settings Explorer" set "OPENTOOLS=True" & call:CURL "0" "https://raw.githubusercontent.com/ArtanisInc/Post-Tweaks-Tools/main/PowerSettingsExplorer.exe" "%UserProfile%\Documents\_Tools\Tweaks\PowerSettingsExplorer.exe"
if "!OPENTOOLS!"=="True" start "" "explorer.exe" "%UserProfile%\Documents\_Tools"
goto TOOLS_MENU_CLEAR

:CREDITS
call:MSGBOX "Revision community - Learned a lot about PC Tweaking\nTheBATeam community - Coding help\nMathieu Squidward - Coding help\nAveyo - Code snippet (RunAsTI)\nAMIT - Code snippet (system mitigation and split audio service)\nFelip - Code inspirations from his 'Tweaks for Gaming' batch\nTimecard - For his research about PC optimization, configuration and setup\n\nThanks to many other people for help with testing and suggestions.\n\n                                                                         Created by Artanis" vbInformation "Credits"
goto MAIN_MENU

:HELP
call:MSGBOX "Post Tweaks aims to improve the responsiveness, performance and privacy of Windows. It also allows automatic installation of essential programs in the background.\n\nOptions:\n\n1) SYSTEM TWEAKS\n   ● Remove unnecessary Microsoft apps\n   ● Disable unnecessary services\n   ● Disable power saving features\n   ● Disable telemetry\n   ● Optimize drivers\n   ● Optimize network\n   ● Harden Windows\n   ● Personalize Windows\n\n2) SOFTWARE INSTALLER\nDisplay a selection menu that let you download and install essential programs automatically in the background.\n\n3) TOOLS\nDisplay a selection menu that let you download useful tools." vbInformation "Help"
goto MAIN_MENU

REM =====================================================
REM ==================    FONCTIONS    ==================
REM =====================================================

:SETCONSTANTS
REM Colors and text format
set "CMDLINE=RED=[31m,S_GRAY=[90m,S_RED=[91m,S_GREEN=[92m,S_YELLOW=[93m,S_MAGENTA=[95m,S_WHITE=[97m,B_BLACK=[40m,B_YELLOW=[43m,UNDERLINE=[4m,_UNDERLINE=[24m"
set "%CMDLINE:,=" & set "%"
REM ECHOX
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do set datetime=%%I
set datetime=!datetime:~0,8!-!datetime:~8,6!
REM Check Computer type
for /f "delims=:{}" %%i in ('wmic path Win32_systemenclosure get ChassisTypes^| findstr [0-9]') do set "CHASSIS=%%i"
for %%i in (8 9 10 11 12 14 18 21 13 31 32 30) do if "!CHASSIS!"=="%%i" set "PC_TYPE=LAPTOP/TABLET"
REM Check SSD\NVME
call "resources\smartctl.exe" %systemdrive% -i | findstr /c:"Rotation Rate:" | findstr /c:"Solid State Device" >nul 2>&1 && set "STORAGE_TYPE=SSD/NVMe"
call "resources\smartctl.exe" %systemdrive% -i | findstr /c:"NVMe Version:" >nul 2>&1 && set "STORAGE_TYPE=SSD/NVMe"
REM Check GPU
wmic path Win32_VideoController get Name | findstr "NVIDIA" >nul 2>&1 && set "GPU=NVIDIA"
wmic path Win32_VideoController get Name | findstr "AMD ATI" >nul 2>&1 && set "GPU=AMD"
wmic path Win32_VideoController get Name | findstr "Intel" >nul 2>&1 && set "GPU=INTEL"
REM Check HT/SMT
for /f "skip=1" %%i in ('wmic CPU get NumberOfCores^| findstr [0-9]') do set "CORES=%%i"
for /f "skip=1" %%i in ('wmic CPU get NumberOfLogicalProcessors^| findstr [0-9]') do set "LOGICAL_PROCESSORS=%%i"
if !CORES! lss !LOGICAL_PROCESSORS! (set "HT_SMT=ON") else set "HT_SMT=OFF"
REM Check Wi-Fi
wmic path WIN32_NetworkAdapter where NetConnectionID="Wi-Fi" get NetConnectionStatus | findstr "2" >nul 2>&1 && set "NIC_TYPE=WIFI"
REM Check VC++ Redistributable
reg query "HKLM\SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes" /ve >nul 2>&1
if !ERRORLEVEL! equ 1 set "VC=NOT_INSTALLED"
REM Power plan GUID
set "POWER_GUID=%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%-%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%-%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%-%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%-%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%%random:~0,1%"
REM Total memory and SvcHost
for /f "skip=1" %%i in ('wmic os get TotalVisibleMemorySize') do if not defined TOTAL_MEMORY set "TOTAL_MEMORY=%%i" & set /a SVCHOST=%%i+1024000
REM User SID
for /f %%i in ('wmic path Win32_UserAccount where name^="%username%" get sid ^| findstr "S-"') do set "USER_SID=%%i"
goto:eof

:ECHOX
echo !S_WHITE!%time:~0,8% [!S_RED!INFO!S_WHITE!]:!S_GREEN! %*
echo %time:~0,8% [INFO]: %* >>"logs\log_!datetime!.txt"
goto:eof

:POWERSHELL
chcp 437 >nul 2>&1 & powershell -nop -noni -exec bypass -c %* >nul 2>&1 & chcp 65001 >nul 2>&1
goto:eof

:NIC_SETTINGS
for /f "tokens=1,2*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}" /s /v "*IfType"^| findstr /i "HKEY 0x6 0x47"') do if /i "%%i" neq "*IfType" (set "REGPATH_NIC=%%i") else (for /f %%a in ('reg query "!REGPATH_NIC!" /v "%~1"^| findstr "HKEY"') do reg add "%%a" /v "%~1" /t REG_SZ /d "%~2" /f) >nul 2>&1
goto:eof

:CHOCO [Package]
if not exist "%ProgramData%\chocolatey" call:POWERSHELL "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && set "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin" & call "%ProgramData%\chocolatey\bin\RefreshEnv.cmd"
choco install -y --limit-output --ignore-checksums %*
goto:eof

:CURL [Argument] [URL] [Directory]
if not exist "%WinDir%\System32\curl.exe" if not exist "%ProgramData%\chocolatey\lib\curl" call:CHOCO curl
if "%~1"=="0" curl -k -L --progress-bar "%~2" --create-dirs -o "%~3"
if "%~1"=="1" curl --silent "%~2" --create-dirs -o "%~3"
goto:eof

:MSGBOX [Text] [Argument] [Title]
echo WScript.Quit Msgbox(Replace("%~1","\n",vbCrLf),%~2,"%~3") >"%TMP%\msgbox.vbs"
cscript /nologo "%TMP%\msgbox.vbs"
set "exitCode=!ERRORLEVEL!" & del /f /q "%TMP%\msgbox.vbs" >nul 2>&1
exit /b %exitCode%

:SHORTCUT [Name] [Path] [TargetPath] [WorkingDirectory]
echo Set WshShell=WScript.CreateObject^("WScript.Shell"^) >"%TMP%\shortcut.vbs"
echo Set lnk=WshShell.CreateShortcut^("%~2\%~1.lnk"^) >>"%TMP%\shortcut.vbs"
echo lnk.TargetPath="%~3" >>"%TMP%\shortcut.vbs"
echo lnk.WorkingDirectory="%~4" >>"%TMP%\shortcut.vbs"
echo lnk.WindowStyle=4 >>"%TMP%\shortcut.vbs"
echo lnk.Save >>"%TMP%\shortcut.vbs"
cscript /nologo "%TMP%\shortcut.vbs" & del /f /q "%TMP%\shortcut.vbs" >nul 2>&1
goto:eof

:UNZIP [FilePath] [DestinationPath]
call:POWERSHELL "Expand-Archive -Path '%~1' -DestinationPath '%~2'"
goto:eof

#:RunAsTI snippet to run as TI/System, with innovative HKCU load, ownership privileges, high priority, and explorer support
set ^ #=& set "0=%~f0"& set 1=%*& powershell -c iex(([io.file]::ReadAllText($env:0)-split'#\:RunAsTI .*')[1])& exit /b
function RunAsTI ($cmd,$arg) { $id='RunAsTI'; $key="Registry::HKU\$(((whoami /user)-split' ')[-1])\Volatile Environment"; $code=@'
$I=[int32]; $M=$I.module.gettype("System.Runtime.Interop`Services.Mar`shal"); $P=$I.module.gettype("System.Int`Ptr"); $S=[string]
$D=@(); $T=@(); $DM=[AppDomain]::CurrentDomain."DefineDynami`cAssembly"(1,1)."DefineDynami`cModule"(1); $Z=[uintptr]::size
0..5|% {$D += $DM."Defin`eType"("AveYo_$_",1179913,[ValueType])}; $D += [uintptr]; 4..6|% {$D += $D[$_]."MakeByR`efType"()}
$F='kernel','advapi','advapi', ($S,$S,$I,$I,$I,$I,$I,$S,$D[7],$D[8]), ([uintptr],$S,$I,$I,$D[9]),([uintptr],$S,$I,$I,[byte[]],$I)
0..2|% {$9=$D[0]."DefinePInvok`eMethod"(('CreateProcess','RegOpenKeyEx','RegSetValueEx')[$_],$F[$_]+'32',8214,1,$S,$F[$_+3],1,4)}
$DF=($P,$I,$P),($I,$I,$I,$I,$P,$D[1]),($I,$S,$S,$S,$I,$I,$I,$I,$I,$I,$I,$I,[int16],[int16],$P,$P,$P,$P),($D[3],$P),($P,$P,$I,$I)
1..5|% {$k=$_; $n=1; $DF[$_-1]|% {$9=$D[$k]."Defin`eField"('f' + $n++, $_, 6)}}; 0..5|% {$T += $D[$_]."Creat`eType"()}
0..5|% {nv "A$_" ([Activator]::CreateInstance($T[$_])) -fo}; function F ($1,$2) {$T[0]."G`etMethod"($1).invoke(0,$2)}
$TI=(whoami /groups)-like'*1-16-16384*'; $As=0; if(!$cmd) {$cmd='control';$arg='admintools'}; if ($cmd-eq'This PC'){$cmd='file:'}
if (!$TI) {'TrustedInstaller','lsass','winlogon'|% {if (!$As) {$9=sc.exe start $_; $As=@(get-process -name $_ -ea 0|% {$_})[0]}}
function M ($1,$2,$3) {$M."G`etMethod"($1,[type[]]$2).invoke(0,$3)}; $H=@(); $Z,(4*$Z+16)|% {$H += M "AllocHG`lobal" $I $_}
M "WriteInt`Ptr" ($P,$P) ($H[0],$As.Handle); $A1.f1=131072; $A1.f2=$Z; $A1.f3=$H[0]; $A2.f1=1; $A2.f2=1; $A2.f3=1; $A2.f4=1
$A2.f6=$A1; $A3.f1=10*$Z+32; $A4.f1=$A3; $A4.f2=$H[1]; M "StructureTo`Ptr" ($D[2],$P,[boolean]) (($A2 -as $D[2]),$A4.f2,$false)
$Run=@($null, "powershell -win 1 -nop -c iex `$env:R; # $id", 0, 0, 0, 0x0E080600, 0, $null, ($A4 -as $T[4]), ($A5 -as $T[5]))
F 'CreateProcess' $Run; return}; $env:R=''; rp $key $id -force; $priv=[diagnostics.process]."GetM`ember"('SetPrivilege',42)[0]
'SeSecurityPrivilege','SeTakeOwnershipPrivilege','SeBackupPrivilege','SeRestorePrivilege' |% {$priv.Invoke($null, @("$_",2))}
$HKU=[uintptr][uint32]2147483651; $NT='S-1-5-18'; $reg=($HKU,$NT,8,2,($HKU -as $D[9])); F 'RegOpenKeyEx' $reg; $LNK=$reg[4]
function L ($1,$2,$3) {sp 'HKLM:\Software\Classes\AppID\{CDCBCFCA-3CDC-436f-A4E2-0E02075250C2}' 'RunAs' $3 -force -ea 0
$b=[Text.Encoding]::Unicode.GetBytes("\Registry\User\$1"); F 'RegSetValueEx' @($2,'SymbolicLinkValue',0,6,[byte[]]$b,$b.Length)}
function Q {[int](gwmi win32_process -filter 'name="explorer.exe"'|?{$_.getownersid().sid-eq$NT}|select -last 1).ProcessId}
$11bug=($((gwmi Win32_OperatingSystem).BuildNumber)-eq'22000')-AND(($cmd-eq'file:')-OR(test-path -lit $cmd -PathType Container))
if ($11bug) {'System.Windows.Forms','Microsoft.VisualBasic' |% {[Reflection.Assembly]::LoadWithPartialName("'$_")}}
if ($11bug) {$path=$path='^(l)'+$($cmd -replace '([\+\^\%\~\(\)\[\]])','{$1}')+'{ENTER}'; $cmd='control.exe'; $arg='admintools'}
L ($key-split'\\')[1] $LNK ''; $R=[diagnostics.process]::start($cmd,$arg); if ($R) {$R.PriorityClass='High'; $R.WaitForExit()}
if ($11bug) {$w=0; do {if($w-gt40){break}; sleep -mi 250;$w++} until (Q); [Microsoft.VisualBasic.Interaction]::AppActivate($(Q))}
if ($11bug) {[Windows.Forms.SendKeys]::SendWait($path)}; do {sleep 7} while(Q); L '.Default' $LNK 'Interactive User'
'@; $V='';'cmd','arg','id','key'|%{$V+="`n`$$_='$($(gv $_ -val)-replace"'","''")';"}; sp $key $id $($V,$code) -type 7 -force -ea 0
start powershell -args "-win 1 -nop -c `n$V `$env:R=(gi `$key -ea 0).getvalue(`$id)-join''; iex `$env:R" -verb runas
}; $A=$env:1-split'"([^"]+)"|([^ ]+)',2|%{$_.Trim(' "')}; RunAsTI $A[1] $A[2]; #:RunAsTI lean & mean snippet by AveYo, 2022.01.28