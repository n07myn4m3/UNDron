module
wb_pwm #(
	parameter bit_resolution = 8,
	parameter phases = 1
)(
	input clk,
	input rst,
// Interfaz del wishbone
	input              wb_stb_i,//senal selecciona esclavo
	input              wb_cyc_i,// ciclo de bus en progreso
	output             wb_ack_o,//respuesta a stb
	input              wb_we_i, //senal de flujo ciclo
	input       [31:0] wb_adr_i,//bus dir
	input        [3:0] wb_sel_i,//valida data
	input       [31:0] wb_dat_i,//data in
	output reg  [31:0] wb_dat_o, //data out
// Interfaz del modulo
    output [phases*3:0] pwm_out
//  output [phases-1:0] pwm_n_out
);

	reg [bit_resolution-1:0] duty0;
	reg [bit_resolution-1:0] duty1;
	reg [bit_resolution-1:0] duty2;
	reg [bit_resolution-1:0] duty3;

	reg                      ena;

pwm pwm0(.clk ( clk ),.rst ( rst ),.ena ( ena ),.duty ( duty0 ),.pwm_out ( pwm_out[0] )/*,pwm_n_out ( pwm_n_out )*/);
pwm pwm1(.clk ( clk ),.rst ( rst ),.ena ( ena ),.duty ( duty1 ),.pwm_out ( pwm_out[1] )/*,pwm_n_out ( pwm_n_out )*/);
pwm pwm2(.clk ( clk ),.rst ( rst ),.ena ( ena ),.duty ( duty2 ),.pwm_out ( pwm_out[2] )/*,pwm_n_out ( pwm_n_out )*/);
pwm pwm3(.clk ( clk ),.rst ( rst ),.ena ( ena ),.duty ( duty3 ),.pwm_out ( pwm_out[3] )/*,pwm_n_out ( pwm_n_out )*/);

/*
		    	_________
      clk----->|         |
      rst----->|		 |
      ena----->|   pwm	 |
			   |      	 |----->pwm_out
      duty---->|_________|----->pwm_n_out

*/

wire wb_rd = wb_stb_i & wb_cyc_i & ~wb_we_i; //Es propio del wishbone
wire wb_wr = wb_stb_i & wb_cyc_i &  wb_we_i; //Es propio del wishbone
reg  ack; //Es propio del wishbone

assign wb_ack_o       = wb_stb_i & wb_cyc_i & ack; //Es propio del wishbone


always @(posedge clk)
begin
	if (rst) begin
		duty0[bit_resolution-1:0] <= 0;
		duty1[bit_resolution-1:0] <= 0;
		duty2[bit_resolution-1:0] <= 0;
		duty3[bit_resolution-1:0] <= 0;
		ena <= 0;
	end else begin
		wb_dat_o[31:8] <= 24'b0;
		ack    <= 0;
// Operacion de lectura del wishbone
/*		if (wb_rd & ~ack) begin
			ack <= 1;
      wb_dat_o[7:0] <= 8'd0;
		end
*/
// Operacion de escritura del wishbone 
		if (wb_wr & ~ack ) begin
			ack  <= 1;
      case (wb_adr_i[5:2])
	    4'b0000: ena    <= wb_dat_i[0];
        4'b0001: duty0  <= wb_dat_i[7:0];
        4'b0010: duty1  <= wb_dat_i[7:0];
        4'b0011: duty2  <= wb_dat_i[7:0];
        4'b0100: duty3  <= wb_dat_i[7:0];
       endcase
		end
	end
end

endmodule


