module Half_Add(
  input wire a,
  input wire b,
  output wire sum, 
  output wire c_out );
  
  assign sum = a^b;
  assign c_out = a*b;
endmodule