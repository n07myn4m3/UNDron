`timescale 10ns / 10ps
`define SIMULATION

module i2c_master_TB;
    reg           clk, reset, ena, rw;
    reg [6:0]     addr;
    reg [7:0]     data_wr;
    wire          busy, ack_error;
    wire [7:0]    data_rd;
    wire          sda, scl;
    reg           sda_out = 1'bz;
    reg  [4:0]    count_aux = 9;
    reg  [7:0]    vamo_a_leer = 8'h55;
    reg           direc = 1'b0;

    i2c_master inst1(clk, reset, ena, addr, rw, data_wr, busy, data_rd, ack_error, sda, scl);

    assign sda = sda_out;

    initial
        begin
            clk = 1'b0;
            reset = 1'b0;
            ena = 1'b0;
            rw = 1'b0;
            addr = 7'h58;
            data_wr = 8'hbf;
    end
    
    always #1 clk = ~clk; 


    
    always @(negedge scl) begin
       #251
       count_aux = count_aux-1;
        if (rw || !direc) begin 
             if (count_aux == 0) begin
                sda_out = 1'b0;
                data_wr = $random; 
                count_aux = 9;
                direc = 1'b1;
             end else begin
                sda_out = 1'bz;
             end
        end else begin
             if (count_aux == 0) begin
               sda_out = 1'bz;
               count_aux = 9;
               vamo_a_leer = data_wr;
             end else begin
               sda_out = vamo_a_leer[count_aux-1] ? 1'b1:1'b0;
            end
        end 
    end
      


   initial begin
     $dumpfile("i2c_master_TB.vcd");
     $dumpvars(-1, inst1);
      #10 
        reset = 1'b1;
      #10  
        reset = 1'b0;
      #1000 
        ena = 1'b1;
     #60000
     $finish;
   end

endmodule
