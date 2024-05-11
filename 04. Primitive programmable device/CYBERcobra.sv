module CYBERcobra(
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic [15:0] sw_i,
    output logic [31:0] out_o
);

logic [31:0] pc;
logic [31:0] adder_o;
logic [31:0] curr_jump;

logic [31:0] RD1;
logic [31:0] RD2;
logic [31:0] alu_result;
logic alu_flag;

logic [31:0] instruction;

logic J;
logic B;
logic [1:0] WS;
logic [4:0] ALUop;
logic [4:0] RA1;
logic [4:0] RA2;
logic [7:0] offset;
logic [4:0] WA;
logic [22:0] constant;

assign J        = instruction[31];
assign B        = instruction[30];
assign WS       = instruction[29:28];
assign ALUop    = instruction[27:23];
assign RA1      = instruction[22:18];
assign RA2      = instruction[17:13];
assign offset   = instruction[12:5];
assign WA       = instruction[4:0];
assign constant = instruction[27:5];

always_ff @(posedge clk_i) begin
    if (rst_i) pc <= 0;
    else pc <= adder_o;
end

logic [31:0] rf_write_data;

always_comb begin
    case (WS)
        0: rf_write_data = $signed({ {9{constant[22]}}, constant});
        1: rf_write_data = alu_result;
        2: rf_write_data = { {16{sw_i[15]}}, sw_i};
        3: rf_write_data = 32'b0;
    endcase
end

assign curr_jump = (J ^ (B & alu_flag)) ? $signed({ {22{offset[7]}}, offset, 2'b0}) : 32'd4;

fulladder32 adder (
    .a_i    (pc),
    .b_i    (curr_jump),
    .sum_o  (adder_o),
    .carry_i(1'b0)
);

instr_mem instmem (
    .addr_i     (pc),
    .read_data_o(instruction)
);

rf_riscv rf (
    .clk_i          (clk_i),
    .write_enable_i (~(J ^ B)),
    .write_addr_i   (WA),
    .read_addr1_i   (RA1),
    .read_addr2_i   (RA2),
    .write_data_i   (rf_write_data),
    .read_data1_o   (RD1),
    .read_data2_o   (RD2)
);

alu_riscv alu (
    .a_i     (RD1),
    .b_i     (RD2),
    .alu_op_i(ALUop),
    .flag_o  (alu_flag),
    .result_o(alu_result)
);

assign out_o = RD1;
    
endmodule
