`timescale 1ns/10ps
`define cycle 10

module tb_top ();

    reg clk, rst_n;
    wire [3:0] binary;

    top t1(
        .clk(clk),
        .rst_n(rst_n),
        .binary(binary)
    );

    always #(`cycle/2) clk = ~clk;

    initial begin
        clk=0; rst_n=0;
        #13 rst_n=1;
        #10000  $finish;
    end

    initial begin
        $dumpfile("binary_down_counter.vcd");
        $dumpvars;
    end

endmodule