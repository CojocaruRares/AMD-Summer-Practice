// Code your testbench here
// or browse Examples
module PIPO_Testbench;

  reg clock;
  reg reset;
  reg [3:0] data_in;
  wire [3:0] data_out;

  PIPO test (
    .clock(clock),
    .reset(reset),
    .data_in(data_in),
    .data_out(data_out)
  );

  initial reset= 1'b1;
  initial clock= 1'b0;
  initial data_in = 4'b0001;
  initial forever #5 clock = ~clock;
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #10 reset =1'b0;
    #10 reset =1'b1;
    #10 reset = 1'b0; data_in = 4'b1011;
    #40 reset =1'b1;
    #100;
    $finish(1);
  end
  
  
endmodule