module top (
    input clk,
    input rst_n,
    input sw,
    input [3:0] btn,
    output [7:0] display,
    output [3:0] ctrl,
    output [15:0] led
);

wire clk_div, count_en, lap_en, reset_en;
wire [3:0] push_debounced;
wire [3:0] push_onepulse;
wire [5:0] min_binary, sec_binary;
wire [7:0] min_BCD, sec_BCD;

frequency_divider_1Hz fd1(
    .clk(clk),
    .rst_n(rst_n),
    .clk_div(clk_div),
    .clk_div_ssd(clk_div_ssd),
    .clk_div_btn(clk_div_btn)
);

debounce d1(            //count_en
    .clk(clk_div_btn),
    .rst_n(rst_n),
    .btn(btn[0]),
    .push_debounced(push_debounced[0])
);

one_pulse p1(
    .clk(clk_div_btn),
    .rst_n(rst_n),
    .push_debounced(push_debounced[0]),
    .push_onepulse(push_onepulse[0])
);

debounce d2(            //lap_en
    .clk(clk_div_btn),
    .rst_n(rst_n),
    .btn(btn[1]),
    .push_debounced(push_debounced[1])
);

one_pulse p2(
    .clk(clk_div_btn),
    .rst_n(rst_n),
    .push_debounced(push_debounced[1]),
    .push_onepulse(push_onepulse[1])
);

debounce d3(            //inc_sec_en
    .clk(clk_div_btn),
    .rst_n(rst_n),
    .btn(btn[2]),
    .push_debounced(push_debounced[2])
);

one_pulse p3(
    .clk(clk_div_btn),
    .rst_n(rst_n),
    .push_debounced(push_debounced[2]),
    .push_onepulse(push_onepulse[2])
);

debounce d4(            //inc_min_en
    .clk(clk_div_btn),
    .rst_n(rst_n),
    .btn(btn[3]),
    .push_debounced(push_debounced[3])
);

one_pulse p4(
    .clk(clk_div_btn),
    .rst_n(rst_n),
    .push_debounced(push_debounced[3]),
    .push_onepulse(push_onepulse[3])
);

controller c1(
    .clk(clk_div_btn),
    .rst_n(rst_n),
    .push_onepulse(push_onepulse[1:0]),
    .mode(sw),
    .count_en(count_en),
    .lap_en(lap_en)
);

timer t1(
    .clk(clk_div),
    .clk_div_btn(clk_div_btn),
    .rst_n(rst_n),
    .push_onepulse(push_onepulse[3:2]),
    .count_en(count_en),
    .reset_en(!btn[1]),
    .mode(sw),
    .min_binary(min_binary),
    .sec_binary(sec_binary)
);

bin2bcd b1(
    .binary(min_binary),
    .BCD(min_BCD)
);

bin2bcd b2(
    .binary(sec_binary),
    .BCD(sec_BCD)
);

seven_segment_display_controller dc1(
    .clk(clk_div_ssd),
    .rst_n(rst_n),
    .min_BCD(min_BCD),
    .sec_BCD(sec_BCD),
    .lap_en(lap_en),
    .count_en(count_en),
    .mode(sw),
    .display(display),
    .ctrl(ctrl),
    .led(led)
);

    
endmodule