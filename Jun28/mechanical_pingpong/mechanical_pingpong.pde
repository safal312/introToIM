/* 
 Name: Safal Shrestha
 June 28, 2021
 Title: Single player pingpong game with Arduino implementation
 Intro to IM, Summer 2021
 */

//importing the minim library
import ddf.minim.*;
import processing.serial.*;

Minim minim;
AudioPlayer player;
Serial myPort;
String response;

int score = 0;    // variable for the score
boolean gameOverSoundPlayed = false;    // boolean value that'll ensure that the game over music is only played once

// setting up variables
float b_xpos, b_ypos, b_xvel, b_yvel, b_radius,   // variables for the ball 
      p_xpos, p_ypos, pwidth, pheight;      // variables for the player

// initialization
void initialize() {
  // setting values to the global game variables
  score = 0;
  gameOverSoundPlayed = false;

  b_xpos = 100;
  b_ypos = round(random(height));
  b_xvel = 2.5;
  b_yvel = 2.5;
  b_radius = 20;

  p_xpos = 40;
  p_ypos = height/2;
  pwidth = 20;
  pheight = 100;
}

void setup() {
  String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');
  initialize();
  size(800, 600);
  minim = new Minim(this);
  player = minim.loadFile("sounds/hit.mp3");    // loading hit sound on collision
}

void draw() {
  background(0);
  textSize(24);
  fill(255);
  // placing the score
  text("SCORE", width - 100, 50);
  text(score, width - 70, 80);

  // if the ball is beyond player's x position, game is over
  if (b_xpos > p_xpos + pwidth) {
    noStroke();
    fill(0, 255, 100);
    //setting boundaries for the ball
    if (b_xpos > width) {
      b_xvel *= -1;
      player.play();    // play the collision sound whenever ball hits the boundaries
      player.rewind();  // then reset it
    }
    if (b_ypos > height || b_ypos < 0) {
      b_yvel *= -1;
      player.play();
      player.rewind();
    }
    b_xpos += b_xvel;
    b_ypos += b_yvel;
    ellipse(b_xpos, b_ypos, b_radius, b_radius);

    // restricting player from going over the boundaries
    if (p_ypos < 0) p_ypos = 0;
    if (p_ypos + pheight > height) p_ypos = height - pheight;
    rect(p_xpos, p_ypos, pwidth, pheight);
    checkCollision();
  } else {
    gameOver();
  }
}

void checkCollision() {
  // simple collision detection
  if ((b_xpos - (b_radius/2)) <= (p_xpos + pwidth) && (b_ypos + (b_radius/2)) >= p_ypos && (b_ypos) <= p_ypos + pheight) {

    // calculating how far the ball lands from the center of the moving bar
    // then changing the y-speed according to it
    float yforce = (b_ypos - (p_ypos + (pheight / 2)))/(pheight/2);
    b_xvel *= -1.1;    // reflecting the ball on x-axis on collision
    b_yvel = yforce * 3;    // amlifying the yforce value
    player.play();    // play collision sound
    player.rewind();
    score += 10;    // increasing the score
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
    initialize();
    player = minim.loadFile("sounds/hit.mp3");    // loading the hit sound again to the player
    gameOverSoundPlayed = false;
    score = 0;
  }
  if (keyCode == UP) {
    p_ypos -= 10;
  } else if (keyCode == DOWN) {
    p_ypos += 10;
  }
}

// boolean value to help us reset the game only once
boolean resetPressed = false;

void serialEvent(Serial myPort) {
  response = myPort.readStringUntil('\n');
  response = trim(response);
  int[] values = int(split(response, ','));
  if (values.length == 2) {
    if (values[0] == 1 && values[1] == 1 && !resetPressed) {
       // reinitializing variables
      resetPressed = true;
      initialize();
      player = minim.loadFile("sounds/hit.mp3");    // loading the hit sound again to the player
      gameOverSoundPlayed = false;
      score = 0;
    } else if (values[0] == 1) {
      p_ypos -= 10;
    } else if (values[1] == 1) {
      p_ypos += 10;
    } else if (values[0] == 0 && values[1] == 0) {
      resetPressed = false;        // we allow reset again after both the buttons are released after pressing together
    }
  }
  myPort.write(1);
  
}
