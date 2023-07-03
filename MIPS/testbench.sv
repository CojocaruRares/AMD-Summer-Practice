// Code your testbench here
// or browse Examples
module CPU;
  
  reg[31:0] pc;
  wire[31:0] instruction;
  
  reg a, b, c;
  wire sum, out;
  
  initial begin
    a=1;
    b=1;
    c = 1;
  end
  
  FetchInstruction fetch(.pc(pc), .instruction(instruction));
  //Full_Add add(.a(a), .b(b), .c_in(c), .sum(sum),.c_out(out));
  Half_Add half_add(.a(a), .b(b), .sum(sum), .c_out(out));
  
  
  initial begin
     $dumpfile("dump.vcd");
    $dumpvars;
    pc = 4; 
    #5; 
    a=0;
    #10; 
    $finish;
  end

  always @(instruction) begin
    $display("Instruction: %h", instruction);
  end
  
endmodule