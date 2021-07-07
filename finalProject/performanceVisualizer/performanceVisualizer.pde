/*
Name: Safal Shrestha
Date: July 8th, 2021
Performance Visualizer, Intro to IM, Summer 2021
*/


// importing necessary libraries
import processing.sound.*;
import processing.serial.*;

// delcaring some global variables
FFT fft;
AudioIn in;
int bands = 512;
float[] spectrum = new float[bands];

Serial port;

// value we get from arduino
String response;

float colorValue = 1;          // hue of the color
float increment = 0.1;         // increment for the hue

float rotation = 80;           // initial rotation of the sphere grid
float rotationInc = 0.001;     // initial rotation increment in the sphere grid

float r, g, b;                 // r, g, b values of the background color

// number of tiles and tileSize
float tiles = 15;
float tileSize;

//gameState value which determines if the sketch is paused or not
int gameState = 0;

void setup() {
  String portName = Serial.list()[2];
  port = new Serial(this, portName, 9600);
  port.bufferUntil('\n');

  size(1000, 1000, P3D);

  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, bands);
  in = new AudioIn(this, 0);

  // start the Audio Input
  in.start();

  // patch the AudioIn
  fft.input(in);

  // dynamically calculating the tileSize
  tileSize = width/tiles;
}

void draw() {
  // changing color mode
  colorMode(HSB);

  // storing the previous increment to keep track of the direction that the color was incrementing in
  // this prevents the color from getting stuck at a point
  float prevIncrement = increment;
  increment = map(rotation, 0, 80, 1, 0.1);
  if (prevIncrement < 0) increment *= -1;
  if (colorValue <= 0 || colorValue > 255) increment *= -1;

  colorValue += increment;
  color c = color(colorValue, 150, 200);

  // extracting r, g, b values
  r = c >> 16 & 0xFF;
  g = c >> 8 & 0xFF;
  b =  c & 0xFF;

  background(c);

  // changing the color mode back to rgb
  colorMode(RGB);

  // mapping the mouse values for the directional light
  float x = map(mouseX, 0, width, 1, -1);
  float y = map(mouseY, 0, height, 1, -1);

  directionalLight(51, 102, 126, x, y, -1);
  ambientLight(150, 150, 150);

  // analyzing the audio
  fft.analyze(spectrum);

  int counter = 0;

  for (int i = 0; i < tiles; i++) {
    for (int j = 0; j < tiles; j++) {
      if (i * tiles + j < spectrum.length) {
        \
        // mapping the frequency value from 0 to 200
        int size = (int)map(spectrum[counter], 0, 0.1, 0, 200);
        int z = constrain(size, 0, 200);

        pushMatrix();

        // translating the whole grid to the center
        translate(width/2, height/2, -500);

        // initial rotation to get the desired perspective
        rotateX(radians(rotation));
        rotateZ(radians(80 - rotation));

        if (gameState == 0) {
          z = 0;              // stop the spheres from bouncing if gameState is off
        } else {
          // if the spheres are jumping around, we rotate
          if (size > 0.8 && rotation >= 0) rotation -= rotationInc * 2;
          else {
            if (rotation < 80) rotation += rotationInc * 2;
          }
        }

        // placing each sphere on the grid concisely 
        translate(i*int(tileSize) - (int(tileSize)*tiles)/2, j*int(tileSize) - (int(tileSize)*tiles)/2, z);

        noStroke();

        fill(255);
        sphere(20);
        counter++;
        popMatrix();
      }
    }
  }
}

void serialEvent(Serial myPort) {
  response = myPort.readStringUntil('\n');
  response = trim(response);
  int[] values = int(split(response, ','));

  // values[0] has the gameState value from arduino
  // values[1] has the LDR sensor value
  gameState = values[0];
  if (gameState == 1) {
    tileSize = map(values[1], 300, 700, 200, width/tiles);
  } 
  // writing the rgb value to arduino
  myPort.write(int(r) + "," + int(g) + "," + int(b)+"\n");
}
