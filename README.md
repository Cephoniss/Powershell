# For Work
## Reg
- \HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
- \HKEY_USERS\S-1-5-19\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2 // Use to find mapped/mounted drives on PC
- HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon // Use to edit/create log in accounts (auto login user)
-- UserName
-- Password
-- AutoAdminLogon
-- ForceAutoLogon
## Powershell
- invoke-command -cn HOSTNAME -scriptblock {quser} // To see logged on users
- invoke-Command -ScriptBlock { logoff # } // To log out user
- -cn HOSTNAME  // To run on remote device
- enter-pssession // To enter powershell session on remote device
- Get-WmiObject win32_computersystem // To pull system info
- Get-WmiObject win32_bios // To pull serial and BIOS info
- Get-WMIObject -class Win32_PhysicalMemory // To pull RAM info
- Get-wmiobject win32_diskdrive // To pull Drive info
- Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' |format-list  ReleaseId // To get windows version can also use winver
- manage-bde –status // To get Encryption status
- get-process
