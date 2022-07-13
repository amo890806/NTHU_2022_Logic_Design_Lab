module top (
    input clk, 
    input rst_n,
    input rst,
    input btn,
    output [15:0] led,
    output [7:0] display,
    output [3:0] ctrl
);

wire clk_div, clk_div_ssd, clk_div_btn, count_en;
wire push_debounced;
wire push_onepulse;
wire [5:0] binary;
wire [3:0] tens_BCD, digits_BCD;

frequency_divider_1Hz fd1(
    .clk(clk),
    .rst_n(!rst_n),
    .clk_div(clk_div),
    .clk_div_ssd(clk_div_ssd),
    .clk_div_btn(clk_div_btn)
);

debounce d1(
    .clk(clk_div_btn),
    .rst_n(!rst_n),
    .btn(btn),
    .push_debounced(push_debounced)
);

one_pulse p1(
    .clk(clk_div_btn),
    .rst_n(!rst_n),
    .push_debounced(push_debounced),
    .push_onepulse(push_onepulse)
);

controller c1(
    .clk(clk_div_btn),
    .rst_n(!rst_n),
    .rst(!rst),
    .push_onepulse(push_onepulse),
    .count_en(count_en)
);

down_counter dc1(
    .clk(clk_div),
    .rst_n(!rst_n),
    .count_en(count_en),
    .binary(binary),
    .led(led)
);

bin2bcd b1(
    .binary(binary),
    .tens_BCD(tens_BCD),
    .digits_BCD(digits_BCD)
);

seven_segment_display_control ssc1(
    .clk(clk_div_ssd),
    .rst_n(!rst_n),
    .tens_BCD(tens_BCD),
    .digits_BCD(digits_BCD),
    .display(display),
    .ctrl(ctrl)
);
    
endmodule