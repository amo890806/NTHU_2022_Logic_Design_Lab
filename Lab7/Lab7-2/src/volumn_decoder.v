module volumn_decoder (
    input clk,
    input rst_n,
    input inc,
    input dec,
    output reg [15:0] vol_high,
    output reg [15:0] vol_low,
    output reg [3:0] binary
);

wire [1:0] sel = {inc, dec};

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        binary <= 0;
    end
    else begin
        case(sel)
            2'b10: binary <= (binary == 15) ? 15 : binary+1;
            2'b01: binary <= (binary == 0) ? 0 : binary-1;
        endcase
    end
end

always @(*) begin
    case(binary)
        0: vol_high = 16'h0000;
        1: vol_high = 16'h0666; //1638
        2: vol_high = 16'h0CCD; //3276+1
        3: vol_high = 16'h1332; //4914
        4: vol_high = 16'h6552; //6552
        5: vol_high = 16'h1FFF; //8190+1
        6: vol_high = 16'h2664; //9828
        7: vol_high = 16'h2CCA; //11466
        8: vol_high = 16'h3331; //13104+1
        9: vol_high = 16'h3996; //14742
        10: vol_high = 16'h3FFC; //16380
        11: vol_high = 16'h4663; //18018+1
        12: vol_high = 16'h4CC8; //19656
        13: vol_high = 16'h532E; //21294
        14: vol_high = 16'h5995; //22932+1
        15: vol_high = 16'h5FFF; //24575
    endcase
end

always @(*) begin
    case(binary)
        0: vol_low = 16'h0000;
        1: vol_low = 16'hFAAB; //-1365
        2: vol_low = 16'hF555; //-2730-1
        3: vol_low = 16'hF001; //-4095
        4: vol_low = 16'hEAAC; //-5460
        5: vol_low = 16'hE556; //-6825-1
        6: vol_low = 16'hE002; //-8190
        7: vol_low = 16'hDAAD; //-9555
        8: vol_low = 16'hD557; //-10920-1
        9: vol_low = 16'hD003; //-12285
        10: vol_low = 16'hCAAE; //-13650
        11: vol_low = 16'hC558; //-15015-1
        12: vol_low = 16'hC004; //-16380
        13: vol_low = 16'hBAAF; //-17745
        14: vol_low = 16'hB559; //-19110-1
        15: vol_low = 16'hB000; //-20480
    endcase
end
    
endmodule