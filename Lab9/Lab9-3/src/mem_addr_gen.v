`define H_REF 260
`define STEP 24

module mem_addr_gen (
    input clk,
    input rst,
    input [9:0] h_cnt,
    input [9:0] v_cnt,
    input [2:0] random,
    output reg [12:0] pixel_addr
);

integer i, j;

reg [2:0] data [0:3] [0:19];    //4*20
reg [4:0] step_cnt;
reg [2:0] random_reg;
//x: 0=>H_CENTER ~ H_CENTER+24 ; 1=>H_CENTER+24 ~ H_CENTER+48 ; 2=>H_CENTER+48 ~ H_CENTER+72 3=>H_CENTER+72 ~ H_CENTER+96 ;
//y: 0=>0~24 ; 1=>24~48, ..., 19=>456~480

reg pause_en, pause_en_dly;
always @(*) begin
    if(step_cnt > 0)begin
        case (random_reg)
            1: pause_en = (data[0][step_cnt+1] != 0) || (data[1][step_cnt+1] != 0) || (data[2][step_cnt+1] != 0) || (data[3][step_cnt+1] != 0);
            2: pause_en = (data[0][step_cnt+1] != 0) || (data[1][step_cnt+1] != 0) || (data[2][step_cnt+1] != 0);
            3: pause_en = (data[1][step_cnt+1] != 0) || (data[2][step_cnt+1] != 0) || (data[3][step_cnt+1] != 0);
            4: pause_en = (data[1][step_cnt+1] != 0) || (data[2][step_cnt+1] != 0);
            5: pause_en = (data[1][step_cnt+1] != 0) || (data[2][step_cnt+1] != 0);
            6: pause_en = (data[1][step_cnt+1] != 0) || (data[2][step_cnt+1] != 0) || (data[3][step_cnt+1] != 0);
            7: pause_en = (data[2][step_cnt+1] != 0) || (data[3][step_cnt+1] != 0);
            default: pause_en = 0;
        endcase
    end
    else begin
        if(data[0][0]!=0 || data[1][0]!=0 || data[2][0]!=0 || data[3][0]!=0)begin
            pause_en = 1;
        end
        else begin
            case (random)
                1: pause_en = (data[0][1] != 0) || (data[1][1] != 0) || (data[2][1] != 0) || (data[3][1] != 0);
                2: pause_en = (data[0][1] != 0) || (data[1][1] != 0) || (data[2][1] != 0);
                3: pause_en = (data[1][1] != 0) || (data[2][1] != 0) || (data[3][1] != 0);
                4: pause_en = (data[1][1] != 0) || (data[2][1] != 0);
                5: pause_en = (data[1][1] != 0) || (data[2][1] != 0);
                6: pause_en = (data[1][1] != 0) || (data[2][1] != 0) || (data[3][1] != 0);
                7: pause_en = (data[2][1] != 0) || (data[3][1] != 0);
                default: pause_en = 0;
            endcase
        end
    end
end

always @(posedge clk or posedge rst) begin
    if(rst)begin
        pause_en_dly <= 0;
    end
    else begin
        pause_en_dly <= pause_en;
    end
end

always @(posedge clk or posedge rst) begin
    if(rst)begin
        step_cnt <= 0;
    end
    else begin
        step_cnt <= (step_cnt == 19) ? 0 : ((pause_en)?0:step_cnt+1);
    end
end

always @(posedge clk or posedge rst) begin
    if(rst)begin
        random_reg <= 0;
    end
    else begin
        if(step_cnt == 0)begin
            random_reg <= random;   
        end
    end
end

