module top (
    input clk,
    input rst_n,
    output [7:0] display,
    output [3:0] ctrl
);

wire clk_div;
wire [3:0] BCD;

frequency_divider_500mHz d1(
    .clk(clk),
    .rst_n(rst_n),
    .clk_div(clk_div)
);

BCD_down_counter c1(
    .clk(clk_div),
    .rst_n(rst_n),
    .BCD(BCD)
);

seven_segment_display_decoder ssd1(
    .BCD(BCD), 
    .display(display),
    .ctrl(ctrl)
);
    
endmodule