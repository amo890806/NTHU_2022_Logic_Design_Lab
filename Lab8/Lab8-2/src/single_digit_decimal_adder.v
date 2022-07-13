module single_digit_decimal_adder (
    input clk,
    input rst,
    output [7:0] display,
    output [3:0] ctrl,
    inout PS2_CLK,
    inout PS2_DATA
);

wire key_valid, load, key_down_onepulse, press_num;
wire [8:0] last_change;
wire [511:0] key_down;
wire clk_1Hz, clk_10Hz, clk_100Hz, clk_2kHz;
wire [3:0] BCD, addend_BCD, augend_BCD;
wire [5:0] sum_binary;
wire [7:0] sum_BCD;

frequency_divider fd1(
    .clk(clk),
    .rst(rst),
    .clk_1Hz(clk_1Hz), 
    .clk_10Hz(clk_10Hz),
    .clk_100Hz(clk_100Hz),
    .clk_2kHz(clk_2kHz)
);

KeyboardDecoder KD1(
	.clk(clk),
	.rst(rst),
    .key_down(key_down),
	.last_change(last_change),
	.key_valid(key_valid),
	.PS2_CLK(PS2_CLK),
	.PS2_DATA(PS2_DATA)
);

OnePulse p1(
	.clock(clk),
	.signal(key_down[last_change]),
    .signal_single_pulse(key_down_onepulse)
);

controller c1(
    .clk(clk),
    .rst(rst),
    .last_change(last_change),
    .key_down_onepulse(key_down_onepulse),
    .load(load),
    .press_num(press_num)
);

last_change_decoder lcd1(
    .clk(clk),
    .rst(rst),
    .load(load),
    .press_num(press_num),
    .key_down_onepulse(key_down_onepulse),
    .last_change(last_change),
    .BCD(BCD)
);

adder a1(
    .clk(clk),
    .rst(rst),
    .load(load),
    .key_down_onepulse(key_down_onepulse),
    .BCD(BCD),
    .addend_BCD(addend_BCD),
    .augend_BCD(augend_BCD),
    .sum_binary(sum_binary)
);

bin2bcd b1(
    .sum_binary(sum_binary),
    .sum_BCD(sum_BCD)
);

seven_segment_display_controller ssd1(
    .clk(clk_2kHz),
    .rst(rst),
    .addend_BCD(addend_BCD),
    .augend_BCD(augend_BCD),
    .sum_BCD(sum_BCD),
    .display(display),
    .ctrl(ctrl)
);
    
endmodule