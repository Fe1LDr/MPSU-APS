module riscv_core(
    input  logic        clk_i,
    input  logic        rst_i,
    
    input  logic        stall_i,
    input  logic [31:0] instr_i,
    input  logic [31:0] mem_rd_i,
    
    output logic [31:0] instr_addr_o,
    output logic [31:0] mem_addr_o,
    output logic [2:0]  mem_size_o,
    output logic        mem_req_o,
    output logic        mem_we_o,
    output logic [31:0] mem_wd_o
);

logic [31:0] pc;
logic [31:0] adder_pc;

logic [11:0] imm_I;
logic [31:0] imm_U;
logic [11:0] imm_S;
logic [12:0] imm_B;
logic [20:0] imm_J;
logic [4:0]  RA1;
logic [4:0]  RA2;
logic [4:0]  WA;
logic [31:0] RD1;
logic [31:0] RD2;
logic [31:0] wb_data;

logic [31:0] alu_first;
logic [31:0] alu_second;
logic        alu_flag;
logic [31:0] alu_result;

logic [1:0] a_sel;
logic [2:0] b_sel;
logic [4:0] alu_op;
logic [2:0] csr_op;
logic       csr_we;
logic       mem_req;
logic       mem_we;
logic       gpr_we;
logic [1:0] wb_sel;
logic       illegal_instr;
logic       branch; 
logic       jal;
logic       jalr;
logic       mret;

logic [31:0] adder1_first;
logic [31:0] adder1_second;
logic [31:0] adder1_result;
logic [31:0] adder2_result;

assign imm_I = instr_i[31:20];
assign imm_U = {instr_i[31:12], {12{1'b0}}};
assign imm_S = {instr_i[31:25], instr_i[11:7]};
assign imm_B = {instr_i[31], instr_i[7], instr_i[30:25], instr_i[11:8], 1'b0};
assign imm_J = {instr_i[31], instr_i[19:12], instr_i[20], instr_i[30:21], 1'b0};
assign RA1   = instr_i[19:15];
assign RA2   = instr_i[24:20];
assign WA    = instr_i[11:07];

always_ff @(posedge clk_i) begin
    if (~stall_i) begin
        if (rst_i) pc <= 0;
        else pc <= adder_pc;
    end
end

always_comb begin
    case (a_sel)
        0: alu_first = RD1;
        1: alu_first = pc;
        2: alu_first = 32'b0;
        default: alu_first = 32'b0;
    endcase
end

always_comb begin
    case (b_sel)
        0: alu_second = RD2;
        1: alu_second = {{20{imm_I[11]}}, imm_I};
        2: alu_second = imm_U;
        3: alu_second = {{20{imm_S[11]}}, imm_S};
        4: alu_second = 32'd4;
        default: alu_second = 32'b0;
    endcase
end

always_comb begin
    case (wb_sel)
        0: wb_data = alu_result;
        1: wb_data = mem_rd_i;
        default: wb_data = alu_result;
    endcase
end

logic  jump;
assign jump = jal | (branch & alu_flag);

always_comb begin
    case (jump)
        0: adder1_second = 32'd4;
        1: adder1_second = branch ? {{19{imm_B[12]}}, imm_B} : {{11{imm_J[20]}}, imm_J};
    endcase
end

always_comb begin
    if (jalr) adder_pc = adder2_result;
    else      adder_pc = adder1_result;
end

decoder_riscv decoder(
    .fetched_instr_i(instr_i),
    .a_sel_o        (a_sel),
    .b_sel_o        (b_sel),
    .alu_op_o       (alu_op),
    .csr_op_o       (),
    .csr_we_o       (),
    .mem_req_o      (mem_req_o),
    .mem_we_o       (mem_we_o),
    .mem_size_o     (mem_size_o),
    .gpr_we_o       (gpr_we),
    .wb_sel_o       (wb_sel),
    .illegal_instr_o(),
    .branch_o       (branch),
    .jal_o          (jal),
    .jalr_o         (jalr),
    .mret_o         ()
);

rf_riscv rf (
    .clk_i          (clk_i),
    .write_enable_i (gpr_we & ~stall_i),
    .write_addr_i   (WA),
    .read_addr1_i   (RA1),
    .read_addr2_i   (RA2),
    .write_data_i   (wb_data),
    .read_data1_o   (RD1),
    .read_data2_o   (RD2)
);

alu_riscv alu (
    .a_i            (alu_first),
    .b_i            (alu_second),
    .alu_op_i       (alu_op),
    .flag_o         (alu_flag),
    .result_o       (alu_result)
);

fulladder32 adder1 (
    .a_i            (pc),
    .b_i            (adder1_second),
    .sum_o          (adder1_result),
    .carry_i        (1'b0)
);

fulladder32 adder2 (
    .a_i            (RD1),
    .b_i            ({{20{imm_I[11]}}, imm_I}),
    .sum_o          (adder2_result),
    .carry_i        (1'b0)
);

assign instr_addr_o = pc;
assign mem_addr_o = alu_result;
assign mem_wd_o = RD2;
    
endmodule