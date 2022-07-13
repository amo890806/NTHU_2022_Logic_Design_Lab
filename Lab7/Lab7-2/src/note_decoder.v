module note_decoder (
    input Mid_Do,
    input Mid_Re,
    input Mid_Mi,
    output reg [21:0] note_div
);

wire [2:0] sel;
assign sel = {Mid_Do, Mid_Re, Mid_Mi};

always @(*) begin
    case (sel)
        3'b100: note_div = 22'd191571;   //(100M/261) / 2
        3'b010: note_div = 22'd170648;   //(100M/293) / 2
        3'b001: note_div = 22'd151515;   //(100M/330) / 2
        default: note_div = 0;
    endcase
end
    
endmodule
