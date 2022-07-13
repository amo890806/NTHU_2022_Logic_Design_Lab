module setup (
    input clk,
    input rst_n,
    input [1:0] push_onepulse,
    input mode,
    output reg [5:0] min_init,
    output reg [5:0] sec_init
);

wire carry;
assign carry = (sec_init == 59) ? 1 : 0;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        sec_init <= 0;
    end
    else begin
        if(mode)begin
            if(push_onepulse[0])begin
                sec_init <= (sec_init == 59) ? 0 : sec_init+1; 
            end
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        min_init <= 0;
    end
    else begin
        if(mode)begin
            if(push_onepulse[1])begin
                min_init <= (min_init == 59) ? 0 : min_init+1; 
            end
            else if(push_onepulse[0])begin
                min_init <= (carry) ? ((min_init == 59) ? 0 : min_init+1) : min_init;
            end
        end
    end
end
    
endmodule