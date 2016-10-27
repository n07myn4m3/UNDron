`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:41:34 12/05/2015 
// Design Name: 
// Module Name:    ADC_READER 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ADC_READER(ADC_VALUE_PORT, DONE_RD, ADC_READ_PORT, enable, clk);

    output reg [12:0] ADC_VALUE_PORT; //recibe un valor de 8 bits multiplicado por 20 lo que dara un total de 13 bits
    output reg        DONE_RD;
    input             ADC_READ_PORT;
    input             enable;   
    input             clk; 

           reg [2:0] counter;
           reg [7:0] registro;
           reg       activador;

    initial begin
      ADC_VALUE_PORT  = 13'd0;
      DONE_RD         = 0;
      counter         = 3'b000;
      registro       <= 8'b00000000;
      activador       = 1;
    end  
    
     
always @(posedge clk) 

    if (enable==0) 

        begin
        counter         =  3'b000;
        registro       <= 8'b00000000;
        ADC_VALUE_PORT  =  13'd0;
        DONE_RD         =  0;
        activador       =  1;
        end

    else if (enable==1) 

        begin
  
             if(activador==1)
              begin
                 
                  registro<=(registro+ADC_READ_PORT)<<1;
                  ADC_VALUE_PORT=registro;

                 if(counter==3'b111) 
                   begin
                    registro<=registro+ADC_READ_PORT;
                    ADC_VALUE_PORT=registro;
                    activador=0;
                   end

                 counter = counter+1'b1;      
              end

             else if(activador==0)
              begin
                  DONE_RD        = 1;
                  ADC_VALUE_PORT = registro*20;  
              end    
        end

endmodule 
