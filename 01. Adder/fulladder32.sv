module fulladder32(
    input  logic [31:0] a_i,
    input  logic [31:0] b_i,
    input  logic 		carry_i,
    output logic [31:0] sum_o,
    output logic 		carry_o
);

genvar i;
logic [32:0] carry;
assign carry[0] = carry_i;

generate
for (i = 0; i < 32; i = i + 1) begin : fulladder
	fulladder inst(
		.a_i	(a_i[i]),
		.b_i	(b_i[i]),
		.sum_o	(sum_o[i]),
		.carry_i(carry[i]),
		.carry_o(carry[i+1])
	);
end
endgenerate
assign carry_o = carry[32];

endmodule