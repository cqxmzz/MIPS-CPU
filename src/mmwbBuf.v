module mmwbBuf(
	                 clockIn,
	                 reset,
	                 stall,
	                 regWriteIn,
	                 mem2RegIn,
	                 data1In,
	                 data2In,
	                 regIn,
	                 regWriteOut,
	                 mem2RegOut,
	                 data1Out,
	                 data2Out,
	                 regOut,
	                 memStall
	                  );

input	clockIn;
input	reset;
input	stall;
input	regWriteIn;
input	mem2RegIn;
input 	[31:0] data1In;
input 	[31:0] data2In;
input 	[4:0] regIn;
output	reg regWriteOut;
output	reg mem2RegOut;
output	reg [31:0] data1Out;
output	reg [31:0] data2Out;
output	reg [4:0] regOut;

input memStall;

always @(posedge clockIn)
	if (reset) 
	begin
		regWriteOut <= 0;
		mem2RegOut <= 0;
		data1Out <= 0;
		data2Out <= 0;
		regOut <= 0;
	end else if (~stall && ~memStall) 
	begin
		regWriteOut <= regWriteIn;
		mem2RegOut <= mem2RegIn;
		data1Out <= data1In;
		data2Out <= data2In;
		regOut <= regIn;
	end

endmodule