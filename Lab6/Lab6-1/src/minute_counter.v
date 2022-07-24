module minute_counter (
    input clk,
    input rst_n,
    input count_en,
    input reset_en,
    input carry,
    output reg [8:0] binary
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        binary <= 0;
    end
    else if(reset_en)begin
        if(!count_en)begin
            binary <= 0;
        end
    end
    else begin
        if(count_en)begin
            binary <= (carry) ? ((binary == 59) ? 0 : binary+1) : binary;
        end
    end
end
    
endmodule