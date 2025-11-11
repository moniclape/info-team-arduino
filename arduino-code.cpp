const int PIN_RED   = 9; //Red LED on pin 9

const int PIN_GREEN = 10; //Green LED on pin 10

const int PIN_BLUE  = 11; //Blue LED on Pin 11

int incomingByte = 0;

String readString;


void setup() {

  //set all three pins to output mode

  pinMode(PIN_RED,   OUTPUT);

  pinMode(PIN_GREEN, OUTPUT);

  pinMode(PIN_BLUE,  OUTPUT);

  Serial.begin(9600);

}

void loop() {


  while (Serial.available()) {

    delay(2);  //delay to allow byte to arrive in input buffer

    char c = Serial.read();

    if (c != '\n')

    {

      readString += c;

    }

  }


  if (readString.length() > 0)

  {

    //expected value example 0.50.255

   

    int index = readString.indexOf('.');

    int length = readString.length();

    String valueRedString = readString.substring(0, index);

    String valueGreenAndBlueString = readString.substring(index + 1, length);

    index = valueGreenAndBlueString.indexOf('.');

    String valueGreenString = valueGreenAndBlueString.substring(0, index);

    String valueBlueString = valueGreenAndBlueString.substring(index + 1, length);


    int valueRedInt = valueRedString.toInt();

    int valueGreenInt = valueGreenString.toInt();

    int valueBlueInt = valueBlueString.toInt();


    analogWrite(PIN_RED,   valueRedInt);

    analogWrite(PIN_GREEN, valueGreenInt);

    analogWrite(PIN_BLUE,  valueBlueInt);


    Serial.println(valueRedInt);

    Serial.println(valueGreenInt);

    Serial.println(valueBlueInt);

    readString = "";

  }


  delay(1000);    //a little delay is needed so you can see the change

}

