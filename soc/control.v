`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2022 10:09:04 PM
// Design Name: 
// Module Name: control
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

module control(
    input Clk,
    input Reset,
    input Halt,
    input [6:0] AluOp,
    input IntEnabled,
    input Int,
    input IntAck,
    input [31:0] IntMemData,
    output [31:0] IData,
    output SetIData,
    output SetIPC,
    output SetIrPC,
    output InstTick,
    input Misalignment,
    input Ready,
    output Execute,
    input DataReady,
    input AluWait,
    input AluMultiCy,
    output [6:0] State
    );

    localparam FETCH = 7'b0000001;
    localparam DECODE = 7'b0000010;
    localparam EXECUTE = 7'b0001000;
    localparam MEMORY = 7'b0010000;
    localparam WRITEBACK = 7'b0100000;
    localparam MULTI_STALL = 7'b1000000;
    localparam STALL = 7'b1001000;

    // Opcodes
    localparam LOAD = 5'b00000;
    localparam STORE = 5'b01000;
    localparam MADD = 5'b10000;
    localparam BRANCH = 5'b11000;
    localparam JALR = 5'b11001;
    localparam JAL = 5'b11011;
    localparam SYSTEM = 5'b11100;
    localparam OP = 5'b01100;
    localparam OPIMM = 5'b00100;
    localparam MISCMEM = 5'b00011;
    localparam AUIPC = 5'b00101;
    localparam LUI = 5'b01101;

    reg [6:0] state = FETCH;

    reg memReady;
    reg memExecute;
    reg memDataReady;

    reg [31:0] memCycle;

    reg [6:0] nextState = FETCH;

    reg [2:0] interruptState;
    reg interruptAck;
    reg interruptWasInactive;
    reg setIData;
    reg setIPC;
    reg instTick;
    reg hasWaited;

    reg [31:0] iData;

    reg [31:0] checkAlignInt;

    always @ (posedge Clk) begin
        if (Halt == 1'b0) begin
            if (Reset == 1'b1) begin
                state <= FETCH;
                nextState <= 7'b0000001;
                memCycle <= 32'h00000000;
                memExecute <= 1'b0;
                interruptWasInactive <= 1'b1;
                interruptAck <= 1'b0;
                interruptState <= 3'b000;
                setIPC <= 1'b0;
                iData <= 32'h00000000;
                setIData <= 1'b0;
                instTick <= 1'b0;
            end else begin
                case (state)
                    FETCH : begin
                        if (checkAlignInt != 1'b0) begin
                            if (IntEnabled == 1'b1 && interruptWasInactive == 1'b1 && Int == 1'b1) begin
                                interruptAck <= 1'b1;
                                interruptWasInactive <= 0;
                                interruptState <= 3'b000;
                                nextState <= FETCH;
                                state <= MULTI_STALL;
                                checkAlignInt <= 1'b0;
                            end else begin
                                checkAlignInt <= $signed(checkAlignInt) - 1;
                            end
                        end else begin
                            if (Int == 1'b0) begin
                                interruptWasInactive <= 1'b1;
                            end
                            instTick <= 1'b0;
                            if (memCycle == 32'h00000000 && memReady == 1'b1) begin
                                memExecute <= 1'b1;
                                memCycle <= 1;
                            end else if (memCycle == 32'h00000001) begin
                                memExecute <= 1'b0;
                                memCycle <= 32'h00000002;
                            end else if (memCycle == 32'h00000002) begin
                                memExecute <= 1'b0;
                                if (DataReady == 1'b1) begin
                                    memCycle <= 32'h00000000;
                                    state <= DECODE;
                                end
                            end
                        end
                    end
                    DECODE : begin
                        if (Int == 1'b0) begin
                            interruptWasInactive <= 1'b1;
                        end
                        hasWaited <= 1'b0;
                        state <= EXECUTE;
                    end
                    EXECUTE : begin
                        if (Int == 1'b0) begin
                            interruptWasInactive <= 1'b1;
                        end
                        if (AluOp[6:2] == LOAD || AluOp[6:2] == STORE) begin
                            state <= MEMORY;
                        end else begin
                            if (AluWait <= 1'b0) begin
                                if (AluMultiCy == 1'b1) begin
                                    if (hasWaited == 1'b1) begin
                                        state <= WRITEBACK;
                                    end
                                end else begin
                                    state <= WRITEBACK;
                                end
                                hasWaited <= 1'b1;
                            end
                        end
                    end
                    MEMORY : begin
                        if (Int == 1'b0) begin
                            interruptWasInactive <= 1'b1;
                        end
                        if (Misalignment == 1'b1 && checkAlignInt == 32'h00000000) begin
                            checkAlignInt <= 32'h00000006;
                        end else if ($signed(checkAlignInt) > 0) begin
                            if (IntEnabled == 1'b1 && interruptWasInactive == 1'b1 && Int == 1'b1) begin
                                interruptAck <= 1'b1;
                                interruptWasInactive <= 1'b0;
                                interruptState <= 32'b001;
                                nextState <= FETCH;
                                state <= MULTI_STALL;
                                checkAlignInt <= 32'h00000000;
                            end else begin
                                checkAlignInt <= $signed(checkAlignInt) - 1;
                            end
                        end else begin
                            if (memCycle == 32'h00000000 && memReady == 1'b1) begin
                                memExecute <= 1'b1;
                                memCycle <= 32'h00000001;
                            end else if (memCycle == 32'h00000001) begin
                                memExecute <= 1'b0;
                                if (AluOp[6:2] == STORE) begin
                                    memCycle <= 32'h00000000;
                                    state <= WRITEBACK;
                                end else if (memDataReady == 1'b1) begin
                                    memCycle <= 32'h00000000;
                                    state <= WRITEBACK;
                                end
                            end
                        end
                    end
                    WRITEBACK : begin
                        if (IntEnabled == 1'b1 && interruptWasInactive == 1'b1 && Int == 1'b1) begin
                            interruptAck <= 1'b1;
                            interruptWasInactive <= 1'b0;
                            interruptState <= 1'b0;
                            nextState <= FETCH;
                            state <= MULTI_STALL;
                        end else begin
                            if (Int == 1'b0) begin
                                interruptWasInactive <= 1'b1;
                            end
                            if (Misalignment == 1'b1 && checkAlignInt == 32'h00000000) begin
                                checkAlignInt <= 32'h00000003;
                            end
                            state <= FETCH;
                            if (Misalignment == 1'b0 && memCycle == 32'h00000000 && memReady == 1'b1) begin
                                memExecute <= 1'b1;
                                memCycle <= 32'h00000002;
                            end
                        end
                        instTick <= 1'b1;
                    end
                    MULTI_STALL : begin
                        if (Int == 1'b0) begin
                            interruptWasInactive <= 1'b1;
                        end
                        instTick <= 1'b0;
                        if (interruptState == 3'b001) begin
                            setIPC <= 1'b1;
                            interruptState <= 3'b101;
                        end else if (interruptState == 3'b101) begin
                            setIPC <= 1'b0;
                            interruptAck <= 1'b0;
                            interruptState <= 3'b111;
                        end else if (interruptState == 3'b111) begin
                            interruptState <= 3'b000;
                            state <= FETCH;
                        end
                    end
                    STALL : begin
                        state <= WRITEBACK;
                    end
                    default: state <= FETCH;
                endcase
            end
        end
    end

    assign State = state;
    assign IntAck = interruptAck;
    assign IData = iData;
    assign SetIData = setIData;
    assign SetIPC = setIPC;
    assign InstTick = instTick;
    assign Execute = memExecute;
    assign State = state;

endmodule
