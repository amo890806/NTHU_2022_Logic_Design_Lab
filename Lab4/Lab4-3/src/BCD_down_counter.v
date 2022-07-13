module BCD_down_counter (
    input clk,
    input rst_n,
    output reg [3:0] BCD
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        BCD <= 4'd9;
    end
    else begin
        BCD <= (BCD == 0) ? 4'd9 : BCD-1;
    end
end
    
endmodule