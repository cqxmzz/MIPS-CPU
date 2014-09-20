module aluCtr(
    opcode,
    funct,
    aluCtrOut
    );
	  input [5:0] opcode;
    input [5:0] funct;
    output reg [3:0] aluCtrOut;
    
    
  	 
	 always @(opcode or funct)
	 begin
		case(opcode)
			6'b001000://add
				aluCtrOut=4'b0010;
				
			6'b001100://and
				aluCtrOut=4'b0000;
			
			6'b000010://j
				aluCtrOut=4'b1111;
				
			6'b000011://j
				aluCtrOut=4'b1111;
			
			6'b000100://equ
				aluCtrOut=4'b1111;
				
			6'b000101://notequ
				aluCtrOut=4'b1111;
			
			6'b001111://upper
				aluCtrOut=4'b1010;
			
			6'b100011://add
				aluCtrOut=4'b0010;
			
			6'b001101://or
				aluCtrOut=4'b0001;
			
			6'b001010://<
				aluCtrOut=4'b1000;
			
			6'b101011://add
				aluCtrOut=4'b0010;
				
			6'b000000://see funct
			begin
				case(funct)
					6'b100000://add
						aluCtrOut=4'b0010;
					
					6'b100100://and
						aluCtrOut=4'b0000;
					
					6'b001000://jr
						aluCtrOut=4'b1111;
						
					6'b100111://nor
						aluCtrOut=4'b0100;
					
					6'b100101://or
						aluCtrOut=4'b0001;
				
					6'b101010://<
						aluCtrOut=4'b1000;
						
					6'b000000://<<
						aluCtrOut=4'b0101;
					
					6'b000010://>>
						aluCtrOut=4'b0110;
						
					6'b100010://sub
						aluCtrOut=4'b0011;
						
					default:
					   aluCtrOut=4'b1111;
				endcase
				
				
			end
			default:
					   aluCtrOut=4'b1111;
		endcase
	 end


endmodule

