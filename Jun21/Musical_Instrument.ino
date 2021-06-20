/*
  Name: Safal Shrestha
  June 17, 2021
  Musical Instrument
*/

const int ldrPin = A5;        // pin to get reading from LDR
const int tonePin = 8;        
const int yellowPushBtn = 3;
const int redPushBtn = 2;
// setting default values to play when the arduino has just started and yellow button isn't being pressed
int ldrOut = 500;
int freq = 100;
// boolean value to turn the device on and off completely
boolean on = false;
// helper variable for switching on/off action 
boolean redBtnPressed = false;

void setup() {
  Serial.begin(9600);
  // setting pin modes
  pinMode(ldrPin, INPUT);
  pinMode(yellowPushBtn, INPUT);
  pinMode(redPushBtn, INPUT);
}

void loop() {
  // reading from the red button
  int redBtnState = digitalRead(redPushBtn);
  if (redBtnState == 1 && !redBtnPressed) {
    // toggling the on value after pressing the red button
    on = !on;  
    redBtnPressed = true;
  } else {
    redBtnPressed = false;  
  }

  // code to run after we turn on the device by pressing the red button
  if (on) {
    // reading the yellow button state
    int yellowBtnState = digitalRead(yellowPushBtn);
    // only taking values when the yellow button is pressed
    // this allows us to achieve delays between notes when we're not pressing the button
    if (yellowBtnState == 1) {
      // getting the ldr value and mapping the frequency
      ldrOut = analogRead(ldrPin);
      freq = map(ldrOut, 500, 700, 50, 1000);
      // constraining the freq because I got a negative value at random points
      freq = constrain(freq, 50, 1000);
    }
    // playing the desired tone
    tone(tonePin, freq);
  } else {
     noTone(tonePin);
   }
  delay(500);

}
