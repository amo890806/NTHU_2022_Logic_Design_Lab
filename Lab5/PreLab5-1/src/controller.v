`define PAUSE 0
`define COUNT 1

module controller (
    input clk,
    input rst_n,
    input push_onepulse,
    output count_en
);

reg cs, ns;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        cs <= `COUNT;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    if(cs == `COUNT)begin
        ns = (push_onepulse) ? `PAUSE : `COUNT;
    end 
    else begin
        ns = (push_onepulse) ? `COUNT : `PAUSE;
    end
end

assign count_en = (cs == `COUNT) ? 1 : 0;
    
endmodule