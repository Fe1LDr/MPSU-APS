module sw_sb_ctrl(
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic        req_i,
    input  logic        write_enable_i,
    input  logic [31:0] addr_i,
    input  logic [31:0] write_data_i,
    
    output logic [31:0] read_data_o,
    
    output logic        interrupt_request_o,
    input  logic        interrupt_return_i,
    
    input  logic [15:0] sw_i
);

logic [15:0] sw_temp;

always_ff @(posedge clk_i) begin
    if (rst_i) sw_temp <= 0;
    else begin
        sw_temp <= sw_i;
        if (sw_temp != sw_i) interrupt_request_o <= 1'b1;
        if (interrupt_return_i) interrupt_request_o <= 1'b0;
    end
end

always_ff @(posedge clk_i) begin
    if (req_i & ~write_enable_i & addr_i == 32'b0) begin
        read_data_o = {{16{1'b0}}, sw_temp};
    end
end
    
endmodule