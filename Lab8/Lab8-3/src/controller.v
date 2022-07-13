`define PRESS_FIRST_OPERAND 0
`define PRESS_OPERATOR 1
`define PRESS_SECOND_OPERAND 2
`define PRESS_ENTER 3

module controller (
    input clk,
    input rst,
    input [8:0] last_change,
    input key_down_onepulse,
    output press_num,
    output press_asm,
    output press_enter,
    output reg [1:0] press_num_cnt,
    output [1:0] state,
    output reg reset_en
);

reg [1:0] cs, ns;
assign press_num = (last_change == 9'h0_70) || (last_change == 9'h0_69) || (last_change == 9'h0_72) ||
                 (last_change == 9'h0_7A) || (last_change == 9'h0_6B) || (last_change == 9'h0_73) ||
                 (last_change == 9'h0_74) || (last_change == 9'h0_6C) || (last_change == 9'h0_75) ||  
                 (last_change == 9'h0_7D);
assign press_asm = (last_change == 9'h0_79) || (last_change == 9'h0_7B) || (last_change == 9'h0_7C);
assign press_enter = (last_change == 9'h0_5A);
assign state = cs;

always @(posedge clk or posedge rst) begin
    if(rst)begin
        cs <= `PRESS_FIRST_OPERAND;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case (cs)
        `PRESS_FIRST_OPERAND: ns = (press_asm) ? ((key_down_onepulse && (press_num_cnt > 0))?`PRESS_OPERATOR:`PRESS_FIRST_OPERAND) : `PRESS_FIRST_OPERAND;
        `PRESS_OPERATOR: ns = (press_num) ? ((key_down_onepulse)?`PRESS_SECOND_OPERAND:`PRESS_OPERATOR) : `PRESS_OPERATOR;
        `PRESS_SECOND_OPERAND:  ns = (press_enter) ? ((key_down_onepulse)?`PRESS_ENTER:`PRESS_SECOND_OPERAND) : `PRESS_SECOND_OPERAND;
        `PRESS_ENTER: ns = (press_num) ? ((key_down_onepulse)?`PRESS_FIRST_OPERAND:`PRESS_ENTER) : `PRESS_ENTER;
    endcase
end

always @(posedge clk or posedge rst) begin
    if(rst)begin
        press_num_cnt <= 0;
    end
    else begin
        case (cs)
            `PRESS_FIRST_OPERAND, `PRESS_SECOND_OPERAND:begin
                if(key_down_onepulse)begin
                    press_num_cnt <= (press_num) ? ((press_num_cnt == 2) ? 2 : press_num_cnt+1)  : press_num_cnt;
                end
            end
            `PRESS_OPERATOR: begin
                press_num_cnt <=  (press_num) ? ((key_down_onepulse)?1:0) : 0;
            end
            `PRESS_ENTER: begin
                press_num_cnt <= (press_num) ? ((key_down_onepulse)?1:0) : 0;
            end
        endcase
    end
end

always @(*) begin
    case(cs)
        `PRESS_ENTER: reset_en = (press_num) ? ((key_down_onepulse)?1:0) : 0;
        default: reset_en = 0;
    endcase
end
    
endmodule