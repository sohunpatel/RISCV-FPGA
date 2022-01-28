`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/24/2022 08:32:16 PM
// Design Name: 
// Module Name: core
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module core(
    input Clk,
    input Reset,
    input Halt,
    input [31:0] IntData,
    input Int,
    output IntAck,
    input MEM_Ready,
    output MEM_Cmd,
    output MEM_We,
    output [1:0] MEM_ByteEnable,
    output [31:0] MEM_Addr,
    output [31:0] MEM_DataOut,
    input [31:0] MEM_DataIn,
    input MEM_DataReady,
    output Halted,
    output [63:0] Dbg
);
    
    wire [31:0] PC;
    reg [31:0] nextPC;
    reg [1:0] nextPCop;
    
    pc pc_unit (
        .clk (Clk),
        .nextPC (nextPC),
        .nextPCop (nextPCop),
        .intVec (Int),
        .PC (PC)
    );
    
    wire ready;
    reg execute;
    reg dataWe;
    reg [31:0] address;
    reg [31:0] inData;
    reg [1:0] dateByteEn;
    reg signExtend;
    wire [31:0] outData;
    wire dataReady;
    reg MEM_ready;
    wire MEM_cmd;
    wire MEM_we;
    wire [1:0] MEM_byteEnable;
    wire [31:0] MEM_addr;
    wire [31:0] MEM_inData;
    reg [31:0] MEM_outData;
    reg MEM_dataReady;
    
    mem_controller mem_controller_unit (
        .Clk (Clk),
        .Reset (Reset),
        .Ready (ready),
        .Execute (execute),
        .DataWe (dataWe),
        .Address (address),
        .InData (inData),
        .DataByteEn (dataByteEn),
        .SignExtend (signExtend),
        .OutData (outData),
        .DataReady (dataReady),
        .MEM_Ready (MEM_ready),
        .MEM_Cmd (MEM_cmd),
        .MEM_We (MEM_we),
        .MEM_ByteEnable (MEM_byteEnable),
        .MEM_Addr (MEM_addr),
        .MEM_InData (MEM_inData),
        .MEM_OutData (MEM_outData),
        .MEM_DataReady (MEM_dataReady)
    );
    
    reg en;
    reg [31:0] dataA;
    reg [31:0] dataB;
    reg dataDWe;
    reg [4:0] aluOp;
    reg [15:0] aluFunc;
    reg [31:0] epc;
    reg [31:0] dataIMM;
    reg clear;
    wire [31:0] dataResult;
    wire [31:0] branchTarget;
    wire dataWriteReg;
    wire [31:0] lastPC;
    wire shouldBranch;
    wire Wait;
    
     alu alu_unit (
         .Clk (Clk),
         .En (en),
         .DataA (dataA),
         .DataB (dataB),
         .DataDWe (dataDWe),
         .AluOp (aluOp),
         .AluFunc (aluFunc),
         .PC (PC),
         .Epc (epc),
         .DataIMM (dataIMM),
         .Clear (clear),
         .DataResult (dataResult),
         .BranchTarget (branchTarget),
         .DataWriteReg (dataWriteReg),
         .LastPC (lastPC),
         .ShouldBranch (shouldBranch),
         .Wait (Wait)
     );

endmodule
