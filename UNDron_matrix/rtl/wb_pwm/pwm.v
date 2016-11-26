/*
Notas:
- 1000 produjo una salida cada un milisegundo
- 500 produce una salida cada dos milisegundos
*/
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
module pwm (
	input clk,
	input rst,
	input ena,
	input [bit_resolution-1:0] duty,
	output reg [phases-1:0]  pwm_out,
	output reg [phases-1:0]  pwm_n_out
);
	parameter sys_clk = 50000000;
	parameter pwm_freq = 50; //El valor debe ser 50 para obtener un pulso cada 20 ms
	parameter bit_resolution = 8;
	parameter phases = 1;
/*
			  _________
	clk----->|         |
	rst----->|		   |
	ena----->|   pwm   |
			 |         |----->pwm_out
	duty---->|_________|----->pwm_n_out


	reg [counters:0] count [n_phases:0];

*/
	localparam period = sys_clk/(pwm_freq);
	localparam half_dutie = period/2;
	localparam delay = period/phases;
	localparam tme = phases*w_period;
	localparam tme_half = phases*w_half_duties;
	parameter w_half_duties =`log2(half_dutie);
	parameter w_phases = `log2(phases);
	parameter w_period = `log2(period);
	parameter counters = phases*w_period;
//	reg [w_period-1:0] counter = 0;
	reg [w_period+bit_resolution-1:0] half_duties = 0;
	reg [w_period+bit_resolution-1:0] value;
	reg [tme_half-1:0] half_duty = 0;
	reg [phases*w_half_duties-1	:0] half_duty_new = 0;
	reg [counters:0] count;
	reg [w_phases-1:0] i;
	reg [bit_resolution-2:0] half_val={(bit_resolution-1){1'b1}};

	always @(posedge clk, posedge rst) begin

		if(rst)begin
			i=0;
			count = 0;
			pwm_out <= 1'b0;
			pwm_n_out <= 1'b0;
		end
		else begin
			if(ena) begin
        value <= duty*period;
        half_duty_new <= value>>(bit_resolution+1);
			end


			if(count[i*tme +:tme] == period - 1 - i*delay) begin
				count[i*tme +:(tme+1)] = 0;
				half_duty[i*tme +: tme] <= half_duty_new;
			end else begin
				count[i*tme +:(tme+1)] = count[i*tme +:(tme)]+1;
			end


			if(count[i*tme +:tme]==half_duty[i*tme_half +:tme_half])begin
				pwm_out[i]<=1'b0;
				pwm_n_out[i]<=1'b1;
			end
			else if (count[i*tme +: tme]==(period-half_duty[i*tme_half +:tme_half]))begin
				pwm_out[i]<=1'b1;
				pwm_n_out[i]<=1'b0;
			end
				i=i+1;
			if(i==phases)begin
				i=0;
			end	
    end
	end
/*
	always @(negedge clk) begin
		if(i==phases)begin
			i=0;
		end
	end		
*/
endmodule
					
			
			
			
  
