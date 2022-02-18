`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2022 03:41:24 PM
// Design Name: 
// Module Name: lint
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


module lint(
    input Clk,
    input Reset,
    input [31:0] NextPC,
    input [31:0] PC,
    input [3:0] EnMask,
    input Int0,
    input [31:0] IntData0,
    output IntAck0,
    input Int1,
    input [31:0] IntData1,
    output IntAck1,
    input Int2,
    input [31:0] IntData2,
    output IntAck2,
    input Int3,
    input [31:0] IntData3,
    output IntAck3,
    output Int,
    output [31:0] IntData,
    output [31:0] IntEpc
    );

    reg actualInt;
    reg [31:0] actualIntData;
    reg [31:0] actualIntEpc;

    reg int0Ack = 1'b0;
    reg int1Ack = 1'b0;
    reg int2Ack = 1'b0;
    reg int3Ack = 1'b0;

    reg [1:0] resetCounter;

    always @ (posedge Clk) begin
        if (Reset == 1'b1) begin
            resetCounter <= 2'b01;
            int0Ack <= 1'b0;
            int1Ack <= 1'b0;
            int2Ack <= 1'b0;
            int3Ack <= 1'b0;
        end else if (resetCounter == 2'b01) begin
            resetCounter <= 2'b10;
        end else if (resetCounter == 2'b10) begin
            resetCounter <= 2'b11;
        end else if (resetCounter == 2'b11) begin
            resetCounter <= 2'b00;
        end else if (resetCounter == 2'b00 && actualInt == 1'b0) begin
            if (EnMask[0] == 1'b1 && Int0 == 1'b1 && int0Ack == 1'b0) begin
                actualInt <= 1'b1;
                actualIntData <= IntData0;
                int0Ack <= 1'b1;
            end else if (EnMask[1] == 1'b1 && Int1 == 1'b1 && int1Ack == 1'b0) begin
                actualInt <= 1'b1;
                actualIntData <= IntData1;
                int1Ack <= 1'b1;
            end else if (EnMask[2] == 1'b1 && Int2 == 1'b1 && int2Ack == 1'b0) begin
                actualInt <= 1'b1;
                actualIntData <= IntData2;
                int2Ack <= 1'b1;
            end else if (EnMask[3] == 1'b1 && Int3 == 1'b1 && int3Ack == 1'b0) begin
                actualInt <= 1'b1;
                actualIntData <= IntData3;
                int3Ack <= 1'b1;
            end
        end
    end

    assign Int = actualInt;
    assign IntData = actualIntData;
    assign IntEpc = actualIntEpc;

    assign IntAck0 = int0Ack;
    assign IntAck1 = int1Ack;
    assign IntAck2 = int2Ack;
    assign IntAck3 = int3Ack;

endmodule
