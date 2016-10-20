#include "soc-hw.h"

uart_t     *uart0    = (uart_t *)    0x20000000;
timer_t    *timer0   = (timer_t *)   0x30000000;
gpio_t     *gpio0    = (gpio_t *)    0x40000000;
spi_t      *spi0     = (spi_t *)     0x50000000;
i2c_t 		 *i2c0	 = (i2c_t *) 0x60000000;



isr_ptr_t isr_table[32];

void prueba()
{
	   uart0->rxtx=30;
	   timer0->tcr0 = 0xAA;
	   gpio0->ctrl=0x50;
		 i2c0 ->wxrx = 0x40;
}

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
//static uint32_t rwaddrs;
//static uint8_t ena;
//static uint8_t rw;


void i2c_putchar(uint8_t c)
{
  data = c;
	while ((i2c0->ucr & !I2C_BUSY));
	i2c0->wxrx = data;
}

void i2c_putrwaddr (uint8_t rw, uint8_t addrs)
{
	i2c0 -> rwaddr = ((rw<<7)|addrs>>1);
}

void i2c_putdatas(char *str)	
{
	char *c= str;
	while (*c) {
		i2c_putchar(*c);
    c++;
	}
}

void i2c_init()
{
 i2c0->ucr = I2C_ENA;  
}

void i2c_sleep()
{
	while((i2c0->ucr & I2C_BUSY))
	i2c0->ucr = 0x00;
}

char i2c_getdata()
{
	while ( (i2c0->ucr & I2C_BUSY) && (!(i2c0->ucr & I2C_ERROR)));
	return i2c0-> wxrx;
}

/***************************************************************************
 * SPI Functions
 */
void spi_init()
{
	spi0-> ucr = SPI_ENA;
}

char spi_getchar()
{   
    while (spi0->ucr & SPI_BUSY) ;
    return spi0->rxtx;
}

void spi_sleep()
{
	while ((spi0->ucr & SPI_BUSY));
	spi0->ucr = 0x00;
}

void spi_continue(uint8_t a)
{
	if(a) {
	spi0->ucr = SPI_CONT;
	}
	else {
	spi0->ucr = !SPI_CONT;
	}
}

void spi_cont_d(char data)
{
	spi0->ucr = SPI_CONT;
	spi0->rxtx = data;
}

void spi_putchar(char c)
{
    while (spi0->ucr & SPI_BUSY) ;
    spi0->rxtx = c;
}


void spi_putstr(char *str)
{
    char *c = str;
    while(*c) {
				spi_continue(0x01);
        spi_putchar(*c);
        c++;
    }
}

