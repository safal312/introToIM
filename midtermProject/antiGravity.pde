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
  float speed = 5;

  int orientation = 0;    // if integer to keep track of the orientation of the player 
  float gravity = 2;
  PImage character = loadImage("images/playerSprite/walk5.png");    // the default image I want to use

  // storing the desired height and width of character
  float chWidth = 28*2;    // 28 and 34
  float chHeight = 34*2;

  // method to be called every frame
  void update() {
    //image(character, x, y, chWidth, chHeight, 73, 29, 45, 63);
    pushMatrix();
    translate(x, y);
    pushMatrix();
    int angle = -90 * orientation % 360;
    rotate(radians(angle));
    image(character, 0, 0, 28*2, 34*2, 45, 29, 73, 63);
    popMatrix();
    popMatrix();


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
    if (player.orientation == 0 && (y + chHeight) < (height + game.boxHeight)/2 - game.borderWidth) return false;
    if (player.orientation == 1 && x + chWidth < (width + game.boxWidth)/2 - game.borderWidth) return false;
    if (player.orientation == 2 && (y - chHeight > (height - game.boxHeight)/2 + game.borderWidth)) return false;
    if (player.orientation == 3 && x - chWidth > (width - game.boxWidth)/2 + game.borderWidth) return false;
    return true;

    //if ((y > (height - game.boxHeight)/2 + game.borderWidth) && ((y + chHeight) < (height + game.boxHeight)/2 - game.borderWidth) 
    //  && x > (width - game.boxWidth)/2 + game.borderWidth && x + chWidth < (width + game.boxWidth)/2 - game.borderWidth) {
    //  return false;
    //}
    //return true;
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
  println(player.orientation);
  //println(mouseX, mouseY);
  ellipse(player.x, player.y, 5, 5);    // really helpful to find the collision box of the character
  //println(player.x, player.chWidth);
}

// game controls yet to be done
void keyPressed() {
  
  // need to make it specific per orientation
  
  
  if (player.orientation == 0 || player.orientation == 2) {
    if (player.x < (width - game.boxWidth)/2 + game.borderWidth) {
      player.x = (width - game.boxWidth)/2 + game.borderWidth;
    } else if (player.x + player.chWidth > (width + game.boxWidth)/2 - game.borderWidth) {
      player.x = (width + game.boxWidth)/2 - player.chWidth - game.borderWidth;
    } else {
      if (keyCode == LEFT) {
        player.x -= player.speed;
      } else if (keyCode == RIGHT) {
        player.x += player.speed;
      }
    }
  }

  if (player.orientation == 1 || player.orientation == 3) {
    if (player.y - player.chHeight < (height - game.boxHeight)/2 + game.borderWidth) {
      player.y = (height - game.boxHeight)/2 + game.borderWidth + player.chHeight;
    } else if (player.y > (height + game.boxHeight)/2 - game.borderWidth) {
      player.y = (height + game.boxHeight)/2 - game.borderWidth;
    } else {
      if (keyCode == UP) {
        player.y -= player.speed;
      } else if (keyCode == DOWN) {
        player.y += player.speed;
      }
    }
  }

  if (keyCode == ' ') {
    player.orientation = (player.orientation + 1) % 4;
    if (player.orientation == 0) player.gravity *= -1;
    if (player.orientation == 2) player.gravity *= -1;

    float temp = player.chWidth;
    player.chWidth = player.chHeight;
    player.chHeight = temp;
  }

  //if (player.orientation == 0) {
  //  if (keyCode == UP) {
  //    player.gravity *= -1;
  //  }
  //}

  //if (player.orientation == 1) {
  //    if (keyCode == DOWN) {
  //      player.gravity
  //    }
  //}
}
