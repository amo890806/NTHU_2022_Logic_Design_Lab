module top (
    input clk,
    input rst_n,
    input [4:0] btn,
    input sw,
    output audio_mclk,
    output audio_lrck,
    output audio_sck,
    output audio_sdin
);

wire [4:0] push_debounced;
wire [15:0] vol_high, vol_low;
wire [21:0] note_div_left, note_div_right;

frequency_divider_1Hz fd1(
    .clk(clk),
    .rst_n(rst_n),
    .clk_1Hz(clk_1Hz), 
    .clk_10Hz(clk_10Hz),
    .clk_100Hz(clk_100Hz), 
    .clk_2kHz(clk_2kHz)
);

debounce d1(
    .clk(clk_100Hz),
    .rst_n(rst_n),
    .btn(btn[0]),
    .push_debounced(push_debounced[0])
);

debounce d2(
    .clk(clk_100Hz),
    .rst_n(rst_n),
    .btn(btn[1]),
    .push_debounced(push_debounced[1])
);

debounce d3(
    .clk(clk_100Hz),
    .rst_n(rst_n),
    .btn(btn[2]),
    .push_debounced(push_debounced[2])
);

debounce d4(
    .clk(clk_100Hz),
    .rst_n(rst_n),
    .btn(btn[3]),
    .push_debounced(push_debounced[3])
);

debounce d5(
    .clk(clk_100Hz),
    .rst_n(rst_n),
    .btn(btn[4]),
    .push_debounced(push_debounced[4])
);

note_control nc1(
    .Mid_Do_Mi(push_debounced[0]),
    .Mid_Re_Fa(push_debounced[1]),
    .Mid_Mi_So(push_debounced[2]),
    .Mid_Fa_La(push_debounced[3]),
    .Mid_So_Si(push_debounced[4]),
    .mode(sw),
    .note_div_left(note_div_left),
    .note_div_right(note_div_right)
);

speaker s1(
    .clk(clk),
    .rst_n(rst_n),
    .note_div_left(note_div_left),
    .note_div_right(note_div_right),
    .audio_mclk(audio_mclk),
    .audio_lrck(audio_lrck),
    .audio_sck(audio_sck),
    .audio_sdin(audio_sdin)
);
    
endmodule