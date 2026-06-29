`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:35:28 12/17/2025
// Design Name:   MD_ALU
// Module Name:   /home/vm/Documents/lu/DIP/PROJ_OSC/CPU_ALU_TEST.v
// Project Name:  PROJ_OSC
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MD_ALU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module CPU_ALU_TEST;

	// Inputs
	reg [31:0] A;
	reg [31:0] B;
	reg [4:0] OP;

	// Outputs
	wire [31:0] Q;

	// Instantiate the Unit Under Test (UUT)
	MD_ALU uut (
		.A(A), 
		.B(B), 
		.OP(OP), 
		.Q(Q)
	);

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;
		OP = 0;
		
		A=32'h80000000;
		B=32'h00000001;
		OP=5'b00101;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

