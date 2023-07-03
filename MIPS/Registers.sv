module Registers(
    input wire[4:0] readReg1,
    input wire[4:0] readReg2,
    input wire[4:0] writeReg,
    input wire[31:0] writeData,
    input wire write, 
    output reg[31:0] reg1Data,
    output reg[31:0] reg2Data );
    
    
   	reg [31:0] regMem [31:0];
    
    always @(readReg1 or readReg2) begin 
      reg1Data = regMem[readReg1];
      reg2Data = regMem[readReg2];
    end
    
    always @(posedge write) begin
         regMem[writeReg] = writeData;
    end
  endmodule