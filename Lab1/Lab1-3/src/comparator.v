module comparator (
    input signed [2:0] A,
    input signed [2:0] B,
    output [2:0] result
);

assign result = (A>B) ? A : B;
    
endmodule