`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/29/2022 04:26:06 PM
// Design Name:
// Module Name: csr
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

module csr(
    input Clk,
    input En,
    input [31:0] DataIn,
    output [31:0] DataOut,
    input [4:0] CsrOp,
    input [11:0] CsrAddr,
    input Int,
    output [31:0] IntData,
    input InstRetTick,
    input [31:0] IntCause,
    input [31:0] IntPC,
    input [31:0] IntMtval,
    input IntEntry,
    input IntExit,
    output [31:0] CsrStatus,
    output [31:0] CsrCause,
    output [31:0] CsrIe,
    output [31:0] CsrTvec,
    output [31:0] CsrEpc
    );

    reg [63:0] csrCycles;
    reg [63:0] csrInstret;

    reg [31:0] csrMStatus;
    reg [31:0] csrMIe;
    reg [31:0] csrMTvec;
    reg [31:0] csrMScratch;
    reg [31:0] csrMEpc;
    reg [31:0] csrMCause;
    reg [31:0] csrMTval;
    reg [31:0] csrMIp;

    reg [31:0] csrVexRiscIRQMask;
    reg [31:0] csrVexRiscIRQPending;

    reg [31:0] currCsrValue;
    reg [31:0] nextCsrValue;

    reg [31:0] test0Csr = 32'hFEFBBEF0;
    reg [31:0] test1Csr = 32'hFEFBBEF1;

    reg [31:0] csrOp;
    reg [1:0] opState;
    localparam STEP_READ_OR_IDLE = 1'b00;
    localparam STEP_MODIFY = 1'b01;
    localparam STEP_WRITE = 1'b10;

    localparam CSR_ADDR_PRIVILEGE_BIT_START  = 32'h00000009;
    localparam CSR_ADDR_PRIVILEGE_BIT_END    = 32'h00000008;
    localparam CSR_ADDR_PRIVILEGE_USER       = 2'b00;
    localparam CSR_ADDR_PRIVILEGE_SUPERVISOR = 2'b01;
    localparam CSR_ADDR_PRIVILEGE_RESERVED   = 2'b10;
    localparam CSR_ADDR_PRIVILEGE_MACHINE    = 2'b11;

    localparam CSR_ADDR_ACCESS_BIT_START = 32'h0000000B;
    localparam CSR_ADDR_ACCESS_BIT_END   = 32'h0000000A;
    localparam CSR_ADDR_ACCESS_READONLY  = 2'b11;

    localparam CSR_OP_BITS_READ = 32'h00000000;
    localparam CSR_OP_BITS_WRITTEN = 32'h00000001;
    localparam CSR_OP_BITS_OPA = 32'h00000002;
    localparam CSR_OP_BITS_OPB = 32'h00000003;
    localparam CSR_OP_BITS_IMM = 32'h00000004;

    localparam CSR_MAINOP_WR = 2'b01;
    localparam CSR_MAINOP_SET = 2'b10;
    localparam CSR_MAINOP_CLEAR = 2'b11;

    localparam CSR_OP_WR = 5'b00100;
    localparam CSR_OP_W  = 5'b00101;
    localparam CSR_OP_R  = 5'b00110;

    localparam CSR_OP_SET_WR = 5'b01000;
    localparam CSR_OP_SET_W  = 5'b01001;
    localparam CSR_OP_SET_R  = 5'b01010;

    localparam CSR_OP_CLEAR_WR = 5'b01100;
    localparam CSR_OP_CLEAR_W  = 5'b01101;
    localparam CSR_OP_CLEAR_R  = 5'b01110;

    localparam CSR_OP_IMM_WR = 5'b10100;
    localparam CSR_OP_IMM_W  = 5'b10101;
    localparam CSR_OP_IMM_R  = 5'b10110;

    localparam CSR_OP_IMM_SET_WR = 5'b11000;
    localparam CSR_OP_IMM_SET_W  = 5'b11001;
    localparam CSR_OP_IMM_SET_R  = 5'b11010;

    localparam CSR_OP_IMM_CLEAR_WR = 5'b11100;
    localparam CSR_OP_IMM_CLEAR_W  = 5'b11101;
    localparam CSR_OP_IMM_CLEAR_R  = 5'b11110;

    localparam CSR_ADDR_USTATUS = 12'h000;
    localparam CSR_ADDR_UIE = 12'h004;
    localparam CSR_ADDR_UTVEC = 12'h005;

    localparam CSR_ADDR_USCRATCH = 12'h040;
    localparam CSR_ADDR_UEPC = 12'h041;
    localparam CSR_ADDR_UCAUSE = 12'h042;
    localparam CSR_ADDR_UTVAL = 12'h043;
    localparam CSR_ADDR_UIP = 12'h044;

    localparam CSR_ADDR_CYCLE = 12'hC00;
    localparam CSR_ADDR_TIME = 12'hC01;
    localparam CSR_ADDR_INSTRET = 12'hC02;

    localparam CSR_ADDR_CYCLEH = 12'hC80;
    localparam CSR_ADDR_TIMEH = 12'hC81;
    localparam CSR_ADDR_INSTRETH = 12'hC82;
    localparam CSR_ADDR_TEST_400 = 12'h400;
    localparam CSR_ADDR_TEST_401 = 12'h401;

    localparam CSR_ADDR_MSTATUS = 12'h300;
    localparam CSR_ADDR_MISA = 12'h301;
    localparam CSR_ADDR_MEDELEG = 12'h302;
    localparam CSR_ADDR_MIDELEG = 12'h303;
    localparam CSR_ADDR_MIE = 12'h304;
    localparam CSR_ADDR_MTVEC = 12'h305;
    localparam CSR_ADDR_MCOUNTEREN = 12'h306;

    localparam CSR_ADDR_MSCRATCH = 12'h340;
    localparam CSR_ADDR_MEPC = 12'h341;
    localparam CSR_ADDR_MCAUSE = 12'h342;
    localparam CSR_ADDR_MTVAL = 12'h343;
    localparam CSR_ADDR_MIP = 12'h344;

    localparam CSR_ADDR_MCYCLE = 12'hB00;
    localparam CSR_ADDR_MINSTRET = 12'hB02;

    localparam CSR_ADDR_MCYCLEH = 12'hB80;
    localparam CSR_ADDR_MINSTRETH = 12'hB82;

    localparam CSR_ADDR_MVENDORID = 12'hF11;
    localparam CSR_ADDR_MARCHID = 12'hF12;
    localparam CSR_ADDR_MIMPID = 12'hF13;
    localparam CSR_ADDR_MHARDID = 12'hF14;

    reg raiseInt;

    always @ (posedge Clk) begin
        csrCycles <= $unsigned(csrCycles + 1);
        if (InstRetTick == 1'b1) begin 
            csrInstret <= $unsigned(csrInstret + 1);
        end
        if (IntEntry == 1'b1) begin
            csrMStatus[7] <= csrMStatus[3];
            csrMStatus[3] <= 1'b0;
            csrMStatus[12:11] <= 2'b11;
            csrMCause <= IntCause;
            csrMEpc <= IntPC;
            csrMTval <= IntMtval;
        end else if (IntExit == 1'b1) begin
            csrMStatus[3] <= csrMStatus[7];
            csrMStatus <= 1'b1;
            csrMStatus[12:11] <= 2'b00;
        end else if (En == 1'b1 && opState == STEP_READ_OR_IDLE) begin
            csrOp <= CsrOp;
            case (CsrAddr)
                CSR_ADDR_MVENDORID : currCsrValue <= 32'h00000000;
                CSR_ADDR_MARCHID : currCsrValue <= 32'h00000000;
                CSR_ADDR_MIMPID : currCsrValue <= 32'h52505531;
                CSR_ADDR_MHARDID : currCsrValue <= 32'h00000000;
                CSR_ADDR_MISA : currCsrValue <= 32'h40001100;
                CSR_ADDR_MSTATUS : currCsrValue <= csrMStatus;
                CSR_ADDR_MTVEC : currCsrValue <= csrMTvec;
                CSR_ADDR_MIE : currCsrValue <= csrMIe;
                CSR_ADDR_MIP : currCsrValue <= csrMIp;
                CSR_ADDR_MCAUSE : currCsrValue <= csrMCause;
                CSR_ADDR_MEPC : currCsrValue <= csrMEpc;
                CSR_ADDR_MTVAL : currCsrValue <= csrMTval;
                CSR_ADDR_MSCRATCH : currCsrValue <= csrMScratch;
                CSR_ADDR_CYCLE : currCsrValue <= csrCycles[31:0];
                CSR_ADDR_CYCLEH : currCsrValue <= csrCycles[63:32];
                CSR_ADDR_INSTRET : currCsrValue <= csrInstret [31:0];
                CSR_ADDR_INSTRETH : currCsrValue <= csrInstret [63:0];
                CSR_ADDR_MCYCLE : currCsrValue <= csrCycles[31:0];
                CSR_ADDR_MCYCLEH : currCsrValue <= csrCycles[63:0];
                CSR_ADDR_MINSTRET : currCsrValue <= csrInstret[31:0];
                CSR_ADDR_MINSTRETH : currCsrValue <= csrInstret[63:0];
                default: ;
            endcase
            opState <= STEP_MODIFY;
        end else if (opState == STEP_MODIFY) begin
            case (csrOp[3:2])
                CSR_MAINOP_WR : nextCsrValue <= DataIn;
                CSR_MAINOP_SET : nextCsrValue <= currCsrValue | DataIn;
                CSR_MAINOP_CLEAR : nextCsrValue <= currCsrValue & (!DataIn);
                default: ;
            endcase
            if (csrOp[CSR_OP_BITS_WRITTEN] == 1'b1) begin
                opState <= STEP_WRITE;
            end else begin
                opState <= STEP_READ_OR_IDLE;
            end
        end else if (opState == STEP_WRITE) begin
            opState <= STEP_READ_OR_IDLE;
            case (CsrAddr)
                CSR_ADDR_MSTATUS : csrMStatus <= nextCsrValue;
                CSR_ADDR_MTVEC : csrMTvec <= nextCsrValue;
                CSR_ADDR_MIE : csrMIe <= nextCsrValue;
                CSR_ADDR_MIP : csrMEpc <= nextCsrValue;
                CSR_ADDR_MEPC : csrMEpc <= nextCsrValue;
                CSR_ADDR_MSCRATCH : csrMScratch <= nextCsrValue;
                default: ;
            endcase
        end
    end

endmodule
