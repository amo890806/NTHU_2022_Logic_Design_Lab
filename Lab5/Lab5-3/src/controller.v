module controller (
    input clk,
    input rst_n,
    input [1:0] push_onepulse,
    input mode,
    output reg count_en,
    output reg lap_en
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        count_en <= 0;
    end
    else begin
        count_en <= (mode) ? 0 : ((push_onepulse[0]) ? ~count_en : count_en); 
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        lap_en <= 0;
    end
    else begin
        if(count_en)begin
            lap_en <= (mode) ? 0 : ((push_onepulse[1]) ? ~lap_en : lap_en);
        end
        else begin
            lap_en <= 0;
        end
    end
end
    
endmodule