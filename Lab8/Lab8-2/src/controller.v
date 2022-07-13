`define PRESS_ADDEND 0
`define PRESS_AUGEND 1

module controller (
    input clk,
    input rst,
    input [8:0] last_change,
    input key_down_onepulse,
    output reg load,
    output press_num
);

reg cs, ns;
assign press_num = (last_change == 9'h0_45) || (last_change == 9'h0_16) || (last_change == 9'h0_1E) ||
                 (last_change == 9'h0_26) || (last_change == 9'h0_25) || (last_change == 9'h0_2E) ||
                 (last_change == 9'h0_36) || (last_change == 9'h0_3D) || (last_change == 9'h0_3E) ||  
                 (last_change == 9'h0_46);

always @(posedge clk or posedge rst) begin
    if(rst)begin
        cs <= `PRESS_ADDEND;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case(cs)
        `PRESS_ADDEND: ns = (press_num) ? ((key_down_onepulse)?`PRESS_AUGEND:`PRESS_ADDEND) : `PRESS_ADDEND;
        `PRESS_AUGEND: ns = (press_num) ? ((key_down_onepulse)?`PRESS_ADDEND:`PRESS_AUGEND) : `PRESS_AUGEND;
    endcase
end

always @(*) begin
    case(cs)
        `PRESS_ADDEND: load = 0;
        `PRESS_AUGEND: load = 1;
    endcase
end
    
endmodule