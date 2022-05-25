#include "Stepper.h"
#include "Arduino.h"
#include "crane_elevation.h"

// Pins
const int magnetPin = 2;
const int stepperMotorPin1 = 15, stepperMotorPin2 = 32, stepperMotorPin3 = 33, stepperMotorPin4 = 25;

// Other variables
const int stepsPerRevolution = 20200;
int currentAngle = 0;


Stepper revolutionStepper(stepsPerRevolution, stepperMotorPin1, stepperMotorPin2, stepperMotorPin3, stepperMotorPin4);

void setupCrane()
{
  revolutionStepper.setSpeed(4);
  setupElevationControls();
  pinMode(magnetPin, OUTPUT);
}

void gotoAngle(int angle)
{
  if (angle > 359)
  {
    Serial.print("Angle is too large: " + angle);
    return;
  }
  if (angle < 0)
  {
    Serial.print("Angle is negative: " + angle);
    return;
  }
  int degreesToMove = (angle - currentAngle);

  moveDegrees(degreesToMove);
  currentAngle = angle;
  delay(100);
  digitalWrite(stepperMotorPin1, LOW);
  digitalWrite(stepperMotorPin2, LOW);
  digitalWrite(stepperMotorPin3, LOW);
  digitalWrite(stepperMotorPin4, LOW);
}

void toggleMagnet(int powerOn)
{
  if (powerOn == 1)
  {
    digitalWrite(magnetPin, HIGH);
  }
  else
  {
    digitalWrite(magnetPin, LOW);
  }
}

void moveDegrees(int degrees)
{
  if (degrees < -100 || degrees > 100)
  {
    int splitDegrees = degrees / 3;
    revolutionStepper.step(splitDegrees * 112);
    revolutionStepper.step(splitDegrees * 112);
    revolutionStepper.step((degrees - (2 * splitDegrees)) * 112);
  }
  else
  {
    int stepsToGo = degrees * 112;
    revolutionStepper.step(stepsToGo);
  }
}

void toggleElevation(int direction)
{
  if (direction == 1)
  {
    raise();
  }
  else if (direction == 0)
  {
    lower();
  }else{
    publish("log/disk1/error", (char*)"Don't send me garbage");
  }
}
