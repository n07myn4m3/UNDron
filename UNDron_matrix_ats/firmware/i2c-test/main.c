
#include "soc-hw.h"
//#include "softfloat.h"

int main(){
//

      for(;;){
   
		i2c_putrwaddr(0x00, 0x40);
		i2c_putrwaddr(0x00, 0x30);
		i2c_putchar(0x80); 
		//nsleep(150);
		i2c_sleep();

 	   }
    return 0;
}
