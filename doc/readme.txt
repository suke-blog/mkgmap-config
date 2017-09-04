■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
■                                                                      ■
■  OpenStreetMapデータからのローマ字版 gmapsupp.img作成用設定ファイル  ■
■                                                                      ■
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

＜1.これは何？＞
OpenStreetMap(OSM)の日本全国の地図データを変換して、Garmin GPS用のgmapsupp.imgを作成するための設定ファイル群です。
英語版GPSで使用するため、日本語（漢字やひらがな）はローマ字に変換します。

なお、変換済みのデータは http://tmz.skr.jp/data/gmap.html で公開しています。
この設定ファイルは、各自でカスタマイズした地図を作成したい場合に利用されることを想定しています。

＜2-1.最低限必要なハードウェア＞
・Windows PC
・メモリ4GB以上
・HDD空き容量15GB以上 等高線付きにする場合は25GB以上

地図データは非常に大きなデータのため、大きめのメモリとHDDが必要です。
将来、OSMのデータが大きくなった場合は、さらに大きなものが必要になる可能性があります。

＜2-2.最低限必要なソフトウェア＞ 無償ソフトのみで動作可能です
・Java
  http://java.com/ja/download/
・GnuWin32
  http://gnuwin32.sourceforge.net/packages.html
    CoreUtils, Gzip, Less, LibIconv, Make, Sed, Wget の各パッケージ
・ActivePerl
  http://www.activestate.com/activeperl/downloads
    Community Edition
・splitter
  http://www.mkgmap.org.uk/splitter/
    splitter-rXXXの最新版[.zip]
・mkgmap
  http://www.mkgmap.org.uk/snapshots/
    mkgmap-rXXXXの最新版[.zip]
・Osmconvert
  http://wiki.openstreetmap.org/wiki/Osmconvert
・Srtm2Osm ※等高線データが必要な場合のみ
  http://tmz.skr.jp/programs/srtm2osm_srtm3_30.html
・kakasi
  http://www.namazu.org/win32/
    kakasi-2.3.4.zip
・テキストエディタ（各自、使い慣れたもの）

＜2-3.最低限必要なデータ＞
・kakasi用辞書データ
  http://openlab.ring.gr.jp/skk/wiki/wiki.cgi?page=SKK%BC%AD%BD%F1#p7
  SKK-JISYO.geo, SKK-JISYO.station
・（OpenStreetMapの地図データ）
  http://download.geofabrik.de/asia/japan.html
  japan-latest.osm.pbf 日々の最新版を毎回ダウンロードする必要がありますが、
  バッチファイル内で自動ダウンロードされるので事前にダウンロードする必要はありません。

＜2-4.カスタマイズに必要なもの（一例）＞
カスタマイズについての詳細は、readme_customize.txt をご覧ください。

・UTF-8対応のテキストエディタ（一部ファイルがUTF-8のため）
  例えば GreenPad http://www.kmonos.net/lib/gp.ja.html

＜設定ファイルの更新について＞
・OSMのデータを正常に変換できなくなった場合の対処
・変換ツール類の更新に伴うバッチファイルの更新
などのため、作者による公開ファイルは更新される場合があります。

各自でカスタマイズする場合、変更内容をマージできるように考慮しておくのがおすすめです。
（公開版と自分用にカスタマイズした内容の差分をメモしておく、
  または比較ツールやバージョン管理システムなどを利用して差分管理しておくなど）

＜ライセンス表示＞
Copyright (c) T-MZ, CC BY-SA 2.0 
http://creativecommons.org/licenses/by-sa/2.0/deed.ja

＜利用条件＞
この設定ファイルを利用したことにより生じた、または生じる損害について、
作者は責任を負いません。利用者の責任でご利用ください。

＜使用方法＞

1. 等高線データのダウンロード（等高線あり地図を作りたい場合のみ）
   ダウンロードできる等高線データは更新されないので、
   一度ダウンロードしたら、それ以降更新する必要はありません。

  1-1. 等高線ダウンロード用バッチファイルのファイルパスの更新
    contour\make_contour_japan.bat を開き、最初の部分にある下記を、各自のファイルパスに置き換える

    SRTM2OSM   : Srtm2Osmの実行ファイルを置いた場所

  1-2. ダウンロードを実行
    contour\make_contour_japan.bat をダブルクリックして実行するとデータがダウンロードされ、
    contourディレクトリ内に*.osmファイルが約300個作成されます。

2. バッチファイル内のファイルパス部分の更新
  gmapsupp作成.bat を開き、最初の部分にある下記を、各自のファイルパスに置き換える

  MAP_FILE_ORG : OpesStreetMapの元データをダウンロードする場所
  DIC_FILE     : kakasi用辞書ファイルを置いた場所
  SPLITTER     : splitterの実行ファイルを置いた場所
  MKGMAP       : mkgmapの実行ファイルを置いた場所
  PATH         : java, gnuwin32ツール(iconvなど), ActrivePerl(perl), kakasi, 
                 osmconvert, 7-Zip(7z)の全てにパスを通しておく

3. 等高線の有無を設定
  gmapsupp作成.bat を開き、最初の部分にある下記を、必要に応じて書き換える。

  set TARGET_TYPE=0

  等高線なしの地図のみ作るときは1、等高線ありの地図のみ作るときは2、両方作るときは0 に書き換える

