module riscv_lsu(
    input  logic        clk_i,
    input  logic        rst_i,
    
    input  logic        core_req_i,
    input  logic        core_we_i,
    input  logic [2:0]  core_size_i,
    input  logic [31:0] core_addr_i,
    input  logic [31:0] core_wd_i,
    output logic [31:0] core_rd_o,
    output logic        core_stall_o,
    
    input  logic [31:0] mem_rd_i,
    input  logic        mem_ready_i,
    output logic        mem_req_o,
    output logic        mem_we_o,
    output logic [3:0]  mem_be_o,
    output logic [31:0] mem_addr_o,
    output logic [31:0] mem_wd_o
);

import riscv_pkg::*;

assign mem_req_o  = core_req_i;
assign mem_we_o   = core_we_i;
assign mem_addr_o = core_addr_i;

logic [1:0] byte_offset;
logic       half_offset;

assign byte_offset = core_addr_i[1:0];
assign half_offset = core_addr_i[1];

always_comb begin
    case (core_size_i)
        LDST_W: mem_be_o = 4'b1111;
        LDST_H: mem_be_o = half_offset ? 4'b1100 : 4'b0011;
        LDST_B: mem_be_o = 4'b0001 << byte_offset;
        default:mem_be_o = 4'b1111;
    endcase
end

always_comb begin
    case (core_size_i)
        LDST_W: mem_wd_o = core_wd_i;
        LDST_H: mem_wd_o = {{2{core_wd_i[15:0]}}};
        LDST_B: mem_wd_o = {{4{core_wd_i[7:0]}}};
        default:mem_wd_o = core_wd_i;
    endcase
end

always_comb begin 
    case (core_size_i)
        LDST_W: core_rd_o = mem_rd_i;
        LDST_H: core_rd_o = half_offset ? {{16{mem_rd_i[31]}}, mem_rd_i[31:16]} : {{16{mem_rd_i[15]}}, mem_rd_i[15:0]};
        LDST_B: begin
                    case (byte_offset)
                        0: core_rd_o = {{24{mem_rd_i[7]}}, mem_rd_i[7:0]};
                        1: core_rd_o = {{24{mem_rd_i[15]}}, mem_rd_i[15:8]};
                        2: core_rd_o = {{24{mem_rd_i[23]}}, mem_rd_i[23:16]};
                        3: core_rd_o = {{24{mem_rd_i[31]}}, mem_rd_i[31:24]};
                    endcase
                end
        LDST_HU: core_rd_o = half_offset ? {{16{1'b0}}, mem_rd_i[31:16]} : {{16{1'b0}}, mem_rd_i[15:0]} ;
        LDST_BU: begin
                    case (byte_offset)
                        0: core_rd_o = {{24{1'b0}}, mem_rd_i[7:0]};
                        1: core_rd_o = {{24{1'b0}}, mem_rd_i[15:8]};
                        2: core_rd_o = {{24{1'b0}}, mem_rd_i[23:16]};
                        3: core_rd_o = {{24{1'b0}}, mem_rd_i[31:24]};
                    endcase
                end
        default: core_rd_o = mem_rd_i;
    endcase
end

logic stall_reg;
logic stall;

assign stall = ((~(stall_reg & mem_ready_i)) & core_req_i);

always_ff @(posedge clk_i) begin
    if (rst_i) stall_reg <= 0;
    else stall_reg <= stall;
end

assign core_stall_o = stall;
    
endmodule
