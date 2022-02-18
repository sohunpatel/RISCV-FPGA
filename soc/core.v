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
    
    reg aluEn;
    wire [31:0] dataA;
    wire [31:0] dataB;
    reg dataDWe;
    wire [4:0] aluOp;
    wire [15:0] aluFunc;
    wire [31:0] epc;
    wire [31:0] dataIMM;
    reg clear;
    wire [31:0] dataResult;
    wire [31:0] branchTarget;
    wire dataWriteReg;
    wire [31:0] lastPC;
    wire shouldBranch;
    wire Wait;
    
    alu alu_unit (
        .Clk (Clk),
        .En (aluEn),
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
    
    reg decodeEn;
    reg [31:0] dataInst;
    wire [4:0] selRS1;
    wire [4:0] selRS2;
    wire [4:0] selD;
    wire regDwe;
    wire [4:0] memOp;
    wire [4:0] csrOp;
    wire [11:0] csrAddr;
    wire trapExit;
    wire multyCyAlu;
    wire int;
    wire [31:0] intData;
    reg intAck;
    
    decoder RV32I (
        .Clk (Clk),
        .En (decodeEn),
        .DataInst (dataInst),
        .SelRS1 (selRS1),
        .SelRS2 (selRS2),
        .SelD (selD),
        .DataIMM (dataIMM),
        .RegDwe (regDwe),
        .AluOp (aluOp),
        .AluFunc (aluFunc),
        .MemOp (memOp),
        .CsrOp (csrOp),
        .CsrAddr (csrAddr),
        .TrapExit (trapExit),
        .MultycyAlu (multyCyAlu),
        .Int (int),
        .IntData (IntData),
        .IntAck (intAck) 
    );
    
    reg registerEn;
    reg [31:0] dataD;
    reg regWe;
    
    registers file (
        .Clk (Clk),
        .En (registerEn),
        .DataD (dataD),
        .SelRS1 (selRS1),
        .SelRS2 (selRS2),
        .SelD (selD),
        .We (regWe),
        .DataA (dataA),
        .DataB (dataB)
    );

    reg lintReset;
    reg [3:0] lintEnMask;
    reg int0;
    reg [31:0] intData0;
    wire [31:0] intAck0;
    reg int1;
    reg [31:0] intData1;
    wire [31:0] intAck1;
    reg int2;
    reg [31:0] intData2;
    wire [31:0] intAck2;
    reg int3;
    reg [31:0] intData3;
    wire [31:0] intAck3;

    lint lint_uint (
        .Clk (Clk),
        .Reset (lintReset),
        .NextPC (nextPC),
        .PC (PC),
        .EnMask (lintEnMask),
        .Int0 (int0),
        .IntData0 (intData0),
        .IntAck0 (intAck0),
        .Int1 (int1),
        .IntData1 (intData1),
        .IntAck1 (intAck1),
        .Int2 (int2),
        .IntData2 (intData2),
        .IntAck2 (intAck2),
        .Int3(int3),
        .IntData3 (intData3),
        .IntAck3 (intAck3),
        .Int (int),
        .IntData (intData),
        .IntEpc (epc)
    );

    reg csrEn;
    reg [31:0] csrDataIn;
    wire [31:0] csrDataOut;
    reg instRetTick;

    reg [31:0] intCause;
    reg [31:0] intPC;
    reg [31:0] intMtval;

    reg intEntry;
    reg intExit;

    wire [31:0] csrStatus;
    wire [31:0] csrCause;
    wire [31:0] csrIe;
    wire [31:0] csrTvec;
    wire [31:0] csrEpc;

    csr csr_unit (
        .Clk (clk),
        .En (csrEn),
        .DataIn (csrDataIn),
        .DataOut (csrDataOut),
        .CsrOp (csrOp),
        .CsrAddr (csrAddr),
        .Int (int),
        .IntData (intData),
        .InstRetTick (instRetTick),
        .IntCause (intCause),
        .IntPC (intPC),
        .IntMtval (intMtval),
        .IntEntry (intEntry),
        .IntExit (intExit),
        .CsrStatus (csrStatus),
        .CsrCause (csrCause),
        .CsrIe (csrIe),
        .CsrTvec (csrTvec),
        .CsrEpc (csrEpc)
    );
    
    reg intEnabled;
    reg [31:0] intMemData;
    wire [31:0] iData;
    wire setIData;
    wire setIPC;
    wire setIrPC;
    wire instTick;
    reg misalignment;
    reg controlReady;
    wire controlExecute;
    reg ctrlDataReady;
    reg aluWait;
    reg aluMultiCy;
    wire [6:0] controlState;
    
    control control_unit (
        .Clk (Clk),
        .Reset (Reset),
        .Halt (Halt),
        .AluOp (aluOp),
        .IntEnabled (intEnabled),
        .Int (Int),
        .IntAck (intAck),
        .IntMemData (intMemData),
        .IData (iData),
        .SetIData (setIData),
        .SetIrPC (setIrPC),
        .InstTick (instTick),
        .Misalignment (misalignment),
        .Ready (controlReady),
        .Execute (controlExecute),
        .DataReady (ctrlDataReady),
        .AluWait (aluWait),
        .AluMultiCy (aluMultiCy),
        .State (controlState)
    );

endmodule
