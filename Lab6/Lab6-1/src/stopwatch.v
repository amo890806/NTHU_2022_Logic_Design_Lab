module stopwatch (
    input clk,
    input rst_n,
    input stw_count_en,
    input stw_reset_en,
    output [8:0] stw_sec_binary,
    output [8:0] stw_min_binary
);

wire timeup;
assign timeup = (stw_sec_binary == 0) && (stw_min_binary==0);

wire sec_count_en;
assign sec_count_en = stw_count_en & (!timeup);

wire sec_borrow, min_borrow;

downcounter sec(
    .clk(clk),
    .rst_n(rst_n),
    .count_en(sec_count_en),
    .reset_en(stw_reset_en),
    .init(9'd59),
    .binary(stw_sec_binary),
    .time_borrow(sec_borrow)
);

downcounter min(
    .clk(clk),
    .rst_n(rst_n),
    .count_en(sec_borrow),
    .reset_en(stw_reset_en),
    .init(9'd59),
    .binary(stw_min_binary),
    .time_borrow(min_borrow)
);
    
endmodule