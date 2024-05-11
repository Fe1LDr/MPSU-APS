module riscv_unit(
    input logic clk_i,
    input logic rst_i
);
logic stall;

logic [31:0] IM_A;
logic [31:0] IM_RD;

logic [31:0] DM_A;
logic [31:0] DM_RD;

logic req;
logic WE;
logic [31:0] WD;

always_ff @(posedge clk_i) begin
    if (rst_i) stall <= 0;
    else stall <= (~stall & req);
end

instr_mem instmem (
    .addr_i             (IM_A),
    .read_data_o        (IM_RD)
);

riscv_core core (
    .clk_i              (clk_i),
    .rst_i              (rst_i),
    .stall_i            (~stall & req),
    .instr_i            (IM_RD),
    .mem_rd_i           (DM_RD),
    .instr_addr_o       (IM_A),
    .mem_addr_o         (DM_A),
    .mem_size_o         (),
    .mem_req_o          (req),
    .mem_we_o           (WE),
    .mem_wd_o           (WD)
);

data_mem datamem (
    .clk_i              (clk_i),
    .mem_req_i          (req),
    .write_enable_i     (WE),
    .addr_i             (DM_A),
    .write_data_i       (WD),
    .read_data_o        (DM_RD)
);
    
endmodule