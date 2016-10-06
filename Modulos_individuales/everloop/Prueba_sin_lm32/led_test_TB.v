/* -----------------------------------------------------
   TESTBENCH EVERLOOP
   -----------------------------------------------------

=> RECOMENDACIONES 
	Las entradas son registros (reg) las salidas son cables (wires).

=> ESQUEMA DEL MODULO
		                      ____________
	 clk            -------->|>           |--------> led_ctl                        
	 rst            -------->|            |                      
		                     |  led_test  |                                        
		                     |            |
                             |____________|

*/

`timescale 10ns / 1ps
`define SIMULATION


module led_test_TB;

//---------------------------------------------------------------------------
// Descripcion de las entradas y salidas del modulo
//---------------------------------------------------------------------------
  reg clk;
  reg rst;

  wire led_ctl;

  led_test uut (
	  .clk(clk), 
	  .rst(rst),
	  .led_ctl(led_ctl)
  );
//---------------------------------------------------------------------------
// Definicion del reloj de pruebas
//---------------------------------------------------------------------------
   parameter PERIOD          = 2;   
   parameter real DUTY_CYCLE = 0.5;
   parameter OFFSET          = 0;
   reg [20:0] i;
   event reset_trigger;
//---------------------------------------------------------------------------
// Inicializacion de las entradas del modulo
//---------------------------------------------------------------------------
   initial begin  
      clk = 0; rst = 1; 
   end
//---------------------------------------------------------------------------
// Proceso para el reloj
//---------------------------------------------------------------------------
   initial  begin  
     #OFFSET;
     forever
       begin
         clk = 1'b0;
         #(PERIOD-(PERIOD*DUTY_CYCLE)) clk = 1'b1;
         #(PERIOD*DUTY_CYCLE);
       end
   end
//---------------------------------------------------------------------------
// Reseteo del sistema, inicia el proceso de captura de datos
//---------------------------------------------------------------------------
   initial begin 
      forever begin 
        @ (reset_trigger);
      		rst = 0;      
      end
   end

//---------------------------------------------------------------------------
// Salida de datos archivo .vcd
//---------------------------------------------------------------------------

   initial begin: TEST_CASE
     $dumpfile("led_test_TB.vcd");
     $dumpvars(-1, uut);
	
     #10 -> reset_trigger;
     #((PERIOD*DUTY_CYCLE)*2000000) $finish;
   end

endmodule


