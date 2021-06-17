/*
Name: Safal Shrestha
June 17, 2021
Blinking Lights with LDR
*/

const int pushButton = 2;     // pin for reading from button
const int blueLedPin = 7;     // pin for the blue LED
const int redLedPin = 6;      // pin for the red LED
const int ldrPin = A5;        // pin to get reading from LDR
int increment = 5;            // increment for the LED light

void setup() {
  Serial.begin(9600);
  // setting pin modes
  pinMode(pushButton, INPUT);
  pinMode(blueLedPin, OUTPUT);
  pinMode(redLedPin, OUTPUT);
  pinMode(ldrPin, INPUT);
}

void loop() {
  // reading from button
  int buttonState = digitalRead(pushButton);
  // reading from LDR
  int ldrOut = analogRead(ldrPin);

  if (buttonState == 1) {
    // turning on the blue light when switch is on 
    digitalWrite(blueLedPin, HIGH);
  } else {
    digitalWrite(blueLedPin, LOW);
  }

  // getting brightness value from ldr sensor,, this is the max brightness that the LED can have when blinking
  int brightness = map(ldrOut, 650, 750, 0, 180);
  // the brightness increases quicker when the ldr value is low and increases slowly when it is high
  int increment = map(ldrOut, 650, 800, 20, 5);

  // loop to increase brightness gradually
  for (int i = 0; i <= brightness; i += increment) {
    analogWrite(redLedPin, i);
    delay(2);
  }
  delay(100);
//  // loop to decrease brightness gradually
  for (int i = brightness; i > 0; i -= increment) {
    analogWrite(redLedPin, i);
    delay(2);
  }
  
  delay(100);        // delay in between reads for stability
}