4. gmapsupp作成.bat をダブルクリックして実行する

  最終的に、実行した場所の下のoutputディレクトリに
  gmapsupp.img や gmapsupp.zip ができていれば成功です。

  途中で変換に失敗した場合、gmapsupp.img が作成されずに空っぽのgmapsupp.zipが作成されたりします。

なお、変換実行中の下記エラーは表示されても問題ありません。

---------
致命的 (LocationHook): 63240001.osm.pbf.roman: Disable LocationHook because boundary directory does not exist. Dir: bounds
※ splitterで分割される境界を固定するためのファイルがないということのようですが、
   本設定ファイルの使い方としては分割される境界を固定する意図は無いので問題ありません。
---------

＜技術情報：gmapsupp作成.batの動作概要＞
動作の流れは、data_flow.pdfを参照して下さい。

大きな流れとしては、wgetでOSMデータの日本エリアの日々の最新版をダウンロードし、
splitterで120個程度に分割し、
kakasiで日本語をローマ字読み変換し、
mkgmapで1つのgmapsupp.imgとして変換します。

途中で一旦分割しているのは、mkgmapの変換時に一度に受け付けられるサイズにするためです。


＜変更履歴＞
2017/01/28
  ・ファイル容量削減のため、名称のない建物(building,amenity)を削除
  ・name:ja-Latnを名称候補に追加
  ・データがない（ファイルサイズ150バイト以下の）等高線ファイルを無視するよう変更

2016/11/11
  ・岡山南部の海岸線が消えないように暫定措置(areas.listの更新)

2016/09/25
  ・splitterの処理が終わらなくなったための対処を実施
    - メモリ割り当てを2Gに増加
    - resolutionを12に指定
  ・splitterの処理時間削減用にareas.listを再利用するように変更
  ・nameとoperatorが両方ある場合、operatorを削除するように変更

2016/05/25
  ・nameとbrandが両方ある場合、brandを削除するように変更

2016/05/02
  ・mkgmap r3676対応（スタイルファイルをr3676-defaultからマージ）
  ・mkgmap r3674以降で生成した等高線あり版でカーソル位置の情報が表示されないのを修正

2015/08/07
  ・XML構造保護用の変換対象文字を追加（"″"）

2014/11/17
  ・検索用イメージ作成用のファイル追加

2014/09/03
  ・mkgmap r3334対応（文字コードをutf8に変更）
  ・name/brand/operatorの同一名重複回避
  ・間引き用のオプション設定追加

2014/05/28
  ・splitter r398対応（--search-limit=10000000 を追加）
  ・モノレールとケーブルカーの表示を追加
  ・名前候補にbrandを追加

2014/03/05
  ・polygonのplaceタグを無視するよう変更（place=island内のlanduse=reservoirが表示されないことがある対策）
  ・information=boardのアイコンをiアイコンに変更

2014/01/19
  ・mkgmap r2934対応（スタイルファイルをr2934-defaultからマージ）
  ・一方通行マークの表示を追加

2013/09/07
  ・highway=serviceの表示を変更
  ・フランス語等の文字変換追加

2013/07/23
  ・XML構造保護用の変換対象文字を追加（"゛"）
  ・名前候補にname:frを追加

2013/05/06
  ・mkgmap最新版(r2585)対応
  ・POI（コンビニ）の判定条件調整

2013/03/20
  ・geofabrikのファイルパス変更
  ・等高線なしデータとありデータの両方を作るときの変換を高速化

2013/01/16
  ・splitter-r282対応（--keep-complete=true追加）
  ・mkgmap-r2447対応（display_name → mkgmap:display_name）
  ・mapidを63240001始まりから63310001始まりに変更

2012/12/17
  ・名前候補にname:ja_kanaを追加
  ・POI（コンビニ）の判定条件調整

2012/09/26
  ・OSMライセンス切り替え対応
    geofabrikのファイルパス変更
    coastlineを使用しないように変更
  ・XML構造保護用の変換対象文字を追加（"〈"と"〉"）

2012/06/19
  ・見やすさ改善とファイル容量削減のため、森の表示を削除
    具体的には、landuse=forest, landuse=wood, natural=woodを削除

2012/06/08
  ・Srtm2Osmのcorrxyオプションを使用するとエリア境界付近の等高線が0mになってしまうので
    corrxyオプション無しで取得後にperlスクリプトで補正するように変更

2012/06/02
  ・オーバーフローが起きる箇所が発生したため、splitterのmax-nodesを120000から100000に変更

2012/04/30
  ・等高線の誤差補正（Srtm2Osmのパラメータに-corrxy 0.0005 0.0005を追加）
  ・gmapsupp作成.batにファイルを指定した場合はダウンロードせずにそのファイルを使うように変更

2012/02/16
  ・等高線データの組み込み対応

＜最新版配布場所＞

http://tmz.skr.jp/data/gmap.html


＜連絡先＞

ご意見などがありましたら、作者までご連絡をお願いします。t-mz@ijk.com までどうぞ。
カスタマイズについては、readme_customize.txtに書かれているような大まかなアドバイスしかできませんのでご了承ください。
