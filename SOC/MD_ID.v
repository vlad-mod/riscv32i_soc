`timescale 1ns / 1ps
/*
based on opcode tell what instruction type that is

    these bits are the same, they can be ignored
         \/
R - 0010011
R - 0110011

I - 0010011
I - 0000011
I - 1100111

S - 0100011

B - 1100011

U - 0110111
U - 0010111

J - 1101111

SH - 0010011 // pseudo type where imm is used as shamt

----

some opcodes are the same for different instruction types, those types can be distinguished by looking at funct3 

R - 01100

I - 00100 funct3[1:0]!=2'b01
I - 00000
I - 11001 

S - 01000

B - 11000

U - 01101
U - 00101

J - 11011

SH - 00100 funct3[1:0]=2'b01
    
*/
module MD_ID(
		input [31:0] iw,
		output reg [4:0] rs1=0,
		output reg [4:0] rs2=0,
		output reg [4:0] rd=0,
		output reg [31:0] imm=0,
		output reg [2:0] funct3=0,
		output reg [6:0] funct7=0,
		output reg [3:0]instr_type=0,
		output [6:0] opcode
	);
	
	//E is unrecognised instruction
	localparam [3:0] E=0, R=1, I=2, S=3, B=4, U=5, J=6, SH=7; 
	//reg [3:0] instr_type=0;
	
	//separation into instruction parts
	wire[6:0] opcode_i = iw[6:0];
	wire[4:0] rd_i = iw[11:7];
	wire[2:0] funct3_i = iw[14:12];
	wire[4:0] rs1_i = iw[19:15];
	wire[4:0] rs2_i = iw[24:20];
	wire[6:0] funct7_i = iw[31:25];
	
	assign opcode = opcode_i;
	
	// decode instruction type
	always @(*) begin
		case({iw[6:2]})
			// SH/I
			5'b00100:begin
				if(funct3_i[1:0]==2'b01)begin
				// SH
					instr_type=SH;
				end else begin
				// I
					instr_type=I;
				end
			end
			// R
			5'b01100: instr_type=R;
			// I
			5'b00000: instr_type=I;
			5'b11001: instr_type=I;
			// S
			5'b01000: instr_type=S;
			// B
			5'b11000: instr_type=B;
			// U
			5'b01101: instr_type=U;
			5'b00101: instr_type=U;
			// J
			5'b11011: instr_type=J;
			
			// instruction can not be decoded
			default: instr_type=E;
		endcase
	end
	
	// using instruction type assign required registers
	always @(*) begin
		case(instr_type)
		R: begin
			rs1=rs1_i;
			rs2=rs2_i;
			rd=rd_i;
			funct3=funct3_i;
			funct7=funct7_i;
			imm=0;
		end
		I: begin
			rs1=rs1_i;
			rs2=0;
			rd=rd_i;
			funct3=funct3_i;
			funct7=0;
			imm={{20{iw[31]}},iw[31:20]};
		end
		SH: begin
			rs1=rs1_i;
			rs2=0;
			rd=rd_i;
			funct3=funct3_i;
			funct7=funct7_i;
			imm={27'b0,iw[24:20]};
		end
		S: begin
			rs1=rs1_i;
			rs2=rs2_i;
			rd=0;
			funct3=funct3_i;
			funct7=0;
			imm={{20{iw[31]}},iw[31:25],iw[11:7]};
		end
		B: begin
			rs1=rs1_i;
			rs2=rs2_i;
			rd=0;
			funct3=funct3_i;
			funct7=0;
			imm={{19{iw[31]}}, iw[31], iw[7], iw[30:25], iw[11:8], 1'b0};
		end
		U: begin
			rs1=0;
			rs2=0;
			rd=rd_i;
			funct3=0;
			funct7=0;
			imm={iw[31:12],12'b0};
		end
		J: begin
			rs1=0;
			rs2=0;
			rd=rd_i;
			funct3=0;
			funct7=0;
			imm={{11{iw[31]}},iw[31],iw[19:12],iw[20],iw[30:21],1'b0};
		end
		E: begin
			// invalid instruction, set all outputs to 
			rs1=0;
			rs2=0;
			rd=0;
			funct3=0;
			funct7=0;
			imm=0;
		end
		default: begin
			rs1=0;
			rs2=0;
			rd=0;
			funct3=0;
			funct7=0;
			imm=0;
		end
		endcase
	end
	
	
	
endmodule
