`define SSD_0 8'b0000001_1
`define SSD_1 8'b1001111_1
`define SSD_2 8'b0010010_1
`define SSD_3 8'b0000110_1
`define SSD_4 8'b1001100_1
`define SSD_5 8'b0100100_1
`define SSD_6 8'b0100000_1
`define SSD_7 8'b0001111_1
`define SSD_8 8'b0000000_1
`define SSD_9 8'b0000100_1
`define SSD_A 8'b0001000_1
`define SSD_B 8'b1100000_1
`define SSD_C 8'b0110001_1
`define SSD_D 8'b1000010_1
`define SSD_E 8'b0110000_1
`define SSD_F 8'b0111000_1

module seven_segment_display_decoder (
    input [3:0] binary, 
    output reg [7:0] display,
    output [3:0] ctrl
);

always @(*) begin
    case (binary)
        //binary to 7-segment_star_dot
        4'h0: display = `SSD_0;
        4'h1: display = `SSD_1;
        4'h2: display = `SSD_2;
        4'h3: display = `SSD_3;
        4'h4: display = `SSD_4;
        4'h5: display = `SSD_5;
        4'h6: display = `SSD_6;
        4'h7: display = `SSD_7;
        4'h8: display = `SSD_8;
        4'h9: display = `SSD_9;
        4'hA: display = `SSD_A;
        4'hB: display = `SSD_B;
        4'hC: display = `SSD_C;
        4'hD: display = `SSD_D;
        4'hE: display = `SSD_E;
        4'hF: display = `SSD_F;
    endcase
end

assign ctrl = 4'b1110;
assign led = binary;
    
endmodule