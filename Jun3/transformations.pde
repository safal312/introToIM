/*
Name: Safal Shrestha
 Date: 3 June, 2021
 I wanted to make something with the use of angles and translations,
 so I went on to make something that looks like colorful veins growing
 */

// this class represents the rectangles being drawm
class Petal {
  int rectWidth = 30;
  int rectHeight = 10;

  // this method is called every frame with new variables
  void display(float x, float y, float angle) {
    pushMatrix();
    translate(x, y);
    rotate(radians(angle));
    noStroke();
    fill(random(255), random(255), random(255));    // randomizing colors
    rect(0, 0, rectWidth, rectHeight);
    popMatrix();
  }
}

void setup() {
  size(800, 800);
  frameRate(60);
  background(186, 255, 179);
}

// starting from a random angle, width, height
float angle = random(0, 360);
float xpos = random(width);
float ypos = random(height);
int increment = 10;    // variable for segments in a circle
Petal one = new Petal();

void draw() {
  one.display(xpos, ypos, angle);

  if (xpos > width + one.rectWidth || ypos > height + one.rectHeight) {
    xpos = random(width);
    ypos = random(height);
    //background(255);
  }
  
  if (abs(angle) >= 360) {
    angle = angle % 360;    // restricting angle
    xpos += random(50);
    ypos += random(50);
    increment = round(random(1, 5)) * 10 % 60;    // ramdomizing segments
  }


  angle = angle + increment;
}
