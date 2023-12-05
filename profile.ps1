#
# function ���ŏ��ɓo�^���Ă����āA���ł��g����悤�ɂ���B
# �ȒP�Ȑ����� hashtable �ɂ��āA�\������B
#
$manhash = @{}

$manhash["tsvInsert"] = @"
tsv�̃f�[�^���� INSERT �����쐬���Ė߂�(�i���Łj
 - table_name �͈���2�ڂœn��
 - TSV1�s�ځi�񖼁j�́@#�t����NUMBER�Ƃ��āu"�v�ɂ��N�I�[�g���s��Ȃ��B
 - TSV1�s�ځi�񖼁j�́@$�t����DATE�Ƃ��āAYYYY/MM/DD hh:mm:ss ��
   �㔼�����i���ԁj���J�b�g����B
 - ���g�̖����s��INSERT���͍��Ȃ��B
"@
function tsvInsert($tsv, $tblN) {
  $lines = $tsv -split "`n" 
  $firstLine = $lines[0]
  $flDates = $firstLine -split "`t"

  $headStr = "INSERT INTO " + $tblN + "`n("
  $isNums = @() 
  $isDate = @()
  foreach ($item in $flDates) {
    $isNums += $item.Contains("`#")
    $isDate += $item.Contains("$")
    $headStr = $headStr + $item.Replace("`#","").Replace("$","") + ","
  }
  $headStr = $headStr.Substring(0, $headStr.Length - 1)    # �]�v��","���폜
  $headStr = $headStr + ")`n"

  $insertSql = ""
  foreach ($line in $lines[1..($lines.Length - 1)]) {
    $datas = $line -split "`t"
    if($datas[0] -ne "") {
      $insertSql = $insertSql + $headStr + "VALUES`n("
      for ($i = 0; $i -lt $datas.Count; $i++) {
        if($datas[$i] -eq "") {
          $insertSql = $insertSql + "NULL,"
        } elseif($isNums[$i]) {
          $insertSql = $insertSql + $datas[$i] + ","
        } elseif($isDate[$i]) {
          $darr = $datas[$i].split(" ")
          $insertSql = $insertSql + "'" + $darr[0] + "',"
        } else { 
          $insertSql = $insertSql + "'" + $datas[$i] + "',"
        }
      }
      $insertSql = $insertSql.Substring(0, $insertSql.Length - 1)    # �]�v��","���폜
      $insertSql = $insertSql + ");`n"
    }
  }
  return($insertSql)
}

$manhash["clipTsvInsert"] = @"
tsv �̃f�[�^���N���b�v�{�[�h����ǂݍ����
 INSERT ���Ŗ߂�
   tsv�̂P�s�ڂ̓J���������X�g�Ƃ��Ďg�p����
   tsvInsert �𗘗p����
   table_name �͈����œn��
"@
function clipTsvInsert ($tableName){
  $clp = Get-Clipboard -Format Text
  $newclp = tsvInsert $clp $tableName
  Set-Clipboard -value $newclp
}



$manhash["tsvQt"] = @"
tsv�̃f�[�^�e���ڂ��u'�v�ŃN�H�[�g����csv�Ŗ߂�
"@
function tsvQt($tsv) {
  $newCsv = ""
  $lines = $tsv -split "`r`n"
  foreach ($line in $lines) {
    $datas = $line -split "`t"
    foreach ($item in $datas) { $newCsv = $newCsv + "'" + $item + "'," }
    $newCsv = $newCsv.Substring(0, $newCsv.Length - 1)    # �]�v��","���폜
    $newCsv = $newCsv + "`r`n"
  }
  return($newCsv)
}

$manhash["clipTsvQt"] = @"
tsv �̃f�[�^���N���b�v�{�[�h����ǂݍ���� �e���ڂ��u'�v�ŃN�H�[�g����csv�Ŗ߂�
  tsvQt �𗘗p����
"@
function clipTsvQt {
  $clp = Get-Clipboard -Format Text
  $newclp = tsvQt $clp
  Set-Clipboard -value $newclp
}

$manhash["c2t"] = @"
csv�̃f�[�^�e���ڂ�tsv�ɂ��Ė߂�
 �����Fcsv ������
"@
function c2t($csv) {
  $tsv = ""
  $lines = $csv -split "`r`n"
  foreach ($line in $lines) {
    $datas = $line -split ","
    foreach ($item in $datas) { $tsv = $tsv + $item + "`t" }
    $tsv = $tsv.Substring(0, $tsv.Length - 1)    # �]�v��"`t"���폜
    $tsv = $tsv + "`r`n"
  }
  return($tsv)
}

$manhash["clipc2t"] = @"
csv �̃f�[�^���N���b�v�{�[�h����ǂݍ���� tsv �ɂ��Ė߂�
  c2t �𗘗p����
"@
function clipc2t {
  $clp = Get-Clipboard -Format Text
  $newclp = c2t $clp
  Set-Clipboard -value $newclp
}

$manhash["csvQt"] = @"
csv�̃f�[�^�e���ڂ��u'�v�ŃN�H�[�g���Ė߂�
"@
function csvQt($csv) {
  $newCsv = ""
  $lines = $csv -split "`r`n"
  foreach ($line in $lines) {
    $datas = $line -split ","
    foreach ($item in $datas) { $newCsv = $newCsv + "'" + $item + "'," }
    $newCsv = $newCsv.Substring(0, $newCsv.Length - 1)    # �]�v��","���폜
    $newCsv = $newCsv + "`r`n"
  }
  return($newCsv)
}

$manhash["clipcsvQt"] = @"
csv �̃f�[�^���N���b�v�{�[�h����ǂݍ���� �e���ڂ��u'�v�ŃN�H�[�g���Ė߂�
  csvQt �𗘗p����
"@
function clipcsvQt {
  $clp = Get-Clipboard -Format Text
  $newclp = csvQt $clp
  Set-Clipboard -value $newclp
}

$manhash["clCsv"] = @"
tsv �̃f�[�^���N���b�v�{�[�h����ǂݍ���� �N�H�[�g���Ȃ��� csv �Ŗ߂�
"@
function clCsv {
  $clp = Get-Clipboard -Format Text
  $datas = $clp -split "`t"
  $newclp = ""
  foreach ($item in $datas) { $newclp = $newclp + $item + "," }
  $newclp = $newclp.Substring(0, $newclp.Length - 1)
  Set-Clipboard -value $newclp
}

$manhash["clipcsv"] = @"
tsv �̃f�[�^���N���b�v�{�[�h����ǂݍ���� csv �Ŗ߂�
"@
function clipcsv {
  $clp = Get-Clipboard -Format Text
  $datas = $clp -split "`t"
  $newclp = ""
  foreach ($item in $datas) { $newclp = $newclp + "'" + $item + "'," }
  $newclp = $newclp.Substring(0, $newclp.Length - 1)
  Set-Clipboard -value $newclp
}

$manhash["colcsv"] = @"
���s��؂�̃f�[�^���N���b�v�{�[�h����ǂ�� csv �Ŗ߂� 
"@
function colcsv {
  $clp = Get-Clipboard -Format Text
  $datas = $clp -split "`n"
  $newclp = ""
  foreach ($item in $datas) { $newclp = $newclp + "'" + $item + "'," }
  $newclp = $newclp.Substring(0, $newclp.Length - 1)
  Set-Clipboard -value $newclp
}

$manhash["kakkonai"] = @"
�����s�f�[�^���N���b�v�{�[�h����ǂݍ����
 �J�b�R��������߂�
"@
function kakkonai {
  $clp = Get-Clipboard -Format Text
  $datas = $clp -split "`n"
  $newclp = ""
  foreach ($item in $datas) { 
    $m = $item -match "[(�i].*[�j)]"
    $nakami = $Matches[0] -replace "[()�i�j]", ""
    if ($m) {
      $newclp = $newclp + $nakami + "`n" 
    }
  }
  $newclp = $newclp.Substring(0, $newclp.Length - 1)
  Set-Clipboard -value $newclp
}

$manhash["clpupp"] = @"
�������� �f�[�^���N���b�v�{�[�h����ǂݍ���� �啶�� �Ŗ߂�
 lower case -> upper case
"@
function clpupp {
  $clp = Get-Clipboard -Format Text
  $newclp = $clp.ToUpper()
  Set-Clipboard -value $newclp
}

$manhash["clplow"] = @"
�啶���� �f�[�^���N���b�v�{�[�h����ǂݍ���� ������ �Ŗ߂�
 upper case -> lower case
"@
function clplow {
  $clp = Get-Clipboard -Format Text
  $newclp = $clp.ToLower()
  Set-Clipboard -value $newclp
}


$manhash["coll2u"] = @"
���s��؂�̏������f�[�^���N���b�v�{�[�h����ǂ��
 �啶�����s��؂�Ŗ߂� 
"@
function coll2u {
  $clp = Get-Clipboard -Format Text
  $datas = $clp -split "`n"
  $newclp = ""
  foreach ($item in $datas) { $newclp = $newclp + $item.ToUpper() + "`n" }
  $newclp = $newclp.Substring(0, $newclp.Length - 1)
  Set-Clipboard -value $newclp
}


$manhash["colu2l"] = @"
���s��؂�̑啶���f�[�^���N���b�v�{�[�h����ǂ��
 ���������s��؂�Ŗ߂� 
"@
function colu2l {
  $clp = Get-Clipboard -Format Text
  $datas = $clp -split "`n"
  $newclp = ""
  foreach ($item in $datas) { $newclp = $newclp + $item.Tolower() + "`n" }
  $newclp = $newclp.Substring(0, $newclp.Length - 1)
  Set-Clipboard -value $newclp
}


$manhash["colchUL"] = @"
���s��؂�̕����f�[�^���N���b�v�{�[�h����ǂ��
 �啶���������𔻒肵�A���ꂼ�ꔽ�]�����Ė߂� 
"@
function colchUL {
  $clp = Get-Clipboard -Format Text
  $datas = $clp -split "`n"
  $newclp = ""
  foreach ($item in $datas) {
    switch -Regex -CaseSensitive ($item)
    {  
      "^[A-Z].*" {$newclp = $newclp + $item.Tolower() + "`n"; break}
      "^[a-z].*" {$newclp = $newclp + $item.ToUpper() + "`n"; break}
    }
  }
  $newclp = $newclp.Substring(0, $newclp.Length - 1)
  Set-Clipboard -value $newclp
}

$manhash["coldelspc"] = @"
���s��؂�̕����f�[�^���N���b�v�{�[�h����ǂ��
 �󔒂��Ȃ��Ė߂�
"@
function coldelspc {
  $clp = Get-Clipboard -Format Text
  $datas = $clp -split "`n"
  $newclp = ""
  foreach ($item in $datas) {
    switch -Regex ($item)
    {  
      ".+" {$newclp = $newclp + $item + "`n"; break}
      default { break }
    }
  }
  $newclp = $newclp.Substring(0, $newclp.Length - 1)
  Set-Clipboard -value $newclp
}

$manhash["coldel2"] = @"
���s��؂�̕����f�[�^���N���b�v�{�[�h����ǂ��
 �󔒂Ɓh,�h���Ȃ��Ė߂�
"@
function coldel2 {
  $clp = Get-Clipboard -Format Text
  $datas = $clp -split "`n"
  $newclp = ""
  foreach ($item in $datas) {
    switch -Regex ($item)
    {  
      ","  { break }
      ".+" {$newclp = $newclp + $item + "`n"; break}
      default { break }
    }
  }
  $newclp = $newclp.Substring(0, $newclp.Length - 1)
  Set-Clipboard -value $newclp
}

$manhash["coldel2swp"] = @"
�e�s�����s��؂�ŁA�e���ڂ��^�u��؂�̕����f�[�^��
 �N���b�v�{�[�h����ǂ��
 �󔒂Ɓh,�h�̍s���Ȃ��A�������Ȃ��f�[�^��1���ڂ�2���ږڂ�
 ����ւ��Ė߂��B
"@
function coldel2swp {
  $clp = Get-Clipboard -Format Text
  $datas = $clp -split "`n"
  $newclp = ""
  foreach ($itemLine in $datas) {
    $items = $itemLine -split "`t" 
    switch -Regex ($items[0])
    {  
      ","  { break }
      ".+" {$newclp = $newclp + $items[1] + "`t`t`t`t`t`t`t" + $items[0] + "`n"; break}
      default { break }
    }
  }
  $newclp = $newclp.Substring(0, $newclp.Length - 1)
  Set-Clipboard -value $newclp
}

$manhash["memogrep"] = @"
�����̃������L�[���[�h�Ō�������
"@
function memogrep($searchWord) { 
  Select-String $searchWord -context 2,8 -path C:\Users\nakaom\memo\*.*
}

$manhash["manf"] = @"
�֐��̐�����\������
 �����Ɋ֐���������ƁA���̊֐��̐����̂ݕ\������
"@
function manf($cmd) {
  if([string]::IsNullorEmpty($cmd)) {
    Write-Output $manhash
  } else {
    Write-Output $manhash[$cmd]
  }
}





# SIG # Begin signature block
# MIIGCQYJKoZIhvcNAQcCoIIF+jCCBfYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUlS87PGhn4KPOi+dKwqnqhK17
# +nOgggNwMIIDbDCCAlSgAwIBAgIQR1Uy3wFEc7dN91Cb5xKMGDANBgkqhkiG9w0B
# AQsFADBOMUwwSgYDVQQDDENQb3dlclNoZWxs57mn772557mn772v57md772q57md
# 5Yqx44Oo6YSC772y6Jy35ZKy55WR6Zqq77286K2P5Y+W5baMMB4XDTIzMTEzMDA3
# NTIwOFoXDTQ5MTIzMTE1MDAwMFowTjFMMEoGA1UEAwxDUG93ZXJTaGVsbOe5p++9
# uee5p++9r+e5ne+9que5neWKseODqOmEgu+9suict+WSsueVkemaqu+9vOitj+WP
# luW2jDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALHvQYqJ3tfczze8
# g69wV4g8UhIpsf14gRSTqiWp83xU13QSro1iJrqt0YgkjvxZhQ02/N+qdj7J7AxP
# DTCs9ukkOIoOTeHjb7LYGshqV0hOxDhSndidS0dzLKFGrWhJ2cF15XfaZH4s84Wr
# iN7rNtE4RMEdeg/kMZ/jacAL2rjonAG3+u5oQ6MHBNAGrovamI5X2CX9xuquXa2+
# J5qcQ8lPMrZlBYiMuRBHcsPlk1P0WokKwTwa91buFxtBp3uzMYWQx9QnhZUtbfPP
# t/uB2b+2wF310wr1U70WhlCs2pWmqYpR3bLWNRAcGl96GBhYZK0YKJ7fo4HIm3Dh
# MtNL6zECAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMB0GA1UdDgQWBBS6MZQhCMvj32QnbX7K63sgi3O+DDANBgkqhkiG9w0BAQsF
# AAOCAQEAaa28IZPea5EG8mxahmXog5NHguUU2Qw972MKieFAxMTNSlF+7RW74yVV
# rzwieu8QnhWa1Bon9cgBkaxO7UaumxfdBz08T1P1SeIE+QXIEP4mAYqJjYRE8xvf
# bMs5b9lQiXc4BxC7W9AKqiv+AcV96O1qnVhWnh6p6EK5hXAiB+cjPazuWCxXq6ay
# BDPPN6BbC6JAbSqKgJnC1G38REjpKW/GTgHD6fsMBtWVOlHztB/s4rLS8VrPdJNy
# YsVddyt1JeqfUyQpkpYyWTpGH3KP5lBnqvyuGYbVqkJSPpd7/Ccjdk49vqMTOqez
# L8CqOSqAdub7iJjqDVM96zgAdChVuzGCAgMwggH/AgEBMGIwTjFMMEoGA1UEAwxD
# UG93ZXJTaGVsbOe5p++9uee5p++9r+e5ne+9que5neWKseODqOmEgu+9suict+WS
# sueVkemaqu+9vOitj+WPluW2jAIQR1Uy3wFEc7dN91Cb5xKMGDAJBgUrDgMCGgUA
# oHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0B
# CQQxFgQUOv/YDKCJD5mXBTZUlqCoWC/8FUAwDQYJKoZIhvcNAQEBBQAEggEAYsNf
# n1A9xF69iPH0txIGHx12jrCxHmeim4r19PqTk/FysoB2LKA2lJW8B6dy+gKiqgHp
# WdLjTnUs3uqaurfE1/WD3MuEtE0emN87X8cvWq0NcXHnmzvLw8277lqcnHGYK7py
# wo/mXLtomSuJ0/SOmLKdttG0J5j3ayrIsmy03nJR01o2HtlOQAz45xISnis5DEqv
# 4EVpx7sm9uADluwjFiRVPhKVYjiWNgOoveApfRRiV45kZVLd4U5X9YQGQBNghjXZ
# Mf79n6GztY4m2L4imlj5F6wpjxFvFHvGvCCjju/PwxLqtqxUYDTpiuloPZLahgSj
# ad9uD2UTvIACOIjc3w==
# SIG # End signature block
