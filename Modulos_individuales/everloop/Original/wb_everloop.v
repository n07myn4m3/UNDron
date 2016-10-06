module wb_everloop#(
  parameter mem_file_name = "none"  
)(
  input clk,nrst,
  
  // LED interface
  output led_ctl,
  input  led_fb,
    
  // Wishbone interface
  input              wb_stb_i,
  input              wb_cyc_i,
  input              wb_we_i,
  input       [13:0] wb_adr_i,
  input        [1:0] wb_sel_i,
  input       [15:0] wb_dat_i,
  output      [15:0] wb_dat_o   
);

wire wb_rd = wb_stb_i & wb_cyc_i & ~wb_we_i;
wire wb_wr = wb_stb_i & wb_cyc_i & wb_we_i;

wire [7:0] data_b;
wire  [10:0] adr_b;
reg [2:0] swr;
reg [7:0] data_a;
reg add_adr_a;

always @(negedge clk)  swr <= {swr[1:0],wb_wr};

wire wr_fallingedge = (swr[2:1]==2'b10);



everloop everloop0(
  .clk(clk),
  .rst(nrst),
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
  .en_a (wb_wr | add_adr_a),
  .adr_a({wb_adr_i[9:0],add_adr_a}),
  .dat_a(data_a[7:0]),
  .we_a (wb_wr | add_adr_a),
  .clk_b(clk),
  .en_b (1'b1),
  .adr_b(adr_b),
  .dat_b(data_b)	
);

always @(posedge clk)
begin

case({wb_wr,wr_fallingedge})
  2'b10: begin
    data_a <= wb_dat_i;
    add_adr_a <= 0;
  end
  2'b01:begin
    data_a <= data_a >>8;
    add_adr_a <= 1;
  end
  
  default: begin
    data_a <= data_a;
    add_adr_a <= 0;
  end
endcase
end

endmodule
