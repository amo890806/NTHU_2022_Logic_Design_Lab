`timescale 1ns/10ps

module tb_fulladder ();

    reg A, B, Cin;
    wire S, Cout;

    fulladder f1(
        .A(A), 
        .B(B),
        .Cin(Cin),
        .S(S),
        .Cout(Cout)
    );

    initial begin
        A=0; B=0; Cin=0;
        #10 A=0; B=1; Cin=0;
        #10 A=1; B=0; Cin=0;
        #10 A=1; B=1; Cin=0;
        #10 A=0; B=0; Cin=1;
        #10 A=0; B=1; Cin=1;
        #10 A=1; B=0; Cin=1;
        #10 A=1; B=1; Cin=1;
        #10 $finish;
    end

    initial begin
        $dumpfile("fulladdr.vcd");
        $dumpvars;
    end
    
endmodule