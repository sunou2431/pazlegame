/////////////////////////////////////////////////
/////////////グローバル変数
//////////////////////////////////////////////////
int [][] data = new int[13][20]; //座標データ
PImage[] puyo;//ぷよぷよの画像データ
int nowdata = 10;//現在選択しているぷよの記憶データ
int num;//消せる個数入れておく
int score = 0;//現在のスコアの一時記憶
int x;//座標の位置
int y;//座標の位置
int flgmode = 0;//タイトル画面などの切り替え
color iro[] = new int[5];//色の格納
int sentaku = 0;//初期画面の選択
String name; //名前の選択
BufferedReader reader;//読み込み
String line;//読み込み
String[] rankname = new String[11];
String[] rankscore = new String[11];


/////////////////////////////////////////////
////初期セットアップ//////////////////////////
//////////////////////////////////////////////////
import javax.swing.*;
import java.awt.*;

JLayeredPane pane;
JTextField field;
JTextArea area;

void settings() {
  size(1000, 800);
}

void setup() {
  
  Canvas canvas = (Canvas) surface.getNative();
  pane = (JLayeredPane) canvas.getParent().getParent();
  
  strokeWeight(1);
  setupMisc();
  puyo = new PImage[10];
  puyoload(0);
  newdata();
  irosen();
}

/////////////////////////////////////////////////////////
//////メイン関数
///////////////////////////////////////////////
void draw() {
  background(255, 255, 255);//特にどうでもいいところは白色での塗りつぶし

  switch(flgmode) {
  case 1://ゲーム画面
    viewdata();//ぷよの表示
    viewscore();
    break;

  case 0://タイトル画面
    title();
    break;

  case 2://ランキング画面
    scoreview();
    break;
    
  case 3://ランキング送信画面
  case 4:
    if(flgmode == 3){
        field = new JTextField();
        field.setBounds(150, 500, 150, 30);
        pane.add(field);
        flgmode = 4;
    }
    scoresend();
    break;
  }

  //タイトル名などの表示
  drawTitleAndName("パズルプログラム", "M0117210 西澤武");
}

/////////////////////////////////////////
//////画像の読み込み
//////////////////////////////////////////
void puyoload(int j) {
  for (int i = 0; i <= 9; i++) {
    if (j == 0) {
      puyo[i] = loadImage("pazu"+i+".jpeg");
    }
  }
}

////////////////////////////////////////////////////////////
////////データ配列の作成
////////////////////////////////////////////////////////////
void newdata() {
  for (int i = 0; i <= 11; i++) {
    for (int j = 0; j <= 19; j++) {
      data[i][j] = int(random(4));
    }
  }
}

/////////////////////////////////////////////
//////ぷよの描画  
//////////////////////////////////////////////////
void viewdata() {
  for (int i = 0; i <= 11; i++) {
    for (int j = 0; j <= 19; j++) {
      image(puyo[data[i][j]], j*50, 100+i*50);
    }
  }
}

