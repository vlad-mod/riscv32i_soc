`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:08:53 12/04/2025 
// Design Name: 
// Module Name:    MD_RAM 
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
module CPU_RAM(
		input CLK,
		//memory
		input [31:0] DI,
		input [2:0] WM,
		input [31:0] A_IN,
		input [1:0] WE, //0-nothing 1-read 2-write
		output [31:0] DO,
		//rom
		output [31:0] ROM_A,
		output [31:0] ROM_D,
		output [3:0] ROM_M,
		//display
		output [31:0] DISP_MEM_A,
		output  [31:0] DISP_MEM_D_O,
		input [31:0] DISP_MEM_D_I,
		output  DISP_MEM_SEL,
		output [1:0] DISP_MEM_RW,//0-nothing 1-read 2-write
		
		//io
		output [31:0] SEG,
		output [7:0] LED,
		input [2:0] BTN,
		input [7:0] SW,
		output [31:0] DISP_CFG
	);
	//display 0x30000000
	//ram 0x20000000
	//peripherals 0x10000000
	//rom  0x00000000

	reg [31:0] DOP;
	wire [31:0] DOM;
	reg [31:0] DOMO;
	reg [31:0] DOR;
	wire [31:0] DODISP;
	
	reg [3:0] RAM_WE;
	
	wire SEL_RAM;
	assign SEL_RAM = A[31:28]== 4'h2;//A==0x2XXXXXXX
	assign SEL_PER = A[31:28]== 4'h1;//A==0x1XXXXXXX
	assign SEL_ROM = A[31:28]== 4'h0;//A==0x0XXXXXXX
	assign SEL_DIS = A[31:28]== 4'h3;//A==0x3XXXXXXX
	
	assign DO = SEL_RAM?DOMO:(SEL_PER?DOP:(SEL_ROM?DOR:(SEL_DIS?DODISP:0)));
	
	reg  [31:0] A;
	
	always@(*) begin
		if(WE!=0)begin
			A<=A_IN;
		end
	end
	
	
	
	RAM_MEM memm(
		.clka(~CLK),
		.addra({6'b0,A[27:2]}),
		.dina(DI<<(A[1:0]*8)),
		.wea(RAM_WE),
		
		.clkb(~CLK),
		.addrb({6'b0,A[27:2]}),
		.doutb(DOM),
		.web(0)
	);

	
	always @(*) begin
    case (WM[1:0])
        // byte
        2'd0: RAM_WE = (WE==2&SEL_RAM) ? (4'b0001 << A[1:0]) : 4'b0000;

        // half word
        2'd1: RAM_WE = (WE==2&SEL_RAM) ? (4'b0011 << (A[0]*2)) : 4'b0000;

        // word
        2'd2: RAM_WE = (WE==2&SEL_RAM) ? 4'b1111 : 4'b0000;

        default: RAM_WE = 4'b0000;
		endcase
	end
	
	always @(*) begin
		case(WM[1:0])
			//byte
			0: begin
				case(A[1:0])
					0: DOMO = {WM[2]?{24{DOM[ 7]}}:24'b0,DOM[7:0]};
					1: DOMO = {WM[2]?{24{DOM[15]}}:24'b0,DOM[15:8]};
					2: DOMO = {WM[2]?{24{DOM[23]}}:24'b0,DOM[23:16]};
					3: DOMO = {WM[2]?{24{DOM[31]}}:24'b0,DOM[31:24]};
				endcase
			end
			//half work
			1: begin
				case(A[0])
					0: DOMO = {WM[2]?{16{DOM[15]}}:16'b0,DOM[15:0]};
					1: DOMO = {WM[2]?{16{DOM[31]}}:16'b0,DOM[31:16]};
				endcase
			end
			//word
			2: DOMO = DOM;
			//error
			default: begin
				DOMO=0;
			end
		endcase
	end
	
	//peripherals============

	reg [31:0] perh [0:31];
	
	
	integer i;
	initial begin
		for(i = 0; i < 32; i = i+1) begin
			perh[i] = 0;
		end
	end
	
	//io
	assign SEG=perh[0];
	assign LED=perh[1];
	//display config
	assign DISP_CFG=perh[4];

	

	always@(negedge CLK) begin
		
		if(WE!=0 & SEL_PER)begin
			$display("%x - %x",A[27:2],DI);
		case(WM[1:0])
			//byte
			0: perh[A[27:2]] <= (DI[7:0]<<A[1:0])|((~(32'hff<<(A[1:0]*8)))&perh[A[27:2]]);
			//half word
			1: perh[A[27:2]] <= (DI[15:0]<<A[0])|((~(32'hffff<<(A[0]*16)))& perh[A[27:2]]);
			//word
			2: perh[A[27:2]] <= DI[31:0];
			//error
			default: begin
			end
		endcase
		end
		//io
		perh[2]<=BTN;
		perh[3]<=SW;
	end
	
	always@(negedge CLK) begin
		if(SEL_PER)begin
			//$display("PER DO=%x | ADDR=%x | WE=%x | WM=%x",DI, A, WE, WM);
		end
		
		case(WM[1:0])
			//byte
			0: begin
				case(A[1:0])
					0: DOP = {WM[2]?{24{perh[A[27:2]][ 7]}}:24'b0,perh[A[27:2]][7:0]};
					1: DOP = {WM[2]?{24{perh[A[27:2]][15]}}:24'b0,perh[A[27:2]][15:8]};
					2: DOP = {WM[2]?{24{perh[A[27:2]][23]}}:24'b0,perh[A[27:2]][23:16]};
					3: DOP = {WM[2]?{24{perh[A[27:2]][31]}}:24'b0,perh[A[27:2]][31:24]};
				endcase
			end
			//half work
			1: begin
				case(A[0])
					0: DOP = {WM[2]?{16{perh[A[27:2]][15]}}:16'b0,perh[A[27:2]][15:0]};
					1: DOP = {WM[2]?{16{perh[A[27:2]][31]}}:16'b0,perh[A[27:2]][31:16]};
				endcase
			end
			//word
			2: DOP = perh[A[27:2]];
			//error
			default: begin
				DOP=0;
			end
		endcase
	end
	
	
	//display===========
	assign DODISP = DISP_MEM_D_I;
	assign DISP_MEM_RW = WE;
	assign DISP_MEM_SEL = SEL_DIS;
	assign DISP_MEM_A ={2'b0,A[27:2]};
	assign DISP_MEM_D_O =DI;
			/*
	always@(*) begin
		if(WE!=0 & SEL_DIS)begin
			DISP_MEM_A<={2'b0,A[27:2]};
			DISP_MEM_D_O<=DI;
		end
	end
	*/
	//ROM============

	assign ROM_A=A[27:2];
	assign ROM_M=4'b1111;

	

	
	always@(*) begin
		if(SEL_ROM)begin
			//$display("ROM DO=%x | ADDR=%x | WE=%x | WM=%x",DI, A, WE, WM);
		end
		
		case(WM[1:0])
			//byte
			0: begin
				case(A[1:0])
					0: DOR = {WM[2]?{24{ROM_D[ 7]}}:24'b0,ROM_D[31:24]};
					1: DOR = {WM[2]?{24{ROM_D[15]}}:24'b0,ROM_D[23:16]};
					2: DOR = {WM[2]?{24{ROM_D[23]}}:24'b0,ROM_D[15:8]};
					3: DOR = {WM[2]?{24{ROM_D[31]}}:24'b0,ROM_D[7:0]};
				endcase
			end
			//half work
			1: begin
				case(A[0])
					0: DOR = {WM[2]?{16{ROM_D[15]}}:16'b0,{ROM_D[23:16],ROM_D[31:24]}};
					1: DOR = {WM[2]?{16{ROM_D[31]}}:16'b0,{ROM_D[7:0],ROM_D[15:8]}};
				endcase
			end
			//word
			2: DOR = {ROM_D[7:0],ROM_D[15:8],ROM_D[23:16],ROM_D[31:24]};
			//error
			default: begin
				DOR=0;
			end
		endcase
	end

endmodule
