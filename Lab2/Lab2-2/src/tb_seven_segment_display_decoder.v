`timescale 1ns/10ps

module tb_seven_segment_display_decoder ();

    reg [3:0] binary;
    wire [7:0] display;
    wire ctrl;
    wire [3:0] led;

    seven_segment_display_decoder s1(
        .binary(binary), 
        .display(display),
        .ctrl(ctrl),
        .led(led)
    );

    initial begin
        binary = 4'h0;
        #10 binary = 4'h1;
        #10 binary = 4'h2;
        #10 binary = 4'h3;
        #10 binary = 4'h4;
        #10 binary = 4'h5;
        #10 binary = 4'h6;
        #10 binary = 4'h7;
        #10 binary = 4'h8;
        #10 binary = 4'h9;
        #10 binary = 4'hA;
        #10 binary = 4'hB;
        #10 binary = 4'hC;
        #10 binary = 4'hD;
        #10 binary = 4'hE;
        #10 binary = 4'hF;
        #10 $finish;
    end

    initial begin
        $dumpfile("seven_segment_display_decoder.vcd");
        $dumpvars;
    end

endmodule