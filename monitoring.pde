/*
  Blink
  Turns on an LED on for one second, then off for one second, repeatedly.
 
  This example code is in the public domain.
 */

#include <avr/interrupt.h>  
#include <avr/io.h>

#include <Servo.h>
#define CLICK 10
#define TRACKER 12
#define ORDER 11
#define INSCREEN 9

Servo myservo;

unsigned long time = millis();

void setup() {                
  // initialize the digital pin as an output.
  // Pin 13 has an LED connected on most Arduino boards:
  pinMode(CLICK, OUTPUT); 
  pinMode(TRACKER, OUTPUT);  
  pinMode(ORDER, OUTPUT);
  pinMode(INSCREEN, OUTPUT);
  Serial.begin(115200);
  myservo.attach(8);
  
}

unsigned int actions = 0;

void loop() {
  
  int ma[101];
  memset(ma, 0, 101);
  
  while(Serial.available() > 0){
    int data = Serial.read();
    int pin = 0;
    
    switch(data){
     case 'c': pin = CLICK; break;
     case 't': pin = TRACKER; break;
     case 'o': pin = ORDER; break;
     case 'I': pin = INSCREEN; break;     
    }
    
    actions++;
    if(millis() - time > 50) {
      int i = 0;
      for (i = 0; i < 100; ++i) {
        ma[i] = ma[i+1];
      }
      ma[100] = actions * 20;
      int sum = 0;
      for (i = 0; i < 100; ++i) {
        sum += ma[i];
      }
      myservo.writeMicroseconds((sum / 100) + 700);
      actions = 0;
      time = millis();
    }
    
    if(pin != 0){
      digitalWrite(pin, HIGH);   // set the LED on
      delay(10);              // wait for a second
      digitalWrite(pin, LOW);    // set the LED off
    }
  }
  
}
