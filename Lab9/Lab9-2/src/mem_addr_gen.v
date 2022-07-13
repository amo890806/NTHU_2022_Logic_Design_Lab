`define PRESS_FIRST_OPERAND 0
`define PRESS_OPERATOR 1
`define PRESS_SECOND_OPERAND 2
`define PRESS_ENTER 3

module mem_addr_gen (
    input clk,
    input rst,
    input [1:0] press_num_cnt,
    input [1:0] state,
    input [9:0] h_cnt,
    input [9:0] v_cnt,
    input [15:0] first_operand_BCD,
    input [15:0] second_operand_BCD,
    input [3:0] operator,
    input [15:0] result_BCD,
    output reg [15:0] thousands_pixel_addr,
    output reg [15:0] hundreds_pixel_addr,
    output reg [15:0] tens_pixel_addr,
    output reg [15:0] digits_pixel_addr
);

wire [15:0] digits_ref = ((h_cnt-480)>>1)+80*((v_cnt-120)>>1);
wire [15:0] tens_ref = ((h_cnt-360)>>1)+80*((v_cnt-120)>>1);
wire [15:0] hundreds_ref = ((h_cnt-240)>>1)+80*((v_cnt-120)>>1);
wire [15:0] thousands_ref = ((h_cnt-120)>>1)+80*((v_cnt-120)>>1);

always @(*) begin
    if(h_cnt < 480)begin
        digits_pixel_addr = 0;
    end
    else begin
        if(v_cnt < 200 || v_cnt > 280)begin
            digits_pixel_addr = 0;
        end
        else begin
            if(state == `PRESS_FIRST_OPERAND)begin
                case (first_operand_BCD[3:0])
                    0: digits_pixel_addr = digits_ref;
                    1: digits_pixel_addr = digits_ref + 80*46;
                    2: digits_pixel_addr = digits_ref + 80*92;
                    3: digits_pixel_addr = digits_ref + 80*138;
                    4: digits_pixel_addr = digits_ref + 80*185;
                    5: digits_pixel_addr = digits_ref + 80*231;
                    6: digits_pixel_addr = digits_ref + 80*278;
                    7: digits_pixel_addr = digits_ref + 80*324;
                    8: digits_pixel_addr = digits_ref + 80*371;
                    9: digits_pixel_addr = digits_ref + 80*417;
                    default: digits_pixel_addr = 0;
                endcase
            end
            else if(state == `PRESS_OPERATOR)begin
                case (operator)
                    4'hA: digits_pixel_addr = digits_ref + 80*464;
                    4'hB: digits_pixel_addr = digits_ref + 80*511;
                    4'hC: digits_pixel_addr = digits_ref + 80*550;
                    default: digits_pixel_addr = 0;
                endcase
            end
            else if(state == `PRESS_SECOND_OPERAND)begin
                case (second_operand_BCD[3:0])
                    0: digits_pixel_addr = digits_ref;
                    1: digits_pixel_addr = digits_ref + 80*46;
                    2: digits_pixel_addr = digits_ref + 80*92;
                    3: digits_pixel_addr = digits_ref + 80*138;
                    4: digits_pixel_addr = digits_ref + 80*185;
                    5: digits_pixel_addr = digits_ref + 80*231;
                    6: digits_pixel_addr = digits_ref + 80*278;
                    7: digits_pixel_addr = digits_ref + 80*324;
                    8: digits_pixel_addr = digits_ref + 80*371;
                    9: digits_pixel_addr = digits_ref + 80*417;
                    default: digits_pixel_addr = 0;
                endcase
            end
            else begin
                case (result_BCD[3:0])
                    0: digits_pixel_addr = (result_BCD[15:4] == 0) ? 0 : digits_ref;
                    1: digits_pixel_addr = digits_ref + 80*46;
                    2: digits_pixel_addr = digits_ref + 80*92;
                    3: digits_pixel_addr = digits_ref + 80*138;
                    4: digits_pixel_addr = digits_ref + 80*185;
                    5: digits_pixel_addr = digits_ref + 80*231;
                    6: digits_pixel_addr = digits_ref + 80*278;
                    7: digits_pixel_addr = digits_ref + 80*324;
                    8: digits_pixel_addr = digits_ref + 80*371;
                    9: digits_pixel_addr = digits_ref + 80*417;
                    default: digits_pixel_addr = 0;
                endcase
            end
        end
    end
end

always @(*) begin
    if(h_cnt < 360 || h_cnt >= 480)begin
        tens_pixel_addr = 0;
    end
    else begin
        if(v_cnt < 200 || v_cnt > 280)begin
            tens_pixel_addr = 0;
        end
        else begin
            if(state == `PRESS_FIRST_OPERAND)begin
                case (first_operand_BCD[7:4])
                    0: tens_pixel_addr = (press_num_cnt == 2) ? tens_ref : 0;
                    1: tens_pixel_addr = tens_ref + 80*46;
                    2: tens_pixel_addr = tens_ref + 80*92;
                    3: tens_pixel_addr = tens_ref + 80*138;
                    4: tens_pixel_addr = tens_ref + 80*185;
                    5: tens_pixel_addr = tens_ref + 80*231;
                    6: tens_pixel_addr = tens_ref + 80*278;
                    7: tens_pixel_addr = tens_ref + 80*324;
                    8: tens_pixel_addr = tens_ref + 80*371;
                    9: tens_pixel_addr = tens_ref + 80*417;
                    default: tens_pixel_addr = 0;
                endcase
            end
            else if(state == `PRESS_OPERATOR)begin
                tens_pixel_addr = 0;
            end
            else if(state == `PRESS_SECOND_OPERAND)begin
                case (second_operand_BCD[7:4])
                    0: tens_pixel_addr = (press_num_cnt == 2) ? tens_ref : 0;
                    1: tens_pixel_addr = tens_ref + 80*46;
                    2: tens_pixel_addr = tens_ref + 80*92;
                    3: tens_pixel_addr = tens_ref + 80*138;
                    4: tens_pixel_addr = tens_ref + 80*185;
                    5: tens_pixel_addr = tens_ref + 80*231;
                    6: tens_pixel_addr = tens_ref + 80*278;
                    7: tens_pixel_addr = tens_ref + 80*324;
                    8: tens_pixel_addr = tens_ref + 80*371;
                    9: tens_pixel_addr = tens_ref + 80*417;
                    default: tens_pixel_addr = 0;
                endcase
            end
            else begin
                case (result_BCD[7:4])
                    0: tens_pixel_addr = (result_BCD[15:8] == 0) ? 0 : tens_ref;
                    1: tens_pixel_addr = tens_ref + 80*46;
                    2: tens_pixel_addr = tens_ref + 80*92;
                    3: tens_pixel_addr = tens_ref + 80*138;
                    4: tens_pixel_addr = tens_ref + 80*185;
                    5: tens_pixel_addr = tens_ref + 80*231;
                    6: tens_pixel_addr = tens_ref + 80*278;
                    7: tens_pixel_addr = tens_ref + 80*324;
                    8: tens_pixel_addr = tens_ref + 80*371;
                    9: tens_pixel_addr = tens_ref + 80*417;
                    default: tens_pixel_addr = 0;
                endcase
            end
        end
    end
