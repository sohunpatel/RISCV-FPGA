`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2022 12:33:05 PM
// Design Name: 
// Module Name: alu
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


module alu(
    input Clk,
    input En,
    input [31:0] DataA,
    input [31:0] DataB,
    input DataDWe,
    input [4:0] AluOp,
    input [15:0] AluFunc,
    input [31:0] PC,
    input [31:0] Epc,
    input [31:0] DataIMM,
    input Clear,
    output [31:0] DataResult,
    output [31:0] BranchTarget,
    output DataWriteReg,
    output [31:0] LastPC,
    output ShouldBranch,
    output Wait
);

    reg div_exec;
    reg [1:0] div_op;
    wire [31:0] div_dataResult;
    wire div_done;
    wire div_int;

    alu_int32_div division_unit (
        .Clk (Clk),
        .Execute (div_exec),
        .Dividend (DataA),
        .Divisor (DataB),
        .Op (div_op),
        .DataResult (div_dataResult),
        .Done (div_done),
        .Int (div_int)
    );

endmodule
