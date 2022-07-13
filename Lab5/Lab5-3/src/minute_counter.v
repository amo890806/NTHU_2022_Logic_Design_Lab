module minute_counter (
    input clk,
    input rst_n,
    input count_en,
    input reset_en,
    input [5:0] init,
    input mode,
    input borrow,
    output empty,
    output reg [5:0] binary
);

always @(posedge clk or negedge rst_n or negedge reset_en) begin
    if(!rst_n)begin
        binary <= 0;
    end
    else if(!reset_en)begin
        if(!count_en)begin
            binary <= init;
        end
    end
    else begin
        if(!mode)begin            
            if(count_en)begin
                binary <= (borrow) ? ((binary == 0) ? 0 : binary-1) : binary;
            end
        end
        else begin
            binary <= init;
        end
    end
end

assign empty = (mode) ? 0 : (binary == 0);
    
endmodule