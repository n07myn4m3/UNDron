/* -----------------------------------------------------
   wb_everloop
   -----------------------------------------------------
	██╗   ██╗███╗   ██╗██████╗ ██████╗  ██████╗ ███╗   ██╗    
	██║   ██║████╗  ██║██╔══██╗██╔══██╗██╔═══██╗████╗  ██║    
	██║   ██║██╔██╗ ██║██║  ██║██████╔╝██║   ██║██╔██╗ ██║    
	██║   ██║██║╚██╗██║██║  ██║██╔══██╗██║   ██║██║╚██╗██║    
	╚██████╔╝██║ ╚████║██████╔╝██║  ██║╚██████╔╝██║ ╚████║    
	 ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝  
   DESCRIPCIÓN DE LOS REGISTROS
   0x00 everloop_ram

   FUNCIONAMIENTO
   * La direccion adr_a de la memoria RAM depende de la direccion escrita presente en el wishbone
     y de un valor de uno o cero 
   * ---   

   CONVENCIONES      
   * --- 
   * ---

   INDICADORES
   * PROBLEMA: Situacion que genera conflicto y debe corregirse
   * NPI: Declaracion que no se conoce
*/

module wb_everloop#(
  parameter mem_file_name = "none"  
)(
  input              clk,
  input              rst,
     
   // Wishbone interface
   input              wb_stb_i,
   input              wb_cyc_i,
   output             wb_ack_o,
   input              wb_we_i,
   input       [31:0] wb_adr_i,
   input        [3:0] wb_sel_i,
   input       [31:0] wb_dat_i,
   output reg  [31:0] wb_dat_o,

   // Everloop interface
   output everloop_led_ctl // Es la salida que va conectada al everloop fisico
   //input  led_fb,  // Esta entrada no es utilizada NPI
);


assign wb_ack_o = wb_stb_i & wb_cyc_i & ack;

wire wb_rd = wb_stb_i & wb_cyc_i & ~wb_we_i;
wire wb_wr = wb_stb_i & wb_cyc_i &  wb_we_i;
reg  ack;

//registros de prueba

reg [7:0] prueba_1;
reg [7:0] prueba_2;
reg [7:0] prueba_3;

  always @(posedge clk)
  begin
    if (rst) begin
      ack         <= 0;
      prueba_1    <= 8'b0;
      prueba_2    <= 8'b0;
      prueba_3    <= 8'b0;
    end else begin
	  wb_dat_o[31:8] <= 24'b0;
      // Handle WISHBONE access
      ack    <= 0;
//--------------------------------------------------------------------------------
     if (wb_rd & ~ack) begin               // Operación de lectura Wishbone
       ack <= 1;
			case (wb_adr_i[4:2])

				3'b001: begin               // Switches
					wb_dat_o[7:0] <= 8'b0; //Mostrar registro de estado
				end

				3'b010: begin               // Botones
					wb_dat_o[7:0] <= 8'b0; //Por defecto los dejo en cero
				end
      
				default: begin
					wb_dat_o[7:0] <= 8'b0; //Debido a que no estoy leyendo nada, en caso de escritura se debe incluir un case con la direccion de los switches y asignarle a wb_dat_0 los valores de la entrada, de switchs o buttons.	
				end
	        endcase
     end
//--------------------------------------------------------------------------------
     else if (wb_wr & ~ack ) begin // write cycle
       ack <= 1;
			case (wb_adr_i[7:0])
				'h00: begin
                    prueba_1 <= wb_dat_i[7:0];
				end
				'h04: begin
					prueba_2 <= wb_dat_i[7:0];
		    end
				'h08: begin
					prueba_3 <= wb_dat_i[7:0];
				end
				default: begin
                    prueba_1 <= 8'b0;
                    prueba_2 <= 8'b0;
                    prueba_3 <= 8'b0;
				end
			endcase
     end
    end
  end

endmodule
