module frequency_divider_1Hz (
    input clk,
    input rst_n,
    output reg clk_div,
    output reg clk_div_ssd
);

reg [25:0] counter;
reg [15:0] counter_ssd;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        counter <= 0;
    end
    else begin
        counter <= (counter == 50000000-1) ? 0 : counter+1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        clk_div <= 0;
    end
    else begin
        clk_div <= (counter == 50000000-1) ? ~clk_div : clk_div;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        counter_ssd <= 0;
    end
    else begin
        counter_ssd <= (counter_ssd == 50000-1) ? 0 : counter_ssd+1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        clk_div_ssd <= 0;
    end
    else begin
        clk_div_ssd <= (counter_ssd == 50000-1) ? ~clk_div_ssd : clk_div_ssd;
    end
end
    
endmodule