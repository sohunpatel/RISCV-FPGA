`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Sohun Patel
// Engineer: Sohun Patel
// 
// Create Date: 01/18/2022 09:09:51 PM
// Design Name: Memory Controller
// Module Name: mem_controller
// Project Name: RISC V Processor
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
    input Clk,
    input Reset,
    output Ready,
    input Execute,
    input DataWe,
    input [31:0] Address,
    input [31:0] InData,
    input [1:0] DataByteEn,
    input SignExtend,
    output [31:0] OutData,
    output DataReady,
    input MEM_Ready,
    output MEM_Cmd,
    output MEM_We,
    output [1:0] MEM_ByteEnable,
    output [31:0] MEM_Addr,
    output [31:0] MEM_InData,
    input [31:0] MEM_OutData,
    input MEM_DataReady
);
    
    reg we = 1'b0;
    reg [31:0] addr = 32'h00000000;
    reg [31:0] indata = 32'h00000000;
    reg [31:0] outdata = 32'h00000000;
    
    reg [1:0] byteEnable = 2'b11;
    reg cmd = 1'b0;
    reg state = 2'b00;
    
    reg ready = 1'b0;
    reg dataReady;
        
    always @ (posedge Clk) begin
        if (Reset == 1'b1) 
        begin
            we <= 1'b0;
            cmd <= 1'b0;
            state <= 1'b0;
            dataReady <= 1'b0;
        end
        else if (state == 1'b0 && Execute == 1'b1 && MEM_Ready == 1'b1) 
        begin
            we <= DataWe;
            addr <= Address;
            indata <= InData;
            byteEnable <= DataByteEn;
            cmd = 1'b1;
            dataReady <= 1'b0;
            outdata <= 32'hABCDEFEE;
            if (DataWe == 1'b1)
                state <= 2'b01; // read
            else
                state <= 2'b10; // write
        end
        else if (state ==2'b01)
        begin
            cmd <= 1'b0;
            dataReady <= 1'b1;
            outdata <= MEM_InData;
            state <= 2'b10;
        end
        else if (state == 2'b10) 
        begin
            cmd <= 0;
            state <= 0;
            dataReady <= 0;
        end
    end
    
    assign OutData = outdata;
    assign Ready = (MEM_Ready & !Execute);
    assign DataReady = dataReady;
    
    assign MEM_Cmd = cmd;
    assign MEM_ByteEnable = byteEnable;
    assign MEM_Data = indata;
    assign MEM_Addr = addr;
    assign MEM_We = we;
endmodule
