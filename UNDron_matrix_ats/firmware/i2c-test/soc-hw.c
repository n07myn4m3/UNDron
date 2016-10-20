#include "soc-hw.h"
//#include "softfloat.h"

uart_t      *uart0     = (uart_t *)     0x20000000;
timer_t     *timer0    = (timer_t *)    0x30000000;
gpio_t      *gpio0     = (gpio_t *)     0x40000000;
spi_t       *spi0      = (spi_t *)      0x50000000;
i2c_t 		*i2c0	   = (i2c_t *)		0x60000000;
everloop_t  *everloop0 = (everloop_t *) 0x70000000; //leo y escribo datos de esa direccion

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
//static uint32_t rwaddrs;
//static uint8_t ena;
//static uint8_t rw;


void i2c_putchar(uint8_t c)
{
    data = c;
	//while ((i2c0->ucr & !I2C_BUSY));
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
 * everloop Functions
 */
static uint32_t leds;

void everloop_init()
{
  //LEDs off
  everloop0->leds = 0;
  leds = 0;
}

void everloop_leds_on(uint8_t leds_on)
{
  //LEDs on
  leds |= leds_on;
  everloop0->leds = leds;
}

void everloop_leds_off(uint8_t leds_off)
{
  //LEDs off
  leds &= ~leds_off;
  everloop0->leds = leds;
}

void everloop_leds(uint8_t leds0)
{
  //LEDs
  leds = leds0; //coge lo que le llega a la funcion y lo manda a los leds
  everloop0->leds = leds0;
}

uint8_t everloop_read_sw (void)
{
return everloop0->switches;
}