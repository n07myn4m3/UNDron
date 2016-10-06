/*
 * AdMobilize 
 * Array of PDM microphones
 */


module everloop_ram #(
  parameter mem_file_name = "none",
	parameter adr_width = 7,
	parameter dat_width = 7
) (
	// write port a 
	input      clk_a,
	input      en_a,
	input      en_b,
	input      [9:0] adr_a,
	input 	   [7:0] dat_a,
	// read port b
	input      clk_b,
	input      [7:0] adr_b,
	output reg [7:0] dat_b,
	output reg [7:0] dat_a_out,
	input  we_a
);

parameter depth = (1 << adr_width);
// actual ram cells
reg [dat_width-1:0] ram [0:depth-1];
//------------------------------------------------------------------
// read port B
//------------------------------------------------------------------
always @(posedge clk_b)
begin
  if (en_b)
    dat_b <= ram[adr_b];
end

//------------------------------------------------------------------
// write port A
//------------------------------------------------------------------
always @(posedge clk_a)
begin
  if (en_a) begin
    if (we_a) begin
      ram[adr_a] <= dat_a;
    end 
  end 
end


initial 
begin
  if (mem_file_name != "none") begin
    $readmemh(mem_file_name, ram);
  end
end


endmodule
