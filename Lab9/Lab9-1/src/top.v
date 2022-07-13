module top (
    input clk,
    input rst,
    input en,
    output [3:0] vga_Red,
    output [3:0] vga_Green,
    output [3:0] vga_Blue,
    output hsync,
    output vsync
);

wire clk22, clk_25MHz;
wire clk_1Hz, clk_10Hz, clk_100Hz, clk_2kHz;
wire push_debounced, push_onepulse;
wire scroll_en, valid;
wire [9:0] h_cnt, v_cnt;
wire [16:0] pixel_addr;
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

debounce d1(
    .clk(clk_100Hz),
    .rst(rst),
    .en(en),
    .push_debounced(push_debounced)
);

one_pulse p1(
    .clk(clk_10Hz),
    .rst(rst),
    .push_debounced(push_debounced),
    .push_onepulse(push_onepulse)
);

controller c1(
    .clk(clk_10Hz),
    .rst(rst),
    .push_onepulse(push_onepulse),
    .scroll_en(scroll_en)
);

vga_controller vc1(
    .pclk(clk_25MHz),
    .reset(rst),
    .hsync(hsync),
    .vsync(vsync),
    .valid(valid),
    .h_cnt(h_cnt),
    .v_cnt(v_cnt)
);

mem_addr_gen mag1(
    .clk(clk22),
    .rst(rst),
    .scroll_en(scroll_en),
    .h_cnt(h_cnt),
    .v_cnt(v_cnt),
    .pixel_addr(pixel_addr)
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

assign {vga_Red, vga_Green, vga_Blue} = vga_RGB;
    
endmodule