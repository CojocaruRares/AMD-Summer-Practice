module ALU (
  input ALUSrc,
  input  [31:0] srcA,
  input  [31:0] srcB,
  input [31:0] imm,
  input [3:0] ALUCtrl,
  output reg [31:0] ALUResult,
  output reg Zero );
  
  wire [31:0] dataImm;
  assign dataImm = (ALUSrc == 0) ? srcB : imm;
  
  always @(*) begin
    Zero = 0;
    case(ALUCtrl)
      4'b0000: ALUResult <= srcA + dataImm; //add
      4'b0001: ALUResult <= srcA - dataImm; //sub
      4'b0010: ALUResult <= srcA & srcB; //and
      4'b0011: ALUResult <= srcA | srcB; //or
      4'b0100: ALUResult <= srcA << srcB; //sll
      4'b0101: ALUResult <= srcA >> srcB; //srl
      4'b0110: ALUResult <= (srcA < srcB) ? 1 : 0; //slt
      4'b0111: begin //beq
        if( srcA == srcB )
          Zero <= 1;
        else 
          Zero <= 0;
      end
      4'b1000: begin //bne
        if( srcA != srcB )
          Zero <= 1;
        else
          Zero <= 0;
      end
      default: ALUResult <= 0;
    endcase
  end
endmodule
          
      
      
    
  