module ifidBuf(
              clockIn,
              reset,
              stall,
              inPc,
              inIns,
              outPc,
              outIns,
              memStall
              );
input clockIn;
input reset;
input stall;
input [31:0] inPc;
input [31:0] inIns;
output reg [31:0] outPc;
output reg [31:0] outIns;
input memStall;

always @(posedge clockIn)
if (reset)
  begin
    outPc <= 0;
    outIns <= 0;
  end
else if (~stall && ~memStall)
      begin
        outPc <= inPc;
        outIns <= inIns;
      end

endmodule