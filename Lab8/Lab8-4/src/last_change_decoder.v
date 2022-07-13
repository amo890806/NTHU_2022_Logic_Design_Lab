module last_change_decoder (
    input [8:0] last_change,
    input press_letter,
    input caps_sel,
    output reg [6:0] ASCII_code
);

always @(*) begin
    if(press_letter)begin
        case(last_change)
            9'h0_1C: ASCII_code = (caps_sel) ? 7'h41 : 7'h61;        
            9'h0_32: ASCII_code = (caps_sel) ? 7'h42 : 7'h62;
            9'h0_21: ASCII_code = (caps_sel) ? 7'h43 : 7'h63;
            9'h0_23: ASCII_code = (caps_sel) ? 7'h44 : 7'h64;
            9'h0_24: ASCII_code = (caps_sel) ? 7'h45 : 7'h65;
            9'h0_2B: ASCII_code = (caps_sel) ? 7'h46 : 7'h66;
            9'h0_34: ASCII_code = (caps_sel) ? 7'h47 : 7'h67;
            9'h0_33: ASCII_code = (caps_sel) ? 7'h48 : 7'h68;
            9'h0_43: ASCII_code = (caps_sel) ? 7'h49 : 7'h69;
            9'h0_3B: ASCII_code = (caps_sel) ? 7'h4A : 7'h6A;
            9'h0_42: ASCII_code = (caps_sel) ? 7'h4B : 7'h6B;
            9'h0_4B: ASCII_code = (caps_sel) ? 7'h4C : 7'h6C;
            9'h0_3A: ASCII_code = (caps_sel) ? 7'h4D : 7'h6D;
            9'h0_31: ASCII_code = (caps_sel) ? 7'h4E : 7'h6E;
            9'h0_44: ASCII_code = (caps_sel) ? 7'h4F : 7'h6F;
            9'h0_4D: ASCII_code = (caps_sel) ? 7'h50 : 7'h70;
            9'h0_15: ASCII_code = (caps_sel) ? 7'h51 : 7'h71;
            9'h0_2D: ASCII_code = (caps_sel) ? 7'h52 : 7'h72;
            9'h0_1B: ASCII_code = (caps_sel) ? 7'h53 : 7'h73;
            9'h0_2C: ASCII_code = (caps_sel) ? 7'h54 : 7'h74;
            9'h0_3C: ASCII_code = (caps_sel) ? 7'h55 : 7'h75;
            9'h0_2A: ASCII_code = (caps_sel) ? 7'h56 : 7'h76;
            9'h0_1D: ASCII_code = (caps_sel) ? 7'h57 : 7'h77;
            9'h0_22: ASCII_code = (caps_sel) ? 7'h58 : 7'h78;
            9'h0_35: ASCII_code = (caps_sel) ? 7'h59 : 7'h79;
            9'h0_1A: ASCII_code = (caps_sel) ? 7'h5A : 7'h7A;
            default: ASCII_code = 0;
        endcase
    end
    else begin
        ASCII_code = 0;
    end
end
    
endmodule