module stopwatch (
    input clk,
    input rst_n,
    input count_en,
    input reset_en,
    output [5:0] sec_binary,
    output [5:0] min_binary
);

wire timeup;
assign timeup = (sec_binary == 0) && (min_binary==0);

wire sec_count_en;
assign sec_count_en = count_en & (!timeup);

wire sec_borrow, min_borrow;

downcounter sec(
    .clk(clk),
    .rst_n(rst_n),
    .count_en(sec_count_en),
    .reset_en(reset_en),
    .init(9'd59),
    .binary(sec_binary),
    .time_borrow(sec_borrow)
);

downcounter min(
    .clk(clk),
    .rst_n(rst_n),
    .count_en(sec_borrow),
    .reset_en(reset_en),
    .init(9'd59),
    .binary(min_binary),
    .time_borrow(min_borrow)
);
    
endmodule