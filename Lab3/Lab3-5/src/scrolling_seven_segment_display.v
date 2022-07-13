`define n 8'b1101010_1
`define t 8'b1110000_1
`define h 8'b1101000_1
`define u 8'b1100011_1
`define E 8'b0110000_1 
`define C 8'b0110001_1
`define S 8'b0100100_1

module scrolling_seven_segment_display (
    input clk,
    input clk_div_ssd,
    input rst_n,
    output [7:0] display,
    output reg [3:0] ctrl
);

reg [7:0] data [0:7];
reg [1:0] counter;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        data[0] <= `n;
        data[1] <= `t;
        data[2] <= `h;
        data[3] <= `u;
        data[4] <= `E;
        data[5] <= `E;
        data[6] <= `C;
        data[7] <= `S;
    end
    else begin
        data[0] <= data[1];
        data[1] <= data[2];
        data[2] <= data[3];
        data[3] <= data[4];
        data[4] <= data[5];
        data[5] <= data[6];
        data[6] <= data[7];
        data[7] <= data[0];
    end
end

assign display = data[counter];

always @(posedge clk_div_ssd or negedge rst_n) begin
    if(!rst_n)begin
        ctrl <= 4'b0111;
    end
    else begin
        ctrl <= {ctrl[0], ctrl[3:1]};
    end
end

always @(posedge clk_div_ssd or negedge rst_n) begin
    if(!rst_n)begin
        counter <= 0;
    end
    else begin
        counter <= counter + 1;
    end
end

    
endmodule