#include <EEPROM.h>

void setup()
{
  Serial.begin(9600);
}

void loop()
{
  String command = "CHANGE_PASSWORD;01;8976";
  String result[3];

  Serial.println(command.length());
  processCommand(result, command);

  for(int i=0; i<3; i++)
    Serial.println(result[i]);  
  delay(2000);
}

// Method that compares a key with stored keys
boolean compareKey(String key) {
  int acc = 3;
  int codif, arg0, arg1; 
  for(int i=0; i<3; i++) {
    codif = EEPROM.read(i);
    while(codif!=0) {
      if(codif%2==1) {
        arg0 = EEPROM.read(acc);
        arg1 = EEPROM.read(acc+1);
        String compose = "";
        arg1*=256;
        arg1+= arg0;
        if(sizeof(String(arg1)) == 1) {
          compose = "000"+String(arg0);
        }
        else if(sizeof(String(arg1)) == 2) {
          compose = "00"+String(arg0);
        }
        else if(sizeof(String(arg1))==3) {
          compose = "0"+String(arg1);
        }
        else {
          compose = String(arg1);
        }

        if(compose==key) {
          return true;
        }
      }
      acc+=2;
      codif>>=1;
    }
    acc=(i+1)*16+3;
  }
  return false;
}

// Methods that divides the command by parameters
void processCommand(String* result, String command) {
  int i = 0;
  char* token;
  char buf[command.length() + 1];

  command.toCharArray(buf, sizeof(buf));
  token = strtok(buf, ";");

  while(token != NULL) {
    result[i++] = token;
    token = strtok(NULL, ";");
  }
}

//Method that adds a password in the specified index
void addPassword(int val, int index) {
  byte arg0 = val%256;
  byte arg1 = val/256;
  EEPROM.write((index*2)+3,arg0);
  EEPROM.write((index*2)+4,arg1);
  byte i = 1;
  byte location = index/8;
  byte position = index%8;
  i<<=position;
  byte j = EEPROM.read(location);
  j |= i;
  EEPROM.write(location,j);
}

//Method that updates a password in the specified index
void updatePassword(int val, int index) {
  byte arg0 = val%256;
  byte arg1 = val/256;
  EEPROM.write((index*2)+3,arg0);
  EEPROM.write((index*2)+4,arg1);
}

//Method that deletes a password in the specified index
void deletePassword(int index) {
  byte i = 1;
  byte location = index/8;
  byte position = index%8;
  i<<=position;
  byte j = EEPROM.read(location);
  j ^= i;
  EEPROM.write(location,j);
}

//Method that deletes all passwords
void deleteAllPasswords() {
  //Password reference to inactive
  EEPROM.write(0,0);
  EEPROM.write(1,0);
  EEPROM.write(2,0);
}

