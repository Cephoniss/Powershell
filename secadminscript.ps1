Add-Type -AssemblyName System.Windows.Forms

# Create the main form
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "PowerShell GUI"
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


# Create "AD" tab
$ADTab = New-Object System.Windows.Forms.TabPage
$ADTab.Text = "AD"

# Create labels for search boxes
$KIDLabel = New-Object System.Windows.Forms.Label
$KIDLabel.Text = "KID:"
$KIDLabel.Location = New-Object System.Drawing.Point(10, 10)
$KIDLabel.AutoSize = $true

$ADGroupLabel = New-Object System.Windows.Forms.Label
$ADGroupLabel.Text = "AD Group:"
$ADGroupLabel.Location = New-Object System.Drawing.Point(10, 40)
$ADGroupLabel.AutoSize = $true

# Create text boxes for search inputs
$KIDTextBox = New-Object System.Windows.Forms.TextBox
$KIDTextBox.Location = New-Object System.Drawing.Point(80, 10)
$KIDTextBox.Size = New-Object System.Drawing.Size(200, 20)

$ADGroupTextBox = New-Object System.Windows.Forms.TextBox
$ADGroupTextBox.Location = New-Object System.Drawing.Point(80, 40)
$ADGroupTextBox.Size = New-Object System.Drawing.Size(200, 20)

# Create button for executing the search
$SearchButton = New-Object System.Windows.Forms.Button
$SearchButton.Text = "Search"
$SearchButton.Location = New-Object System.Drawing.Point(300, 35)
$SearchButton.Add_Click({
    $KID = $KIDTextBox.Text
    $ADGroup = $ADGroupTextBox.Text
    
    # Perform wildcard search if AD Group is empty
    if ([string]::IsNullOrEmpty($ADGroup)) {
        $ADGroup = "*"
    }
    
    $user = Get-ADUser -Identity $KID -Properties MemberOf
    if ($user) {
        $memberOf = $user.MemberOf |
            Get-ADGroup |
            Where-Object { $_.Name -like "*$ADGroup*" } |
            Select-Object -ExpandProperty Name |
            Sort-Object

        # Clear the text box before displaying the result
        $ResultTextBox.Clear()

        # Append each search result to a new line in the text box
        if ($memberOf) {
            $ResultTextBox.AppendText($memberOf -join "`r`n")
        } else {
            $ResultTextBox.AppendText("No results found.")
        }
    } else {
        $ResultTextBox.AppendText("User not found.")
    }
})

# Create multi-line text box for displaying the search result
$ResultTextBox = New-Object System.Windows.Forms.TextBox
$ResultTextBox.Multiline = $true
$ResultTextBox.Location = New-Object System.Drawing.Point(10, 70)
$ResultTextBox.Size = New-Object System.Drawing.Size(480, 200)
$ResultTextBox.ScrollBars = "Vertical"

# Add controls to the AD tab
$ADTab.Controls.Add($KIDLabel)
$ADTab.Controls.Add($KIDTextBox)
$ADTab.Controls.Add($ADGroupLabel)
$ADTab.Controls.Add($ADGroupTextBox)
$ADTab.Controls.Add($SearchButton)
$ADTab.Controls.Add($ResultTextBox)

# Add the AD tab to the tab control
$TabControl.TabPages.Add($ADTab)

# Add the tab control to the form
$Form.Controls.Add($TabControl)

# Show the form
$Form.ShowDialog()
