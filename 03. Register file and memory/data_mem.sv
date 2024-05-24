module data_mem(
    input  logic        clk_i,
    input  logic        mem_req_i,
    input  logic        write_enable_i,
    input  logic [31:0] addr_i,
    input  logic [31:0] write_data_i,
    output logic [31:0] read_data_o
);

logic [31:0] reg_data [0:4095];

always_ff @(posedge clk_i) begin
    if (mem_req_i) begin
        if (write_enable_i) reg_data[addr_i[13:2]] <= write_data_i;
        else read_data_o <= reg_data[addr_i[13:2]];
    end
end

endmodule
