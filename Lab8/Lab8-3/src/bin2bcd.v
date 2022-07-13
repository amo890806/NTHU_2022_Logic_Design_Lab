module bin2bcd (
    input [14:0] binary,
    output reg [15:0] BCD
);

integer i;

always @(*) begin
    BCD = 0;
    for(i=0; i<15; i=i+1)begin
        if(BCD[3:0] > 4)begin
            BCD[3:0] =  BCD[3:0] + 3;
        end
        if(BCD[7:4] > 4)begin
            BCD[7:4] =  BCD[7:4] + 3;
        end
        if(BCD[11:8] > 4)begin
            BCD[11:8] =  BCD[11:8] + 3;
        end
        if(BCD[15:12] > 4)begin
            BCD[15:12] =  BCD[15:12] + 3;
        end
        BCD = {BCD[14:0], binary[14-i]};
    end
end
    
endmodule