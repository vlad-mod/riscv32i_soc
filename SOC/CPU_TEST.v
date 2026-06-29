
`timescale 1ns/1ps

module CPU_TEST;

reg CLK = 0;
wire [31:0] INSTR_ADDR;
reg  [31:0] INSTR_DAT;
wire [31:0] ADDR;
wire [31:0] DOUT;
wire  [31:0] DIN;
wire [1:0] WE;
wire [2:0] WM;
wire READY;

// Instantiate DUT
MD_CPU dut (
    .CLK(CLK),
	 
    .INSTR_ADDR(INSTR_ADDR),
    .INSTR_DAT(INSTR_DAT),
	 
    .ADDR(ADDR),
    .DOUT(DOUT),
    .DIN(DIN),
    .WE(WE),
	 .WM(WM),
	 .READY(READY)
);

CPU_RAM ram(
	.CLK(CLK),
	.DI(DOUT),
	.WM(WM),
	.A_IN(ADDR),
	.WE(WE),
	.DO(DIN),
	.READY(READY)
);


always #5 CLK = ~CLK;

// ROM model
reg [31:0] ROM [0:32768];

always @(posedge CLK) begin
    INSTR_DAT = {ROM[INSTR_ADDR[31:2]][7:0],ROM[INSTR_ADDR[31:2]][15:8],ROM[INSTR_ADDR[31:2]][23:16],ROM[INSTR_ADDR[31:2]][31:24]};
end

initial begin
$readmemh("program.hex",ROM);
	INSTR_DAT =0;
    $display("Running tests...");
 // === branching ===
    // Load program
	 		

/*	 
		 ROM[ 0] =  32'h00000000;
 ROM[ 1] =  32'hfe010113;
 ROM[ 2] =  32'h00112e23;
 ROM[ 3] =  32'h00812c23;
 ROM[ 4] =  32'h02010413;
 ROM[ 5] =  32'hfe042623;
 ROM[ 6] =  32'hfec42783;
 ROM[ 7] =  32'h00178793;
 ROM[ 8] =  32'hfef42623;
 ROM[ 9] =  32'h000007b7;
 ROM[10] =  32'h0007a783;
 ROM[11] =  32'hfec42703;
 ROM[12] =  32'h00e7a023;
 ROM[13] =  32'hfe5ff06f;


 ROM[ 0] =  32'h00a50513;
 ROM[ 1] =  32'h01428293;
 ROM[ 2] =  32'h00552023;
 ROM[ 3] =  32'h00052303;
 ROM[ 4] =  32'h0062c5b3;
 ROM[ 5] =  32'h0015b393;
 ROM[ 6] =  32'h14521e63;
 ROM[ 7] =  32'h00148493;
 ROM[ 8] =  32'h40310233;
 ROM[ 9] =  32'h00200293;
 ROM[10] =  32'h14521663;
 ROM[11] =  32'h00148493;
 ROM[12] =  32'h00317233;
 ROM[13] =  32'h00100293;
 ROM[14] =  32'h12521e63;
 ROM[15] =  32'h00148493;
 ROM[16] =  32'h00316233;
 ROM[17] =  32'h00700293;
 ROM[18] =  32'h12521663;
 ROM[19] =  32'h00148493;
 ROM[20] =  32'h00314233;
 ROM[21] =  32'h00600293;
 ROM[22] =  32'h10521e63;
 ROM[23] =  32'h00148493;
 ROM[24] =  32'h00312233;
 ROM[25] =  32'h10021863;
 ROM[26] =  32'h00148493;
 ROM[27] =  32'h00313233;
 ROM[28] =  32'h10021263;
 ROM[29] =  32'h00148493;
 ROM[30] =  32'h00100313;
 ROM[31] =  32'h00611233;
 ROM[32] =  32'h00a00293;
 ROM[33] =  32'h0e521863;
 ROM[34] =  32'h00148493;
 ROM[35] =  32'h00615233;
 ROM[36] =  32'h00200293;
 ROM[37] =  32'h0e521063;
 ROM[38] =  32'h00148493;
 ROM[39] =  32'h40615233;
 ROM[40] =  32'h00200293;
 ROM[41] =  32'h0c521863;
 ROM[42] =  32'h00148493;
 ROM[43] =  32'hffd10213;
 ROM[44] =  32'h00200293;
 ROM[45] =  32'h0c521063;
 ROM[46] =  32'h00148493;
 ROM[47] =  32'h00312213;
 ROM[48] =  32'h0a021a63;
 ROM[49] =  32'h00148493; 
 ROM[50] =  32'h00313213;  
 ROM[51] =  32'h0a021463;
 ROM[52] =  32'h00148493;
 ROM[53] =  32'h00317213;
 ROM[54] =  32'h00100293;
 ROM[55] =  32'h08521c63;
 ROM[56] =  32'h00148493;
 ROM[57] =  32'h00316213;
 ROM[58] =  32'h00700293;
 ROM[59] =  32'h08521463;
 ROM[60] =  32'h00148493;
 ROM[61] =  32'h00314213;
 ROM[62] =  32'h00600293;
 ROM[63] =  32'h06521c63;
 ROM[64] =  32'h00148493;
 ROM[65] =  32'h00211213;
 ROM[66] =  32'h01400293;
 ROM[67] =  32'h06521463;
 ROM[68] =  32'h00148493;
 ROM[69] =  32'h00215213;
 ROM[70] =  32'h00100293;
 ROM[71] =  32'h04521c63;
 ROM[72] =  32'h00148493;
 ROM[73] =  32'h40215213;
 ROM[74] =  32'h00100293;
 ROM[75] =  32'h04521463;
 ROM[76] =  32'h00148493;
 ROM[77] =  32'h00010237;
 ROM[78] =  32'h00100293;
 ROM[79] =  32'h01029293;
 ROM[80] =  32'h02521a63;
 ROM[81] =  32'h00148493;
 ROM[82] =  32'h00000217;
 ROM[83] =  32'h014003ef;
 ROM[84] =  32'h00100213;
 ROM[85] =  32'h02020063;
 ROM[86] =  32'h00148493;
 ROM[87] =  32'h0080006f;
 ROM[88] =  32'h00038067;
 ROM[89] =  32'h00210463;
 ROM[90] =  32'h00c0006f;
 ROM[91] =  32'h00100093;
 ROM[92] =  32'h00c0006f;
 ROM[93] =  32'h00000093;
 ROM[94] =  32'hffdff06f;
 ROM[95] =  32'h0000006f;


*/





    repeat(15000000) @(posedge CLK);
	 $display("x0=%x",dut.REG_FILE.REG_FILE[0]);
	 $display("x1=%x",dut.REG_FILE.REG_FILE[1]);
	 $display("x2=%x",dut.REG_FILE.REG_FILE[2]);
	 $display("x3=%x",dut.REG_FILE.REG_FILE[3]);
	 $display("x4=%x",dut.REG_FILE.REG_FILE[4]);
	 $display("x5=%x",dut.REG_FILE.REG_FILE[5]);
	 $display("x6=%x",dut.REG_FILE.REG_FILE[6]);
	 $display("x7=%x",dut.REG_FILE.REG_FILE[7]);
	 $display("x8=%x",dut.REG_FILE.REG_FILE[8]);
	 $display("x9=%x",dut.REG_FILE.REG_FILE[9]);
	 $display("x10=%x",dut.REG_FILE.REG_FILE[10]);
    $display("All tests completed!");
    $stop;
end

endmodule
