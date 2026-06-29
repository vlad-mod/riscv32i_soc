`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:05:39 11/27/2025 
// Design Name: 
// Module Name:    REG_CLK 
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
module REG_CLK(
		input [31:0] in,
		input clk,
		output reg [31:0] out=0
    );
	
	
	always @(posedge clk) begin
		out<=in;
	end

endmodule
