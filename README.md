# For Work
## SysInfo Script
SysInfo script in repo will refrence  some of the power shell commands below:
## Powershell
To see logged on users
```
invoke-command -cn HOSTNAME -scriptblock {quser} 
```
To log out user
```
invoke-Command -ScriptBlock { logoff # } 
```
Get Printer info from print server
```
Get-Printer -ComputerName "printserver" -Name "name*"
```
To run on remote device
```
-cn HOSTNAME  
```
To enter powershell session on remote device
```
enter-pssession 
```
To pull system info
```
Get-WmiObject win32_computersystem
```
To pull serial and BIOS info
```
Get-WmiObject win32_bios
 ```
To pull RAM info
```
Get-WMIObject -class Win32_PhysicalMemory
```
To pull Drive info
```
Get-wmiobject win32_diskdrive
```
To pull gpu info
```
Get-WmiObject win32_VideoController 
```
To get windows version can also use winver
```
Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' |format-list  ReleaseId 
```
To get Encryption status
```
manage-bde –status
```
To get running processes
```
get-process
```
- get-aduser
- get-adcomputer
- net user $username $password /add /expires:never
- net localgroup Administrators UserName /add

Check AD for computer with name
```
Get-ADComputer -Filter {Name -like "Bellevuecd*"} | Sort-Object Name | Select-Object Name
```
Check AD group membership of user
```
(Get-ADUser -Identity "name" -Properties MemberOf).MemberOf | Get-ADGroup | Where-Object { $_.Name -like "shar*" } | Select-Object -ExpandProperty Name
```

## Sciprt for checking if hostnames in CSV file are online
```
$hostnames = Import-Csv -Path "C:\temp\host.csv" | Select-Object -ExpandProperty Hostname

foreach ($hostname in $hostnames) {
    if (Test-Connection -ComputerName $hostname -Count 1 -Quiet) {
        $ip = (Resolve-DnsName -Name $hostname -ErrorAction SilentlyContinue).IPAddress
        Write-Output "$hostname is online at IP address $ip"
    } else {
        Write-Output "$hostname is offline"
    }
}
```
## Map Network Share Batch File

```
@echo Create new $LETTER: drive mapping
@net use P: \\$PATH /persistent:yes
taskkill /F /IM explorer.exe & start explorer
:exit
@pause
```

## Delete Chrome Bookmarks Batch File
```
@echo off
if exist "%LocalAppData%\Google\Chrome\User Data\Default\Bookmarks" (
  ren "%LocalAppData%\Google\Chrome\User Data\Default\Bookmarks" "Bookmarks.old"
  echo Bookmarks renamed successfully.
) else (
  echo Bookmarks file not found.
)
if exist "%LocalAppData%\Google\Chrome\User Data\Default\Bookmarks.bak" (
  ren "%LocalAppData%\Google\Chrome\User Data\Default\Bookmarks.bak" "Bookmarks.bak.old"
  echo Bookmarks.bak renamed successfully.
) else (
  echo Bookmarks.bak file not found.
)
pause
```
## Reg
- \HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
- \HKEY_USERS\S-1-5-19\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2 // Use to find mapped/mounted drives on PC
- HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon // Use to edit/create log in accounts (auto login user)
-- UserName
-- Password
-- AutoAdminLogon
-- ForceAutoLogon
- HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations
In WinStations registry key, create a DWORD (32-bit) value IgnoreClientDesktopScaleFactor 
- \HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\ProfileList