always @(posedge clk or posedge rst) begin
    if(rst)begin
        for(i=0; i<4; i=i+1)begin
            for(j=0; j<20; j=j+1)begin
                data[i][j] <= 0;
            end
        end
    end
    else begin
            if(step_cnt == 0)begin
                if(data[0][0]==0 && data[1][0]==0 && data[2][0]==0 && data[3][0]==0)begin
                    case(random)
                        1: begin
                            data[0][0] <= 1;
                            data[1][0] <= 1;
                            data[2][0] <= 1;
                            data[3][0] <= 1;
                        end
                        2: begin
                            data[0][0] <= 2;
                            data[1][0] <= 2;
                            data[2][0] <= 2;
                        end
                        3: begin
                            data[1][0] <= 3;
                            data[2][0] <= 3;
                            data[3][0] <= 3;
                        end
                        4: begin
                            data[1][0] <= 4;
                            data[2][0] <= 4;
                        end
                        5: begin
                            data[1][0] <= 5;
                            data[2][0] <= 5;
                        end
                        6: begin
                            data[1][0] <= 6;
                            data[2][0] <= 6;
                            data[3][0] <= 6;
                        end
                        7: begin
                            data[2][0] <= 7;
                            data[3][0] <= 7;
                        end
                    endcase
                end
            end
            else if(step_cnt == 1)begin
                if(!pause_en_dly)begin
                    case(random_reg)
                        1: begin
                            data[0][0] <= 0;
                            data[1][0] <= 0;
                            data[2][0] <= 0;
                            data[3][0] <= 0;
                        end
                        2: begin
                            data[1][0] <= 0;
                            data[2][0] <= 0;
                        end
                        3: begin
                            data[1][0] <= 0;
                            data[2][0] <= 0;
                        end
                        4: begin
                            data[1][0] <= 4;
                            data[2][0] <= 4;
                        end
                        5: begin
                            data[1][0] <= 0;
                            data[3][0] <= 5;
                        end
                        6: begin
                            data[1][0] <= 0;
                            data[3][0] <= 0;
                        end
                        7: begin
                            data[1][0] <= 7;
                            data[3][0] <= 0;
                        end
                    endcase
                    for(i=0; i<4; i=i+1)begin
                        data[i][1] <= data[i][0];
                    end
                end
            end
            else begin
                if(!pause_en_dly)begin
                    for(i=0; i<4; i=i+1)begin
                        data[i][step_cnt-2] <= 0; 
                        data[i][step_cnt-1] <= data[i][step_cnt-2];
                        if(data[i][step_cnt] == 0)begin
                            data[i][step_cnt] <= data[i][step_cnt-1];
                        end
                    end
                end
            end
    end
end

