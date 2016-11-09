//---------------------------------------------------------------------------
// Wishbone I2C
//
// Register Description:
//
//    0x00 UCR      [ 0 | 0 | 0 | 0 | ena | 0 | ack_error | busy ]
//    0x04 DATA_WXRX
//    0x08 ADDR-RW  [rw | addr] esto debe venir asi desde el software     
// 
//---------------------------------------------------------------------------

module wb_i2c(

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
	// i2c Wires
	inout             i2c_sda,
	inout             i2c_scl
);

//---------------------------------------------------------------------------
// Actual 	I2C engine
//---------------------------------------------------------------------------
wire [7:0] data_rd;
wire       busy;
wire       ack_error;
reg [6:0] addr;
reg [7:0] data_wr;
reg        ena;
reg        rw;



i2c_master i2c0 (
	.clk(       clk      ),
	.reset(     reset    ),
	//
	.scl(  i2c_scl ),
	.sda( i2c_sda ),
	//
    .ena( ena ),
	.data_rd(   data_rd  ),
	.busy(  busy ),
	.ack_error(  ack_error ),
	.addr(    addr   ),
	.rw(     rw    ),
	.data_wr(   data_wr  )
);

//---------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------
wire [7:0] ucr = { 4'b0, ena, 1'b0, ack_error, busy };
reg [7:0] prueba;
//assign ucr=ucr_aux;

wire wb_rd = wb_stb_i & wb_cyc_i & ~wb_we_i;
wire wb_wr = wb_stb_i & wb_cyc_i &  wb_we_i;

reg  ack;

assign wb_ack_o = wb_stb_i & wb_cyc_i & ack;

always @(posedge clk) begin
	if(reset) begin
		wb_dat_o[31:8] <= 24'b0;
		ena <= 1'b0;
		ack <= 1'b0;
	end else begin
		wb_dat_o[31:8] <= 24'b0;
		ack <= 1'b0;
		
		if(wb_rd & ~ack)begin
			ack<= 1'b1;

			case (wb_adr_i[4:2]) 
	 			3'b000: begin
					wb_dat_o[7:0] <= ucr;
				end
				3'b001: begin
					wb_dat_o[7:0] <= data_rd;
				end
				default: begin
	 				wb_dat_o[7:0] <= 8'b0;
				end
			endcase
		end else if (wb_wr & ~ack) begin
			ack <= 1'b1;

			case (wb_adr_i[7:0])
				'h00: begin
					ena    <= wb_dat_i[3];
                    prueba <= wb_dat_i[7:0];
				end
				'h04: begin
					data_wr <= wb_dat_i[7:0];
		        end
				'h08: begin
					rw   <= wb_dat_i[7];	
					addr <= wb_dat_i[6:0];
					//ena  <= 1'b1;
				end
				default: begin
					ena<= 1'b0;
					data_wr <= 8'b0;
					addr <= 7'bx;
					rw <= 1'b0;
				end
			endcase
		end
	end
end
        
endmodule
