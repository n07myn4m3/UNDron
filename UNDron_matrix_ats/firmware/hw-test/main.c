
#include "soc-hw.h"
#include "softfloat.h"

int main(){
//
/*    volatile unsigned int     *data32;
    data32 = (volatile unsigned int   *)(0x70000000);
    data32++;
    *data32 = PI;*/
    
    // Init Commands//
//    uart_init();
//    isr_init();
    //tic_init();
//    irq_set_mask( 0x00000002 );
//    irq_enable();


  for(;;){
    uart_putchar(0x20);
    pwm_init();

    // BasicIO
    //uart_putstr( "** BasicIO **\n" );
 	i2c_putrwaddr(0x00, 0x30);   
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
  }    
    return 0;
}

