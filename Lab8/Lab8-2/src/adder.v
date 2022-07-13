module adder (
    input clk,
    input rst,
    input load,
    input key_down_onepulse,
    input [3:0] BCD,
    output reg [3:0] addend_BCD,
    output reg [3:0] augend_BCD,
    output [5:0] sum_binary
);

always @(posedge clk or posedge rst) begin
    if(rst)begin
        addend_BCD <= 0;
    end
    else begin
        if(!load)begin
            addend_BCD <= (key_down_onepulse) ? BCD : addend_BCD;
        end
    end
end

always @(posedge clk or posedge rst) begin
    if(rst)begin
        augend_BCD <= 0;
    end
    else begin
        if(load)begin
            augend_BCD <= (key_down_onepulse) ? BCD : 0;
        end
    end
end

assign sum_binary = addend_BCD + augend_BCD;
    
endmodule