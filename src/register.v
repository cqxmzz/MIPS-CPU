module register(clockIn,
                reset,
                reInAdd,
                reOutAdd1,
                reOutAdd2,
                reInData,
                reOutData1,
                reOutData2,
                reWrite
                );
input reset;
input clockIn;
input [4:0] reInAdd;
input [4:0] reOutAdd1;
input [4:0] reOutAdd2;

input reWrite;
input [31:0] reInData;
output [31:0] reOutData1;
output [31:0] reOutData2;

reg [31:0] reFile[31:0];
	
	
assign reOutData1 = reFile[reOutAdd1];
assign reOutData2 = reFile[reOutAdd2];

always @(negedge clockIn)
begin
if (reWrite && reInAdd)
  reFile[reInAdd] = reInData;
end

integer i; 
always @(posedge reset)
begin  
  for (i = 0; i < 32; i = i + 1)
    reFile[i] <= 0;
end
endmodule
