`define LOWER_CASE 0
`define UPPER_CASE 1

module controller (
    input clk,
    input rst,
    input [8:0] last_change,
    input key_down_onepulse,
    input press_shift,
    output caps,
    output caps_sel
);

wire press_caps = (last_change == 9'h0_58);

reg cs, ns;

always @(posedge clk or posedge rst) begin
    if(rst)begin
        cs <= `LOWER_CASE;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case(cs)
        `LOWER_CASE: ns = (press_caps) ? ((key_down_onepulse) ? `UPPER_CASE : `LOWER_CASE) : `LOWER_CASE;
        `UPPER_CASE: ns = (press_caps) ? ((key_down_onepulse) ? `LOWER_CASE : `UPPER_CASE) : `UPPER_CASE;
    endcase
end

assign caps_sel = cs ^ press_shift;
assign caps = cs;

endmodule