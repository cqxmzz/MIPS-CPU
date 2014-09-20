module SE(
	input signExt,
	input [15:0] imm,
	output wire [31:0] signExtOut
);

assign signExtOut[15:0] = imm[15:0];
assign signExtOut[31:16] = signExt ? {16{imm[15]}} : 16'b0000000000000000;

endmodule