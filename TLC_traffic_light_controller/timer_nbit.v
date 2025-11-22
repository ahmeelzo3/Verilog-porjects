`timescale 1ns / 1ps

// Parameterizable N-bit timer/counter module
// - Counts up when `en` is asserted. When the counter reaches `t_max`,
//   `timer_done` becomes high. The counter wraps to zero on the next increment
//   after reaching or exceeding `t_max`.

module timer_nbit #(parameter n = 6)(
    input clk , res_n ,en ,
    input [n-1:0]t_max ,
    output [n-1:0]t ,
    output timer_done
    );
    // Register for current count and next count value
    reg [n-1:0]Q_next , Q_reg ;

// Combinational next-state logic for the counter
always @(*) begin
    Q_next = Q_reg ; 
    if (en) begin
        // If current count reached or exceeded t_max, wrap to 0
        if ((Q_reg >= t_max)) Q_next = 'b0 ;
        else Q_next = Q_reg + 1'b1 ;
    end
    else Q_next = Q_reg ;
end
    
// Sequential register update: synchronous with clock, asynchronous reset (active-low)
always@(posedge clk , negedge res_n) begin
    if (~res_n) Q_reg <= 0 ;
    else Q_reg <= Q_next ;
end
    
    // Expose current count and done signal
    assign t = Q_reg ;
    assign timer_done = (t == t_max) ;
endmodule
