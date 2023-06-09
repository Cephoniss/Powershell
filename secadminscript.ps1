Add-Type -AssemblyName System.Windows.Forms

# Create the main form
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "AD Tool"
$Form.Size = New-Object System.Drawing.Size(500, 400)

# Create tab control
$TabControl = New-Object System.Windows.Forms.TabControl
$TabControl.Size = New-Object System.Drawing.Size(480, 340)
$TabControl.Location = New-Object System.Drawing.Point(10, 10)

# Create "Links" tab
$LinksTab = New-Object System.Windows.Forms.TabPage
$LinksTab.Text = "Links"

# Create table layout panel for links
$LinksTable = New-Object System.Windows.Forms.TableLayoutPanel
$LinksTable.RowCount = 3
$LinksTable.ColumnCount = 3

# Add links to the table
$Links = @(
    "AD Manager", "https://adm.nyumc.org:8443/",
    "Routing Chart", "https://servicecatalog.nyumc.org/DesksideRouting/Pages/RoutingChart.aspx",
    "Sailpoint", "https://identity.nyumc.org",
    "AirWatch", "https://aw.nyumc.org/AirWatch",
    "Duo Security", "https://admin-a5409281.duosecurity.com",
    "Citrix Director", "https://ctxcdcpdirxd001.nyumc.org/Director",
    "VPN Logout", "https://vpn-termination.nyumc.org",
    "Peoplesoft HCM", "https://peoplesofthcm.nyumc.org/psc/hrprod/EMPLOYEE/HRMS/c/NUI_FRAMEWORK.PT_LANDINGPAGE.GBL?NPSLT=Y"
)

for ($i = 0; $i -lt $Links.Count; $i += 2) {
    $linkLabel = New-Object System.Windows.Forms.LinkLabel
    $linkLabel.Text = $Links[$i]
    $linkLabel.Dock = 'Fill'
    $linkLabel.LinkBehavior = "AlwaysUnderline"
    $linkLabel.LinkColor = [System.Drawing.Color]::Blue
    $linkLabel.Font = New-Object System.Drawing.Font($linkLabel.Font, [System.Drawing.FontStyle]::Underline)
    $linkLabel.Tag = $Links[$i + 1]
    $linkLabel.Add_Click({
        $url = $this.Tag.ToString()
        [System.Diagnostics.Process]::Start($url)
    })

    $LinksTable.Controls.Add($linkLabel, $i / 2, 0)
}

# Add the table to the Links tab
$LinksTab.Controls.Add($LinksTable)

# Add the Links tab to the tab control
$TabControl.TabPages.Add($LinksTab)


# Create "Search" tab
$SearchTab = New-Object System.Windows.Forms.TabPage
$SearchTab.Text = "Search"

# Create label for search type
$SearchTypeLabel = New-Object System.Windows.Forms.Label
$SearchTypeLabel.Text = "Search Type:"
$SearchTypeLabel.Location = New-Object System.Drawing.Point(10, 10)
$SearchTypeLabel.AutoSize = $true

# Create radio button for searching users
$SearchUsersRadioButton = New-Object System.Windows.Forms.RadioButton
$SearchUsersRadioButton.Text = "Search Users"
$SearchUsersRadioButton.Location = New-Object System.Drawing.Point(80, 10)
$SearchUsersRadioButton.Checked = $true

# Create radio button for searching groups
$SearchGroupsRadioButton = New-Object System.Windows.Forms.RadioButton
$SearchGroupsRadioButton.Text = "Search Groups"
$SearchGroupsRadioButton.Location = New-Object System.Drawing.Point(180, 10)

# Create label for search keyword
$SearchKeywordLabel = New-Object System.Windows.Forms.Label
$SearchKeywordLabel.Text = "Keyword:"
$SearchKeywordLabel.Location = New-Object System.Drawing.Point(10, 40)
$SearchKeywordLabel.AutoSize = $true

# Create text box for search keyword input
$SearchKeywordTextBox = New-Object System.Windows.Forms.TextBox
$SearchKeywordTextBox.Location = New-Object System.Drawing.Point(80, 40)
$SearchKeywordTextBox.Size = New-Object System.Drawing.Size(200, 20)

