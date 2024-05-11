module instr_mem(
    input  logic [31:0] addr_i,
    output logic [31:0] read_data_o
);

logic [31:0] reg_name [0:1023];

initial begin
    $readmemh("program.mem", reg_name);
end

assign read_data_o = reg_name[addr_i[11:2]];
    
endmodule
