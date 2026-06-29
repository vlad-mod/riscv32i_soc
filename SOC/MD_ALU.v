`timescale 1ns / 1ps
module MD_ALU(
		input [31:0] A,
		input [31:0] B,
		input  [4:0] OP,
		output [31:0] Q
		);
		//alu:{invert B or arithmetical shift,math/comparison,funct3}
		/*
math	

ADD		0 0 000
SUB		1 0 000
SLT		0 0 010
SLTU		0 0 011
// special instruction that adds a+b-4
ADD		1 1 000

logic
		
AND		0 0 111
OR			0 0 110
XOR		0 0 100
SLL		0 0 001
SRL		0 0 101
SRA		1 0 101


branch
EQ			0 1 000
NE			0 1 001
GE			0 1 101
GEU		0 1 111
LT			0 1 100
LTU		0 1 110

special
outB		1 1 111

		*/
		
		wire [31:0] S;
		wire [31:0] SS;
		wire [31:0] SSS;
		ALU_ADD alu_add(
			.a(A),
			.b(B),
			.s(S)
		);
		ALU_ADD alu_sub(
			.a(A),
			.b(-B),
			.s(SS)
		);

		reg [32:0] Qextended=0;
		// MSB is carry
		assign Q = Qextended[31:0];
		
		always @(*)
		begin
			case(OP)
			//math 
			5'b00000: begin
					Qextended = S;
				end
			5'b10000: begin
					Qextended = SS;
				end
			5'b00010: begin//signed
					Qextended =  $signed(A)<$signed(B)?1:0;
				end
			5'b00011: begin//unsigned
					Qextended =  A<B?1:0;
				end
			5'b11000: begin
					Qextended = S;
				end
			//logic
			5'b00111: begin
					Qextended = A&B;
				end
			5'b00110: begin
					Qextended = A|B;
				end
			5'b00100: begin
					Qextended = A^B;
				end
			5'b00001: begin
					Qextended = A<<B;
				end
			5'b00101: begin//SRL
					Qextended = A>>B;
				end
			5'b10101: begin//SRA
					Qextended = $signed(A)>>>$signed(B);
				end
			//compare
			5'b01000: begin//EQ
					Qextended = A==B;
				end
			5'b01001: begin//NE
					Qextended = A!=B;
				end
			5'b01101: begin//GE
					Qextended = $signed(A)>=$signed(B);
				end
			5'b01111: begin//GEU
					Qextended = A>=B;
				end
			5'b01100: begin//LT
					Qextended = $signed(A)<$signed(B);
				end
			5'b01110: begin//LTU
					Qextended = A<B;
				end
			// special ops
			5'b11111: begin//out b
					Qextended = B;
				end
			default: begin
					Qextended=0;
				end
			endcase
		end
endmodule