# Create button for executing the search
$SearchButton = New-Object System.Windows.Forms.Button
$SearchButton.Text = "Search"
$SearchButton.Location = New-Object System.Drawing.Point(300, 35)
$SearchButton.Add_Click({
    $keyword = $SearchKeywordTextBox.Text
    $searchType = if ($SearchUsersRadioButton.Checked) { "Users" } else { "Groups" }
    
    if ([string]::IsNullOrEmpty($keyword)) {
        $SearchResultTextBox.Clear()
        $SearchResultTextBox.AppendText("Please enter a $searchType keyword.")
        return
    }
    
    $SearchResultTextBox.Clear()
    
    if ($SearchUsersRadioButton.Checked) {
        $userFilter = "SamAccountName -eq '$keyword'"
        $users = Get-ADUser -Filter $userFilter -Properties MemberOf
        
        if ([string]::IsNullOrEmpty($users)) {
            $SearchResultTextBox.AppendText("No users found.")
        } else {
            foreach ($user in $users | Sort-Object -Property SamAccountName) {
                $groups = $user.MemberOf | ForEach-Object { Get-ADGroup -Identity $_ }
                
                if ($groups) {
                    $SearchResultTextBox.AppendText("User: $($user.SamAccountName)`r`n")
                    $SearchResultTextBox.AppendText("Group Memberships:`r`n")
                    foreach ($group in $groups | Sort-Object -Property Name) {
                        $SearchResultTextBox.AppendText("$($group.Name)`r`n")
                    }
                    $SearchResultTextBox.AppendText("`r`n")
                } else {
                    $SearchResultTextBox.AppendText("User: $($user.SamAccountName)`r`nNo group memberships found.`r`n`r`n")
                }
            }
        }
    } else {
        $groups = Get-ADGroup -Filter "Name -like '*$keyword*'"
        
        if ([string]::IsNullOrEmpty($groups)) {
            $SearchResultTextBox.AppendText("No groups found.")
        } else {
            foreach ($group in $groups | Sort-Object -Property Name) {
                $members = Get-ADGroupMember -Identity $group -Recursive | Where-Object { $_.objectClass -eq 'user' }
                
                if ($members) {
                    $SearchResultTextBox.AppendText("Group: $($group.Name)`r`n")
                    $SearchResultTextBox.AppendText("Members:`r`n")
                    foreach ($member in $members | Sort-Object -Property SamAccountName) {
                        $SearchResultTextBox.AppendText("$($member.SamAccountName)`r`n")
                    }
                    $SearchResultTextBox.AppendText("`r`n")
                } else {
                    $SearchResultTextBox.AppendText("Group: $($group.Name)`r`nNo members found.`r`n`r`n")
                }
            }
        }
    }
})

# Create text box for displaying search results
$SearchResultTextBox = New-Object System.Windows.Forms.TextBox
$SearchResultTextBox.Location = New-Object System.Drawing.Point(10, 70)
$SearchResultTextBox.Size = New-Object System.Drawing.Size(480, 180)
$SearchResultTextBox.Multiline = $true
$SearchResultTextBox.ScrollBars = "Vertical"
$SearchResultTextBox.ReadOnly = $true

# Add controls to the Search tab
$SearchTab.Controls.Add($SearchTypeLabel)
$SearchTab.Controls.Add($SearchUsersRadioButton)
$SearchTab.Controls.Add($SearchGroupsRadioButton)
$SearchTab.Controls.Add($SearchKeywordLabel)
$SearchTab.Controls.Add($SearchKeywordTextBox)
$SearchTab.Controls.Add($SearchButton)
$SearchTab.Controls.Add($SearchResultTextBox)

# Create the tab for exporting search results to CSV
$ExportTab = New-Object System.Windows.Forms.TabPage
$ExportTab.Text = "Export"

# Create label for export type
$ExportTypeLabel = New-Object System.Windows.Forms.Label
$ExportTypeLabel.Text = "Export Type:"
$ExportTypeLabel.Location = New-Object System.Drawing.Point(10, 10)
$ExportTypeLabel.AutoSize = $true


