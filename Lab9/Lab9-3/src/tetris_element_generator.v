module tetris_element_generator (
    input clk,
    input rst,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output Hsync,
    output Vsync,
    output [7:0] led
);

wire clk_1Hz, clk_10Hz, clk_100Hz, clk_2kHz;
wire [11:0] data;
wire clk_25MHz;
wire clk_22;
wire [12:0] pixel_addr;
wire [11:0] pixel, vga_RGB;
wire valid;
wire [9:0] h_cnt; //640
wire [9:0] v_cnt;  //480
wire [2:0] random;
wire [2:0] random_led;
wire [4:0] cnt_led;

assign led = {random_led, cnt_led};

frequency_divider fd1(
    .clk(clk),
    .rst(rst),
    .clk_1Hz(clk_1Hz), 
    .clk_10Hz(clk_10Hz), 
    .clk_100Hz(clk_100Hz),
    .clk_2kHz(clk_2kHz)
);

clock_divisor cd1(
    .clk(clk), 
    .clk22(clk22),
    .clk_25MHz(clk_25MHz)
);

vga_controller vc1(
    .pclk(clk_25MHz),
    .reset(rst),
    .Hsync(Hsync),
    .Vsync(Vsync),
    .valid(valid),
    .h_cnt(h_cnt),
    .v_cnt(v_cnt)
);

random_number_generator rng1(
    .clk(clk_1Hz),
    .rst(rst),
    .random(random)
);

mem_addr_gen mag1(
    .clk(clk_1Hz),
    .rst(rst),
    .h_cnt(h_cnt),
    .v_cnt(v_cnt),
    .random(random),
    .pixel_addr(pixel_addr),
    .random_led(random_led),
    .cnt_led(cnt_led)
);

blk_mem_gen_0 bmg1(
    .clka(clk_25MHz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data),
    .douta(pixel)
);

vga_display_mux m1(
    .valid(valid),
    .pixel(pixel),
    .vga_RGB(vga_RGB)
);

assign {vgaRed, vgaGreen, vgaBlue} = vga_RGB;
    
endmodule