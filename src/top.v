`include "CPU.v"
`include "memory.v"
`include "l2cache.v"
module top;
    
reg CLOCK;
reg RESET;
reg haltafter;

wire	HALT;

initial begin
	CLOCK = 1;
	RESET = 1;
	$readmemb("test.mif", memory.memFile);
	#0 RESET = 0;
end

always
begin
	#1 CLOCK = ~CLOCK;
end
always
begin	
   #2 haltafter = ~HALT;
end

integer	file;
integer i;

always	@(negedge haltafter)
begin
	file = $fopen("test.out");
	for (i = 0; i < 32; i = i + 1)
		$fwrite(file, "%b\n", CPU.register.reFile[i]);
	for (i = 0; i < 10; i = i + 1) begin
		$fwrite(file, "%b", memory.memFile[4*i] === 8'bx ? 8'b0 : memory.memFile[4*i]);
		$fwrite(file, "%b", memory.memFile[4*i+1] === 8'bx ? 8'b0 : memory.memFile[4*i+1]);
		$fwrite(file, "%b", memory.memFile[4*i+2] === 8'bx ? 8'b0 : memory.memFile[4*i+2]);
		$fwrite(file, "%b\n", memory.memFile[4*i+3] === 8'bx ? 8'b0 : memory.memFile[4*i+3]);
	end
	for (i = 1<<17; i < (1<<17) + 10; i = i + 1) begin
		$fwrite(file, "%b", memory.memFile[4*i] === 8'bx ? 8'b0 : memory.memFile[4*i]);
		$fwrite(file, "%b", memory.memFile[4*i+1] === 8'bx ? 8'b0 : memory.memFile[4*i+1]);
		$fwrite(file, "%b", memory.memFile[4*i+2] === 8'bx ? 8'b0 : memory.memFile[4*i+2]);
		$fwrite(file, "%b\n", memory.memFile[4*i+3] === 8'bx ? 8'b0 : memory.memFile[4*i+3]);
	end
	$finish;
end

wire [31:0] mem1;
wire [31:0] mem2;
wire mem3;
wire [31:0] mem4;
wire [31:0] mem5;
wire [31:0] mem6;
wire mem7;
wire mem8;

wire [31:0] ca1;
wire [31:0] ca2;
wire ca3;
wire [31:0] ca4;
wire [31:0] ca5;
wire [31:0] ca6;
wire ca7;
wire ca8;

CPU CPU(CLOCK, RESET, HALT, ca1, ca2, ca3, ca4, ca5, ca6, ca7, ca8);

l2cache l2cache(ca1, ca2, ca3, ca4, ca5, ca6, ca7, ca8, mem1, mem2, mem3, mem4, mem5, mem6, mem7, mem8);

memory memory(mem1, mem2, mem3, mem4, mem5, mem6, mem7, mem8, CLOCK);




endmodule


