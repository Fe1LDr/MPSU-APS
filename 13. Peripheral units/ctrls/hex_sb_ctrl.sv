module hex_sb_ctrl(
    input  logic        clk_i,
    input  logic        rst_i, // ?
    input  logic [31:0] addr_i,
    input  logic        req_i,
    input  logic [31:0] write_data_i,
    input  logic        write_enable_i,
    output logic [31:0] read_data_o,
    
    output logic [6:0]  hex_led,
    output logic [7:0]  hex_sel
);
    
logic [3:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7;
logic [7:0] bitmask;

logic  read_req;
logic  write_req;
logic  rst;
assign read_req  = req_i & ~write_enable_i;
assign write_req = req_i &  write_enable_i;
assign rst       = rst_i | (write_data_i[0] & (write_req & (addr_i == 32'h24)));

hex_digits hex (
    .clk_i    (clk_i),
    .rst_i    (rst_i),
    .hex0_i   (hex0),
    .hex1_i   (hex1),
    .hex2_i   (hex2),
    .hex3_i   (hex3),
    .hex4_i   (hex4),
    .hex5_i   (hex5),
    .hex6_i   (hex6),
    .hex7_i   (hex7),
    .bitmask_i(bitmask),
    
    .hex_led_o(hex_led),
    .hex_sel_o(hex_sel)
);

always_ff @(posedge clk_i) begin
    if (rst) begin
        hex0 <= 4'd0;
        hex1 <= 4'd0;
        hex2 <= 4'd0;
        hex3 <= 4'd0;
        hex4 <= 4'd0;
        hex5 <= 4'd0;
        hex6 <= 4'd0;
        hex7 <= 4'd0;
        bitmask <= 8'hff;
    end else if (write_req) begin
        case (addr_i)
            32'h00: hex0    <= write_data_i[3:0];
            32'h04: hex1    <= write_data_i[3:0];
            32'h08: hex2    <= write_data_i[3:0];
            32'h0C: hex3    <= write_data_i[3:0];
            32'h10: hex4    <= write_data_i[3:0];
            32'h14: hex5    <= write_data_i[3:0];
            32'h18: hex6    <= write_data_i[3:0];
            32'h1C: hex7    <= write_data_i[3:0];
            32'h20: bitmask <= write_data_i[7:0];
        endcase
    end
end

always_ff @(posedge clk_i) begin
    if (read_req) begin
        case (addr_i)
            32'h00: read_data_o <= {28'd0, hex0};
            32'h04: read_data_o <= {28'd0, hex1};
            32'h08: read_data_o <= {28'd0, hex2};
            32'h0C: read_data_o <= {28'd0, hex3};
            32'h10: read_data_o <= {28'd0, hex4};
            32'h14: read_data_o <= {28'd0, hex5};
            32'h18: read_data_o <= {28'd0, hex6};
            32'h1C: read_data_o <= {28'd0, hex7};
            32'h20: read_data_o <= {24'd0, bitmask};
            default:read_data_o <= {28'd0, hex0};
        endcase
    end
end
    
endmodule