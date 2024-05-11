module ps2_sb_ctrl(
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic [31:0] addr_i,
    input  logic        req_i,
    input  logic [31:0] write_data_i,
    input  logic        write_enable_i,
    output logic [31:0] read_data_o,
    
    output logic        interrupt_request_o,
    input  logic        interrupt_return_i,
    
    input  logic        kclk_i,
    input  logic        kdata_i 
);

logic [7:0] scan_code;
logic       scan_code_is_unread;

logic [7:0] temp_code;
logic       keycode_valid;
logic       keycode_invalid;
assign      keycode_invalid = ~keycode_valid;

PS2Receiver ps2r (
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    .kclk_i         (kclk_i),
    .kdata_i        (kdata_i),
    .keycodeout_o   (temp_code),
    .keycode_valid_o(keycode_valid)
);

logic  read_req;
logic  write_req;
logic  rst_req;
assign read_req  = req_i & ~write_enable_i;
assign write_req = req_i &  write_enable_i;
assign rst_req   = write_data_i[0] & write_req & addr_i == 32'h24;

always_ff @(posedge clk_i) begin
    if      (rst_i)   begin scan_code <= 1'b0; scan_code_is_unread <= 1'b0; end
    else if (rst_req) begin scan_code <= 1'b0; scan_code_is_unread <= 1'b0; end 
    else begin 
        if (keycode_valid) begin
            scan_code <= temp_code;
            scan_code_is_unread <= 1'b1;
        end
        if (read_req) begin
            if (addr_i == 32'h00) begin
                read_data_o <= {24'b0, scan_code};
                if (keycode_invalid) scan_code_is_unread <= 1'b0;
            end
            else if (addr_i == 32'h04) read_data_o <= {31'b0, scan_code_is_unread};
        end
        if (interrupt_return_i & keycode_invalid) scan_code_is_unread <= 1'b0;
    end
end

assign interrupt_request_o = scan_code_is_unread;
    
endmodule