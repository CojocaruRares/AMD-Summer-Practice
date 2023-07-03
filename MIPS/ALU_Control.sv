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
  
  always @(*)
    case(aluop)
      2'b00: aluCtrl <= 4'b0000; //add
      2'b01: aluCtrl <= 4'b0001; //sub
      default: case(func)
        ADD: aluCtrl <= 4'b0000;
        SUB: aluCtrl <= 4'b0001;
        AND: aluCtrl <= 4'b0010;
        OR: aluCtrl <= 4'b0011;
        SLL: aluCtrl <= 4'b0100;
        SRL: aluCtrl <= 4'b0101;
        SLT: aluCtrl <= 4'b0110;
      endcase
    endcase
endmodule
  