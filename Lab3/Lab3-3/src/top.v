module top (
    input clk,
    input rst_n,
    output [3:0] counter
);

wire clk_div;

frequency_divider d1(
    .clk(clk),
    .rst_n(rst_n),
    .clk_div(clk_div)
);

four_bit_counter c1(
    .clk(clk_div),
    .rst_n(rst_n),
    .counter(counter)
);

    
endmodule