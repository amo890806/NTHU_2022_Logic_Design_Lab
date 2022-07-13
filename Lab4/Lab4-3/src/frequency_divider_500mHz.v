module frequency_divider_500mHz (
    input clk,
    input rst_n,
    output reg clk_div  //500mHz = 2s = 200000000*10ns
);

reg [26:0] counter;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        counter <= 0;
    end
    else begin
        counter <= (counter == 100000000-1) ? 0 : counter+1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        clk_div <= 0;
    end
    else begin
        clk_div <= (counter == 100000000-1) ? ~clk_div : clk_div;
    end
end
    
endmodule