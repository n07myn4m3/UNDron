//---------------------------------------------------------------------------
// Wishbone SPI
//
// Register Description:
//
//    0x00 UCR      [ 0 | 0 | 0 | 0 | count | enable | 0 | busy ]
//    0x04 RX_DATA AND TX_DATA
//		
//---------------------------------------------------------------------------

module wb_spi #(
	parameter slaves = 1,
	parameter d_width = 8
  ) (
	input              clk,
	input              reset,
	// Wishbone interface
	input              wb_stb_i,
	input              wb_cyc_i,
	output             wb_ack_o,
	input              wb_we_i,
	input       [31:0] wb_adr_i,
	input        [3:0] wb_sel_i,
	input       [31:0] wb_dat_i,
	output reg  [31:0] wb_dat_o,
	// Serial Wires
	input              miso_rxd,
	output             mosi_txd,
	output 						 sclk,
	output 						 ss_n,
	output 			 			 csn,
	output 						 ce
);

//---------------------------------------------------------------------------
// Actual SPI engine
//---------------------------------------------------------------------------
  reg enable =1'b0;
	wire cpol;
	wire cpha;
  reg [d_width-1:0] tx_data = 1'b0;
  wire [9:0] clk_div;
  wire busy;
	reg  							  csn= 1'b0;
	reg 								ce = 1'b0;
  wire							 ss_n;
  wire [d_width-1:0] rx_data;


spi_master #(
	.d_width(	d_width )
) spi0(
	.clk(       clk      ),
	.rst(     reset    ),
	//
	.sclk(	sclk		 ),
	.ss_n(	ss_n		 ),
	.miso(  miso_rxd ),
	.mosi(  mosi_txd ),
	//
	.enable(    enable   ),
	.cpol(			cpol		 ), //Se adjunta por defecto en el wb
	.cpha(			cpha		 ), //Se adjunta por defecto en el wb
	.clk_div(		clk_div	 ), //Se adjunta por defecto en el wb
	.tx_data(		tx_data	 ),
	.rx_data(   rx_data  ),
	.busy(  		busy		 )
);

//---------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------
assign cpol = 1'b0;
assign cpha = 1'b0;
assign clk_div = 5;

wire [7:0] ucr = { 5'b0 , enable , 1'b0 , busy };

wire wb_rd = wb_stb_i & wb_cyc_i & ~wb_we_i;
wire wb_wr = wb_stb_i & wb_cyc_i &  wb_we_i;

reg  ack;

assign wb_ack_o       = wb_stb_i & wb_cyc_i & ack;


always @(posedge clk)
begin
	if (reset) begin
		wb_dat_o[31:8] <= 24'b0;
		ack            <= 0;
	end else begin
		wb_dat_o[31:8] <= 24'b0;
		ack 					 <= 0;
		if (wb_rd & ~ack) begin
			ack <= 1;

			case (wb_adr_i[5:2])
				3'b000: begin
					wb_dat_o[7:0] <= ucr;
				end
				3'b001: begin
					wb_dat_o[7:0] <= rx_data;
				end
				default: begin
					wb_dat_o[7:0] <= 8'b0;
				end
			endcase
		end else if (wb_wr & ~ack ) begin
			ack <= 1;

			case (wb_adr_i[5:2])
				3'b000: begin
					enable  <= wb_dat_i[2];
				end
				3'b001: begin
					tx_data <= wb_dat_i[7:0];
				end
				3'b010: begin
					csn		<= wb_dat_i[0];
		    end
				3'b011: begin
					ce    <= wb_dat_i[0];
				end
				default: begin
					enable  <= 1'b0;
					tx_data <=8'bx;
				end
			endcase
		end
	end
end

endmodule 
			
