module riscv_unit(
    input  logic        clk_i,
    input  logic        resetn_i,
    
    input  logic [15:0] sw_i, // switches
    
    output logic [15:0] led_o, // lights
    
    input  logic        kclk_i, // ps/2 
    input  logic        kdata_i,
    
    output logic [6:0]  hex_led_o, // seven segment
    output logic [7:0]  hex_sel_o,
    
    input  logic        rx_i, // uart
    output logic        tx_o,
    
    output logic [3:0]  vga_r_o, // vga
    output logic [3:0]  vga_g_o,
    output logic [3:0]  vga_b_o,
    output logic        vga_hs_o,
    output logic        vga_vs_o
);
    
logic sysclk, rst;
sys_clk_rst_gen divider(
    .ex_clk_i     (clk_i),
    .ex_areset_n_i(resetn_i),
    .div_i        (4'd5),
    .sys_clk_o    (sysclk),
    .sys_reset_o  (rst)
);

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

logic irq_req;
logic irq_ret;

logic [31:0] instr_read_addr;
logic [31:0] instr_read_data;
logic [31:0] instr_write_addr;
logic [31:0] instr_write_data;
logic        instr_write_enable;
logic [31:0] data_addr;
logic [31:0] data_wdata;
logic        data_write_enable;
logic        core_reset;

logic        perif_req;
logic        perif_we;
logic  [3:0] perif_be;
logic [31:0] perif_addr;
logic [31:0] perif_wd;

logic bluster_tx, uart_tx;

assign tx_o       = core_reset ? bluster_tx        : uart_tx;

assign perif_req  = core_reset ? 1'b1              : lsu_mem_req;
assign perif_we   = core_reset ? data_write_enable : lsu_mem_we;
assign perif_be   = core_reset ? 4'hf              : lsu_mem_be;
assign perif_addr = core_reset ? data_addr         : lsu_mem_addr;
assign perif_wd   = core_reset ? data_wdata        : lsu_mem_wd;

logic [255:0] out;
assign out = 255'd1 << perif_addr[31:24];

logic  ext_mem_req;
logic  ps2_req;
logic  tx_req;
logic  vga_req;
logic  timer_req;
assign ext_mem_req = perif_req & out[0];
assign ps2_req     = perif_req & out[3];
assign tx_req      = perif_req & out[6];
assign vga_req     = perif_req & out[7];
assign timer_req   = perif_req & out[8];

logic [31:0] ext_mem_rd;
logic [31:0] ps2_rd;
logic [31:0] tx_rd;
logic [31:0] vga_rd;
logic [31:0] timer_rd;

logic [31:0] ext_addr;
assign ext_addr = {8'd0, perif_addr[23:0]};

logic [7:0] periph_unit_addr;
assign periph_unit_addr = perif_addr[31:24];

always_comb begin
    case (periph_unit_addr)
        0: mem_lsu_rd = ext_mem_rd;
        3: mem_lsu_rd = ps2_rd;
        6: mem_lsu_rd = tx_rd;
        7: mem_lsu_rd = vga_rd;
        8: mem_lsu_rd = timer_rd;
        default: mem_lsu_rd = ext_mem_rd;
    endcase
end

rw_instr_mem instr_mem (
    .clk_i              (sysclk),
    .read_addr_i        (instr_read_addr),
    .read_data_o        (instr_read_data),
    .write_addr_i       (instr_write_addr),
    .write_data_i       (instr_write_data),
    .write_enable_i     (instr_write_enable)
);
/*
bluster bluster (
    .clk_i               (sysclk),
    .rst_i               (rst),
    .rx_i                (rx_i),
    .tx_o                (bluster_tx),
    
    .instr_addr_o        (instr_write_addr),
    .instr_wdata_o       (instr_write_data),
    .instr_write_enable_o(instr_write_enable),
    .data_addr_o         (data_addr),
    .data_wdata_o        (data_wdata),
    .data_write_enable_o (data_write_enable),
    
    .core_reset_o        (core_reset)
); */

assign core_reset = 0;

riscv_core core (
    .clk_i              (sysclk),
    .rst_i              (rst),
    .stall_i            (lsu_core_stall),
    .instr_i            (instr_read_data),
    .mem_rd_i           (lsu_core_rd),
    .instr_addr_o       (instr_read_addr),
    .mem_addr_o         (core_lsu_addr),
    .mem_size_o         (core_lsu_size),
    .mem_req_o          (core_lsu_req),
    .mem_we_o           (core_lsu_we),
    .mem_wd_o           (core_lsu_wd),
    
    .irq_req_i          (irq_req),
    .irq_ret_o          (irq_ret)
);

riscv_lsu lsu(
    .clk_i              (sysclk),
    .rst_i              (rst),

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
    .clk_i              (sysclk),
    .mem_req_i          (ext_mem_req),
    .write_enable_i     (perif_we),
    .addr_i             (ext_addr),
    .write_data_i       (perif_wd),
    .read_data_o        (ext_mem_rd),
    .byte_enable_i      (perif_be),
    .ready_o            (mem_lsu_ready)
);

ps2_sb_ctrl ps2 (
    .clk_i              (sysclk),
    .rst_i              (rst),
    .addr_i             (ext_addr),
    .req_i              (ps2_req),
    .write_data_i       (perif_wd),
    .write_enable_i     (perif_we),
    .read_data_o        (ps2_rd),

    .interrupt_request_o(irq_req),
    .interrupt_return_i (irq_ret),

    .kclk_i             (kclk_i),
    .kdata_i            (kdata_i)
);

uart_tx_sb_ctrl uart(
    .clk_i              (sysclk),
    .rst_i              (rst),
    .addr_i             (ext_addr),
    .req_i              (tx_req),
    .write_data_i       (perif_wd),
    .write_enable_i     (perif_we),
    .read_data_o        (tx_rd),
    .tx_o               (uart_tx)
);

vga_sb_ctrl vga(
    .clk_i              (sysclk),
    .rst_i              (rst),
    .clk100m_i          (clk_i),
    .req_i              (vga_req),
    .write_enable_i     (perif_we),
    .mem_be_i           (perif_be),
    .addr_i             (ext_addr),
    .write_data_i       (perif_wd),
    .read_data_o        (vga_rd),

    .vga_r_o            (vga_r_o),
    .vga_g_o            (vga_g_o),
    .vga_b_o            (vga_b_o),
    .vga_hs_o           (vga_hs_o),
    .vga_vs_o           (vga_vs_o)
);

timer_sb_ctrl timer(
    .clk_i              (sysclk),
    .rst_i              (rst),
    .req_i              (timer_req),
    .write_enable_i     (perif_we),
    .addr_i             (ext_addr),
    .write_data_i       (perif_wd),
    .read_data_o        (timer_rd),
    .ready_o            (),
    .interrupt_request_o()
);
    
endmodule