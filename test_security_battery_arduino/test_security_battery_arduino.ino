//Minimum voltage required for an alert
const double MIN_VOLTAGE = 1.2;

//Battery indicator
const int BATTERY_LED = A2;

//Battery measure pin
const int BATTERY_PIN = A3;

//Current battery charge
double batteryCharge;

void setup() {
  // Iniciamos el monitor serie
  Serial.begin(9600);

  // Ouput pin definition for BATTERY_LED
  pinMode(BATTERY_LED,OUTPUT);

  //Input pin definition for battery measure
  pinMode(BATTERY_PIN,INPUT);
}

void loop() {
  //Value conversion from digital to voltage
  batteryCharge = (analogRead(BATTERY_PIN)*5.4)/1024;
  
  //Measured value comparison with min voltage required
  if(batteryCharge<=MIN_VOLTAGE) {
    digitalWrite(BATTERY_LED,HIGH);
    Serial.println("LOW BATTERY");
  }
  else {
    digitalWrite(BATTERY_LED,LOW);
  }
}

