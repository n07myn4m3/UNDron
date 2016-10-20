
#include "soc-hw.h"

int main(){

    // Init Commands
    uart_init();
    isr_init();
    //tic_init();
    irq_set_mask( 0x00000002 );
    irq_enable();

		
		prueba();
		isr_init();
		uart_init();
		i2c_putchar(0x54);
		spi_putchar(0x40);
		spi_init();
		spi_sleep();
		spi_getchar();
		uart_putstr("Probando 1 2 3");
		i2c_putrwaddr(0x00, 0x40);
		i2c_putchar(0x80);
		i2c_init();
		spi_sleep();
		spi_init();
		spi_putstr("Hola Mundo");
		spi_sleep();
		nsleep(200);
		uart_putstr("my heart feel so bad\n");
    nsleep(20);
		i2c_sleep();
/*    
    // Init Commands
    isr_init();
    //tic_init();
    irq_set_mask( 0x00000012 );
    irq_enable();

    uart_init();
    basicIO_init();
    // BasicIO
    //uart_putstr( "** BasicIO **\n" );
    

    basicIO_leds(0b01010101);
    msleep(200);
    basicIO_leds(0b10101010);
    msleep(200);

    while(1){
    basicIO_leds(0b01010101);
    msleep(200);
    basicIO_leds(0b10101010);
    msleep(200);
    }

    basicIO_leds(basicIO_sw());
    basicIO_leds(basicIO_bt());
    
    uint8_t i;
    for(i=0;i<8;i++){
        basicIO_leds(0x01);
        msleep(20);
        basicIO_leds(0x02);
        msleep(20);
        basicIO_leds(0x04);
        msleep(20);
        basicIO_leds(0x08);
        msleep(20);
        basicIO_leds(0x10);
        msleep(20);
        basicIO_leds(0x20);
        msleep(20);
        basicIO_leds(0x40);
        msleep(20);
        basicIO_leds(0x80);
        msleep(20);
        
        basicIO_leds(0x80);
        msleep(20);
        basicIO_leds(0x40);
        msleep(20);
        basicIO_leds(0x20);
        msleep(20);
        basicIO_leds(0x10);
        msleep(20);
        basicIO_leds(0x08);
        msleep(20);
        basicIO_leds(0x04);
        msleep(20);
        basicIO_leds(0x02);
        msleep(20);
        basicIO_leds(0x01);
        msleep(20);

    }   
*/
				return 0;
}
