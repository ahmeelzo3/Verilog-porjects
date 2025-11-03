`timescale 1ns / 1ps
module ass_two_1_tb();
    wire out , out_bar ;
    reg A ,B , C , sel ;
    reg [2:0]D;
    ass_two_1 dut (.A(A) , .B(B) , .C(C) , .sel(sel), .D(D) ,.out(out) ,.out_bar(out_bar)) ; 
    //stop watch 
    initial begin
    #40 $finish ; //stop after 40 ns
    end
    initial begin
    sel = 1'b0 ; 
    {A , B , C , D} = 6'b000000 ;
    #5;
    sel = 1'b1 ;
    {A , B , C , D} = 6'b110011 ;
    #5 ;
    sel = 1'b0 ;
    {A , B , C , D} = 6'b110101 ;
    #5 ;
    sel = 1'b1 ;
    {A , B , C , D} = 6'b011110 ;
    #5 ;
    sel = 1'b1 ;
    {A , B , C , D} = 6'b001111 ;
    #5 ;
    sel = 1'b1 ;
    {A , B , C , D} = 6'b101011 ;
    #5 ;
    sel = 1'b1 ;
    {A , B , C , D} = 6'b000011 ;
    end
endmodule
