module decoder_riscv(
    input  logic [31:0] fetched_instr_i,
    output logic [1:0]  a_sel_o,
    output logic [2:0]  b_sel_o,
    output logic [4:0]  alu_op_o,
    output logic [2:0]  csr_op_o,
    output logic        csr_we_o, // -
    output logic        mem_req_o, // -
    output logic        mem_we_o, // -
    output logic [2:0]  mem_size_o,
    output logic        gpr_we_o, // -
    output logic [1:0]  wb_sel_o,
    output logic        illegal_instr_o, // -
    output logic        branch_o, // - 
    output logic        jal_o, // -
    output logic        jalr_o, // -
    output logic        mret_o
);

import alu_opcodes_pkg::*;
import csr_pkg::*;
import riscv_pkg::*;

logic [6:0] opcode;
logic [2:0] funct3;
logic [6:0] funct7;
assign opcode = fetched_instr_i[6:0];
assign funct3 = fetched_instr_i[14:12];
assign funct7 = fetched_instr_i[31:25];

always_comb begin
    a_sel_o         = OP_A_RS1; // 0
    b_sel_o         = OP_B_IMM_I; // 1
    alu_op_o        = ALU_ADD; // 0
    csr_op_o        = CSR_RW; // 0
    csr_we_o        = 1'b0;
    mem_req_o       = 1'b0;
    mem_we_o        = 1'b0;
    mem_size_o      = LDST_B; // 0
    gpr_we_o        = 1'b0;
    wb_sel_o        = WB_EX_RESULT; // 0
    illegal_instr_o = 1'b0;
    branch_o        = 1'b0;
    jal_o           = 1'b0;
    jalr_o          = 1'b0;
    mret_o          = 1'b0;
    
    case (opcode)
        {LOAD_OPCODE, 2'b11}: begin
            wb_sel_o = WB_LSU_DATA;
            case (funct3)
                LDST_B:  begin gpr_we_o = 1'b1; mem_req_o = 1'b1; mem_size_o = LDST_B; end
                LDST_H:  begin gpr_we_o = 1'b1; mem_req_o = 1'b1; mem_size_o = LDST_H; end
                LDST_W:  begin gpr_we_o = 1'b1; mem_req_o = 1'b1; mem_size_o = LDST_W; end
                LDST_BU: begin gpr_we_o = 1'b1; mem_req_o = 1'b1; mem_size_o = LDST_BU;end
                LDST_HU: begin gpr_we_o = 1'b1; mem_req_o = 1'b1; mem_size_o = LDST_HU;end
                default: illegal_instr_o = 1'b1;
            endcase
        end
        {MISC_MEM_OPCODE, 2'b11}: begin
            case (funct3)
                0: begin end
                default: illegal_instr_o = 1'b1;
            endcase
        end
        {OP_OPCODE, 2'b11}: begin
            b_sel_o = OP_B_RS2;
            case (funct3)
                0: begin case(funct7) 
                    0:  begin gpr_we_o = 1'b1; alu_op_o = ALU_ADD; end
                    32: begin gpr_we_o = 1'b1; alu_op_o = ALU_SUB; end
                    default: illegal_instr_o = 1'b1;
                    endcase end
                4: begin case (funct7)
                    0:  begin gpr_we_o = 1'b1; alu_op_o = ALU_XOR; end
                    default: illegal_instr_o = 1'b1;
                    endcase end
                6: begin case (funct7)
                    0:  begin gpr_we_o = 1'b1; alu_op_o = ALU_OR;  end
                    default: illegal_instr_o = 1'b1;
                    endcase end
                7: begin case (funct7)
                    0:  begin gpr_we_o = 1'b1; alu_op_o = ALU_AND; end
                    default: illegal_instr_o = 1'b1;
                    endcase end
                1: begin case (funct7)
                    0:  begin gpr_we_o = 1'b1; alu_op_o = ALU_SLL; end
                    default: illegal_instr_o = 1'b1;
                    endcase end
                5: begin case(funct7)
                    0:  begin gpr_we_o = 1'b1; alu_op_o = ALU_SRL; end
                    32: begin gpr_we_o = 1'b1; alu_op_o = ALU_SRA; end
                    default: illegal_instr_o = 1'b1;
                    endcase end
                2: begin case (funct7)
                    0:  begin gpr_we_o = 1'b1; alu_op_o = ALU_SLTS;end
                    default: illegal_instr_o = 1'b1;
                    endcase end
                3: begin case (funct7)
                    0:  begin gpr_we_o = 1'b1; alu_op_o = ALU_SLTU;end
                    default: illegal_instr_o = 1'b1;
                    endcase end
                default: illegal_instr_o = 1'b1;
            endcase 
        end
        {OP_IMM_OPCODE, 2'b11}: begin
            case (funct3)
                0: begin gpr_we_o = 1'b1; alu_op_o = ALU_ADD; end
                4: begin gpr_we_o = 1'b1; alu_op_o = ALU_XOR; end
                6: begin gpr_we_o = 1'b1; alu_op_o = ALU_OR;  end
                7: begin gpr_we_o = 1'b1; alu_op_o = ALU_AND; end
                1: begin case (funct7)
                    0: begin gpr_we_o = 1'b1; alu_op_o = ALU_SLL; end
                    default: illegal_instr_o = 1'b1;
                    endcase end
                5: begin case(funct7)
                    0:  begin gpr_we_o = 1'b1; alu_op_o = ALU_SRL; end
                    32: begin gpr_we_o = 1'b1; alu_op_o = ALU_SRA; end
                    default: illegal_instr_o = 1'b1;
                    endcase end
                2: begin gpr_we_o = 1'b1; alu_op_o = ALU_SLTS;end
                3: begin gpr_we_o = 1'b1; alu_op_o = ALU_SLTU;end
                default: illegal_instr_o = 1'b1;
            endcase
        end
        {AUIPC_OPCODE, 2'b11}: begin
            gpr_we_o = 1'b1;
            a_sel_o = OP_A_CURR_PC;
            b_sel_o = OP_B_IMM_U;
        end
        {STORE_OPCODE, 2'b11}: begin
            case (funct3)
                0: begin mem_req_o = 1'b1; mem_we_o = 1'b1; mem_size_o = LDST_B; b_sel_o = OP_B_IMM_S; end
                1: begin mem_req_o = 1'b1; mem_we_o = 1'b1; mem_size_o = LDST_H; b_sel_o = OP_B_IMM_S; end
                2: begin mem_req_o = 1'b1; mem_we_o = 1'b1; mem_size_o = LDST_W; b_sel_o = OP_B_IMM_S; end
                default: illegal_instr_o = 1'b1;
            endcase
        end
        {LUI_OPCODE, 2'b11}: begin
            gpr_we_o = 1'b1;
            a_sel_o = OP_A_ZERO;
            b_sel_o = OP_B_IMM_U;
        end
        {BRANCH_OPCODE, 2'b11}: begin
            case (funct3)
                0: begin branch_o = 1'b1; b_sel_o = OP_B_RS2; alu_op_o = ALU_EQ; end
                1: begin branch_o = 1'b1; b_sel_o = OP_B_RS2; alu_op_o = ALU_NE; end
                4: begin branch_o = 1'b1; b_sel_o = OP_B_RS2; alu_op_o = ALU_LTS;end
                5: begin branch_o = 1'b1; b_sel_o = OP_B_RS2; alu_op_o = ALU_GES;end
                6: begin branch_o = 1'b1; b_sel_o = OP_B_RS2; alu_op_o = ALU_LTU;end
                7: begin branch_o = 1'b1; b_sel_o = OP_B_RS2; alu_op_o = ALU_GEU;end
                default: illegal_instr_o = 1'b1;
            endcase
        end
        {JAL_OPCODE, 2'b11}: begin
            jal_o = 1'b1;
            a_sel_o = OP_A_CURR_PC;
            b_sel_o = OP_B_INCR;
            gpr_we_o = 1'b1;
        end
        {JALR_OPCODE, 2'b11}: begin
            case (funct3)
                0: begin jalr_o = 1'b1; a_sel_o = OP_A_CURR_PC; b_sel_o = OP_B_INCR; gpr_we_o = 1'b1; end
                default: illegal_instr_o = 1'b1;
            endcase
        end
        {SYSTEM_OPCODE, 2'b11}: begin
            case (funct3)
                0: begin case (funct7)
                    //0: illegal_instr_o = 1'b1;
                    //1: illegal_instr_o = 1'b1;
                    24: mret_o = 1'b1;
                    default: illegal_instr_o = 1'b1;
                    endcase end
                1: begin csr_we_o = 1'b1; gpr_we_o = 1'b1; wb_sel_o = WB_CSR_DATA; csr_op_o = CSR_RW; end
                2: begin csr_we_o = 1'b1; gpr_we_o = 1'b1; wb_sel_o = WB_CSR_DATA; csr_op_o = CSR_RS; end
                3: begin csr_we_o = 1'b1; gpr_we_o = 1'b1; wb_sel_o = WB_CSR_DATA; csr_op_o = CSR_RC; end
                5: begin csr_we_o = 1'b1; gpr_we_o = 1'b1; wb_sel_o = WB_CSR_DATA; csr_op_o = CSR_RWI;end
                6: begin csr_we_o = 1'b1; gpr_we_o = 1'b1; wb_sel_o = WB_CSR_DATA; csr_op_o = CSR_RSI;end
                7: begin csr_we_o = 1'b1; gpr_we_o = 1'b1; wb_sel_o = WB_CSR_DATA; csr_op_o = CSR_RCI;end
                default: illegal_instr_o = 1'b1;
            endcase
        end
        default: illegal_instr_o = 1'b1;
    endcase
end
    
endmodule