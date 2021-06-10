// Game class to draw the four separate rectangles and store information about position and stuff
class Game {
  int boxWidth = 700;    // total width of the box
  int boxHeight = 700;    // total height of the box
  int borderWidth = 100;  // the border thickness

  void update() {
    noStroke();
    rect((width - boxWidth)/2, (height + boxHeight)/2 - borderWidth, boxWidth, borderWidth);      // orientation 0 - bottom rect
    rect((width + boxWidth)/2 - borderWidth, (height - boxHeight)/2, borderWidth, boxHeight);     // 1 - right
    rect((width - boxWidth)/2, (height - boxHeight)/2, boxWidth, borderWidth);                    // 2 - top
    rect((width - boxWidth)/2, (height - boxHeight)/2, borderWidth, boxHeight);                   // 3 - left
  }
}

// player class will handle the anti gravity mechanism and more
class Player {
  // start position of player at center
  float x = width/2;      
  float y = height/2;
  
  int orientation = 0;    // if integer to keep track of the orientation of the player 
  float gravity = 2;
  PImage character = loadImage("images/playerSprite/walk5.png");    // the default image I want to use
  
  // storing the desired height and width of character
  float chWidth = character.width * 2;
  float chHeight = character.height * 2;
  
  // method to be called every frame
  void update() {
    image(character, x, y, character.width * 2, character.height * 2);
    
    // if it doesn't collide with the wall, the gravity gets applied depending on what the orientation of the player is
    if (!collides()) {
      if (orientation == 0 || orientation == 2) {
        y += gravity;
      } else {
        x += gravity;
      }
    }
    
    // collision with objects yet to be implemented
  }
  
  // checking collision on the basis of the position of the rectangles on all sides
  boolean collides() {
    if (y > (height - game.boxHeight)/2 + game.borderWidth && y + chHeight < (height + game.boxHeight)/2 - game.borderWidth 
      && x > (width - game.boxWidth)/2 + game.borderWidth && x + chWidth < (width + game.boxWidth)/2 - game.borderWidth) {
      return false;
    }
    return true;
  }
}

Game game;
Player player;

void setup() {
  size(1000, 1000);
  game = new Game();
  player = new Player();
} 

void draw() {
  background(0);
  game.update();
  player.update();
  //println(mouseX, mouseY);
}

// game controls yet to be done
