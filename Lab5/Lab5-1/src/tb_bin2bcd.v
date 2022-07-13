`timescale 1ns/10ps
`define cycle 10

module tb_bin2bcd ();

    reg [5:0] binary;
    wire [3:0] tens_BCD, digits_BCD;

    bin2bcd bb1(
        .binary(binary),
        .tens_BCD(tens_BCD),
        .digits_BCD(digits_BCD)
    );

    initial begin
        binary = 40;
        #10 binary = 39;
        #10 binary = 38;
        #10 $finish;
    end

    initial begin
        $dumpfile("bin2bcd.vcd");
        $dumpvars;
    end



endmodule