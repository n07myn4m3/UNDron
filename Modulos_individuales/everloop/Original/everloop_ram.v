/* -----------------------------------------------------
   MEMORIA RAM DE DOBLE PUERTO
   -----------------------------------------------------
	██╗   ██╗███╗   ██╗██████╗ ██████╗  ██████╗ ███╗   ██╗    
	██║   ██║████╗  ██║██╔══██╗██╔══██╗██╔═══██╗████╗  ██║    
	██║   ██║██╔██╗ ██║██║  ██║██████╔╝██║   ██║██╔██╗ ██║    
	██║   ██║██║╚██╗██║██║  ██║██╔══██╗██║   ██║██║╚██╗██║    
	╚██████╔╝██║ ╚████║██████╔╝██║  ██║╚██████╔╝██║ ╚████║    
	 ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝    
   FUNCIONAMIENTO
   * Declaracion del tamaño de la memoria
		-Profundidad:
         1 bit es desplazado deacuerdo al numero de bits del numero de 
         direcciones, por ejemplo si el bus es de 7 bits podra acceder 
         a 127 direcciones diferentes entonces 1 << 7 da como resultado
         128 si a esto se le resta uno se obtienen todas las combinaciones
         posibles.
        -Tamaño del dato:
         Si el tamaño del dato es de 7 bits podra contener 7 valores 
         cuyo rango varia entre 1 y 0, debido a que su enumeracion 
         incluye al cero entonces van desde 0 - (tamaño del dato - 1)
         o como en el ejemplo de 0 a 6. 
   CONVENCIONES      
   * --- 
   * ---
 * Copyright 2016 <Admobilize>
 * MATRIX Labs  [http://creator.matrix.one]
 * This file is part of MATRIX Creator HDL for Spartan 6
 *
 * MATRIX Creator HDL is like free software: you can redistribute 
 * it and/or modify it under the terms of the GNU General Public License 
 * as published by the Free Software Foundation, either version 3 of the 
 * License, or (at your option) any later version.

 * This program is distributed in the hope that it will be useful, but 
 * WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
 * General Public License for more details.

 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

module everloop_ram #(
  parameter mem_file_name = "none",
	parameter adr_width = 7,
	parameter dat_width = 7
) (
	// Write port a: Este es el empleado por el wishbone 
	input      clk_a,
	input      en_a,
	input      en_b,
	input      [9:0] adr_a,
	input 	   [7:0] dat_a,
	// Read port b: Este es el empleado por el everloop
	input      clk_b,
	input      [7:0] adr_b,
	output reg [7:0] dat_b,
	output reg [7:0] dat_a_out, // Al parecer no se usa, CORREGIR
	input  we_a
);

/*

     CONEXION                                        CONEXION
     WISHBONE                                        EVERLOOP
                          ________________
 clk_a          -------->|                |--------> everloop_d                         
 en_a           -------->|                |--------> en_rd                       
                         |                |                                        
 dat_a          -------->|  everloop_ram  |
 adr_a          -------->|                |
                         |                |
 we_a           -------->|________________|

*/

parameter depth = (1 << adr_width);
// actual ram cells
reg [dat_width-1:0] ram [0:depth-1];
//------------------------------------------------------------------
// read port B
//------------------------------------------------------------------
always @(posedge clk_b)
begin
  if (en_b)
    dat_b <= ram[adr_b];
end

//------------------------------------------------------------------
// write port A
//------------------------------------------------------------------
always @(posedge clk_a)
begin
  if (en_a) begin
    if (we_a) begin
      ram[adr_a] <= dat_a;
    end 
  end 
end
//------------------------------------------------------------------
// Lectura del archivo.ram por defecto
//------------------------------------------------------------------
initial 
begin
  if (mem_file_name != "none") begin
    $readmemh(mem_file_name, ram);
  end
end
//------------------------------------------------------------------
endmodule
