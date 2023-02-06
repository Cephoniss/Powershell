[System.Reflection.Assembly]::LoadWithPartialName("System.Management.Automation") | Out-Null

function GetSystemInfo($computerhostname) {
    $ps = [PowerShell]::Create()
    $ps.AddScript("Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computerhostname")
    $results = $ps.Invoke()
    Write-Host "System Information: "
    $results
    ShowSelectionMenu $computerhostname
}

function GetBiosInfo($computerhostname) {
    $ps = [PowerShell]::Create()
    $ps.AddScript("Get-WmiObject -Class Win32_BIOS -ComputerName $computerhostname")
    $results = $ps.Invoke()
    Write-Host "BIOS Information: "
    $results
    ShowSelectionMenu $computerhostname
}

function GetRamInfo($computerhostname) {
    $ps = [PowerShell]::Create()
    $ps.AddScript("Get-WmiObject -Class Win32_PhysicalMemory -ComputerName $computerhostname")
    $results = $ps.Invoke()
    Write-Host "RAM Information: "
    $results
    ShowSelectionMenu $computerhostname
}

function GetDriveInfo($computerhostname) {
    $ps = [PowerShell]::Create()
    $ps.AddScript("Get-WmiObject -Class Win32_DiskDrive -ComputerName $computerhostname")
    $results = $ps.Invoke()
    Write-Host "Drive Information: "
    $results
    ShowSelectionMenu $computerhostname
}

function ShowSelectionMenu($computerhostname) {
    Write-Host "Select an option: "
    Write-Host "1. System Information"
    Write-Host "2. BIOS Information"
    Write-Host "3. RAM Information"
    Write-Host "4. Drive Information"
    Write-Host "5. Exit"
    Write-Host "Enter your choice (1-5): "

    $choice = Read-Host

    switch ($choice) {
        "1" {GetSystemInfo $computerhostname}
        "2" {GetBiosInfo $computerhostname}
        "3" {GetRamInfo $computerhostname}
        "4" {GetDriveInfo $computerhostname}
        "5" {Write-Host "Exiting the script."; return}
        default {Write-Host "Invalid choice. Try again."; ShowSelectionMenu $computerhostname}
    }
}

Write-Host "Enter hostname: "
$computerhostname = Read-Host
ShowSelectionMenu $computerhostname
