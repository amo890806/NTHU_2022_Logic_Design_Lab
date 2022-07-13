`define PAUSE 0
`define SCROLL 1

module controller (
    input clk,
    input rst,
    input push_onepulse,
    output scroll_en
);

reg cs, ns;

always @(posedge clk ) begin
    if(rst)begin
        cs <= `PAUSE;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case(cs)
        `PAUSE: ns = (push_onepulse) ? `SCROLL : `PAUSE;
        `SCROLL: ns = (push_onepulse) ? `PAUSE : `SCROLL;
    endcase
end

assign scroll_en = cs;
    
endmodule