module binary_down_counter (
    input clk,
    input rst_n,
    output reg [3:0] binary
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        binary <= 4'hF;
    end
    else begin
        binary <= (binary == 0) ? 4'hF : binary-1;
    end
end
    
endmodule