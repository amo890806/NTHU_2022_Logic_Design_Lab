`include "frequency_divider.v"
`include "parallel_to_serial.v"

module speak_control (
    input clk,
    input rst_n,
    input [15:0] audio_in_left,
    input [15:0] audio_in_right,
    output audio_mclk,
    output audio_lrck,
    output audio_sck,
    output audio_sdin
);

wire audio_lrck, audio_sck;

frequency_divider fd1(
    .clk(clk),
    .rst_n(rst_n),
    .audio_mclk(audio_mclk),  
    .audio_lrck(audio_lrck),  
    .audio_sck(audio_sck)    
);

parallel_to_serial ps1(
    .audio_lrck(audio_lrck),
    .audio_sck(audio_sck),
    .rst_n(rst_n),
    .audio_in_left(audio_in_left),
    .audio_in_right(audio_in_right),
    .audio_sdin(audio_sdin)
);
    
endmodule