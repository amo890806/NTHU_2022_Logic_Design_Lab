module top (
    input clk,
    input rst_n,
    input [4:0] btn,
    output audio_mclk,
    output audio_lrck,
    output audio_sck,
    output audio_sdin,
    output [7:0] display,
    output [3:0] ctrl
);

wire clk_1Hz, clk_10Hz, clk_100Hz, clk_2kHz;
wire [4:0] push_debounced;
wire [1:0] push_onepulse;
wire [21:0] note_div;
wire [15:0] vol_high, vol_low;
wire [3:0] binary;

frequency_divider_1Hz fd1(
    .clk(clk),
    .rst_n(rst_n),
    .clk_1Hz(clk_1Hz), 
    .clk_10Hz(clk_10Hz),
    .clk_100Hz(clk_100Hz), 
    .clk_2kHz(clk_2kHz)
);

debounce d1(        //Do
    .clk(clk_100Hz),
    .rst_n(rst_n),
    .btn(btn[0]),
    .push_debounced(push_debounced[0])
);

debounce d2(        //Re
    .clk(clk_100Hz),
    .rst_n(rst_n),
    .btn(btn[1]),
    .push_debounced(push_debounced[1])
);

debounce d3(        //Mi
    .clk(clk_100Hz),
    .rst_n(rst_n),
    .btn(btn[2]),
    .push_debounced(push_debounced[2])
);

debounce d4(        //Volume up
    .clk(clk_100Hz),
    .rst_n(rst_n),
    .btn(btn[3]),
    .push_debounced(push_debounced[3])
);

one_pulse p4(
    .clk(clk_10Hz),
    .rst_n(rst_n),
    .push_debounced(push_debounced[3]),
    .push_onepulse(push_onepulse[0])
);

debounce d5(        //Volume down
    .clk(clk_100Hz),
    .rst_n(rst_n),
    .btn(btn[4]),
    .push_debounced(push_debounced[4])
);

one_pulse p5(
    .clk(clk_10Hz),
    .rst_n(rst_n),
    .push_debounced(push_debounced[4]),
    .push_onepulse(push_onepulse[1])
);

note_decoder nd1(
    .Mid_Do(push_debounced[0]),
    .Mid_Re(push_debounced[1]),
    .Mid_Mi(push_debounced[2]),
    .note_div(note_div) 
);

volumn_decoder vd1(
    .clk(clk_10Hz),
    .rst_n(rst_n),
    .inc(push_onepulse[0]),
    .dec(push_onepulse[1]),
    .vol_high(vol_high),
    .vol_low(vol_low),
    .binary(binary)
);

speaker s1(
    .clk(clk),
    .rst_n(rst_n),
    .note_div(note_div),
    .vol_high(vol_high),
    .vol_low(vol_low),
    .audio_mclk(audio_mclk),
    .audio_lrck(audio_lrck),
    .audio_sck(audio_sck),
    .audio_sdin(audio_sdin)
);

seven_segment_display_decoder ssd1(
    .binary(binary),
    .display(display),
    .ctrl(ctrl)
);
    
endmodule
