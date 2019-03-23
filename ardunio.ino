#include "EmonLib.h"                   // Include Emon Library
EnergyMonitor e1;                   // Create an object

void setup()
{  
  Serial.begin(9600);
  
  e.current(1, 111.1);             // Current: input pin, calibration.
}

void loop()
{
  double Irms = e.calcIrms(1480);  // Calculate Irms only
  
  Serial.println(2.1*((Irms*220.0)-3.80));         // Apparent power


  //Testing department below :-
  
  //Serial.print(" ");
  //Serial.println(Irms);          // Irms
}