module timer_sb_ctrl(
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic        req_i,
    input  logic        write_enable_i,
    input  logic [31:0] addr_i,
    input  logic [31:0] write_data_i,
    
    output logic [31:0] read_data_o,
    output logic        ready_o,
    
    output logic        interrupt_request_o
);

logic [63:0] system_counter;
logic [63:0] delay;
enum logic [1:0] {OFF, NTIMES, FOREVER} mode, next_mode;
logic [31:0] repeat_counter;
logic [63:0] system_counter_at_start;

always_ff @(posedge clk_i) begin
  if (rst_i) begin
    system_counter <= 0;
    delay <= 0;
    mode <= OFF;
    repeat_counter <= 0;
    system_counter_at_start <= 0;
  end else begin
    system_counter <= system_counter + 1;
    mode <= next_mode;
    if (req_i && write_enable_i) begin
      case (addr_i)
        32'h08: delay[31:0]  <= write_data_i;
        32'h0C: delay[63:32] <= write_data_i;
        32'h10: begin
          case (write_data_i)
            OFF:     mode <= OFF;
            NTIMES:  begin
              mode <= NTIMES;
              system_counter_at_start <= system_counter;
            end
            FOREVER: begin
              mode <= FOREVER;
              system_counter_at_start <= system_counter;
            end
          endcase
        end
        32'h14: repeat_counter <= write_data_i;
        32'h24: begin
          system_counter <= 0;
          delay <= 0;
          mode <= OFF;
          repeat_counter <= 0;
          system_counter_at_start <= 0;
        end
      endcase
    end
  end
end

always_comb begin
  ready_o = req_i;
  case (addr_i)
    32'h00:  read_data_o = system_counter[31:0];
    32'h04:  read_data_o = system_counter[63:32];
    32'h08:  read_data_o = delay[31:0];
    32'h0C:  read_data_o = delay[63:32];
    32'h10:  read_data_o = {30'b0, mode};
    32'h14:  read_data_o = repeat_counter;
    default: read_data_o = 32'h00;
  endcase
end

always_comb begin
  next_mode = mode;
  interrupt_request_o = 0;
  if (mode != OFF && system_counter - system_counter_at_start >= delay) begin
    interrupt_request_o = 1;
    system_counter_at_start = system_counter;
    if (mode == NTIMES) begin
      if (repeat_counter > 1) begin
        repeat_counter = repeat_counter - 1;
      end else begin
        next_mode = OFF;
      end
    end
  end
end

endmodule