module keyboard (
    input clk,
    input rst,
    output [7:0] display,
    output [3:0] ctrl,
    inout PS2_CLK,
    inout PS2_DATA
);

wire key_valid;
wire [8:0] last_change;
wire [511:0] key_down;

KeyboardDecoder KD1(
	.clk(clk),
	.rst(rst),
    .key_down(key_down),
	.last_change(last_change),
	.key_valid(key_valid),
	.PS2_CLK(PS2_CLK),
	.PS2_DATA(PS2_DATA)
);

seven_segment_display_decoder ssd1(
    .clk(clk),
    .rst(rst),
    .last_change(last_change), 
    .display(display),
    .ctrl(ctrl)
);
    
endmodule