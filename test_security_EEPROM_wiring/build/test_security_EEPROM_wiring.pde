#include <EEPROM.h>

void setup()
{
  Serial.begin(9600);
  Serial.println(EEPROM.read(0));
  Serial.println(EEPROM.read(1));
  delay(random(5000));
  long time = millis();
  int addr0 = time%256;
  int addr1 = (time/256) % 256;
  Serial.println(String(addr0)+" & "+String(addr1));
  EEPROM.write(0,addr0);
  EEPROM.write(1,addr1);
}

void loop()
{

}
