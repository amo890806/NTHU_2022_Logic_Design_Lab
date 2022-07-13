module frequency_divider (
    input clk,
    input rst_n,
    output clk_div
);

reg [26:0] counter;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        counter <= 0;
    end
    else begin
        counter <= (counter == 27'h7FFFFFF) ? 0 : counter+1;
    end
end

assign clk_div = counter[26];
    
endmodule