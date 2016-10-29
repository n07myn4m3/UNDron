/*
Este código se realizo con la finalidad de poder evaluar el correcto funcionamiento del conversor ADC0832 y se basa en la siguiente lectura:
http://playground.arduino.cc/Code/MCP3208 


Esquema para el ADC0832 
Pinout:

                         ___ 
CS                 1 | u  | 8   VCC(VREF)
CHANNEL 0   2 |     | 7   CLK
CHANNEL 1   3 |     | 6   DO
GND              4 |___| 5   DI

    1    CS   ->  D9
    5    DI   ->  D10
    6    DO   ->  D11
    7    CLK  ->  D12
    4    GND  ->  GND
    8    VCC  ->  SUPPLY_VOLTAGE_5V

*/

#define SEL_PIN 9 //Pin de seleccion o chip select (CS)
#define COMMAND_DATA 10 // Pin de configuracion del ADC inicio, modo, seleccion de canal. 
#define ADC_DATA_READ  11 //Salida de datos, conversion analoga a digital
#define SPI_CLOCK  12 //Reloj o Clock 

int readvalue; 
float v_channel;
//--------------------------------------------------
void setup(){ 
  
 //Configura el modo de los pines 
 pinMode(SEL_PIN, OUTPUT); 
 pinMode(COMMAND_DATA, OUTPUT); 
 pinMode(ADC_DATA_READ, INPUT); 
 pinMode(SPI_CLOCK, OUTPUT); 
 
 //Desactiva el dispositivo para iniciar con los siguientes valores
 digitalWrite(SEL_PIN,HIGH); 
 digitalWrite(COMMAND_DATA,LOW); 
 digitalWrite(SPI_CLOCK,LOW); 

 Serial.begin(9600); 
} 

//--------------------------------------------------
int read_adc(int channel){
  int adcvalue = 0;
  byte commandbits = B110000; 
  commandbits|=((channel-1)<<3);

  digitalWrite(SEL_PIN,LOW); //Activa el dispositivo ADC
     //Prepara los bits que seran enviados al ADC
  for (int i=5; i>=3; i--){
    digitalWrite(COMMAND_DATA,commandbits&1<<i);
     //Ciclos de reloj
    digitalWrite(SPI_CLOCK,HIGH);
    digitalWrite(SPI_CLOCK,LOW);    
  }

  digitalWrite(SPI_CLOCK,HIGH);    //Ignora dos bits nulos
  digitalWrite(SPI_CLOCK,LOW);
  digitalWrite(SPI_CLOCK,HIGH);  
  digitalWrite(SPI_CLOCK,LOW);

    //Lee los bits entregados por el ADC
  for (int i=7; i>=0; i--){
    adcvalue+=digitalRead(ADC_DATA_READ)<<i;
    //Ciclos de reloj
    digitalWrite(SPI_CLOCK,HIGH);
    digitalWrite(SPI_CLOCK,LOW);
  }
  digitalWrite(SEL_PIN, HIGH); //Apaga el dispositivo ADC
  return adcvalue;
}
//--------------------------------------------------
void loop() { 
 readvalue = read_adc(1); 
 v_channel=readvalue*(5.0 / 255.0);
  Serial.print("CANAL 0 ");
  Serial.print(readvalue,BIN); //DEC para decimal
  Serial.print(" voltaje ");
  Serial.print(v_channel,3);
  Serial.print("\n\n");
  
 readvalue = read_adc(2); 
 v_channel=readvalue*(5.0 / 255.0);
  Serial.print("CANAL 1 ");
  Serial.print(readvalue,BIN); 
  Serial.print(" voltaje ");
  Serial.print(v_channel,5);
  
  Serial.print("\n\n");
  delay(1000); 
} 
