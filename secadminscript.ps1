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
$LinksTable.RowCount = 4
$LinksTable.ColumnCount = 3

# Add links to the table
$LinksTable.Controls.Add((New-Object System.Windows.Forms.LinkLabel -Property @{Text = "AD Manager"; Dock = 'Fill'}), 0, 0)
$LinksTable.Controls.Add((New-Object System.Windows.Forms.LinkLabel -Property @{Text = "Routing Chart"; Dock = 'Fill'}), 1, 0)
$LinksTable.Controls.Add((New-Object System.Windows.Forms.LinkLabel -Property @{Text = "Sailpoint"; Dock = 'Fill'}), 2, 0)
$LinksTable.Controls.Add((New-Object System.Windows.Forms.LinkLabel -Property @{Text = "AirWatch"; Dock = 'Fill'}), 0, 1)
$LinksTable.Controls.Add((New-Object System.Windows.Forms.LinkLabel -Property @{Text = "Duo Security"; Dock = 'Fill'}), 1, 1)
$LinksTable.Controls.Add((New-Object System.Windows.Forms.LinkLabel -Property @{Text = "Citrix Director"; Dock = 'Fill'}), 2, 1)
$LinksTable.Controls.Add((New-Object System.Windows.Forms.LinkLabel -Property @{Text = "VPN Logout"; Dock = 'Fill'}), 0, 2)
$LinksTable.Controls.Add((New-Object System.Windows.Forms.LinkLabel -Property @{Text = "Peoplesoft HCM"; Dock = 'Fill'}), 1, 2)

# Set the hyperlinks
$LinksTable.Controls[0, 0].LinkBehavior = "AlwaysUnderline"
$LinksTable.Controls[0, 0].LinkColor = [System.Drawing.Color]::Blue
$LinksTable.Controls[0, 0].Font = New-Object System.Drawing.Font($LinksTable.Controls[0, 0].Font, [System.Drawing.FontStyle]::Underline)
$LinksTable.Controls[0, 0].Add_Click({ [System.Diagnostics.Process]::Start("https://adm.nyumc.org:8443/") })

$LinksTable.Controls[1, 0].LinkBehavior = "AlwaysUnderline"
$LinksTable.Controls[1, 0].LinkColor = [System.Drawing.Color]::Blue
$LinksTable.Controls[1, 0].Font = New-Object System.Drawing.Font($LinksTable.Controls[1, 0].Font, [System.Drawing.FontStyle]::Underline)
$LinksTable.Controls[1, 0].Add_Click({ [System.Diagnostics.Process]::Start("https://servicecatalog.nyumc.org/DesksideRouting/Pages/RoutingChart.aspx") })

$LinksTable.Controls[2, 0].LinkBehavior = "AlwaysUnderline"
$LinksTable.Controls[2, 0].LinkColor = [System.Drawing.Color]::Blue
$LinksTable.Controls[2, 0].Font = New-Object System.Drawing.Font($LinksTable.Controls[2, 0].Font, [System.Drawing.FontStyle]::Underline)
$LinksTable.Controls[2, 0].Add_Click({ [System.Diagnostics.Process]::Start("https://identity.nyumc.org") })

$LinksTable.Controls[0, 1].LinkBehavior = "AlwaysUnderline"
$LinksTable.Controls[0, 1].LinkColor = [System.Drawing.Color]::Blue
$LinksTable.Controls[0, 1].Font = New-Object System.Drawing.Font($LinksTable.Controls[0, 1].Font, [System.Drawing.FontStyle]::Underline)
$LinksTable.Controls[0, 1].Add_Click({ [System.Diagnostics.Process]::Start("https://aw.nyumc.org/AirWatch") })

$LinksTable.Controls[1, 1].LinkBehavior = "AlwaysUnderline"
$LinksTable.Controls[1, 1].LinkColor = [System.Drawing.Color]::Blue
$LinksTable.Controls[1, 1].Font = New-Object System.Drawing.Font($LinksTable.Controls[1, 1].Font, [System.Drawing.FontStyle]::Underline)
$LinksTable.Controls[1, 1].Add_Click({ [System.Diagnostics.Process]::Start("https://admin-a5409281.duosecurity.com") })

$LinksTable.Controls[2, 1].LinkBehavior = "AlwaysUnderline"
$LinksTable.Controls[2, 1].LinkColor = [System.Drawing.Color]::Blue
$LinksTable.Controls[2, 1].Font = New-Object System.Drawing.Font($LinksTable.Controls[2, 1].Font, [System.Drawing.FontStyle]::Underline)
$LinksTable.Controls[2, 1].Add_Click({ [System.Diagnostics.Process]::Start("https://ctxcdcpdirxd001.nyumc.org/Director") })

$LinksTable.Controls[0, 2].LinkBehavior = "AlwaysUnderline"
$LinksTable.Controls[0, 2].LinkColor = [System.Drawing.Color]::Blue
$LinksTable.Controls[0, 2].Font = New-Object System.Drawing.Font($LinksTable.Controls[0, 2].Font, [System.Drawing.FontStyle]::Underline)
$LinksTable.Controls[0, 2].Add_Click({ [System.Diagnostics.Process]::Start("https://vpn-termination.nyumc.org") })

$LinksTable.Controls[1, 2].LinkBehavior = "AlwaysUnderline"
$LinksTable.Controls[1, 2].LinkColor = [System.Drawing.Color]::Blue
$LinksTable.Controls[1, 2].Font = New-Object System.Drawing.Font($LinksTable.Controls[1, 2].Font, [System.Drawing.FontStyle]::Underline)
$LinksTable.Controls[1, 2].Add_Click({ [System.Diagnostics.Process]::Start("https://peoplesofthcm.nyumc.org/psc/hrprod/EMPLOYEE/HRMS/c/NUI_FRAMEWORK.PT_LANDINGPAGE.GBL?NPSLT=Y") })

# Add the table to the Links tab
$LinksTab.Controls.Add($LinksTable)

# Add the Links tab to the tab control
$TabControl.TabPages.Add($LinksTab)

# Create "AD" tab
$ADTab = New-Object System.Windows.Forms.TabPage
$ADTab.Text = "AD"

# Add the AD tab to the tab control
$TabControl.TabPages.Add($ADTab)

# Add the tab control to the form
$Form.Controls.Add($TabControl)

# Show the form
$Form.ShowDialog()
