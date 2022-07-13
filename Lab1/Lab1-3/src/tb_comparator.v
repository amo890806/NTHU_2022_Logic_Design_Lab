`timescale 1ns/10ps

module tb_comparator ();

    reg signed [2:0] A, B;
    wire [2:0] result;

    comparator c1(
        .A(A),
        .B(B),
        .result(result)
    );

    initial begin
        //2bit presicion: -4~3
        A=3'b000; B=3'b000;
        #10 A=3'b011; B=3'b010; //3, 2
        #10 A=3'b001; B=3'b111; //1, -1
        #10 A=3'b100; B=3'b011; //-4, 3
        #10 A=3'b101; B=3'b110; //-3, -2
        #10 $finish;
    end

    initial begin
        $dumpfile("comparator.vcd");
        $dumpvars;
    end

    
endmodule