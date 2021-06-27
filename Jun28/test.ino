/* 
 Name: Safal Shrestha
 June 28, 2021
 Title: Single player pingpong game with Arduino implementation
 Intro to IM, Summer 2021
 */

// string to store incoming value from processing
String val;

// setting up some variables
const int upButton = 5;
const int downButton = 6;
int upButtonState, downButtonState;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  // initiating handshaking
  Serial.println("0,0");
  pinMode(upButton, INPUT);
  pinMode(downButton, INPUT);
}

void loop() {
  // getting the state of our two buttons
  upButtonState = digitalRead(upButton);
  downButtonState = digitalRead(downButton);

  // send the data only when some data is available on the Serial port from processing
  if (Serial.available()) {
    Serial.print(upButtonState);
    Serial.print(",");
    Serial.println(downButtonState);
  }
  delay(50);
}
