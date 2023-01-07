`timescale 1ns/1ps
`include "barrelShifter.v"

module barrelShifter_tb();
    reg [7:0] in;
    reg [2:0] shift;
    wire [7:0] out;

    reg [7:0] in_ [2:0];
    reg [2:0] shift_ [2:0];
    reg [1:0] j, k;

    barrelShifter shifter(in, shift, out);

    initial begin
        in_[0] = 8'b00000001;
        in_[1] = 8'b10101010;
        in_[2] = 8'b11111000;
        shift_[0] = 3'b001;
        shift_[1] = 3'b100;
        shift_[2] = 3'b111;

        for (j=0; j<3;j++) begin
            in = in_[j];
            for (k=0; k<3; k++) begin
                shift = shift_[k];
                #10
                $display("In: %8b | Shift: %8b | Out: %8b", in, shift, out);
            end
        end
    end 

endmodule