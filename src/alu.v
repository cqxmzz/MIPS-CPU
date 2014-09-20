module alu(
          aluInData1,
          aluInData2,
          aluCtr,
          aluOutData
          );

input [31:0] aluInData1;
input [31:0] aluInData2;
input [3:0] aluCtr;
output [31:0] aluOutData;

reg [31:0] aluOutData;

always @ (aluInData1, aluInData2, aluCtr)
begin
  case (aluCtr)
    4'b0000: //and
    aluOutData = aluInData1 & aluInData2;
      
    4'b0001: //or
    aluOutData = aluInData1 | aluInData2;
    
    4'b0010: //add
    aluOutData = aluInData1 + aluInData2;
    
    4'b0011: //sub
    aluOutData = aluInData1 - aluInData2;
        
    4'b0100: //nor
    aluOutData = ~(aluInData1 | aluInData2);
    
    4'b0101: //<<
    aluOutData = aluInData1 << aluInData2;
    
    4'b0110: //>>
    aluOutData = aluInData1 >> aluInData2;
    
    4'b1000: //<
    begin
       aluOutData = aluInData1 - aluInData2;
       if (aluOutData[31:31] == 1)
         aluOutData = 1;
       else
         aluOutData = 0;
    end
     
    
    4'b1010: //upper
    aluOutData = {aluInData2 , 16'b0000000000000000};
    
    default: //NULL
    aluOutData = 0;
    
  endcase
end

endmodule