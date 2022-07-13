module second_counter (
    input clk,
    input rst_n,
    input count_en,
    input reset_en,
    input [5:0] init,
    input mode,
    input empty,
    output borrow,
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
               binary <= (binary == 0) ? ((empty) ? 0 : 59) : binary-1; 
            end
        end
        else begin
            binary <= init;
        end
    end
end

assign borrow = (mode) ? 0 : (binary == 0);
    
endmodule