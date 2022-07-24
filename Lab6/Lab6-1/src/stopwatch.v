module stopwatch (
    input clk,
    input rst_n,
    input stw_count_en,
    input stw_reset_en,
    output [8:0] stw_sec_binary,
    output [8:0] stw_min_binary
);

wire carry;

second_counter sc1(
    .clk(clk),
    .rst_n(rst_n),
    .count_en(stw_count_en),
    .reset_en(stw_reset_en),
    .carry(carry),
    .binary(stw_sec_binary)
);
    
minute_counter mc1(
    .clk(clk),
    .rst_n(rst_n),
    .count_en(stw_count_en),
    .reset_en(stw_reset_en),
    .carry(carry),
    .binary(stw_min_binary)
);

endmodule