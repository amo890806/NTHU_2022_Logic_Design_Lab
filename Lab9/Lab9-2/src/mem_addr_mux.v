module mem_addr_mux (
    input [9:0] h_cnt,
    input [15:0] thousands_pixel_addr,
    input [15:0] hundreds_pixel_addr,
    input [15:0] tens_pixel_addr,
    input [15:0] digits_pixel_addr,
    output reg [15:0] pixel_addr
);

always @(*) begin
    if(h_cnt < 240)begin
        pixel_addr = thousands_pixel_addr;
    end
    else if(h_cnt < 360)begin
        pixel_addr = hundreds_pixel_addr;
    end
    else if(h_cnt < 480)begin
        pixel_addr = tens_pixel_addr;
    end
    else begin
        pixel_addr = digits_pixel_addr;
    end
end
    
endmodule