`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:23:59 11/25/2025 
// Design Name: 
// Module Name:    MD_CPU 
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
module MD_CPU(
	input CLK,
	//ROM
	output [31:0] INSTR_ADDR,
	input [31:0] INSTR_DAT,
	//RAM
	output [31:0] ADDR,
	output [31:0] DOUT,
	input [31:0] DIN,
	output [1:0] WE,
	output [2:0] WM,
	input READY,
	input RST
	);
	wire CLK_INH;
	//assign CLK_INH = CLK&&READY&&~RST;
	assign CLK_INH = CLK;
	
	//pc
	wire [31:0] PC_IN;
	wire [31:0] PC_OUT;
	REG_CLK PC_R(
		.in(PC_IN),
		.out(PC_OUT),
		.clk(CLK_INH)
	);
	wire [31:0] PC4;	
	
	//assign PC4 = PC_OUT+(PC_INC_SEL?BRANCHER:4);

	
	assign INSTR_ADDR = PC_IN;
	
	//decoder out
	wire [4:0] rs1;
	wire [4:0] rs2;
	wire [4:0] rd;
	wire [31:0] imm;
	wire [2:0] funct3;
	wire [6:0] funct7;
	wire [3:0] instr_type;
	wire [6:0] opcode;
	
	MD_ID ID(
		.iw(INSTR_DAT),
		.rs1(rs1),
		.rs2(rs2),
		.rd(rd),
		.imm(imm),
		.funct3(funct3),
		.funct7(funct7),
		.instr_type(instr_type),
		.opcode(opcode)///
	);
	
	
	wire REG_RW;
	wire [1:0] REG_SRC;
	wire ALU_A_SRC;
	wire ALU_B_SRC;
	wire [4:0] ALU_OP;
	wire [1:0] MEM_RW;
	wire PC_A_SEL;
	wire PC_INC_SEL;
	
	wire [31:0] REG_D;
	wire [31:0] ALU_Q;
	
	//data memory
	assign ADDR=ALU_Q;
	assign DOUT=B;
	assign WE=MEM_RW;
	
	//brancher
	wire [31:0] BRANCHER;
	assign BRANCHER=ALU_Q[0]?imm:4;
	
	assign PC4 = PC_OUT+(PC_INC_SEL?BRANCHER:4);
	/*
	ALU_ADD pc_add(
		.a(PC_OUT),
		.b(PC_INC_SEL?BRANCHER:4),
		.s(PC4)
	);
	*/
	MUX4 REG_MUX(
		.a(DIN),
		.b(ALU_Q),
		.c(PC4),
		.d(0),
		.sel(REG_SRC),
		.out(REG_D)
	);
	
	assign PC_IN = PC_A_SEL?ALU_Q:PC4;

	
	wire [31:0] A;
	wire [31:0] B;
	
	REG REG_FILE(
		.CLK(CLK_INH),
		.A(A),
		.B(B),
		.AA(rs1),
		.AB(rs2),
		.D(REG_D),
		.AD(rd),
		.RW(REG_RW)
	);


	CONTROLLER CNTRL(
		.funct3(funct3),
		.funct7(funct7),
		.opcode(opcode),
		.instr_type(instr_type),
		//
		.REG_RW(REG_RW), //0-read 1-write
		.REG_SRC(REG_SRC), //0-mem 1-alu 2-pc+4
		.ALU_A_SRC(ALU_A_SRC),//0-a 1-pc
		.ALU_B_SRC(ALU_B_SRC),//0-b 1-imm
		.ALU_OP(ALU_OP),
		.MEM_RW(MEM_RW), //0-read 1-write
		.MEM_M(WM),
		.PC_A_SEL(PC_A_SEL),	
		.PC_INC_SEL(PC_INC_SEL)
	);
	
	
	MD_ALU ALU(
		.A(ALU_A_SRC?PC_OUT:A),
		.B(ALU_B_SRC?imm:B),
		.OP(ALU_OP),
		.Q(ALU_Q)
	);


endmodule
