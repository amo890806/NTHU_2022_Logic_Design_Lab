`timescale 1ns/10ps
`define cycle 10

module tb_top ();

    reg clk, rst_n;
    wire [7:0] counter;

    top t1(
        .clk(clk),
        .rst_n(rst_n),
        .counter(counter)
    );

    always #(`cycle/2) clk = ~clk;

    initial begin
        clk=0; rst_n=0;
        #13 rst_n = 1;
        #300  $finish;
    end

    initial begin
        $dumpfile("ring_counter.vcd");
        $dumpvars;
    end

endmodule