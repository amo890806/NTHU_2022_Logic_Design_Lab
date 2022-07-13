`timescale 1ns/10ps

module tb_ripple_carry_adder ();

    reg [3:0] A, B; 
    reg op;
    wire [3:0] Sum; 
    wire overflow;

    ripple_carry_adder r1(
        .A(A), 
        .B(B),
        .op(op),
        .Sum(Sum),
        .overflow(overflow)
    );

    initial begin
        //3bit presicion: -8~7
        A=4'b0100; B=4'b0011; op=0;        //4+3=7, overflow=0
        #10 A=4'b0111; B=4'b1110; op=0;    //7+(-2)=5, overflow=0
        #10 A=4'b0111; B=4'b0010; op=0;    //7+2=9, overflow=1
        #10 A=4'b1010; B=4'b0010; op=1;    //-6-2=-8, overflow=0
        #10 A=4'b1011; B=4'b1100; op=1;    //-5-(-4)=-1, overflow=0
        #10 A=4'b1011; B=4'b0100; op=1;    //-5-4=-9, overflow=1
        #10 $finish;
    end

    initial begin
        $dumpfile("ripple_carry_adder.vcd");
        $dumpvars;
    end
    
endmodule