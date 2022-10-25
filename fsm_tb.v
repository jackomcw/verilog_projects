`timescale 1ns/1ps
`include "fsm.v" 

module tb_fsm;
    
    reg [0:27] fsm_in, fsm_out;
    reg in;
    reg [4:0] i;
    wire gnt;

    fsm state_machine(in, gnt);

    initial begin
        $dumpfile("fsm_tb.vcd");
        $dumpvars; 
        i = 0;
        fsm_in   = 28'b0100110010100101011011011011;
        fsm_out  = {29{1'b1}};
        //output should be: 1000011100000110001100010001
    end
    
    always @(posedge state_machine.clk) begin
        in <= fsm_in[i];
        #2; //for in to propogate through fsm
        fsm_out[i] <= gnt;
        #1; //so display of fsm_out[i] is correct

        $display ("Input: %0b   Output: %0b", in, fsm_out[i]); 
        $display ("State: %0d   Next:   %0d", state_machine.state, state_machine.next);
        i++;
        if (i==28) #10 begin 
            $display ("Input:           -%0b", fsm_in); 
            $display ("Output:          %0b", fsm_out);
            $display ("Desired output:  %0b", 28'b1000011100000110001100010001);
            $finish;
        end
    end
endmodule