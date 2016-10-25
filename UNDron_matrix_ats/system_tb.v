/* -----------------------------------------------------
   TESTBENCH LM32
   -----------------------------------------------------
	██╗   ██╗███╗   ██╗██████╗ ██████╗  ██████╗ ███╗   ██╗    
	██║   ██║████╗  ██║██╔══██╗██╔══██╗██╔═══██╗████╗  ██║    
	██║   ██║██╔██╗ ██║██║  ██║██████╔╝██║   ██║██╔██╗ ██║    
	██║   ██║██║╚██╗██║██║  ██║██╔══██╗██║   ██║██║╚██╗██║    
	╚██████╔╝██║ ╚████║██████╔╝██║  ██║╚██████╔╝██║ ╚████║    
	 ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝    

=> RECOMENDACIONES 
   - Las entradas son registros (reg) las salidas son cables (wires).
   - Si se trata de un puerto bidireccional los puertos son declarados 
	 como wires

---------- Codigo de prueba revisar mas tarde -----------------------------------
wire [7:0] input_value;
wire [7:0] bidir_signal;
reg [7:0] output_value;
reg output_value_valid;

mymodule myinstance (
  ...
  ...
  .bidir_signal(bidir_signal),
  ...
  ...
);

assign input_value  = bidir_signal;
assign bidir_signal = (output_value_valid==1'b1)? output_value : 8'hZZ;

initial begin
  output_value_valid = 0;
  // use bidir_signal as input here so you can read its current value
  //
  $display ("Current value: %x\n", input_value);
  #100;
  // now we switch to output signal: we write value 10101010 in it
  output_value_valid = 1;
  output_value = 8'hAA;
  #100;
  $finish;
end
-----------------------------------------------------------------------------------

=> ESQUEMA DEL MODULO

		                      ____________
	 clk            -------->|>           |--------> led                         
	 rst            -------->|            |                      
	 	                     |            |<-------- uart_rxd                                        
		                     |    LM_32   |--------> uart_txd
		                     |            |
	 	                     |            |<-------- spi_miso
	 	                     |            |--------> spi_mosi
	 	                     |            |--------> spi_clk
		                     |            |
	 	                     |            |<-------> i2c_sda
	 	                     |            |<-------> i2c_scl
		                     |            |
	 	                     |____________|--------> everloop_led_ctl

*/

`timescale 10ns / 1ps
`define SIMULATION


module system_tb;

//---------------------------------------------------------------------------
// Descripcion de las entradas y salidas del modulo
//---------------------------------------------------------------------------
	reg             clk;
	// Debug 
	wire            led;
	reg             rst;

	// UART
	reg             uart_rxd; 
	wire            uart_txd;
	// SPI
	reg             spi_miso; 
	wire            spi_mosi;
	wire            spi_clk;
	// 12c
	wire             i2c_sda; 
	wire             i2c_scl;
	// everloop
    wire            everloop_led_ctl;

    // Parametros

	parameter tck              = 20;       // clock period in ns
	parameter uart_baud_rate   = 1152000;  // uart baud rate for simulation 
	parameter clk_freq         = 1000000000 / tck; // Frecuencia del reloj en Hz

  system #(
	  .clk_freq(clk_freq),
	  .uart_baud_rate(uart_baud_rate)
  ) uut  (
	  .clk(clk),
	  // Debug
	  .rst(rst),
	  .led(led),
	  // Uart
	  .uart_rxd(uart_rxd),
	  .uart_txd(uart_txd),
	// SPI
	  .spi_miso(spi_miso), 
	  .spi_mosi(spi_mosi),
	  .spi_clk(spi_clk),
	// 12c
	  .i2c_sda(i2c_sda), 
	  .i2c_scl(i2c_scl),
	// everloop
      .everloop_led_ctl(everloop_led_ctl)
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
      clk = 0; rst = 0; uart_rxd = 0; spi_miso = 0;
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
       for(i=0; i<4; i=i+1) begin
         @ (negedge clk);
       end 
      		rst = 1; 
/* 
       for(i=0; i<4; i=i+1) begin
         @ (negedge clk);
       end
			data_RGB = 8'h5D;	
			ack = 1;
       @ (negedge clk);
            ack = 0;
*/
      end
   end

//---------------------------------------------------------------------------
// Salida de datos archivo .vcd
//---------------------------------------------------------------------------

   initial begin: TEST_CASE
     $dumpfile("system_tb.vcd");
     $dumpvars(-1, uut);
	
     #10 -> reset_trigger;
     #((PERIOD*DUTY_CYCLE)*200000) $finish;
   end

endmodule
