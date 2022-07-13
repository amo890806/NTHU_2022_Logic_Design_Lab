`define SSD_0 8'b0000001_1
`define SSD_1 8'b1001111_1
`define SSD_2 8'b0010010_1
`define SSD_3 8'b0000110_1
`define SSD_4 8'b1001100_1
`define SSD_5 8'b0100100_1
`define SSD_6 8'b0100000_1
`define SSD_7 8'b0001111_1
`define SSD_8 8'b0000000_1
`define SSD_9 8'b0000100_1
`define SSD_A 8'b0001000_1
`define SSD_S 8'b0100101_1
`define SSD_M 8'b0101010_1

`define INIT 0
`define PRESS_NUM 1
`define PRESS_ASM 2

module seven_segment_display_decoder (
    input clk,
    input rst,
    input [8:0] last_change, 
    output reg [7:0] display,
    output reg [3:0] ctrl
);

wire press_enter = (last_change == 9'h0_5A);
wire press_asm = (last_change == 9'h0_1C) || (last_change == 9'h0_1B) || (last_change == 9'h0_3A);
wire press_num = (last_change == 9'h0_45) || (last_change == 9'h0_16) || (last_change == 9'h0_1E) ||
                 (last_change == 9'h0_26) || (last_change == 9'h0_25) || (last_change == 9'h0_2E) ||
                 (last_change == 9'h0_36) || (last_change == 9'h0_3D) || (last_change == 9'h0_3E) ||  
                 (last_change == 9'h0_46);

reg [1:0] cs, ns;
reg [7:0] display_dly;

always @(posedge clk or posedge rst) begin
    if(rst)begin
        cs <= `INIT;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case(cs)
        `INIT:begin
            if(press_num) ns = `PRESS_NUM;
            else if(press_asm) ns = `PRESS_ASM;
            else ns = `INIT;
        end
        `PRESS_NUM: ns = (press_asm) ? `PRESS_ASM : `PRESS_NUM;
        `PRESS_ASM: ns = (press_num) ? `PRESS_NUM : `PRESS_ASM; 
        default: ns = `INIT;
    endcase
end

always @(*) begin
    case (last_change)
        //last_change to 7-segment_star_dot
        9'h0_45: display = `SSD_0;
        9'h0_16: display = `SSD_1;
        9'h0_1E: display = `SSD_2;
        9'h0_26: display = `SSD_3;
        9'h0_25: display = `SSD_4;
        9'h0_2E: display = `SSD_5;
        9'h0_36: display = `SSD_6;
        9'h0_3D: display = `SSD_7;
        9'h0_3E: display = `SSD_8;
        9'h0_46: display = `SSD_9;
        9'h0_1C: display = `SSD_A;
        9'h0_1B: display = `SSD_S;
        9'h0_3A: display = `SSD_M;
        default: display = display_dly;
    endcase
end

always @(posedge clk or posedge rst) begin
    if(rst)begin
        display_dly <= 0;
    end
    else begin
        case(cs)
            `PRESS_NUM: display_dly <= display;
            `PRESS_ASM: begin
                if(press_enter) display_dly <= 8'b1111111_1;
                else display_dly <= display;
            end
        endcase
    end
end



always @(*) begin
    case(cs)
        `INIT: ctrl = 4'b1111;
        `PRESS_NUM: ctrl = 4'b1110;
        `PRESS_ASM: ctrl = (press_enter) ? 4'b1111 : 4'b1110;
        default: ctrl = 4'b1111;
    endcase
end
    
endmodule