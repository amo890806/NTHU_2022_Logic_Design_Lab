module bin2bcd (
    input [5:0] binary,
    output [3:0] tens_BCD,
    output [3:0] digits_BCD
);

reg [7:0] BCD;

integer i;

always @(*) begin
    BCD = 0;
    for(i=0; i<6; i=i+1)begin
        if(BCD[3:0] > 4)begin
            BCD[3:0] =  BCD[3:0] + 3;
        end
        if(BCD[7:4] > 4)begin
            BCD[7:4] =  BCD[7:4] + 3;
        end
        BCD = {BCD[6:0], binary[5-i]};
    end
end

assign {tens_BCD, digits_BCD} = BCD;
    
endmodule