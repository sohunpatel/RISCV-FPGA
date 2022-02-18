`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2022 01:09:34 AM
// Design Name: 
// Module Name: registers
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


module registers(
    input Clk,
    input En,
    input [31:0] DataD,
    input [4:0] SelRS1,
    input [4:0] SelRS2,
    input [4:0] SelD,
    input We,
    output [31:0] DataA,
    output [31:0] DataB
    );
    
    reg [31:0] regsA [31:0];
    reg [31:0] regsB [31:0];
    reg [31:0] dataA;
    reg [31:0] dataB;
    
    always @ (posedge Clk & En) begin
        dataA <= regsA[SelRS1];
        dataB <= regsB[SelRS2];
        if (We == 1'b1) begin
            regsA[SelD] <= DataD;
            regsB[SelD] <= DataD;
        end
    end
    
    assign DataA = (SelRS1 == 5'b00000) ? 32'h00000000 : dataA;
    assign DataB = (SelRS2 == 5'b00000) ? 32'h00000000 : dataB;
    
endmodule
