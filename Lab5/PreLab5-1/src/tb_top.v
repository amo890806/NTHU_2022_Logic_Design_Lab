`timescale 1ns/10ps
`define cycle 10

module tb_top ();

    reg clk, rst_n;
    reg [1:0] btn;
    wire [15:0] led;

    top t1(
        .clk(clk), 
        .rst_n(rst_n),
        .btn(btn),
        .led(led)
    );
    
    always #(`cycle/2) clk = ~clk;

    initial begin
        clk=0; rst_n=0; btn=2'b00;
        #13 rst_n = 1;
        #600 btn = 2'b01;   //pause
        #100 btn = 2'b10;   //reset
        #100 btn = 2'b01;   //start
        #200 btn = 2'b10;   //reset
        #1000 $finish;
    end

    initial begin
        $dumpfile("down_counter.vcd");
        $dumpvars;
    end



endmodule