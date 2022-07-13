module down_counter (
    input clk,
    input rst_n,
    input count_en,
    input push_onepulse,
    output [15:0] led
);

reg [5:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        cnt <= 6'd40;
    end
    else begin
        if(count_en)begin
            cnt <= (push_onepulse) ? 6'd40 : ((cnt==0) ? 6'd40 : cnt-1);
        end
        else begin
            cnt <= (push_onepulse) ? 6'd40 : cnt;
        end
    end
end

assign led[15:1] = (cnt == 0) ? 15'h7FFF : 0;
assign led[0] = (cnt == 0) ? 1 : count_en;
    
endmodule