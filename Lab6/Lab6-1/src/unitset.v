module unitset (
    input clk,
    input rst_n,
    input set_en,
    input reg_load_en,
    input [7:0] set_data,
    input [8:0] reg_load_sec,
    input [8:0] reg_load_min,
    input [8:0] reg_load_hr,
    input [8:0] reg_load_day,
    input [8:0] reg_load_mon,
    input [8:0] reg_load_yr,
    input [8:0] reg_load_alarm_min,
    input [8:0] reg_load_alarm_hr,
    output [8:0] reg_sec,
    output [8:0] reg_min,
    output [8:0] reg_hr,
    output [8:0] reg_day,
    output [8:0] reg_mon,
    output [8:0] reg_yr,
    output [8:0] reg_alarm_min,
    output [8:0] reg_alarm_hr
);

wire sec_count_en, min_count_en, hr_count_en, day_count_en, mon_count_en, yr_count_en;
wire sec_carry, min_carry, hr_carry, day_carry, mon_carry, yr_carry;
wire alarm_min_count_en, alarm_hr_count_en;
wire alarm_min_carry, alarm_hr_carry;

assign sec_count_en = set_en & set_data[0];
assign min_count_en = set_en & set_data[1];
assign hr_count_en = set_en & set_data[2];
assign day_count_en = set_en & set_data[3];
assign mon_count_en = set_en & set_data[4];
assign yr_count_en = set_en & set_data[5];
assign alarm_min_count_en = set_en & set_data[6];
assign alarm_hr_count_en = set_en & set_data[7];

reg [8:0] day_limit;

always @(*) begin
    case(reg_mon)
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
    .count_en(sec_count_en),
    .load_en(reg_load_en),
    .data(reg_load_sec),
    .limit(9'd59),
    .init(9'd0),
    .binary(reg_sec),
    .time_carry(sec_carry)
);

counterx min(
    .clk(clk),
    .rst_n(rst_n),
    .count_en(min_count_en),
    .load_en(reg_load_en),
    .data(reg_load_min),
    .limit(9'd59),
    .init(9'd0),
    .binary(reg_min),
    .time_carry(min_carry)
);

counterx hr(
    .clk(clk),
    .rst_n(rst_n),
    .count_en(hr_count_en),
    .load_en(reg_load_en),
    .data(reg_load_hr),
    .limit(9'd23),
    .init(9'd0),
    .binary(reg_hr),
    .time_carry(hr_carry)
);

counterx day(
    .clk(clk),
    .rst_n(rst_n),
    .count_en(day_count_en),
    .load_en(reg_load_en),
    .data(reg_load_day),
    .limit(day_limit),
    .init(9'd1),
    .binary(reg_day),
    .time_carry(day_carry)
);

counterx mon(
    .clk(clk),
    .rst_n(rst_n),
    .count_en(mon_count_en),
    .load_en(reg_load_en),
    .data(reg_load_mon),
    .limit(9'd12),
    .init(9'd1),
    .binary(reg_mon),
    .time_carry(mon_carry)
);

counterx yr(
    .clk(clk),
    .rst_n(rst_n),
    .count_en(yr_count_en),
    .load_en(reg_load_en),
    .data(reg_load_yr),
    .limit(9'd99),
    .init(9'd0),
    .binary(reg_yr),
    .time_carry(yr_carry)
);

counterx alarm_min(
    .clk(clk),
    .rst_n(rst_n),
    .count_en(alarm_min_count_en),
    .load_en(reg_load_en),
    .data(reg_load_alarm_min),
    .limit(9'd59),
    .init(9'd0),
    .binary(reg_alarm_min),
    .time_carry(alarm_min_carry)
);

counterx alarm_hr(
    .clk(clk),
    .rst_n(rst_n),
    .count_en(alarm_hr_count_en),
    .load_en(reg_load_en),
    .data(reg_load_alarm_hr),
    .limit(9'd23),
    .init(9'd0),
    .binary(reg_alarm_hr),
    .time_carry(alarm_hr_carry)
);
    
endmodule