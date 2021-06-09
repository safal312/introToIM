class Game {
  float boxWidth = 400;
  float boxHeight = 400;
  void init() {
    pushMatrix();
    translate(width/2, height/2 - boxHeight/2);
    pushMatrix();
    rotate(radians(45));
    rect(0, 0, boxWidth, boxHeight);
    popMatrix();
    popMatrix();
  }
}

void setup() {
  size(800, 800);

  game.init();
  
}

Game game = new Game();

void draw() {
  //background(200);
  //println(width, height, game.boxWidth, game.boxHeight);
  //println(800/0.2);
}
