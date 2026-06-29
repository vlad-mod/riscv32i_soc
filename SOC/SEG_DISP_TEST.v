`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:12:32 12/18/2025
// Design Name:   SEG_DISP
// Module Name:   /home/vm/Documents/lu/DIP/PROJ_OSC/SEG_DISP_TEST.v
// Project Name:  PROJ_OSC
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SEG_DISP
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module SEG_DISP_TEST;

	// Inputs
	reg CLK;
	reg [32:0] DAT;

	// Outputs
	wire [6:0] SEG;
	wire [5:0] AN;
	wire dp;

	// Instantiate the Unit Under Test (UUT)
	SEG_DISP uut (
		.CLK(CLK), 
		.DAT(DAT), 
		.SEG(SEG), 
		.AN(AN), 
		.dp(dp)
	);

	always #5 CLK=~CLK;
	initial begin
		// Initialize Inputs
		CLK = 0;
		DAT = 0;

		// Wait 100 ns for global reset to finish
		#100;
        DAT = 10;
		// Add stimulus here

	end
      
endmodule

