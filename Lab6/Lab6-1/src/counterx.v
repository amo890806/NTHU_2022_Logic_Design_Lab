module counterx (
    input clk,
    input rst_n,
    input count_en,
    input load_en,
    input [8:0] data,
    input [8:0] limit,
    input [8:0] init,
    output reg [8:0] binary,
    output time_carry
);

wire [1:0] binary_sel;
assign binary_sel = {load_en, count_en};

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        binary <= init;
    end
    else begin
        case (binary_sel)
            2'b01: binary <= (binary == limit) ? init : binary+1; 
            2'b10, 2'b11: binary <= data; 
        endcase
    end
end

assign time_carry = (binary == limit);
    
endmodule