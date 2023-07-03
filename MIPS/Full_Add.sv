module Full_Add(
  input wire a,
  input wire b,
  input wire c_in,
  output wire sum,
  output wire c_out);
  
  assign {c_out, sum} = a+b+c_in;
  
endmodule