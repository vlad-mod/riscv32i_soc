`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:43:01 09/18/2025 
// Design Name: 
// Module Name:    OSC_CLK_DIV 
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
module OSC_CLK_DIV(
		input clock_in,
		output reg clock_out
    );
	 
	reg[64:0] counter=64'd0;
	parameter DIVISOR = 64'd12;

	always @(posedge clock_in)
	begin
		counter <= counter + 64'd1;
		if(counter>=(DIVISOR-1))
			counter <= 64'd0;

		clock_out <= (counter<DIVISOR/2)?1'b1:1'b0;
	end	
endmodule
