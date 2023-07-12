
module Control(
  input wire [5:0] opcode,
  output RegDst,
  output Jump,
  output Branch,
  output MemRead,
  output MemtoReg,
  output [1:0] ALUOp,
  output MemWrite,
  output ALUSrc,
  output RegWrite ); 
  
  parameter R_TYPE = 6'b000000;
  parameter ADDI = 6'b001000;
  parameter LW = 6'b100011;
  parameter SW = 6'b101011;
  parameter BEQ = 6'b000100;
  parameter BNE = 6'b000101;
  parameter J = 6'b000010;
  
  reg [9:0] controls;
  
  assign {RegDst, RegWrite, Jump, Branch, MemRead,
          MemtoReg, MemWrite, ALUSrc, ALUOp} = controls;
  
  always @(*)
    case(opcode)
      R_TYPE: controls <= 10'b1100000000;
      ADDI: controls <= 10'b0100000101;
      LW: controls <= 10'b0100110101;
      SW: controls <= 10'b0000001101;
      BEQ: controls <= 10'b0001000010;
      BNE: controls <= 10'b0001000011;
      J: controls <= 10'b0010000000;
      default: controls <= 10'bxxxxxxxxxx;
    endcase
endmodule
     
  