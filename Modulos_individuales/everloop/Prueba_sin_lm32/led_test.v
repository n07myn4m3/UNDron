module led_test#(
  parameter mem_file_name = "image.ram"  
)(
  input clk,
  input rst,
  
  // LED interface
  output led_ctl
);
/*
=> ESQUEMA DEL MODULO
		                      ____________
	 clk            -------->|>           |--------> led_ctl                        
	 rst            -------->|            |                      
		                     |  led_test  |                                        
		                     |            |
                             |____________|
*/

wire  [7:0]  data_b;
wire  [10:0] adr_b;


everloop everloop0(
  .clk(clk),
  .rst(rst),
  .address(adr_b),
  .data_RGB(data_b),
  .everloop_d(led_ctl)
);

everloop_ram #(
  .adr_width(11), 
  .dat_width(8), 
  .mem_file_name(mem_file_name)
) everloopram0(
  .clk_a(clk),
  .en_a (1'b0),
  .adr_a(10'd0),
  .dat_a(7'd0),
  .we_a (1'b0),
//------------------
  .clk_b(clk),
  .en_b (1'b1),
  .adr_b(adr_b),
  .dat_b(data_b)	
);

endmodule
