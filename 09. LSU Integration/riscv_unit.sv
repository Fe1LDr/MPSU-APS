module riscv_unit(
    input logic clk_i,
    input logic rst_i
);

logic [31:0] IM_A;
logic [31:0] IM_RD;

logic        lsu_core_stall;
logic        core_lsu_req;
logic        core_lsu_we;
logic [2:0]  core_lsu_size;
logic [31:0] core_lsu_wd;
logic [31:0] core_lsu_addr;
logic [31:0] lsu_core_rd;

logic        mem_lsu_ready;
logic        lsu_mem_req;
logic        lsu_mem_we;
logic [3:0]  lsu_mem_be;
logic [31:0] lsu_mem_wd;
logic [31:0] lsu_mem_addr;
logic [31:0] mem_lsu_rd;

instr_mem instmem (
    .addr_i             (IM_A),
    .read_data_o        (IM_RD)
);

riscv_core core (
    .clk_i              (clk_i),
    .rst_i              (rst_i),
    .stall_i            (lsu_core_stall),
    .instr_i            (IM_RD),
    .mem_rd_i           (lsu_core_rd),
    .instr_addr_o       (IM_A),
    .mem_addr_o         (core_lsu_addr),
    .mem_size_o         (core_lsu_size),
    .mem_req_o          (core_lsu_req),
    .mem_we_o           (core_lsu_we),
    .mem_wd_o           (core_lsu_wd)
);

riscv_lsu lsu(
    .clk_i              (clk_i),
    .rst_i              (rst_i),

    .core_req_i         (core_lsu_req),
    .core_we_i          (core_lsu_we),
    .core_size_i        (core_lsu_size),
    .core_addr_i        (core_lsu_addr),
    .core_wd_i          (core_lsu_wd),
    .core_rd_o          (lsu_core_rd),
    .core_stall_o       (lsu_core_stall),

    .mem_rd_i           (mem_lsu_rd),
    .mem_ready_i        (mem_lsu_ready),
    .mem_req_o          (lsu_mem_req),
    .mem_we_o           (lsu_mem_we),
    .mem_be_o           (lsu_mem_be),
    .mem_addr_o         (lsu_mem_addr),
    .mem_wd_o           (lsu_mem_wd)
);

ext_mem datamem (
    .clk_i              (clk_i),
    .mem_req_i          (lsu_mem_req),
    .write_enable_i     (lsu_mem_we),
    .addr_i             (lsu_mem_addr),
    .write_data_i       (lsu_mem_wd),
    .read_data_o        (mem_lsu_rd),
    .byte_enable_i      (lsu_mem_be),
    .ready_o            (mem_lsu_ready)
);
    
endmodule