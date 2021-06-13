/*
Name: Safal Shrestha
Date: June 14, 2021
LED puzzle: SOS morse code
*/

// pins for the two switches
const int redPushButton = A2;
const int yellowPushButton = 4;

// pins for the two wires for the led
const int redPin = 13;
const int yellowPin = 8;

// string to hold the value pressed on arduino: redPush is 1 and yellowPush is 0
String output = "";

// boolean to see if the exact code has been pressed or not
bool helpCalled = false;

// boolean values to stop the 1s and 0s to be added continuously while the switch is on
bool redButtonPressed = false;
bool yellowButtonPressed = false;

void setup() {
  Serial.begin(9600);

  // assinging output and input
  pinMode(redPushButton, INPUT);
  pinMode(yellowPushButton, INPUT);
  pinMode(redPin, OUTPUT);
  pinMode(yellowPin, OUTPUT);
}

void loop() {
  // checking if the switches have been turned on
  int redButtonState = digitalRead(redPushButton);
  int yellowButtonState = digitalRead(yellowPushButton);
  // print out the state of the button:
//  Serial.println(redButtonState);
//  Serial.println(yellowButtonState);
//  Serial.println();
//  Serial.println(output);
//  Serial.println();
  delay(1);        // delay in between reads for stability

  // if both buttons are pressed, we reset the process
  if (redButtonState == 1 && yellowButtonState == 1) {
    output = "";
    helpCalled = false;
  }

  // if the code becomes correct 
  if (helpCalled) {
    // we start blinking the lights
    digitalWrite(yellowPin, HIGH);
    digitalWrite(redPin, HIGH);
    delay(100);
    digitalWrite(yellowPin, LOW);
    digitalWrite(redPin, LOW);
    delay(100);
  } else {
    // 111000111 is the morse code for S.O.S which is the code that the user needs to enter
    if (output == "111000111") helpCalled = true;

    // if the button is being pressed for the first time we add 1 to the output
    if (redButtonPressed == false && redButtonState == 1) {
      output += "1";
      redButtonPressed = true;
    }
    
    // when red button is lifted, we change the boolean redButtonPressed
    if (redButtonState == 0) redButtonPressed = false;

    // similar approach to the yellow button
    if (yellowButtonPressed == false && yellowButtonState == 1) {
      output += "0";
      yellowButtonPressed = true;
    }
    if (yellowButtonState == 0) yellowButtonPressed = false;
  }
}
