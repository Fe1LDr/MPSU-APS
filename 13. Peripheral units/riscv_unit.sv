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

logic irq_req;
logic irq_ret;

logic [255:0] out;
assign out = 255'd1 << lsu_mem_addr[31:24];

logic  ext_mem_req;
logic  sw_req;
logic  led_req;
logic  ps2_req;
logic  hex_req;
logic  rx_req;
logic  tx_req;
logic  vga_req;
assign ext_mem_req = lsu_mem_req & out[0];
assign sw_req      = lsu_mem_req & out[1];
assign led_req     = lsu_mem_req & out[2];
assign ps2_req     = lsu_mem_req & out[3];
assign hex_req     = lsu_mem_req & out[4];
assign rx_req      = lsu_mem_req & out[5];
assign tx_req      = lsu_mem_req & out[6];
assign vga_req     = lsu_mem_req & out[7];

logic [31:0] ext_mem_rd;
logic [31:0] sw_rd;
logic [31:0] led_rd;
logic [31:0] ps2_rd;
logic [31:0] hex_rd;
logic [31:0] rx_rd;
logic [31:0] tx_rd;
logic [31:0] vga_rd;

logic [31:0] ext_addr;
assign ext_addr = {8'd0, lsu_mem_addr[23:0]};

logic [7:0] periph_unit_addr;
assign periph_unit_addr = lsu_mem_addr[31:24];

always_comb begin
    case (periph_unit_addr)
        0: mem_lsu_rd = ext_mem_rd;
        1: mem_lsu_rd = sw_rd;
        2: mem_lsu_rd = led_rd;
        3: mem_lsu_rd = ps2_rd;
        4: mem_lsu_rd = hex_rd;
        5: mem_lsu_rd = rx_rd;
        6: mem_lsu_rd = tx_rd;
        7: mem_lsu_rd = vga_rd;
        default: mem_lsu_rd = ext_mem_rd;
    endcase
end

instr_mem instmem (
    .addr_i             (IM_A),
    .read_data_o        (IM_RD)
);

riscv_core core (
    .clk_i              (sysclk),
    .rst_i              (rst),
    .stall_i            (lsu_core_stall),
    .instr_i            (IM_RD),
    .mem_rd_i           (lsu_core_rd),
    .instr_addr_o       (IM_A),
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
    .write_enable_i     (lsu_mem_we),
    .addr_i             (ext_addr),
    .write_data_i       (lsu_mem_wd),
    .read_data_o        (ext_mem_rd),
    .byte_enable_i      (lsu_mem_be),
    .ready_o            (mem_lsu_ready)
);

sw_sb_ctrl sw (
    .clk_i              (sysclk),              
    .rst_i              (rst),
    .req_i              (sw_req),
    .write_enable_i     (lsu_mem_we),
    .addr_i             (ext_addr),
    .write_data_i       (lsu_mem_wd),

    .read_data_o        (sw_rd),

    .interrupt_request_o(irq_req),
    .interrupt_return_i (irq_ret),
    
    .sw_i               (sw_i)
);

led_sb_ctrl led (
    .clk_i              (sysclk),         
    .rst_i              (rst),
    .req_i              (led_req),
    .write_enable_i     (lsu_mem_we),
    .addr_i             (ext_addr),
    .write_data_i       (lsu_mem_wd),

    .read_data_o        (led_rd),

    .led_o              (led_o)

);

ps2_sb_ctrl ps2 (
    .clk_i              (sysclk),
    .rst_i              (rst),
    .addr_i             (ext_addr),
    .req_i              (ps2_req),
    .write_data_i       (lsu_mem_wd),
    .write_enable_i     (lsu_mem_we),
    .read_data_o        (ps2_rd),

    .interrupt_request_o(irq_req),
    .interrupt_return_i (irq_ret),

    .kclk_i             (kclk_i),
    .kdata_i            (kdata_i)
);

hex_sb_ctrl hex (
    .clk_i              (sysclk),
    .rst_i              (rst),
    .addr_i             (ext_addr),
    .req_i              (hex_req),
    .write_data_i       (lsu_mem_wd),
    .write_enable_i     (lsu_mem_we),
    .read_data_o        (hex_rd),

    .hex_led            (hex_led_o),
    .hex_sel            (hex_sel_o)
);

uart_rx_sb_ctrl rx (
    .clk_i              (sysclk),
    .rst_i              (rst),
    .addr_i             (ext_addr),
    .req_i              (rx_req),
    .write_data_i       (lsu_mem_wd),
    .write_enable_i     (lsu_mem_we),
    .read_data_o        (rx_rd),
                        
    .interrupt_request_o(irq_req),
    .interrupt_return_i (irq_ret),
                        
    .rx_i               (rx_i)
);

uart_tx_sb_ctrl tx (
    .clk_i              (sysclk),
    .rst_i              (rst),
    .addr_i             (ext_addr),
    .req_i              (tx_req),
    .write_data_i       (lsu_mem_wd),
    .write_enable_i     (lsu_mem_we),
    .read_data_o        (tx_rd),
                        
    .tx_o               (tx_o)
);

vga_sb_ctrl vga(
    .clk_i              (sysclk),
    .rst_i              (rst),
    .clk100m_i          (clk_i),
    .req_i              (vga_req),
    .write_enable_i     (lsu_mem_we),
    .mem_be_i           (lsu_mem_be),
    .addr_i             (ext_addr),
    .write_data_i       (lsu_mem_wd),
    .read_data_o        (vga_rd),

    .vga_r_o            (vga_r_o),
    .vga_g_o            (vga_g_o),
    .vga_b_o            (vga_b_o),
    .vga_hs_o           (vga_hs_o),
    .vga_vs_o           (vga_vs_o)
);
    
endmodule
