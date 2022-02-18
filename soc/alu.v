`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2022 12:33:05 PM
// Design Name: 
// Module Name: alu
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


module alu(
    input Clk,
    input En,
    input [31:0] DataA,
    input [31:0] DataB,
    input DataDWe,
    input [4:0] AluOp,
    input [15:0] AluFunc,
    input [31:0] PC,
    input [31:0] Epc,
    input [31:0] DataIMM,
    input Clear,
    output [31:0] DataResult,
    output [31:0] BranchTarget,
    output DataWriteReg,
    output [31:0] LastPC,
    output ShouldBranch,
    output Wait
);

    reg [15:0] aluFunc;
    reg [31:0] branchTarget;
    reg [31:0] lastPC;
    reg dataWriteReg;
    
    reg [63:0] result;
    reg [63:0] resultms;
    reg [63:0] resultmu;
    reg [65:0] resultmsu;
    reg shouldBranch;
    reg wait_;
    
    reg divExec;
    reg [31:0] divDividend;
    wire [31:0] divDivisor;
    reg [1:0] divOp;
    wire [31:0] divDataResult;
    wire divDone;
    wire divInt;
    
    reg [31:0] mulState;
    reg [31:0] divState;

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

    // Flags
    localparam F3_BRANCH_BEQ = 3'b000;
    localparam F3_BRANCH_BNE = 3'b001;
    localparam F3_BRANCH_BLT = 3'b100;
    localparam F3_BRANCH_BGE = 3'b101;
    localparam F3_BRANCH_BLTU = 3'b110;
    localparam F3_BRANCH_BGEU = 3'b111;

    localparam F3_JALR = 3'b000;

    localparam F3_LOAD_LB = 3'B000;
    localparam F3_LOAD_LH = 3'B001;
    localparam F3_LOAD_LW = 3'B010;
    localparam F3_LOAD_LBU = 3'B100;
    localparam F3_LOAD_LHU = 3'B101;

    localparam F2_MEM_LS_SIZE_B = 2'b00;
    localparam F2_MEM_LS_SIZE_H = 2'b01;
    localparam F2_MEM_LS_SIZE_W = 2'b10;

    localparam F3_STORE_SB = 3'b000;
    localparam F3_STORE_SH = 3'b001;
    localparam F3_STORE_SW = 3'b010;

    localparam F3_OPIMM_ADDI = 3'b000;
    localparam F3_OPIMM_SLTI = 3'b010;
    localparam F3_OPIMM_SLTIU = 3'b011;
    localparam F3_OPIMM_XORI = 3'b100;
    localparam F3_OPIMM_ORI = 3'b110;
    localparam F3_OPIMM_ANDI = 3'b111;

    localparam F3_OPIMM_SLLI = 3'b001;
    localparam F7_OPIMM_SLLI = 7'b0000000;
    localparam F3_OPIMM_SRLI = 3'b101;
    localparam F7_OPIMM_SRLI = 7'b0000000;
    localparam F3_OPIMM_SRAI = 3'b101;
    localparam F7_OPIMM_SRAI = 7'b0100000;

    localparam F3_OP_ADD = 3'b000;
    localparam F7_OP_ADD = 7'b0000000;
    localparam F3_OP_SUB = 3'b000;
    localparam F7_OP_SUB = 7'b0100000;
    localparam F3_OP_SLL = 3'b001;
    localparam F7_OP_SLL = 7'b0000000;
    localparam F3_OP_SLT = 3'b010;
    localparam F7_OP_SLT = 7'b0000000;
    localparam F3_OP_SLTU = 3'b011;
    localparam F7_OP_SLTU = 7'b0000000;
    localparam F3_OP_XOR = 3'b100;
    localparam F7_OP_XOR = 7'b0000000;
    localparam F3_OP_SRL = 3'b101;
    localparam F7_OP_SRL = 7'b0000000;
    localparam F3_OP_SRA = 3'b101;
    localparam F7_OP_SRA = 7'b0100000;
    localparam F3_OP_OR = 3'b110;
    localparam F7_OP_OR = 7'b0000000;
    localparam F3_OP_AND = 3'b111;
    localparam F7_OP_AND = 7'b0000000;

    localparam DIV_IDLE = 2'b00;
    localparam DIV_INFLIGHT = 2'b01;
    localparam DIV_COMPLETE = 2'b10;

    localparam MUL_IDLE = 2'b00;
    localparam MUL_COMPLETE = 2'b10;
    localparam ADDR_RESET = 32'h00000000;
    localparam ADDR_INTVEC = 32'h00000100;

    localparam F7_OP_M_EXT = 7'b0000001;
    localparam F3_OP_M_MUL = 3'b000;
    localparam F3_OP_M_MULH = 3'b001;
    localparam F3_OP_M_MULHSU = 3'b010;
    localparam F3_OP_M_MULHU = 3'b011;
    localparam F3_OP_M_DIV = 3'b100;
    localparam F3_OP_M_DIVU = 3'b101;
    localparam F3_OP_M_REM = 3'b110;
    localparam F3_OP_M_REMU = 3'b111;

    localparam F3_PRIVOP = 3'b000;

    localparam F7_PRIVOP_URET       = 7'b0000000;
    localparam F7_PRIVOP_SRET_WFI   = 7'b0001000;
    localparam F7_PRIVOP_MRET       = 7'b0011000;
    localparam F7_PRIVOP_SFENCE_VMA = 7'b0001001;

    alu_int32_div division_unit (
        .Clk (Clk),
        .Execute (divExec),
        .Dividend (DataA),
        .Divisor (DataB),
        .Op (divOp),
        .DataResult (divDataResult),
        .Done (divDone),
        .Int (divInt)
    );
    
    always @ (posedge Clk) begin
        if (Clear == 1'b1 && En == 1'b0) begin
            branchTarget = 32'h00000000;
            result = 64'h0000000000000000;
        end else if (En == 1'b1) begin
            lastPC <= PC;
            dataWriteReg <= DataDWe;
            case (AluOp)
                OPIMM : begin
                    wait_ <= 1'b0;
                    shouldBranch <= 1'b0;
                    case (AluFunc[2:0])
                        F3_OPIMM_ADDI : result[31:0] <= $signed(DataA) + $signed(DataIMM);
                        F3_OPIMM_XORI : result[31:0] <= DataA ^ DataIMM;
                        F3_OPIMM_ORI  : result[31:0] <= DataA | DataIMM;
                        F3_OPIMM_ANDI : result[31:0] <= DataA & DataIMM;
                        F3_OPIMM_XORI : result[31:0] <= DataA ^ DataIMM;
                        F3_OPIMM_SLTI : begin
                            if ($signed(DataA) < $signed(DataIMM)) begin
                                result[31:0] <= 32'h00000001;
                            end else begin
                                result[31:0] <= 32'h00000000;
                            end
                        end
                        F3_OPIMM_SLTIU : begin
                            if ($unsigned(DataA) < $unsigned(DataIMM)) begin
                                result[31:0] <= 32'h00000001;
                            end else begin
                                result[31:0] <= 32'h00000000;
                            end
                        end
                        F3_OPIMM_SLLI : result[31:0] <= $unsigned(DataA) << $unsigned(DataIMM[4:0]);
                        F3_OPIMM_SRLI : begin
                            case (AluFunc[9:3])
                                F7_OPIMM_SRLI : result[31:0] = $unsigned(DataA) >> $unsigned(DataIMM[4:0]);
                                F7_OPIMM_SRAI : result[31:0] = $signed(DataA) >> $unsigned(DataIMM[4:0]);
                                default: ;
                            endcase
                        end
                        default: ;
                    endcase
                end 
                OP : begin
                    if (AluFunc[9:3] == F7_OP_M_EXT) begin
                        if (AluFunc[2] == 1'b0) begin
                            if (mulState == MUL_IDLE) begin
                                resultms <= $signed(DataA) * $signed(DataB);
                                resultmsu <= $unsigned(DataA) * $unsigned(DataB);
                                resultmsu <= $signed({DataA[31], DataA}) * $signed({1'b0, DataB});
                                wait_ <= 1'b0;
                                mulState <= MUL_COMPLETE;
                            end else if (mulState == MUL_COMPLETE) begin
                                if (AluFunc[2:0] == F3_OP_M_MUL) begin
                                    result[31:0] <= resultms[31:0];
                                end else if (AluFunc[2:0] == F3_OP_M_MULH) begin
                                    result[31:0] <= resultms[63:32];
                                end else if (AluFunc[2:0] == F3_OP_M_MULHU) begin
                                    result[31:0] <= resultmu[63:32];
                                end else if (AluFunc[2:0] == F3_OP_M_MULHSU) begin
                                    result[31:0] <= resultmsu[63:32];
                                end
                                mulState <= MUL_IDLE;
                            end
                        end else begin
                            if (divState == DIV_IDLE) begin
                                divExec <= 1'b1;
                                divOp <= AluFunc[1:0];
                                divState <= DIV_INFLIGHT;
                                wait_ <= 1'b1;
                            end else if (divState <= DIV_INFLIGHT) begin
                                divExec <= 1'b0;
                                if (divDone == 1'b1) begin
                                    divState <= DIV_COMPLETE;
                                    wait_ <= 1'b0;
                                end
                            end else if (divState == DIV_COMPLETE) begin
                                divState <= DIV_IDLE;
                                result <= divDataResult;
                            end
                        end
                    end else begin
                        wait_ <= 1'b0;
                        case (AluFunc[9:0])
                            {F7_OP_ADD, F3_OP_ADD} : result[31:0] <= $signed(DataA) + $signed(DataB);
                            {F7_OP_SUB, F3_OP_SUB} : result[31:0] <= $signed(DataA) - $signed(DataB);
                            {F7_OP_SLT, F3_OP_SLT} : begin
                                if ($signed(DataA) < $signed(DataB)) begin
                                    result[31:0] <= 32'h00000001;
                                end else begin
                                    result[31:0] <= 32'h00000000;
                                end
                            end
                            {F7_OP_SLTU, F3_OP_SLTU} : begin
                                if ($unsigned(DataA) < $unsigned(DataB)) begin
                                    result[31:0] <= 32'h00000001;
                                end else begin
                                    result[31:0] <= 32'h00000000;
                                end
                            end
                            {F7_OP_XOR, F3_OP_XOR} : result[31:0] <= DataA ^ DataB;
                            {F7_OP_OR, F3_OP_OR} : result[31:0] <= DataA | DataB;
                            {F7_OP_AND, F3_OP_AND} : result[31:0] <= DataA & DataB;
                            {F7_OP_SLL, F3_OP_SLL} : result[31:0] <= $unsigned(DataA) << $unsigned(DataB[4:0]);
                            {F7_OP_SRL, F3_OP_SRL} : result[31:0] <= $unsigned(DataA) >> $unsigned(DataB[4:0]);
                            {F7_OP_SRA, F3_OP_SRA} : result[31:0] <= $signed(DataA) >> $unsigned(DataB[4:0]);
                            default: result <= { 32'h00000000,  32'hCDC1FEF1 };
                        endcase
                    end
                    shouldBranch <= 1'b0;
                end
                LOAD | STORE : begin
                    wait_ <= 1'b0;
                    shouldBranch <= 1'b0;
                    result[31:0] <= $signed(DataA) + $signed(DataIMM);
                end
                JALR : begin
                    wait_ <= 1'b0;
                    branchTarget <= ($signed(DataA) + $signed(DataIMM)) & 32'hFFFFFFFE;
                    shouldBranch <= 1'b1;
                    result[31:0] <= $signed(PC) + 4;
                end
                JAL : begin
                    wait_ <= 1'b0;
                    branchTarget <= $signed(DataA) + $signed(DataIMM);
                    shouldBranch <= 1'b1;
                    result[31:0] <= $signed(PC) + 4;
                end
                SYSTEM : begin
                    wait_ <= 1'b0;
                    if (AluFunc[9:0] == {F7_PRIVOP_MRET, F3_PRIVOP}) begin
                        branchTarget<= Epc;
                        shouldBranch <= 1'b1;
                        result <= $signed(PC) + 4;
                    end else if (AluFunc[2:0] != F3_PRIVOP) begin
                        shouldBranch <= 1'b0;
                    end
                end
                LUI : begin
                    wait_ <= 1'b0;
                    shouldBranch <= 1'b0;
                    result[31:0] <= DataIMM;
                end
                AUIPC : begin
                    wait_ <= 1'b0;
                    shouldBranch <= 1'b0;
                    result[31:0] <= $signed(PC) + $signed(DataIMM);
                end
                BRANCH : begin
                    case (AluFunc[2:0])
                        F3_BRANCH_BEQ : begin
                            if (DataA == DataB) begin
                                shouldBranch <= 1'b1;
                            end else begin
                                shouldBranch <= 1'b0;
                            end
                        end
                        F3_BRANCH_BNE : begin
                            if (DataA != DataB) begin
                                shouldBranch <= 1'b1;
                            end else begin
                                shouldBranch <= 1'b0;
                            end
                        end
                        F3_BRANCH_BLT : begin
                            if ($signed(DataA) < $signed(DataB)) begin
                                shouldBranch <= 1'b1;
                            end else begin
                                shouldBranch <= 1'b0;
                            end
                        end
                        F3_BRANCH_BGE : begin
                            if ($signed(DataA) >= $signed(DataB)) begin
                                shouldBranch <= 1'b1;
                            end else begin
                                shouldBranch <= 1'b0;
                            end
                        end
                        F3_BRANCH_BLTU : begin
                            if ($unsigned(DataA) < $unsigned(DataB)) begin
                                shouldBranch <= 1'b1;
                            end else begin
                                shouldBranch <= 1'b0;
                            end
                        end
                        F3_BRANCH_BGEU : begin
                            if ($unsigned(DataA) >= $unsigned(DataB)) begin
                                shouldBranch <= 1'b1;
                            end else begin
                                shouldBranch <= 1'b0;
                            end
                        end
                        default: result <= { 32'h00000000, 32'hCDCDFEFE };
                    endcase
                end
                default: ;
            endcase
        end
    end
    
    assign divDivdend = DataA;
    assign divDivisor = DataB;

    assign DataResult = result[31:0];
    assign ShouldBranch = shouldBranch;
    assign BranchTarget = branchTarget;
    assign LastPC = lastPC;

endmodule
