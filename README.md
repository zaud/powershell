私は、この数年間　職業＝「コピペ作業」　みたいな感じで過ごしています。

そんなある日、クリップボードの履歴が使えないマシンで仕事するはめになりました。
仕方がないので、クリップボードによく使う文字列を入れるものを作りました。
SQLなんかも使うので、一部置換できる機能も付けました。

一番上のリストのどれかをクリックするとクリップボードに文字列がセットされます。
その内容は、2段目の領域に表示されます。
一番下の小さな入力領域に文字列を入力して、「set(swap)」ボタンを押すと　
文字列の一部が置換されてクリップボードにセットされます。

データは、別途エディタ等で作成してください。
xx_utl_data.csv　という名前のファイルを使います。
名前(key)と内容(value)を並べただけのダブルクォーテーション括りのCSV形式です。

文字列の置き換え機能を使う場合は、内容(value)の置き換え対象部分に
"{}" 波括弧ペアを置きます。

-------------------------------------------------------------------
I've been spending the past few years feeling like occupation = "copy and paste work".

One day, I was forced to work on a machine that couldn't use clipboard history.
I couldn't help it, so I made something that puts frequently used strings on the clipboard.
Since we also use SQL, we have added a function that can be partially replaced.

Click on any of the top lists to set the string to the clipboard.
Its contents are displayed in the area of the second row.
If you enter a string in the small input area at the bottom and press the "Set (swap)" button,　
Part of the string is replaced and placed on the clipboard.

Please create the data separately with an editor.
Use a file named xx_utl_data.csv.
It is a CSV format with double quotation marks that only side by side the name (key) and the content (value).

When using the string replacement function, add
Put a pair of "{}" curly braces.

