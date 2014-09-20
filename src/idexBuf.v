module idexBuf(
              clockIn,
              reset,
              stall,
              regWriteIn,
              mem2RegIn,
              memReadIn,
              memWriteIn,
              pc2RegIn,//
              regDstIn,//
              ALUOpIn,
              ALUSrcIn,//
              PCIn,
              data1In,
              data2In,
              signExtIn,//
              reg1In,
              reg2In,
              reg3In,
              regWriteOut,
              mem2RegOut,
              memReadOut,
              memWriteOut,
              pc2RegOut,//
              regDstOut,//
              ALUOpOut,
              ALUSrcOut,
              PCOut,
              data1Out,
              data2Out,
              signExtOut,//
              reg1Out,
              reg2Out,
              reg3Out,
              haltIn,
              haltOut,
              memStall
              );
input clockIn;
input reset;
input stall;

input regWriteIn;
input mem2RegIn;
input memReadIn;
input memWriteIn;
input [3:0]ALUOpIn;

input [31:0] data1In;
input [31:0] data2In;
input [4:0] reg1In;
input [4:0] reg2In;
input [4:0] reg3In;

input pc2RegIn;
input regDstIn;
input [1:0] ALUSrcIn;
input [31:0]PCIn;
input [31:0] signExtIn;
output reg pc2RegOut;
output reg regDstOut;
output reg [1:0] ALUSrcOut;
output reg [31:0] PCOut;
output reg [31:0] signExtOut;


output reg regWriteOut;
output reg  mem2RegOut;
output reg  memReadOut;
output reg  memWriteOut;
output reg  [3:0] ALUOpOut;
output reg  [31:0] data1Out;
output reg  [31:0] data2Out;
output reg  [4:0] reg1Out;
output reg  [4:0] reg2Out;
output reg  [4:0] reg3Out;

input haltIn;
output reg haltOut;

input memStall;

always @(posedge clockIn)
if (reset)
begin
  regWriteOut <= 0;
  mem2RegOut <= 0;
  memReadOut <= 0;
  memWriteOut <= 0;
  ALUOpOut<= 0;
  data1Out <= 0;
  data2Out <= 0;
  reg1Out <= 0;
  reg2Out <= 0;
  reg3Out <= 0;
  pc2RegOut <= 0;
  regDstOut <= 0;
  ALUSrcOut <= 0;
  PCOut <= 0;
  signExtOut <= 0;
  haltOut <= 0;

end
else if (~stall && ~memStall)
begin
  regWriteOut <= regWriteIn;
  mem2RegOut <= mem2RegIn;
  memReadOut <= memReadIn;
  memWriteOut <= memWriteIn;
  ALUOpOut <= ALUOpIn;
  data1Out <= data1In;
  data2Out <= data2In;
  reg1Out <= reg1In;
  reg2Out <= reg2In;
  reg3Out <= reg3In;
  pc2RegOut <= pc2RegIn;
  regDstOut <= regDstIn;
  ALUSrcOut <= ALUSrcIn;
  PCOut <= PCIn;
  signExtOut <= signExtIn;
  haltOut <= haltIn;
  
end

endmodule