/*
Name: Safal Shrestha
Date: 04 June 2021
Abstract print effect
*/

PImage picture;

void setup() {
  size(500, 300);
  picture = loadImage("images/image.jpg");    // loading our main image
  picture.resize(width, 0);                   // reducing size proportionally
  image(picture, 0, 0);
}

void draw() {
  
  for (int i = 0; i < width*height; i++) {

    loadPixels();      // loading pixels of the canvas
    
    // extracting each pixel's rgb values
    color pixel = pixels[i];  
    int r = (int)red(pixel);
    int g = (int)green(pixel);
    int b = (int)blue(pixel);
    
    // calculating the brightness
    int brightness = (r+g+b)/3;
    
    // changing brightness to either totally black or white
    if (brightness < 128) {
      brightness = 0;
    } else {
      brightness = 255;
    }

    // filling the pixel with that particular color
    pixels[i] = color(brightness);

    updatePixels();
  }
  
  // saving the black and white image once
  save("out.jpg");
  
  // loading the black and white image
  PImage bw = loadImage("out.jpg");
  bw.resize(width/2, 0);      // resizing it to fit in half of the window
  
  // displaying the images in four sections to give a mirror-like effect
  image(bw, 0, 0, bw.width, bw.height, bw.width, 0, 0, bw.height);
  image(bw, width/2, 0);
  image(bw, 0, bw.height, bw.width, bw.height, bw.width, bw.height, 0, 0);
  image(bw, width/2, bw.height, bw.width, bw.height, 0, bw.height, bw.width, 0);
  
  // save the output
  save("out.jpg");
  
  noLoop();    // only run the loop once
}
