module stopwatch (
    input clk,
    input rst_n,
    input count_en,
    input reset_en,
    output [5:0] min_binary,
    output [5:0] sec_binary
);

wire carry;

second_counter sc1(
    .clk(clk),
    .rst_n(rst_n),
    .count_en(count_en),
    .reset_en(reset_en),
    .carry(carry),
    .binary(sec_binary)
);
    
minute_counter mc1(
    .clk(clk),
    .rst_n(rst_n),
    .count_en(count_en),
    .reset_en(reset_en),
    .carry(carry),
    .binary(min_binary)
);

endmodule