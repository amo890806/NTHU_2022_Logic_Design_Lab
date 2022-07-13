module vga_display_mux (
    input valid,
    input [11:0] pixel,
    output [11:0] vga_RGB
);

assign vga_RGB = (valid) ? pixel : 0;
    
endmodule