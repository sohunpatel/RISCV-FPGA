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
reg reset;
reg halt;
reg [31:0] intData;
reg int;
wire intAck;
reg MEM_ready;
wire MEM_Cmd;
wire MEM_we;
wire [1:0] MEM_byteEnable;
wire [31:0] MEM_addr;
wire [31:0] MEM_dataOut;
reg [31:0] MEM_dataIn;
reg MEM_dataReady;
wire halted;
wire [63:0] dbg;

core core_uut (
    .Clk (clk),
    .Reset (reset),
    .Halt (halt),
    .IntData (intData),
    .Int (int),
    .IntAck (intAck),
    .MEM_Ready (MEM_ready),
    .MEM_Cmd (MEM_cmd),
    .MEM_We (MEM_we),
    .MEM_ByteEnable (MEM_byteEnable),
    .MEM_Addr (MEM_addr),
    .MEM_DataOut (MEM_dataOut),
    .MEM_DataIn (MEM_dataIn),
    .MEM_DataReady (MEM_dataReady),
    .Halted (halted),
    .Dbg (dbg)
);

// generate clock
initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

endmodule
