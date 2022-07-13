`timescale 1ns/10ps
`define cycle 10

module tb_four_bit_counter ();

    reg clk, rst_n;
    wire [3:0] counter;

    four_bit_counter c1(
        .clk(clk),
        .rst_n(rst_n),
        .counter(counter)
    );

    always #(`cycle/2)  clk = ~clk;

    initial begin
        clk=0; rst_n=0;
        #13 rst_n = 1;
        #300  $finish;
    end

    initial begin
        $dumpfile("four_bit_counter.vcd");
        $dumpvars;
    end
    
endmodule