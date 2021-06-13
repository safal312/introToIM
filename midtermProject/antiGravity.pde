/*  //<>//
 Name: Safal Shrestha
 Date: June 14, 2021
 Midterm Project: Anti-Gravity, Intro to IM, Summer 2021
 */


// Using the minim library
import ddf.minim.*;

Minim minim;
AudioPlayer playHead;      // player for the orb pickup sound
AudioPlayer bgPlayHead;    // player for the bg music

// Game class handles game states
class Game {
  int boxWidth = 700;    // total width of the box
  int boxHeight = 700;    // total height of the box
  int borderWidth = 100;  // the border thickness
  String state = "menu";  // there are three states: menu, play, and over
  int time = 20;          // time limit for the game
  boolean win = false;
  PFont font = createFont("PressStart2P.ttf", 64);

  void update() {
    // counting 60 frames as a second and using that as a timer
    if (frameCount % 60 == 0) time--;

    // two cases when game is over
    if (time < 0 || orbs.size() == 0) {
      state = "over";
      if (orbs.size() == 0) win = true;      // if player picks up all orbs, they win
    } else { 
      textFont(font);
      textSize(24);
      // displaying time
      text("TIME: " + time, width - 250, 90);

      noStroke();
      // four rectangles that make the box
      rect((width - boxWidth)/2, (height + boxHeight)/2 - borderWidth, boxWidth, borderWidth);      // orientation 0 - bottom rect
      rect((width + boxWidth)/2 - borderWidth, (height - boxHeight)/2, borderWidth, boxHeight);     // 1 - right
      rect((width - boxWidth)/2, (height - boxHeight)/2, boxWidth, borderWidth);                    // 2 - top
      rect((width - boxWidth)/2, (height - boxHeight)/2, borderWidth, boxHeight);                   // 3 - left
    }
  }

  void menu() {
    // text for the main menu
    textFont(font);
    text("ANTI GRAVITY", width/8, height/2);
    textSize(16);
    text("Press 'Enter' to play", width/3, height/1.5);
    text("Press 'Space' to switch your gravity", width/4.5, height - 160);
    text("Collect all the orbs before the time ends", width/5.5, height - 130);
    text("Press the arrow keys to move", width/3.5, height - 100);
    text("Press 'e' to exit", width/2.7, height - 70);
  }

  void over() {
    textFont(font);
    //text for the end screen
    if (win == true) {
      text("YOU WIN", width/4, height/2);
    } else {
      text("YOU LOSE", width/4.5, height/2);
    }
    textSize(16);
    text("Press 'r' to restart", width/3.1, height/1.5);
  }
}

// player class will handle the gravity mechanism and more
class Player {
  // start position of player at center
  float x = width/2;      
  float y = height/2;
  float anchorX = x;          // the actual x and y values of the image are in different positions than the top left point of the image in different orientations
  float anchorY = y;          // so we are using anchorX and anchorY to take care of that
  float speed = 5;            // walk speed
  float acc = 0.1;

  // boolean values to check for key presses
  boolean left = false;
  boolean right = false;

  int orientation = 0;    // integer to keep track of the orientation of the player 
  float gravity = 2;

  // stroing the images of the walk cycle in an array
  PImage[] sprite = new PImage[8];

  // default standing position image is in the fourth position
  int spriteCounter = 4;
  String characterString = "images/playerSprite/walk5.png";

  // storing the desired height and width of character
  float chWidth = 28*2;    // 28 and 34 is the height of the character within the image
  float chHeight = 34*2;

  // loading sprite images in the constructor
  Player() {
    for (int i = 0; i < 8; i++) {
      String path = "images/playerSprite/walk" + (i + 1) + ".png";
      sprite[i] = loadImage(path);
    }
  }

