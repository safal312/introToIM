/*
Name: Safal Shrestha
Date: May 27, 2021
Intro to IM, Summer 2021
*/

void setup() {
  size(500, 500);
  background(255);
}

void draw() {
  fill(255);
  noStroke();
  
  // don't generate anything if the mouse isn't moving
  if (pmouseX != mouseX) {
    for (int i = 0; i < 3; i++) {
      
      // random value that decides which shape is generated
      int x = round(random(3));
      
      // randomizing the color
      fill(round(random(255)), round(random(255)), round(random(255)));
      if (x == 0) {
        ellipse(mouseX, mouseY, 100, 100);
      } else if (x == 1) {
        rect(mouseX, mouseY, 100, 100);
      } else if (x == 2) {
        rotate(PI/3);
        rect(mouseX, mouseY, 100, 100);
      } else if (x == 3) {
        rotate(PI);
        rect(mouseX, mouseY, 100, 100);
      }
    }
  }
}

void mouseClicked() {
  save("output.jpg");
}
