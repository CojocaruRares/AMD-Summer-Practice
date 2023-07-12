module Registers(
    input clk,
    input wire[4:0] readReg1,
    input wire[4:0] readReg2,
    input wire[4:0] writeReg,
    input wire[31:0] writeData,
    input wire write, 
    output wire [31:0] reg1Data,
    output wire [31:0] reg2Data );
    
    
   	reg [31:0] regMem [31:0];
  
  always @(posedge clk) begin
    if(write)
      regMem[writeReg] <= writeData;
    end
    	
  assign reg1Data = ( readReg1 != 0 ) ? regMem[readReg1] : 0;
  assign reg2Data = ( readReg2 != 0 ) ? regMem[readReg2] : 0;
  
  endmodule