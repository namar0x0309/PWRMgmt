### Sample script to check Battery Health 
### on systems with a single battery 
### Compatible with Windows 7 and later 
### This script is provided As Is 
### Script by Joao Botto 
### Version 0.3 
 
 
### INSTRUCTIONS: 
### Execute this script when you want information 
### about the battery health 
### or regularly as a scheduled task 
 
### PARAMETERS: 
### show - Shows current battery health on screen 
### reg - Save information in HKLM:\SOFTWARE\BatteryHealth 
### file - Save information in c:\BatteryHealth 
 
 
[CmdletBinding()] 
    Param([Parameter(Mandatory=$false)][String]$action) 
 
 
# Compute battery health in percentage 
# of original possible cycles 
 
Function Test-BatteryHealth 
{ 
    $fullchargecapacity = (Get-WmiObject -Class "BatteryFullChargedCapacity" -Namespace "ROOT\WMI").FullChargedCapacity 
    $designcapacity = (Get-WmiObject -Class "BatteryStaticData" -Namespace "ROOT\WMI").DesignedCapacity 
 
    if ($fullchargecapacity -eq $designcapacity) { 
        Write-Host "Your system doesn't seem capable of providing accurate battery information`n" -ForegroundColor black -BackgroundColor red 
        Exit 1 
    } 
 
    $batteryhealth = ($fullchargecapacity / $designcapacity) * 100 
    if ($batteryhealth -gt 100) {$batteryhealth = 100} 
    return [decimal]::round($batteryhealth)  
} 
 
 
# Show battery health on the screen 
 
Function Show-BatteryHealth 
{ 
    if ($batteryhealth -gt 90) { Write-Host "Last full charge was $batteryhealth% of original capacity`n" -ForegroundColor black -BackgroundColor Green } 
    if ($batteryhealth -lt 89 -and $batteryhealth -gt 70) { Write-Host "Last full charge was $batteryhealth% of original capacity`n" -ForegroundColor black -BackgroundColor Yellow } 
    if ($batteryhealth -lt 69) { Write-Host "Last full charge was $batteryhealth% of original capacity`n" -ForegroundColor black -BackgroundColor Red } 
} 
 
 
# Write battery health and date 
# to the registry 
 
Function Add-BatteryRegistry 
{ 
    If (!(Test-Path HKLM:\SOFTWARE\BatteryHealth)) { 
        If (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { 
            Write-Host "Cannot write to registry. This script needs to be run as Administrator`n" -ForegroundColor black -BackgroundColor red 
            Exit 1 
        } 
        $null = New-Item -Path HKLM:\SOFTWARE\BatteryHealth 
    } 
     
    Set-ItemProperty -Path HKLM:\SOFTWARE\BatteryHealth -Name EvalDate -Value $date 
    Set-ItemProperty -Path HKLM:\SOFTWARE\BatteryHealth -Name PercentOrigCapacity -Value $batteryhealth 
 
} 
 
 
# Write battery health and date 
# to a file 
 
Function Add-BatteryFile 
{ 
    if (!(Test-Path c:\BatteryHealth)) { 
        $null = New-Item c:\BatteryHealth -type directory 
    } 
     
    Add-Content c:\BatteryHealth\Log.txt "`n Assessed on $date" 
    Add-Content c:\BatteryHealth\Log.txt "`n On the last full charge the battery could hold -- $batteryhealth% -- of its original capacity" 
    Add-Content c:\BatteryHealth\Log.txt "`n" 
} 
 
 
# Main 
 
# $date = Get-Date -format d 
 
# $batteryhealth = Test-BatteryHealth 
 
# switch ($action) { 
#     "show" {Show-BatteryHealth} 
 
#     "reg" {Add-BatteryRegistry} 
 
#     "file" {Add-BatteryFile} 
 
#     "?" {Write-Host "`n" 
#          Write-Host "Available parameters:" 
#          Write-Host "show - Shows current battery health on screen" 
#          Write-Host "reg - Save information in HKLM:\SOFTWARE\BatteryHealth" 
#          Write-Host "file - Save information in c:\BatteryHealth" 
#          Write-Host "`n" 
#         } 
     
#     default { 
#         $wshell = New-Object -ComObject Wscript.Shell 
#         $continue = $wshell.Popup("You haven't provided a parameter such as show, reg or file. `n`nPress OK to continue and log battery capacity information to file and registry",0,"No Parameter",0x1)  
#             if($continue -ne 1) {Exit 1} 
#         Show-BatteryHealth 
#         Add-BatteryRegistry 
#         Add-BatteryFile 
#     } 
# } 
 
 
# end 
 
Exit 0