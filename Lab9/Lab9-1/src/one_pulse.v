module one_pulse (
    input clk,
    input rst,
    input push_debounced,
    output reg push_onepulse
);

reg push_debounced_delay;

always @(posedge clk or posedge rst) begin
    if(rst)begin
        push_debounced_delay <= 0;
    end
    else begin
        push_debounced_delay <= push_debounced;
    end
end
    
always @(posedge clk or posedge rst) begin
    if(rst)begin
        push_onepulse <= 0;
    end
    else begin
        push_onepulse <= push_debounced & ~push_debounced_delay;
    end
end

endmodule