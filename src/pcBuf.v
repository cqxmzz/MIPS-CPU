module pcBuf(
            clockIn,
            reset,
            stall,
            ipc,
            opc,
            memStall
            );
input stall;
input clockIn;
input reset;
input [31:0] ipc;
output [31:0] opc;
reg [31:0] opc;
input memStall;

always @(posedge clockIn)
begin
  if (reset)
    opc <= 0;
  else if (~stall && ~memStall)
    opc <= ipc;
end

endmodule  