module top (
    input clk, 
    input rst_n,
    output [7:0] display,
    output [3:0] ctrl
);

wire clk_div, clk_div_ssd;

frequency_divider_1Hz d1(
    .clk(clk),
    .rst_n(rst_n),
    .clk_div(clk_div),
    .clk_div_ssd(clk_div_ssd)
);

scrolling_seven_segment_display ssd1( 
    .clk(clk_div),
    .clk_div_ssd(clk_div_ssd),
    .rst_n(rst_n),
    .display(display),
    .ctrl(ctrl)
);

endmodule