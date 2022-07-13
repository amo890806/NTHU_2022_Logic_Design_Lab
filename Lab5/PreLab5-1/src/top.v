`include "debounce.v"
`include "one_pulse.v"
`include "controller.v"
`include "down_counter.v"

module top (
    input clk, 
    input rst_n,
    input [1:0] btn,
    output [15:0] led
);

wire count_en;
wire [1:0] push_debounced;
wire [1:0] push_onepulse;

debounce d1(
    .clk(clk),
    .rst_n(rst_n),
    .btn(btn[0]),
    .push_debounced(push_debounced[0])
);

one_pulse p1(
    .clk(clk),
    .rst_n(rst_n),
    .push_debounced(push_debounced[0]),
    .push_onepulse(push_onepulse[0])
);

debounce d2(
    .clk(clk),
    .rst_n(rst_n),
    .btn(btn[1]),
    .push_debounced(push_debounced[1])
);

one_pulse p2(
    .clk(clk),
    .rst_n(rst_n),
    .push_debounced(push_debounced[1]),
    .push_onepulse(push_onepulse[1])
);

controller c1(
    .clk(clk),
    .rst_n(rst_n),
    .push_onepulse(push_onepulse[0]),
    .count_en(count_en)
);

down_counter dc1(
    .clk(clk),
    .rst_n(rst_n),
    .push_onepulse(push_onepulse[1]),
    .count_en(count_en),
    .led(led)
);
    
endmodule