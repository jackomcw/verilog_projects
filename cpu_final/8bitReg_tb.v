`timescale 1ns/1ps
`include "8bitReg.v"

// module clock(input enable, output reg clk); 
//     reg not_clk;
    
//     initial begin 
//         $display("here");
//         forever #5 clk = not_clk;
//         not_clk = ~clk;
//         $display("%1b", clk);
//     end
// endmodule

module registerFile_tb();
    reg write, reset;
    reg [2:0] w_addr, r_addr1, r_addr2;
    reg [7:0] in;
    wire [7:0] out1, out2;
    reg clk;

    registerFile reg_test(in, out1, out2, w_addr, r_addr1, r_addr2, write, clk, reset);
    
    initial begin
        $monitor(clk);
        w_addr = 3'b010;
        r_addr1 = 3'b010;
        reset = 1;
        reset = 0;
        clk = 0;
        #5 clk = 1;
        write = 1;
        in = 8'b00001111;
        #5 clk = 0;
        $display("writing %d to R%d", in, w_addr);
        #5 write = 0;
        clk = 1;
        #5 $display ("Address %d contains %d", r_addr1, out1);
        $display(reg_test.regFile[2]);
    end

endmodule