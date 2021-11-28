`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2021 11:03:38 PM
// Design Name: 
// Module Name: pc_tb
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


module pc_tb;

reg clk;
reg [31:0] nextPC;
reg [1:0] nextPCop;
reg intVec;
wire [31:0] PC;

pc uut (
    .clk (clk),
    .nextPC (nextPC),
    .nextPCop (nextPCop),
    .intVec (intVec),
    .PC (PC)
);

// generate clock
initial begin
    clk = 0;
    nextPC = 32'h88888888;
    intVec = 0;
    forever #10 clk = ~clk;
end

// generate reset
initial begin
    nextPCop = 2'b11;
    # 200;
    nextPCop = 2'b01;
    # 200
    nextPCop = 2'b10;
    # 200
    nextPCop = 2'b00;
end

endmodule
