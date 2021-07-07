/*
Name: Safal Shrestha
Date: July 8th, 2021
Performance Visualizer, Intro to IM, Summer 2021
*/

// storing pin values
const int startBtn = 2
const int ldrBtn = A5;

const int redPin = 9;
const int greenPin = 10;
const int bluePin = 11;

const int pauseLed = 5;

// global variable to store the on or off value
boolean state = false;
int ldrBtnState;

// initial r, g, b value
int r = 222;
int g = 84;
int b = 82;

void setup() {
  Serial.begin(9600);
  // initiating handshaking
  Serial.println("0,0");
  // setting pin modes
  pinMode(startBtn, INPUT);
  pinMode(ldrBtn, INPUT);

  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);

  pinMode(pauseLed, OUTPUT);
}

// helper variable to make sure that the button is only pressed once
boolean startBtnPressed = false;

void loop() {
  // turning on the LED only when the state is off, or there is no visualization
  digitalWrite(pauseLed, !state);

  // writing the r, g, b value to the RGB light
  analogWrite(redPin, r);
  analogWrite(greenPin, g);
  analogWrite(bluePin, b);

  // listening for the start button press
  int startBtnState = digitalRead(startBtn);
  if (!startBtnPressed && startBtnState == 1) {
      state = !state;
      startBtnPressed = true;
  }
  // start button released
  if (startBtnState == 0) startBtnPressed = false;

  // getting ldr sensor value
  ldrBtnState = analogRead(ldrBtn);

  // send the data only when some data is available on the Serial port from processing
  if (Serial.available()) {
    // parsing the r, g, b values we get from processing
    r = Serial.parseInt();
    g = Serial.parseInt();
    b = Serial.parseInt();

    // send the gameState and ldr values
    Serial.print(state);
    Serial.print(",");
    Serial.println(ldrBtnState);
  }
  delay(50);
}
