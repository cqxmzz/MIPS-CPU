module l2cache(
  caOutInsAdd,   //in 32
  caOutIns,      //out 32
  caWrite,       //in 1
  caAdd,         //in 32
  caInData,      //in 32
  caOutData,
  caRead,      //out 32
  caStall,
  
  memOutInsAdd,   //in 32
  memOutIns,      //out 32
  memWrite,       //in 1
  memAdd,         //in 32
  memInData,      //in 32
  memOutData,
  memRead,      //out 32
  memStall
  );
input caWrite;
input [31:0] caInData;
input [31:0] caAdd;
input [31:0] caOutInsAdd;
output [31:0] caOutData;
output [31:0] caOutIns;
output caStall;
input caRead;

output memWrite;
output [31:0] memInData;
output [31:0] memAdd;
output [31:0] memOutInsAdd;
input [31:0] memOutData;
input [31:0] memOutIns;
input memStall;
output memRead;

wire inCache1;//memRead
wire inCache2;//insRead

reg [7:0] Cache[4095:0][0:3];
reg [4095:0]validBit;
reg [18:0] cacheTag[4095:0];

reg stall;

initial begin
    validBit = 0;
    stall = 0;
end

assign caOutData = inCache1 ? {Cache[caAdd[13:2]][caAdd[1:0]], Cache[caAdd[13:2]][caAdd[1:0]+1], Cache[caAdd[13:2]][caAdd[1:0]+2], Cache[caAdd[13:2]][caAdd[1:0]+3]} : memOutData;

assign caOutIns = inCache2 ? {Cache[caOutInsAdd[13:2]][0], Cache[caOutInsAdd[13:2]][1], Cache[caOutInsAdd[13:2]][2], Cache[caOutInsAdd[13:2]][3]} : memOutIns;

assign caStall = stall == 1 ? 1 : memStall;

assign memRead = inCache1 ? 0 : caRead;
assign memWrite = caWrite;

assign memOutInsAdd = inCache2 ? 0 : caOutInsAdd;
assign memAdd = caAdd;
assign memInData = caInData;

assign inCache1 = validBit[memAdd[13:2]] && (cacheTag[memAdd[13:2]] == memAdd[31:14]);
assign inCache2 = validBit[caOutInsAdd[13:2]] && (cacheTag[caOutInsAdd[13:2]] == caOutInsAdd[31:14]);

always@(negedge caStall)
begin
    
	if (inCache2)
	begin
		stall = 1;
		#5
		stall = 0;
	end
	else
	begin
		validBit[caOutInsAdd[13:2]] = 1;
		cacheTag[caOutInsAdd[13:2]] = caOutInsAdd[31:14];
		Cache[caOutInsAdd[13:2]][0] = memOutIns[31:24];
		Cache[caOutInsAdd[13:2]][1] = memOutIns[23:16];
		Cache[caOutInsAdd[13:2]][2] = memOutIns[15:8];
		Cache[caOutInsAdd[13:2]][3] = memOutIns[7:0];
	end
	
	if (caRead)
	if (inCache1)
	begin
		stall = 1;
		#9
		stall = 0;
	end
	else
	begin
		validBit[caAdd[13:2]] = 1;
		cacheTag[caAdd[13:2]] = caAdd[31:14];
		Cache[caAdd[13:2]][0] = memOutData[31:24];
		Cache[caAdd[13:2]][1] = memOutData[23:16];
		Cache[caAdd[13:2]][2] = memOutData[15:8];
		Cache[caAdd[13:2]][3] = memOutData[7:0]; 
	end
	
	if (caWrite)
   begin
	   validBit[caAdd[13:2]] = 1;
   	  cacheTag[caAdd[13:2]] = caAdd[31:14];
     	Cache[caAdd[13:2]][0] = caInData[31:24];
     	Cache[caAdd[13:2]][1] = caInData[23:16];
	   Cache[caAdd[13:2]][2] = caInData[15:8];
	   Cache[caAdd[13:2]][3] = caInData[7:0];
   end
end

endmodule

