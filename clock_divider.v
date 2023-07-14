`timescale 1ns / 1ps

module clock_divider(
     input  clk_in,
     output reg clk_out,
     input  reset,
     input  [31:0] ratio
     );
     
     reg [31:0] count;

     initial begin
        clk_out = 0;
        count = 0;
     end  
     
    
     always@(posedge clk_in, posedge reset) begin 
        if(reset == 1) begin
            clk_out = 0;
            count = 0;        
        end else if(count == (ratio/2)-1)begin
            clk_out = ~clk_out;  
            count = 0;
        end else count = count + 1;
     end

endmodule
