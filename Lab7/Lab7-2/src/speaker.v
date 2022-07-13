module speaker (
    input clk,
    input rst_n,
    input [21:0] note_div,
    input [15:0] vol_high,
    input [15:0] vol_low,
    output audio_mclk,
    output audio_lrck,
    output audio_sck,
    output audio_sdin
);

wire [15:0] audio_in_left, audio_in_right;

buzzer_control bc1(
    .clk(clk),
    .rst_n(rst_n),
    .note_div(note_div),
    .vol_high(vol_high),
    .vol_low(vol_low),
    .audio_in_left(audio_in_left),
    .audio_in_right(audio_in_right)
);

speak_control sc1(
    .clk(clk),
    .rst_n(rst_n),
    .audio_in_left(audio_in_left),
    .audio_in_right(audio_in_right),
    .audio_mclk(audio_mclk),
    .audio_lrck(audio_lrck),
    .audio_sck(audio_sck),
    .audio_sdin(audio_sdin)
);

    
endmodule
