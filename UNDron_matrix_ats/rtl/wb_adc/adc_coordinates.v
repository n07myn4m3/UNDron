/*
                   ____________
                  |            |
 (ena)   -------->|    ADC     | (coordinates) --------> 
                  |    xyz     | (do)          --------> 
 (reset) -------->|            | (rst)         -------->
                  |____________|

 cs: 0 para (x-y) y 1 para (z)
 chl: 0 channel0 (x-z) 1 para channel1 (y)


*/
module adc_coordinates (reset,rst,ena,do,coordinates);
	input reset;
        input ena;
        output reg       rst;
        output reg [1:0] do;
        output reg [12:0] coordinates;
        wire x;
        wire y;
        wire z;
    
        do = 00;
        adc acdx (rst(reset),ena,di(do),data_chl,done,cs0,cs1,ch_sel,data(x));
        do = 01;
        adc acdy (rst(reset),ena,di(do),data_chl,done,cs0,cs1,ch_sel,data(y));
        do = 10;
        adc acdz (rst(reset),ena,di(do),data_chl,done,cs0,cs1,ch_sel,data(z));
    
endmodule
