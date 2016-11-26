`define log2(n)   ((n) <= (1<<0)  ? 0 : (n)  <= (1<<1)  ? 1  :\
                   (n) <= (1<<2)  ? 2 : (n)  <= (1<<3)  ? 3  :\
                   (n) <= (1<<4)  ? 4 : (n)  <= (1<<5)  ? 5  :\
                   (n) <= (1<<6)  ? 6 : (n)  <= (1<<7)  ? 7  :\
                   (n) <= (1<<8)  ? 8 : (n)  <= (1<<9)  ? 9  :\
                   (n) <= (1<<10) ? 10 : (n) <= (1<<11) ? 11 :\
                   (n) <= (1<<12) ? 12 : (n) <= (1<<13) ? 13 :\
                   (n) <= (1<<14) ? 14 : (n) <= (1<<15) ? 15 :\
                   (n) <= (1<<16) ? 16 : (n) <= (1<<17) ? 17 :\
                   (n) <= (1<<18) ? 18 : (n) <= (1<<19) ? 19 :\
                   (n) <= (1<<20) ? 20 : (n) <= (1<<21) ? 21 :\
                   (n) <= (1<<22) ? 22 : (n) <= (1<<23) ? 23 :\
                   (n) <= (1<<24) ? 24 : (n) <= (1<<25) ? 25 :\
                   (n) <= (1<<26) ? 26 : (n) <= (1<<27) ? 27 :\
                   (n) <= (1<<28) ? 28 : (n) <= (1<<29) ? 29 :\
                   (n) <= (1<<30) ? 30 : (n) <= (1<<31) ? 31 : 32)

/*
divider
Frecuence 0832 = 250kHz
Frecuence 

                    ____________
                   |            | (rst)     		-------->
 (ena)    -------->|    ADC     | (ena_out)     -------->
 (clk_in) -------->|    xyz     | (clk_out)     --------> 
 (rst)    -------->|            | (do)          --------> 
                   |____________| (coordinates) --------> 



 cs: 0 para (x-y) y 1 para (z)
 chl: 0 channel0 (x-z) 1 para channel1 (y)


        input [8:0] data_chl;
        output reg       cs0;
        output reg       cs1;
        output reg [2:0] ch_sel;


*/
module adc_coordinates (ena,clk,rst,done,coordinates,data_chl,cs0,cs1,chl_sel);
//datos módulo--------------------------------------------------------------------//
				input rst;
        input ena;
        input clk;


        input data_chl;
        output cs0;
        output cs1;
        output chl_sel;

        output reg       done;
        output reg [23:0] coordinates;


				
//--------------------------------------------------------------------------------//

//Ajuste de reloj para el módulo ADC, para que pueda comunicarse con e chip ------//
   	parameter   input_clk    = 50000000;  
    parameter   bus_clk      = 100000;
    parameter   divFactor    = input_clk/bus_clk; 
    parameter   maxCount     = divFactor/2;
    parameter   counterWidth = `log2(maxCount);
    reg clock;
		reg reset;
		reg rdelay = 0;
    reg     [counterWidth-1: 0]  Q = 0;
    
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            //adc
						reset <= 1;
						rdelay <= 0;
            //clock
						Q <= 0;
            clock <= 1'b0;
        end
        else begin
            if(Q == (maxCount-1)) begin
                Q <= 0;
                clock <= ~clock;
								if (rdelay==0) begin rdelay <= rdelay+1; end
								else begin reset <= 0; end
            end
            else begin
                Q <= Q + 1;
            end
				end
    end
//-------------------------------------------------------------------------------//

reg read;
reg enable;
wire adc_done;
wire [7:0] chl_val;
reg [1:0] xyz;


		adc acd0 (.rst(reset),.ena(enable),.clk(clock),.di(xyz),.done(adc_done),.data(chl_val),.data_chl(data_chl),.cs0(cs0),.cs1(cs1),.ch_sel(ch_sel));
		always @(posedge clock) begin
		 if(reset) begin
          coordinates[23:0] <= 8'd0;
			    done <=0;
			    xyz <=2'b00;
					enable <= 1;
      end
			else begin
				if (done != 1) begin
					if (adc_done==1 & xyz == 2'b00) begin
						coordinates[7:0] <= chl_val[7:0];
						xyz<=xyz+1;
					end
					else if (adc_done==1 & xyz == 2'b01) begin
						coordinates[15:8] <=  chl_val[7:0];
						xyz<=xyz+1;
					end
					else if (adc_done==1 & xyz == 2'b10) begin
						coordinates[23:16] <=  chl_val[7:0];
						xyz<=xyz+1;
					end
					else if(xyz == 2'b11) begin
						done <= 1;
					end
				end
			end
		end

endmodule
