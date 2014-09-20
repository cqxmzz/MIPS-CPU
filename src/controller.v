module controller(
  input [31:0] inIns,
	output reg [1:0] branchOut,
   output jumpReg,
   output jump,
	output	reg regWrite = 0,
	output	reg mem2Reg = 0,
	output	reg memRead = 0,
	output	reg memWrite = 0,
	output	pc2Reg,
	output	[5:0] opcode,
	output [5:0] funct,
	output	reg signExt = 0,
	output reg [1:0]ALUSrc,
	output reg regDst = 0,
	output reg halt = 0
  );
  

assign opcode = inIns[31:26];
assign funct = inIns[5:0];
assign	jumpReg = opcode == 6'b000000 && funct == 6'b001000;
assign	jump = opcode == 6'b000010 || opcode == 6'b000011;

assign	pc2Reg = opcode == 6'b000011;

always @(opcode, funct)
	begin
	   ALUSrc = 0;
		regWrite = 0;
		mem2Reg = 0;
		memRead = 0;
		memWrite = 0;
		regDst = 0;
		signExt = 0;
		branchOut = 2'b00;
		halt = 0;
	case (opcode)
		6'b000000	: case (funct)
			6'b000000		: begin regWrite = 1; regDst = 1; ALUSrc = 2'b10; end
			6'b000010		: begin regWrite = 1; regDst = 1; ALUSrc = 2'b10; end
			6'b001000		: ;
			6'b100000		: begin regWrite = 1; regDst = 1; end
			6'b100010		: begin regWrite = 1; regDst = 1; end
			6'b100101		: begin regWrite = 1; regDst = 1; end
			6'b100100		: begin regWrite = 1; regDst = 1; end
			6'b100110		: begin regWrite = 1; regDst = 1; end
			6'b100111		: begin regWrite = 1; regDst = 1; end
			6'b101010		: begin regWrite = 1; regDst = 1; end
			6'b111111 : begin halt = 1;end
		endcase
		6'b000010		: ;
		6'b000011		: begin regWrite = 1; end
		6'b000100		: begin branchOut = 2'b11; signExt = 1; end
		6'b000101		: begin branchOut = 2'b10; signExt = 1; end
		6'b001000	: begin regWrite = 1; ALUSrc = 2'b01; signExt = 1; end
		6'b001100	: begin regWrite = 1; ALUSrc = 2'b01; end
		6'b001101		: begin regWrite = 1; ALUSrc = 2'b01; end
		6'b001110	: begin regWrite = 1; ALUSrc = 2'b01; end
		6'b100011		: begin regWrite = 1; mem2Reg = 1; memRead = 1; ALUSrc = 2'b01; signExt = 1; end
		6'b101011		: begin memWrite = 1; ALUSrc = 2'b01; signExt = 1; end		
		6'b001111  : begin regWrite = 1; ALUSrc = 2'b01; signExt = 0; end
	   6'b001010 : begin regWrite = 1; ALUSrc = 2'b01; signExt = 1; end 
	   6'b111111 : begin halt = 1; end
	endcase
	end

endmodule