  // method to be called every frame
  void update() {
    pushMatrix();
    translate(x, y);
    pushMatrix();
    // depending on the orientation we rotate 90, 180, 270, or 0 degrees
    int angle = -90 * orientation % 360;
    rotate(radians(angle));

    // make the sprite animation a bit slower
    if (frameCount % 8 == 0) {
      if (left == true || right == true) {
        // if wer're moving any way, we increase the spriteCounter to change the current image to something else
        spriteCounter = (spriteCounter + 1) % 8;
      }
    }

    if (left == true) {
      image(sprite[spriteCounter], 0, 0, 28*2, 34*2, 45, 29, 73, 63);
    } else if (right == true) {
      // invert the image when moving right
      image(sprite[spriteCounter], 0, 0, 28*2, 34*2, 73, 29, 45, 63);
    } else {
      image(sprite[spriteCounter], 0, 0, 28*2, 34*2, 45, 29, 73, 63);
    }

    popMatrix();
    popMatrix();

    // depending on the orientation, changing the anchor point to the top left of the image
    if (orientation == 0) {
      anchorX = x; 
      anchorY = y;
    } else if (orientation == 1) {
      anchorX = x; 
      anchorY = y - chHeight;
    } else if (orientation == 2) {
      anchorX = x - chWidth; 
      anchorY = y - chHeight;
    } else if (orientation == 3) {
      anchorX = x - chWidth; 
      anchorY = y;
    }


    // if it doesn't collide with the ground, the gravity gets applied depending on what the orientation of the player is
    if (!collides()) {
      if (orientation == 0 || orientation == 2) {
        y += gravity;      // apply gravity in the y direction for orientations 0 and 2
      } else {
        x += gravity;      // and in the x direction for orientations 1 and 3
      }
      gravity += acc;      // for acceleration
    }

    // setting restraints for the character in all directions
    if (anchorX < (width - game.boxWidth)/2 + game.borderWidth) {
      anchorX = (width - game.boxWidth)/2 + game.borderWidth;
    }
    if (anchorX + chWidth > (width + game.boxWidth)/2 - game.borderWidth) {
      anchorX = (width + game.boxWidth)/2 - chWidth - game.borderWidth;
    } 

    if (anchorY < (height - game.boxHeight)/2 + game.borderWidth) {
      anchorY = (height - game.boxHeight)/2 + game.borderWidth;
    }
    if (anchorY + chHeight > (height + game.boxHeight)/2 - game.borderWidth) {
      anchorY = (height + game.boxHeight)/2 - game.borderWidth - chHeight;
    }
  }

  // checking collision on the basis of the position of the rectangles on all sides
  boolean collides() {
    // since each orientation has a different "ground", we check it accordingly

    if (player.orientation == 0 && (anchorY + chHeight) < (height + game.boxHeight)/2 - game.borderWidth) return false;
    if (player.orientation == 1 && anchorX + chWidth < (width + game.boxWidth)/2 - game.borderWidth) return false;
    if (player.orientation == 2 && (anchorY > (height - game.boxHeight)/2 + game.borderWidth)) return false;
    if (player.orientation == 3 && anchorX > (width - game.boxWidth)/2 + game.borderWidth) return false;
    return true;
  }
}

// class for the orbs
class Orb {
  float radius = 20;
  float x, y;
  String type = "blue_orb";    // type of orbs
  PImage blue_orb = loadImage("images/blue-orb.png");
  PImage green_orb = loadImage("images/green-orb.png");
  PImage yellow_orb = loadImage("images/yellow-orb.png");

  Orb(float xpos, float ypos, String foodType) {
    x = xpos;
    y = ypos;
    type = foodType;
  }

  void update(int i) {
    // displaying corresponding image
    if (type == "blue_orb") image(blue_orb, x, y, radius, radius);
    if (type == "green_orb") image(green_orb, x, y, radius, radius);
    if (type == "yellow_orb") image(yellow_orb, x, y, radius, radius);

    if (objectCollides()) {
      orbs.remove(i);      // removing orb when collides with player
      playHead.play();     // play the orb pickup sound
      playHead.rewind();
    }
  }

  // checking if the object falls within the player
  boolean objectCollides() {
    if (x + radius >= player.anchorX && x < player.anchorX + player.chWidth && y + radius >= player.anchorY && y < player.anchorY + player.chHeight) {
      return true;
    }
    return false;
  }
}


Game game;
Player player;
ArrayList<Orb> orbs = new ArrayList<Orb>();      // array for orbs
PImage background;                               // variable for the background star image

