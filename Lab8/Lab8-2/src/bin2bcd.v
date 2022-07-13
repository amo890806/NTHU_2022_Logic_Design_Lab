module bin2bcd (
    input [5:0] sum_binary,
    output reg [7:0] sum_BCD
);

integer i;

always @(*) begin
    sum_BCD = 0;
    for(i=0; i<6; i=i+1)begin
        if(sum_BCD[3:0] > 4)begin
            sum_BCD[3:0] =  sum_BCD[3:0] + 3;
        end
        if(sum_BCD[7:4] > 4)begin
            sum_BCD[7:4] =  sum_BCD[7:4] + 3;
        end
        sum_BCD = {sum_BCD[6:0], sum_binary[5-i]};
    end
end
    
endmodule