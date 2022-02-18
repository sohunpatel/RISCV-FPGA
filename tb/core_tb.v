`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2022 05:06:04 PM
// Design Name: 
// Module Name: core_tb
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


module core_tb;

reg clk;
reg en;
reg [31:0] dataInst;
wire [4:0] selRS1;
wire [4:0] selRS2;
wire [4:0] selD;
wire [31:0] dataIMM;
wire regDwe;
wire [6:0] aluOp;
wire [15:0] aluFunc;
wire [4:0] memOp;
wire [4:0] csrOp;
wire [11:0] csrAddr;
wire trapExit;
wire multyCyAlu;
wire int;
wire [31:0] intData;
reg intAck;

decoder uut (
    .Clk (clk),
    .En (en),
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
    .IntData (intData),
    .IntAck (intAck)
);

// generate clock and initialize inputs
initial begin
    clk = 0;
    en = 1'b0;
    dataInst = 32'h00000000;
    intAck = 1'b0;
    forever #2 clk = ~clk;
end

reg [31:0] i;

// test decoding
initial begin
    en = 'b1;
    for (i = 0; $unsigned(i) < 32'hFFFFFFFF; i = i + 1) begin
        dataInst = $unsigned(i);
        #4;
    end
end

endmodule
