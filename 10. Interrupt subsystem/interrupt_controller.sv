module interrupt_controller(
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic        exception_i,
    input  logic        irq_req_i,
    input  logic        mie_i,
    input  logic        mret_i,
    
    output logic        irq_ret_o,
    output logic [31:0] irq_cause_o,
    output logic        irq_o
);

logic exc_h;
logic irq_h;

logic exc_exception;

assign exc_exception = exception_i ^ exc_h;

assign irq_o = (irq_req_i & mie_i) & ~(exc_exception | irq_h);

always_ff @(posedge clk_i) begin
    if (rst_i) exc_h <= 0;
    else       exc_h <= exc_exception & ~(mret_i);
end

always_ff @(posedge clk_i) begin
    if (rst_i) irq_h <= 0;
    else       irq_h <= ~(~exc_exception & mret_i) & (irq_h | irq_o);
end

assign irq_ret_o   = ~exc_exception & mret_i;
assign irq_cause_o = 32'h80000010;
    
endmodule