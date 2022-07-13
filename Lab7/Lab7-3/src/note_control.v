module note_control (
    input Mid_Do_Mi,
    input Mid_Re_Fa,
    input Mid_Mi_So,
    input Mid_Fa_La,
    input Mid_So_Si,
    input mode,
    output reg [21:0] note_div_left,
    output reg [21:0] note_div_right
);

wire [4:0] sel;
assign sel = {Mid_Do_Mi, Mid_Re_Fa, Mid_Mi_So, Mid_Fa_La, Mid_So_Si};

always @(*) begin
    case (sel)
        5'b10000: note_div_left = 22'd191571;   //(100M/261) / 2
        5'b01000: note_div_left = 22'd170648;   //(100M/293) / 2
        5'b00100: note_div_left = 22'd151515;   //(100M/330) / 2
        5'b00010: note_div_left = 22'd143266;   //(100M/349) / 2
        5'b00001: note_div_left = 22'd127551;   //(100M/392) / 2
        default: note_div_left = 0;
    endcase
end

always @(*) begin
    if(mode)begin
        case (sel)
            5'b10000: note_div_right = 22'd151515;   //(100M/330) / 2
            5'b01000: note_div_right = 22'd143266;   //(100M/349) / 2
            5'b00100: note_div_right = 22'd127551;   //(100M/392) / 2
            5'b00010: note_div_right = 22'd113636;   //(100M/440) / 2
            5'b00001: note_div_right = 22'd101215;   //(100M/494) / 2
            default: note_div_right = 0;
        endcase
    end
    else begin
        note_div_right = note_div_left;
    end
end
    
endmodule