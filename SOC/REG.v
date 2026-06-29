`timescale 1ns / 1ps
module REG(
		input CLK,
		output [31:0] A,
		output [31:0] B,
		input [4:0] AA,
		input [4:0] AB,
		input [31:0] D,
		input [4:0] AD,
		input RW
	);
	
	reg  [31:0] REG_FILE [0:31];

	// reg file initialisation for simulation
	integer i;
	initial begin
		for (i=0;i<=31;i=i+1) begin
			REG_FILE[i] = 0;
		end
	end
	
	assign A = AA==0?0:REG_FILE[AA];
	assign B = AB==0?0:REG_FILE[AB];
	

	always@(posedge CLK) begin
		if(RW && AD!=0) begin
			REG_FILE[AD] <= D;
		end
	end

endmodule
