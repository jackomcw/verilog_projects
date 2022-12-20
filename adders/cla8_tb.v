`include "cla8.v"

module cla_adder_8bits_tb();
    parameter N_BIT = 8;

    reg [N_BIT-1:0] input1 = 0;
    reg [N_BIT-1:0] input2 = 0;
    reg c_in = 0;
    wire [N_BIT-1:0] w_sum;
    wire c_out;

    cla_adder_8bits #(.N_BIT(N_BIT)) cla_tb
        (
            .x(input1),
            .y(input2),
            .cin(c_in),
            .sum(w_sum),
            .cout(c_out)
        );

    initial
        begin
            $dumpfile("cla8_tb.vcd");
            $dumpvars; 
            #10;
            input1 = 8'b00000100; //4
            input2 = 8'b00000001; //1
            c_in = 0;
            #10;
            $display ("Input 1: %8b | Input 2: %8b | Output: %8b | Carry out: %0b", input1, input2, w_sum, c_out); 

            #10;                     //5 = 000000101
            input1 = 8'b01000100; //68
            input2 = 8'b00101001; //41
            c_in = 1;
            #10;
            $display ("Input 1: %8b | Input 2: %8b | Output: %8b | Carry out: %0b", input1, input2, w_sum, c_out); 

            #10;                     //109 = 01101101
            input1 = 8'b01001010; //74
            input2 = 8'b11110000; //240
            c_in = 0;
            #10;
            $display ("Input 1: %8b | Input 2: %8b | Output: %8b | Carry out: %0b", input1, input2, w_sum, c_out); 
                                    //314 = 1 00111010
        end

endmodule