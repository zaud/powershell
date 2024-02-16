#
# function を最初に登録しておいて、いつでも使えるようにする。
# 簡単な説明を hashtable にして、表示する。
#
$manhash = @{}

$manhash["tsvInsert"] = @"
tsvのデータから INSERT 文を作成して戻す(進化版）
 - table_name は引数2つ目で渡す
 - TSV1行目（列名）の　#付きをNUMBERとして「"」によるクオートを行わない。
 - TSV1行目（列名）の　$付きをDATEとして、YYYY/MM/DD hh:mm:ss の
   後半部分（時間）をカットする。
 - 中身の無い行のINSERT文は作らない。
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
  $headStr = $headStr.Substring(0, $headStr.Length - 1)    # 余計な","を削除
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
      $insertSql = $insertSql.Substring(0, $insertSql.Length - 1)    # 余計な","を削除
      $insertSql = $insertSql + ");`n"
    }
  }
  return($insertSql)
}

$manhash["clipTsvInsert"] = @"
tsv のデータをクリップボードから読み込んで
 INSERT 文で戻す
   tsvの１行目はカラム名リストとして使用する
   tsvInsert を利用する
   table_name は引数で渡す
"@
function clipTsvInsert ($tableName){
  $clp = Get-Clipboard -Format Text
  $newclp = tsvInsert $clp $tableName
  Set-Clipboard -value $newclp
}



$manhash["tsvQt"] = @"
tsvのデータ各項目を「'」でクォートしてcsvで戻す
"@
function tsvQt($tsv) {
  $newCsv = ""
  $lines = $tsv -split "`r`n"
  foreach ($line in $lines) {
    $datas = $line -split "`t"
    foreach ($item in $datas) { $newCsv = $newCsv + "'" + $item + "'," }
    $newCsv = $newCsv.Substring(0, $newCsv.Length - 1)    # 余計な","を削除
    $newCsv = $newCsv + "`r`n"
  }
  return($newCsv)
}

$manhash["clipTsvQt"] = @"
tsv のデータをクリップボードから読み込んで 各項目を「'」でクォートしてcsvで戻す
  tsvQt を利用する
"@
function clipTsvQt {
  $clp = Get-Clipboard -Format Text
  $newclp = tsvQt $clp
  Set-Clipboard -value $newclp
}

$manhash["c2t"] = @"
csvのデータ各項目をtsvにして戻す
 引数：csv 文字列
"@
function c2t($csv) {
  $tsv = ""
  $lines = $csv -split "`r`n"
  foreach ($line in $lines) {
    $datas = $line -split ","
    foreach ($item in $datas) { $tsv = $tsv + $item + "`t" }
    $tsv = $tsv.Substring(0, $tsv.Length - 1)    # 余計な"`t"を削除
    $tsv = $tsv + "`r`n"
  }
  return($tsv)
}

$manhash["clipc2t"] = @"
csv のデータをクリップボードから読み込んで tsv にして戻す
  c2t を利用する
"@
function clipc2t {
  $clp = Get-Clipboard -Format Text
  $newclp = c2t $clp
  Set-Clipboard -value $newclp
}

$manhash["csvQt"] = @"
csvのデータ各項目を「'」でクォートして戻す
"@
function csvQt($csv) {
  $newCsv = ""
  $lines = $csv -split "`r`n"
  foreach ($line in $lines) {
    $datas = $line -split ","
    foreach ($item in $datas) { $newCsv = $newCsv + "'" + $item + "'," }
    $newCsv = $newCsv.Substring(0, $newCsv.Length - 1)    # 余計な","を削除
    $newCsv = $newCsv + "`r`n"
  }
  return($newCsv)
}

$manhash["clipcsvQt"] = @"
csv のデータをクリップボードから読み込んで 各項目を「'」でクォートして戻す
  csvQt を利用する
"@
function clipcsvQt {
  $clp = Get-Clipboard -Format Text
  $newclp = csvQt $clp
  Set-Clipboard -value $newclp
}

$manhash["clCsv"] = @"
tsv のデータをクリップボードから読み込んで クォートしないで csv で戻す
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
tsv のデータをクリップボードから読み込んで csv で戻す
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
改行区切りのデータをクリップボードから読んで csv で戻す 
"@
function colcsv {
  $clp = Get-Clipboard -Format Text
  $datas = $clp -split "`n"
  $newclp = ""
  foreach ($item in $datas) { $newclp = $newclp + "'" + $item + "'," }
  $newclp = $newclp.Substring(0, $newclp.Length - 1)
  Set-Clipboard -value $newclp
}

$manhash["delchar"] = @"
クリップボードから読んで指定charを取り除いて戻す
"@
function delchar($chars) {
  $clp = Get-Clipboard -Format Text
  $chars.ToCharArray() | foreach {
    $clp = $clp.Replace($_.ToString(), "")
  }
  Set-Clipboard -value $clp
}

$manhash["kakkonai"] = @"
複数行データをクリップボードから読み込んで
 カッコ内だけを戻す
"@
function kakkonai {
  $clp = Get-Clipboard -Format Text
  $datas = $clp -split "`n"
  $newclp = ""
  foreach ($item in $datas) { 
    $m = $item -match "[(（].*[）)]"
    $nakami = $Matches[0] -replace "[()（）]", ""
    if ($m) {
      $newclp = $newclp + $nakami + "`n" 
    }
  }
  $newclp = $newclp.Substring(0, $newclp.Length - 1)
  Set-Clipboard -value $newclp
}

$manhash["clpupp"] = @"
小文字の データをクリップボードから読み込んで 大文字 で戻す
 lower case -> upper case
"@
function clpupp {
  $clp = Get-Clipboard -Format Text
  $newclp = $clp.ToUpper()
  Set-Clipboard -value $newclp
}

$manhash["clplow"] = @"
大文字の データをクリップボードから読み込んで 小文字 で戻す
 upper case -> lower case
"@
function clplow {
  $clp = Get-Clipboard -Format Text
  $newclp = $clp.ToLower()
  Set-Clipboard -value $newclp
}


$manhash["coll2u"] = @"
改行区切りの小文字データをクリップボードから読んで
 大文字改行区切りで戻す 
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
改行区切りの大文字データをクリップボードから読んで
 小文字改行区切りで戻す 
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
改行区切りの文字データをクリップボードから読んで
 大文字小文字を判定し、それぞれ反転させて戻す 
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
改行区切りの文字データをクリップボードから読んで
 空白を省いて戻す
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
改行区切りの文字データをクリップボードから読んで
 空白と”,”を省いて戻す
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
各行が改行区切りで、各項目がタブ区切りの文字データを
 クリップボードから読んで
 空白と”,”の行を省き、消去しないデータの1項目と2項目目を
 入れ替えて戻す。
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
毎日のメモをキーワードで検索する
"@
function memogrep($searchWord) { 
  Select-String $searchWord -context 2,8 -path C:\Users\nakaom\memo\*.*
}

$manhash["manf"] = @"
関数の説明を表示する
 引数に関数名を入れると、その関数の説明のみ表示する
"@
function manf($cmd) {
  if([string]::IsNullorEmpty($cmd)) {
    Write-Output $manhash
  } else {
    Write-Output $manhash[$cmd]
  }
}




