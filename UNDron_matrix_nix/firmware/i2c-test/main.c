
#include "soc-hw.h"
//#include "softfloat.h"

int main(){
//

      for(;;){

    
//		isr_init();
//		uart_init();
//		i2c_putchar(0x54);
//		spi_putchar(0x40);
//		spi_init();
//		spi_sleep();
//		spi_getchar();
//		uart_putstr("Probando 1 2 3");
		i2c_putrwaddr(0x00, 0x40);
		i2c_putchar(0x80);
		//nsleep(150);
		i2c_sleep();
//		uart_putstr("my heart feel so bad\n");
//		i2c_putrwaddr(0x00, 0x20);
//		i2c_init();
//		spi_sleep();
//		spi_init();
//		spi_putstr("Hola Mundo");
//		spi_sleep();
//		nsleep(200);
//		uart_putstr("my heart feel so bad\n");
//    nsleep(20);
//		i2c_sleep();
    }
    return 0;
}

