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
=> Anotaciones
   - Esta version no posee eventos, se espera que esto permita 
	 implementar las pruebas del modulo i2c

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
// Prueba I2C JULKN
//---------------------------------------------------------------------------

reg          start = 1'b0;  // FLAG
reg          wr = 1'b0;     // FLAG
reg   [3:0]  count_aux = 9;
reg   [1:0]  direc = 0;     // FLAG
reg   [8:0]  count;
reg   [7:0]  vamo_a_leer = 8'h02;
reg          sda_out = 1'bz;

assign i2c_sda = sda_out; 


    always @(negedge i2c_sda) begin
       @ (negedge clk) begin
         if(i2c_scl == 1'b1) begin
            start = 1'b1;   
//            sda_out <= 1'b1;
          end
       end
    end
   
  always @(negedge i2c_scl) begin
    #2505 
      if(start) begin
         count = count-1;
         if(count == 0) begin
            start = 1'b0;
            count = 9;
            $display("start = %b,sda = %h, wr = %h",start,i2c_sda,wr);
              if(i2c_sda == 1'b0)begin  
                wr = 0;
              end else begin
                wr = 1;
                direc = 0;      
              end            
        end
     end
  end
               
  always @(negedge i2c_scl) begin    
     #2505                             //Espera 250 para cambiar los datos cuando slc esta en
       if (wr  && (direc < 2)) begin 
           count_aux = count_aux-1; 
           if (count_aux <= 8) begin
               sda_out = vamo_a_leer[count_aux-1] ? 1'b1:1'b0;
               if(count_aux == 0) begin
                  count_aux = 9;
                  sda_out = 1'bz;
                  vamo_a_leer = $random;  //Después de la primer escritura precargada en el TB, precarga nuevos data_wr
                  $display("VALORES RAMDON = %b,VALORES RAMDON = %h",vamo_a_leer, vamo_a_leer); 
                  direc = direc+1;
               end  
           end
       end 
    end

//---------------------------------------------------------------------------
// Modulos auxiliares Divisor de frecuencias
//---------------------------------------------------------------------------
	wire ClkOut;
    reg init;	

	freqDiv aux1 (
		.ClkOut(ClkOut),
		.Clk(clk),
		.Reset(init)
      );

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
// Inicializacion de las entradas del modulo
//---------------------------------------------------------------------------
   initial begin  
      clk = 0; rst = 0; uart_rxd = 0; spi_miso = 0; start = 0; count = 9;
   end
//---------------------------------------------------------------------------
// Definicion del reloj
//---------------------------------------------------------------------------

   parameter PERIOD          = 2;  //Mantener si los parametros de simulacion permiten 20ns / 1ps 
   parameter real DUTY_CYCLE = 0.5;
   parameter OFFSET          = 0;
   reg [20:0] i;

   always clk = #(PERIOD-(PERIOD*DUTY_CYCLE)) ~clk;

//-----------------------------------------
    always @(negedge clk) begin
      init <= (i2c_scl == 1'b0) ? 1'b1:1'b0;  //Prueba 1
      sda_out = 1'b0;   //Prueba 2
    end
//-----------------------------------------

//---------------------------------------------------------------------------
// Recopilacion de datos
//---------------------------------------------------------------------------
initial begin: TEST_CASE
     $dumpfile("system_tb.vcd");
     $dumpvars(-1, uut, aux1);
       //--------------------------------
		for(i=0; i<4; i=i+1) begin
			@ (negedge clk);
		end 
      		rst <= 1;
        //sda_out = 1'b0;   //Prueba 3
       //--------------------------------
     #((PERIOD*DUTY_CYCLE)*400000) $finish;
end


endmodule
