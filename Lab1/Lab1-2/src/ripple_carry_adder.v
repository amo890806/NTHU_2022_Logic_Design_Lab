`include "fulladder.v"

module ripple_carry_adder (
    input [3:0 ]A,
    input [3:0] B,
    input op,
    output [3:0] Sum,
    output overflow
);

wire [3:0] B_comp;
assign B_comp = {B[3]^op, B[2]^op, B[1]^op, B[0]^op};
wire Cin;
assign Cin = op;
wire [3:0] Cout;

fulladder f0(
    .A(A[0]), 
    .B(B_comp[0]), 
    .Cin(Cin), 
    .S(Sum[0]), 
    .Cout(Cout[0])
);

fulladder f1(
    .A(A[1]), 
    .B(B_comp[1]), 
    .Cin(Cout[0]), 
    .S(Sum[1]), 
    .Cout(Cout[1])
);

fulladder f2(
    .A(A[2]), 
    .B(B_comp[2]), 
    .Cin(Cout[1]), 
    .S(Sum[2]), 
    .Cout(Cout[2])
);

fulladder f3(
    .A(A[3]), 
    .B(B_comp[3]), 
    .Cin(Cout[2]), 
    .S(Sum[3]), 
    .Cout(Cout[3])
);
    
assign overflow = Cout[2]^Cout[3];

endmodule