module top (
    input clk,
    input rst_n, 
    output [3:0] binary
);

wire clk_div;

frequency_divider_1Hz d1(
    .clk(clk),
    .rst_n(rst_n),
    .clk_div(clk_div)
);

binary_down_counter c1(
    .clk(clk_div),
    .rst_n(rst_n),
    .binary(binary)
);
    
endmodule