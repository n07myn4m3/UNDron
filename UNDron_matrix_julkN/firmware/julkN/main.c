#include "soc-hw.h"
#include "softfloat.h"
#include "LSM9DS1.h"
#include "MPL3115A2.h"
//Antenas
#include "nrf24.h"
#include "nRF24L01.h"


const uint8_t pipe[] = {0xF0,0xF0,0xF0,0xF0,0xE1};
static char pipex[] = {'p','i','p','e','0','7'};
//static char pipe0[] = {'p','i','p','e','0'};
static char *data_aux;
static char data[] = {'t','u','G','F','A'};
static char data2[] ={':','v','l','o','l'};
static uint8_t ports;
int *data_receive;



int main(){

  for(;;){
/*
---------------------------------------------------------------------------
						 ____  ____  ____  ____ 
						(_  _)(  __)/ ___)(_  _)
						  )(   ) _) \___ \  )(  
						 (__) (____)(____/ (__)                         
---------------------------------------------------------------------------
 Prueba antenas
---------------------------------------------------------------------------*/



		nrf24_begin();
		msleep(100);
		setAutoAck(true);

		enableDynamicAckPayloads();
		//PTX
		//stopTransmission();
		//openPipe0_tx(pipe);
		//PRX
		openpipe_rx(1,pipe);
		startRx_mode();
		setRetries(15, 15);


			uart_putstr("\nLa transmision va a iniciar");
			if ( available() == 1) {
				writeAckPayload( 1, data, 5 );
				uart_putstr("\nEL dato enviado es: ");
				uart_putstr((char*)data);
				read_payload( data_receive, sizeof(data_receive) );
				uart_putstr("\nEl archivo recibido es : ");
				uart_putstr("\nEL mensaje recibo es : ");
				uart_putstr((char*)data_receive);
		  }
			msleep(100);






/*
---------------------------------------------------------------------------
						 ____  ____  ____  ____ 
						(_  _)(  __)/ ___)(_  _)
						  )(   ) _) \___ \  )(  
						 (__) (____)(____/ (__)                         
---------------------------------------------------------------------------
 Prueba motores
---------------------------------------------------------------------------*/
/*
 //   uint8_t  c;
    pwm_init();
    setmotor1(0b00001100);
    msleep(5000);
 //   c = '*'; // Cumplir la condicion por default
*/




/*
setmotor1(0b00001110);
msleep(10000);
setmotor1(0b00001111);
msleep(10000);
setmotor1(0b00010011);
msleep(10000);
setmotor1(0b00001100);
msleep(10000);
*/
/*

		switch (c) {
    		case 'a':  
                uart_putstr("minimo \r\n");
				setmotor1(0b00001110); //00001110
    			break;
		    case 's': 
                uart_putstr("medio \r\n");
				setmotor1(0b00001111); //00001111
    			break;
    		case 'd': 
                uart_putstr("maximo \r\n");
                setmotor1(0b00010011); //00010011
    			break;  
    		case 'q': 
                uart_putstr("apagado \r\n");
                setmotor1(0b00001100); //00001100
    			break; 
		    default:
                uart_putstr("default \r\n");
				break;
		};
		c = uart_getchar();
*/


/*
---------------------------------------------------------------------------
						 ____  ____  ____  ____ 
						(_  _)(  __)/ ___)(_  _)
						  )(   ) _) \___ \  )(  
						 (__) (____)(____/ (__)                         
---------------------------------------------------------------------------
 Pruebas modulo I2C
---------------------------------------------------------------------------*/
/*
    uart_putstr("Prueba Lab \r\n");
	 //i2c_putrwaddr(0x00, 0x40);
	 //i2c_putrwaddr(0x01, 0x50);
	 //i2c_putrwaddr(0x00, 0x70);
	 //i2c_putrwaddr(0x01, 0x50);
//Prueba lectura i2c
    //volatile uint8_t dataRead;
    //dataRead = I2CreadByte(0x30, 0x35); 
    //gpio0->oe  = 0x000000ff;
    //gpio0->out = 0x60;
    //gpio0->out = dataRead;
    
    uint8_t mTest = mReadByte(WHO_AM_I_M); //adress 0x1C subaddress 0x0F
    //gpio0->out = 0x70;
    //gpio0->out = mTest;

    uint8_t agTest = agReadByte(WHO_AM_I_AG); //adress 0x1C subaddress 0x0F
    //gpio0->out = 0x70;
    //gpio0->out = mTest;

    uart_putstr("Verificacion \r\n");

    if( mTest==WHO_AM_I_M_RSP && agTest==WHO_AM_I_AG_RSP)
      uart_putstr("Disponible \r\n");      
    else 
      uart_putstr("Error \r\n"); 

    msleep(1000); 
*/




/*
---------------------------------------------------------------------------
						 ____  ____  ____  ____ 
						(_  _)(  __)/ ___)(_  _)
						  )(   ) _) \___ \  )(  
						 (__) (____)(____/ (__)                         
---------------------------------------------------------------------------
 Pruebas modulo I2C leer un arreglo de bytes
---------------------------------------------------------------------------*/
/*
    uart_putstr("Prueba Lab \r\n");

	static int temp[6]; 

   I2CreadBytes(0x30, 0x35, temp, 6);
   //lectura_array(temp, 6); 

   gpio0->oe  = 0x000000ff;

   gpio0->out = 0xAA;


   gpio0->out = 0x00;
   gpio0->out = temp[0];
   gpio0->out = 0x01;
	gpio0->out = temp[1];
   gpio0->out = 0x02;
	gpio0->out = temp[2];
   gpio0->out = 0x03;
	gpio0->out = temp[3];
   gpio0->out = 0x04;
	gpio0->out = temp[4];
   gpio0->out = 0x05;
	gpio0->out = temp[5];

   //--------------------------------------------------------

   I2CreadBytes(0x30, 0x35, temp, 6);
   //lectura_array(temp, 6); 

   gpio0->oe  = 0x000000ff;

   gpio0->out = 0xAA;


   gpio0->out = 0x00;
   gpio0->out = temp[0];
   gpio0->out = 0x01;
	gpio0->out = temp[1];
   gpio0->out = 0x02;
	gpio0->out = temp[2];
   gpio0->out = 0x03;
	gpio0->out = temp[3];
   gpio0->out = 0x04;
	gpio0->out = temp[4];
   gpio0->out = 0x05;
	gpio0->out = temp[5];



   msleep(1000);
*/


/*
---------------------------------------------------------------------------
						 ____  ____  ____  ____ 
						(_  _)(  __)/ ___)(_  _)
						  )(   ) _) \___ \  )(  
						 (__) (____)(____/ (__)                         
---------------------------------------------------------------------------
 Pruebas modulo I2C escribir un byte
---------------------------------------------------------------------------*/
/*
    uart_putstr("Prueba Lab \r\n");
    I2CwriteByte(0x30, 0x40, 0x50);
    I2CwriteByte(0x60, 0x70, 0x80);


static int temp[6]; 

   I2CreadBytes(0x30, 0x35, temp, 6);
   //lectura_array(temp, 6); 

   gpio0->oe  = 0x000000ff;

   gpio0->out = 0xBB;


   gpio0->out = 0x00;
   gpio0->out = temp[0];
   gpio0->out = 0x01;
	gpio0->out = temp[1];
   gpio0->out = 0x02;
	gpio0->out = temp[2];
   gpio0->out = 0x03;
	gpio0->out = temp[3];
   gpio0->out = 0x04;
	gpio0->out = temp[4];
   gpio0->out = 0x05;
	gpio0->out = temp[5];

    I2CwriteByte(0x30, 0x40, 0x50);
    I2CwriteByte(0x60, 0x70, 0x80);

    msleep(1000);
*/

/*
---------------------------------------------------------------------------
						 ____  ____  ____  ____ 
						(_  _)(  __)/ ___)(_  _)
						  )(   ) _) \___ \  )(  
						 (__) (____)(____/ (__)                         
---------------------------------------------------------------------------
 Prueba altimetro
---------------------------------------------------------------------------*/
/*
    uart_putstr("ZZZZ");

    MPLBegin();

    MPLgetAltitude();

    uart_putstr("YYYY");

    msleep(1000);
*/


/*
---------------------------------------------------------------------------
						 ____  ____  ____  ____ 
						(_  _)(  __)/ ___)(_  _)
						  )(   ) _) \___ \  )(  
						 (__) (____)(____/ (__)                         
---------------------------------------------------------------------------
 Prueba unidad de punto flotante
---------------------------------------------------------------------------*/

/*

//Prueba unidades de punto flotante    
    multiplicacion=float32_mul( PI, alfa );
    entero=float32_to_int32(multiplicacion);
    gpio0->oe  = 0x000000ff;
    gpio0->out = multiplicacion;
//-----------------------------------
	 //i2c_putrwaddr(0x01, 0x23);

//Prueba modulo problematico
//everloop_putdata_2(0x41);
//everloop_putdata_1(0x40);
//everloop_putdata_2(0x41);
//everloop_putdata_3(0x42);


//Prueba unidades de punto flotante    
    multiplicacion=float32_mul( PI, alfa );
    entero=float32_to_int32(multiplicacion);
    gpio0->ctrl=entero;

    division=float32_div( PI, alfa );
    entero=float32_to_int32(division);
    gpio0->ctrl=entero;

    //nsleep(20);
    pwm_enable(1);
    pwm_duty(10);
    nsleep(1);
    pwm_duty(20);
    //nsleep(100);
    pwm_duty(30);
    //nsleep(100);
    pwm_duty(40);
    //nsleep(100);
    pwm_duty(50);
    //nsleep(100);
*/
  }    
    return 0;
}

