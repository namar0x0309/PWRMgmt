@echo off

REM Author: Nassim Amar
REM Requires https://sourceforge.net/projects/qres/ 
REM Usage: pass "-battery" or "-power". Default: -battery
REM todo: powercfg /l | findstr * | findstr Balanced
REM       this detects which power config is happening right now 
REM Set-ExecutionPolicy Unrestricted -Scope CurrentUser
REM and call to get battery number:
REM      powershell -command "& {. %cd%\BatteryHealthHelper.ps1; Test-BatteryHealth }"
REM throttlestop can call a script when its profile changes (with battery)



REM true if power supply else false if battery
set OnLine=false
set cmd=WMIC /NameSpace:\\root\WMI Path BatteryStatus Get PowerOnline
%cmd% | find /i "true" > nul && set OnLine=true

echo Power Source is %OnLine%, will apply changes in
timeout /t 3 /nobreak

IF %OnLine%==true GOTO POWER
IF %OnLine%==false GOTO BATTERY
 
 :BATTERY
 echo battery setting
call %~dp0\binaries\qures\qres.exe x=1920 y=1080 f=60
GOTO END

:POWER
echo power setting
call %~dp0\binaries\qures\qres.exe x=1920 y=1080 f=144

:END