# Create button for exporting search results to CSV
$ExportButton = New-Object System.Windows.Forms.Button
$ExportButton.Text = "Export"
$ExportButton.Location = New-Object System.Drawing.Point(300, 35)
$ExportButton.Add_Click({
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.Filter = "CSV (*.csv)|*.csv"
    $saveFileDialog.Title = "Export Search Results"
    
    if ($saveFileDialog.ShowDialog() -eq "OK") {
        $filePath = $saveFileDialog.FileName
        
        if ([string]::IsNullOrEmpty($SearchResultTextBox.Text)) {
            [System.Windows.Forms.MessageBox]::Show("No results to export.", "Export Search Results", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            return
        }
        
        $exportData = $SearchResultTextBox.Lines[2..($SearchResultTextBox.Lines.Count - 1)] | ForEach-Object { [PSCustomObject]@{ name = $_ } }
        $exportData | Export-Csv -Path $filePath -NoTypeInformation -Encoding UTF8
        
        [System.Windows.Forms.MessageBox]::Show("Search results exported successfully.", "Export Search Results", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
})

# Add controls to the Export tab
$ExportTab.Controls.Add($ExportTypeLabel)
$ExportTab.Controls.Add($ExportButton)

# Add tabs to the tab control
$TabControl.Controls.Add($SearchTab)
$TabControl.Controls.Add($ExportTab)

# Add the tab control to the form
$Form.Controls.Add($TabControl)



# Create "Computers" tab
$ComputersTab = New-Object System.Windows.Forms.TabPage
$ComputersTab.Text = "Computers"

# Create label for computer search box
$ComputerLabel = New-Object System.Windows.Forms.Label
$ComputerLabel.Text = "Computer Name:"
$ComputerLabel.Location = New-Object System.Drawing.Point(10, 10)
$ComputerLabel.AutoSize = $true

# Create text box for computer search input
$ComputerTextBox = New-Object System.Windows.Forms.TextBox
$ComputerTextBox.Location = New-Object System.Drawing.Point(120, 10)
$ComputerTextBox.Size = New-Object System.Drawing.Size(200, 20)

# Create button for executing the computer search
$ComputerSearchButton = New-Object System.Windows.Forms.Button
$ComputerSearchButton.Text = "Search"
$ComputerSearchButton.Location = New-Object System.Drawing.Point(340, 5)
$ComputerSearchButton.Add_Click({
    $ComputerName = $ComputerTextBox.Text

    # Clear the text box before displaying the result
    $ComputerResultTextBox.Clear()

    if ($ComputerName) {
        try {
            $systemInfo = Get-WmiObject Win32_ComputerSystem -ComputerName $ComputerName
            $biosInfo = Get-WmiObject Win32_BIOS -ComputerName $ComputerName
            $memoryInfo = Get-WmiObject Win32_PhysicalMemory -ComputerName $ComputerName
            $diskDriveInfo = Get-WmiObject Win32_DiskDrive -ComputerName $ComputerName
            $videoControllerInfo = Get-WmiObject Win32_VideoController -ComputerName $ComputerName

            if (!$systemInfo -or !$biosInfo -or !$memoryInfo -or !$diskDriveInfo -or !$videoControllerInfo) {
                $ComputerResultTextBox.AppendText("No computer found with the name: $ComputerName")
                return
            }

            $ComputerResultTextBox.AppendText("System Information for $ComputerName`r`n`r`n")
            $ComputerResultTextBox.AppendText("Manufacturer: " + $systemInfo.Manufacturer + "`r`n")
            $ComputerResultTextBox.AppendText("Model: " + $systemInfo.Model + "`r`n")
            $ComputerResultTextBox.AppendText("BIOS Version: " + $biosInfo.SMBIOSBIOSVersion + "`r`n`r`n")
            $ComputerResultTextBox.AppendText("Memory Information:`r`n")
            $memoryInfo | ForEach-Object {
                $ComputerResultTextBox.AppendText("Capacity: " + ($_ | Select-Object -ExpandProperty Capacity) + " bytes`r`n")
            }
            $ComputerResultTextBox.AppendText("`r`nDisk Drive Information:`r`n")
            $diskDriveInfo | ForEach-Object {
                $ComputerResultTextBox.AppendText("Model: " + $_.Model + "`r`n")
            }
            $ComputerResultTextBox.AppendText("`r`nVideo Controller Information:`r`n")
            $videoControllerInfo | ForEach-Object {
                $ComputerResultTextBox.AppendText("Name: " + $_.Name + "`r`n")
            }
        }
        catch {
            $ComputerResultTextBox.AppendText("Error: $_.Exception.Message")
        }
    } else {
        $ComputerResultTextBox.AppendText("Please enter a computer name.")
    }
})

# Create multi-line text box for displaying the computer search result
$ComputerResultTextBox = New-Object System.Windows.Forms.TextBox
$ComputerResultTextBox.Multiline = $true
$ComputerResultTextBox.Location = New-Object System.Drawing.Point(10, 40)
$ComputerResultTextBox.Size = New-Object System.Drawing.Size(480, 230)
$ComputerResultTextBox.ScrollBars = "Vertical"
$ComputerResultTextBox.ReadOnly = $true

# Add controls to the Computers tab
$ComputersTab.Controls.Add($ComputerLabel)
$ComputersTab.Controls.Add($ComputerTextBox)
$ComputersTab.Controls.Add($ComputerSearchButton)
$ComputersTab.Controls.Add($ComputerResultTextBox)

# Add the Computers tab to the tab control
$TabControl.TabPages.Add($ComputersTab)

# Add the tab control to the form
$Form.Controls.Add($TabControl)

# Show the form
$Form.ShowDialog()
