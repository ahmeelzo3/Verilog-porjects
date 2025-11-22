`timescale 1ns / 1ps

module trafic_light_controller(
        input clk , res_n , s_a , s_b ,
        output [5:0]t ,
        output Ga , Ra , Ya , Gb , Yb , Rb
    );
    wire t_done ;
    wire [5:0]t_max ;
    fsm_controller d1 (.s_a(s_a) ,.s_b(s_b) , .clk(clk) ,
                       .res_n(res_n) , .timer_done(t_done)
                       ,.t_max(t_max) , .Ga(Ga) , .Gb(Gb) ,
                       .Ra(Ra) , .Rb(Rb) , .Ya(Ya) , .Yb(Yb) 
                      ) ;
    timer_nbit#(.n(6)) d2 (.clk(clk) ,.res_n(res_n) ,
                           .t_max(t_max) , .en(1'b1) ,
                           .timer_done(t_done) ,.t(t) );
endmodule