end

always @(*) begin
    if(h_cnt < 240 || h_cnt >= 360)begin
        hundreds_pixel_addr = 0;
    end
    else begin
        if(v_cnt < 200 || v_cnt > 280)begin
            hundreds_pixel_addr = 0;
        end
        else begin
            if(state == `PRESS_FIRST_OPERAND)begin
                hundreds_pixel_addr = 0;
            end
            else if(state == `PRESS_OPERATOR)begin
                hundreds_pixel_addr = 0;
            end
            else if(state == `PRESS_SECOND_OPERAND)begin
                hundreds_pixel_addr = 0;
            end
            else begin
                case (result_BCD[11:8])
                    0: hundreds_pixel_addr = (result_BCD[15:12] == 0) ? 0 : hundreds_ref;
                    1: hundreds_pixel_addr = hundreds_ref + 80*46;
                    2: hundreds_pixel_addr = hundreds_ref + 80*92;
                    3: hundreds_pixel_addr = hundreds_ref + 80*138;
                    4: hundreds_pixel_addr = hundreds_ref + 80*185;
                    5: hundreds_pixel_addr = hundreds_ref + 80*231;
                    6: hundreds_pixel_addr = hundreds_ref + 80*278;
                    7: hundreds_pixel_addr = hundreds_ref + 80*324;
                    8: hundreds_pixel_addr = hundreds_ref + 80*371;
                    9: hundreds_pixel_addr = hundreds_ref + 80*417;
                    default: hundreds_pixel_addr = 0;
                endcase
            end
        end
    end
end

always @(*) begin
    if(h_cnt < 120 || h_cnt >= 240)begin
        thousands_pixel_addr = 0;
    end
    else begin
        if(v_cnt < 200 || v_cnt > 280)begin
            thousands_pixel_addr = 0;
        end
        else begin
            if(state == `PRESS_FIRST_OPERAND)begin
                thousands_pixel_addr = 0;
            end
            else if(state == `PRESS_OPERATOR)begin
                thousands_pixel_addr = 0;
            end
            else if(state == `PRESS_SECOND_OPERAND)begin
                thousands_pixel_addr = 0;
            end
            else begin
                case (result_BCD[15:12])
                    0: thousands_pixel_addr = 0;
                    1: thousands_pixel_addr = thousands_ref + 80*46;
                    2: thousands_pixel_addr = thousands_ref + 80*92;
                    3: thousands_pixel_addr = thousands_ref + 80*138;
                    4: thousands_pixel_addr = thousands_ref + 80*185;
                    5: thousands_pixel_addr = thousands_ref + 80*231;
                    6: thousands_pixel_addr = thousands_ref + 80*278;
                    7: thousands_pixel_addr = thousands_ref + 80*324;
                    8: thousands_pixel_addr = thousands_ref + 80*371;
                    9: thousands_pixel_addr = thousands_ref + 80*417;
                    default: thousands_pixel_addr = 0;
                endcase
            end
        end
    end
end
    
endmodule