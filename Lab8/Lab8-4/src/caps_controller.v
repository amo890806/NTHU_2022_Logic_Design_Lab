`define SHIFT_L 9'h0_12
`define SHIFT_R 9'h0_59 

module caps_controller (
    input clk,
    input rst,
    output [7:0] led,
    inout PS2_CLK,
    inout PS2_DATA
);

wire key_valid, load, key_down_onepulse;
wire [8:0] last_change;
wire [511:0] key_down;
wire caps;
wire [6:0] ASCII_code;
wire press_shift = key_down[`SHIFT_L] || key_down[`SHIFT_R];
wire press_letter = key_down[9'h0_1C] || key_down[9'h0_32] || key_down[9'h0_21] ||
                    key_down[9'h0_23] || key_down[9'h0_24] || key_down[9'h0_2B] ||
                    key_down[9'h0_34] || key_down[9'h0_33] || key_down[9'h0_43] ||
                    key_down[9'h0_3B] || key_down[9'h0_42] || key_down[9'h0_4B] ||
                    key_down[9'h0_3A] || key_down[9'h0_31] || key_down[9'h0_44] ||
                    key_down[9'h0_4D] || key_down[9'h0_15] || key_down[9'h0_2D] ||
                    key_down[9'h0_1B] || key_down[9'h0_2C] || key_down[9'h0_3C] ||
                    key_down[9'h0_2A] || key_down[9'h0_1D] || key_down[9'h0_22] ||
                    key_down[9'h0_35] || key_down[9'h0_1A] ;

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
    .press_shift(press_shift),
    .caps(caps),
    .caps_sel(caps_sel)
);

last_change_decoder lcd1(
    .last_change(last_change),
    .press_letter(press_letter),
    .caps_sel(caps_sel),
    .ASCII_code(ASCII_code)
);

assign led = {caps, ASCII_code};
    
endmodule