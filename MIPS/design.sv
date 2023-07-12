`include "FetchInstruction.sv"
`include "Registers.sv"
`include "Controls.sv"
`include "ALU_Control.sv"
`include "ALU.sv"
`include "adder.sv"
`include "dmem.sv"

module MIPS (
  output [31:0] dataBus,
  input clk,
  input reset,
  output reg MemRWPin,
  output reg [31:0] addressBus );
  
  reg [2:0] stage = 0 ;  
    /* CPU stages  fetch IF > decode ID > execute EX > access memory MEM> writeback WB */

    parameter IF = 3'd0;
    parameter ID = 3'd1;
    parameter EX = 3'd2;
    parameter MEM = 3'd3;
    parameter WB = 3'd4;


    /* PC_regs */
    reg [31:0] pc = 0;
    wire [31:0] pc_next;
    reg [31:0] NextAdd;
  

    /* fetch stage*/
    reg [31:0] fetchPC;
    wire [31:0] fetchedInst;

    /* instruction fields */
    reg [31:0] instruction;
    wire [5:0] opcode;
    wire [4:0] rs;
    wire [4:0] rd;
    wire [4:0] rt;
    wire [15:0] addrim; //address offset / immediate 
    wire [31:0] immediate;
    wire [25:0] instidx; // jump address distination shifted to left two bits <add 00 at lsb in execute>
    wire [4:0] sa; // shift amount for shift instructions 
    wire [5:0] fn;
    wire [4:0] rgw;

    /*Control Unit */
    wire contRegDst;
    wire contJmp;
    wire contBranch;
    wire contMemRead;
    wire contMemtoReg;
    wire contALUSrc;
    wire contRegWrite;
    wire contMemWrite;
    wire [1:0] contAluop;

    /*register File */
    reg RegWrite;
    wire [31:0] rdata1;
    wire [31:0] rdata2;
    reg [31:0] rgwdata;

    /* ALU  */
    reg [1:0 ]aluOp;
    reg [31:0] data1;
    reg [31:0] data2;
    reg aluSrc;
    wire [3:0] aluCtrl;
    wire [31:0] result;
    wire zero;

    /**/
    reg [31:0] MemData;
    wire [31:0] dataMem;

    assign dataBus = MemRWPin ? MemData : 32'bz;
  	assign dataMem = MemData;

    assign opcode = instruction[31:26];
    assign rs = instruction[25:21];
    assign rt = instruction[20:16];
    assign rd = instruction[15:11];
    assign addrim = instruction[15:0];
    assign instidx = instruction[25:0];
    assign sa = instruction[10:6];
    assign fn = instruction[5:0];
    assign rgw = contRegDst ? rd : rt;
    assign immediate = addrim;
  
  adder nextAdder (.a(pc), .b(NextAdd), .y(pc_next));
  
  FetchInstruction fetch( .pc(pc), .instruction(fetchedInst));
  
  Control control (
    .opcode(opcode),
    .RegDst(contRegDst),
    .Jump(contJmp),
    .Branch(contBranch),
    .MemRead(contMemRead),
    .MemtoReg(contMemtoReg),
    .ALUOp(contAluop),
    .MemWrite(contMemWrite),
    .ALUSrc(contALUSrc),
    .RegWrite(contRegWrite) );
  
  Registers registers (
    .clk(clk),
    .readReg1(rs),
    .readReg2(rt),
    .writeReg(rgw),
    .writeData(rgwdata),
    .write(RegWrite),
    .reg1Data(rdata1),
    .reg2Data(rdata2) );
  
  ALU_Control alu_control(
    .func(fn),
    .aluop(aluOp),
    .aluCtrl(aluCtrl) );	
  
  ALU alu (
    .ALUSrc(aluSrc),
    .srcA(data1),
    .srcB(data2),
    .imm(immediate),
    .ALUCtrl(aluCtrl),
    .ALUResult(result),
    .Zero(zero) );
  
  dmem dataMemory (
    .clk(clk),
    .we(MemRWPin),
    .a(addressBus),
    .wd(rgwdata),
    .rd(dataMem));
    
  
  
  always @(posedge clk or negedge reset) begin
 
    if(reset == 1'b1)
      begin
        pc <= 32'b0;
        stage <= IF;
        NextAdd <= 32'd4; 
        MemRWPin <= 1'bz;
        MemData <= 32'b0;
        data1 <= 0;
        data2 <= 0;
      end
    else
      case(stage)
        
        IF: begin
         RegWrite <= 1'b0;
          instruction <= fetchedInst;
          stage <= ID;
          MemRWPin <= 1'bz;
          data1 <= 0;
          data2 <= 0;
        end
        
        ID: begin
          aluOp <= contAluop;
          aluSrc <= contALUSrc;
          data1 <= rdata1;
          data2 <= rdata2;
          MemRWPin <= 1'bz;
          stage <= EX; 
        end
        
        EX: begin 
          MemRWPin <= 1'bz;
          if(contJmp == 1) begin
            pc <= instidx << 2;
            stage <= IF;
          end
          else if(contBranch == 1) begin 
            if(zero == 1) begin
              NextAdd <= addrim << 2;
              pc <= pc_next;
              stage = IF;
            end
          end
          
          else if(contMemRead == 1'b1 || contMemWrite == 1'b1) 
            stage <= MEM;
          else if (contRegWrite == 1'b1) begin
            stage <= WB;
            rgwdata <= result;
          end
          
          else begin
            NextAdd <= 4'd4;
            pc <= pc_next;
            stage <= IF;
          end
        end
        
       MEM: begin
        data1 <= 0;
        data2 <= 0;

        if (contMemWrite == 1'b1) begin
          addressBus <= rdata1;
          MemData <= rdata2;
          MemRWPin <= 1'b1;
          stage <= MEM;
          NextAdd <= 4'd4;
          pc <= pc_next;
        end
        else if (contMemRead == 1'b1) begin
          addressBus <= rdata1;
          MemRWPin <= 1'b0; 
          stage <= MEM;
          NextAdd <= 4'd4;
          pc <= pc_next;
        end
        else begin
          if (contMemtoReg == 1'b1) begin
            rgwdata <= dataBus;
            stage <= WB;
          end
          else begin
            stage <= IF;
            NextAdd <= 4'd4;
            pc <= pc_next;
          end
        end
      end
        
        WB: begin 
          data1 <= 0;
          data2 <= 0;
          MemRWPin <= 1'bz;
          RegWrite <= 1'b1;
          stage <= IF;
          pc <= pc_next;
        end
        
        default : begin 
          stage <= IF;
          pc <= pc_next;
          RegWrite <= 1'b0;
        end   
      endcase   
    end
  
endmodule
  






  

	
    