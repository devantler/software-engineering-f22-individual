#include <analogWrite.h>

const int liftMotorPin1 = 14;
const int liftMotorPin2 = 12;
const int liftMotorEnablePin = 13;
const int photoResistorPin = 34;

const int blackThreshold = 300;
const int whiteThreshold = 1800;

//float distanceBetweenDiscAndCrane = 100; // in mm
//float wheelCircumference = 141.37; // in mm
//float wheelStepCount = 12;
//const int stepsToTake = ceil(distanceBetweenDiscAndCrane / (wheelCircumference / wheelStepCount));
int lastPhotoResistorVal;

void setup() {
  Serial.begin(115200);
  while (!Serial)
  {
    // Waiting until serial is connected
  };
  Serial.println("Serial connected");
  pinMode(liftMotorPin1, OUTPUT);
  pinMode(liftMotorPin2, OUTPUT);
  pinMode(liftMotorEnablePin, OUTPUT);
  lastPhotoResistorVal = analogRead(photoResistorPin);
}

void loop() {
  int targetSpeed;

  Serial.println("Set a target speed (0-255)");
  while(true){ 
    targetSpeed = Serial.readString().toInt();
    if(targetSpeed > 0 && targetSpeed <= 255){
      Serial.println("Target speed: " + String(targetSpeed));
      break;
    }
  }

  int stepsTaken = 0;
  int oldTime = 0;
  //enableMotor(true, targetSpeed);
  lastPhotoResistorVal = analogRead(photoResistorPin);
  while(stepsTaken <= 11){
    if(checkSteps()){
      int newTime = millis();
      stepsTaken++;
      int timeTaken = newTime - oldTime;
      Serial.println("steps: " + String(stepsTaken) + ", time:" + String(timeTaken));
      oldTime = newTime;   
    }
  }
  //disableMotor();
}

bool checkSteps() {
    int currentPhotoResistorVal = analogRead(photoResistorPin);
    Serial.println("sensor val: " + String(currentPhotoResistorVal));
    if (isSteppingFromBlackToWhite(lastPhotoResistorVal, currentPhotoResistorVal) ||
        isSteppingFromWhiteToBlack(lastPhotoResistorVal, currentPhotoResistorVal))
    {
        lastPhotoResistorVal = currentPhotoResistorVal;
        return true;
    }
    return false;
}

bool isSteppingFromBlackToWhite(int lastPhotoResistorVal, int currentPhotoResistorVal)
{
    return isSensingBlack(lastPhotoResistorVal) && isSensingWhite(currentPhotoResistorVal);
}

bool isSteppingFromWhiteToBlack(int lastPhotoResistorVal, int currentPhotoResistorVal)
{
    return isSensingWhite(lastPhotoResistorVal) && isSensingBlack(currentPhotoResistorVal);
}

bool isSensingBlack(int sensingVal)
{
    return sensingVal < 300;
};

bool isSensingWhite(int sensingVal)
{
    return sensingVal > 1700;
};

void enableMotor(bool direction, uint8_t speed)
{
    if (direction)
    {
        analogWrite(liftMotorEnablePin, speed);
        digitalWrite(liftMotorPin1, LOW);
        digitalWrite(liftMotorPin2, HIGH);
    }
    else
    {
        analogWrite(liftMotorEnablePin, speed);
        digitalWrite(liftMotorPin1, HIGH);
        digitalWrite(liftMotorPin2, LOW);
    }
}

void disableMotor()
{
    analogWrite(liftMotorEnablePin, 0);
    digitalWrite(liftMotorPin1, LOW);
    digitalWrite(liftMotorPin2, LOW);
}
