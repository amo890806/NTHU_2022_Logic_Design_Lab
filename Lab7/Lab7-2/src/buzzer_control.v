module buzzer_control (
    input clk,
    input rst_n,
    input [21:0] note_div,
    input [15:0] vol_high,
    input [15:0] vol_low,
    output [15:0] audio_in_left,
    output [15:0] audio_in_right
);

reg [21:0] cnt;
reg b_clk;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        cnt <= 0;
    end
    else begin
        cnt <= (cnt == note_div-1) ? 0 : cnt+1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        b_clk <= 0;
    end
    else begin
        b_clk <= (cnt == note_div-1) ? ~b_clk : b_clk;
    end
end

assign audio_in_left = (~b_clk) ? vol_high : vol_low;
assign audio_in_right = (~b_clk) ? vol_high : vol_low;
    
endmodule