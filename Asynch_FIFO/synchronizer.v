`timescale 1ns / 1ps

module synchronizer#(parameter WIDTH = 4)(
    input clk , reset_n ,
    input [WIDTH:0] data_in ,
    output reg [WIDTH:0] data_out
  );
  reg [WIDTH:0] q1 ;
  always @(posedge clk or negedge reset_n)
    if(!reset_n)
    begin
      q1<= 0;
      data_out<= 0;
    end
    else
    begin
      data_out <= q1 ;
      q1<= data_in;
    end

endmodule
