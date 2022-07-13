module ring_counter (
    input clk,
    input rst_n,
    output reg [7:0] counter
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        counter <= 8'b01010101;
    end
    else begin
        counter <= {counter[6:0], counter[7]};
    end
end
    
endmodule