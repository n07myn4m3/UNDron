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

//Valores para probar las librerias de coma flotante
  volatile uint32_t entero;
  float32 multiplicacion;
  float32 division;


  for(;;){
   // uart_putchar(0x20);
 //   pwm_init();

//Prueba i2c
     uart_putstr("Prueba Lab");
	 i2c_putrwaddr(0x00, 0x40);
	 //i2c_putrwaddr(0x01, 0x50);
	 //i2c_putrwaddr(0x00, 0x70);
	 //i2c_putrwaddr(0x01, 0x50);
//Prueba lectura i2c
     I2CreadByte(0x30, 0x35); 

//Prueba unidades de punto flotante    
    multiplicacion=float32_mul( PI, alfa );
    entero=float32_to_int32(multiplicacion);
    gpio0->oe  = 0x000000ff;
    gpio0->out = multiplicacion;
//-----------------------------------
	 //i2c_putrwaddr(0x01, 0x23);

//Prueba modulo problematico
//everloop_putdata_2(0x41);
//everloop_putdata_1(0x40);
//everloop_putdata_2(0x41);
//everloop_putdata_3(0x42);


//Prueba unidades de punto flotante    
    multiplicacion=float32_mul( PI, alfa );
    entero=float32_to_int32(multiplicacion);
    gpio0->ctrl=entero;

    division=float32_div( PI, alfa );
    entero=float32_to_int32(division);
    gpio0->ctrl=entero;

    //nsleep(20);
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