always @(*) begin
    if(h_cnt <= `H_REF-24*3 || h_cnt >= `H_REF+24*7)begin
        pixel_addr = 1; //black
    end
    else begin
        if(h_cnt < `H_REF || h_cnt >= `H_REF+96)begin
            if(h_cnt == `H_REF-24*2 || h_cnt == `H_REF-24*1 || h_cnt == `H_REF+24*4 || h_cnt == `H_REF+24*5 || h_cnt == `H_REF+24*6 ||
               v_cnt == 0 || v_cnt == 24*1 || v_cnt == 24*2 || v_cnt == 24*3 || v_cnt == 24*4 ||
               v_cnt == 24*5 || v_cnt == 24*6 || v_cnt == 24*7 || v_cnt == 24*8 || v_cnt == 24*9 ||
               v_cnt == 24*10 || v_cnt == 24*11 || v_cnt == 24*12 || v_cnt == 24*13 || v_cnt == 24*14 ||
               v_cnt == 24*15 || v_cnt == 24*16 || v_cnt == 24*17 || v_cnt == 24*18 || v_cnt == 24*19)begin
                pixel_addr = 1; //black
            end
            else begin
                pixel_addr = 0; //gray
            end
        end
        else begin

            //draw square block
            if(h_cnt == `H_REF || h_cnt == `H_REF+24*1 || h_cnt == `H_REF+24*2 || h_cnt == `H_REF+24*3 ||
               v_cnt == 0 || v_cnt == 24*1 || v_cnt == 24*2 || v_cnt == 24*3 || v_cnt == 24*4 ||
               v_cnt == 24*5 || v_cnt == 24*6 || v_cnt == 24*7 || v_cnt == 24*8 || v_cnt == 24*9 ||
               v_cnt == 24*10 || v_cnt == 24*11 || v_cnt == 24*12 || v_cnt == 24*13 || v_cnt == 24*14 ||
               v_cnt == 24*15 || v_cnt == 24*16 || v_cnt == 24*17 || v_cnt == 24*18 || v_cnt == 24*19 )begin
                pixel_addr = 1; //black
            end

            //i=0, j=0
            else if((`H_REF < h_cnt) && (h_cnt < `H_REF+24*1) && (0 < v_cnt) && (v_cnt < 24*1))begin
                case(data[0][0])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=1, j=0
            else if((`H_REF+24*1 < h_cnt) && (h_cnt < `H_REF+24*(1+1)) && (0 < v_cnt) && (v_cnt < 24*1))begin
                case(data[1][0])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=2, j=0
            else if((`H_REF+24*2 < h_cnt) && (h_cnt < `H_REF+24*(2+1)) && (0 < v_cnt) && (v_cnt < 24*1))begin
                case(data[2][0])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=3, j=0
            else if((`H_REF+24*3 < h_cnt) && (h_cnt < `H_REF+24*(3+1)) && (0 < v_cnt) && (v_cnt < 24*1))begin
                case(data[3][0])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=0, j=1
            else if((`H_REF < h_cnt) && (h_cnt < `H_REF+24*1) && (24*1 < v_cnt) && (v_cnt < 24*(1+1)))begin
                case(data[0][1])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=1, j=1
            else if((`H_REF+24*1 < h_cnt) && (h_cnt < `H_REF+24*(1+1)) && (24*1 < v_cnt) && (v_cnt < 24*(1+1)))begin
                case(data[1][1])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=2, j=1
            else if((`H_REF+24*2 < h_cnt) && (h_cnt < `H_REF+24*(2+1)) && (24*1 < v_cnt) && (v_cnt < 24*(1+1)))begin
                case(data[2][1])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=3, j=1
            else if((`H_REF+24*3 < h_cnt) && (h_cnt < `H_REF+24*(3+1)) && (24*1 < v_cnt) && (v_cnt < 24*(1+1)))begin
                case(data[3][1])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=0, j=2
            else if((`H_REF < h_cnt) && (h_cnt < `H_REF+24*1) && (24*2 <= v_cnt) && (v_cnt < 24*(2+1)))begin
                case(data[0][2])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=1, j=2
            else if((`H_REF+24*1 < h_cnt) && (h_cnt < `H_REF+24*(1+1)) && (24*2 <= v_cnt) && (v_cnt < 24*(2+1)))begin
                case(data[1][2])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=2, j=2
            else if((`H_REF+24*2 < h_cnt) && (h_cnt < `H_REF+24*(2+1)) && (24*2 <= v_cnt) && (v_cnt < 24*(2+1)))begin
                case(data[2][2])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=3, j=2
            else if((`H_REF+24*3 < h_cnt) && (h_cnt < `H_REF+24*(3+1)) && (24*2 <= v_cnt) && (v_cnt < 24*(2+1)))begin
                case(data[3][2])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=0, j=3
            else if((`H_REF < h_cnt) && (h_cnt < `H_REF+24*1) && (24*3 <= v_cnt) && (v_cnt < 24*(3+1)))begin
                case(data[0][3])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=1, j=3
            else if((`H_REF+24*1 < h_cnt) && (h_cnt < `H_REF+24*(1+1)) && (24*3 <= v_cnt) && (v_cnt < 24*(3+1)))begin
                case(data[1][3])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=2, j=3
            else if((`H_REF+24*2 < h_cnt) && (h_cnt < `H_REF+24*(2+1)) && (24*3 <= v_cnt) && (v_cnt < 24*(3+1)))begin
                case(data[2][3])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=3, j=3
            else if((`H_REF+24*3 < h_cnt) && (h_cnt < `H_REF+24*(3+1)) && (24*3 <= v_cnt) && (v_cnt < 24*(3+1)))begin
                case(data[3][3])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=0, j=4
            else if((`H_REF < h_cnt) && (h_cnt < `H_REF+24*1) && (24*4 <= v_cnt) && (v_cnt < 24*(4+1)))begin
                case(data[0][4])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=1, j=4
            else if((`H_REF+24*1 < h_cnt) && (h_cnt < `H_REF+24*(1+1)) && (24*4 <= v_cnt) && (v_cnt < 24*(4+1)))begin
                case(data[1][4])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=2, j=4
            else if((`H_REF+24*2 < h_cnt) && (h_cnt < `H_REF+24*(2+1)) && (24*4 <= v_cnt) && (v_cnt < 24*(4+1)))begin
                case(data[2][4])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=3, j=4
            else if((`H_REF+24*3 < h_cnt) && (h_cnt < `H_REF+24*(3+1)) && (24*4 <= v_cnt) && (v_cnt < 24*(4+1)))begin
                case(data[3][4])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=0, j=5
            else if((`H_REF < h_cnt) && (h_cnt < `H_REF+24*1) && (24*5 <= v_cnt) && (v_cnt < 24*(5+1)))begin
                case(data[0][5])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=1, j=5
            else if((`H_REF+24*1 < h_cnt) && (h_cnt < `H_REF+24*(1+1)) && (24*5 <= v_cnt) && (v_cnt < 24*(5+1)))begin
                case(data[1][5])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=2, j=5
            else if((`H_REF+24*2 < h_cnt) && (h_cnt < `H_REF+24*(2+1)) && (24*5 <= v_cnt) && (v_cnt < 24*(5+1)))begin
                case(data[2][5])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=3, j=5
            else if((`H_REF+24*3 < h_cnt) && (h_cnt < `H_REF+24*(3+1)) && (24*5 <= v_cnt) && (v_cnt < 24*(5+1)))begin
                case(data[3][5])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=0, j=6
            else if((`H_REF < h_cnt) && (h_cnt < `H_REF+24*1) && (24*6 <= v_cnt) && (v_cnt < 24*(6+1)))begin
                case(data[0][6])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=1, j=6
            else if((`H_REF+24*1 < h_cnt) && (h_cnt < `H_REF+24*(1+1)) && (24*6 <= v_cnt) && (v_cnt < 24*(6+1)))begin
                case(data[1][6])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=2, j=6
            else if((`H_REF+24*2 < h_cnt) && (h_cnt < `H_REF+24*(2+1)) && (24*6 <= v_cnt) && (v_cnt < 24*(6+1)))begin
                case(data[2][6])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=3, j=6
            else if((`H_REF+24*3 < h_cnt) && (h_cnt < `H_REF+24*(3+1)) && (24*6 <= v_cnt) && (v_cnt < 24*(6+1)))begin
                case(data[3][6])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=0, j=7
            else if((`H_REF < h_cnt) && (h_cnt < `H_REF+24*1) && (24*7 <= v_cnt) && (v_cnt < 24*(7+1)))begin
                case(data[0][7])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=1, j=7
            else if((`H_REF+24*1 < h_cnt) && (h_cnt < `H_REF+24*(1+1)) && (24*7 <= v_cnt) && (v_cnt < 24*(7+1)))begin
                case(data[1][7])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=2, j=7
            else if((`H_REF+24*2 < h_cnt) && (h_cnt < `H_REF+24*(2+1)) && (24*7 <= v_cnt) && (v_cnt < 24*(7+1)))begin
                case(data[2][7])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=3, j=7
            else if((`H_REF+24*3 < h_cnt) && (h_cnt < `H_REF+24*(3+1)) && (24*7 <= v_cnt) && (v_cnt < 24*(7+1)))begin
                case(data[3][7])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=0, j=8
            else if((`H_REF < h_cnt) && (h_cnt < `H_REF+24*1) && (24*8 <= v_cnt) && (v_cnt < 24*(8+1)))begin
                case(data[0][8])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=1, j=8
            else if((`H_REF+24*1 < h_cnt) && (h_cnt < `H_REF+24*(1+1)) && (24*8 <= v_cnt) && (v_cnt < 24*(8+1)))begin
                case(data[1][8])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=2, j=8
            else if((`H_REF+24*2 < h_cnt) && (h_cnt < `H_REF+24*(2+1)) && (24*8 <= v_cnt) && (v_cnt < 24*(8+1)))begin
                case(data[2][8])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=3, j=8
            else if((`H_REF+24*3 < h_cnt) && (h_cnt < `H_REF+24*(3+1)) && (24*8 <= v_cnt) && (v_cnt < 24*(8+1)))begin
                case(data[3][8])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=0, j=9
            else if((`H_REF < h_cnt) && (h_cnt < `H_REF+24*1) && (24*9 <= v_cnt) && (v_cnt < 24*(9+1)))begin
                case(data[0][9])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=1, j=9
            else if((`H_REF+24*1 < h_cnt) && (h_cnt < `H_REF+24*(1+1)) && (24*9 <= v_cnt) && (v_cnt < 24*(9+1)))begin
                case(data[1][9])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=2, j=9
            else if((`H_REF+24*2 < h_cnt) && (h_cnt < `H_REF+24*(2+1)) && (24*9 <= v_cnt) && (v_cnt < 24*(9+1)))begin
                case(data[2][9])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=3, j=9
            else if((`H_REF+24*3 < h_cnt) && (h_cnt < `H_REF+24*(3+1)) && (24*9 <= v_cnt) && (v_cnt < 24*(9+1)))begin
                case(data[3][9])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=0, j=10
            else if((`H_REF < h_cnt) && (h_cnt < `H_REF+24*1) && (10 <= v_cnt) && (v_cnt < 24*(10+1)))begin
                case(data[0][10])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=1, j=10
            else if((`H_REF+24*1 < h_cnt) && (h_cnt < `H_REF+24*(1+1)) && (10 <= v_cnt) && (v_cnt < 24*(10+1)))begin
                case(data[1][10])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=2, j=10
            else if((`H_REF+24*2 < h_cnt) && (h_cnt < `H_REF+24*(2+1)) && (0 <= v_cnt) && (v_cnt < 24*(10+1)))begin
                case(data[2][10])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=3, j=10
            else if((`H_REF+24*3 < h_cnt) && (h_cnt < `H_REF+24*(3+1)) && (0 <= v_cnt) && (v_cnt < 24*(10+1)))begin
                case(data[3][10])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=0, j=11
            else if((`H_REF < h_cnt) && (h_cnt < `H_REF+24*1) && (24*11 <= v_cnt) && (v_cnt < 24*(11+1)))begin
                case(data[0][11])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=1, j=11
            else if((`H_REF+24*1 < h_cnt) && (h_cnt < `H_REF+24*(1+1)) && (24*11 <= v_cnt) && (v_cnt < 24*(11+1)))begin
                case(data[1][11])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=2, j=11
            else if((`H_REF+24*2 < h_cnt) && (h_cnt < `H_REF+24*(2+1)) && (24*11 <= v_cnt) && (v_cnt < 24*(11+1)))begin
                case(data[2][11])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=3, j=11
            else if((`H_REF+24*3 < h_cnt) && (h_cnt < `H_REF+24*(3+1)) && (24*11 <= v_cnt) && (v_cnt < 24*(11+1)))begin
                case(data[3][11])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=0, j=12
            else if((`H_REF < h_cnt) && (h_cnt < `H_REF+24*1) && (24*12 <= v_cnt) && (v_cnt < 24*(12+1)))begin
                case(data[0][12])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=1, j=12
            else if((`H_REF+24*1 < h_cnt) && (h_cnt < `H_REF+24*(1+1)) && (24*12 <= v_cnt) && (v_cnt < 24*(12+1)))begin
                case(data[1][12])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=2, j=12
            else if((`H_REF+24*2 < h_cnt) && (h_cnt < `H_REF+24*(2+1)) && (24*12 <= v_cnt) && (v_cnt < 24*(12+1)))begin
                case(data[2][12])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=3, j=12
            else if((`H_REF+24*3 < h_cnt) && (h_cnt < `H_REF+24*(3+1)) && (24*12 <= v_cnt) && (v_cnt < 24*(12+1)))begin
                case(data[3][12])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=0, j=13
            else if((`H_REF < h_cnt) && (h_cnt < `H_REF+24*1) && (24*13 <= v_cnt) && (v_cnt < 24*(13+1)))begin
                case(data[0][13])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=1, j=13
            else if((`H_REF+24*1 < h_cnt) && (h_cnt < `H_REF+24*(1+1)) && (24*13 <= v_cnt) && (v_cnt < 24*(13+1)))begin
                case(data[1][13])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=2, j=13
            else if((`H_REF+24*2 < h_cnt) && (h_cnt < `H_REF+24*(2+1)) && (24*13 <= v_cnt) && (v_cnt < 24*(13+1)))begin
                case(data[2][13])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=3, j=13
            else if((`H_REF+24*3 < h_cnt) && (h_cnt < `H_REF+24*(3+1)) && (24*13 <= v_cnt) && (v_cnt < 24*(13+1)))begin
                case(data[3][13])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=0, j=14
            else if((`H_REF < h_cnt) && (h_cnt < `H_REF+24*1) && (24*14 <= v_cnt) && (v_cnt < 24*(14+1)))begin
                case(data[0][14])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=1, j=14
            else if((`H_REF+24*1 < h_cnt) && (h_cnt < `H_REF+24*(1+1)) && (24*14 <= v_cnt) && (v_cnt < 24*(14+1)))begin
                case(data[1][14])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=2, j=14
            else if((`H_REF+24*2 < h_cnt) && (h_cnt < `H_REF+24*(2+1)) && (24*14 <= v_cnt) && (v_cnt < 24*(14+1)))begin
                case(data[2][14])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=3, j=14
            else if((`H_REF+24*3 < h_cnt) && (h_cnt < `H_REF+24*(3+1)) && (24*14 <= v_cnt) && (v_cnt < 24*(14+1)))begin
                case(data[3][14])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=0, j=15
            else if((`H_REF < h_cnt) && (h_cnt < `H_REF+24*1) && (24*15 <= v_cnt) && (v_cnt < 24*(15+1)))begin
                case(data[0][15])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=1, j=15
            else if((`H_REF+24*1 < h_cnt) && (h_cnt < `H_REF+24*(1+1)) && (24*15 <= v_cnt) && (v_cnt < 24*(15+1)))begin
                case(data[1][15])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=2, j=15
            else if((`H_REF+24*2 < h_cnt) && (h_cnt < `H_REF+24*(2+1)) && (24*15 <= v_cnt) && (v_cnt < 24*(15+1)))begin
                case(data[2][15])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=3, j=15
            else if((`H_REF+24*3 < h_cnt) && (h_cnt < `H_REF+24*(3+1)) && (24*15 <= v_cnt) && (v_cnt < 24*(15+1)))begin
                case(data[3][15])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=0, j=16
            else if((`H_REF < h_cnt) && (h_cnt < `H_REF+24*1) && (24*16 <= v_cnt) && (v_cnt < 24*(16+1)))begin
                case(data[0][16])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=1, j=6
            else if((`H_REF+24*1 < h_cnt) && (h_cnt < `H_REF+24*(1+1)) && (24*16 <= v_cnt) && (v_cnt < 24*(16+1)))begin
                case(data[1][16])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=2, j=6
            else if((`H_REF+24*2 < h_cnt) && (h_cnt < `H_REF+24*(2+1)) && (24*16 <= v_cnt) && (v_cnt < 24*(16+1)))begin
                case(data[2][16])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=3, j=16
            else if((`H_REF+24*3 < h_cnt) && (h_cnt < `H_REF+24*(3+1)) && (24*16 <= v_cnt) && (v_cnt < 24*(16+1)))begin
                case(data[3][16])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=0, j=17
            else if((`H_REF < h_cnt) && (h_cnt < `H_REF+24*1) && (24*17 <= v_cnt) && (v_cnt < 24*(17+1)))begin
                case(data[0][17])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=1, j=17
            else if((`H_REF+24*1 < h_cnt) && (h_cnt < `H_REF+24*(1+1)) && (24*17 <= v_cnt) && (v_cnt < 24*(17+1)))begin
                case(data[1][17])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=2, j=17
            else if((`H_REF+24*2 < h_cnt) && (h_cnt < `H_REF+24*(2+1)) && (24*17 <= v_cnt) && (v_cnt < 24*(17+1)))begin
                case(data[2][17])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=3, j=17
            else if((`H_REF+24*3 < h_cnt) && (h_cnt < `H_REF+24*(3+1)) && (24*17 <= v_cnt) && (v_cnt < 24*(17+1)))begin
                case(data[3][17])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=0, j=18
            else if((`H_REF < h_cnt) && (h_cnt < `H_REF+24*1) && (24*18 <= v_cnt) && (v_cnt < 24*(18+1)))begin
                case(data[0][18])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=1, j=18
            else if((`H_REF+24*1 < h_cnt) && (h_cnt < `H_REF+24*(1+1)) && (24*18 <= v_cnt) && (v_cnt < 24*(18+1)))begin
                case(data[1][18])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=2, j=18
            else if((`H_REF+24*2 < h_cnt) && (h_cnt < `H_REF+24*(2+1)) && (24*18 <= v_cnt) && (v_cnt < 24*(18+1)))begin
                case(data[2][18])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=3, j=18
            else if((`H_REF+24*3 < h_cnt) && (h_cnt < `H_REF+24*(3+1)) && (24*18 <= v_cnt) && (v_cnt < 24*(18+1)))begin
                case(data[3][18])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=0, j=19
            else if((`H_REF < h_cnt) && (h_cnt < `H_REF+24*1) && (24*19 <= v_cnt) && (v_cnt < 24*(19+1)))begin
                case(data[0][19])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=1, j=19
            else if((`H_REF+24*1 < h_cnt) && (h_cnt < `H_REF+24*(1+1)) && (24*19 <= v_cnt) && (v_cnt < 24*(19+1)))begin
                case(data[1][19])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*1)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=2, j=19
            else if((`H_REF+24*2 < h_cnt) && (h_cnt < `H_REF+24*(2+1)) && (24*19 <= v_cnt) && (v_cnt < 24*(19+1)))begin
                case(data[2][19])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*2)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            //i=3, j=19
            else if((`H_REF+24*3 < h_cnt) && (h_cnt < `H_REF+24*(3+1)) && (24*19 <= v_cnt) && (v_cnt < 24*(19+1)))begin
                case(data[3][19])
                    0: pixel_addr = 0;  //gray
                    1: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 24; //24~47
                    2: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 48; //48~71
                    3: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 72; //72~95
                    4: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 96; //96~119
                    5: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 120; //120~143
                    6: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 144; //144~167
                    7: pixel_addr = (h_cnt-(`H_REF+24*3)) + 192*(v_cnt%24) + 168; //168~191
                endcase
            end
            else begin
                pixel_addr = 0;
            end
        end
    end
end
    
endmodule