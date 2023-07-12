// Code your testbench here
// or browse Examples
module MIPS_TB;
  
  reg clk, reset;
  wire [31:0] dataBus;
  wire[31:0] addressBus;
  wire MemRWPin;
  reg [31:0] MemData;
  
  MIPS cpu( 
    .dataBus(dataBus),
    .clk(clk), 
    .reset(reset),
    .MemRWPin(MemRWPin), 
    .addressBus(addressBus)
    );
  
  assign dataBus = MemRWPin ? 32'bz : MemData;
  
 initial begin 
   reset <= 1;
   #20;
   reset <= 0;
   #200;
 end
  
  always begin 
    clk <= 1;
    #5;
    clk <= 0;
    #5;
  end
     
initial begin 
  $dumpfile("dump.vcd");
  $dumpvars;
  
  #1;
  reset <= 0;
 
   #400;
  
  $finish;
end

endmodule