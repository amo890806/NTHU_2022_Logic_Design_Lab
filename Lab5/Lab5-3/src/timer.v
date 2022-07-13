module timer (
    input clk,
    input clk_div_btn,
    input rst_n,
    input [1:0] push_onepulse,
    input count_en,
    input reset_en,
    input mode,
    output [5:0] min_binary,
    output [5:0] sec_binary
);

wire borrow, empty;
wire [5:0] min_init, sec_init;

setup s1(
    .clk(clk_div_btn),
    .rst_n(rst_n),
    .push_onepulse(push_onepulse),
    .mode(mode),
    .min_init(min_init),
    .sec_init(sec_init)
);

second_counter sc1(
    .clk(clk),
    .rst_n(rst_n),
    .count_en(count_en),
    .reset_en(reset_en),
    .init(sec_init),
    .mode(mode),
    .empty(empty),
    .borrow(borrow),
    .binary(sec_binary) 
);
    
minute_counter mc1(
    .clk(clk),
    .rst_n(rst_n),
    .count_en(count_en),
    .reset_en(reset_en),
    .init(min_init),
    .mode(mode),
    .borrow(borrow),
    .empty(empty),
    .binary(min_binary) 
);
    
endmodule