// method that takes care of instantiating and stuff
void init() {
  game = new Game();
  player = new Player();

  // instantiating 10 orbs
  for (int i = 0; i < 10; i++) {
    // randomizing the position within the box
    float x = random((width - game.boxWidth)/2 + game.borderWidth, (width + game.boxWidth)/2 - game.borderWidth - 10);    // radius value = 10
    float y = random((height - game.boxHeight)/2 + game.borderWidth, (height + game.boxHeight)/2 - game.borderWidth - 10);
    String temp;
    float randomNum = random(0, 1);
    // setting up the rarity of the orbs
    if (randomNum < 0.05) {
      temp = "green_orb";
    } else if (randomNum < 0.4) {
      temp = "yellow_orb";
    } else {
      temp = "blue_orb";
    }

    Orb orb = new Orb(x, y, temp);
    // making sure that the orbs don't spawn on the player
    if (!orb.objectCollides())
      orbs.add(orb);
  }
}

void setup() {
  size(1000, 1000);
  // loading the bg image
  background = loadImage("images/bg.png");

  // loading minim
  minim = new Minim(this);

  // the bg music plays on loop
  bgPlayHead = minim.loadFile("bgMusic.mp3");
  bgPlayHead.play();
  bgPlayHead.loop();
  playHead = minim.loadFile("orb.mp3");    // loading hit sound on collision
  init();
} 

void draw() {
  background(0);
  image(background, 0, 0, width, height);

  // calling different methods on the game depending on the state
  if (game.state == "menu") {
    game.menu();
  } else if (game.state == "play") {
    game.update();
    player.update();
    for (int i = 0; i < orbs.size(); i++) {
      orbs.get(i).update(i);
    }
  } else if (game.state == "over") {
    game.over();
  }
  //ellipse(player.anchorX, player.anchorY, 5, 5);    // really helpful to find the collision box of the character
}

// game controls
void keyPressed() {
  // enter to the game 
  if (game.state == "menu" && keyCode == ENTER) {
    game.state = "play";
  }

  // restarting at the end screen
  if (game.state == "over" && key == 'r') {
    init();
  }

  // to exit
  if (key == 'e') {
    exit();
  }

  // character movement
  if (keyCode == LEFT) {
    // when upside down, the left and right of the character is messed up and the sprite is inverted
    // so it is necessary to change it like this for proper display
    if (player.orientation == 0) player.left = true;
    if (player.orientation == 2) player.right = true;
    player.anchorX -= player.speed;
  } else if (keyCode == RIGHT) {
    if (player.orientation == 0) player.right = true;
    if (player.orientation == 2) player.left = true;
    player.anchorX += player.speed;
  }

  // same here
  if (keyCode == UP) {
    if (player.orientation == 1) player.right = true;
    if (player.orientation == 3) player.left = true;
    player.anchorY -= player.speed;
  } else if (keyCode == DOWN) {
    if (player.orientation == 1) player.left = true;
    if (player.orientation == 3) player.right = true;
    player.anchorY += player.speed;
  }

  // since we used the anchor values everywhere
  // we update the actual x and y values to display the image with the use of the anchor point
  // this needs to be done per orientation
  if (player.orientation == 0) {
    player.x = player.anchorX;
    player.y = player.anchorY;
  } else if (player.orientation == 1) {
    player.x = player.anchorX; 
    player.y = player.anchorY + player.chHeight;
  } else if (player.orientation == 2) {
    player.x = player.anchorX + player.chWidth;
    player.y = player.anchorY + player.chHeight;
  } else if (player.orientation == 3) {
    player.x = player.anchorX + player.chWidth; 
    player.y = player.anchorY;
  }

  // pressing space to change the orientation
  if (game.state == "play" && keyCode == ' ') {
    player.gravity = 0;
    player.orientation = (player.orientation + 1) % 4;

    // when coming back to orientation 0 from 4 and 2 from 1, the gravity and acceleration need to be inverted
    if (player.orientation == 0) {
      player.gravity *= -1; 
      player.acc *= -1;
    }
    if (player.orientation == 2) {
      player.gravity *= -1; 
      player.acc *= -1;
    }

    // need to flip the width and height of character when image is changed per orientation
    float temp = player.chWidth;
    player.chWidth = player.chHeight;
    player.chHeight = temp;
  }
}

// to keep track of key press for the sprite
void keyReleased() {
  player.left = false;
  player.right = false;
}
