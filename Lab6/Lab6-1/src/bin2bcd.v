module bin2bcd (
    input [8:0] binary,
    output [7:0] BCD
);

reg [11:0] BCD_tmp;

integer i;

always @(*) begin
    BCD_tmp = 0;
    for(i=0; i<9; i=i+1)begin
        if(BCD_tmp[3:0] > 4)begin
            BCD_tmp[3:0] =  BCD_tmp[3:0] + 3;
        end
        if(BCD_tmp[7:4] > 4)begin
            BCD_tmp[7:4] =  BCD_tmp[7:4] + 3;
        end
        if(BCD_tmp[11:8] > 4)begin
            BCD_tmp[11:8] = BCD_tmp[11:8] + 3;
        end
        BCD_tmp = {BCD_tmp[10:0], binary[8-i]};
    end
end

assign BCD = BCD_tmp[7:0];

endmodule
