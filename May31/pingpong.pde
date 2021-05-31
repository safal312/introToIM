/* 
 Name: Safal Shrestha
 May 31, 2021
 Title: Single player pingpong game
 Intro to IM, Summer 2021
 */

//importing the minim library
import ddf.minim.*;

Minim minim;
AudioPlayer player;

//class for the ball
class Ball {
  float xpos = 20;
  float ypos;
  float xvel = 2.5;
  float yvel = 2.5;
  float radius = 20;
  Ball (float x, float y) {
    xpos = x;
    ypos = y;
  }
  void update() {
    //setting boundaries for the ball
    if (xpos > width) {
      xvel *= -1;
      player.play();    // play the collision sound whenever ball hits the boundaries
      player.rewind();  // then reset it
    }
    if (ypos > height || ypos < 0) {
      yvel *= -1;
      player.play();
      player.rewind();
    }
    xpos += xvel;
    ypos += yvel;
    ellipse(xpos, ypos, radius, radius);
  }
}

// class for the player
class Player {
  float xpos = 40;
  float ypos = height/2;
  float pwidth = 20;
  float pheight = 100;
  void update() {
    // restricting player from going over the boundaries
    if (ypos < 0) ypos = 0;
    if (ypos + pheight > height) ypos = height - pheight;
    rect(xpos, ypos, pwidth, pheight);
    collides(b);
  }
  void collides(Ball b) {
    // simple collision detection
    if ((b.xpos - (b.radius/2)) <= (xpos + pwidth) && (b.ypos + (b.radius/2)) >= ypos && (b.ypos) <= ypos + pheight) {

      // calculating how far the ball lands from the center of the moving bar
      // then changing the y-speed according to it
      float yforce = (b.ypos - (p.ypos + (p.pheight / 2)))/(pheight/2);
      b.xvel *= -1.1;    // reflecting the ball on x-axis on collision
      b.yvel = yforce * 3;    // amlifying the yforce value
      player.play();    // play collision sound
      player.rewind();
      score += 10;    // increasing the score
    }
  }
}

// initialization
Ball b;
Player p;
int score = 0;
boolean gameOverSoundPlayed = false;    // boolean value that'll ensure that the game over music is only played once

void setup() {
  size(800, 600);
  minim = new Minim(this);
  player = minim.loadFile("sounds/hit.mp3");
  b = new Ball(100, round(random(height)));
  p = new Player();
}

void draw() {
  background(0);
  textSize(24);
  fill(255);
  // placing the score
  text("SCORE", width - 100, 50);
  text(score, width - 70, 80);

  // if the ball is beyond player's x position, game is over
  if (b.xpos > p.xpos + p.pwidth) {
    noStroke();
    fill(0, 255, 100);
    b.update();
    p.update();
  } else {
    gameOver();
  }
}

void gameOver() {
  background(0, 255, 100);
  fill(0);
  text("Score: " + score, width/2 - 70, height/2 + 65);
  text("Press 'r' to restart", width/2 - 120, height/2 + 100);
  textSize(64);
  text("Game Over", width/2 - 180, height/2);

  if (!gameOverSoundPlayed) {
    player = minim.loadFile("sounds/gameover.mp3");  
    player.play();
    player.rewind();
    gameOverSoundPlayed = true;
  }
}

void keyPressed() {
  if (key == 'r') {
    // reinitializing variables
    b = new Ball(100, round(random(height)));
    p = new Player();
    player = minim.loadFile("sounds/hit.mp3");    // loading the hit sound again to the player
    gameOverSoundPlayed = false;
    score = 0;
  }
  if (keyCode == UP) {
    p.ypos -= 10;
  } else if (keyCode == DOWN) {
    p.ypos += 10;
  }
}
