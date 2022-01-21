`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/18/2022 09:09:51 PM
// Design Name: 
// Module Name: mem_controller
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


    module mem_controller(
    input clk,
    input reset,
    output ready,
    input execute,
    input dataWe,
    input [31:0] address,
    input [31:0] InData,
    input [1:0] dataByteEn,
    input signExtend,
    output [31:0] OutData,
    output dataReady,
    input MEM_ready,
    output MEM_cmd,
    output MEM_we,
    output [1:0] MEM_byteEnable,
    output [31:0] MEM_addr,
    output [31:0] MEM_InData,
    input [31:0] MEM_OutData,
    input MEM_dataReady
    );
    
    reg we = 1'b0;
    reg [31:0] addr = 32'h00000000;
    reg [31:0] indata = 32'h00000000;
    reg [31:0] outdata = 32'h00000000;
    
    reg [1:0] byteEnable = 2'b11;
    reg cmd = 1'b0;
    reg state = 2'b00;
    
    reg ready = 1'b0;
    
    always @ (posedge clk) begin
        if (reset == 1'b1) 
        begin
            we <= 1'b0;
            cmd <= 1'b0;
            state <= 1'b0;
            dataReady <= 1'b0;
        end
        else if (state == 1'b0 && execute == 1'b1 && MEM_ready == 1'b1) 
        begin
            we <= dataWe;
            addr <= address;
            indata <= InData;
            byteEnable <= dataByteEn;
            cmd = 1'b1;
            dataReady <= 1'b0;
            outdata <= 32'hABCDEFEE;
            if (dataWe == 1'b1)
                state <= 2'b01; // read
            else
                state <= 2'b10; // write
        end 
        else if (state == 2'b10) 
        begin
            cmd <= 0;
            state <= 0;
            dataReady <= 0;
        end
    end
    
    assign OutData = outdata;
    assign ready = (MEM_ready & !execute);
    
    assign MEM_cmd = cmd;
    assign MEM_byteEnable = byteEnable;
    assign MEM_data = indata;
    assign MEM_addr = addr;
    assign MEM_we = we;        
endmodule
