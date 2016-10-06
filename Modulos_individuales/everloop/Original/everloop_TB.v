`timescale 1ns / 1ps

  module everloop_TB;



       // Inputs
       reg clk;
       reg rst;
       reg [7:0] data_RGB;

       // Outputs
       wire [7:0] address;
       wire everloop_d;



  everloop uut(
       .clk(clk), .rst(rst), .data_RGB(data_RGB), .address(address),
       .everloop_d(everloop_d) 
  );

  initial begin
    // Initialize Inputs
    rst = 0; clk = 0; data_RGB = 8'hAA;
  end

//------------------------------------------
//          RESET GENERATION
//------------------------------------------

event reset_trigger;
event reset_done_trigger;

initial begin 
  forever begin 
   @ (reset_trigger);
   @ (negedge clk);
   rst = 1;
   @ (negedge clk);
   rst = 0;
   -> reset_done_trigger;
  end
end


//------------------------------------------
//          CLOCK GENERATION
//------------------------------------------

    parameter TBIT   = 1;
    parameter PERIOD = 5;
    parameter real DUTY_CYCLE = 0.5;
    parameter OFFSET = 0;


    initial    // Clock process for clk
    begin
        #OFFSET;
        forever
        begin
            clk = 1'b0;
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clk = 1'b1;
            #(PERIOD*DUTY_CYCLE);
        end
    end




initial begin: TEST_CASE 
  #0 -> reset_trigger;
  @ (reset_done_trigger); 
  
  


end

   initial begin: TEST_DUMP
     $dumpfile("everloop_TB.vcd");
     $dumpvars(-1, uut);
     #((PERIOD*DUTY_CYCLE)*60000) $finish;
   end

endmodule
