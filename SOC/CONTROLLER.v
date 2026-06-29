`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:40:57 11/25/2025 
// Design Name: 
// Module Name:    CONTROLLER 
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
module CONTROLLER(
		input [2:0] funct3,
		input [6:0] funct7,
		input [6:0] opcode,
		input [3:0] instr_type,
		//
		output reg REG_RW, //0-read 1-write
		output reg [1:0] REG_SRC=0, //0-mem 1-alu 2-pc+4
		output reg ALU_A_SRC=0,//0-a 1-pc
		output reg ALU_B_SRC=0,//0-b 1-imm
		output reg [4:0] ALU_OP=0,
		output reg [1:0] MEM_RW=0, //0-nothing 1-read 2-write
		output reg [2:0] MEM_M=0,//[sign extend|mask[1:0]]
		output reg MEM_OP=0,// read or write op must be executed
		output reg PC_A_SEL=0, // 0-adder 1-alu	
		output reg PC_INC_SEL=0 // 0-4 1- brancher
	);
	
	localparam [0:0] 
		MATH=1'b0, //normal math ops
		COMP=1'b1; //compare 
	
	localparam [3:0] E=0, R=1, I=2, S=3, B=4, U=5, J=6, SH=7; 

	//alu:{invert B or arithmetical shift,math/comparison,funct3}
 
	always@(*)begin
		case(instr_type)
			// r1 x r2 => rd
			R: begin
				REG_RW = 1;//write
				ALU_B_SRC = 0;//r2
				ALU_A_SRC = 0;//r1
				MEM_RW = 0;//ignore
				REG_SRC = 1;//alu
				ALU_OP = {funct7[5],MATH,funct3};//pass func3
				PC_A_SEL =0;//+4
				PC_INC_SEL=0;
				MEM_M=0;
				MEM_OP=0;
			end
			I: begin
				//JALR
				if(opcode==7'b1100111) begin
					REG_RW = 1;//write
					ALU_B_SRC = 1;//imm
					ALU_A_SRC = 0;//r1
					MEM_RW = 0;//ignore
					REG_SRC = 2;//pc+4
					ALU_OP = {1'b0,MATH,3'b000};//+
					PC_A_SEL =1;//alu
					PC_INC_SEL=0;
					MEM_M=0;
					MEM_OP=0;
				end else
				// r1 x imm => rd
				if(opcode[4]==1'b1)begin
					REG_RW = 1;//write
					ALU_B_SRC = 1;//imm
					ALU_A_SRC = 0;//r1
					MEM_RW = 0;//ignore
					REG_SRC = 1;//alu
					ALU_OP = {funct7[5],MATH,funct3};//pass func3
					PC_A_SEL =0;//+4
					PC_INC_SEL=0;
					MEM_M=0;
					MEM_OP=0;
				// load[r1+imm] => rd
				end else begin
					REG_RW = 1;//write
					ALU_B_SRC = 1;//imm
					ALU_A_SRC = 0;//r1
					MEM_RW = 1;//read
					REG_SRC = 0;//mem
					ALU_OP = {1'b0,MATH,3'b000};//+
					PC_A_SEL =0;//+4
					PC_INC_SEL=0;
					MEM_M={!funct3[2],funct3[1:0]};
					MEM_OP=1;
				end
			end
			//store r2 => r1+imm
			S: begin
				REG_RW = 0;//read
				ALU_B_SRC = 1;//imm
				ALU_A_SRC = 0;//r1
				MEM_RW = 2;//write
				REG_SRC = 0;//mem
				ALU_OP = {1'b0,MATH,3'b000};//+
				PC_A_SEL =0;//+4
				PC_INC_SEL=0;
				MEM_M={!funct3[2],funct3[1:0]};
				MEM_OP=1;
			end
			// compare 
			B: begin
				REG_RW = 0;//read
				ALU_B_SRC = 0;//r2
				ALU_A_SRC = 0;//r1
				MEM_RW = 0;//ignore
				REG_SRC = 1;//alu
				ALU_OP = {1'b0,COMP,funct3};//compare
				PC_A_SEL =0;//+ imm
				PC_INC_SEL=1;//imm
				MEM_M=0;
				MEM_OP=0;
			end
			U: begin
				//LUI
				if(opcode[5]==1)begin
					REG_RW = 1;//write
					ALU_B_SRC = 1;//imm
					ALU_A_SRC = 0;//r1
					MEM_RW = 0;//ignore
					REG_SRC = 1;//alu
					ALU_OP = {5'b11111};//pass B
					PC_A_SEL =0;//+4
					PC_INC_SEL=0;
					MEM_M=0;
					MEM_OP=0;
				//AUIPC
				end else begin
					REG_RW = 1;//write
					ALU_B_SRC = 1;//imm
					ALU_A_SRC = 1;//pc
					MEM_RW = 0;//ignore
					REG_SRC = 1;//alu
					ALU_OP = {1'b0,MATH,3'b000};//+
					PC_A_SEL =0;//+4
					PC_INC_SEL=0;
					MEM_M=0;
					MEM_OP=0;
				end
				
			end
			//JAL
			J: begin
				REG_RW = 1;//write
				ALU_B_SRC = 1;//imm
				ALU_A_SRC = 1;//pc
				MEM_RW = 0;//ignore
				REG_SRC = 2;//pc+4
				ALU_OP = {1'b1,1'b1,3'b000};//+ -4
				PC_A_SEL =1;//alu
				PC_INC_SEL=0;
				MEM_M=0;
				MEM_OP=0;
			end
			//SH- instructions with shamt
			// r1 x imm => rd
			SH: begin
				REG_RW = 1;//write
				ALU_B_SRC = 1;//imm
				ALU_A_SRC = 0;//r1
				MEM_RW = 0;//ignore
				REG_SRC = 1;//alu
				ALU_OP = {funct7[5],MATH,funct3};//pass func3
				PC_A_SEL =0;//+4
				PC_INC_SEL=0;
				MEM_M=0;
				MEM_OP=0;
			end
			E: begin
				//nop
				REG_RW = 0;//read
				ALU_B_SRC = 0;//r2
				ALU_A_SRC = 0;//r1
				MEM_RW = 0;//ignore
				REG_SRC = 1;//alu
				ALU_OP = {1'b0,MATH,3'b000};//+
				PC_A_SEL =0;//+4
				PC_INC_SEL=0;
				MEM_M=0;
				MEM_OP=0;
			end
			default: begin
				//nop
				REG_RW = 0;//read
				ALU_B_SRC = 0;//r2
				ALU_A_SRC = 0;//r1
				MEM_RW = 0;//ignore
				REG_SRC = 1;//alu
				ALU_OP = {1'b0,MATH,3'b000};//+
				PC_A_SEL =0;//+4
				PC_INC_SEL=0;
				MEM_M=0;
				MEM_OP=0;
			end
		endcase
	end


endmodule
