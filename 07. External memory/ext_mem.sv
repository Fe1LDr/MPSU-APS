module ext_mem(
    input  logic        clk_i,
    input  logic        mem_req_i,
    input  logic        write_enable_i,
    input  logic [31:0] addr_i,
    input  logic [31:0] write_data_i,
    output logic [31:0] read_data_o,
    output logic        ready_o,
    
    input  logic [3:0]  byte_enable_i
);

import filenames_pkg::*;

logic [31:0] reg_data [0:4095];

initial begin
    $readmemh(DATA_INIT_FILE_NAME, reg_data);
end

always_ff @(posedge clk_i) begin
    if (mem_req_i) begin
        if (write_enable_i) begin
            if (byte_enable_i[0]) reg_data[addr_i[13:2]][7:0]   <= write_data_i[7:0];
            if (byte_enable_i[1]) reg_data[addr_i[13:2]][15:8]  <= write_data_i[15:8];
            if (byte_enable_i[2]) reg_data[addr_i[13:2]][23:16] <= write_data_i[23:16];
            if (byte_enable_i[3]) reg_data[addr_i[13:2]][31:24] <= write_data_i[31:24];
        end else read_data_o <= reg_data[addr_i[13:2]];
    end
end

assign ready_o = 1'b1;
    
endmodule