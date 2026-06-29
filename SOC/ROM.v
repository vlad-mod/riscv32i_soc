`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:51:50 01/16/2026 
// Design Name: 
// Module Name:    ROM 
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
module ROM(
		input READY,
		input CLK,
		input CLKR,
		input      [31:0] AIN1, // 32bit aligned address
		output     [31:0] DOUT1,
		input      [31:0] AIN2, // 32bit aligned address
		output     [31:0] DOUT2
   );
	
	(* rom_style = "block" *)
	reg [31:0] ROM [0:16384];
			
	initial begin
		$readmemh("program.hex",ROM);
	end

	reg [31:0] t1;
	reg [31:0] t2;
	assign DOUT1={t1[7:0],t1[15:8],t1[23:16],t1[31:24]};
	assign DOUT2=t2;

	always @(posedge CLK) begin
		t1 <= ROM[AIN1];
	end
	always @(posedge CLKR) begin
		t2 <= ROM[AIN2];
	end
	
endmodule
