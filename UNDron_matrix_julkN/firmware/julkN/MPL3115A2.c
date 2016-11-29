/**************************************************************************/
/*!
    @file     Adafruit_MPL3115A2.cpp
    @author   K.Townsend (Adafruit Industries)
    @license  BSD (see license.txt)

    Driver for the MPL3115A2 barometric pressure sensor

    This is a library for the Adafruit MPL3115A2 breakout
    ----> https://www.adafruit.com/products/1893

    Adafruit invests time and resources providing this open source code,
    please support Adafruit and open-source hardware by purchasing
    products from Adafruit!

    @section  HISTORY

    v1.0 - First release
*/
/**************************************************************************/
#include "MPL3115A2.h"
#include "soc-hw.h"

static int temp[3]; 

/**************************************************************************/
/*!
    DECLARACION DE FUNCIONES DE LECTURA Y ESCRITURA I2C
*/
/**************************************************************************/

uint8_t MPLReadByte(uint8_t subAddress)
{
	return I2CreadByte(MPL3115A2_ADDRESS, subAddress);
}

void MPLWriteByte(uint8_t subAddress,uint8_t data)
{
	I2CwriteByte(MPL3115A2_ADDRESS, subAddress, data);
}

void MPLReadBytes(uint8_t subaddress, int *dest, uint8_t count)
{
	I2CreadBytes(MPL3115A2_ADDRESS, subaddress, dest, count);
}

/**************************************************************************/
/*!
    INICIALIZAR EL MODULO
*/
/**************************************************************************/

void MPLBegin(){

	MPLWriteByte(MPL3115A2_CTRL_REG1,
		MPL3115A2_CTRL_REG1_OS128 |
		MPL3115A2_CTRL_REG1_ALT);

	MPLWriteByte(MPL3115A2_PT_DATA_CFG,
		MPL3115A2_PT_DATA_CFG_TDEFE |
		MPL3115A2_PT_DATA_CFG_PDEFE |
		MPL3115A2_PT_DATA_CFG_DREM);
}

void MPLgetAltitude(){

	MPLWriteByte(MPL3115A2_CTRL_REG1, 
		MPL3115A2_CTRL_REG1_SBYB  |
		MPL3115A2_CTRL_REG1_OS128 |
		MPL3115A2_CTRL_REG1_ALT);

  uint8_t sta = 0;
//  while (sta & MPL3115A2_REGISTER_STATUS_PDR) {
  while (! (sta & 0x04)) {
    sta = MPLReadByte(MPL3115A2_REGISTER_STATUS);
    //gpio0->oe  = 0x000000ff;
    //gpio0->out = 0xBB;
    //gpio0->out = sta;
    //gpio0->out = sta & 0x04;    
    uart_putstr("NNNN");
    nsleep(20);
  }

  MPLReadBytes(MPL3115A2_REGISTER_PRESSURE_MSB, temp, 3);

// Prueba lectura ----------------------------------------

/*   gpio0->oe  = 0x000000ff;

   gpio0->out = 0xBB;

   gpio0->out = 0x00;
   gpio0->out = temp[0];
   gpio0->out = 0x01;
	gpio0->out = temp[1];
   gpio0->out = 0x02;
	gpio0->out = temp[2];*/

// Prueba lectura tamaño


   nsleep(20);
   uart_putstr("SSSS");
   uart_putchar(temp[0]);
   uart_putchar(temp[0]);
   uart_putchar(temp[0]);

   nsleep(20);
   uart_putstr("SSSS");
   uart_putchar(temp[1]);
   uart_putchar(temp[1]);
   uart_putchar(temp[1]);

   nsleep(20);
   uart_putstr("SSSS");
   uart_putchar(temp[2]);
   uart_putchar(temp[2]);
   uart_putchar(temp[2]);

}


/**************************************************************************/
/*!
    LEER LA INFORMACION ASOCIADA A LA ALTURA
*/
/**************************************************************************/


