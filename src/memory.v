module memory(
  memOutInsAdd,   //in 32
  memOutIns,      //out 32
  memWrite,       //in 1
  memAdd,         //in 32
  memInData,      //in 32
  memOutData,
  memRead,      //out 32
  memStall,
  clk
           );
input memWrite;
input [31:0] memInData;
input [31:0] memAdd;
input [31:0] memOutInsAdd;
output [31:0] memOutData;
output [31:0] memOutIns;
output reg memStall;
input memRead;
input clk;

reg [7:0] memFile[0:1024*1024-1];

initial begin
    memStall = 0;
end


assign memOutData = {memFile[memAdd],memFile[memAdd+1],memFile[memAdd+2],memFile[memAdd+3]};
assign memOutIns = memWrite && memAdd == memOutInsAdd ? memOutData : {memFile[memOutInsAdd], memFile[memOutInsAdd+1], memFile[memOutInsAdd+2], memFile[memOutInsAdd+3]};

always @(memAdd, memInData)
if (memWrite)
begin
  memFile[memAdd] = memInData[31:24];
  memFile[memAdd+1] = memInData[23:16];
  memFile[memAdd+2] = memInData[15:8];
  memFile[memAdd+3] = memInData[7:0];
end

always @(posedge memRead, posedge memWrite, memOutInsAdd)
begin
    #1
    memStall = 1;
    #19
    memStall = 0;
end

endmodule