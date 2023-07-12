module FetchInstruction(
  input wire[31:0] pc,
  output wire[31:0] instruction
);
  
  parameter data_file = ("data.txt");
  
  reg [31:0] memory [63:0];
  
  initial begin
    $readmemh(data_file, memory);
  end
  
  assign instruction = memory[pc[31:2]];
endmodule 