`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2022 01:49:45 PM
// Design Name: 
// Module Name: alu_int32_div
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


module alu_int32_div(
    input Clk,
    input Execute,
    input [31:0] Dividend,
    input [31:0] Divisor,
    input [1:0] Op,
    output [31:0] DataResult,
    output Done,
    output Int
    );
    
    localparam IDLE = 2'b00;
    localparam INFLIGHTU = 2'b01;
    localparam COMPLETE = 2'b10;
    
    reg done;
    reg int;
    reg [1:0] op;
    reg [31:0] result;
    reg outsign;
    reg [31:0] ur;
    
    reg [31:0] I;
    reg [31:0] N;
    reg [31:0] D;
    reg [31:0] R;
    reg [31:0] Q;
    
    reg [1:0] state;

    always @ (posedge Clk) begin
        if (state == IDLE)
        begin
            done <= 2'b0;
            if (Execute == 1'b1)
            begin
                op <= Op;
                done <= 1'b0;
                if (Divisor == 32'h0)
                begin
                    state <= COMPLETE;
                    Q <= 32'hFFFFFFFF;
                    R <= Dividend;
                    outsign <= Dividend[31];
                end
                if (Divisor == 32'h1 && Op == 2'b0)
                begin
                    state <= COMPLETE;
                    R <= 32'h0;
                    Q <= Dividend;
                    outsign <= Dividend[31];
                end
                else
                begin
                    state <= INFLIGHTU;
                    N <= Dividend;
                    D <= Divisor;
                    ur <= 32'h0;
                    Q <= 32'h0;
                    R <= 32'h0;
                    I <= 32'hFF;
                    outsign <= 1'b0;
                end
            end
        end
        else if (state == INFLIGHTU)
        begin // binary integer long division loop
            if (R[30:0] & N[I] >= D)
            begin
                R <= R[30:0] & N[I] - D;
                Q <= 32'h1;
            end
            else
            begin
                R <= R[30:0] & N[I];
            end
            if (I == 0)
            begin
                state = COMPLETE;
            end
            else
            begin
                I = I - 1;
            end
        end
        else if (state == COMPLETE)
        begin
            result <= Q;
            done <= 1'b1;
            state <= IDLE;
        end
    end
    
    assign DataResult = result;
    assign Done = done;
    assign Int = int;

endmodule
