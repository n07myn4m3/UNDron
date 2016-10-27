module MCP0832_TB;
/*
------------------------------------
MODULO A PROBAR
------------------------------------

module MCP0832(ADC_COMMAND_DATA_PORT, SEL_PIN_PORT, ADC_VALUE_PORT, DONE_RD, CHANNEL_SELECT, ADC_READ_PORT, enable, clk);
 
SALIDAS  son wires

  output       ADC_COMMAND_DATA_PORT;
  output reg   SEL_PIN_PORT;
  output [12:0] ADC_VALUE_PORT;
  output       DONE_RD;

ENTRADAS son registros

  input        CHANNEL_SELECT;
  input        ADC_READ_PORT;
  input        enable;   
  input        clk; 

*/

// SALIDAS  

  wire ADC_COMMAND_DATA_PORT;
  wire SEL_PIN_PORT;
  wire [12:0] ADC_VALUE_PORT;
  wire DONE_RD;

// ENTRADAS 

  reg CHANNEL_SELECT = 0;
  reg ADC_READ_PORT  = 0;
  reg enable         = 0;   
  reg clk            = 0;
  always #5 clk = !clk; 

  initial begin
     $dumpfile("test.vcd");
     $dumpvars(0,MCP0832_TB);

     # 50 enable = 1;
          CHANNEL_SELECT = 0;   
       #0  ADC_READ_PORT = 0;//ruido
       #10 ADC_READ_PORT = 0;//ruido  
       #10 ADC_READ_PORT = 0;//ruido
       #10 ADC_READ_PORT = 0;//ruido
       #10 ADC_READ_PORT = 0;//catch para verificar 10101010*10100
       #10 ADC_READ_PORT = 0;//catch
       #10 ADC_READ_PORT = 0;//catch 
       #10 ADC_READ_PORT = 0;//catch 
       #10 ADC_READ_PORT = 0;//catch
       #10 ADC_READ_PORT = 0;//catch
       #10 ADC_READ_PORT = 0;//catch
       #10 ADC_READ_PORT = 1;//catch
       #10 ADC_READ_PORT = 0;//ruido 
       #10 ADC_READ_PORT = 0;//ruido
       #10 ADC_READ_PORT = 0;//ruido  
       #10 ADC_READ_PORT = 0;//ruido
       #10 ADC_READ_PORT = 0;//ruido
       #10 ADC_READ_PORT = 0;//ruido
     # 200 enable = 0;
     # 100 enable = 1;
          CHANNEL_SELECT = 1;
       #0  ADC_READ_PORT = 0;//ruido
       #10 ADC_READ_PORT = 0;//ruido  
       #10 ADC_READ_PORT = 0;//ruido
       #10 ADC_READ_PORT = 0;//ruido
       #10 ADC_READ_PORT = 0;//catch para verificar 10101010*10100
       #10 ADC_READ_PORT = 0;//catch
       #10 ADC_READ_PORT = 1;//catch 
       #10 ADC_READ_PORT = 0;//catch 
       #10 ADC_READ_PORT = 1;//catch
       #10 ADC_READ_PORT = 0;//catch
       #10 ADC_READ_PORT = 1;//catch
       #10 ADC_READ_PORT = 1;//catch
       #10 ADC_READ_PORT = 0;//ruido 
       #10 ADC_READ_PORT = 0;//ruido
       #10 ADC_READ_PORT = 0;//ruido  
       #10 ADC_READ_PORT = 0;//ruido
       #10 ADC_READ_PORT = 0;//ruido
       #10 ADC_READ_PORT = 0;//ruido
     # 400 $finish;
  end

 

//---------------------------------------------------------------------------------------------------  
  MCP0832 MCP0832f (.ADC_COMMAND_DATA_PORT(ADC_COMMAND_DATA_PORT), .SEL_PIN_PORT(SEL_PIN_PORT), .ADC_VALUE_PORT(ADC_VALUE_PORT), .DONE_RD(DONE_RD), .CHANNEL_SELECT(CHANNEL_SELECT), .ADC_READ_PORT(ADC_READ_PORT), .enable(enable), .clk(clk));
//--------------------------------------------------------------------------------------------------- 

  initial
     $monitor("At time = %t, COMANDO_ADC = %b,CS = %b, SALIDA = %b, DONE = %b, CANAL = %b, DATA_IN = %b,ENABLE = %b, CLK = %b",
              $time, ADC_COMMAND_DATA_PORT, SEL_PIN_PORT, ADC_VALUE_PORT, DONE_RD, CHANNEL_SELECT, ADC_READ_PORT, enable, clk);
endmodule // test
