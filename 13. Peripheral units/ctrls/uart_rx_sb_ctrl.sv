module uart_rx_sb_ctrl(
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic [31:0] addr_i,
    input  logic        req_i,
    input  logic [31:0] write_data_i,
    input  logic        write_enable_i,
    output logic [31:0] read_data_o,
    
    output logic        interrupt_request_o,
    input  logic        interrupt_return_i,
    
    input  logic        rx_i
);
    
logic        busy;
logic [16:0] baudrate;
logic        parity_en;
logic        stopbit;
logic [7:0]  data;
logic        valid;

logic  read_req;
logic  write_req;
assign read_req  = req_i & ~write_enable_i;
assign write_req = req_i &  write_enable_i;

logic  rst;
assign rst = rst_i | (write_req & write_data_i[0] & addr_i == 32'h24);

logic [7:0] rx_data;
logic       rx_valid;
logic       busy_temp;

uart_rx rx (
    .clk_i      (clk_i),
    .rst_i      (rst),
    .rx_i       (rx_i),
    .busy_o     (busy_temp),
    .baudrate_i (baudrate),
    .parity_en_i(parity_en),
    .stopbit_i  (stopbit),
    .rx_data_o  (rx_data),
    .rx_valid_o (rx_valid)
);

always_ff @(posedge clk_i) begin
    busy <= busy_temp;
end

always_ff @(posedge clk_i) begin
    if (interrupt_return_i) valid <= 1'b0;
    if (rst) begin
        baudrate  <= 17'd9600;
        parity_en <= 1'b1;
        stopbit   <= 1'b1;
        data      <= 8'b0;
        valid     <= 1'b0;
    end
    else if (rx_valid) begin
        data  <= rx_data;
        valid <= rx_valid;
    end
    if (write_req & ~busy) begin
        case (addr_i)
            32'h0C: baudrate  <= write_data_i[16:0];
            32'h10: parity_en <= write_data_i[0];
            32'h14: stopbit   <= write_data_i[0];
            default:baudrate  <= write_data_i[16:0];
        endcase
    end
    if (read_req) begin
        case (addr_i)
            32'h00: begin 
                     read_data_o <= {24'b0, data}; valid <= 1'b0; 
            end
            32'h04:  read_data_o <= {31'b0, valid};
            32'h08:  read_data_o <= {31'b0, busy};
            32'h0C:  read_data_o <= {15'd0, baudrate};
            32'h10:  read_data_o <= {31'd0, parity_en};
            32'h14:  read_data_o <= {31'd0, stopbit};
            default: read_data_o <= {24'b0, data};
        endcase
    end
end

assign interrupt_request_o = valid;
    
endmodule