//////////////////////////////////////////////////
/////マウスが動いたとき消せるところの表示
//////////////////////////////////////////////////
void mouseMoved() {
  switch(flgmode){
      case 1:
      x = mouseX/50;//横軸の計算
      y = (mouseY - 100)/50;//縦軸の計算
      int flg = 1;//消せるところの検索時に使用
    
      ///画面外などをタッチした場合のエラー回避
      if (x >= 21) {
        x = 20;
      }
      if (x <= 0) {
        x = 0;
      }
      if (y >= 13) {
        y = 12;
      }
      if (y <= 0) {
        y  = 0;
      }
    
      if (0 > data[y][x]-5) {//最初にデータが赤色にしてるか確認
        for (int i = 0; i <= 11; i++) {//背景が赤色のものをもとの色に戻す
          for (int j = 0; j <= 19; j++) {
            if (data[i][j] ==  nowdata + 5) {
              data[i][j] = nowdata;
            }
          }
        }
    
    
        nowdata = data[y][x] % 5;//nowデータを現在のものに置き換え
        data[y][x] = data[y][x] + 5; //背景を赤色に変更
    
    
        while (flg == 1) {//一回でも変えていたら最初から
          flg = 0;//flgを0にする
          for (int i = 0; i <= 11; i++) {
            for (int j = 0; j <= 19; j++) {
              if (data[i][j] == data[y][x]) {//データが隣接しているものだったら
                if (i != 0) {
                  if (data[i-1][j] == data[y][x]-5) {//上側の確認
                    data[i-1][j] = data[y][x];
                    flg = 1;
                  }
                }
                if (i != 11) {
                  if (data[i+1][j] == data[y][x]-5) {//下側の確認
                    data[i+1][j] = data[y][x];
                    flg = 1;
                  }
                }
                if (j != 0) {
                  if (data[i][j-1] == data[y][x]-5) {//左側の確認
                    data[i][j-1] = data[y][x];
                    flg = 1;
                  }
                }
                if (j != 19) {
                  if (data[i][j+1] == data[y][x]-5) {//右側の確認
                    data[i][j+1] = data[y][x];
                    flg = 1;
                  }
                }
              }
            }
          }
        }
        num = 0;
        for (int i = 0; i <= 11; i++) {//消せるプヨの合計を計算
          for (int j = 0; j <= 19; j++) {
            if (data[i][j] == nowdata+5) {
              num++;
            }
          }
        }
      }
      break;
      
    case 0:
      int dummy = 0;
      if((mouseX >= 30)&&(mouseX <= 330)){
        if((mouseY >= 30)&&(mouseY <= 130)){
          sentaku = 1;
          dummy = 1;
        }
      }
      if((mouseX >= 30)&&(mouseX <= 330)){
        if((mouseY >= 160)&&(mouseY <= 260)){
          sentaku = 2;
          dummy = 1;
        }
      }
      if((mouseX >= 30)&&(mouseX <= 330)){
        if((mouseY >= 290)&&(mouseY <= 390)){
          sentaku = 3;
          dummy = 1;
        }
      }
      if(dummy == 0){
        sentaku = 0;
      }
      break;
  }
}
void mouseReleased() {
  switch(flgmode){
    case 1:
      if ((x == mouseX/50)&&(y == (mouseY - 100) /50)) { 
        //消す個数が1個の場合は消せないようにする
        if (num >= 2) {
          //消せるところを消す
          for (int i = 0; i <= 11; i++) {
            for (int j = 0; j <= 19; j++) {
              if (data[i][j] == nowdata+5) {
                data[i][j] = 4;
              }
            }
          }
          //scoreの増加
          score = score + ( (num - 2) * ( num - 2) );
    
          //消したプヨを上に持っていく
          for (int i = 0; i <= 19; i++) {
            for (int j = 0; j <= 11; j++) {
              for (int k = 11; k >= 1; k--) {
                if (data[k][i] == 4) {
                  int tmp = data[k][i];
                  data[k][i] = data[k-1][i];
                  data[k-1][i] = tmp;
                }
              }
            }
          }
          //その行に消したプヨしかない場合右に持っていく
          for (int i = 0; i <= 19; i++) {
            for (int j = 18; j >= 0; j--) {
              if (data[11][j] == 4) {
                for (int k = 0; k <= 11; k++) {
                  int tmp = data[k][j];
                  data[k][j] = data[k][j+1];
                  data[k][j+1] = tmp;
                }
              }
            }
          }
        }
      }
      if((mouseX >= 500)&&(mouseX <= 750)){
        if((mouseY >= 10)&&(mouseY <= 50)){
          scorereset();
        }
      }
      if((mouseX >= 750)&&(mouseX <= 950)){
        if((mouseY >= 10)&&(mouseY <= 50)){
          flgmode = 3;
        }
      }
      break;
      
    case 0:
      if((mouseX >= 30)&&(mouseX <= 330)){
        if((mouseY >= 30)&&(mouseY <= 130)){
          scorereset();
          flgmode = 1;
        }
      }
      if((mouseX >= 30)&&(mouseX <= 330)){
        if((mouseY >= 160)&&(mouseY <= 260)){
          scoreload();
          flgmode = 2;
        }
      }
      if((mouseX >= 30)&&(mouseX <= 330)){
        if((mouseY >= 290)&&(mouseY <= 390)){
          exit();
        }
      }
      break;   
      
    case 4:
      if((mouseY >= 600)&&(mouseY <= 650)){
        if((mouseX >= 300)&&(mouseX <= 400)){
          field.setBounds(1500, 5000, 150, 30);
          name = field.getText(); 
          scoreprint();
          flgmode = 0;
          
        }
        if((mouseX >= 500)&&(mouseX <= 600)){
          field.setBounds(1500, 5000, 150, 30);
          flgmode = 0;
        }
      }
      break;
      
    case 2:
      if((mouseX >=100)&&(mouseX <= 200)){
        if((mouseY >= 600)&&(mouseY <= 650)){
          flgmode = 0;
        }
      }
  }
}

