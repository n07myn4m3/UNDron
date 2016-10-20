
#include "soc-hw.h"
#include "softfloat.h"

int main(){
//
    volatile unsigned int     *data32;
    data32 = (volatile unsigned int   *)(0x70000000);
    data32++;
    *data32 = PI;
    
    // Init Commands
    uart_init();
    isr_init();
    //tic_init();
    irq_set_mask( 0x00000002 );
    irq_enable();
    basicIO_init();

    // BasicIO
    //uart_putstr( "** BasicIO **\n" );
    
    basicIO_leds(0b01010101);
    msleep(200);
    basicIO_leds(0b10101010);
    msleep(200);
    basicIO_leds(0b01010101);
    msleep(200);
    basicIO_leds(0b10101010);
    msleep(200);


    
    uint8_t i;
    for(i=0;i<8;i++){
        basicIO_leds(0x01); //COnvertir a binario
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
    
    return 0;
}

