`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Sohun Patel
// Engineer: Sohun Patel
// 
// Create Date: 11/26/2021 09:30:06 PM
// Design Name: 
// Module Name: pc
// Project Name: RISC V processor
// Target Devices: Nexys A7
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


module pc(
    input clk,
    input [31:0] nextPC,
    input [1:0] nextPCop,
    input intVec,
    output [31:0] PC
    );
    
    reg [31:0] current_pc;
    
    // PC unit opcodes
    localparam PC_OP_NOP = 2'b00;
    localparam PC_OP_INC = 2'b01;
    localparam PC_OP_ASSIGN = 2'b10;
    localparam PC_OP_RESET = 2'b11;
    
    always @ (posedge clk) begin
        case (nextPCop)
            PC_OP_NOP : ;
            PC_OP_INC : current_pc  <= current_pc + 4;
            PC_OP_ASSIGN : current_pc <= nextPC;
            PC_OP_RESET : current_pc <= 32'h00000000;
            default : ;
        endcase
    end
    
    assign PC = current_pc;
endmodule
