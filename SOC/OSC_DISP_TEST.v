`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:33:35 09/16/2025
// Design Name:   OSC_DISP
// Module Name:   /home/vm/Documents/DIP/PROJ_OSC/OSC_DISP_TEST.v
// Project Name:  PROJ_OSC
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: OSC_DISP
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module OSC_DISP_TEST;

	// Inputs
	reg CLK;
	reg RST;

	// Outputs
	wire [7:0] TFT_R;
	wire [7:0] TFT_G;
	wire [7:0] TFT_B;
	wire TFT_VDDEN;
	wire TFT_CLK;
	wire TFT_DE;
	wire TFT_DISP;
	wire TFT_BKLT;

	// Instantiate the Unit Under Test (UUT)
	OSC_DISP uut (
		.CLK(CLK), 
		.RST(RST), 
		.TFT_R(TFT_R), 
		.TFT_G(TFT_G), 
		.TFT_B(TFT_B), 
		.TFT_VDDEN(TFT_VDDEN), 
		.TFT_CLK(TFT_CLK), 
		.TFT_DE(TFT_DE), 
		.TFT_DISP(TFT_DISP), 
		.TFT_BKLT(TFT_BKLT)
	);

	initial begin
		CLK = 0;
		RST = 1;
		#100;
		RST = 0;
		#100;

		forever begin
			CLK = ~CLK;
			#110;
		end
	end
      
endmodule

