module electronic_clock (
    input clk,
    input rst,
    input [2:0] sw,
    input [4:0] btn,
    output [7:0] display,
    output [3:0] ctrl,
    output [15:0] led
);

wire clk_1Hz, clk_10Hz, clk_100Hz, clk_2kHz;
wire alarm_en, alarm_disp_en, stw_count_en, stw_lap_en, set_en, data_load_en, reg_load_en;
wire [7:0] set_data;
wire [4:0] state;
wire stw_state_led;
wire [2:0] display_state_led;
wire [3:0] set_state_led;
wire time_load_en;
assign time_load_en = data_load_en && (state[4:3] == 2'b00);
wire [8:0] time_sec_binary, time_min_binary, time_hr_binary, time_day_binary, time_mon_binary, time_yr_binary;
wire [8:0] reg_load_sec, reg_load_min, reg_load_hr, reg_load_day, reg_load_mon, reg_load_yr, reg_load_alarm_min, reg_load_alarm_hr;
wire [8:0] reg_sec, reg_min, reg_hr, reg_day, reg_mon, reg_yr, reg_alarm_min, reg_alarm_hr;
wire alarm_load_en;
assign alarm_load_en = data_load_en && (state[4:3] == 2'b01);
wire [7:0] alarm_state_led;
wire [8:0] alarm_min_binary, alarm_hr_binary;
wire [8:0] stw_sec_binary, stw_min_binary;
wire [8:0] reg_binary_L, reg_binary_R;
wire [7:0] BCD_L, BCD_R;

wire rst_n = !rst;

frequency_divider fd1(
    .clk(clk),
    .rst_n(rst_n),
    .clk_1Hz(clk_1Hz), 
    .clk_10Hz(clk_10Hz),
    .clk_100Hz(clk_100Hz),
    .clk_2kHz(clk_2kHz)
);

wire [4:0] push_debounced, push_onepulse;


debounce d1(                        //switch_btn
    .clk(clk_100Hz),
    .rst_n(rst_n),
    .btn(btn[0]),
    .push_debounced(push_debounced[0])
);

one_pulse p1(
    .clk(clk_10Hz),
    .rst_n(rst_n),
    .push_debounced(push_debounced[0]),
    .push_onepulse(push_onepulse[0])
);

debounce d2(                        //stw_count_btn
    .clk(clk_100Hz),
    .rst_n(rst_n),
    .btn(btn[1]),
    .push_debounced(push_debounced[1])
);

one_pulse p2(
    .clk(clk_10Hz),
    .rst_n(rst_n),
    .push_debounced(push_debounced[1]),
    .push_onepulse(push_onepulse[1])
);

debounce d3(                        //stw_lap_btn
    .clk(clk_100Hz),
    .rst_n(rst_n),
    .btn(btn[2]),
    .push_debounced(push_debounced[2])
);

one_pulse p3(
    .clk(clk_10Hz),
    .rst_n(rst_n),
    .push_debounced(push_debounced[2]),
    .push_onepulse(push_onepulse[2])
);

debounce d4(                        //set_L_inc_btn
    .clk(clk_100Hz),
    .rst_n(rst_n),
    .btn(btn[3]),
    .push_debounced(push_debounced[3])
);

one_pulse p4(
    .clk(clk_10Hz),
    .rst_n(rst_n),
    .push_debounced(push_debounced[3]),
    .push_onepulse(push_onepulse[3])
);

debounce d5(                        //set_R_inc_btn
    .clk(clk_100Hz),
    .rst_n(rst_n),
    .btn(btn[4]),
    .push_debounced(push_debounced[4])
);

one_pulse p5(
    .clk(clk_10Hz),
    .rst_n(rst_n),
    .push_debounced(push_debounced[4]),
    .push_onepulse(push_onepulse[4])
);

controller c1(
    .clk(clk_1Hz),
    .rst_n(rst_n),
    .mode_sw(sw[1:0]),
    .alarm_sw(sw[2]),        
    .switch_btn(btn[0]),       
    .stw_count_btn(btn[1]),    
    .stw_lap_btn(btn[2]),      
    .set_L_inc_btn(push_onepulse[3]),    
    .set_R_inc_btn(push_onepulse[4]),    
    .alarm_en(alarm_en),        
    .alarm_disp_en(alarm_disp_en),  
    .stw_count_en(stw_count_en),    
    .stw_lap_en(stw_lap_en),      
    .set_en(set_en),          
    .data_load_en(data_load_en),    
    .reg_load_en(reg_load_en),     
    .set_data(set_data),
    .state(state),
    .stw_state_led(stw_state_led),   
    .display_state_led(display_state_led),    
    .set_state_led(set_state_led)    
);

time_display td1(
    .clk(clk_1Hz),
    .rst_n(rst_n),
    .count_en(1),
    .time_load_en(time_load_en),
    .time_sec_data(reg_sec),
    .time_min_data(reg_min),
    .time_hr_data(reg_hr),
    .time_day_data(reg_day),
    .time_mon_data(reg_mon),
    .time_yr_data(reg_yr),
    .time_sec_binary(time_sec_binary),
    .time_min_binary(time_min_binary),
    .time_hr_binary(time_hr_binary),
    .time_day_binary(time_day_binary),
    .time_mon_binary(time_mon_binary),
    .time_yr_binary(time_yr_binary)
);

alarm a1(
    .clk(clk_1Hz),
    .rst_n(rst_n),
    .alarm_en(alarm_en),
    .alarm_load_en(alarm_load_en),
    .time_min_binary(time_min_binary),
    .time_hr_binary(time_hr_binary),
    .alarm_min_data(reg_alarm_min),
    .alarm_hr_data(reg_alarm_hr),
    .alarm_min_binary(alarm_min_binary),
    .alarm_hr_binary(alarm_hr_binary),
    .alarm_state_led(alarm_state_led)
);

reg_load_mux m1(
    .time_sec_binary(time_sec_binary),
    .time_min_binary(time_min_binary),
    .time_hr_binary(time_hr_binary),
    .time_day_binary(time_day_binary),
    .time_mon_binary(time_mon_binary),
    .time_yr_binary(time_yr_binary),
    .alarm_min_binary(alarm_min_binary),
    .alarm_hr_binary(alarm_hr_binary),
    .state(state[4:3]),
    .reg_load_sec(reg_load_sec),
    .reg_load_min(reg_load_min),
    .reg_load_hr(reg_load_hr),
    .reg_load_day(reg_load_day),
    .reg_load_mon(reg_load_mon),
    .reg_load_yr(reg_load_yr),
    .reg_load_alarm_min(reg_load_alarm_min),
    .reg_load_alarm_hr(reg_load_alarm_hr)
);

stopwatch w1(
    .clk(clk_1Hz),
    .rst_n(rst_n),
    .stw_count_en(stw_count_en),
    .stw_reset_en(btn[2]),
    .stw_sec_binary(stw_sec_binary),
    .stw_min_binary(stw_min_binary)
);

unitset u1(
    .clk(clk_10Hz),
    .rst_n(rst_n),
    .set_en(set_en),
    .reg_load_en(reg_load_en),
    .set_data(set_data),
    .reg_load_sec(reg_load_sec),
    .reg_load_min(reg_load_min),
    .reg_load_hr(reg_load_hr),
    .reg_load_day(reg_load_day),
    .reg_load_mon(reg_load_mon),
    .reg_load_yr(reg_load_yr),
    .reg_load_alarm_min(reg_load_alarm_min),
    .reg_load_alarm_hr(reg_load_alarm_hr),
    .reg_sec(reg_sec),
    .reg_min(reg_min),
    .reg_hr(reg_hr),
    .reg_day(reg_day),
    .reg_mon(reg_mon),
    .reg_yr(reg_yr),
    .reg_alarm_min(reg_alarm_min),
    .reg_alarm_hr(reg_alarm_hr)
);

binary_mux m2(
    .time_sec_binary(time_sec_binary),
    .time_min_binary(time_min_binary),
    .time_hr_binary(time_hr_binary),
    .time_day_binary(time_day_binary),
    .time_mon_binary(time_mon_binary),
    .time_yr_binary(time_yr_binary),
    .alarm_min_binary(alarm_min_binary),
    .alarm_hr_binary(alarm_hr_binary),
    .stw_sec_binary(stw_sec_binary),
    .stw_min_binary(stw_min_binary),
    .reg_sec(reg_sec),
    .reg_min(reg_min),
    .reg_hr(reg_hr),
    .reg_day(reg_day),
    .reg_mon(reg_mon),
    .reg_yr(reg_yr),
    .reg_alarm_min(reg_alarm_min),
    .reg_alarm_hr(reg_alarm_hr),
    .alarm_disp_en(alarm_disp_en),
    .state(state),
    .reg_binary_L(reg_binary_L),
    .reg_binary_R(reg_binary_R)
);

bin2bcd b1(
    .binary(reg_binary_L),
    .BCD(BCD_L)
);

bin2bcd b2(
    .binary(reg_binary_R),
    .BCD(BCD_R)
);

seven_segment_display_controller ssd1(
    .clk(clk_2kHz),
    .rst_n(rst_n),
    .BCD_L(BCD_L),
    .BCD_R(BCD_R),
    .stw_lap_en(stw_lap_en),
    .display(display),
    .ctrl(ctrl)
);

assign led = {set_state_led, display_state_led, alarm_state_led, stw_state_led};

endmodule