using namespace System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#
# 画面サイズ関係
#
$xWid = 280
$xinWid = $xWid - 40
$xHei = 455
$xinHei = $xHei - 150
$bottom1 = $xHei - 65
$bottom2 = $xHei - 145

$script:orgBkup = ""

$objForm = New-Object Form -Property @{
    Text = "Select Item"
    Size = New-Object System.Drawing.Size($xWid, $xHei)
    StartPosition = "manual"
}

#
# リストDATAの読み込み
#
$utl_hash = @{}
$csv_data = Import-Csv .\xx_utl_data.csv -Encoding UTF8
foreach ($item in $csv_data) {
  $utl_hash[$item.key] = $item.value
}

$objListBox = New-Object ListBox -Property @{
    Location = New-Object System.Drawing.Point(10,0)
    Size = New-Object System.Drawing.Size($xinWid, $xinHei)
}
$objForm.Controls.Add($objListBox)
$objListBox.Add_Click({UppClip})

foreach ($key in $utl_hash.Keys) {
  [void] $objListBox.Items.Add($key)
}

function SetColorTxt {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [System.Windows.Forms.RichTextBox]$box,
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$text
    )
    $box.Text = ""
    $SplitStr = $text -split "{}"
    if ($SplitStr.Length -gt 1) {
      $box.AppendText($SplitStr[0])
      foreach ($SStr in $SplitStr[1..($SplitStr.Length -1)]) {
        $box.SelectionStart = $box.TextLength
        $box.SelectionLength = 0
        $box.SelectionColor = [System.Drawing.Color]::Red
        $box.AppendText("{}")
        $box.SelectionColor = $box.ForeColor;
        $box.AppendText($SStr)
      }
    } else {
      $box.AppendText($text)
    }
}

$setTextBox = New-Object RichTextBox -Property @{
    Location = New-Object System.Drawing.Point(10, $bottom2)
    Size = New-Object System.Drawing.Size($xinWid, 75)
}
$objForm.Controls.Add($setTextBox)

function UppClip {
    $hashKey = $objListBox.SelectedItem
    $script:orgBkup = $utl_hash[$hashKey]
    if ($script:orgBkup -ne $null) {
      SetColorTxt $setTextBox $script:orgBkup  
      Set-Clipboard -value $script:orgBkup
    }
}

$swpTextBox = New-Object TextBox -Property @{
    Location = New-Object System.Drawing.Point(10, $bottom1)
    Size = New-Object System.Drawing.Size(160,20)
}
$objForm.Controls.Add($swpTextBox)


$swpButton = New-Object Button -Property @{
    Location = New-Object System.Drawing.Size(180, $bottom1)
    Size = New-Object System.Drawing.Size(77,20)
    Text = "set(swap)"
}
$swpButton.Add_Click({SwapClip $swpTextBox.text})
$objForm.AcceptButton = $swpButton
$objForm.Controls.Add($swpButton)

function SwapClip($str) {
    $newclp = $script:orgBkup -replace "{}", $str  
    $setTextBox.Text = $newclp
    Set-Clipboard -value $newclp
}

$objForm.Topmost = $True
$objForm.Add_Shown({$objForm.Activate()})
$result = $objForm.ShowDialog()


