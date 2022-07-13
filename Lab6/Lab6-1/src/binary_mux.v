`define TIME_DISP_YR_MON 5'b00000
`define TIME_DISP_DAY_HR 5'b00001
`define TIME_DISP_MIN_SEC 5'b00010
`define TIME_SET_YR_MON 5'b00011
`define TIME_SET_DAY_HR 5'b00100
`define TIME_SET_MIN_SEC 5'b00101
`define ALM_SET_HR_MIN 5'b01000
`define STW_DISP_MIN_SEC 5'b10000
`define STW_START 5'b10001
`define STW_PAUSE 5'b10010

module binary_mux (
    input [8:0] time_sec_binary,
    input [8:0] time_min_binary,
    input [8:0] time_hr_binary,
    input [8:0] time_day_binary,
    input [8:0] time_mon_binary,
    input [8:0] time_yr_binary,
    input [8:0] alarm_min_binary,
    input [8:0] alarm_hr_binary,
    input [8:0] stw_sec_binary,
    input [8:0] stw_min_binary,
    input [8:0] reg_sec,
    input [8:0] reg_min,
    input [8:0] reg_hr,
    input [8:0] reg_day,
    input [8:0] reg_mon,
    input [8:0] reg_yr,
    input [8:0] reg_alarm_min,
    input [8:0] reg_alarm_hr,
    input alarm_disp_en,
    input [4:0] state,
    output reg [8:0] reg_binary_L,
    output reg [8:0] reg_binary_R
);

always @(*) begin
    case(state)
        `TIME_DISP_YR_MON:begin
            if(alarm_disp_en)begin
                reg_binary_L = alarm_hr_binary;
                reg_binary_R = alarm_min_binary;
            end
            else begin
                reg_binary_L = time_yr_binary;
                reg_binary_R = time_mon_binary;
            end
        end
        `TIME_DISP_DAY_HR:begin
            if(alarm_disp_en)begin
                reg_binary_L = alarm_hr_binary;
                reg_binary_R = alarm_min_binary;
            end
            else begin
                reg_binary_L = time_day_binary;
                reg_binary_R = time_hr_binary;
            end
        end
        `TIME_DISP_MIN_SEC:begin
            if(alarm_disp_en)begin
                reg_binary_L = alarm_hr_binary;
                reg_binary_R = alarm_min_binary;
            end
            else begin
                reg_binary_L = time_min_binary;
                reg_binary_R = time_sec_binary;
            end
        end
        `ALM_SET_HR_MIN:begin
            reg_binary_L = reg_alarm_hr;
            reg_binary_R = reg_alarm_min;
        end
        `TIME_SET_YR_MON:begin
            reg_binary_L = reg_yr;
            reg_binary_R = reg_mon;
        end
        `TIME_SET_DAY_HR:begin
            reg_binary_L = reg_day;
            reg_binary_R = reg_hr;
        end
        `TIME_SET_MIN_SEC:begin
            reg_binary_L = reg_min;
            reg_binary_R = reg_sec;
        end
        `STW_DISP_MIN_SEC, `STW_START, `STW_PAUSE:begin
            reg_binary_L = stw_min_binary;
            reg_binary_R = stw_sec_binary;
        end
        default: begin
            reg_binary_L = 0;
            reg_binary_R = 0;
        end

    endcase
end
    
endmodule