`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:42:04 09/16/2025 
// Design Name: 
// Module Name:    OSC_BASE 
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
module SOC(
		input CLK,
		//segment display
		output [6:0] SEG,
		output [5:0] AN,
		output dp,
		//io
		input [7:0] SW,
		output [7:0] LED,
		input [2:0] BTN,
		output [7:0] JD,
		input RST,
		//display
		output [7:0] TFT_R,
		output [7:0] TFT_G,
		output [7:0] TFT_B,
		output TFT_VDDEN,
		output TFT_CLK,
		output TFT_DE,
		output	TFT_DISP,
		output	TFT_BKLT
    );
	
	
	CLOCKING dcm (
	 .CLK_IN1(CLK),   	// IN
    .CLK_OUT1(CLKG), 	// 100
    .CLK_OUT2(CLK_C),	// 20
	 .CLK_OUT3(CLK_H)		//50
	);
	
	wire CLK_CPU;
	BUFGMUX CLK_MUX(
		.I1(CLK_C),
		.I0(0),
		.S(~RST),
		.O(CLK_CPU)
	);
	
	//segment clock
	OSC_CLK_DIV #(.DIVISOR(100000)) div_seg (
		.clock_in(CLKG), 
		.clock_out(CLK_SEG)
	);
	

	wire [31:0] INSTR_ADDR;
	wire [31:0] INSTR_DAT;
	wire [31:0] ADDR;
	wire [31:0] DOUT;
	wire  [31:0] DIN;
	wire [1:0] WE;
	wire [2:0] WM;
	
	wire MOP;
	/*
	(* rom_style = "block" *)
	reg [31:0] ROM [0:30000];
	
	integer i;
	initial begin
		$readmemh("program.hex",ROM);
	end
	
	reg [31:0] ROM_D=0;
	
	assign INSTR_DAT = {ROM_D[7:0],ROM_D[15:8],ROM_D[23:16],ROM_D[31:24]};
	
	always @(posedge CLK_CPU) begin
		ROM_D<=ROM[INSTR_ADDR[27:2]];
	end
	*/
	wire [31:0] ROM_A;
	wire [31:0] ROM_D;
	wire [3:0] ROM_M;
	ROM rom(		
		.CLK(CLK_CPU), 
		.AIN1({2'b0,INSTR_ADDR[31:2]}), 
		.DOUT1(INSTR_DAT), 
		
		.CLKR(~CLK_CPU), 
		.AIN2(ROM_A), 
		.DOUT2(ROM_D)

	 );
	
	MD_CPU cpu (
		.CLK(CLK_CPU),
		.INSTR_ADDR(INSTR_ADDR),
		.INSTR_DAT(INSTR_DAT),
		.ADDR(ADDR),
		.DOUT(DOUT),
		.DIN(DIN),
		.WE(WE),
		.WM(WM)
		);
	
	wire [31:0] SEG_D;
	wire [31:0] DISP_MEM_A;
	wire [31:0] DISP_MEM_D_O;
	wire [31:0] DISP_MEM_D_I;
	wire [1:0] DISP_MEM_RW;
	wire [31:0] DISP_CFG;
	CPU_RAM ram(
		
		.CLK(CLK_CPU), 
		//instr
		.ROM_A(ROM_A),
		.ROM_D(ROM_D),
		.ROM_M(ROM_M),
		//mem
		.A_IN(ADDR), 
		.DI(DOUT), 
		.DO(DIN), 
		.WM(WM), 
		.WE(WE), 
		//disp
		.DISP_MEM_A(DISP_MEM_A),
		.DISP_MEM_D_O(DISP_MEM_D_O),
		.DISP_MEM_D_I(DISP_MEM_D_I),
		.DISP_MEM_RW(DISP_MEM_RW),//0-nothing 1-read 2-write
		.DISP_MEM_SEL(DISP_MEM_SEL),
		//io
		.SEG(SEG_D),
		.LED(LED),
		.BTN(BTN),
		.SW(SW),
		.DISP_CFG(DISP_CFG)
	 );
	assign JD=SEG_D;
	 SEG_DISP seg(
	 	.CLK(CLK_SEG),
		.DAT(SEG_D),
		.SEG(SEG),
		.AN(AN),
		.dp(dp)
	 );
	 
	 //display===============
	 	reg SELECTED_BUFFER=0;
	
	always @(negedge sync)begin
		SELECTED_BUFFER<=DISP_CFG[0];
	end
	
	 wire [16:0] DISP_REQ_A;
	  wire [31:0] DISP_MEM_D_I_1;
	  wire [31:0] DISP_MEM_D_I_2;
	 DISP_MEM DISPLAY_MEM_1(
		.clka(~CLK_CPU), 
		.wea(DISP_MEM_RW==2&&SELECTED_BUFFER==0&&DISP_MEM_SEL ), 
		.addra(DISP_MEM_A), 
		.dina(DISP_MEM_D_O), 
		.douta(DISP_MEM_D_I_1), 
		
		.clkb(CLK_H), 
		.addrb(DISP_REQ_A), 
		.web(0),
		.doutb(DISP_REQ_D_1) 
	 );
	 DISP_MEM DISPLAY_MEM_2(
		.clka(~CLK_CPU), 
		.wea(DISP_MEM_RW==2&&SELECTED_BUFFER==1&&DISP_MEM_SEL),
		.addra(DISP_MEM_A),
		.dina(DISP_MEM_D_O), 
		.douta(DISP_MEM_D_I_2),
		
		.clkb(CLK_H), 
		.addrb(DISP_REQ_A),
		.web(0),
		.doutb(DISP_REQ_D_2) 
	 );
	 
	 assign DISP_MEM_D_I = SELECTED_BUFFER?DISP_MEM_D_I_2:DISP_MEM_D_I_1;
	 /*
	(* ram_style = "block" *)
	reg [31:0]DISPLAY_MEM_1[0:4066];
	(* ram_style = "block" *)
	reg [31:0]DISPLAY_MEM_2[0:4066];
	

	
	
	always @(negedge CLK_CPU)begin
		if(DISP_MEM_SEL)begin
		 if(DISP_MEM_RW==2)begin
			if(SELECTED_BUFFER==0)begin
				DISPLAY_MEM_1[DISP_MEM_A] <= DISP_MEM_D_O;
			end else begin
				DISPLAY_MEM_2[DISP_MEM_A] <= DISP_MEM_D_O;
			end
		  end
		  
		end
		
		//read

			if(SELECTED_BUFFER==0)begin
				DISP_MEM_D_I <= DISPLAY_MEM_1[DISP_MEM_A];
			end else begin
				DISP_MEM_D_I <= DISPLAY_MEM_2[DISP_MEM_A];
			end
		//write
		 if(DISP_MEM_RW==2)begin
			if(SELECTED_BUFFER==0)begin
				DISPLAY_MEM_1[DISP_MEM_A] <= DISP_MEM_D_O;
			end else begin
				DISPLAY_MEM_2[DISP_MEM_A] <= DISP_MEM_D_O;
			end
		end
		

		
	end
	*/
	/*

	wire DISP_REQ_D;
	reg [31:0] DISP_REQ_DD;
	
	always @(posedge CLK_H)begin
		if(SELECTED_BUFFER==0)begin
			DISP_REQ_DD <= DISPLAY_MEM_2[DISP_REQ_A[31:5]];
		end else begin
			DISP_REQ_DD <= DISPLAY_MEM_1[DISP_REQ_A[31:5]];
		end
	end
	
	assign DISP_REQ_D = DISP_REQ_DD[DISP_REQ_A[4:0]];
	*/
	
	assign DISP_REQ_D = SELECTED_BUFFER?DISP_REQ_D_1:DISP_REQ_D_2;
	
	 OSC_CLK_DIV #(.DIVISOR(12)) disp_div (
		.clock_in(CLKG), 
		.clock_out(CLK_DISP)
	);
	
	OSC_DISP display(
		.CLK(CLK_DISP), 
		
		
		.ADDRA(DISP_REQ_A), 
		.DATA(DISP_REQ_D),
		
		.TFT_R(TFT_R), 
		.TFT_G(TFT_G), 
		.TFT_B(TFT_B), 
		.TFT_VDDEN(TFT_VDDEN), 
		.TFT_CLK(TFT_CLK), 
		.TFT_DE(TFT_DE), 
		.TFT_DISP(TFT_DISP), 
		.TFT_BKLT(TFT_BKLT), 
		
		.sync(sync)
	 );

endmodule
