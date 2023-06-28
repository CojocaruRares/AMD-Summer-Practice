// Code your design here
module PIPO (
  input clock,
  input reset,
  input [3:0]data_in,
  output [3:0]data_out);
  
  reg [3:0] data_register;
  
  always @( posedge clock )
   begin
    if(reset)
      data_register <= 4'b0000;
  else
    data_register <= data_in;
  end
  
  assign data_out = data_register;
endmodule
  