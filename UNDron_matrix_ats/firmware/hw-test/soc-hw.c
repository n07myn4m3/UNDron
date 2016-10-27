#include "soc-hw.h"
#include "softfloat.h"

uart_t     *uart0     = (uart_t *)     0x20000000;
timer_t    *timer0    = (timer_t *)    0x30000000;
gpio_t     *gpio0     = (gpio_t *)     0x40000000;
spi_t      *spi0      = (spi_t *)      0x50000000;
everloop_t *everloop0 = (everloop_t *) 0x60000000; // por el momento no disponible
i2c_t 	   *i2c0	  = (i2c_t *)	   0x70000000;
pwm_t      *pwm0      = (pwm_t *)      0x80000000;    //leo y escribo datos de esa direccion


isr_ptr_t isr_table[32];

void tic_isr();
/***************************************************************************
 * IRQ handling
 */
void isr_null()
{
}

void irq_handler(uint32_t pending)
{
    int i;

    for(i=0; i<32; i++) {
        if (pending & 0x01) (*isr_table[i])();
        pending >>= 1;
    }
}

void isr_init()
{
    int i;
    for(i=0; i<32; i++)
        isr_table[i] = &isr_null;
}

void isr_register(int irq, isr_ptr_t isr)
{
    isr_table[irq] = isr;
}

void isr_unregister(int irq)
{
    isr_table[irq] = &isr_null;
}

/***************************************************************************
 * TIMER Functions
 */
uint32_t tic_msec;

void msleep(uint32_t msec)
{
    uint32_t tcr;

    // Use timer0.1
    timer0->compare1 = (FCPU/1000)*msec;
    timer0->counter1 = 0;
    timer0->tcr1 = TIMER_EN;

    do {
        //halt();
         tcr = timer0->tcr1;
     } while ( ! (tcr & TIMER_TRIG) );
}

void nsleep(uint32_t nsec)
{
    uint32_t tcr;

    // Use timer0.1
    timer0->compare1 = (FCPU/1000000)*nsec;
    timer0->counter1 = 0;
    timer0->tcr1 = TIMER_EN;

    do {
        //halt();
         tcr = timer0->tcr1;
     } while ( ! (tcr & TIMER_TRIG) );
}

void tic_isr()
{
    tic_msec++;
    timer0->tcr0     = TIMER_EN | TIMER_AR | TIMER_IRQEN;
}

void tic_init()
{
    tic_msec = 0;

    // Setup timer0.0
    timer0->compare0 = (FCPU/10000);
    timer0->counter0 = 0;
    timer0->tcr0     = TIMER_EN | TIMER_AR | TIMER_IRQEN;

    isr_register(1, &tic_isr);
}


/***************************************************************************
 * UART Functions
 */
void uart_init()
{
    //uart0->ier = 0x00;  // Interrupt Enable Register
    //uart0->lcr = 0x03;  // Line Control Register:    8N1
    //uart0->mcr = 0x00;  // Modem Control Register

    // Setup Divisor register (Fclk / Baud)
    //uart0->div = (FCPU/(57600*16));
}

char uart_getchar()
{   
    while (! (uart0->ucr & UART_DR)) ;
    return uart0->rxtx;
}

void uart_putchar(char c)
{
    while (uart0->ucr & UART_BUSY) ;
    uart0->rxtx = c;
}

void uart_putstr(char *str)
{
    char *c = str;
    while(*c) {
        uart_putchar(*c);
        c++;
    }
}

/***************************************************************************
 * I2C Functions
 */

	static uint8_t data;
    static uint8_t data_LSB;
    static uint8_t data_MSB;
    //----------------------------------------------------------------
	void i2c_putdata(uint8_t c)
	{
	  data = c;
		while ((i2c0->ucr & !I2C_BUSY));
		i2c0->wxrx = data;
	}
    //----------------------------------------------------------------
	void i2c_putrwaddr (uint8_t rw, uint8_t addrs)
	{
		i2c0 -> rwaddr = ((rw<<7)|addrs);
	}
    //----------------------------------------------------------------
	void i2c_putdatas(char *str)	
	{
		char *c= str;
		while (*c) {
			i2c_putdata(*c);
		c++;
		}
	}
    //----------------------------------------------------------------
	void i2c_init()
	{
	 i2c0->ucr = I2C_ENA;  
	}
    //----------------------------------------------------------------
	void i2c_sleep()
	{
		while((i2c0->ucr & I2C_BUSY))
		i2c0->ucr = 0x00;
	}
    //----------------------------------------------------------------
	uint8_t i2c_getdata()
	{
		while ( (i2c0->ucr & I2C_BUSY) && (!(i2c0->ucr & I2C_ERROR)));
		return i2c0-> wxrx;
	}
    //----------------------------------------------------------------
    uint8_t I2CreadByte(uint8_t address, uint8_t subaddress)
    {
      //1) Enviar la secuencia de start.
      //2) Enviar la dirección I2C del esclavo con el bit R/W bajo.
      //3) Ingresar el registro interno de la dirección a la cual usted desea leer.
      //4) Enviar de nuevo la secuencia de start.
      //5) Enviar la dirección I2C del esclavo con el bit R/W alto.
      //6) Leer el byte de información del esclavo.
      //7) Opcionalmente puede leer mas bytes de información del esclavo.
      //8) Enviar la secuencia de stop.
      //Indicar la direccion interna que se desea leer    
      i2c_putrwaddr (I2C_WRITE, address);
      i2c_putdata(subaddress);
      i2c_init(); 
      nsleep(20);
	  i2c_sleep();
      //Pausa para que el esclavo procese la orden
      while((i2c0->ucr & I2C_BUSY));
      //gpio0->oe  = 0x000000ff;
      //gpio0->out = 0x64;
      nsleep(80);               // Esta contando en us no en ns 
      //gpio0->out = 0x65;
      //Lectura de la informacion otorgada por el esclavo
      i2c_putrwaddr(I2C_READ, address);
      i2c_init();  
      nsleep(20);
      i2c_sleep();
	  while ( (i2c0->ucr & I2C_BUSY) && (!(i2c0->ucr & I2C_ERROR)));
      //gpio0->oe  = 0x000000ff;
      //gpio0->out = 0x66;
	  return i2c0-> wxrx;     
    }

/***************************************************************************
 * everloop functions
 */
	void everloop_putdata_1(uint8_t data1)
	{
	  everloop0->prueba_1 = data1;
	}

	void everloop_putdata_2(uint8_t data2)
	{
	  everloop0->prueba_2 = data2;
	}

	void everloop_putdata_3(uint8_t data3)
	{
	  everloop0->prueba_3 = data3;
	}
/***************************************************************************
 * PWM Functions
 */
void pwm_init(void)
{
  pwm0->duty = 0;
  pwm0->enable = 0;
}

void pwm_duty(uint8_t duty0)
{
  pwm0->duty = duty0;
}

void pwm_enable(uint8_t enable0)
{
  pwm0->enable = enable0;
}

