/****************************************************************************
*Antenas nrfl2401+
****************************************************************************/
#ifndef NRF_H
#define NRF_H



#include "soc-hw.h"
#include "nRF24L01.h"


//Logic boolean
#define BOOL char
#define true 1
#define false 0



/****************************************************************************
 * Types
 *
typedef unsigned int  uint32_t;    // 32 Bit
typedef signed   int   int32_t;    // 32 Bit

typedef unsigned char  uint8_t;    // 8 Bit
typedef signed   char   int8_t;    // 8 Bit

****************************************************************************/

  uint8_t ce_pin; /**< "Chip Enable" pin, activates the RX or TX role */
  uint8_t csn_pin; /**< SPI Chip select */
	uint8_t wxrxDelay;
	uint8_t dynamic_payloads_enabled;
	uint8_t *pipe0_reading_address;
	//uint8_t spi_rxbuff[32];        //debe tener el mismo tamanp 	que el payload
/*
  uint8_t spi_rxbuff[32+1] ; //SPI receive buffer (payload max 32 bytes)
  uint8_t spi_txbuff[32+1] ; //SPI transmit buffer (payload max 32 bytes + 1 byte for the command)
*/

//Niveles
#define HIGH 0x01
#define LOW  0x00

/*******************************************************************************
*Funciones control de señales
*******************************************************************************/
/*
void digital_write(uint8_t port);
//Escritura delos pines GPIO, implementado para usar CSN y CE
*/

uint8_t ce(uint8_t level);
//Define el estado del CE para las antenas nrf240l +

uint8_t csn(uint8_t level);
//Define el estado del CSN del protocolo SPI para las antenas nrf240l +

void  spi_finish();
//Apaga el CSN y el CE de las antenas nrf240l+

void spi_enable();
//Reinicia los puertos del spi y vuelve alto el CSN del spi para las antenas nrf240l+
uint8_t spi_transmitD(uint8_t data);
//Transmite al modulo spi sin tener en cuenta las senales csn y ce
uint8_t spi_transfer(uint8_t data);
//Transmite los datos por el modulo spi, devuelve un dato de confirmacion
void spi_putstr_nrf24(const uint8_t *data);
//Transmite multiples datos, a diferencia de su homologo no devuelve nada
//void spi_receivestr(void * data,uint8_t size);
//Permite almacenar multiples lecturas en un arreglo


/******************************************************************************
*Funciones nrf240l+
******************************************************************************/
void nrf24_begin(void);
//Configura los parametros por defecto del modulo
uint8_t get_status();
//Devuelve el estado de las antenas 
uint8_t read_register(uint8_t reg);
//Lee los registros del modulo
uint8_t read_register_buff(uint8_t reg, uint8_t * buf, uint8_t len);
//Permite leer varios datos provenientes del modulo spi
uint8_t write_register(uint8_t reg, const uint8_t *buf, uint8_t len);
//Escribe en los registos del modulo, permite direccion y multiples comandos o datos
uint8_t write_register_basic(uint8_t reg,uint8_t value);
//Escribe en los registros del modulo, solo permite una direccion y un comando
void spi_loadpay(uint8_t *spi_txbuff, uint8_t writeType);
//Carga los datos al payload de las antenas
//void transmit_data(uint8_t *data);
//Inicia la transmision de datos del PTX AL PRX
void setRetries(uint8_t delay, uint8_t count);
//Configura el numero de retransmisiones y el tiempo de espera entre cada una	
void setChannel(uint8_t channel);
//Ingresa el canal por el cual hay que transmitir 
void flush_rx();
void flush_tx();
//limpia los registros de los payoloads
void power_up();
//Permite pasar del estado pwr_d al standByI
void power_down();
//Apaga las antenas, "Las lleva al estado power down"
uint8_t load_payload(const void *spi_txbuff, uint8_t writeType, uint8_t len);
//Escribe los datos al payload
void setPaLevel(uint8_t level);
//Configura la potencia de transmision de las antenas
void openPipe0_tx(const uint8_t * addres);
//Abre el canal 0 del ptx, debe ser solo el cero ya que una antena PTX, solo
//puede escribir a un receptor, leer datasheet pag 38.
void setAutoAck(uint8_t enable);
//Habilita el autoAcknowledge de todos los canales
void enableDynamicAckPayloads(void);
//Habilita el claculo automatico del payload y la adjucion del mismo a la senal payload
//void enableAckPayload(void);
//Lo mismo que hace la funcion de arriba solo que para este caso
//se habilitan los canales 0 y 1
void stopTransmission(void);
//Permite detener la transmision de las antena.
void openpipe_rx(uint8_t pipe,const uint8_t *addres);
//Habilita los canales de recepcion de datos
void startRx_mode(void);
//Permite habilitar la antena como receptora y entrar al modo PRX
void closeReadingPipe( uint8_t pipe );
//Cierra un canal de escritura por lo general el 0
uint8_t isAckPayloadAvailable(void);
//Comprueba de que si la antena PRX adjuntara datos a la senal ack
uint8_t available(void);
//permite determinar si el FIFO_RX esta vacio
void writeAckPayload(uint8_t pipe, const void* buf, uint8_t len);
//Carga los datos al TX_FIFO de la antena PRX
uint8_t read_payload(void * buf,uint8_t data_len);
//Permite leer el payload de la antena
void toggle_features(void);
//Inicializa la direccion 0 de la antena PRX en 0;
void nrf24_config(void);
#endif
