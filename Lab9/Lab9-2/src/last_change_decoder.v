`define PRESS_FIRST_OPERAND 0
`define PRESS_OPERATOR 1
`define PRESS_SECOND_OPERAND 2
`define PRESS_ENTER 3

module last_change_decoder (
    input clk,
    input rst,
    input [1:0] state,
    input press_num,
    input press_asm,
    input press_enter,
    input key_down_onepulse,
    input [8:0] last_change,
    output reg [3:0] BCD
);

reg [3:0] BCD_dly;

always @(*) begin
    case (last_change)
        //last_change to binary
        9'h0_70: BCD = 4'h0;
        9'h0_69: BCD = 4'h1;
        9'h0_72: BCD = 4'h2;
        9'h0_7A: BCD = 4'h3;
        9'h0_6B: BCD = 4'h4;
        9'h0_73: BCD = 4'h5;
        9'h0_74: BCD = 4'h6;
        9'h0_6C: BCD = 4'h7;
        9'h0_75: BCD = 4'h8;
        9'h0_7D: BCD = 4'h9;
        9'h0_79: BCD = 4'hA;
        9'h0_7B: BCD = 4'hB;
        9'h0_7C: BCD = 4'hC;
        default: BCD = BCD_dly;
    endcase
end

always @(posedge clk or posedge rst) begin
    if(rst)begin
        BCD_dly <= 0;
    end
    else begin
        case (state)
            `PRESS_FIRST_OPERAND: BCD_dly <= (press_num) ? ((key_down_onepulse)?BCD:BCD_dly) : BCD_dly;
            `PRESS_OPERATOR: BCD_dly <= (press_asm) ? ((key_down_onepulse)?BCD:BCD_dly) : BCD_dly;
            `PRESS_SECOND_OPERAND: BCD_dly <= (press_num) ? ((key_down_onepulse)?BCD:BCD_dly) : BCD_dly;
        endcase
    end
end

    
endmodule