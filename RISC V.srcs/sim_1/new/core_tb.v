`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2022 03:50:07 PM
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
//reg [31:0] nextPC;
//reg [1:0] nextPCop;
//reg intVec;
//wire [31:0] PC;
reg execute;
reg [31:0] dividend;
reg [31:0] divisor;
reg [1:0] op;
wire [31:0] dataResult;
wire done;
wire int;

//pc uut (
//    .clk (clk),
//    .nextPC (nextPC),
//    .nextPCop (nextPCop),
//    .intVec (intVec),
//    .PC (PC)
//);

alu_int32_div uut (
    .Clk (clk),
    .Execute (execute),
    .Dividend (dividend),
    .Divisor (divisor),
    .Op (op),
    .DataResult (dataResult),
    .Done (done),
    .Int (int)
);

// generate clock and initialize registers
initial begin
    clk = 0;
//    nextPC = 32'h88888888;
//    intVec = 0;
    execute = 1'b0;
    dividend = 32'h0;
    divisor = 32'h0;
    op = 2'b0;
    forever #10 clk = ~clk;
end

// test PC
//initial begin
//    nextPCop = 2'b11;
//    # 200;
//    nextPCop = 2'b01;
//    # 200
//    nextPCop = 2'b10;
//    # 200
//    nextPCop = 2'b00;
//end

endmodule
