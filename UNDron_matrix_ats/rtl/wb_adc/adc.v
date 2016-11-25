/*
                      ____________
                     |            |
 (rst)      -------->|            |
 (ena)      -------->|    ADC     | (cs)  -------->
 (clk)      -------->|   module   | (chl) -------->
                     |            | 
 (data_chl) -------->|            | (data) -------->
                     |____________|

 cs: 0 para (x-y) y 1 para (z)
 chl: 0 channel0 (x-z) 1 para channel1 (y)
 di: chip select canal uno o dos

*/

module adc (rst,ena,clk,di,data_chl,done,cs0,cs1,ch_sel,data);
	input rst;
        input ena;
input clk;
        input [1:0] di;
        input data_chl;
        output reg       done;
        output reg       cs0;
        output reg       cs1;
        output reg ch_sel;
        output reg [7:0] data;
  
reg write;
reg [2:0] readcicle;
reg [3:0] state;

initial begin
  done           = 0;
  cs0            = 1;
  cs1            = 1;
  ch_sel         = 0;
  data          <= 8'd0;
  write         <= 1;
  state       	<= 4'b1111;
  readcicle     <= 3'd0;
end

parameter INIT = 4'b1111,
            SEL1_CH0 = 4'b0000, SEL1_CH1 = 4'b0100, SEL1_CH2 = 4'b1000,
            SEL2_CH0 = 4'b0001, SEL2_CH1 = 4'b0101, SEL2_CH2 = 4'b1001,
            SEL3_CH0 = 4'b0010, SEL3_CH1 = 4'b0110, SEL3_CH2 = 4'b1010, END = 4'b1110;



always @ (posedge clk) begin
  if (rst) begin
    write <= 1;
    state <= INIT;
  end
  else if (write==1 && done==0) begin// && done==0
    case(state)
      INIT: begin
        cs0    <= 1;
        cs1    <= 1;
        ch_sel <= 0;
    		state <= (di) << 2;
      end
      SEL1_CH0: begin
        cs0    <= 0;
        cs1    <= 1;
        ch_sel <= 1;
        state <= SEL2_CH0;
      end
      SEL1_CH1: begin
        cs0    <= 0;
        cs1    <= 1;
        ch_sel <= 1;
        state <= SEL2_CH1;
      end
      SEL1_CH2: begin
        cs0    <= 1;
        cs1    <= 0;
        ch_sel <= 1;
        state <= SEL2_CH2;
      end
      SEL2_CH0: begin
        ch_sel <= 1;
        state <= SEL3_CH0;
      end
      SEL2_CH1: begin
        ch_sel <= 1;
        state <= SEL3_CH1;
      end
      SEL2_CH2: begin
        ch_sel <= 1;
        state <= SEL3_CH2;
      end
      SEL3_CH0: begin
        ch_sel <= 0;
        state <= 4'b1110;
      end
      SEL3_CH1: begin
        ch_sel <= 1;
        state <=  4'b1110;
      end
      SEL3_CH2: begin
        ch_sel <= 0;
        state <=  4'b1110;
      end
      END: begin
        ch_sel <= 0;
  			write  <= 0;
    		state <= INIT;
      end
      default: begin
        cs0    <= 1;
        cs1    <= 1;
      end
   endcase	
  end
	else begin
		ch_sel <= 0;
	end
end
/*
w d
0 0 = read
0 1 = assign
1 0 = nothing
1 1 = done 0
*/

always @ (negedge clk) begin
  if (rst) begin
    data <= 8'd0;
  end
  else if (write==1 && done==1) begin
    done <= 0;
    data <= 8'd0;
		readcicle = 3'd0;
  end
	else if (write==0 && done==0)  begin
      if (readcicle<3'b111) begin
          data <= (data + data_chl)<<1;
					readcicle = readcicle + 1;
      end
      else begin
          data <= data + data_chl;
          done <= 1;
      end
  end
  else begin
		write <= 1;
  end
end // end always
endmodule
