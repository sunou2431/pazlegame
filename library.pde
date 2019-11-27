//ここの内容は決して変更しないこと
//実行時のエラーで、このプログラムのどこかの行がエラー箇所として指摘される場合があります
//そのような場合でも、本当のエラー原因は、エラー箇所を呼び出している【あなたが】書いたプログラムです
//
//ここの内容は理解できなくても課題提出には影響ありませんが、
//何をやっているかを読んでみることは勉強になるはずです。

PFont titleFont;
void setupMisc() {//もろもろの初期設定
  smooth();
  titleFont = createFont("HGPｺﾞｼｯｸM", 40);
}
void drawRuler(int xMax, int yMax) {//目盛を描画する。左上（0, 0)、右下(xMax, yMax)の範囲
  drawLattice(xMax, yMax, 10, 240);//とても薄いグレーで10画素間隔格子を描画
  drawLattice(xMax, yMax, 50, 210);//やや薄いグレーで50画素間隔格子を描画
  drawLattice(xMax, yMax, 100, 160);//比較的濃いグレーで100画素間隔格子を描画
}
//縦横の格子状に線分を描く
//(0, 0)と(xMax, yMax)の間の範囲に間隔interval画素でstrokeColorの色の縦横線を描く
void drawLattice(int xMax, int yMax, int interval, int strokeColor) {
  //以下の設定stroke, strokeWeightは、ここが実行されたあとdrawLattice終了後も持続します
  //あなたの書いた部分の実行にも影響します
  //自分で書く部分の描画直前の行で自分の望むstroke, strokeWeightの設定をし直してください
  stroke(strokeColor);
  strokeWeight(1);
  for (int x = 0; x < xMax; x += interval) {
    line(x, 0, x, yMax - 1);
  }
  for (int y = 0; y < yMax; y += interval) {
    line(0, y, xMax - 1, y);
  }
}
void drawTitleAndName(String title, String name) {
  textFont(titleFont);
  textSize(40);
  fill(255);
  final int areaHeight = 100;
  rect(0, height - areaHeight, width, areaHeight);
  fill(0);
  drawTitle(title, areaHeight);
  drawName(name);
  fill(0);
  strokeWeight(1);
}
void drawTitle(String title, int areaHeight) {
  textAlign(LEFT, TOP);
  final int y1 = height - areaHeight + 10;
  final int y2 = height - areaHeight / 2;
  final int x = 1;
  if (title.length() <= 25) {
    text(title, x, y1);
  } else if (title.length() <= 40) {
    text(title.substring(0, 25), x + 100, y1);
    text(title.substring(25), x, y2);
  } else {
    text(title.substring(0, 25), x, y1);
    text(title.substring(25, 40), x, y2);
  }
}
void drawName(String name) {
  textAlign(RIGHT, BOTTOM);
  text(name, width - 1, height - 1);
}