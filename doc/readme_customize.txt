設定ファイルのカスタマイズガイド

＜1.前提＞
readme.txtの内容は一通り理解しておいて下さい。


＜2.カスタマイズの目的と指針＞
多くのツールを使用しているため、それぞれのツールの機能の範囲で自由にカスタマイズができます。

例えば・・

[POIアイコンや表示条件の変更]
→tmz.typ の編集（TYPviewer https://sites.google.com/site/sherco40/ などで編集できます）
  とstyles\mystyle\pointsの編集
    pointsの編集についての詳細はmkgmapの使い方を探してみてください

なお、アイコンの表示縮尺の変更は、GPS側の設定でもある程度は変更できますので、
データのカスタマイズよりも先に試してみてください。
Edge800の場合、
  System->Map->Map Visibility->Map Visibility Mode を Custom
  System->Map->Map Visibility->Detail
で情報量の調整ができます。

[ローマ字変換の精度向上]
→kakasiの処理動作の改善（使用する辞書ファイルを変更する、または自作辞書を追加する）

[等高線の間隔を変更]
make_contour_japan.bat 内のSRTM_ARGSを変更してから実行する。
配布ファイルでは、20m間隔で、500m毎、100m毎に太い線が入る設定(-step 20 -cat 500 100)になっています。
オプションの詳細はSrtm2Osmの説明ページ（下記）を参照して下さい。
http://wiki.openstreetmap.org/wiki/Srtm2osm

表示縮尺の設定は、
styles\mystyle\lines の
contour の部分にあります。
配布時の設定では、
  20m毎の線  contour_ext=elevation_minor
  100m毎の線 contour_ext=elevation_medium
  500m毎の線 contour_ext=elevation_major
になっています。

[等高線を国土地理院の基盤地図情報から取得]
簡単な変換手順は確立できていませんが、Srtm2Osmで取得する等高線よりも精度は高いと思われます。
データの再配布（公開）には制約があることに注意して下さい。
http://www.gsi.go.jp/kiban/

＜3.カスタマイズ中のポイント＞
カスタマイズは試行錯誤が必要になります。
最初から日本全国などの大きなデータを毎回処理するのは効率が悪いので、カスタマイズの初期段階では小さな範囲のOSMデータをダウンロードしておき、それを使ってカスタマイズを進めるのがよいです

・OSMサイト( http://www.openstreetmap.org/ )のエクスポートタブで表示させたい領域を表示して、
  ファイル形式：OSM XMLデータ で出力
・gmapsupp作成.batに、上記でダウンロードしたXMLファイルをドラッグアンドドロップする
  （gmapsupp作成.batにファイルが指定された場合は、ダウンロードせずに指定ファイルが使われるようになっています）

＜4.変換が失敗する場合のチェックポイント＞

■OSMデータの更新に伴う主なエラーと対策
これまで変換できていたのに変換できなくなった場合、OSMデータの変化によって変換ができなくなったと考えられます。
・これまでの設定ファイル群では正しく変換できない文字が追加された
       例えば、日本の特定の場所に海外ユーザがASCII以外の文字を含む自国語でタグを追加した場合など
    → 変換条件を修正する必要があります。なお、この場合は作者が公開している変換用ファイルも更新すると思います。
       OSMデータ側を修正することは、データ追加者のミスであることが明らかでない限り避けて下さい。
・データが大きくなりすぎて処理できなくなった
    → 処理できなくなった箇所を特定し、例えばmkgmapでメモリ不足になっているなら、
       バッチファイル内のMKGMAPのメモリサイズオプションを変えるなどしてください。
       内容によっては、作者が公開している変換用ファイルも更新されます。

■その他のエラー例と対策
--------
エラー表示例(mkgmap)：
Error at line 1688655, col 43
Bad file format: 63240074.osm.pbf.roman
Error parsing file

mkgmapが処理しようとするOSMデータは完全なXMLである必要があります。
上記のようにエラー行が表示されている場合は、UTF-8かつ大きなデータの表示ができるテキストエディタか、
なければgnuwin32のlessコマンドで確認し、原因を調査する。
（lessコマンドの場合、起動後に1688655G と入力すれば1688655行目にジャンプします）

行数が表示されない場合、XMLEDITOR.NET で場所を確認。( http://www.xmleditor.jp/ )

--------
エラー表示例(mkgmap)：
Overflow of the NET1. The tile (63240023.osm.pbf.roman) must be split so that th
ere are fewer roads in it

データが大きすぎるようです。
この場合は、splitterのオプションの--max-nodes=1000000の部分を小さくしてみたところ
エラーが起きなくなりました。
