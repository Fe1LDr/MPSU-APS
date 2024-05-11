module uart_tx_sb_ctrl(
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic [31:0] addr_i,
    input  logic        req_i,
    input  logic [31:0] write_data_i,
    input  logic        write_enable_i,
    output logic [31:0] read_data_o,
    
    output logic        tx_o
);
    
logic        busy;
logic [16:0] baudrate;
logic        parity_en;
logic        stopbit;
logic [7:0]  data;

logic  read_req;
logic  write_req;
assign read_req  = req_i & ~write_enable_i;
assign write_req = req_i &  write_enable_i;

logic  rst;
assign rst = rst_i | (write_req & write_data_i[0] & addr_i == 32'h24);

logic       tx_valid;
logic       busy_temp;

uart_tx tx (
    .clk_i      (clk_i),
    .rst_i      (rst),
    .tx_o       (tx_o),
    .busy_o     (busy_temp),
    .baudrate_i (baudrate),
    .parity_en_i(parity_en),
    .stopbit_i  (stopbit),
    .tx_data_i  (data),
    .tx_valid_i (tx_valid) 
);

always_ff @(posedge clk_i) begin
    busy <= busy_temp;
end

always_ff @(posedge clk_i) begin
    if (rst) begin
        baudrate  <= 17'd9600;
        parity_en <= 1'b1;
        stopbit   <= 1'b1;
        data      <= 8'b0;
    end
    if (write_req & ~busy) begin
        case (addr_i)
            32'h00: begin data      <= write_data_i[7:0];  tx_valid <= 1'b1; end
            32'h0C: begin baudrate  <= write_data_i[16:0]; tx_valid <= 1'b0; end
            32'h10: begin parity_en <= write_data_i[0];    tx_valid <= 1'b0; end
            32'h14: begin stopbit   <= write_data_i[0];    tx_valid <= 1'b0; end
            default: tx_valid <= 1'b0;
        endcase
    end
    if (read_req) begin
        case (addr_i)
            32'h00: read_data_o <= {24'b0, data};
            32'h08: read_data_o <= {31'b0, busy};
            32'h0C: read_data_o <= {15'd0, baudrate};
            32'h10: read_data_o <= {31'd0, parity_en};
            32'h14: read_data_o <= {31'd0, stopbit};
            default:read_data_o <= {24'b0, data};
        endcase
    end
end
    
endmodule