Import-Module ActiveDirectory
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#Region Functions
Function SearchAD ($Asset) {
    if ($Asset -Match "^\d{6}$") {
        $Computer = Get-ADComputer -Filter ('Name -Like "*{0}*"' -f $Asset)
    }
    return $Computer
}
#EndRegion 
#Region UI
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Active Directory Computer Search"
$Form.StartPosition = 'CenterScreen'
$Form.ClientSize = '225, 150'

$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Search device asset tag:"
$Label.AutoSize = $True
$Label.Location = New-Object System.Drawing.Point(20, 20)

$SearchField = New-Object System.Windows.Forms.TextBox
$SearchField.Text = ""
$SearchField.Location = New-Object System.Drawing.Point(20, 42)

$SearchButton = New-Object System.Windows.Forms.Button
$SearchButton.Text = "Search"
$SearchButton.AutoSize = $True
$SearchButton.Location = New-Object System.Drawing.Point(125, 40)

$ComputerInfo = New-Object System.Windows.Forms.TextBox
$ComputerInfo.Text = ""
$ComputerInfo.Multiline = $True
$ComputerInfo.ScrollBars = 'Both'
$ComputerInfo.Size = New-Object System.Drawing.Point(180, 65)
$ComputerInfo.Location = New-Object System.Drawing.Point(20, 75)

$Form.Controls.AddRange(@($Label, $SearchField, $SearchButton, $ComputerInfo))
#EndRegion
#Region UI Events
$SearchButton.Add_Click({
    $Info = SearchAD -Asset $SearchField.Text
    $Info = $Info.toString().split(',')
    ForEach ($_ in $Info) {
        $ComputerInfo.Text += $_ + [System.Environment]::NewLine
    }
})

[void]$Form.ShowDialog()