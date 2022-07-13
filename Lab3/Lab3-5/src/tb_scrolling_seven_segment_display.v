`timescale 1ns/10ps
`define cycle 10

module tb_scrolling_seven_segment_display ();
    
    reg clk, rst_n;
    wire [7:0] display;
    wire [3:0] ctrl;

    scrolling_seven_segment_display d1(
        .clk(clk),
        .rst_n(rst_n),
        .display(display),
        .ctrl(ctrl)
    );

    always #(`cycle/2) clk = ~clk;

    initial begin
        clk=0; rst_n=0;
        #13 rst_n=1;
        #30000 $finish;
    end

    initial begin
        $dumpfile("scrolling_seven_segment_display.vcd");
        $dumpvars;
    end

endmodule