module frequency_divider (
    input clk,
    input rst,
    output reg clk_1Hz, //1Hz=1s=100000000*10ns
    output reg clk_10Hz, //10Hz=0.1s=10000000*10ns
    output reg clk_100Hz,  //100Hz=0.01s=1000000*10ns
    output reg clk_2kHz  //2kHz=0.002s=200000*10ns
);

reg [25:0] counter_1Hz;
reg [22:0] counter_10Hz;
reg [18:0] counter_100Hz;
reg [16:0] counter_2kHz;

always @(posedge clk or posedge rst) begin
    if(rst)begin
        counter_1Hz <= 0;
    end
    else begin
        counter_1Hz <= (counter_1Hz == 50000000-1) ? 0 : counter_1Hz+1;
    end
end

always @(posedge clk or posedge rst) begin
    if(rst)begin
        clk_1Hz <= 0;
    end
    else begin
        clk_1Hz <= (counter_1Hz == 50000000-1) ? ~clk_1Hz : clk_1Hz;
    end
end

always @(posedge clk or posedge rst) begin
    if(rst)begin
        counter_10Hz <= 0;
    end
    else begin
        counter_10Hz <= (counter_10Hz == 5000000-1) ? 0 : counter_10Hz+1;
    end
end

always @(posedge clk or posedge rst) begin
    if(rst)begin
        clk_10Hz <= 0;
    end
    else begin
        clk_10Hz <= (counter_10Hz == 5000000-1) ? ~clk_10Hz : clk_10Hz;
    end
end

always @(posedge clk or posedge rst) begin
    if(rst)begin
        counter_100Hz <= 0;
    end
    else begin
        counter_100Hz <= (counter_100Hz == 500000-1) ? 0 : counter_100Hz+1;
    end
end

always @(posedge clk or posedge rst) begin
    if(rst)begin
        clk_100Hz <= 0;
    end
    else begin
        clk_100Hz <= (counter_100Hz == 500000-1) ? ~clk_100Hz : clk_100Hz;
    end
end

always @(posedge clk or posedge rst) begin
    if(rst)begin
        counter_2kHz <= 0;
    end
    else begin
        counter_2kHz <= (counter_2kHz == 100000-1) ? 0 : counter_2kHz+1;
    end
end

always @(posedge clk or posedge rst) begin
    if(rst)begin
        clk_2kHz <= 0;
    end
    else begin
        clk_2kHz <= (counter_2kHz == 100000-1) ? ~clk_2kHz : clk_2kHz;
    end
end
    
endmodule