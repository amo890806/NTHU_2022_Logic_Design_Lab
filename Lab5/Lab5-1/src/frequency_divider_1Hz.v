module frequency_divider_1Hz (
    input clk,
    input rst_n,
    output reg clk_div, //1Hz=1s=100000000*10ns
    output reg clk_div_ssd,  //1kHz=0.001s=100000*10ns
    output reg clk_div_btn  //100Hz=0.01s=1000000*10ns
);

reg [25:0] counter;
reg [15:0] counter_ssd;
reg [18:0] counter_btn;

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

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        counter_btn <= 0;
    end
    else begin
        counter_btn <= (counter_btn == 500000-1) ? 0 : counter_btn+1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        clk_div_btn <= 0;
    end
    else begin
        clk_div_btn <= (counter_btn == 500000-1) ? ~clk_div_btn : clk_div_btn;
    end
end
    
endmodule