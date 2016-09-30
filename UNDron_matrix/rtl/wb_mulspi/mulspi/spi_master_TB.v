`timescale 1ns / 1ps
`define SIMULATION

module spi_master_TB;

	parameter slaves = 4;
	parameter d_width = 8;

  reg clk, rst, enable, cpol, cpha, cont, miso;
  reg [d_width-1:0] tx_data;
  reg [31:0] clk_div;
  reg [31:0] addr;
  reg [0:(d_width-1)] miso_data;
	reg mode;
  wire sclk1;
  wire ss;
	reg [d_width-1:0] count_t;
  wire mosi, sclk, busy;
  wire [slaves-1:0] ss_n;
  wire [d_width-1:0] rx_data;

spi_master uut(.clk(clk), .rst(rst), .enable(enable), .cpol(cpol), .cpha(cpha), .cont(cont), .clk_div(clk_div), .addr(addr), .tx_data(tx_data), .miso(miso), .sclk(sclk), .ss_n(ss_n), .mosi(mosi), .busy(busy), .rx_data(rx_data));

initial begin

	clk = 1'b0;
	rst = 1'b0;
	enable = 1'b0;
	cpol = 1'b1;
	cpha = 1'b1;
	cont = 1'b1;
	miso = 1'bz;
	tx_data = 8'b00011101;
	clk_div = 5;
	addr = 3;
	miso_data = 8'b01010101;
	mode = !(cpha + cpol);
  count_t = 0;

end 

assign ss = ss_n[addr];
always clk = #5 ~clk;   //100MHz
//always clk = #10 ~clk;    //50MHz	

assign sclk1 = (mode) ? !sclk : sclk;

	always @(negedge ss) begin
		if(!cpha) begin
			miso <= miso_data[count_t];
		  count_t = count_t+1;
    end
		else begin
			count_t  = 0;
		end
 end 

	always @(posedge sclk1, posedge ss) begin
		
		if(count_t == d_width) begin
			if(cont) begin
				//tx_data <= 8'b1;
				miso_data = 8'b0;
				count_t = 0;
			end else
      begin
        miso <= 1'bz;
      end
    end else
    if (!ss)begin
			miso <= miso_data[count_t];
			count_t = count_t + 1;
		end
	end

	always @(negedge busy) begin
		if(!ss)begin
			tx_data = 8'b1;
		end
	end

  initial begin: TEST_CASE
      $dumpfile("spi_master_TB.vcd");
      $dumpvars(0, spi_master_TB);
      #5 rst = 1'b1;
      #5 rst = 1'b0;
      #10 enable = 1'b1;
      #10 enable = 1'b0;
      #2500 cont = 1'b0;
      #100 $finish;
  end 
endmodule
				

