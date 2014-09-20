module exmmBuf(
              clockIn,
              reset,
              stall,
              haltIn,
              haltOut,
              regWriteIn,
              mem2RegIn,
              memReadIn,
              memWriteIn,
              data1In,
              data2In,
              regIn,
              regWriteOut,
              mem2RegOut,
              memReadOut,
              memWriteOut,
              data1Out,
              data2Out,
              regOut,
              reg2In,
              reg2Out,
              memStall
              );
input haltIn;
output reg haltOut;

input clockIn;
input reset;
input stall;
input regWriteIn;
input mem2RegIn;
input memWriteIn;
input memReadIn;
input [31:0] data1In;
input [31:0] data2In;
input [4:0] regIn;
input [4:0] reg2In;

output reg regWriteOut;
output reg mem2RegOut;
output reg memWriteOut;
output reg memReadOut;
output reg [31:0] data1Out;
output reg [31:0] data2Out;
output reg [4:0] regOut;
output reg [4:0] reg2Out;

input memStall;

always @(posedge clockIn)
if (reset)
begin
  regWriteOut <= 0;
  mem2RegOut <= 0;
  memWriteOut <= 0;
  memReadOut <= 0;
  data1Out <= 0;
  data2Out <= 0;
  regOut <= 0;
  reg2Out <= 0;
  haltOut <= 0;
end
else if (~stall && ~memStall)
begin
  haltOut <= haltIn;
  regWriteOut <= regWriteIn;
  mem2RegOut <= mem2RegIn;
  memWriteOut <= memWriteIn;
  memReadOut <= memReadIn;
  data1Out <= data1In;
  data2Out <= data2In;
  regOut <= regIn;
  reg2Out <= reg2In;
  
end

//always @(posedge clockIn)
//haltOut <= haltIn;

endmodule