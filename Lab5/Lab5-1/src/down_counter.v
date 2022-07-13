module down_counter (
    input clk,
    input rst_n,
    input count_en,
    output reg [5:0] binary,
    output [15:0] led
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        binary <= 6'd40;
    end
    else begin
        if(count_en)begin
            binary <= (binary==0) ? 6'd40 : binary-1;
        end
    end
end

assign led[15:1] = (binary == 0) ? 15'h7FFF : 0;
assign led[0] = (binary == 0) ? 1 : count_en;
    
endmodule