`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:43:51 12/18/2025 
// Design Name: 
// Module Name:    SEG_DISP 
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
module SEG_DISP(
		input CLK,
		input [31:0] DAT,
		output reg [6:0] SEG,
		output [5:0] AN,
		output dp
   );
	assign dp=0;
	assign AN=CNTR;
	reg [5:0] CNTR=1;
	wire [31:0] digit;
	reg [31:0] offset=0;
	always@(posedge CLK)begin
		if(CNTR==6'b100000)begin
			CNTR<=1;
			offset<=0;
		end else begin
			CNTR<={CNTR,1'b0};
			offset<=offset+4;
		end
		
	end
	wire [31:0]d;
	assign d = DAT>>offset;
	assign digit =d[3:0];
	always@(*)begin
		case(digit)
			0:  SEG = 7'b0111111;
			1:  SEG = 7'b0000110;
			2:  SEG = 7'b1011011;
			3:  SEG = 7'b1001111;
			4:  SEG = 7'b1100110;
			5:  SEG = 7'b1101101;
			6:  SEG = 7'b1111101;
			7:  SEG = 7'b0000111;
			8:  SEG = 7'b1111111;
			9:  SEG = 7'b1101111;
			10:  SEG = 7'b1110111;
			11:  SEG = 7'b1111100;
			12:  SEG = 7'b0111001;
			13:  SEG = 7'b1011110;
			14:  SEG = 7'b1111001;
			15:  SEG = 7'b1110001;	
	endcase
	end


endmodule
