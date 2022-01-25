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
    
    reg [31:0] PC;
    reg [31:0] nextPC;
    reg [1:0] nextPCop;
    
    pc pc_unit (
        .clk (Clk),
        .nextPC (nextPC),
        .nextPCop (nextPCop),
        .intVec (Int),
        .PC (PC)
    );

endmodule
