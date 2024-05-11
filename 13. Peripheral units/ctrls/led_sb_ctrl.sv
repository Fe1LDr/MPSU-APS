module led_sb_ctrl(
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic        req_i,
    input  logic        write_enable_i,
    input  logic [31:0] addr_i,
    input  logic [31:0] write_data_i,
    
    output logic [31:0] read_data_o,
    
    output logic [15:0] led_o
);

logic [15:0] led_val;
logic        led_mode;
logic [32:0] cntr;
logic [32:0] rd;

logic  read_req;
logic  write_req;
logic  is_val_addr;
logic  is_mode_addr;
logic  is_rst_addr;
logic  val_valid;
logic  mode_valid;
logic  rst_valid;
logic  rst;
logic  val_en;
logic  mode_en;

assign read_req     = req_i & ~write_enable_i;
assign write_req    = req_i &  write_enable_i;
assign is_val_addr  = (addr_i == 32'h0);
assign is_mode_addr = (addr_i == 32'h4);
assign is_rst_addr  = (addr_i == 32'h24);
assign val_valid    = (write_data_i <= 32'hffff);
assign mode_valid   = (write_data_i <  32'd2);
assign rst_valid    = (write_data_i == 32'd1);
assign rst          = rst_i | (rst_valid & write_req & is_rst_addr);
assign val_en       = (val_valid  & write_req & is_val_addr);
assign mode_en      = (mode_valid & write_req & is_mode_addr);

always_ff @(posedge clk_i) begin 
    if (rst) led_val <= 0;
    else if (val_en) led_val <= write_data_i[15:0];
end

always_ff @(posedge clk_i) begin 
    if (rst) led_mode <= 0;
    else if (mode_en) led_mode <= write_data_i[0];
end

always_ff @(posedge clk_i) begin
    if (rst | ~(led_mode) | (cntr >= 32'd20_000_000)) cntr <= 32'd0;
    else cntr <= cntr + 32'd1;
end

always_ff @(posedge clk_i) begin
    if (cntr < 32'd10_000_000) led_o = led_val;
    else led_o = 16'd0;    
end

always_ff @(posedge clk_i) begin
    if (rst) rd <= 32'd0;
    else if (read_req & (is_val_addr | is_mode_addr)) begin
            if (is_val_addr) rd <= {16'd0, led_val};
            else rd <= {31'd0, led_mode};
    end
end

assign read_data_o = rd;
    
endmodule