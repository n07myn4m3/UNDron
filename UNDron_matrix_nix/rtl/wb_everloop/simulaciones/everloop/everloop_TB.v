/* -----------------------------------------------------
   TESTBENCH EVERLOOP
   -----------------------------------------------------
	██╗   ██╗███╗   ██╗██████╗ ██████╗  ██████╗ ███╗   ██╗    
	██║   ██║████╗  ██║██╔══██╗██╔══██╗██╔═══██╗████╗  ██║    
	██║   ██║██╔██╗ ██║██║  ██║██████╔╝██║   ██║██╔██╗ ██║    
	██║   ██║██║╚██╗██║██║  ██║██╔══██╗██║   ██║██║╚██╗██║    
	╚██████╔╝██║ ╚████║██████╔╝██║  ██║╚██████╔╝██║ ╚████║    
	 ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝    

=> RECOMENDACIONES 
	Las entradas son registros (reg) las salidas son cables (wires).

=> ESQUEMA DEL MODULO
		                      ____________
	 clk            -------->|>           |--------> everloop_d                         
	 rst            -------->|            |--------> en_rd                      
	 ack            -------->|            |                                        
		                     |  everloop  |
		                     |            |
	 reset_everloop -------->|            |
	 data_RGB       -------->|____________|

*/

`timescale 10ns / 1ps
`define SIMULATION


module everloop_TB;

//---------------------------------------------------------------------------
// Descripcion de las entradas y salidas del modulo
//---------------------------------------------------------------------------
  reg clk, rst;
  reg [7:0] data_RGB;
  reg ack;
  reg reset_everloop;

  wire everloop_d;
  wire en_rd;

  everloop uut (
	  .clk(clk), 
	  .rst(rst),
	  .data_RGB(data_RGB),
	  .ack(ack),
	  .reset_everloop(reset_everloop),
	  //---------------
	  .everloop_d(everloop_d),
	  .en_rd(en_rd)
  );
//---------------------------------------------------------------------------
// Definicion del reloj de pruebas
//---------------------------------------------------------------------------
   parameter PERIOD          = 2;  //Mantener si los parametros de simulacion permiten 20ns / 1ps 
   parameter real DUTY_CYCLE = 0.5;
   parameter OFFSET          = 0;
   reg [20:0] i;
   event reset_trigger;
//---------------------------------------------------------------------------
// Inicializacion de las entradas del modulo
//---------------------------------------------------------------------------
   initial begin  
      clk = 0; rst = 1; data_RGB = 8'h00; ack = 0; reset_everloop = 1; 
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
            reset_everloop = 0;    
       for(i=0; i<4; i=i+1) begin
         @ (negedge clk);
       end
			data_RGB = 8'h5D;	
			ack = 1;
       @ (negedge clk);
            ack = 0;
      end
   end

//---------------------------------------------------------------------------
// Salida de datos archivo .vcd
//---------------------------------------------------------------------------

   initial begin: TEST_CASE
     $dumpfile("everloop_TB.vcd");
     $dumpvars(-1, uut);
	
     #10 -> reset_trigger;
     #((PERIOD*DUTY_CYCLE)*1000) $finish;
   end

endmodule


