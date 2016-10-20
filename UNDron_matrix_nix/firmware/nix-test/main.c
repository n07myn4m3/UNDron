
#include "soc-hw.h"

int main(){
    
    // Init Commands
    uart_init();
    isr_init();
    //tic_init();
    irq_set_mask( 0x00000002 );
    irq_enable();
    everloop_init();

    // everloop
    //uart_putstr( "** everloop **\n" );
    
    everloop_leds(0b01010101);
    msleep(200);
    everloop_leds(0b10101010);
    msleep(200);
    everloop_leds(0b01010101);
    msleep(200);
    everloop_leds(0b10101010);
    msleep(200);
    while(1){
      everloop_leds(everloop_read_sw());    
    }
/*    
    uint8_t i;
    for(i=0;i<8;i++){
        everloop_leds(0x01); //COnvertir a binario
        msleep(20);
        everloop_leds(0x02);
        msleep(20);
        everloop_leds(0x04);
        msleep(20);
        everloop_leds(0x08);
        msleep(20);
        everloop_leds(0x10);
        msleep(20);
        everloop_leds(0x20);
        msleep(20);
        everloop_leds(0x40);
        msleep(20);
        everloop_leds(0x80);
        msleep(20);
        
        everloop_leds(0x80);
        msleep(20);
        everloop_leds(0x40);
        msleep(20);
        everloop_leds(0x20);
        msleep(20);
        everloop_leds(0x10);
        msleep(20);
        everloop_leds(0x08);
        msleep(20);
        everloop_leds(0x04);
        msleep(20);
        everloop_leds(0x02);
        msleep(20);
        everloop_leds(0x01);
        msleep(20);

    }
    
    return 0;
*/
}

