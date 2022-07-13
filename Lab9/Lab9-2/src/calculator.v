`define PRESS_FIRST_OPERAND 0
`define PRESS_OPERATOR 1
`define PRESS_SECOND_OPERAND 2
`define PRESS_ENTER 3

module calculator (
    input clk,
    input rst,
    input [1:0] state,
    input key_down_onepulse,
    input press_num,
    input press_asm,
    input press_enter,
    input [1:0] press_num_cnt,
    input [3:0] BCD,
    input reset_en,
    output reg [6:0] first_operand_binary, 
    output reg [6:0] second_operand_binary,
    output reg [3:0] operator,
    output reg [14:0] result_binary
);

always @(posedge clk or posedge rst) begin
    if(rst)begin
        first_operand_binary <= 0;
    end
    else begin
        case (state)
            `PRESS_FIRST_OPERAND: begin
                if(press_num_cnt == 2)begin
                    first_operand_binary <= first_operand_binary;
                end
                else if(press_num_cnt == 1)begin
                    first_operand_binary <= (press_num) ? ((key_down_onepulse) ? 10*first_operand_binary + BCD : first_operand_binary) : first_operand_binary;
                end
                else if(press_num_cnt == 0)begin
                    first_operand_binary <= (press_num) ? ((key_down_onepulse) ? BCD : first_operand_binary) : first_operand_binary;
                end
                else begin
                    first_operand_binary <= 0;
                end
            end
            `PRESS_ENTER: first_operand_binary <= (reset_en) ? BCD : first_operand_binary;
        endcase
    end
end

always @(posedge clk or posedge rst) begin
    if(rst)begin
        operator <= 0;
    end
    else begin
        case (state)
            `PRESS_FIRST_OPERAND: operator <= (press_asm) ? ((key_down_onepulse) ? BCD : operator) : operator;
            `PRESS_ENTER: operator <= (reset_en) ? 0 : operator;
        endcase
    end
end

always @(posedge clk or posedge rst) begin
    if(rst)begin
        second_operand_binary <= 0;
    end
    else begin
        case(state)
            `PRESS_OPERATOR: second_operand_binary <= (press_num) ? ((key_down_onepulse) ? BCD : second_operand_binary) : second_operand_binary;
            `PRESS_SECOND_OPERAND: begin
                if(press_num_cnt == 2)begin
                    second_operand_binary <= second_operand_binary;
                end
                else if(press_num_cnt == 1)begin
                    second_operand_binary <= (press_num) ? ((key_down_onepulse) ? 10*second_operand_binary + BCD : second_operand_binary) : second_operand_binary;
                end
                else begin
                    second_operand_binary <= 0;
                end
            end
            `PRESS_ENTER: second_operand_binary <= (reset_en) ? 0 : second_operand_binary;
        endcase
    end
end

always @(*) begin
    case (operator)
        4'hA: result_binary = first_operand_binary + second_operand_binary;
        4'hB: result_binary = first_operand_binary - second_operand_binary;
        4'hC: result_binary = first_operand_binary * second_operand_binary;
        default: result_binary = 0;
    endcase
end
    
endmodule