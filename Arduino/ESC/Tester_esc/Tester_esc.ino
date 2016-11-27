/*
  LiquidCrystal Library - Hello World

 Demonstrates the use a 16x2 LCD display.  The LiquidCrystal
 library works with all LCD displays that are compatible with the
 Hitachi HD44780 driver. There are many of them out there, and you
 can usually tell them by the 16-pin interface.

 This sketch prints "Hello World!" to the LCD
 and shows the time.

=============================================================
                 LCD SCREEN CONNECTIONS
=============================================================
 * LCD RS pin to digital pin 12
 * LCD Enable pin to digital pin 11
 * LCD D4 pin to digital pin 5
 * LCD D5 pin to digital pin 4
 * LCD D6 pin to digital pin 3
 * LCD D7 pin to digital pin 2
 * LCD R/W pin to ground
 * LCD VSS pin to ground
 * LCD VCC pin to 5V
 * 10K resistor:
 * ends to +5V and ground
 * wiper to LCD VO pin (pin 3)
 =============================================================
             ARDUINO UNO "GRAPHICAL" CONNECTIONS
 =============================================================
                    _______________________
                   /                      | |13|
                   /                      | ---
                   /                      | |12| LCD RS
                                          | ---
                                          | |11| LCD ENABLE
                                          | ---
                                          | |10| 
                                          | ---
                                          | |09| 
                                          | ---
                                          | |08|
                        ARDUINO_UNO       | ---
                                          | |07|
                                          | ---
                                          | |06|
                                          | ---
                                          | |05| D4
                                          | ---
                                          | |04| D5
                                          | ---
                                          | |03| D6
                                          | ---
                                          | |02| D7
                                          | ---
                                          | |01|
                                          | ---
                                          | |00|
 =============================================================
 Library originally added 18 Apr 2008
 by David A. Mellis
 library modified 5 Jul 2009
 by Limor Fried (http://www.ladyada.net)
 example added 9 Jul 2009
 by Tom Igoe
 modified 22 Nov 2010
 by Tom Igoe

 This example code is in the public domain.

 http://www.arduino.cc/en/Tutorial/LiquidCrystal
 ---
 */

// Librerias
#include <LiquidCrystal.h>  // Control de la pantalla LCD:
#include <SoftwareSerial.h> // Control de software serial, modulo bluetooth
#include<Servo.h>           // Libreria servo

// initialize the library with the numbers of the interface pins
	LiquidCrystal lcd(12, 11, 5, 4, 3, 2);
// Led indicador
	int led13           = 13;
// Servo
	Servo ESC;               //Crear un objeto de clase servo
	int vel = 1000;          //amplitud del pulso
// Botones
   uint8_t inPin1 = 22;          // switch 1
   uint8_t inPin2 = 24;          // switch 2
   uint8_t inPin3 = 26;          // switch 3

//----------------------------------------------------------
void setup() {
  // set up the LCD's number of columns and rows:
	  lcd.begin(16, 2);

  //Indicator led
	  pinMode(led13,OUTPUT);

  //Inicializar servo
	  //Asignar un pin al ESC
	  ESC.attach(9);
	  
	  //Activar el ESC
	  ESC.writeMicroseconds(1000); //1000 = 1ms
	  //Cambia el 1000 anterior por 2000 si
	  //tu ESC se activa con un pulso de 2ms
	  delay(5000); //Esperar 5 segundos para hacer la activacion
		
  //Iniciar puerto serial
  Serial.begin(9600);
  Serial.setTimeout(10);

  //Inicializar botones de entrada
  pinMode(inPin1, INPUT);      // sets the digital pin 22 as input
  pinMode(inPin2, INPUT);      // sets the digital pin 24 as input
  pinMode(inPin3, INPUT);      // sets the digital pin 26 as input
}
//----------------------------------------------------------


void loop() {
  uint8_t buttonState1 = digitalRead(inPin1); 
  uint8_t buttonState2 = digitalRead(inPin2); 
  uint8_t buttonState3 = digitalRead(inPin3);
   
  uint8_t buttonState = (buttonState3<<2)|(buttonState2 << 1)| buttonState1 ;
  
  switch (buttonState) {
    
    case B00000001:
        Serial.println(buttonState, BIN);
        Serial.println("Bajo");
      break;
      
    case B00000010:
        Serial.println(buttonState, BIN);
        Serial.println("Medio");
      break;
      
    case B00000100:    
        Serial.println(buttonState, BIN);
        Serial.println("Alto");
      break;
      
    default:
      // if nothing else matches, do the default
      // default is optional
    break;
  }
  // print out the state of the button:
  
  delay(5);        // delay in between reads for stability
  

}

/*
int ledPin = 13; // LED connected to digital pin 13
int inPin = 7;   // pushbutton connected to digital pin 7
int val = 0;     // variable to store the read value

void setup()
{
  pinMode(ledPin, OUTPUT);      // sets the digital pin 13 as output
  pinMode(inPin, INPUT);      // sets the digital pin 7 as input
}

void loop()
{
  val = digitalRead(inPin);   // read the input pin
  digitalWrite(ledPin, val);    // sets the LED to the button's value
}
*/