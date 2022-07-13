module bulls_and_cows (
    input [7:0] secret,
    input [7:0] guess,
    output reg [2:0] bulls,
    output reg [2:0] cows
);

always @(*) begin
    if((guess[7:4] == guess[3:0])||(secret[7:4] == secret[3:0]))begin
        bulls = 3'd0;
    end
    else if(guess == secret)begin
        bulls = 3'd2;
    end
    else if((guess[7:4] == secret[7:4]) || (guess[3:0] == secret[3:0]))begin
        bulls = 3'd1;
    end
    else begin
        bulls = 3'd0;
    end
end 

always @(*) begin
    if((guess[7:4] == guess[3:0])||(secret[7:4] == secret[3:0]))begin
        cows = 3'd0;
    end
    else if((guess[7:4] == secret[3:0]) && (guess[3:0] == secret[7:4]))begin
        cows = 3'd2;
    end
    else if((guess[7:4] == secret[3:0]) || (guess[3:0] == secret[7:4]))begin
        cows = 3'd1;
    end
    else begin
        cows = 3'd0;
    end
end
    
endmodule