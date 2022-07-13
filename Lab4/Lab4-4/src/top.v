module top (
    input clk,
    input rst_n,
    output [7:0] display,
    output [3:0] ctrl
);

wire clk_div, clk_div_ssd;
wire [3:0] tens_BCD, digits_BCD;

frequency_divider_1Hz d1(
    .clk(clk),
    .rst_n(rst_n),
    .clk_div(clk_div),
    .clk_div_ssd(clk_div_ssd)
);

BCD_up_counter c1(
    .clk(clk_div),
    .rst_n(rst_n),
    .tens_BCD(tens_BCD),
    .digits_BCD(digits_BCD)
);

seven_segment_display_decoder ssd1(
    .clk(clk_div_ssd),
    .rst_n(rst_n),
    .tens_BCD(tens_BCD),
    .digits_BCD(digits_BCD),
    .display(display),
    .ctrl(ctrl)
);
    
endmodule