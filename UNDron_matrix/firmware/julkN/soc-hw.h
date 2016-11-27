#ifndef SPIKEHW_H
#define SPIKEHW_H

#define PROMSTART 0x00000000
#define RAMSTART  0x00000800
#define RAMSIZE   0x400
#define RAMEND    (RAMSTART + RAMSIZE)

#define RAM_START 0x40000000
#define RAM_SIZE  0x04000000

#define FCPU      50000000

#define UART_RXBUFSIZE 32

#define TRUE  0x01
#define FALSE 0x00


/****************************************************************************
 * Types
 */
typedef unsigned int  uint32_t;    // 32 Bit
typedef signed   int   int32_t;    // 32 Bit

typedef unsigned char  uint8_t;    // 8 Bit
typedef signed   char   int8_t;    // 8 Bit

/****************************************************************************
 * Interrupt handling
 */
typedef void(*isr_ptr_t)(void);

void     irq_enable();
void     irq_disable();
void     irq_set_mask(uint32_t mask);
uint32_t irq_get_mak();

void     isr_init();
void     isr_register(int irq, isr_ptr_t isr);
void     isr_unregister(int irq);

/****************************************************************************
 * General Stuff
 */
void     halt();
void     jump(uint32_t addr);


/****************************************************************************
 * Timer
 */
#define TIMER_EN     0x08    // Enable Timer
#define TIMER_AR     0x04    // Auto-Reload
#define TIMER_IRQEN  0x02    // IRQ Enable
#define TIMER_TRIG   0x01    // Triggered (reset when writing to TCR)

typedef struct {
    volatile uint32_t tcr0;
    volatile uint32_t compare0;
    volatile uint32_t counter0;
    volatile uint32_t tcr1;
    volatile uint32_t compare1;
    volatile uint32_t counter1;
} timer_t;

void msleep(uint32_t msec);
void nsleep(uint32_t nsec);
void tic_init();
uint8_t time_happened_micro(uint32_t micros);
uint8_t time_happened_millis(uint32_t millis);
void tic_init();
void init_watch(void);


/***************************************************************************
 * GPIO0
 */
typedef struct {
    volatile uint32_t ctrl;
    volatile uint32_t dummy1;
    volatile uint32_t dummy2;
    volatile uint32_t dummy3;
    volatile uint32_t in;
    volatile uint32_t out;
    volatile uint32_t oe;
} gpio_t;
void gpio_init_write(void);
void digitalWrite(uint8_t output, uint8_t mode);
uint8_t read_gpio(void);

/***************************************************************************
 * UART0
 */
#define UART_DR   0x01                    // RX Data Ready
#define UART_ERR  0x02                    // RX Error
#define UART_BUSY 0x10                    // TX Busy

typedef struct {
   volatile uint32_t ucr;
   volatile uint32_t rxtx;
} uart_t;

void uart_init();
void uart_putchar(char c);
void uart_putstr(char *str);
char uart_getchar();


/***************************************************************************
 * I2C0
 
 Register Description:

    0x00 UCR      [ 0 | 0 | 0 | 0 | ena | 0 | ack_error | busy ]
    0x04 DATA_WXRX
    0x08 ADDR-RW  [rw | addr] esto debe venir asi desde el software     
 
  ****************************************************************************/


//Constantes para seleccionar los valores deseados del ucr
#define I2C_BUSY   0x01     // BUSY        0b00000001
#define I2C_ERROR  0x02     // ACK_ERROR   0b00000010
#define I2C_AVAIL  0x04		// AVAILABLE   0b00000100
#define I2C_ENA    0x08     // ENA         0b00001000
//Constantes de operacion del modulo i2c
#define I2C_WRITE  0x00
#define I2C_READ   0x01

//static uint8_t dest[];


typedef struct {
   volatile uint32_t ucr;    //Posicion x00
   volatile uint32_t wxrx;	 //Posicion x04
   volatile uint32_t rwaddr; //Posicion x08
} i2c_t;

void i2c_init();
void i2c_sleep();
void i2c_putrwaddr(uint8_t rw, uint8_t addrs);
void i2c_putdata(uint8_t c);
void i2c_putdatas(char *str);
uint8_t i2c_getdata();
uint8_t I2CreadByte(uint8_t address, uint8_t subaddress);
void I2CreadBytes(uint8_t address, uint8_t subaddress, int *dest, uint8_t count);
void I2CwriteByte(uint8_t address, uint8_t subaddress, uint8_t data);

/***************************************************************************
 * EVERLOOP
 */

typedef struct {
   volatile uint8_t prueba_1; //Posicion x00
   volatile uint8_t prueba_2; //Posicion x04
   volatile uint8_t prueba_3; //Posicion x08
} everloop_t;

void everloop_putdata_1(uint8_t data1);
void everloop_putdata_2(uint8_t data2);
void everloop_putdata_3(uint8_t data3);

/***************************************************************************
 * PWM0
 */

#define HIGH 0x01
#define LOW  0x00

typedef struct {
	volatile uint32_t enable;	    //00
	volatile uint32_t duty_m1;	 	//04
	volatile uint32_t duty_m2;	 	//08
	volatile uint32_t duty_m3;	 	//0c
	volatile uint32_t duty_m4;	 	//20
} pwm_t;
	
uint8_t setmotor1(uint8_t bit);
uint8_t setmotor2(uint8_t bit);
uint8_t setmotor3(uint8_t bit);
uint8_t setmotor4(uint8_t bit);
void	set_pwm(uint8_t state);
void 	pwm_init(void);



/***************************************************************************
 * SPI0
 */
#define SPI_BUSY  0x01                    // BUSY
#define SPI_ENA  	0x04                    // ENA 
#define SPI_CONT  0x08										// CONT


typedef struct {
   volatile uint32_t ucr;    //Posicion x00
   volatile uint32_t rxtx;	 //Posicion x04
	 volatile uint32_t csn;	   //Posicion x08
	 volatile uint32_t ce;		 //Posicion 0x12
} spi_t;

void spi_init();
void spi_sleep();
void spi_not_ena();
uint8_t spi_getchar();
void spi_continue(uint8_t a);
void spi_cont_d(char data);
void spi_putchar(char c);
void spi_putstr(char *str);


/***************************************************************************
 * Pointer to actual components
 */
extern spi_t 		*spi0;
extern i2c_t		*i2c0;
extern timer_t  *timer0;
extern uart_t   *uart0; 
extern gpio_t   *gpio0; 
extern uint32_t *sram0; 

#endif // SPIKEHW_H
