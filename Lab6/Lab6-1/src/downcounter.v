module downcounter (
    input clk,
    input rst_n,
    input count_en,
    input reset_en,
    input [8:0] init,
    output reg [8:0] binary,
    output time_borrow
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        binary <= 59;
    end
    else if(reset_en)begin
        if(!count_en)begin
            binary <= init;
        end
    end
    else begin
        if(count_en)begin
            binary <= (binary == 0) ? ((time_borrow) ? init : 0) : binary-1;
        end
    end
end

assign time_borrow = (count_en && (binary == 0));
    
endmodule