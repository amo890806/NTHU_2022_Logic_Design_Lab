module parallel_to_serial (
    input audio_lrck,
    input audio_sck,
    input rst_n,
    input [15:0] audio_in_left,
    input [15:0] audio_in_right,
    output reg audio_sdin
);

reg [31:0] audio_in;
reg [4:0] cnt;

always @(posedge audio_sck or negedge rst_n) begin
    if(!rst_n)begin
        cnt <= 31;
    end
    else begin
        cnt <= cnt - 1;
    end
end

always @(negedge audio_lrck or negedge rst_n) begin
    if(!rst_n)begin
        audio_in <= 0;
    end
    else begin
        audio_in <= {audio_in_left, audio_in_right};
    end
end

always @(negedge audio_sck or negedge rst_n) begin
    if(!rst_n)begin
        audio_sdin <= 0;
    end
    else begin
        audio_sdin <= audio_in[cnt];
    end
end
    
endmodule