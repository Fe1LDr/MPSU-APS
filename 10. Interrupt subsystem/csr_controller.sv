module csr_controller(
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic        trap_i,
    input  logic [2:0]  opcode_i,
    input  logic [11:0] addr_i,
    input  logic [31:0] pc_i,
    input  logic [31:0] mcause_i,
    input  logic [31:0] rs1_data_i,
    input  logic [31:0] imm_data_i,
    input  logic        write_enable_i,
    
    output logic [31:0] read_data_o,
    output logic [31:0] mie_o,
    output logic [31:0] mepc_o,
    output logic [31:0] mtvec_o
);

import csr_pkg::*;

logic [31:0] operation_result;

always_comb begin
    case (opcode_i)
        CSR_RW: operation_result = rs1_data_i;
        CSR_RS: operation_result = rs1_data_i | read_data_o;
        CSR_RC: operation_result = ~(rs1_data_i) & read_data_o;
        CSR_RWI:operation_result = imm_data_i;
        CSR_RSI:operation_result = imm_data_i | read_data_o;
        CSR_RCI:operation_result = ~(imm_data_i) & read_data_o;
        default:operation_result = rs1_data_i;
    endcase
end

logic [4:0] enable;

assign enable[0] = write_enable_i & (addr_i == MIE_ADDR);
assign enable[1] = write_enable_i & (addr_i == MTVEC_ADDR);
assign enable[2] = write_enable_i & (addr_i == MSCRATCH_ADDR);
assign enable[3] = write_enable_i & (addr_i == MEPC_ADDR);
assign enable[4] = write_enable_i & (addr_i == MCAUSE_ADDR);

logic [31:0] mie_reg;
logic [31:0] mtvec_reg;
logic [31:0] mscratch_reg;
logic [31:0] mepc_reg;
logic [31:0] mcause_reg;

always_ff @(posedge clk_i) begin
    if (rst_i) mie_reg <= 32'b0;
    else if (enable[0]) mie_reg <= operation_result;
end

always_ff @(posedge clk_i) begin
    if (rst_i) mtvec_reg <= 32'b0;
    else if (enable[1]) mtvec_reg <= operation_result;
end

always_ff @(posedge clk_i) begin
    if (rst_i) mscratch_reg <= 32'b0;
    else if (enable[2]) mscratch_reg <= operation_result;
end

always_ff @(posedge clk_i) begin
    if (rst_i) mepc_reg <= 32'b0;
    else if (enable[3] | trap_i) mepc_reg <= trap_i ? pc_i : operation_result;
end

always_ff @(posedge clk_i) begin
    if (rst_i) mcause_reg <= 32'b0;
    else if (enable[4] | trap_i) mcause_reg <= trap_i ? mcause_i : operation_result;
end

always_comb begin
    case (addr_i)
        MIE_ADDR:      read_data_o = mie_reg;
        MTVEC_ADDR:    read_data_o = mtvec_reg;
        MSCRATCH_ADDR: read_data_o = mscratch_reg;
        MEPC_ADDR:     read_data_o = mepc_reg;
        MCAUSE_ADDR:   read_data_o = mcause_reg;
        default:       read_data_o = mie_reg;
    endcase
end

assign mie_o = mie_reg;
assign mtvec_o = mtvec_reg;
assign mepc_o = mepc_reg;
    
endmodule