`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:39:53 12/05/2015 
// Design Name: 
// Module Name:    MCP0832 
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
module MCP0832(ADC_COMMAND_DATA_PORT, SEL_PIN_PORT, ADC_VALUE_PORT, DONE_RD, CHANNEL_SELECT, ADC_READ_PORT, enable, clk);

  output        ADC_COMMAND_DATA_PORT; // Empleado para programar el ADC fisico
  output reg    SEL_PIN_PORT;          // Este es el que inicializa al ADC fisico (como un enable).
  output [12:0] ADC_VALUE_PORT;        // Es la lectura que obtengo del modulo viene expresada en mV
  output        DONE_RD;               // Indica que la lectura ya fue realizada

  input         CHANNEL_SELECT;        //Funciona para seleccionar el canal debe ser 0 para infrarrojo y 1 para rojo
  input         ADC_READ_PORT;         //Es el puerto donde se realizan las lecturas, se recibe informacion del adc fisico
  input         enable;                //Funciona para habilitar el modulo si es 1 comienza a funcionar, si es cero se resetea el modulo
  input         clk;                   //Pulso de reloj para que el modulo funcione, debe estar conectado a este por medio de un divisor f

  wire W_GO;

//----------------------------------------------------------------------------------------------------------------------------
  ADC_COMMANDER ADC_COMMANDER0 (.COMMAND_DATA_PORT(ADC_COMMAND_DATA_PORT), .COMMAND_READ(W_GO), .CHANNEL_SELECT(CHANNEL_SELECT) , .enable(enable), .clk(clk));
//---------------------------------------------------------------------------------------------------------------------------- 
  ADC_READER ADC_READER0 (.ADC_VALUE_PORT(ADC_VALUE_PORT), .DONE_RD(DONE_RD), .ADC_READ_PORT(ADC_READ_PORT) , .enable(W_GO)  , .clk(clk));
//----------------------------------------------------------------------------------------------------------------------------  
  always @(enable)
  if(enable==1)
   begin
    SEL_PIN_PORT=0;
   end
  else
    SEL_PIN_PORT=1;

endmodule