////////////////////////////////////////
///消せる個数とそのスコアの表示/////////
//////////////////////////////////////////
void viewscore() {
  fill(255);
  rect(0, 0, width, 100);
  
  fill(0);
  text("現在のスコアは", 250, 50);
  text(String.valueOf(score), 375, 50);
  
  
  if ((num == 1)||(nowdata == 4)) {
    text("そこは消せないよ", 800, 100);
  } else {
    text("そこを消すと", 300, 100);
    text(String.valueOf(num), 375, 100);
    text("個消えてスコアは", 680, 100);
    text(String.valueOf((num-2)*(num-2)), 780, 100);
    text("増えるよ", 940, 100);
  }
  
  //リセットボタンとランキング送信ボタン
  strokeWeight(1);
  textAlign(LEFT,TOP);
  noFill();
  rect(500,10,200,40);
  text("リセット",520,15);
  rect(750,10,200,40);
  text("スコア送信",770,15);
}

/////////////////////////////////////////
////key 入力
/////////////////////////////////////////////////
void keyPressed() {
  switch(keyCode) {
    case 'R':
    case 'r':
      scorereset();
      break;
    
    case ESC:
      flgmode = 0;
      break;
  }
}

//////////////////////////////////////////////////
///スコアリセット
//////////////////////////////////////////////////
void scorereset(){
  newdata();
  score = 0;
  num = 0;
}

///////////////////////////////////////////////////
///それぞれのプヨの数の計算
///////////////////////////////////////////////////
void keisan() {
  for (int i = 0; i <= 19; i++) {
    for (int j = 0; j <= 11; j++) {
      switch(data[j][i]) {
      case 0:
      case 5:

        break;
      }
    }
  }
}


//////////////////////////////////////////////////
///タイトル画面の表示
/////////////////////////////////////////////////////
void title() {
  strokeWeight(1);
  textAlign(LEFT,TOP);
  
  if(sentaku == 1){
    fill(iro[2]);
  }
  else{
    noFill();
  }
  rect(30, 30, 300, 100);
  fill(iro[1]);
  text("ゲームで遊ぶ",45,45);
  
  if(sentaku == 2){
    fill(iro[2]);
  }
  else{
    noFill();
  }
  rect(30, 160, 300, 100);
  fill(iro[1]);
  text("ランキング",45,175);
  
  if(sentaku == 3){
    fill(iro[2]);
  }
  else{
    noFill();
  }
  rect(30, 290, 300, 100);
  fill(iro[1]);
  text("終了",45,305);
  
}

///////////////////////////////////////
///色の格納
//////////////////////////////
void irosen(){
  iro[0] = color(255,255,255);
  iro[1] = color(0,0,0);
  iro[2] = color(255,0,0);
}

//////////////////////////////////////////
////スコアの送信
///////////////////////////////////////
void scoresend(){
  strokeWeight(1);
  textAlign(LEFT,TOP);
  text("あなたのスコアは",130,30);
  text(score,130,80);
  text("でした",130,130);
  text("スコアを送信する場合はいかに名前を書いて送信",130,400);
  
  noFill();
  rect(300,600,100,50);
  text("送信",315,615);
  rect(500,600,100,50);
  text("終了",515,615);
}

///////////////////////////////////////////
///スコアの送信
/////////////////////////////////////
void scoreprint(){
  scoreload();
  for(int i = 0;i <= 10;i++){
    println(int(rankscore[i]),"-",score);
    if(int(rankscore[i]) <= score){
      for(int j = 9;j >= i ;j--){
        rankscore[j + 1] = rankscore[j];
      }
      rankscore[i] = str(score);
      rankname[i] = name;
      PrintWriter outfile;
      outfile = createWriter("score.txt");
      for(int j = 0; j <= 10 ;j++){
        outfile.print(rankscore[j]);
        outfile.print(",");     
        outfile.println(rankname[j]);
      }
      outfile.close();
      i = 100;
    }
  }
}

////////////////////////////////////////////
///スコアの読み込み
void scoreload(){
  int a = 0;
  String[] datalines;
  datalines = loadStrings("score.txt");
  if(datalines != null){
    for(int i = 0; i < datalines.length; i ++) {
      // 空白行でないかを確認
      if(datalines[i].length() != 0) {
        String[] values = datalines[i].split("," , -1);
        rankname[i] = values[1];
        rankscore[i] = values[0];
        a++;
        if(a >= 11){
          return;
        }
      }
    }
  }
}

////////////////////////////////////////////////
////スコアの読み込み
//////////////////////////////////////
void scoreview(){
  strokeWeight(1);
  textAlign(LEFT,TOP);
  for(int i = 1;i <= 10;i++){
    text(i,100,50 * i);
    text("位",150,50 * i);
    text(rankname[i-1],250,50 * i);
    text(rankscore[i-1],600,50 * i);
  }
  noFill();
  rect(100,600,100,50);
  text("戻る",115,615);
}