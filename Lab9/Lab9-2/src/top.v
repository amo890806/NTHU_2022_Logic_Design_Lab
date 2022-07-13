module top (
    input clk,
    input rst,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output Hsync,
    output Vsync,
    inout PS2_CLK,
    inout PS2_DATA
);

wire key_valid, key_down_onepulse, press_num, press_asm, press_enter;
wire [1:0] press_num_cnt;
wire [8:0] last_change;
wire [511:0] key_down;
wire clk_1Hz, clk_10Hz, clk_100Hz, clk_2kHz, clk_25MHz, clk22;
wire [1:0] press_cnt, state;
wire reset_en;
wire [3:0] BCD;
wire [6:0] first_operand_binary, second_operand_binary;
wire [3:0] operator;
wire [14:0] result_binary;
wire [15:0] first_operand_BCD, second_operand_BCD, result_BCD;
wire valid;
wire [9:0] h_cnt; //640
wire [9:0] v_cnt;  //480
wire [15:0] pixel_addr, thousands_pixel_addr,hundreds_pixel_addr, tens_pixel_addr, digits_pixel_addr;
wire [11:0] data, pixel, vga_RGB;

clock_divisor cd1(
    .clk(clk), 
    .clk22(clk22),
    .clk_25MHz(clk_25MHz)
);

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
    .press_num(press_num),
    .press_asm(press_asm),
    .press_enter(press_enter),
    .press_num_cnt(press_num_cnt),
    .state(state),
    .reset_en(reset_en)
);

last_change_decoder lcd1(
    .clk(clk),
    .rst(rst),
    .state(state),
    .press_num(press_num),
    .press_asm(press_asm),
    .press_enter(press_enter),
    .key_down_onepulse(key_down_onepulse),
    .last_change(last_change),
    .BCD(BCD)
);

calculator cal1(
    .clk(clk),
    .rst(rst),
    .state(state),
    .key_down_onepulse(key_down_onepulse),
    .press_num(press_num),
    .press_asm(press_asm),
    .press_enter(press_enter),
    .press_num_cnt(press_num_cnt),
    .BCD(BCD),
    .reset_en(reset_en),
    .first_operand_binary(first_operand_binary), 
    .second_operand_binary(second_operand_binary),
    .operator(operator),
    .result_binary(result_binary)
);

bin2bcd b1(
    .binary(first_operand_binary),
    .BCD(first_operand_BCD)
);

bin2bcd b2(
    .binary(second_operand_binary),
    .BCD(second_operand_BCD)
);

bin2bcd b3(
    .binary(result_binary),
    .BCD(result_BCD)
);

vga_controller   vga_inst(
    .pclk(clk_25MHz),
    .reset(rst),
    .Hsync(Hsync),
    .Vsync(Vsync),
    .valid(valid),
    .h_cnt(h_cnt),
    .v_cnt(v_cnt)
);

mem_addr_gen mag1(
    .clk(clk22),
    .rst(rst),
    .press_num_cnt(press_num_cnt),
    .state(state),
    .h_cnt(h_cnt),
    .v_cnt(v_cnt),
    .first_operand_BCD(first_operand_BCD),
    .second_operand_BCD(second_operand_BCD),
    .operator(operator),
    .result_BCD(result_BCD),
    .thousands_pixel_addr(thousands_pixel_addr),
    .hundreds_pixel_addr(hundreds_pixel_addr),
    .tens_pixel_addr(tens_pixel_addr),
    .digits_pixel_addr(digits_pixel_addr)
);

mem_addr_mux m1(
    .h_cnt(h_cnt),
    .thousands_pixel_addr(thousands_pixel_addr),
    .hundreds_pixel_addr(hundreds_pixel_addr),
    .tens_pixel_addr(tens_pixel_addr),
    .digits_pixel_addr(digits_pixel_addr),
    .pixel_addr(pixel_addr)
);

blk_mem_gen_0 bmg1(
    .clka(clk_25MHz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data),
    .douta(pixel)
);

vga_display_mux m2(
    .valid(valid),
    .pixel(pixel),
    .vga_RGB(vga_RGB)
);

assign {vgaRed, vgaGreen, vgaBlue} = vga_RGB;
    
endmodule