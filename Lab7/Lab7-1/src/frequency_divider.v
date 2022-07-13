module frequency_divider (
    input clk,
    input rst_n,
    output audio_mclk,  //25MHz
    output audio_lrck,  //(25/128)MHz
    output audio_sck    //(25/128 * 32)=6.25MHz, fs = 32*fp
);

reg [9:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        cnt <= 0;
    end
    else begin
        cnt <= cnt + 1;
    end
end

assign audio_mclk = cnt[2];
assign audio_lrck = cnt[9];
assign audio_sck = cnt[4];
    
endmodule