module top (
    input clk, 
    input rst_n,
    output [7:0] counter
);

wire clk_div;

frequency_divider_1Hz d1(
    .clk(clk),
    .rst_n(rst_n),
    .clk_div(clk_div)
);

ring_counter c1( 
    .clk(clk_div),
    .rst_n(rst_n),
    .counter(counter)
);

endmodule