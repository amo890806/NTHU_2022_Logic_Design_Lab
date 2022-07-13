module buzzer_control (
    input clk,
    input rst_n,
    input [21:0] note_div_left,
    input [21:0] note_div_right,
    output [15:0] audio_in_left,
    output [15:0] audio_in_right
);

reg [21:0] cnt_left, cnt_right;
reg b_clk_left, b_clk_right;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        cnt_left <= 0;
    end
    else begin
        cnt_left <= (cnt_left == note_div_left-1) ? 0 : cnt_left+1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        b_clk_left <= 0;
    end
    else begin
        b_clk_left <= (cnt_left == note_div_left-1) ? ~b_clk_left : b_clk_left;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        cnt_right <= 0;
    end
    else begin
        cnt_right <= (cnt_right == note_div_right-1) ? 0 : cnt_right+1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        b_clk_right <= 0;
    end
    else begin
        b_clk_right <= (cnt_right == note_div_right-1) ? ~b_clk_right : b_clk_right;
    end
end

assign audio_in_left = (~b_clk_left) ? 16'h5FFF : 16'hB000;
assign audio_in_right = (~b_clk_right) ? 16'h5FFF : 16'hB000;
    
endmodule