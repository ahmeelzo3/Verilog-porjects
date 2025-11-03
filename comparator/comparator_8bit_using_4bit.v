`timescale 1ns / 1ps


module comparator_8bit_using_4bit(
        input [7:0] a , b ,
        input en ,
        output e , l , g  
    );
    wire out_e , out_g , out_l ;
    comparator_4bit comparator_0 (.en(en) ,.a(a[3:0]) , .b(b[3:0]) ,.in_g(1'b0) , .in_l(1'b0)
                                  ,.in_e(1'b1) , .e(out_e) , .l(out_l) ,.g(out_g) ) ;
                    
    comparator_4bit comparator_1 (.en(en) ,.a(a[7:4]) , .b(b[7:4]) ,.in_g(out_g) , .in_l(out_l)
                                  ,.in_e(out_e) , .e(e) , .l(l) ,.g(g) ) ;
    
endmodule
