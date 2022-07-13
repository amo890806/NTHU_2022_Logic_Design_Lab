module debounce (
    input clk,
    input rst_n,
    input btn,
    output reg push_debounced
);

reg [3:0] push_window;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        push_window <= 0;
    end
    else begin
        push_window <= {btn, push_window[3:1]};
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        push_debounced <= 0;
    end
    else begin
        if(push_window == 4'b1111)begin
            push_debounced <= 1;
        end
        else begin
            push_debounced <= 0;
        end
    end
end
    
endmodule