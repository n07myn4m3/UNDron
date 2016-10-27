`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:40:41 12/05/2015 
// Design Name: 
// Module Name:    ADC_COMMANDER 
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
module ADC_COMMANDER(COMMAND_DATA_PORT, COMMAND_READ, CHANNEL_SELECT, enable, clk );

     output reg       COMMAND_DATA_PORT;
     output reg       COMMAND_READ;
     input            CHANNEL_SELECT;  //correccion
     input            enable;   
     input            clk;

            reg [2:0] counter;
            reg       activador;


    initial begin 
       COMMAND_READ      = 0;
       COMMAND_DATA_PORT = 0;

       counter           = 3'b000;
       activador         = 0;
    end



     
always @(negedge clk)  

    if (enable==0) 

        begin
        counter           = 3'b000;
        COMMAND_DATA_PORT = 1'b0 ;
        COMMAND_READ      = 0;
        activador         = 1;
        end


    else if (enable==1) 

        begin

             if(activador==1)

             begin
                   if(counter==3'b000) 
                     begin
                       COMMAND_DATA_PORT = 1'b1;
                     end

                   if(counter==3'b001) 
                     begin
                       COMMAND_DATA_PORT = 1'b1;
                     end

                  if(counter==3'b010) 
                     begin

                        if (CHANNEL_SELECT==0)
                          begin
                           COMMAND_DATA_PORT = 1'b0;
                          end

                        else if (CHANNEL_SELECT==1)
                          begin
                           COMMAND_DATA_PORT = 1'b1;
                          end

                     end 

                  if(counter==3'b011) 
                     begin
                       COMMAND_DATA_PORT = 1'b0;
                       activador=0;
                     end    
  
                     counter = counter+1'b1;  
             end



             else if(activador==0)

             begin
                  COMMAND_DATA_PORT = 1'b0 ;
                  COMMAND_READ      = 1;

             end
             
        end

endmodule 

