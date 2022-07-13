`timescale 1ns/10ps
`define cycle 10

module tb_speak_control ();
    
    reg clk, rst_n;
    reg [15:0] audio_in_left, audio_in_right;
    wire audio_mclk, audio_lrck, audio_sck, audio_sdin;

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

    always #(`cycle/2) clk = ~clk;

    initial begin
        clk=0; rst_n=0;
        #13 rst_n=1;
        #10 audio_in_left=16'hB000 ; audio_in_right=16'h5FFF;
        #100000  $finish;
    end

    initial begin
        $dumpfile("speak_control.vcd");
        $dumpvars;
    end

endmodule