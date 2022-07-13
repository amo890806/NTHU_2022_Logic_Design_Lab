`timescale 1ns/10ps

module tb_bulls_and_cows ();

    reg [7:0] secret, guess;
    wire [2:0] bulls, cows;

    bulls_and_cows b1(
        .secret(secret),
        .guess(guess),
        .bulls(bulls),
        .cows(cows)
    );

    initial begin
        secret=8'b00000000; guess=8'b00000000;      //0, 0, bulls=0, cows=0
        #10 secret=8'b10011000; guess=8'b01100100;      //98, 64, bulls=0, cows=0
        #10 secret=8'b10011000; guess=8'b00101001;      //98, 29, bulls=0, cows=1
        #10 secret=8'b10011000; guess=8'b10001001;      //98, 89, bulls=0, cows=2
        #10 secret=8'b10011000; guess=8'b10010011;      //98, 93, bulls=1, cows=0
        #10 secret=8'b10011000; guess=8'b10011001;      //98, 99, bulls=0, cows=0
        #10 secret=8'b10011000; guess=8'b10011000;      //98, 98, bulls=2, cows=0
        #10 $finish;
    end

    initial begin
        $dumpfile("bulls_and_cows.vcd");
        $dumpvars;
    end

    
endmodule