module reg_load_mux (
    input [8:0] time_sec_binary,
    input [8:0] time_min_binary,
    input [8:0] time_hr_binary,
    input [8:0] time_day_binary,
    input [8:0] time_mon_binary,
    input [8:0] time_yr_binary,
    input [8:0] alarm_min_binary,
    input [8:0] alarm_hr_binary,
    input [1:0] state,
    output reg [8:0] reg_load_sec,
    output reg [8:0] reg_load_min,
    output reg [8:0] reg_load_hr,
    output reg [8:0] reg_load_day,
    output reg [8:0] reg_load_mon,
    output reg [8:0] reg_load_yr,
    output reg [8:0] reg_load_alarm_min,
    output reg [8:0] reg_load_alarm_hr
);

always @(*) begin
    case(state)
        2'b00: begin
            reg_load_sec = time_sec_binary;
            reg_load_min = time_min_binary;
            reg_load_hr = time_hr_binary;
            reg_load_day = time_day_binary;
            reg_load_mon = time_mon_binary;
            reg_load_yr = time_yr_binary;
            reg_load_alarm_min = alarm_min_binary;
            reg_load_alarm_hr = alarm_hr_binary;
        end
        default: begin
            reg_load_sec = 0;
            reg_load_min = 0;
            reg_load_hr = 0;
            reg_load_day = 0;
            reg_load_mon = 0;
            reg_load_yr = 0;
            reg_load_alarm_min = 0;
            reg_load_alarm_hr = 0;
        end
    endcase
end
    
endmodule