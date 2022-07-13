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

module controller (
    input clk,
    input rst_n,
    input [1:0] mode_sw,
    input alarm_sw,         //alarm
    input switch_btn,       //display, set
    input stw_count_btn,    //stw
    input stw_lap_btn,      //stw
    input set_L_inc_btn,    //set
    input set_R_inc_btn,    //set
    output alarm_en,        //if alarm_en=1, alarm active
    output alarm_disp_en,   //if alarm_disp_en=1, show alarm_disp
    output reg stw_count_en,    //if stw_count_en=1, stw starts count down
    output reg stw_lap_en,      //if stw_lap_en=1, ssd stop but stw keep counting
    output set_en,          //if set_en=1, reg data + 1
    output data_load_en,    //if data_load_en=1, load data from reg to counter
    output reg_load_en,     //if reg_load_en=1, load data from counter to reg
    output reg [7:0] set_data,
    output [4:0] state,
    output reg stw_state_led,   //led[0]
    output reg [2:0] display_state_led,    //led[11:9]
    output reg [3:0] set_state_led    //led[15:12]
);

reg [4:0] cs, ns;
reg [1:0] switch_press_count;
reg switch_btn_dly;
wire switch_short_press, switch_long_press;
assign switch_short_press = (~switch_btn) & switch_btn_dly & (~(switch_press_count[1]&switch_press_count[0]));
assign switch_long_press = (switch_press_count == 2'b11);
assign state = cs;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        switch_btn_dly <= 0;
    end
    else begin
        switch_btn_dly <= switch_btn;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        switch_press_count <= 0;
    end
    else begin
        switch_press_count <= (switch_btn) ? switch_press_count+1 : 0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        cs <= 0;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin   
    case(cs)
        `TIME_DISP_YR_MON: begin
            if(mode_sw == 2'b01)begin
                ns = `ALM_SET_HR_MIN;
            end
            else if(mode_sw == 2'b10)begin
                ns = `STW_DISP_MIN_SEC;
            end
            else begin
                if(switch_long_press)begin
                    ns = `TIME_DISP_YR_MON;
                end
                else if(switch_short_press)begin
                    ns = `TIME_DISP_DAY_HR;
                end
                else begin
                    ns = `TIME_DISP_YR_MON;
                end
            end
            
        end
        `TIME_DISP_DAY_HR: begin
            if(mode_sw == 2'b01)begin
                ns = `ALM_SET_HR_MIN;
            end
            else if(mode_sw == 2'b10)begin
                ns = `STW_DISP_MIN_SEC;
            end
            else begin
                if(switch_long_press)begin
                    ns = `TIME_DISP_DAY_HR;
                end
                else if(switch_short_press)begin
                    ns = `TIME_DISP_MIN_SEC;
                end
                else begin
                    ns = `TIME_DISP_DAY_HR;
                end
            end
        end
        `TIME_DISP_MIN_SEC: begin
            if(mode_sw == 2'b01)begin
                ns = `ALM_SET_HR_MIN;
            end
            else if(mode_sw == 2'b10)begin
                ns = `STW_DISP_MIN_SEC;
            end
            else begin
                if(switch_long_press)begin
                    ns = `TIME_DISP_MIN_SEC;
                end
                else if(switch_short_press)begin
                    ns = `TIME_DISP_YR_MON;
                end
                else begin
                    ns = `TIME_DISP_MIN_SEC;
                end
            end
        end
        `ALM_SET_HR_MIN: begin
            if(mode_sw == 2'b00)begin
                ns = `TIME_DISP_YR_MON;
            end
            else if(mode_sw == 2'b10)begin
                ns = `STW_DISP_MIN_SEC;
            end
            else begin
                if(switch_long_press)begin
                    ns = `ALM_SET_HR_MIN;
                end
                else if(switch_short_press)begin
                    ns = `TIME_SET_YR_MON;
                end
                else begin
                    ns = `ALM_SET_HR_MIN;
                end
            end
        end
        `TIME_SET_YR_MON: begin
            if(mode_sw == 2'b00)begin
                ns = `TIME_DISP_YR_MON;
            end
            else if(mode_sw == 2'b10)begin
                ns = `STW_DISP_MIN_SEC;
            end
            else begin
                if(switch_long_press)begin
                    ns = `TIME_SET_YR_MON;
                end
                else if(switch_short_press)begin
                    ns = `TIME_SET_DAY_HR;
                end
                else begin
                    ns = `TIME_SET_YR_MON;
                end
            end
        end
        `TIME_SET_DAY_HR: begin
            if(mode_sw == 2'b00)begin
                ns = `TIME_DISP_YR_MON;
            end
            else if(mode_sw == 2'b10)begin
                ns = `STW_DISP_MIN_SEC;
            end
            else begin
                if(switch_long_press)begin
                    ns = `TIME_SET_DAY_HR;
                end
                else if(switch_short_press)begin
                    ns = `TIME_SET_MIN_SEC;
                end
                else begin
                    ns = `TIME_SET_DAY_HR;
                end
            end
        end
        `TIME_SET_MIN_SEC: begin
            if(mode_sw == 2'b00)begin
                ns = `TIME_DISP_YR_MON;
            end
            else if(mode_sw == 2'b10)begin
                ns = `STW_DISP_MIN_SEC;
            end
            else begin
                if(switch_long_press)begin
                    ns = `TIME_SET_MIN_SEC;
                end
                else if(switch_short_press)begin
                    ns = `ALM_SET_HR_MIN;
                end
                else begin
                    ns = `TIME_SET_MIN_SEC;
                end
            end
        end
        `STW_DISP_MIN_SEC: begin
            if(mode_sw == 2'b00)begin
                ns = `TIME_DISP_YR_MON;
            end
            else if(mode_sw == 2'b01)begin
                ns = `ALM_SET_HR_MIN;
            end
            else begin
                if(stw_count_btn)begin
                    ns = `STW_START;
                end
                else begin
                    ns = `STW_DISP_MIN_SEC;
                end
            end
        end
        `STW_START: begin
            if(stw_count_btn)begin
                ns = `STW_PAUSE;
            end
            else begin
                ns = `STW_START;
            end
        end
        `STW_PAUSE: begin
            if(stw_count_btn)begin
                ns = `STW_START;
            end
            else if(stw_lap_btn)begin
                ns = `STW_DISP_MIN_SEC;
            end
            else begin
                ns = `STW_PAUSE;
            end
        end
        default: ns = `TIME_DISP_YR_MON;
    endcase
end

wire alarm_flag;
assign alarm_flag = (cs == `TIME_DISP_YR_MON) || (cs == `TIME_DISP_DAY_HR) || (cs == `TIME_DISP_MIN_SEC) || 
                    (cs == `ALM_SET_HR_MIN) || (cs == `TIME_SET_YR_MON) || (cs == `TIME_SET_DAY_HR) || 
                    (cs == `TIME_SET_MIN_SEC);
assign alarm_en = (alarm_flag) ? alarm_sw :0;

wire alarm_disp_flag;
assign alarm_disp_flag = (cs == `TIME_DISP_YR_MON) || (cs == `TIME_DISP_DAY_HR) || (cs == `TIME_DISP_MIN_SEC);
assign alarm_disp_en = (alarm_disp_flag) ? switch_long_press : 0;


wire stw_count_flag;
assign stw_count_flag = (cs == `STW_DISP_MIN_SEC) || (cs == `STW_START) || (cs == `STW_PAUSE);
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        stw_count_en <= 0;
    end
    else begin
        stw_count_en <= (stw_count_flag) ? ((stw_count_btn) ? ~stw_count_en : stw_count_en) : 0;
    end
end

wire stw_lap_flag;
assign stw_lap_flag = (cs == `STW_START);
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        stw_lap_en <= 0;
    end
    else begin
        stw_lap_en <= (stw_lap_flag) ? ((stw_lap_btn) ? ~stw_lap_en : stw_lap_en) : 0;
    end
end

wire set_flag;
assign set_flag = (cs == `ALM_SET_HR_MIN) || (cs == `TIME_SET_YR_MON) || (cs == `TIME_SET_DAY_HR) || (cs == `TIME_SET_MIN_SEC);
assign set_en = (set_flag) ? 1 : 0;

wire data_load_flag;
assign data_load_flag = (cs == `ALM_SET_HR_MIN) || (cs == `TIME_SET_YR_MON) || (cs == `TIME_SET_DAY_HR) || (cs == `TIME_SET_MIN_SEC);
assign data_load_en = (data_load_flag) ? 1 : 0;

wire reg_load_flag;
assign reg_load_flag = (cs == `TIME_DISP_YR_MON);
assign reg_load_en = (reg_load_flag) ? ((mode_sw == 2'b01)?1:0) : 0;

always @(*) begin
    case(cs)
        `TIME_SET_YR_MON: set_data = {2'b0, set_L_inc_btn, set_R_inc_btn, 4'b0};
        `TIME_SET_DAY_HR: set_data = {4'b0, set_L_inc_btn, set_R_inc_btn, 2'b0};
        `TIME_SET_MIN_SEC: set_data = {6'b0, set_L_inc_btn, set_R_inc_btn};
        `ALM_SET_HR_MIN: set_data = {set_L_inc_btn, set_R_inc_btn, 6'b0};
        default: set_data = 0;
    endcase
end

always @(*) begin
    case (cs)
        `STW_START:  stw_state_led = 1;
        `STW_DISP_MIN_SEC, `STW_PAUSE: stw_state_led = 0;
        default: stw_state_led = 0;
    endcase
end

always @(*) begin
    case(cs)
        `TIME_DISP_YR_MON: begin
            if(switch_long_press)begin
                display_state_led = 3'b111;
            end
            else begin
                display_state_led = 3'b001;
            end
        end
        `TIME_DISP_DAY_HR: begin
            if(switch_long_press)begin
                display_state_led = 3'b111;
            end
            else begin
                display_state_led = 3'b010;
            end
        end
        `TIME_DISP_MIN_SEC: begin
            if(switch_long_press)begin
                display_state_led = 3'b111;
            end
            else begin
                display_state_led = 3'b100;
            end
        end
        default: display_state_led = 3'b000;
    endcase
end

always @(*) begin
    case(cs)
        `ALM_SET_HR_MIN: set_state_led = 4'b0001;
        `TIME_SET_YR_MON: set_state_led = 4'b0010;
        `TIME_SET_DAY_HR: set_state_led = 4'b0100;
        `TIME_SET_MIN_SEC: set_state_led = 4'b1000;
        default: set_state_led = 4'b0000;
    endcase
end

endmodule