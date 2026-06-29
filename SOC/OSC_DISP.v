`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:38:37 09/16/2025 
// Design Name: 
// Module Name:    OSC_DISP 
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
module OSC_DISP(
		input  CLK,
		input  RST,
		// memory 
		output [16:0] ADDRA,
		input   [8:0] DATA,
		// display pins
		output reg [7:0] TFT_R,
		output reg [7:0] TFT_G,
		output reg [7:0] TFT_B,
		output reg TFT_VDDEN,
		output TFT_CLK,
		output TFT_DE,
		output reg TFT_DISP,
		output reg TFT_BKLT,
		output sync
    );
	 
	 
	reg [16:0] memCnt=0;
	assign ADDRA = memCnt;
	
	// 10bit horizontal clock cycle/pixel counter
	reg [31:0] horizontalCounter = 0;
	// 9bit line counter
	reg [31:0] verticalCounter = 0;
	reg [31:0] stateCnt=0;
	reg [1:0] state=0;
	reg show = 0;
	
	assign TFT_DE = (horizontalCounter>45)&&(verticalCounter>16)&&(show==1);
	assign TFT_CLK =  CLK &&(show==1);
	assign sync = (horizontalCounter==0)&&(verticalCounter==0);
	
	
	
	always @(posedge CLK)
	begin
		if(RST) begin
			state = 0;
			TFT_VDDEN = 0;
			TFT_BKLT = 0;
			TFT_DISP = 0;
			stateCnt=0;
			horizontalCounter=0;
			verticalCounter=0;
		end else begin
		
		
		if(state == 0) begin
			stateCnt = stateCnt + 1;
			if(stateCnt > 1000000)begin
				state = 1;
				TFT_VDDEN = 1;
			end
		end 

		if(state==1) begin
			stateCnt = stateCnt + 1;
			if(stateCnt > 2000000)begin
				TFT_DISP = 1;
				show=1;
				state = 2;
			end
		end
		
		if(state==2) begin
			stateCnt = stateCnt + 1;
			if(stateCnt > 4000000)begin
				state = 3;
				TFT_BKLT = 1;
			end
		end
		
		
		if(TFT_DE == 1) begin
			
			// write pixel
			TFT_R = {8{DATA[0]}};
			TFT_G = {8{DATA[0]}};
			TFT_B = {8{DATA[0]}};
			
			if(memCnt > 480*271)
				memCnt = 0;
			else
				memCnt = memCnt+1;
			
		end else begin
			TFT_R = 0;
			TFT_G = 0;
			TFT_B = 0;
		end
		if(sync) begin
			memCnt=0;
		end
		
		
			
		// progress counters
		horizontalCounter = horizontalCounter + 1;
		if(horizontalCounter > 480+43) begin
			horizontalCounter = 0;
			verticalCounter = verticalCounter + 1;
		end
		
		if(verticalCounter > 272+16) begin
			verticalCounter = 0;
		end
		end
	end

	initial
	begin
		//initialisation
		//enable display
		TFT_VDDEN=0;
		TFT_DISP=0;
		TFT_BKLT=0;
	end

endmodule
