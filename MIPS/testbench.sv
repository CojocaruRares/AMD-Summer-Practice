// Code your testbench here
// or browse Examples
module CPU;
  
  reg[31:0] pc;
  wire[31:0] instruction;
  
  reg [31:0]a;
  reg [31:0]b;
  wire [31:0]c;
  wire [3:0]ctrl;
  wire zero = 0;
  reg [5:0] opcode;
  wire jmp;
  wire branch, memRead, memtoReg, memWrite, aluSrc, regWrite, regDst; 
    
  reg[5:0] func;
  wire [1:0] aluop;
 
  Control control(.opcode(opcode), .RegDst(regDst), .Jump(jmp), .Branch(branch),
                  .MemRead(memRead), .MemtoReg(memtoReg), .ALUOp(aluop), .MemWrite(memWrite),
                  .ALUSrc(aluSrc), .RegWrite(regWrite));
  
  FetchInstruction fetch(.pc(pc), .instruction(instruction));
  
  ALU_Control ALUcontrol(.func(func), .aluop(aluop), .aluCtrl(ctrl));
  
  ALU testALU (.srcA(a), .srcB(b), .ALUCtrl(ctrl), .ALUResult(c), .Zero(zero));
 
  
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    pc = 4; 
    #5; 
    a = 10;
    b = 5;
    func = 6'b100000;
    opcode = 6'b0;
    #10;
    func = 6'b100010;
    #15;
    func = 6'b100100;
    #20;
    func = 6'b100101;
    #25;
    func = 6'b000000;
    #30;
    func = 6'b000010;
    #35;
    func = 6'b101010;
    #40;
    opcode = 6'b100011;
    #200;
    $finish;
  end

  always @(instruction) begin
    $display("Instruction: %h", instruction);
  end
  
endmodule