`include "alu.v"
`include "aluCtr.v"
`include "SE.v"
`include "register.v"
`include "pcBuf.v"
`include "ifidBuf.v"
`include "idexBuf.v"
`include "exmmBuf.v"
`include "mmwbBuf.v"
`include "controller.v"
`include "l1cache.v"

module CPU(
          input CLK,
          input RESET,
          output HALT,
          input [31:0] mem1,
          output [31:0] mem2,
          input mem3,
          input [31:0] mem4,
          input [31:0] mem5,
          output [31:0] mem6,
          output mem7,
          input mem8
          );


wire  SMC1;
wire  SMC2;
wire  SMC3;

wire IDHaltOut;
wire EXHaltIn;
wire EXHaltOut;
wire MMHaltIn;

assign EXHaltOut = EXHaltIn;

//IF

wire [31:0] IFPCOut;

wire PCReset;
wire PCStall;

wire [31:0] EXPCIn;
wire [31:0] NextPC;
wire [31:0] IDPCIn;
wire [31:0] IDData1Out;
wire [31:0] IDData2Out;
wire [31:0] EXSignExtIn;
wire [31:0] PC;
wire [31:0] IDInsIn;
wire [1:0]IDBranchOut;
wire [31:0] ALUData1;
wire [31:0] ALUData2;
wire branch;

assign branch = IDBranchOut[1] && IDBranchOut[0] == (IDData1Out == IDData2Out ? 1 : 0);

wire jumpReg;
wire jump;
wire [31:0] IDPCOut;
wire [31:0] IDSignExtOut;

assign IFPCOut = PC + 4;//PCStall? NextPC : PC + 4

reg [31:0] fomerNextPC;
 
assign	NextPC =
	SMC1 || SMC2 || SMC3 ? EXPCIn - 4 :
	jump ? {IDPCIn[31:28], IDInsIn[25:0], 2'b00} :
	jumpReg ? IDData1Out :
	branch ? IDPCOut + (IDSignExtOut << 2) :
	IFPCOut;


pcBuf pcBuf(CLK, RESET || PCReset, PCStall, NextPC, PC, mem8);

//memory

wire IFIDStall;
wire IFIDReset;
wire [31:0] IFInsOut;

ifidBuf ifidBuf(CLK, RESET || IFIDReset, IFIDStall, IFPCOut, IFInsOut, IDPCIn, IDInsIn, mem8);
  
//ID

wire IDEXReset;
wire EXMMReset;
wire MMWBReset;
wire IDRegWriteOut;
wire IDMem2RegOut;
wire IDMemReadOut;
wire IDMemWriteOut;
wire [5:0] opcode;
wire [5:0] funct;
wire IDPC2RegOut;
wire IDRegDstOut;
wire [1:0] IDALUSrcOut;
wire signExt;


controller controller(IDInsIn, IDBranchOut, jumpReg, jump, IDRegWriteOut, IDMem2RegOut, IDMemReadOut, IDMemWriteOut, IDPC2RegOut, opcode, funct, signExt, IDALUSrcOut, IDRegDstOut, IDHaltOut);

wire [3:0] IDALUOpOut;

aluCtr aluCtr(opcode, funct, IDALUOpOut);

wire [4:0] IDReg1Out;
wire [4:0] IDReg2Out;
wire [4:0] IDReg3Out;

assign	IDPCOut = IDPCIn;

assign	IDReg1Out = IDInsIn[25:21];
assign	IDReg2Out = IDInsIn[20:16];
assign	IDReg3Out = IDInsIn[15:11];

wire [4:0] WBRegIn;
wire [31:0] WBDataOut;
wire WBRegWriteIn;

wire IDEXStall;

wire	[31:0] IDRegData1;
wire	[31:0] IDRegData2;
wire MMRegWriteIn;
wire [4:0]MMRegIn;
wire [31:0] MMData1In;
wire EXRegWriteIn;
wire [4:0] EXRegOut;
wire [31:0] EXData1Out;
wire EXMemReadIn;
wire [31:0] MMData1Out;
wire MMMem2RegIn;

assign	IDData1Out =
	(MMRegWriteIn && MMRegIn == IDReg1Out) ? 
	                                        MMMem2RegIn? MMData1Out: MMData1In :
	(EXRegWriteIn && EXRegOut == IDReg1Out && ~EXMemReadIn) ? EXData1Out :
	IDRegData1;
assign	IDData2Out =
	(MMRegWriteIn && MMRegIn == IDReg2Out) ?
	                                          MMMem2RegIn? MMData1Out:  MMData1In :
	(EXRegWriteIn && EXRegOut == IDReg2Out && ~EXMemReadIn) ? EXData1Out :
	IDRegData2;


register register(CLK, RESET, WBRegIn, IDReg1Out, IDReg2Out, WBDataOut, IDRegData1, IDRegData2, WBRegWriteIn);

SE SE(signExt, IDInsIn[15:0], IDSignExtOut);

//IDEX
wire EXMem2RegIn;

wire EXMemWriteIn;
wire EXPC2RegIn;
wire EXRegDstIn;
wire [3:0] EXALUOpIn;
wire [1:0] EXALUSrcIn;
wire [31:0] EXData1In;
wire [31:0] EXData2In;
wire [4:0] EXReg1In;
wire [4:0] EXReg2In;
wire [4:0] EXReg3In;
idexBuf idexBuf(CLK, RESET || IDEXReset, IDEXStall, IDRegWriteOut, IDMem2RegOut, IDMemReadOut, IDMemWriteOut, 
                    IDPC2RegOut, IDRegDstOut, IDALUOpOut, IDALUSrcOut, IDPCOut, IDData1Out, IDData2Out, IDSignExtOut, IDReg1Out, 
                    IDReg2Out, IDReg3Out, EXRegWriteIn, EXMem2RegIn, EXMemReadIn, EXMemWriteIn, EXPC2RegIn, EXRegDstIn, 
                    EXALUOpIn, EXALUSrcIn, EXPCIn, EXData1In, EXData2In, EXSignExtIn, EXReg1In, EXReg2In, EXReg3In, IDHaltOut, 
                    EXHaltIn, mem8);
                    

// EX

wire EXRegWriteOut;
wire EXMem2RegOut;
wire EXMemReadOut;
wire EXMemWriteOut;

assign	EXRegWriteOut = EXRegWriteIn;
assign	EXMem2RegOut = EXMem2RegIn;
assign	EXMemReadOut = EXMemReadIn;
assign	EXMemWriteOut = EXMemWriteIn;


wire	[31:0] ALUResult;
wire	[31:0] shamt;
wire	[31:0] EXRegData1In;
wire	[31:0] EXRegData2In;

assign	shamt = {{27{1'b0}}, EXSignExtIn[10:6]};

assign	EXRegData1In =
	(MMRegWriteIn && MMRegIn == EXReg1In) ? MMData1In :
	WBRegWriteIn && WBRegIn == EXReg1In ? WBDataOut :
	EXData1In;
assign	EXRegData2In =
	(MMRegWriteIn && MMRegIn == EXReg2In) ? MMData1In :
	WBRegWriteIn && WBRegIn == EXReg2In ? WBDataOut :
	EXData2In;


assign	ALUData1 =
	EXRegData1In;
assign	ALUData2 =
	(EXALUSrcIn == 2'b01) ? EXSignExtIn :
	(EXALUSrcIn == 2'b10) ? shamt :
	EXRegData2In;

alu alu(ALUData1, ALUData2, EXALUOpIn, ALUResult);

wire [31:0] EXData2Out;

assign	EXData1Out = EXPC2RegIn ? EXPCIn : ALUResult;
assign	EXData2Out = EXData2In;
assign	EXRegOut = EXPC2RegIn ? 5'b11111 : 
                  EXRegDstIn ? EXReg3In : EXReg2In;

//EXMM

wire EXMMStall;
wire MMMemReadIn;
wire MMMemWriteIn;
wire [31:0] MMData2In;
wire [4:0] MMReg2In;

exmmBuf exmmBuf(CLK, RESET || EXMMReset, EXMMStall, EXHaltOut, MMHaltIn, EXRegWriteOut, EXMem2RegOut, EXMemReadOut, EXMemWriteOut, 
                EXData1Out, EXData2Out, EXRegOut, MMRegWriteIn, MMMem2RegIn, MMMemReadIn, MMMemWriteIn, 
                MMData1In, MMData2In, MMRegIn, EXReg2In, MMReg2In, mem8);

//memory
wire MMRegWriteOut;
wire MMMem2RegOut;
wire [31:0] MMData2Out;
wire [4:0] MMRegOut;

assign	MMRegWriteOut = MMRegWriteIn;
assign	MMMem2RegOut = MMMem2RegIn;
assign	MMData2Out = MMData1In;
assign	MMRegOut = MMRegIn;

//memory memory(PC, IFInsOut, MMMemWriteIn, MMData1In, MMMemWriteIn && WBRegIn == MMReg2In ? WBDataOut :	MMData2In, MMData1Out);

wire [31:0]ca1;
wire [31:0]ca2;
wire ca3;
wire [31:0]ca4;
wire [31:0]ca5;
wire [31:0]ca6;
wire ca7;

l1cache l1cache(ca1, ca2, ca3, ca4, ca5, ca6, ca7, ca8, mem1, mem2, mem3, mem4, mem5, mem6, mem7, mem8);


assign ca1 = PC;
assign IFInsOut = ca2;
assign ca3 = MMMemWriteIn;
assign ca4 = MMData1In;
assign ca5 = MMMemWriteIn && WBRegIn == MMReg2In ? WBDataOut :	MMData2In;
assign MMData1Out = ca6;
assign ca7 = MMMemReadIn;



//MMWB

wire MMWBStall;
wire WBMem2RegIn;
wire [31:0] WBData1In;
wire [31:0] WBData2In;

mmwbBuf mmwbBuf(CLK, RESET || MMWBReset, MMWBStall, MMRegWriteOut, MMMem2RegOut, MMData1Out, MMData2Out, 
               MMRegOut, WBRegWriteIn, WBMem2RegIn, WBData1In, WBData2In, WBRegIn, mem8);

//WB

assign	WBDataOut = WBMem2RegIn ? WBData1In : WBData2In;

//reset

assign	PCReset = 0;
assign	IFIDReset = (~IFIDStall && (branch || jumpReg || jump) || SMC1 || SMC2 || SMC3) && ~mem8;
assign	IDEXReset = (SMC1 || SMC2 || SMC3 || IFIDStall) && ~mem8;
assign	EXMMReset = (SMC1 || SMC2 || SMC3) && ~mem8;
assign	MMWBReset = 0;//=3=~~


// STALL

assign	PCStall = HALT || EXMemReadIn && (EXRegOut == IDReg1Out || EXRegOut == IDReg2Out) || jumpReg && EXRegWriteIn && EXRegOut == IDReg1Out;
assign	IFIDStall = HALT || EXMemReadIn && (EXRegOut == IDReg1Out || EXRegOut == IDReg2Out) || jumpReg && EXRegWriteIn && EXRegOut == IDReg1Out;
assign	IDEXStall = HALT;
assign	EXMMStall = HALT;
assign	MMWBStall = HALT;
assign HALT = MMHaltIn;


// SMC
assign	SMC1 = MMMemWriteIn && MMData1In == EXPCIn - 4;
assign	SMC2 = MMMemWriteIn && MMData1In == IDPCIn - 4;
assign	SMC3 = MMMemWriteIn && MMData1In == PC;

//L1Cache






endmodule






