`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2022 05:53:17 PM
// Design Name: 
// Module Name: decoder
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


module decoder(
    input Clk,
    input En,
    input [31:0] DataInst,
    output [4:0] SelRS1,
    output [4:0] SelRS2,
    output [4:0] SelD,
    output [31:0] DataIMM,
    output RegDwe,
    output [6:0] AluOp,
    output [15:0] AluFunc,
    output [4:0] MemOp,
    output [4:0] CsrOp,
    output [11:0] CsrAddr,
    output TrapExit,
    output MultycyAlu,
    output Int,
    output [31:0] IntData,
    input IntAck
    );
    
    reg [4:0] selD;
    reg [31:0] dataIMM;
    reg regDwe;
    reg [6:0] aluOp;
    reg [15:0] aluFunc;
    reg [4:0] memOp;
    reg [4:0] csrOp;
    reg [11:0] csrAddr;
    reg trapExit;
    reg int;
    reg [31:0] intData;
    reg multicy;

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

    localparam F3_SYSTEM_ECALL = 3'b000;
    localparam IMM_I_SYSTEM_ECALL = 12'b000000000000;
    localparam F3_SYSTEM_EBREAK = 3'b000;
    localparam IMM_I_SYSTEM_EBREAK = 12'b000000000001;
    localparam F3_SYSTEM_CSRRW = 3'b001;
    localparam F3_SYSTEM_CSRRS = 3'b010;
    localparam F3_SYSTEM_CSRRC = 3'b011;
    localparam F3_SYSTEM_CSRRWI = 3'b101;
    localparam F3_SYSTEM_CSRRSI = 3'b110;
    localparam F3_SYSTEM_CSRRCI = 3'b111;


    localparam F3_PRIVOP = 3'b000;

    localparam F7_PRIVOP_URET       = 7'b0000000;
    localparam F7_PRIVOP_SRET_WFI   = 7'b0001000;
    localparam F7_PRIVOP_MRET       = 7'b0011000;
    localparam F7_PRIVOP_SFENCE_VMA = 7'b0001001;
    
    localparam RD_PRIVOP = 5'b00000;

    localparam R2_PRIV_RET = 5'b00010;
    localparam R2_PRIV_WFI = 5'b00101;

    always @ (posedge Clk)
    begin
        if (En == 1'b1)
        begin
            selD <= DataInst[11:7];
            aluOp <= DataInst[6:0];
            aluFunc <= 6'b000000 & DataInst[31:25] & DataInst[14:2];
            case (DataInst[6:2])
                LOAD  : begin
                            multicy <= 1'b0;
                            trapExit <= 1'b0;
                            csrOp <= 5'b00000;
                            int <= 1'b0;
                            regDwe <= 1'b1;
                            memOp <= 5'b00000;
                            dataIMM <= { DataInst[31:12], 12'b000000000000 };
                        end
                AUIPC : begin
                            multicy <= 1'b0;
                            trapExit <= 1'b0;
                            csrOp <= 5'b00000;
                            int <= 1'b0;
                            regDwe <= 1'b1;
                            memOp <= 5'b00000;
                            dataIMM <= { DataInst[31:12], 12'b000000000000 };
                        end
                JAL   : begin
                            multicy <= 1'b0;
                            trapExit <= 1'b0;
                            csrOp <= 5'b00000;
                            int <= 1'b0;
                            if (DataInst[11:7] == 5'b00000) begin
                                regDwe <= 1'b0;
                            end else begin
                                regDwe <= 1'b1;
                            end
                            memOp <= 5'b00000;
                            if (DataInst[31] == 1'b1) begin
                                dataIMM <= { 12'hFFF, DataInst[19:12], DataInst[20], DataInst[30:21], 1'b0 };
                            end else begin
                                dataIMM <= { 12'h000, DataInst[19:12], DataInst[20], DataInst[30:21], 1'b0 };
                            end
                        end
                JALR  : begin
                            multicy <= 1'b0;
                            trapExit <= 1'b0;
                            csrOp <= 5'b00000;
                            int <= 1'b0;
                            if (DataInst[11:7] == 5'b00000) begin
                                regDwe <= 1'b0;
                            end else begin
                                regDwe <= 1'b1;
                            end
                            memOp <= 5'b00000;
                            if (DataInst[31] == 1'b1) begin
                                dataIMM <= { 12'hFFF, 4'hF, DataInst[31:20] };
                            end else begin
                                dataIMM <= { 12'h000, 4'h0, DataInst[31:20] };
                            end
                        end
                OPIMM : begin
                            multicy <= 1'b0;
                            trapExit <= 1'b0;
                            csrOp <= 5'b00000;
                            int <= 1'b0;
                            regDwe <= 1'b1;
                            memOp <= 5'b00000;
                            if (DataInst[31] == 1'b1) begin
                                dataIMM <= { 12'hFFF, 4'hF, DataInst[31:20] };
                            end else begin
                                dataIMM <= { 12'h000, 4'h0, DataInst[31:20] };
                            end
                        end
                OP    : begin
                            if (DataInst[31:25] == 6'b000001) begin
                                multicy <= 1'b1;
                            end else begin
                                multicy <= 1'b0;
                            end
                            trapExit <= 1'b0;
                            csrOp <= 5'b00000;
                            int <= 1'b0;
                            regDwe <= 1'b1;
                            memOp <= 5'b00000;
                        end
                LOAD  : begin
                            multicy <= 1'b0;
                            if (DataInst[1:0] == 2'b11) begin
                                trapExit <= 1'b0;
                                csrOp <= 5'b00000;
                                int <= 1'b0;
                                regDwe <= 1'b1;
                                memOp = { 2'b10, DataInst[14:12] };
                                if (DataInst[31] == 1'b0) begin
                                    dataIMM <= { 12'hFFF, 4'hF, DataInst[31:20] };
                                end else begin
                                    dataIMM <= { 12'h000, 4'h0, DataInst[31:20] };
                                end
                            end else begin
                                trapExit <= 1'b0;
                                csrOp <= 5'b00000;
                                int <= 1'b0;
                                intData <= 32'h00000002;
                                memOp <= 5'b00000;
                                regDwe <= 5'b0;
                                dataIMM <= { DataInst[31:7], 7'b0000000 };
                            end
                        end
                STORE : begin
                            multicy <= 1'b0;
                            trapExit <= 1'b0;
                            csrOp <= 5'b00000;
                            int <= 1'b0;
                            regDwe <= 1'b0;
                            memOp <= { 2'b11, DataInst[14:12] };
                            if (DataInst[31] == 1'b1) begin
                                dataIMM <= { 12'hFFF, 4'hF, DataInst[31:25], DataInst[11:7] };
                            end else begin
                                dataIMM <= { 12'h000, 4'h0, DataInst[31:25], DataInst[11:7] };
                            end
                        end
                BRANCH : begin
                            multicy <= 1'b0;
                            trapExit <= 1'b0;
                            csrOp <= 5'b00000;
                            int <= 1'b0;
                            regDwe <= 1'b0;
                            memOp <= 5'b00000;
                            if (DataInst[31] == 1'b1) begin
                                dataIMM <= { 12'hFFF, 4'hF, DataInst[7], DataInst[30:25], DataInst[11:8], 1'b0 };
                            end else begin
                                dataIMM <= { 12'h000, 4'h0, DataInst[7], DataInst[30:25], DataInst[11:8], 1'b0 };
                            end
                        end
                MISCMEM : begin
                            multicy <= 1'b0;
                            trapExit <= 1'b0;
                            csrOp <= 5'b00000;
                            int <= 1'b0;
                            regDwe <= 1'b0;
                            memOp <= 5'b01000;
                            dataIMM <= DataInst;
                        end
                SYSTEM : begin
                            multicy <= 1'b0;
                            memOp <= 5'b00000;
                            if (DataInst[14:12] == 3'b000) begin
                                case (DataInst[31:20])
                                    IMM_I_SYSTEM_ECALL : begin
                                        trapExit <= 1'b0;
                                        csrOp <= 5'b00000;
                                        int <= 1'b1;
                                        regDwe <= 1'b0;
                                        intData <= 32'h0000000B;
                                    end
                                    IMM_I_SYSTEM_EBREAK : begin
                                        trapExit <= 1'b0;
                                        csrOp <= 5'b00000;
                                        int <= 1'b1;
                                        intData <= 32'h00000003;
                                        regDwe <= 1'b0;
                                    end
                                    { F7_PRIVOP_MRET, R2_PRIV_RET } : begin
                                        trapExit <= 1'b1;
                                        csrOp <= 5'b00000;
                                        int <= 1'b0;
                                        regDwe <= 1'b0;
                                    end
                                    default: ;
                                endcase
                            end else begin
                                trapExit <= 1'b0;
                                int <= 1'b0;
                                dataIMM <= { 24'h000000, 3'b000, DataInst[19:15] };
                                csrAddr <= DataInst[31:20];
                                if (DataInst[11:7] == 5'b00000) begin
                                    csrOp[0] = 1'b0;
                                    regDwe <= 1'b0;
                                end else begin
                                    regDwe <= 1'b1;
                                    csrOp <= 1'b1;
                                end
                                if (DataInst[13] == 1'b1 && DataInst[19:15] == 5'b00000) begin
                                    csrOp[1] <= 1'b0;
                                end else begin
                                    csrOp[1] <= 1'b1;
                                end
                                csrOp[4:2] <= DataInst[14:12];
                            end
                        end
                default : begin
                    multicy <= 1'b0;
                    trapExit <= 1'b0;
                    csrOp <= 5'b00000;
                    int <= 1'b1;
                    intData <= 32'h00000002;
                    memOp <= 5'b00000;
                    regDwe <= 1'b0;
                    dataIMM <= { DataIMM[31:20], 7'b000000 };
                end
            endcase
        end else if (IntAck == 1'b1) begin
            int <= 1'b0;
        end
    end
    
    assign TrapExit = trapExit;
    assign CsrOp = csrOp;
    assign CsrAddr = csrAddr;
    assign Int = int;
    assign IntData = intData;
    assign MultycyAlu = multicy;
    assign DataIMM = dataIMM;
    assign RegDwe = regDwe;
    assign AluOp = aluOp;
    assign AluFunc = aluFunc;
    assign MemOp = memOp;
    assign SelD = selD;
    
    assign SelRS1 = DataInst[19:15];
    assign SelRS2 = DataInst[24:20];
    
endmodule
