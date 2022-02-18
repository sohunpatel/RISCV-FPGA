`ifndef CONSTANTS_VH
`define CONSTANTS_VH

module constants;

localparam DIV_IDLE = 2'b00;
localparam DIV_INFLIGHT = 2'b01;
localparam DIV_COMPLETE = 2'b10;

localparam MUL_IDLE = 2'b00;
localparam MUL_COMPLETE = 2'b10;
localparam ADDR_RESET = 32'h00000000;
localparam ADDR_INTVEC = 32'h00000100;

// PC unit opcodes
localparam PC_OP_NOP = 2'b00;
localparam PC_OP_INC = 2'b01;
localparam PC_OP_ASSIGN = 2'b10;
localparam PC_OP_RESET = 2'b11;

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

// RV32M Extension
localparam F7_OP_M_EXT = 7'b0000001;
localparam F3_OP_M_MUL = 3'b000;
localparam F3_OP_M_MULH = 3'b001;
localparam F3_OP_M_MULHSU = 3'b010;
localparam F3_OP_M_MULHU = 3'b011;
localparam F3_OP_M_DIV = 3'b100;
localparam F3_OP_M_DIVU = 3'b101;
localparam F3_OP_M_REM = 3'b110;
localparam F3_OP_M_REMU = 3'b111;

// bit 0 of the OP definitions denote unsigned ops; same as above
localparam ALU_INT32_DIV_OP_UNSIGNED_BIT = 32'h00000000;
localparam ALU_INT32_DIV_OP_DIV = 2'b00;
localparam ALU_INT32_DIV_OP_DIVU = 2'b01;
localparam ALU_INT32_DIV_OP_REM = 2'b10;
localparam ALU_INT32_DIV_OP_REMU = 2'b11;

localparam F3_MISCMEM_FENCE = 3'b000;
localparam F3_MISCMEM_FENCEI = 3'b001;

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


localparam EXCEPTION_INT_USER_SOFTWARE       =  32'h80000000;
localparam EXCEPTION_INT_SUPERVISOR_SOFTWARE =  32'h80000001;
// localparam EXCEPTION_INT_RESERVED          =  32'h80000002;
localparam EXCEPTION_INT_MACHINE_SOFTWARE    =  32'h80000003;
localparam EXCEPTION_INT_USER_TIMER          =  32'h80000004;
localparam EXCEPTION_INT_SUPERVISOR_TIMER    =  32'h80000005;
// localparam EXCEPTION_INT_RESERVED          =  32'h80000006;
localparam EXCEPTION_INT_MACHINE_TIMER       =  32'h80000007;
localparam EXCEPTION_INT_USER_EXTERNAL       =  32'h80000008;
localparam EXCEPTION_INT_SUPERVISOR_EXTERNAL =  32'h80000009;
// localparam EXCEPTION_INT_RESERVED          =  32'h8000000a;
localparam EXCEPTION_INT_MACHINE_EXTERNAL    =  32'h8000000b;

localparam EXCEPTION_INSTRUCTION_ADDR_MISALIGNED  =  32'h00000000;
localparam EXCEPTION_INSTRUCTION_ACCESS_FAULT     =  32'h00000001;
localparam EXCEPTION_INSTRUCTION_ILLEGAL          =  32'h00000002;
localparam EXCEPTION_BREAKPOINT                   =  32'h00000003;
localparam EXCEPTION_LOAD_ADDRESS_MISALIGNED      =  32'h00000004;
localparam EXCEPTION_LOAD_ACCESS_FAULT            =  32'h00000005;
localparam EXCEPTION_STORE_AMO_ADDRESS_MISALIGNED =  32'h00000006;
localparam EXCEPTION_STORE_AMO_ACCESS_FAULT       =  32'h00000007;
localparam EXCEPTION_ENVIRONMENT_CALL_FROM_UMODE  =  32'h00000008;
localparam EXCEPTION_ENVIRONMENT_CALL_FROM_SMODE  =  32'h00000009;
// localparam EXCEPTION_RESERVED                   =  32'h0000000a;
localparam EXCEPTION_ENVIRONMENT_CALL_FROM_MMODE  =  32'h0000000b;
localparam EXCEPTION_INSTRUCTION_PAGE_FAULT       =  32'h0000000c;
localparam EXCEPTION_LOAD_PAGE_FAULT              =  32'h0000000d;
// localparam EXCEPTION_RESERVED                   =  32'h0000000e;
localparam EXCEPTION_STORE_AMO_PAGE_FAULT         =  32'h0000000f;

localparam CSR_ADDR_PRIVILEGE_BIT_START  = 32'h00000009;
localparam CSR_ADDR_PRIVILEGE_BIT_END    = 32'h00000008;
localparam CSR_ADDR_PRIVILEGE_USER       = 2'b00;
localparam CSR_ADDR_PRIVILEGE_SUPERVISOR = 2'b01;
localparam CSR_ADDR_PRIVILEGE_RESERVED   = 2'b10;
localparam CSR_ADDR_PRIVILEGE_MACHINE    = 2'b11;

localparam CSR_ADDR_ACCESS_BIT_START = 32'h0000000B;
localparam CSR_ADDR_ACCESS_BIT_END   = 32'h0000000A;
localparam CSR_ADDR_ACCESS_READONLY  = 2'b11;


// CSR Opcodes:
// 0 - CSR Written
// 1 - CSR Read
// 2..3 0 operation
//    01 - read or write whole XLEN
//    10 - Set bits
//    11 - clear bits
// 4 - immediate or register

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

endmodule

`endif