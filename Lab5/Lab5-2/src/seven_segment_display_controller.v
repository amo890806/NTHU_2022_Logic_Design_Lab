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
`define SSD_F 8'b0111000_1

module seven_segment_display_controller (
    input clk,
    input rst_n,
    input [7:0] min_BCD,
    input [7:0] sec_BCD,
    input lap_en,
    output reg [7:0] display,
    output reg [3:0] ctrl
);

reg [3:0] BCD_sel;
reg [1:0] cnt;
reg [7:0] min_BCD_dly, sec_BCD_dly;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        cnt <= 0;
    end
    else begin
        cnt <= cnt + 1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        min_BCD_dly <= 0;
    end
    else begin
        min_BCD_dly <= (lap_en) ? min_BCD_dly : min_BCD;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        sec_BCD_dly <= 0;
    end
    else begin
        sec_BCD_dly <= (lap_en) ? sec_BCD_dly : sec_BCD;
    end
end

always @(*) begin
    case(cnt)
        1: BCD_sel = (lap_en) ? min_BCD_dly[7:4] : min_BCD[7:4];
        2: BCD_sel = (lap_en) ? min_BCD_dly[3:0] : min_BCD[3:0];
        3: BCD_sel = (lap_en) ? sec_BCD_dly[7:4] : sec_BCD[7:4];
        0: BCD_sel = (lap_en) ? sec_BCD_dly[3:0] : sec_BCD[3:0];
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
        default: display = `SSD_F;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        ctrl <= 4'b1110;
    end
    else begin
        ctrl <= {ctrl[0], ctrl[3:1]};
    end
end
    
endmodule