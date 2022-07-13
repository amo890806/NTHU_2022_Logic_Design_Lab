`timescale 1ns/10ps
`define cycle 10

module tb_frequency_divider_1Hz ();

    reg clk, rst_n;
    wire clk_div;

    frequency_divider_1Hz d1(
        .clk(clk),
        .rst_n(rst_n),
        .clk_div(clk_div)
    );

    always #(`cycle/2) clk = ~clk;

    initial begin
        clk=0; rst_n=0;
        #13 rst_n=1;
        #10000  $finish;
    end

    initial begin
        $dumpfile("frequency_divider_1Hz.vcd");
        $dumpvars;
    end
    
endmodule