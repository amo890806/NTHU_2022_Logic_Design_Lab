module last_change_decoder (
    input clk,
    input rst,
    input load,
    input press_num,
    input key_down_onepulse,
    input [8:0] last_change,
    output reg [3:0] BCD
);

reg [3:0] BCD_dly;

always @(*) begin
    case (last_change)
        //last_change to binary
        9'h0_45: BCD = 4'h0;
        9'h0_16: BCD = 4'h1;
        9'h0_1E: BCD = 4'h2;
        9'h0_26: BCD = 4'h3;
        9'h0_25: BCD = 4'h4;
        9'h0_2E: BCD = 4'h5;
        9'h0_36: BCD = 4'h6;
        9'h0_3D: BCD = 4'h7;
        9'h0_3E: BCD = 4'h8;
        9'h0_46: BCD = 4'h9;
        default: BCD = BCD_dly;
    endcase
end

always @(posedge clk or posedge rst) begin
    if(rst)begin
        BCD_dly <= 0;
    end
    else begin
        if(!load)begin
            BCD_dly <= (press_num) ? ((key_down_onepulse)?BCD:BCD_dly) : BCD_dly;
        end
    end
end

    
endmodule