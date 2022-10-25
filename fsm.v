`timescale 1ns/1ps
`include "../clk_gen.v"

module fsm(input in, output reg gnt);

    parameter [1:0] state0 = 2'b00,
                    state1 = 2'b01,
                    state2 = 2'b10;

    reg enable, rst;
    reg [1:0] state, next;
    wire clk;

    clock_gen clock(enable, clk);

    initial begin
        rst = 1;
        next = state2;
        #1 enable = 1; //clk doesn't work without delay
    end
            
    always @(posedge clk or negedge rst) begin
        if (!rst) state <= state2;
        else state <= next;
    end

    always @(*) begin
        next <= 2'bx;
        case (state)
            state0: if (in)     next <= state1;
                    else        next <= state0;
            state1: if (in)     next <= state2;
                    else        next <= state1;
            state2: begin
                    //gnt <= 1'b1;
                    if (in)     next <= state0;
                    else        next <= state2;
            end
            default: next <= 2'bx;
        endcase
    end

    always @(*) begin
        case(next) 
            state2: gnt <= 1'b1;
            default: gnt <= 1'b0;
        endcase
    end

endmodule