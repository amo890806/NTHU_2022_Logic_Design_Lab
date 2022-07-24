module random_number_generator (
    input clk,
    input rst,
    output [2:0] random
);

reg [2:0] Q;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        Q <= 3'b001;
    end
    else begin
        Q <= {Q[1:0], Q[2]^Q[1]};
    end
end

assign random = (Q%7)+1;
    
endmodule