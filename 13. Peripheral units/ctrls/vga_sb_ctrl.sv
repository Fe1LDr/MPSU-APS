module vga_sb_ctrl(
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic        clk100m_i,
    input  logic        req_i,
    input  logic        write_enable_i,
    input  logic [3:0]  mem_be_i,
    input  logic [31:0] addr_i,
    input  logic [31:0] write_data_i,
    output logic [31:0] read_data_o,
    
    output logic [3:0]  vga_r_o,
    output logic [3:0]  vga_g_o,
    output logic [3:0]  vga_b_o,
    output logic        vga_hs_o,
    output logic        vga_vs_o
);
    
logic [2:0]  we;
logic [31:0] q1;
logic [31:0] q2;
logic [31:0] q3;

logic [1:0] addr;
assign addr = addr_i[13:12];

assign we[0] = write_enable_i & (addr == 2'b00);
assign we[1] = write_enable_i & (addr == 2'b01);
assign we[2] = write_enable_i & (addr == 2'b10);

always_comb begin
    case (addr)
        2'b00: read_data_o = q1;
        2'b01: read_data_o = q2;
        2'b10: read_data_o = q3;
        default: read_data_o = q1;
    endcase
end

vgachargen vga (
    .clk_i              (clk_i),             // системный синхроимпульс
    .clk100m_i          (clk100m_i),         // клок с частотой 100МГц
    .rst_i              (rst_i),             // сигнал сброса

    .char_map_addr_i    (addr_i[11:2]),      // адрес позиции выводимого символа
    .char_map_we_i      (we[0]),             // сигнал разрешения записи кода
    .char_map_be_i      (mem_be_i),          // сигнал выбора байтов для записи
    .char_map_wdata_i   (write_data_i),      // ascii-код выводимого символа
    .char_map_rdata_o   (q1),                // сигнал чтения кода символа

    .col_map_addr_i     (addr_i[11:2]),      // адрес позиции устанавливаемой схемы
    .col_map_we_i       (we[1]),             // сигнал разрешения записи схемы
    .col_map_be_i       (mem_be_i),          // сигнал выбора байтов для записи
    .col_map_wdata_i    (write_data_i),      // код устанавливаемой цветовой схемы
    .col_map_rdata_o    (q2),                // сигнал чтения кода схемы

    .char_tiff_addr_i   (addr_i[11:2]),      // адрес позиции устанавливаемого шрифта
    .char_tiff_we_i     (we[2]),             // сигнал разрешения записи шрифта
    .char_tiff_be_i     (mem_be_i),          // сигнал выбора байтов для записи
    .char_tiff_wdata_i  (write_data_i),      // отображаемые пиксели в текущей позиции шрифта
    .char_tiff_rdata_o  (q3),                // сигнал чтения пикселей шрифта

    .vga_r_o            (vga_r_o),           // красный канал vga
    .vga_g_o            (vga_g_o),           // зеленый канал vga
    .vga_b_o            (vga_b_o),           // синий канал vga
    .vga_hs_o           (vga_hs_o),          // линия горизонтальной синхронизации vga
    .vga_vs_o           (vga_vs_o)
);

endmodule