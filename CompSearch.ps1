Import-Module ActiveDirectory
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#Region Functions
Function SearchAssetTag ($Asset) {
    If ($Asset -Match "^\d{6}$") {
        $Computer = Get-ADComputer -Filter ('Name -Like "*'+ $Asset +'*"')
        return $Computer
    }
    Else {
        return 'No Computer Found'
    }
    
}
#EndRegion 
#Region UI
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Active Directory Computer Search"
$Form.StartPosition = 'CenterScreen'
$Form.ClientSize = '225, 150'

$SearchBase = New-Object System.Windows.Forms.ComboBox
$SearchBase.Text = "Search Filter"
$SearchBase.AutoSize = $True
$SearchBase.Location = New-Object System.Drawing.Point(20, 15)
$SearchBase.Items.AddRange(@('Asset Tag #', 'Building', 'Room', 'OU'))  

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

$Form.Controls.AddRange(@($SearchBase, $SearchField, $SearchButton, $ComputerInfo))
#EndRegion
#Region UI Events
$SearchButton.Add_Click({
    If ($SearchBase.Text -eq 'Asset Tag #') {
        $Info = SearchAssetTag -Asset $SearchField.Text
        try {
            $ComputerInfo.Text = $Info.toString().split(',')
        }
        catch {
            $ComputerInfo.Text = 'Computer cannot be found'
        }
    }

})

[void]$Form.ShowDialog()