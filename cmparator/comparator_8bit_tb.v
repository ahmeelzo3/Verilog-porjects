`timescale 1ns / 1ps

module comparator_8bit_tb();
//Declare local wires and registers
reg [7:0]a , b ;
reg en ;
wire l , e , g ;

//instantiat the moudule under test
comparator_8bit_usin_4bit dut (.en(en) ,.a(a[7:0]) , .b(b[7:0]) ,.l(l) , .g(g) ,.e(e) ) ;

//stop watch 
initial begin
#40 $finish ; //stop after 40 ns
end

//generate stimuli using intial or always
initial begin
en = 1'b0 ;
a = 8'b1000_0000 ;
b = 8'b0111_1111 ;
#5 ;
en = 1'b1 ;
a = 8'b1111_0000 ;
b = 8'b1111_1111 ;
#5 ;
a = 8'b1111_1111 ;
b = 8'b1111_1111 ;
#5
a = 8'b1111_1111 ;
b = 8'b0111_1101 ;
#5
a = 8'b1111_0000 ;
b = 8'b0101_1111 ;
end
endmodule





