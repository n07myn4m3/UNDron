/*
                      ____________
                     |            |
 (rst)      -------->|            |
 (ena)      -------->|    ADC     | (cs)  -------->
 (clk)      -------->|   m—dule   | (chl) -------->
                     |            | 
 (data_chl) -------->|            | (data) -------->
                     |____________|

 cs: 0 para (x-y) y 1 para (z)
 chl: 0 channel0 (x-z) 1 para channel1 (y)


*/

module adc (rst,ena,di,data_chl,done,cs0,cs1,ch_sel,data);
	input rst;
        input ena;
        input di;
        input [12:0] data_chl;
        output reg       done;
        output reg       cs0;
        output reg       cs1;
        output reg [2:0] ch_sel;
        output reg [12:0] data;
  
reg write;
reg [3:0] dicicle;
reg [2:0] readcicle;
reg [7:0] temporalData;

initial begin
  done           = 0;
  cs0            = 1;
  cs1            = 1;
  ch_sel         = 0;
  data          <= 12'd0;
  write          = 1;
  dicicle       <= 4'd0;
  readcicle     <= 3'd0;
  temporalData  <= 8'd0;
end

parameter INIT = 4'b1111,
            SEL1_CH0 = 4'b0000, SEL1_CH1 = 4'b0100, SEL1_CH2 = 4'b1000,
            SEL2_CH0 = 4'b0001, SEL2_CH1 = 4'b0101, SEL2_CH2 = 4'b1001,
            SEL3_CH0 = 4'b0010, SEL3_CH1 = 4'b0110, SEL3_CH2 = 4'b1010;

always @ (posedge clk) begin
  if (rst) begin
    write = 1;
    dicicle = di;
    dicicle << 2;
  end
  else if (write) begin
    case(dicicle)
      INIT: begin
        cs0    <= 1;
        cs1    <= 1;
        ch_sel <= 0;
      end
      SEL1_CH0: begin
        cs0    <= 0;
        cs1    <= 1;
        ch_sel <= 1;
        dicicle + 1;
      end
      SEL1_CH1: begin
        cs0    <= 0;
        cs1    <= 1;
        ch_sel <= 1;
        dicicle + 1;
      end
      SEL1_CH2: begin
        cs0    <= 1;
        cs1    <= 0;
        ch_sel <= 1;
        dicicle + 1;
      end
      SEL2_CH0: begin
        ch_sel <= 1;
        dicicle + 1;
      end
      SEL2_CH1: begin
        ch_sel <= 1;
        dicicle + 1;
      end
      SEL2_CH2: begin
        ch_sel <= 1;
        dicicle + 1;
      end
      SEL3_CH0: begin
        ch_sel <= 0;
        write = 0;
      end
      SEL3_CH1: begin
        ch_sel <= 1;
        write = 0;
      end
      SEL3_CH2: begin
        ch_sel <= 0;
        write = 0;
      end
      default: begin
        cs0    <= 1;
        cs1    <= 1;
        ch_sel <= 0;
      end
   endcase
  end
  else begin
    //wait
  end
end

always @ (negedge clk) begin
  if (rst) begin
    temporalData = 8'd0;
  end
  else if (write) begin
    //wait
  end
  else begin
    if (done == 0) begin
        if (readcicle<3'b111) begin
            temporalData <= (temporalData + data_chl)<<1;
        end
        else begin
            temporalData <= temporalData + data_chl;
            done = 1;
        end
    end
    else begin
    assign data = temporalData;
    end
  end // end else
end // end always


endmodule
