module four_bit_counter (
    input clk,
    input rst_n,
    output reg [3:0] counter
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        counter <= 0;
    end
    else begin
        counter <= (counter == 4'hF) ? 0 : counter+1;
    end
end
    
endmodule