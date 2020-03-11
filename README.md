# GSCL_201
======================================================
              Graphix Scrooler Ver-2.01
                       [GSCL]
 -------常駐型グラフィックスクロールプログラム------
======================================================


★機能説明
  このプログラムは、メモリー上に常駐して、グラフィック
画面をスクロールしていくプログラムです。


★ファイル構成
  


★注意事項
  割り込みとして「ＢＩＯＳインターバルタイマ」を使用し
ています。他の同ＢＩＯＳを使用するプログラムとは混用で
きません。
  また、ＧＤＣ関係のＩ／Ｏポートを直接いじっているので
グラフィックを使ったソフトウェアをの混用も避けて下さい


★利用方法
  オプションとして、コマンドラインから S を指定すると、
常駐を開始し、 R を指定すると常駐を解除します。

   例  A>GSCL S       常駐開始
       A>GSCL -s         〃
       A>GSCL R       常駐解除
       A>GSCL /R         〃


★動作確認
  
  ハードウェア
    PC-9801 DS
    PC-9801 DA
    PC-9801 BA
    PC-286 VX
  
  混用ソフトウェア
    MS-DOS Ver3.3C (NEC)
    MS-DOS Ver3.3D (NEC)
    MS-DOS Ver5.0 R2 (EPSON)
    VZ Editor
    エコロジーⅡ
    ＦＤ


★配布条件
  フリーウェアーです。



