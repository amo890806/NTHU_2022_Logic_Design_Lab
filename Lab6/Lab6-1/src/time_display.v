module time_display (
    input clk,
    input rst_n,
    input count_en,
    input time_load_en,
    input [8:0] time_sec_data,
    input [8:0] time_min_data,
    input [8:0] time_hr_data,
    input [8:0] time_day_data,
    input [8:0] time_mon_data,
    input [8:0] time_yr_data,
    output [8:0] time_sec_binary,
    output [8:0] time_min_binary,
    output [8:0] time_hr_binary,
    output [8:0] time_day_binary,
    output [8:0] time_mon_binary,
    output [8:0] time_yr_binary
);

wire sec_carry, min_carry, hr_carry, day_carry, mon_carry, yr_carry;
reg [8:0] day_limit;

always @(*) begin
    case(time_mon_binary)
        1: day_limit = 9'd31;
        2: day_limit = 9'd28;
        3: day_limit = 9'd31;
        4: day_limit = 9'd30;
        5: day_limit = 9'd31;
        6: day_limit = 9'd30;
        7: day_limit = 9'd31;
        8: day_limit = 9'd31;
        9: day_limit = 9'd30;
        10: day_limit = 9'd31;
        11: day_limit = 9'd30;
        12: day_limit = 9'd31;
        default: day_limit = 9'd0;
    endcase
end

counterx sec(
    .clk(clk),
    .rst_n(rst_n),
    .count_en(count_en),
    .load_en(time_load_en),
    .data(time_sec_data),
    .limit(9'd59),
    .init(9'd0),
    .binary(time_sec_binary),
    .time_carry(sec_carry)
);

counterx min(
    .clk(clk),
    .rst_n(rst_n),
    .count_en(sec_carry),
    .load_en(time_load_en),
    .data(time_min_data),
    .limit(9'd59),
    .init(9'd0),
    .binary(time_min_binary),
    .time_carry(min_carry)
);

counterx hr(
    .clk(clk),
    .rst_n(rst_n),
    .count_en(min_carry),
    .load_en(time_load_en),
    .data(time_hr_data),
    .limit(9'd23),
    .init(9'd0),
    .binary(time_hr_binary),
    .time_carry(hr_carry)
);

counterx day(
    .clk(clk),
    .rst_n(rst_n),
    .count_en(hr_carry),
    .load_en(time_load_en),
    .data(time_day_data),
    .limit(day_limit),
    .init(9'd1),
    .binary(time_day_binary),
    .time_carry(day_carry)
);

counterx mon(
    .clk(clk),
    .rst_n(rst_n),
    .count_en(day_carry),
    .load_en(time_load_en),
    .data(time_mon_data),
    .limit(9'd12),
    .init(9'd1),
    .binary(time_mon_binary),
    .time_carry(mon_carry)
);

counterx yr(
    .clk(clk),
    .rst_n(rst_n),
    .count_en(mon_carry),
    .load_en(time_load_en),
    .data(time_yr_data),
    .limit(9'd99),
    .init(9'd0),
    .binary(time_yr_binary),
    .time_carry(yr_carry)
);
    
endmodule