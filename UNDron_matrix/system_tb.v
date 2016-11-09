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
// Modulos auxiliares 
//---------------------------------------------------------------------------
   //------------------------------------------------------------------------
   // Divisor de frecuencias 
   //------------------------------------------------------------------------
	 wire ClkOut;	
    reg  start=1'b0;

	freqDiv freqDiv1 (
		.ClkOut(ClkOut),
		.Clk(clk),
		.Reset(start)
      );

   //------------------------------------------------------------------------
   // Analizador 
   //------------------------------------------------------------------------
    reg  INPUT_A, INPUT_B , INPUT_C, INPUT_D, INPUT_E;
    wire OUTPUT_A, OUTPUT_B ,OUTPUT_C ,OUTPUT_D , OUTPUT_E;
   analyzer analyzer1( 
		.clk(clk), 
		.INPUT_A(INPUT_A), 
		.INPUT_B(INPUT_B), 
		.INPUT_C(INPUT_C), 
		.INPUT_D(INPUT_D), 
		.INPUT_E(INPUT_E), 
		.OUTPUT_A(OUTPUT_A), 
		.OUTPUT_B(OUTPUT_B), 
		.OUTPUT_C(OUTPUT_C), 
		.OUTPUT_D(OUTPUT_D), 
		.OUTPUT_E(OUTPUT_E)
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



/*
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
// Prueba I2C
//---------------------------------------------------------------------------
//reg    read    = 1'b0;
reg    sda_out = 1'bz;
assign i2c_sda = sda_out; 
pullup(i2c_scl); 
reg   [7:0]  data_write = 8'b00111101;
reg   [3:0]  count = 7;

    //1) Descubrir cuando el modulo I2C va a realizar una transmision de datos
    //   y verificar si llevara a cabo un proceso de lectura o escritura.
    always @(negedge i2c_sda) begin
       @ (negedge clk) begin
         if(i2c_scl == 1'b1) begin
		        start   = 1'b1; 
		        INPUT_A = 1'b0;
                INPUT_B = 1'b0;
		     //------------------------------   
		        for(i=0; i<9; i=i+1) begin   //Para revisar si el octavo bit del protocolo es
				   @ (posedge ClkOut);       //de lectura o escritura
				  end 
		     //------------------------------
		        //start = 1'b0;
				if(i2c_sda == 1'b0) begin
		        INPUT_A = 1'b0;              //Se llevara a cabo un proceso de escritura
		        end else begin
		        INPUT_A = 1'b1;              //Se llevara a cabo un proceso de lectura
		        end
			end 
         //------------------------------
       end
    end

    //2) Si se lleva a cabo un proceso de lectura reconocer el bloque donde sucederá
    //   interceptar i2c_sda y enviar los datos que se encuentren en data_write
    always @(negedge clk) begin
       //---------------------------
       if(INPUT_A == 1'b1)begin  
  		  for(i=0; i<2; i=i+1) begin   
		   @ (posedge ClkOut);       
		  end 
          INPUT_B = 1'b1;
          if(INPUT_B == 1'b1)begin
		      for(i=0; i<8; i=i+1) begin   
               sda_out = data_write[7-i] ? 1'b1:1'b0;
			   @ (posedge ClkOut);       
			  end 
		      INPUT_B = 1'b0; //Indico que el estado de lectura termino
		      INPUT_A = 1'b0; //Debido a que se hace cero en el siguiente ciclo que satisface la conclusion
		                      //existe el riezgo que INPUT_B vuelva a ser 1.
              sda_out = 1'bz; //Devolver i2c_sda a su estado original 
          end 
       end
       //---------------------------
    end
*/

//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
// Prueba I2C Lectura multiple
//---------------------------------------------------------------------------
//reg    read    = 1'b0;

/*
PREGUNTAS FRECUENTES

1) ¿Para que es el registro checker?

	Lo que sucede es que al inicio del codigo se cumple una condicion de proceso  
	de lectura que no deberia llevarse a cabo, esto se debe a que i2c_sda presen-
   ta un flanco de bajada e i2c_scl esta en alto lo cual indiferente a que inicie
   con un proceso de lectura lo tomara como uno de escritura, se podria solucionar
   mejor el problema pero por el momento funciona.
*/

reg   [7:0] checker = 1'b0;
reg    sda_out = 1'bz;
assign i2c_sda = sda_out; 
pullup(i2c_scl); 
reg   [7:0]  data_write = 8'b00111101;
reg   [3:0]  count = 7;

    //1) Descubrir cuando el modulo I2C va a realizar una transmision de datos
    //   y verificar si llevara a cabo un proceso de lectura o escritura.
    always @(negedge i2c_sda) begin
       @ (negedge clk) begin
         if(i2c_scl == 1'b1) begin
		        start   = 1'b1; 
		        INPUT_A = 1'b0;
              INPUT_B = 1'b0;
		     //------------------------------   
		        for(i=0; i<9; i=i+1) begin   //Para revisar si el octavo bit del protocolo es
				   @ (posedge ClkOut);         //de lectura o escritura
				  end 
		     //------------------------------
		        //start = 1'b0;
				if(i2c_sda == 1'b0) begin
		        INPUT_A = 1'b0;              //Se llevara a cabo un proceso de escritura
		        end else begin
		        INPUT_A = 1'b1;              //Se llevara a cabo un proceso de lectura
              checker = checker + 1;       //Para evitar atrapar al bug
		        end
			end 
         //------------------------------
       end
    end

    //2) Si se lleva a cabo un proceso de lectura reconocer el bloque donde sucederá
    //   interceptar i2c_sda y enviar los datos que se encuentren en data_write

    always @(negedge clk) begin
       //---------------------------
       if(INPUT_A == 1'b1 && checker > 1'b1)begin  

  		  for(i=0; i<2; i=i+1) begin   
		   @ (posedge ClkOut);       
		  end 

        //Primer valor

        data_write = 8'h1D;
        INPUT_B = 1'b1;
          if(INPUT_B == 1'b1)begin
		      for(i=0; i<8; i=i+1) begin   
               sda_out = data_write[7-i] ? 1'b1:1'b0;

			   @ (posedge ClkOut);       
			   end 
		      INPUT_B = 1'b0; //Indico que el estado de lectura termino
            sda_out = 1'bz; //Devolver i2c_sda a su estado original 

          end 

  		  for(i=0; i<1; i=i+1) begin   
		   @ (posedge ClkOut);       
		  end 

        //Segundo valor

        for(j=0; j<4; j=j+1) begin  

				  data_write = data_write + 8'h10;
				  INPUT_B = 1'b1;
				    if(INPUT_B == 1'b1)begin
						for(i=0; i<8; i=i+1) begin   
				         sda_out = data_write[7-i] ? 1'b1:1'b0;
						@ (posedge ClkOut);       
						end 
						INPUT_B = 1'b0; //Indico que el estado de lectura termino
				      sda_out = 1'bz; //Devolver i2c_sda a su estado original 
				    end 

		  		  for(i=0; i<1; i=i+1) begin   
					@ (posedge ClkOut);       
				  end 

        end

        //Ultimo valor

        data_write = 8'h6D;
        INPUT_B = 1'b1;
          if(INPUT_B == 1'b1)begin
		      for(i=0; i<8; i=i+1) begin   
               sda_out = data_write[7-i] ? 1'b1:1'b0;
			   @ (posedge ClkOut);       
			   end 
		      INPUT_B = 1'b0; //Indico que el estado de lectura termino
            INPUT_A = 1'b0; //Debido a que se hace cero en el siguiente ciclo que satisface la conclusion
		                      //existe el riezgo que INPUT_B vuelva a ser 1.
            sda_out = 1'bz; //Devolver i2c_sda a su estado original 
          end 

       end
       //---------------------------
    end





//---------------------------------------------------------------------------
// Definicion del reloj de pruebas
//---------------------------------------------------------------------------
   parameter PERIOD          = 2;  //Mantener si los parametros de simulacion permiten 20ns / 1ps 
   parameter real DUTY_CYCLE = 0.5;
   parameter OFFSET          = 0;
   reg [20:0] i;
   reg [20:0] j;
   event reset_trigger;
//---------------------------------------------------------------------------
// Inicializacion de las entradas del modulo
//---------------------------------------------------------------------------
   initial begin  
      clk = 0; rst = 0; uart_rxd = 0; spi_miso = 0; start = 0; 
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
      end
   end

//---------------------------------------------------------------------------
// Salida de datos archivo .vcd
//---------------------------------------------------------------------------

   initial begin: TEST_CASE
     $dumpfile("system_tb.vcd");
     $dumpvars(-1, uut, freqDiv1, analyzer1);
	
     #10 -> reset_trigger;
     #((PERIOD*DUTY_CYCLE)*400000) $finish;
//     #((PERIOD*DUTY_CYCLE)*100000) $finish; //Prueba corta
//     #((PERIOD*DUTY_CYCLE)*600000) $finish; //Prueba larga
   end

endmodule
