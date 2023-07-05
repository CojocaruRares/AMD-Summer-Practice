module DataMemory(
  input clk,
  input writeSig,
  input [31:0] pc, data,
  output [31:0] rdata );
  
  reg [31:0] RAM [63:0];
  assign rdata = RAM[pc[31:2]];
  
  always @(posedge clk) begin
    if(writeSig)
      RAM[pc[31:2]] <= data;
  end
endmodule
    