module analyzer (clk, INPUT_A, INPUT_B, INPUT_C, INPUT_D, INPUT_E, OUTPUT_A, OUTPUT_B, OUTPUT_C, OUTPUT_D, OUTPUT_E);
   
   input clk;
   input INPUT_A;
	input INPUT_B;
	input INPUT_C;
   input INPUT_D;
   input INPUT_E;

	output reg OUTPUT_A = 1'b0;
	output reg OUTPUT_B = 1'b0;
	output reg OUTPUT_C = 1'b0;
	output reg OUTPUT_D = 1'b0;
	output reg OUTPUT_E = 1'b0;

	always @(posedge clk) begin
   OUTPUT_A <= INPUT_A;
	OUTPUT_B <= INPUT_B;
	OUTPUT_C <= INPUT_C;
   OUTPUT_D <= INPUT_D;
   OUTPUT_E <= INPUT_E;

   end


endmodule
