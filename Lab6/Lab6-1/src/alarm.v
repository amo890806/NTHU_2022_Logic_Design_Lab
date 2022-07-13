module alarm (
    input clk,
    input rst_n,
    input alarm_en,
    input alarm_load_en,
    input [8:0] time_min_binary,
    input [8:0] time_hr_binary,
    input [8:0] alarm_min_data,
    input [8:0] alarm_hr_data,
    output reg [8:0] alarm_min_binary,
    output reg [8:0] alarm_hr_binary,
    output [7:0] alarm_state_led
);

wire alarm_state_led_flag;
assign alarm_state_led_flag = (alarm_en && (time_min_binary == alarm_min_binary) && 
                        (time_hr_binary == alarm_hr_binary));

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        alarm_min_binary <= 0;
        alarm_hr_binary <= 0;
    end
    else begin
        alarm_min_binary <= (alarm_load_en) ? alarm_min_data : alarm_min_binary;
        alarm_hr_binary <= (alarm_load_en) ? alarm_hr_data : alarm_hr_binary;
    end
end

assign alarm_state_led = (alarm_state_led_flag) ? 7'h7F : 0;
    
endmodule