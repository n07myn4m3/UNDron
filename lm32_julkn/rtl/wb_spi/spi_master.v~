///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//FileName: spi_master.v
//code: verilog.
//Developed: Scott Larson.
//translator: engineer training Julk N.
//Data: 8/july/2016.
//Note: Module for manage a spi_master module, Translated from VHDL code of Scott Larson Larson, see web page https://eewiki.net/pages/viewpage.action?pageId=4096079.
//More Info: https://eewiki.net/pages/viewpage.action?pageId=4096079  or in this folder
//Special Thanks: Scott Larson and Nicolas Ospina.
//University: National University of Colombia.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module spi_master #
(parameter slaves  = 1,
 parameter d_width = 8)
(clk, rst, enable, cpol, cpha, cont, clk_div, addr, tx_data, miso, sclk, ss_n, mosi, busy, rx_data);


/*
                   ______________
 clk      ------->|              |-------> busy            |
 rst      ------->|              |-------> sclk            |
 cpol     ------->|              |-------> ss_n            |
 cpha     ------->|              |												 |CONTROL SIGNALS 
 cont     ------->|              |												 |
 enable   ------->|  spi_master  |												 |
                  |              |
 clk_div  ------->|              |
 addr     ------->|              |
 miso     ------->|              |-------> mosi            |DATA SIGNALS
 tx_data     ---->|______________|-------> rx_data         |

*/

//  parameter slaves = 1; //number of spi_slave
//  parameter d_width = 8; //data bus data width

  input clk, rst, enable, cpol, cpha, cont, miso;
  input [d_width-1:0] tx_data;
  input [31:0] clk_div;
  input [31:0] addr;
  output reg mosi,busy;
  output reg sclk = 1'b0;
  output reg [slaves-1:0] ss_n;
  output reg [d_width-1:0] rx_data;
  
  parameter ready   =2'b01;           //|
  parameter execute =2'b10;           //State machine data type
	parameter delay   =2'b11;

  reg [1:0] state;                    //Current State
  reg [31:0] slave = 31'b0;                   //slave selected for current transaction
  reg [31:0] clk_ratio = 31'b0;               //current clk_div
  reg [31:0] count = 31'b0;                   //counter to trigger sclk from system clock
	reg [31:0] cont_del = 0;
  reg [d_width*2+1:0] clk_toggles = 0;    //count spi clock toggles
  reg assert_data;                    //1'b1 is tx sclk toggle, 1'b0 is rx sclk toggle
  reg continue = 1'b0;                       //flag to continue transaction
  reg [d_width-1:0] rx_buffer = 0;         //receive data buffer
  reg [d_width-1:0] tx_buffer = 0;        //transmit data buffer
  reg [d_width*2:0] last_bit_rx = 0;      //last rx data bit location

  always @(posedge clk, posedge rst) begin
  if (rst) begin
    busy <=1'b1;
    ss_n <= {(slaves){1'b1}};
    mosi <= 1'b1;
    rx_data <=0;
    state <= ready;
  end
  else begin  
    case(state)
      ready: begin
        busy <= 1'b0;
        ss_n <= {(slaves){1'b1}};
        mosi <= 1'b1;
        continue <= 1'b0;
				//user input to initiate transaction
        if (enable) begin
          busy <= 1'b1;
          if (addr < slaves) begin
            slave <= addr;
          end else begin
            slave <= 0;
          end
					if (clk_div == 1'b0) begin
						clk_ratio <= 1;
						count <= 1;
					end else begin
					  clk_ratio <= clk_div;
					  count <= clk_div;
				  end
          sclk <= cpol;
          assert_data <= !cpha;
          tx_buffer <= tx_data;
					clk_toggles <= 0;
					last_bit_rx <= d_width*2 + cpha - 1;
					state <= execute;
        end 
        else begin
          state <= ready;
        end
      end

      execute: begin
		    ss_n [slave] <= 1'b0;	
				busy <= 1'b1;
		    if (count == clk_ratio) begin
					count <= 1;
					assert_data <= !assert_data;
					if (clk_toggles == d_width*2+1) 
		      	clk_toggles <= 0;
		      else
		 				clk_toggles <= clk_toggles+1; //{{(d_width*2){1'b0}},1'b1}
				
					if ((clk_toggles <= d_width*2) && (ss_n[slave]==1'b0)) begin
						sclk <= !sclk;
					end

					if ((assert_data == 1'b0) && (clk_toggles < last_bit_rx+1) && (ss_n[slave]==1'b0)) begin
						rx_buffer <= {rx_buffer[d_width-2:0], miso};
		      end

					if ((assert_data == 1'b1) && (clk_toggles< last_bit_rx)) begin
						mosi <= tx_buffer[d_width-1];
						tx_buffer <= {tx_buffer[d_width-2:0],1'b0};
		      end
		     
					if ((clk_toggles == last_bit_rx) && (cont == 1'b1)) begin
						tx_buffer <= tx_data;
		        clk_toggles <= last_bit_rx - d_width*2+1;
						continue <= 1'b1; 	
						state <= delay; 
		      end

					if(continue) begin
						continue <= 1'b0;
						busy <= 1'b0;
						rx_data <= rx_buffer;
						state <= delay; 
		      end

					if((clk_toggles == d_width*2+1) && (cont == 1'b0)) begin
						busy <=1'b0;
						ss_n <= {(slaves){1'b1}};
						mosi <= 1'b1;
						rx_data <= rx_buffer;
						state <= ready;
		      end
					else begin
		  			state <= execute;
					end
				end
				else begin
					count <= count+1; //{{(30){1'b0}},1'b1}
					state <= execute;
		    end
		  end
	
			delay: begin
				if(cont_del==clk_ratio*last_bit_rx)begin
					state <= execute;
				end else
					cont_del <= cont_del+1; 
					state<=delay;
			end			
		endcase
	end
end 
endmodule
