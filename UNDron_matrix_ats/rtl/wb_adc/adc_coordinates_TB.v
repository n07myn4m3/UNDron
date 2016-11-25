/* -----------------------------------------------------
   TESTBENCH EVERLOOP
   -----------------------------------------------------

=> RECOMENDACIONES 
	Las entradas son registros (reg) las salidas son cables (wires).

=> ESQUEMA DEL MODULO

                    ____________
                   |            | (rst)     		-------->
 (ena)    -------->|    ADC     | (ena_out)     -------->
 (clk_in) -------->|    xyz     | (clk_out)     --------> 
 (rst)    -------->|            | (do)          --------> 
                   |____________| (coordinates) --------> 

*/

`timescale 10ns / 1ps
`define SIMULATION


module adc_coordinates_TB;

//---------------------------------------------------------------------------
// Descripcion de las entradas y salidas del modulo
//---------------------------------------------------------------------------

	reg rst;
  reg ena;
  reg clk;
  wire done;
  wire [23:0] coordinates;


        reg data_chl;
        wire cs0;
        wire cs1;
        wire ch_sel;

  adc_coordinates uut (.ena(ena),.clk(clk),.rst(rst),.done(done),.coordinates(coordinates),.data_chl(data_chl),.cs0(cs0),.cs1(cs1),.chl_sel(chl_sel));

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
      clk = 0; rst = 1; data_chl = 1'b1;
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
          ena = 1;
      end
   end

//---------------------------------------------------------------------------
// Salida de datos archivo .vcd
//---------------------------------------------------------------------------

   initial begin: TEST_CASE
     $dumpfile("adc_coordinates_TB.vcd");
     $dumpvars(-1, uut);
	
     #10 -> reset_trigger;
     #((PERIOD*DUTY_CYCLE)*2000000) $finish;
   end

endmodule


