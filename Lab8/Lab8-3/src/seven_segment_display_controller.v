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
`define SSD_F 8'b0111000_1

module seven_segment_display_controller (
    input clk,
    input rst,
    input [1:0] state,
    input [15:0] first_operand_BCD,
    input [15:0] second_operand_BCD,
    input [3:0] operator,
    input [15:0] result_BCD,
    output reg [7:0] display,
    output reg [3:0] ctrl
);

`define PRESS_FIRST_OPERAND 0
`define PRESS_OPERATOR 1
`define PRESS_SECOND_OPERAND 2
`define PRESS_ENTER 3

reg [3:0] BCD_sel;
reg [1:0] cnt;

always @(*) begin
    case (cnt)
        1: begin
            if(state == `PRESS_FIRST_OPERAND)begin
                BCD_sel = first_operand_BCD[15:12];
            end
            else if(state == `PRESS_OPERATOR)begin
                BCD_sel = 0;
            end
            else if(state == `PRESS_SECOND_OPERAND)begin
                BCD_sel = second_operand_BCD[15:12];
            end
            else begin
                BCD_sel = result_BCD[15:12];
            end
        end
        2:begin
            if(state == `PRESS_FIRST_OPERAND)begin
                BCD_sel = first_operand_BCD[11:8];
            end
            else if(state == `PRESS_OPERATOR)begin
                BCD_sel = 0;
            end
            else if(state == `PRESS_SECOND_OPERAND)begin
                BCD_sel = second_operand_BCD[11:8];
            end
            else begin
                BCD_sel = result_BCD[11:8];
            end
        end
        3: begin
            if(state == `PRESS_FIRST_OPERAND)begin
                BCD_sel = first_operand_BCD[7:4];
            end
            else if(state == `PRESS_OPERATOR)begin
                BCD_sel = 0;
            end
            else if(state == `PRESS_SECOND_OPERAND)begin
                BCD_sel = second_operand_BCD[7:4];
            end
            else begin
                BCD_sel = result_BCD[7:4];
            end
        end
        0: begin
            if(state == `PRESS_FIRST_OPERAND)begin
                BCD_sel = first_operand_BCD[3:0];
            end
            else if(state == `PRESS_OPERATOR)begin
                BCD_sel = operator;
            end
            else if(state == `PRESS_SECOND_OPERAND)begin
                BCD_sel = second_operand_BCD[3:0];
            end
            else begin
                BCD_sel = result_BCD[3:0];
            end
        end
    endcase
end


always @(*) begin
    case (BCD_sel)
        //BCD to 7-segment_star_dot
        4'h0: display = `SSD_0;
        4'h1: display = `SSD_1;
        4'h2: display = `SSD_2;
        4'h3: display = `SSD_3;
        4'h4: display = `SSD_4;
        4'h5: display = `SSD_5;
        4'h6: display = `SSD_6;
        4'h7: display = `SSD_7;
        4'h8: display = `SSD_8;
        4'h9: display = `SSD_9;
        4'hA: display = `SSD_A;
        4'hB: display = `SSD_S;
        4'hC: display = `SSD_M;
        default: display = `SSD_F;
    endcase
end

always @(posedge clk or posedge rst) begin
    if(rst)begin
        cnt <= 0;
    end
    else begin
        cnt <= cnt + 1;
    end
end

always @(posedge clk or posedge rst) begin
    if(rst)begin
        ctrl <= 4'b1110;
    end
    else begin
        ctrl <= {ctrl[0], ctrl[3:1]};
    end
end
    
endmodule