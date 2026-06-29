`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:45:10 09/18/2025
// Design Name:   OSC_CLK_DIV
// Module Name:   /home/vm/Documents/lu/DIP/PROJ_OSC/OSC_CLK_DIV_TEST.v
// Project Name:  PROJ_OSC
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: OSC_CLK_DIV
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module OSC_CLK_DIV_TEST;

	// Inputs
	reg clock_in;

	// Outputs
	wire clock_out;

	// Instantiate the Unit Under Test (UUT)
	OSC_CLK_DIV uut (
		.clock_in(clock_in), 
		.clock_out(clock_out)
	);

	initial begin
		// Initialize Inputs
		clock_in = 0;
		// create input clock 50MHz
      forever #5 clock_in = ~clock_in;
	end
      
endmodule

