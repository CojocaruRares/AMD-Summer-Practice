module ALU_Control(
  input wire [5:0] func,
  input wire [1:0] aluop,
  output reg [3:0] aluCtrl );
  
  parameter ADD = 6'b100000;
  parameter SUB = 6'b100010;
  parameter AND = 6'b100100;
  parameter OR = 6'b100101;
  parameter SLL = 6'b000000;
  parameter SRL = 6'b000010;
  parameter SLT = 6'b101010;
  
  reg [3:0] R_out;

  always @(func)
    case(func)
      ADD: R_out <= 4'b0000;
      SUB: R_out <= 4'b0001;
      AND: R_out <= 4'b0010;
      OR: R_out <= 4'b0011;
      SLL: R_out <= 4'b0100;
      SRL: R_out <= 4'b0101;
      SLT: R_out <= 4'b0110;
    endcase
  
  
  always @(*)
     case(aluop)
      2'b00: aluCtrl <= R_out; 
      2'b01: aluCtrl <= 4'b0000; //sw, lw
      2'b10: aluCtrl <= 4'b0111; 
      2'b11: aluCtrl <= 4'b1000;
    endcase
endmodule
  