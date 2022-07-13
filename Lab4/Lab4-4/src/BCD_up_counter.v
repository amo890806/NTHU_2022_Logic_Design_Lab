module BCD_up_counter (
    input clk,
    input rst_n,
    output reg [3:0] tens_BCD,
    output reg [3:0] digits_BCD
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        digits_BCD <= 0;
    end
    else begin
        digits_BCD <= (digits_BCD == 4'd9) ? 0 : digits_BCD+1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        tens_BCD <= 0;
    end
    else begin
        tens_BCD <= (digits_BCD == 4'd9) ? ((tens_BCD == 4'd9) ? 0 : tens_BCD+1) : tens_BCD;
    end
end
    
endmodule